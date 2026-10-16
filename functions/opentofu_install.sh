#!/bin/bash

install_opentofu() {
  # Version is optional: without it, the latest release is installed
  local TOFU_VERSION="${1#v}"

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
  if [ -n "$TOFU_VERSION" ]; then
    sudo dnf install -y "tofu-${TOFU_VERSION}"
  else
    sudo dnf install -y tofu
  fi

  # Check install
  if tofu version 2>/dev/null | grep -q "$TOFU_VERSION"; then
    echo "$(tofu version | head -n 1) OK."
  else
    echo "❌ Error: OpenTofu instalation fail."
    exit 1
  fi
}
