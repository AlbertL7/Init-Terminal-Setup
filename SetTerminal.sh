#!/bin/zsh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or log in as root."
  exit 1
fi

# Get all users with UID >= 1000 and < 65534, excluding 'nobody'
users=($(awk -F: '$3 >= 1000 && $3 < 65534 && $1 != "nobody" {print $1}' /etc/passwd))

# Install necessary packages if not already installed
for pkg in terminator zsh wget git; do
  if ! command -v $pkg &> /dev/null; then
    apt install -y $pkg
  fi
done

# Set Zsh as the default shell for root
zsh_path=$(which zsh)
if [ "$SHELL" != "$zsh_path" ]; then
  chsh -s "$zsh_path" root
fi

# Install Oh My Zsh for root if not already installed
if [ ! -d "/root/.oh-my-zsh" ]; then
  wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh
fi

# Path to custom configuration files
custom_terminator_config="/root/Init-Terminal-Setup/terminator-config"
custom_zsh_theme="/root/Init-Terminal-Setup/sudo.zsh-theme"
custom_zshrc_root="/root/Init-Terminal-Setup/.zshrc-sudo"
custom_zshrc_user="/root/Init-Terminal-Setup/.zshrc-user"

# Verify that required configuration files exist
if [ ! -f "$custom_terminator_config" ] || [ ! -f "$custom_zsh_theme" ] || [ ! -f "$custom_zshrc_root" ] || [ ! -f "$custom_zshrc_user" ]; then
  echo "One or more required configuration files are missing in /root/Init-Terminal-Setup."
  exit 1
fi

# Configure Zsh and Terminator for root
cp "$custom_zsh_theme" /root/.oh-my-zsh/themes/
cp "$custom_zshrc_root" /root/.zshrc
mkdir -p /root/.config/terminator
cp "$custom_terminator_config" /root/.config/terminator/config

# Reload root's Zsh configuration
source /root/.zshrc

# Configure Zsh and Terminator for all users
for user in "${users[@]}"; do
  user_home=$(eval echo "~$user")
  
  # Set up Zsh for the user
  if [ ! -d "$user_home/.oh-my-zsh" ]; then
    cp -R /root/.oh-my-zsh "$user_home/.oh-my-zsh"
    chown -R "$user:$user" "$user_home/.oh-my-zsh"
  fi
  
  cp "$custom_zshrc_user" "$user_home/.zshrc"
  chown "$user:$user" "$user_home/.zshrc"
  
  # Set up Terminator for the user
  mkdir -p "$user_home/.config/terminator"
  cp "$custom_terminator_config" "$user_home/.config/terminator/config"
  chown -R "$user:$user" "$user_home/.config/terminator"
done

# Final message
echo "Setup complete. Please close and reopen your terminal to apply changes."
