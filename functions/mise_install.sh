#!/bin/bash

install_mise(){
    # Add mise repo
    sudo dnf config-manager addrepo --from-repofile=https://mise.jdx.dev/rpm/mise.repo --overwrite

    # Install mise
    sudo dnf -y install mise
}
