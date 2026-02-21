# Dotfiles

Personal configuration files for macOS and Linux/WSL2, managed using [Chezmoi](https://www.chezmoi.io/) with [1Password CLI](https://developer.1password.com/docs/cli/) for secret injection.

## Contents

| File | Deploys to | Notes |
|------|-----------|-------|
| `dot_zshrc.tmpl` | `~/.zshrc` | Zsh interactive shell config |
| `dot_zprofile.tmpl` | `~/.zprofile` | Zsh login profile, Homebrew, env vars |
| `dot_aliases.tmpl` | `~/.aliases` | Shell aliases and functions |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Git configuration |
| `dot_gitignore` | `~/.gitignore` | Global gitignore |
| `dot_gitmessage` | `~/.gitmessage` | Git commit message template |
| `dot_ansible-lint` | `~/.ansible-lint` | Ansible lint configuration |
| `dot_Brewfile` | `~/.Brewfile` | Homebrew bundle (macOS) |
| `private_dot_ssh/private_config.tmpl` | `~/.ssh/config` | SSH client config (permissions: 600) |
| `ConsoleDefault.terminal` | — | macOS Terminal profile (applied via script) |

## How It Works

Chezmoi manages deployment of all dotfiles. Files with the `.tmpl` extension are Go templates — secrets are pulled live from 1Password at apply time via `onepasswordRead`, so no credentials are stored in this repo.

- `dot_` prefix → deploys as a hidden file (e.g. `dot_zshrc` → `~/.zshrc`)
- `private_` prefix → enforces 600 permissions on the deployed file
- `.tmpl` extension → processed as a template before deployment
- `.chezmoiignore` → lists repo files that are not deployed as dotfiles

## Prerequisites

### macOS
```bash
brew install chezmoi
brew install 1password-cli
op signin
```

### WSL2 / Ubuntu
```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
export PATH="$HOME/.local/bin:$PATH"
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] \
  https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list
sudo apt update && sudo apt install -y 1password-cli
op signin
```

## Bootstrap (New Machine)

Place the chezmoi config file first:
```bash
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[onepassword]
    prompt = true
EOF
```

Then initialize and apply:
```bash
chezmoi init --apply git@github.com:khaosx/dotfiles.git
```

That single command clones the repo, authenticates with 1Password, renders all templates, and deploys everything to the correct locations.

Alternatively, use the included bootstrap script for a fully automated setup:
```bash
bash bootstrap.sh
```

## Daily Usage

```bash
# Preview what would change before applying
chezmoi diff

# Apply changes from repo to live files
chezmoi apply

# Pull latest from git and apply in one step
chezmoi update

# Edit a managed file (applies on save)
chezmoi edit ~/.zshrc

# Add a new file to chezmoi management
chezmoi add ~/.newconfig

# Navigate to the chezmoi source directory
chezmoi cd
```

## Updating

- **Never** edit deployed files directly (e.g. `~/.zshrc`, `~/.ssh/config`). Always edit the source templates via `chezmoi edit` or by editing in the repo and running `chezmoi apply`.
- To update secrets, change them in 1Password and run `chezmoi apply` — no template changes needed.
- To add Homebrew packages, edit `dot_Brewfile` and run `brew bundle`.

## Key Aliases

| Alias | Description |
|-------|-------------|
| `brewup` | Update Homebrew, cleanup, doctor, dump Brewfile |
| `makerole` | Init an Ansible role in `~/Projects/ansible.infrastructure/roles` |
| `keyfix <host>` | Refresh SSH known_hosts for a host |

## Platform Support

| Feature | macOS | WSL2/Linux |
|---------|-------|------------|
| Zsh config | ✅ | ✅ |
| Git config | ✅ | ✅ |
| SSH config | ✅ | ✅ |
| Homebrew | ✅ | — |
| Ansible/Terraform/Packer | ✅ | ✅ |

## License

MIT — see [LICENSE](LICENSE)
