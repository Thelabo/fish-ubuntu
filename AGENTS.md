# AGENTS.md

Operational guide for agentic coding assistants working in `fish-ubuntu`.

## 1) Repository Purpose

- Portable Fish shell setup for Ubuntu.
- Primary automation is Ansible (`ansible/site.yml`).
- Dotfiles are linked with GNU Stow.
- Security model uses pinned refs, checksums, and scoped apt trust.

## 2) Rules Files Status

- `.cursor/rules/`: not present.
- `.cursorrules`: not present.
- `.github/copilot-instructions.md`: not present.
- If added later, treat them as higher-priority local policy.

## 3) Canonical Entry Points

- Main playbook: `ansible/site.yml`
- Inventory: `ansible/inventory.ini`
- Ansible config: `ansible.cfg` (defaults inventory path)
- Core vars: `ansible/vars/packages.yml`

## 4) Build / Lint / Test Commands

No traditional build system or unit-test framework exists.
Validation is Ansible syntax + targeted playbook runs.

### 4.1 Full validation

```bash
ansible-playbook ansible/site.yml -i ansible/inventory.ini --syntax-check
```

### 4.2 Full provisioning run

```bash
ansible-playbook ansible/site.yml -i ansible/inventory.ini --ask-become-pass
```

### 4.3 Single-feature run (closest equivalent to single test)

```bash
ansible-playbook ansible/site.yml -i ansible/inventory.ini -e install_done_fish=true --ask-become-pass
```

Other targeted runs:

- `-e stow_dotfiles=false`
- `-e set_fish_default_shell=false`
- `-e install_fastfetch_from_ppa=true`
- `-e latest_tools_enabled=false`

### 4.4 Single-path stow run (manual)

```bash
stow --dir <repo-root> --target "$HOME" --restow .config
```

### 4.5 Manual single-plugin operations (Fish)

```bash
fish -c "fisher install pure-fish/pure@<ref>"
fish -c "fisher install jorgebucaran/autopair.fish@<ref>"
fish -c "fisher install franciscolourenco/done@<ref>"
```

### 4.6 Useful diagnostics

```bash
ansible-inventory -i ansible/inventory.ini --list
git status --short
git diff
```

## 5) Execution Order (from `ansible/site.yml`)

1. `tasks/fish-ppa.yml`
2. `tasks/packages.yml`
3. `tasks/stow.yml`
4. `tasks/default-shell.yml`
5. `tasks/latest-tools.yml`
6. `tasks/mise.yml`
7. `tasks/fisher.yml`
8. `tasks/done.yml`

When debugging, verify upstream dependency order before edits.

## 6) Code Style — Ansible

### 6.1 Module usage

- Use fully qualified modules: `ansible.builtin.*`.
- Prefer `ansible.builtin.command` over `shell` unless shell features are required.
- Keep privilege explicit (`become: true/false`) where it matters.

### 6.2 Variables and naming

- Use `snake_case` names only.
- Keep toggles boolean and descriptive.
- Keep versions/refs/checksums in `ansible/vars/packages.yml`.

### 6.3 Security conventions

- Use `get_url` + `checksum: "sha256:..."` for remote artifacts and keys.
- Prefer immutable refs (commit SHAs) over mutable tags/branches.
- Use `/etc/apt/keyrings` + `signed-by=` for apt repositories.
- Avoid plaintext HTTP and avoid `state: latest` in security-sensitive flows.

### 6.4 Idempotency conventions

- Use `state: present` for apt installs.
- Use `creates:` on command tasks that produce stable outputs.
- Use `changed_when: false` only for checks or intentional no-change reporting.
- Use `assert` with clear `fail_msg` for path/input validation.

### 6.5 Conditionals and guards

- Gate optional behavior with `when:` and explicit toggles.
- Use `default(...)` on toggles when defensive defaults are needed.
- For discovery checks (`which`, version probes), use `register` and explicit conditions.

## 7) Code Style — Fish Scripts

- Guard optional tools with `if command -q <tool>`.
- Keep bootstrap in `config.fish`; feature blocks in `conf.d/*.fish`.
- Use `command` / `builtin` when disambiguation is intentional.
- Keep aliases portable with fallback behavior.
- Reserve `__` prefix for internal helper functions.

## 8) Formatting and Documentation

- Match existing YAML indentation and quoting style.
- Keep task names specific and imperative.
- Keep README behavior descriptions aligned with actual defaults.
- Document only implemented behavior.

## 9) Git and Change Discipline

- Make focused, atomic commits.
- Prefer semantic commit prefixes (`feat(...)`, `fix(...)`).
- Never commit secrets or local machine artifacts.
- Run syntax-check before commit.

## 10) Agent Workflow Checklist

Before edits:

1. Read `ansible/site.yml` and relevant task files.
2. Confirm toggle/variable names in `ansible/vars/packages.yml`.
3. Check README sections impacted by your change.

After edits:

1. Run `ansible-playbook ... --syntax-check`.
2. Re-check for mutable refs and missing checksums.
3. Ensure docs/defaults still match code.
4. Confirm `git diff` is minimal and intentional.

## 11) Known Non-Goals

- No JS/Python unit test suite exists here.
- No Makefile build pipeline exists here.
- No CI workflow files currently define lint/test gates.

Treat Ansible syntax-check + targeted playbook runs as required validation.
