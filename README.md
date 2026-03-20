# fish-ubuntu

Ubuntu-native Fish shell configuration, derived and cleaned from a CachyOS setup. This repository provides a modern, high-performance Fish environment tailored for Ubuntu LTS (24.04+).

It features smart defaults, syntax highlighting, auto-suggestions, and integration with modern CLI tools, all while remaining safe to use on systems without those tools installed.

## Prerequisites

- **OS**: Ubuntu 24.04 LTS or compatible.
- **Fish Shell 4.x**: Ubuntu's default repositories provide Fish 3.7.x. Fish 4.0+ is required for this configuration.
- **Git**: Required to clone this repository.

### Installing Fish 4.x on Ubuntu

Add the official Fish shell PPA to get the latest version:

```bash
sudo add-apt-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish
```

## Installation

This configuration is designed to be manually symlinked into your home directory.

1. Clone the repository:
   ```bash
   git clone https://github.com/youruser/fish-ubuntu.git ~/git/fish-ubuntu
   ```

2. Create the configuration directory:
   ```bash
   mkdir -p ~/.config/fish
   ```

3. Symlink the configuration files:
   ```bash
   ln -s ~/git/fish-ubuntu/.config/fish/config.fish ~/.config/fish/config.fish
   ln -s ~/git/fish-ubuntu/.config/fish/conf.d ~/.config/fish/conf.d
   ```

Note: If you have existing configuration files, back them up before creating the symlinks.

## Fish Config Overview

The configuration includes several enhancements for a better shell experience:

- **Greeting**: Displays system information using `fastfetch` if available.
- **Pager**: Sets `MANPAGER` to `batcat` for syntax-highlighted manual pages.
- **History Helpers**: Includes custom `!!` (repeat last command) and `!$` (last argument of last command) bindings.
- **Path**: Automatically adds `~/.local/bin` and `/usr/local/bin` to your `PATH`.
- **Tool Activations**: Automatically activates `mise` if it is installed.
- **SSH Agent**: Configures `SSH_AUTH_SOCK` for persistent SSH agent sessions.

All external tool calls are guarded by command checks, ensuring the shell remains functional even if specific tools are missing.

## Optional Tools

To get the most out of this configuration, we recommend installing the following tools:

- **eza**: A modern replacement for `ls`.
  ```bash
  sudo apt install eza
  ```
- **batcat**: A `cat` clone with syntax highlighting.
  ```bash
  sudo apt install bat
  ```
  *Note: On Ubuntu, the executable is named `batcat`.*
- **fastfetch**: A maintained replacement for `neofetch`.
  ```bash
  sudo apt install fastfetch
  ```
- **mise**: A polyglot version manager for your dev tools.
  ```bash
  curl https://mise.run | sh
  ```
- **hwinfo**: Detailed hardware information tool.
  ```bash
  sudo apt install hwinfo
  ```

## Optional: done.fish

The `done.fish` plugin provides desktop notifications when long-running commands finish. This is an **optional** addition that requires the Fisher plugin manager.

1. Install Fisher:
   ```bash
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
   ```

2. Install the `done` plugin:
   ```bash
   fisher install franciscolourenco/done
   ```

## Ansible Bootstrap

An Ansible playbook is provided to automate the installation of Fish 4.x, the recommended apt packages, and `mise`.

### Prerequisites for Ansible

```bash
sudo apt install ansible
```

### Usage

The playbook is located in the `ansible/` directory.

**Standard installation**:
```bash
ansible-playbook ansible/site.yml --ask-become-pass
```

**Installation including done.fish**:
```bash
ansible-playbook ansible/site.yml -e install_done_fish=true --ask-become-pass
```

The playbook uses `ansible/inventory.ini` to target the local machine and requires sudo privileges (via `--ask-become-pass`) for package installation.
