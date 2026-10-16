#!/bin/bash
set -e

# Keep sudo alive
sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &
SUDO_LOOP_PID=$!
trap 'kill $SUDO_LOOP_PID' EXIT

# Variables
FUNCTIONS_DIR="./functions"
# Leave empty to install the latest version, or set one (e.g. "0.81.0")
TERRAGRUNT_VERSION=""
TOFU_VERSION=""
NERDFONTS="Cousine MartianMono Mononoki RobotoMono"
NERDFONTS_VERSION=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r .tag_name)

RPM_PACKAGES=(git vim curl wget fastfetch htop steam
   terminator ansible gnome-tweaks gnome-extensions-app
   gnome-shell-extension-appindicator
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
spinner "Updating the system...  " "sudo dnf upgrade --refresh -y"

# Install rpm packages.
spinner "Installing RPM packages...  " "sudo dnf install -y ${RPM_PACKAGES[*]}"

# Install Flatpaks packages
spinner "Installing Flatpack packages...  " "flatpak install -y ${FLATPAK_PACKAGES[*]}"

# Install Docker
spinner "Instaling Docker... " "install_docker"

# Install kubectl
spinner "Instaling Kubectl... " "install_kubectl"

# Install Minikube
spinner "Instaling Minikube... " "install_minikube"

# Install Helm
spinner "Installing Helm... " "sudo dnf -y install helm"

# Install Lens desktop
spinner "Installing Lens... " "install_lens"

# Install Zed editor
spinner "Installing Zed... " "curl -fsSL https://zed.dev/install.sh | sh"

# Install OpenTofu
spinner "Installing OpenTofu... " "install_opentofu $TOFU_VERSION"

# Install Terragrunt
spinner "Installing Terragrunt... " "install_terragrunt $TERRAGRUNT_VERSION"

# Install Nerd fonts
spinner "Installing NerdFonts... " "

mkdir -p ~/.local/share/fonts &&
for font in \$NERDFONTS; do
  wget -O /tmp/\${font}.zip \"https://github.com/ryanoasis/nerd-fonts/releases/download/\$NERDFONTS_VERSION/\${font}.zip\" &&
  unzip -o /tmp/\${font}.zip -d ~/.local/share/fonts
done &&
rm /tmp/*.zip &&
fc-cache -fv
"

# Install and config starship promt
spinner "Installing Starship promt... " "
curl -sS https://starship.rs/install.sh | sh -s -- -y &&
mkdir -p ~/.config &&
cp ~/dotfiles/starship/starship.toml ~/.config/starship.toml &&
chmod 600 ~/.config/starship.toml
"

# Configure bash
echo "Configuring bash..."
mkdir -p ~/.bashrc.d
cp ~/dotfiles/bash/dotfiles.sh ~/.bashrc.d/dotfiles.sh
if ! grep -q "bashrc.d" ~/.bashrc; then
  cat >> ~/.bashrc <<'BASHRC'

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    [ -f "$rc" ] && . "$rc"
  done
  unset rc
fi
BASHRC
fi

# Configure terminator
echo "Configuring terminator..."
mkdir -p ~/.config/terminator
cp ~/dotfiles/terminator/config ~/.config/terminator/config

# Configure zed
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile

echo "Configuring Zed..."
mkdir -p ~/.config/zed
cp -r ~/dotfiles/zed/* ~/.config/zed/

# Final
ask_reboot
