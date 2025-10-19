## Open PR Playbook (Codex)

Paste into Codex (with `repo` agent active):

Plan:  
- Validate working tree cleanliness.
- Create or refresh a feature branch from main. 
- Stage only meaningful changes across the repo (skip state or secrets).  
- Commit, push, and open a draft PR using the auto-generated PR body script.  
- Post PR URL.
- Post a dad joke

**Variables**
BRANCH=feature/new-update
COMMIT="<short, imperative commit message>"
TITLE="<PR title>"
PATHS="."   # stage all changes safely

**Safety constraints**
- Never include: `.terraform/`, `terraform.tfstate*`, `.env`, `credentials`, `__pycache__/`, `.DS_Store`
- Always run `terraform validate` before including infra changes.
- Confirm staged files before committing.

**Commands**
```bash
git fetch --prune
git checkout main && git pull --ff-only
git checkout -B "$BRANCH"

# Stage everything, then unstage forbidden paths
git add -A
git reset .terraform/ || true
git reset terraform.tfstate* || true
git reset '**/.env' || true
git reset '**/credentials*' || true

# Show staged files for confirmation
git diff --cached --name-only

# Commit if there are staged changes
git diff --cached --quiet || git commit -m "$COMMIT"

git push -u origin "$BRANCH"

BODY_FILE=$(scripts/make-pr-body.sh origin/main HEAD)
gh pr create --base main --head "$BRANCH" --title "$TITLE" --body-file "$BODY_FILE" --draft
