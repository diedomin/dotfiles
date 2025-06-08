#!/bin/bash

install_terragrunt() {
  TERRAGRUNT_VERSION="${1:-0.81.0}"
  TERRAGRUNT_URL="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"

  sudo wget -O /usr/local/bin/terragrunt "$TERRAGRUNT_URL"
  sudo chmod +x /usr/local/bin/terragrunt

  # Check instalation
  if terragrunt --version 2>/dev/null | grep -q "$TERRAGRUNT_VERSION"; then
    echo "Terragrunt $TERRAGRUNT_VERSION OK."
  else
    echo "❌ Error: Terragrunt install fail"
    exit 1
  fi
}
