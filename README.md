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

- `eza`: install from upstream apt repo (`deb.gierens.de`) with scoped apt key (`signed-by`)
- `fastfetch`: optional upstream-author PPA (`ppa:zhangsongcui3371/fastfetch`), disabled by default for stricter trust
- `bat`: install pinned `.deb` from GitHub releases with SHA256 verification
- `mise`: install from official signed apt repository (`https://mise.jdx.dev/deb`)

These are automated in the Ansible playbook.

## Dotfiles linking with GNU Stow

The playbook installs `stow` and, by default, applies links from this repo to your home directory:

```bash
stow --dir <repo-root> --target "$HOME" --restow .config
```

This keeps `~/.config/fish` sourced from the repo structure while remaining easy to re-apply.

## Fish plugins

Plugins are installed through Fisher by the playbook:

- `pure-fish/pure` (prompt)
- `jorgebucaran/autopair.fish`
- optional: `franciscolourenco/done`

The playbook pins Fisher bootstrap and plugin refs to immutable commit SHAs for reproducible installs.

## Ansible Bootstrap

```bash
sudo apt install -y ansible
ansible-playbook ansible/site.yml -i ansible/inventory.ini --ask-become-pass
```

Optional done.fish:

```bash
ansible-playbook ansible/site.yml -i ansible/inventory.ini -e install_done_fish=true --ask-become-pass
```

Optional toggles (defaults shown):

- `latest_tools_enabled=true`
- `install_fastfetch_from_ppa=false`
- `stow_dotfiles=true`
- `install_fish_pure=true`
- `install_fish_autopair=true`
- `install_done_fish=false`
