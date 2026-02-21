#!/usr/bin/env bash
# bootstrap.sh - New machine setup script
# Author: Kristopher Newman
#
# Run this on a fresh macOS or WSL2/Linux machine to bootstrap dotfiles.
# Usage: curl -sL https://raw.githubusercontent.com/khaosx/dotfiles/main/bootstrap.sh | bash

set -euo pipefail

echo "==> Detecting platform..."
OS="$(uname -s)"

# ---- Install Chezmoi ----
if ! command -v chezmoi &>/dev/null; then
  echo "==> Installing Chezmoi..."
  if [[ "$OS" == "Darwin" ]]; then
    brew install chezmoi
  else
    sh -c "$(curl -fsLS get.chezmoi.io)"
    export PATH="$HOME/.local/bin:$PATH"
  fi
else
  echo "==> Chezmoi already installed: $(chezmoi --version)"
fi

# ---- Install 1Password CLI ----
if ! command -v op &>/dev/null; then
  echo "==> Installing 1Password CLI..."
  if [[ "$OS" == "Darwin" ]]; then
    brew install 1password-cli
  else
    # WSL2 / Debian-based Linux
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
      sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] \
      https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
      sudo tee /etc/apt/sources.list.d/1password.list
    sudo apt update && sudo apt install -y 1password-cli
  fi
else
  echo "==> 1Password CLI already installed: $(op --version)"
fi

# ---- Sign in to 1Password ----
echo "==> Signing in to 1Password..."
op signin

# ---- Place chezmoi.toml config ----
CHEZMOI_CONFIG_DIR="$HOME/.config/chezmoi"
CHEZMOI_CONFIG="$CHEZMOI_CONFIG_DIR/chezmoi.toml"

if [[ ! -f "$CHEZMOI_CONFIG" ]]; then
  echo "==> Creating Chezmoi config..."
  mkdir -p "$CHEZMOI_CONFIG_DIR"
  cat > "$CHEZMOI_CONFIG" << 'EOF'
[onepassword]
    prompt = true
EOF
  echo "==> Chezmoi config written to $CHEZMOI_CONFIG"
else
  echo "==> Chezmoi config already exists, skipping."
fi

# ---- Initialize and apply dotfiles ----
echo "==> Initializing dotfiles from GitHub..."
chezmoi init --apply git@github.com:khaosx/dotfiles.git

echo ""
echo "==> Bootstrap complete!"
echo "==> Reload your shell: source ~/.zprofile && source ~/.zshrc"
