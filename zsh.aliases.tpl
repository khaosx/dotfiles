# .aliases.tpl - Zsh Command Aliases
# Managed by 1Password (op inject)
# Author: Kristopher Newman
#
# This file contains aliases and functions for common commands. 
# It is used to generate the local ~/.aliases file.

# Homebrew
alias brewup='brew bundle; brew cleanup; brew doctor; brew bundle dump --force'

# Ansible
alias makerole='ansible-galaxy init --init-path=$HOME/Projects/ansible.infrastructure/roles'

# SSH key management - removes old host keys and adds fresh ones
keyfix() {
  local host="${1:?Usage: keyfix <hostname>}"
  local ip=""

  # Resolve IP using dig (with fallback to dscacheutil on macOS)
  if (( $+commands[dig] )); then
    ip=$(dig +short "$host" | tail -n1)
  elif (( $+commands[dscacheutil] )); then
    ip=$(dscacheutil -q host -a name "$host" | awk '/ip_address/ {print $2; exit}')
  else
    echo "Warning: Could not resolve IP (neither 'dig' nor 'dscacheutil' found)."
  fi

  # Remove old keys
  ssh-keygen -R "$host" &> /dev/null
  [[ -n "$ip" ]] && ssh-keygen -R "$ip" &> /dev/null

  # Add fresh keys
  ssh-keyscan -H "$host" >> ~/.ssh/known_hosts 2>/dev/null
  [[ -n "$ip" ]] && ssh-keyscan -H "$ip" >> ~/.ssh/known_hosts 2>/dev/null

  echo "Refreshed keys for $host${ip:+ ($ip)}"
}