#!/bin/bash
set -e

# Keep sudo alive
sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &
SUDO_LOOP_PID=$!
trap 'kill $SUDO_LOOP_PID' EXIT

# Variables
FUNCTIONS_DIR="./functions"
TERRAGRUNT_VERSION="0.81.0"
TOFU_VERSION="1.9.1"
NERDFONTS="Cousine MartianMono Mononoki RobotoMono"
NERDFONTS_VERSION=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r .tag_name)

RPM_PACKAGES=(git vim curl wget fastfetch htop fish steam
   terminator ansible gnome-tweaks gnome-extensions-app
   gnome-shell-extension-appindicator hydrapaper
)

FLATPAK_PACKAGES=(flathub one.ablaze.floorp com.discordapp.Discord
    org.telegram.desktop com.bambulab.BambuStudio)

# Functions source
for f in $(find "$FUNCTIONS_DIR" -type f -name "*.sh"); do
  source "$f"
done

init_config

# Set dark mode
echo "Set Dark mode"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Configure dnf
configure_dnf

# Update the system.
spinner "Updating the system " "sudo dnf upgrade --refresh -y"

# Install rpm packages.
spinner "Installing RPM packages " "sudo dnf install -y ${RPM_PACKAGES[*]}"

# Install Flatpaks packages
spinner "Installing Flatpack packages " "flatpak install -y ${FLATPAK_PACKAGES[*]}"

# Install Docker
install_docker

# Install kubectl
install_kubectl

# Install Minikube
install_minikube

# Install Helm
sudo dnf -y install helm

# Install Lens desktop
install_lens

# Change default shell to fish
echo "Changing the shell to Fish..."
chsh -s $(which fish)
fish -c "exit"

# Configure wallpapers
mkdir -p ~/Imágenes/Wallpapers
cp ~/dotfiles/wallpapers/* ~/Imágenes/Wallpapers/
hydrapaper --cli \
  "$HOME/Imágenes/Wallpapers/jupiter.jpg" \
  "$HOME/Imágenes/Wallpapers/saturno.jpg"

# Install Zed editor
echo "Installing Zed..."
curl -fsSL https://zed.dev/install.sh | sh

# Install OpenTofu
echo "Installing OpenTofu..."
install_opentofu "$TOFU_VERSION"

# Install Terragrunt
echo "Installing Terragrunt..."
install_terragrunt "$TERRAGRUNT_VERSION"

# Install Nerd fonts
echo "Installing NerdFonts..."
mkdir -p ~/.local/share/fonts

for font in $NERDFONTS; do
  wget -O /tmp/${font}.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERDFONTS_VERSION}/${font}.zip"
  unzip -o /tmp/${font}.zip -d ~/.local/share/fonts
done
rm /tmp/*.zip
fc-cache -fv

# Install and config starship promt
echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y
mkdir -p ~/.config
mkdir -p ~/.config/fish
cp ~/dotfiles/starship/starship.toml ~/.config/starship.toml
chmod 600 ~/.config/starship.toml

# Configure fish shell
echo "Configuring fish..."
mkdir -p ~/.config/fish/functions
cp ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
cp ~/dotfiles/fish/functions/* ~/.config/fish/functions/

# Configure terminator
echo "Configuring terminator..."
mkdir -p ~/.config/terminator
cp ~/dotfiles/terminator/config ~/.config/terminator/config

# Configure zed
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
fish -c "set -U fish_user_paths $HOME/.local/bin \$fish_user_paths"

echo "Configuring Zed..."
mkdir -p ~/.config/zed
cp -r ~/dotfiles/zed/* ~/.config/zed/

# Final
ask_reboot
