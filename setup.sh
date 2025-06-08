#!/bin/bash
set -e

# Variables
FUNCTIONS_DIR="./functions"
TERRAGRUNT_VERSION="0.81.0"
TOFU_VERSION="1.9.1"
NERDFONTS="Cousine MartianMono Mononoki RobotoMono"
NERDFONTS_VERSION=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r .tag_name)

# Functions source
find "$FUNCTIONS_DIR" -type f -name "*.sh" | while read -r f; do
  source "$f"
done

init_config

# Update the system.
sudo dnf upgrade --refresh -y

# Install rpm packages.
echo "Instalando paquetes RPM..."
sudo dnf install -y git vim curl wget fastfetch htop fish \
    steam terminator ansible jq gnome-tweaks gnome-extensions-app \
    gnome-shell-extension-appindicator

# Install Flatpaks packages
echo "Instalando paquetes Flatpak..."
flatpak install -y flathub one.ablaze.floorp com.discordapp.Discord \
    org.telegram.desktop com.bambulab.BambuStudio

# Change default shell to fish
echo "Cambiando la shell a Fish"
chsh -s $(which fish)

# Install Zed editor
echo "Instalando Zed..."
curl -fsSL https://zed.dev/install.sh | sh

# Install OpenTofu
echo "Instalando OpenTofu..."
install_opentofu "$TOFU_VERSION"

# Install Terragrunt
echo "Instalando Terragrunt..."
install_terragrunt "$TERRAGRUNT_VERSION"

# Install Nerd fonts
echo "Instalando NerdFonts..."
mkdir -p ~/.local/share/fonts

for font in $NERDFONTS; do
  wget -O /tmp/${font}.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERDFONTS_VERSION}/${font}.zip"
  unzip -o /tmp/${font}.zip -d ~/.local/share/fonts
done
rm /tmp/*.zip
fc-cache -fv

# Install and config starship promt
echo "Instalando Starship"
curl -sS https://starship.rs/install.sh | sh -s -- -y
mkdir -p ~/.config
cp ~/dotfiles/starship/starship.toml ~/.config/starship.toml
chmod 600 ~/.config/fish/config.fish ~/.config/starship.toml

# Configure fish shell
echo "Configurando fish..."
mkdir -p ~/.config/fish/functions
cp ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
cp ~/dotfiles/fish/functions/* ~/.config/fish/functions/

# Configure terminator
echo "Configurando terminator..."
mkdir -p ~/.config/terminator
cp ~/dotfiles/terminator/config ~/.config/terminator/config

# Configure zed
echo "Configurando Zed..."
mkdir -p ~/.config/zed
cp -r ~/dotfiles/zed/* ~/.config/zed/

# Final
ask_reboot
