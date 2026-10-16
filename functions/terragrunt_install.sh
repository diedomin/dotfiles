#!/bin/bash

install_terragrunt() {
  # Version is optional: without it, the latest release is installed
  local TERRAGRUNT_VERSION="${1#v}"
  local TERRAGRUNT_URL

  if [ -n "$TERRAGRUNT_VERSION" ]; then
    TERRAGRUNT_URL="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
  else
    TERRAGRUNT_URL="https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64"
  fi

  sudo wget -O /usr/local/bin/terragrunt "$TERRAGRUNT_URL"
  sudo chmod +x /usr/local/bin/terragrunt

  # Check instalation
  if terragrunt --version 2>/dev/null | grep -q "$TERRAGRUNT_VERSION"; then
    echo "$(terragrunt --version) OK."
  else
    echo "❌ Error: Terragrunt install fail"
    exit 1
  fi
}
