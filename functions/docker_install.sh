#!/bin/bash

install_docker(){
# Install dependencies
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install Docker
sudo dnf -y install docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin

# Enable Docker
sudo systemctl enable --now docker

# Add $USER to docker group
sudo usermod -aG docker $USER
newgrp docker

# Check installation
if docker --version >/dev/null 2>&1; then
  echo "✔ Docker CLI installed correctly."
else
  echo "❌ Error: Docker did not install correctly."
  exit 1
fi

# Hello-world test
if docker run --rm hello-world >/dev/null 2>&1; then
  echo "✔ Docker works correctly."
else
  echo "❌ Error: Failed to launch a Docker container."
  exit 1
fi
}
