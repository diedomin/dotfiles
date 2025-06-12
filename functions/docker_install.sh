#!/bin/bash

install_docker(){
    # Install dependencies
    sudo dnf -y install dnf-plugins-core
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

    # Install Docker
    sudo dnf -y install docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin

    # Enable Docker
    sudo systemctl enable --now docker

    # Add $USER to docker group
    sudo usermod -aG docker $USER

}
