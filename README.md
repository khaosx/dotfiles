# Dotfiles

Personal configuration files for macOS. Static configs are symlinked into place, while shell and SSH configs are generated via 1Password CLI (`op inject`).

## Contents

| File | Target | Purpose |
| --- | --- | --- |
| `git.gitconfig` | `~/.gitconfig` | Git config |
| `git.gitignore` | `~/.gitignore` | Global ignore list |
| `git.gitmessage` | `~/.gitmessage` | Commit template |
| `ansible.ansible-lint` | `~/.ansible-lint` | Ansible lint config |
| `ssh.config.tpl` | `~/.ssh/config` | SSH config template (1Password injected) |
| `zsh.zprofile.tpl` | `~/.zprofile` | Zsh login profile template (1Password injected) |
| `zsh.zshrc.tpl` | `~/.zshrc` | Zsh interactive config template (1Password injected) |
| `zsh.aliases.tpl` | `~/.aliases` | Zsh aliases template (1Password injected) |
| `sh.Brewfile` | `~/.Brewfile` | Homebrew bundle |

## Prerequisites

- 1Password CLI for injected files:
  - `brew install 1password-cli`
  - `op signin`

## Installation

1. Clone the repo:
   ```bash
   git clone git@github.com:khaosx/dotfiles.git ~/Projects/dotfiles
   ```

2. Symlink static files:
   ```bash
   ln -sf ~/Projects/dotfiles/git.gitconfig ~/.gitconfig
   ln -sf ~/Projects/dotfiles/git.gitignore ~/.gitignore
   ln -sf ~/Projects/dotfiles/git.gitmessage ~/.gitmessage
   ln -sf ~/Projects/dotfiles/ansible.ansible-lint ~/.ansible-lint
   ln -sf ~/Projects/dotfiles/sh.Brewfile ~/.Brewfile
   ```

3. Generate injected configs:
   ```bash
   op inject -i ~/Projects/dotfiles/ssh.config.tpl -o ~/.ssh/config --force
   op inject -i ~/Projects/dotfiles/zsh.zprofile.tpl -o ~/.zprofile --force
   op inject -i ~/Projects/dotfiles/zsh.zshrc.tpl -o ~/.zshrc --force
   op inject -i ~/Projects/dotfiles/zsh.aliases.tpl -o ~/.aliases --force
   ```

4. Install Homebrew packages:
   ```bash
   brew bundle --file=~/.Brewfile
   ```

5. Reload shell:
   ```bash
   source ~/.zprofile && source ~/.zshrc
   ```

## Updating

- Do not edit `~/.zshrc`, `~/.zprofile`, `~/.aliases`, or `~/.ssh/config` directly. Update the templates here and re-run `op inject`.
- Keep `~/.Brewfile` updated via `brew bundle dump --force --file=~/.Brewfile`.

## Key Aliases

| Alias | Description |
| --- | --- |
| `brewup` | Update Homebrew, cleanup, run doctor, dump Brewfile |
| `makerole` | Init an Ansible role in `~/Projects/ansible.infrastructure/roles` |
| `keyfix <host>` | Refresh SSH known_hosts for a host |

## Notes

- Editor is set to `nano` in `git.gitconfig`.
- Global `.gitignore` covers OS/editor files only.
