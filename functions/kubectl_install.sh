#!/bin/bash

install_kubectl(){
sudo tee /etc/yum.repos.d/kubernetes.repo > /dev/null <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.33/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.33/rpm/repodata/repomd.xml.key
EOF

sudo dnf install -y kubectl

# Check installation
if kubectl version --client --short &>/dev/null; then
  echo "✔ kubectl installed correctly."
else
  echo "❌ Error: kubectl did not install correctly."
  exit 1
fi
}
