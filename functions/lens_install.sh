#!/bin/bash

install_lens(){
    # Add Lens repo
    sudo dnf config-manager addrepo --from-repofile=https://downloads.k8slens.dev/rpm/lens.repo

    # Install lens
    sudo dnf -y install lens
}
