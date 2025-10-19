#!/usr/bin/env bash
set -euo pipefail

BASE="${1:-origin/main}"   # compare base (default origin/main)
HEAD="${2:-HEAD}"          # compare head (default HEAD)
OUT="${3:-/tmp/pr_body.md}"

changed_files=$(git diff --name-only "$BASE...$HEAD" | sed 's/^/- /')
changed_website=$(git diff --name-only "$BASE...$HEAD" -- 'website/**' | sed 's/^/- /' || true)
changed_tf=$(git diff --name-only "$BASE...$HEAD" -- 'terraform/**' | sed 's/^/- /' || true)

# Short diffstat
diffstat=$(git diff --stat "$BASE...$HEAD" | tail -n1)

# Optional: capture a short terraform plan if terraform files changed
tf_summary=""
if [[ -n "$changed_tf" ]]; then
  if command -v terraform >/dev/null 2>&1; then
    tf_plan=$( (cd terraform && terraform init -upgrade -lock=false >/dev/null 2>&1 || true
                terraform validate 2>&1 || true
                terraform plan -no-color -compact-warnings 2>&1 || true) )
    # keep only the interesting tail (last 120 lines) to avoid huge PR bodies
    tf_summary="$(echo "$tf_plan" | tail -n 120)"
  fi
fi

cat > "$OUT" <<'MD'
## Summary
<!-- What & why. Agent: write 2–4 sentences summarizing the intent and user impact. -->

## Changes
MD

# High-level bullets
echo "" >> "$OUT"
echo "- Code changes summarized by agent based on diff." >> "$OUT"

# Show grouped files
{
  echo ""
  echo "### Files changed ($diffstat)"
  echo "$changed_files"
  echo ""
  if [[ -n "$changed_website" ]]; then
    echo "### Website"
    echo "$changed_website"
    echo ""
  fi
  if [[ -n "$changed_tf" ]]; then
    echo "### Terraform"
    echo "$changed_tf"
    echo ""
  fi
} >> "$OUT"

# Terraform plan excerpt
if [[ -n "$tf_summary" ]]; then
  {
    echo "## Terraform Plan (excerpt)"
    echo ""
    echo '```text'
    echo "$tf_summary"
    echo '```'
    echo ""
  } >> "$OUT"
fi

# Standard sections
cat >> "$OUT" <<'MD'
## Testing
- Local preview: `python3 -m http.server 8000 --directory website` → verify layout & a11y
- Cross-browser check: Chrome, Firefox, mobile viewport

## Risk & Rollback
- Risk: {low|medium|high} — Agent: justify briefly
- Rollback: `git revert` of the merge commit; no stateful DB changes

## Checklist
- [ ] No secrets or `terraform.tfstate*` committed
- [ ] `terraform validate` clean (if infra changed)
- [ ] Updated docs if user-facing behavior changed
MD

echo "$OUT"
