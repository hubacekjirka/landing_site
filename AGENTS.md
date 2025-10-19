# Codex Agents Configuration

## 🧱 Terraform Agent
- name: sre
  mode: agent
  description: >
    Manages infrastructure — creates and updates AWS S3 website via Terraform.
  permissions:
    - read: all
    - write: terraform/**
    - execute: terraform
  env:
    - AWS_REGION=eu-central-1
  notes: >
    Use this agent for running and editing Terraform files safely.

---

## 🎨 Frontend Agent
- name: ui
  mode: agent
  description: >
    Focused on website content and design (HTML, CSS, and assets).
  permissions:
    - read: all
    - write: ["website/**/*.html", "website/**/*.css", "website/assets/**"]
  env:
    - NODE_ENV=development
  startup_commands:
    - echo "Ready to edit and preview static site."
  notes: >
    Use this agent for editing or refactoring frontend files only.
