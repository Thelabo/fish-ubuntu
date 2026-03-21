# fish-ubuntu

Portable Fish setup for Ubuntu, extracted from a CachyOS environment and made distro-safe.

This repo is structured to keep `config.fish` minimal and place feature blocks under `conf.d/`:

- `config.fish`: shell bootstrap, PATH, bindings, mise activation, SSH agent socket
- `conf.d/aliases.fish`: command aliases
- `conf.d/bob.fish`: Bob Neovim PATH hook
- `conf.d/rustup.fish`: Cargo PATH hook
- `conf.d/done-settings.fish`: `done.fish` plugin variables

## Goals

- Keep the same interactive feel as your current shell
- Avoid CachyOS-only files
- Prefer latest upstream versions for tooling where Ubuntu LTS is often behind

## Quick Install (manual)

```bash
sudo apt update
sudo apt install -y software-properties-common curl git fish
sudo add-apt-repository -y ppa:fish-shell/release-4
sudo apt update
sudo apt install -y fish

git clone https://github.com/youruser/fish-ubuntu.git ~/git/fish-ubuntu
mkdir -p ~/.config/fish
ln -sf ~/git/fish-ubuntu/.config/fish/config.fish ~/.config/fish/config.fish
ln -sfn ~/git/fish-ubuntu/.config/fish/conf.d ~/.config/fish/conf.d

chsh -s "$(which fish)"
```

## Latest toolchain installs (recommended)

To avoid stale LTS package versions:

- `eza`: install from upstream apt repo (`deb.gierens.de`)
- `fastfetch`: install from upstream-author PPA (`ppa:zhangsongcui3371/fastfetch`)
- `bat`: install latest `.deb` from GitHub releases
- `mise`: install via official installer (`https://mise.jdx.dev/install.sh`)

These are automated in the Ansible playbook.

## Fish plugins

Plugins are installed through Fisher by the playbook:

- `pure-fish/pure` (prompt)
- `jorgebucaran/autopair.fish`
- optional: `franciscolourenco/done`

## Ansible Bootstrap

```bash
sudo apt install -y ansible
ansible-playbook ansible/site.yml --ask-become-pass
```

Optional done.fish:

```bash
ansible-playbook ansible/site.yml -e install_done_fish=true --ask-become-pass
```

Optional toggles (defaults shown):

- `latest_tools_enabled=true`
- `install_fish_pure=true`
- `install_fish_autopair=true`
- `install_done_fish=false`
