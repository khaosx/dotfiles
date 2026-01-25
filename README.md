# Dotfiles

Personal configuration files for macOS.

## Contents

| Directory | Files | Purpose |
|-----------|-------|---------|
| `git/` | `.gitconfig`, `.gitignore`, `.gitmessage` | Git configuration, global ignores, commit template |
| `ssh/` | `.ssh/config` | SSH host configurations and defaults |
| `zsh/` | `.zshrc`, `.zprofile`, `.aliases` | Shell configuration, environment variables, aliases |
| `.Brewfile` | - | Homebrew packages, casks, and Mac App Store apps |

## Installation

1. Clone the repository:
   ```bash
   git clone git@github.com:khaosx/dotfiles.git ~/Projects/dotfiles
   ```

2. Run the linking script:
   ```bash
   ~/Projects/dotfiles/link_configs_manual.sh
   ```

   Use `--force` to replace existing files:
   ```bash
   ~/Projects/dotfiles/link_configs_manual.sh --force
   ```

3. Install Homebrew packages:
   ```bash
   brew bundle --file=~/.Brewfile
   ```

4. Reload shell:
   ```bash
   source ~/.zprofile && source ~/.zshrc
   ```

## Updating

After making changes to live config files, sync back to the repo:
```bash
gitdots   # alias: commits and pushes with "Routine Updates" message
```

Or manually:
```bash
cd ~/Projects/dotfiles
git add -A
git commit -m "Your message"
git push
```

## Key Aliases

| Alias | Description |
|-------|-------------|
| `brewup` | Update Homebrew, cleanup, run doctor, dump Brewfile |
| `makedots` | Run the symlink script |
| `gitdots` | Commit and push dotfiles |
| `keyfix <host>` | Refresh SSH known_hosts for a host |

## Notes

- VS Code settings are managed via VS Code's built-in Settings Sync
- The global `.gitignore` covers OS/editor files only; project-specific ignores belong in each repo
