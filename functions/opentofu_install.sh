#!/bin/bash

install_opentofu() {
  TOFU_VERSION="${1:-1.9.1}"

  # Add Tofu repo
  sudo tee /etc/yum.repos.d/opentofu.repo > /dev/null <<EOF
[opentofu]
name=opentofu
baseurl=https://packages.opentofu.org/opentofu/tofu/rpm_any/rpm_any/\$basearch
repo_gpgcheck=0
gpgcheck=1
enabled=1
gpgkey=https://get.opentofu.org/opentofu.gpg
       https://packages.opentofu.org/opentofu/tofu/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[opentofu-source]
name=opentofu-source
baseurl=https://packages.opentofu.org/opentofu/tofu/rpm_any/rpm_any/SRPMS
repo_gpgcheck=0
gpgcheck=1
enabled=1
gpgkey=https://get.opentofu.org/opentofu.gpg
       https://packages.opentofu.org/opentofu/tofu/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF

  # Install OpenTofu
  sudo dnf install -y tofu

  # Check install
  if tofu version 2>/dev/null | grep -q "$TOFU_VERSION"; then
    echo "OpenTofu $TOFU_VERSION OK."
  else
    echo "❌ Error: OpenTofu instalation fail."
    exit 1
  fi
}
