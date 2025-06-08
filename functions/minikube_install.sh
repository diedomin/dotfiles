#!/bin/bash

install_minikube(){
    # Download, install and remove the package.
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
  sudo rpm -Uvh minikube-latest.x86_64.rpm
  rm -f minikube-latest.x86_64.rpm

  # Check installation
  if minikube version &>/dev/null; then
    echo "✔ Minikube installed correctly."
  else
    echo "❌ Error: Minikube did not install correctly."
    exit 1
  fi
}
