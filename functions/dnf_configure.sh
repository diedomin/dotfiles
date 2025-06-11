#!/bin/bash

configure_dnf(){
  if ! grep -q '^\[main\]' /etc/dnf/dnf.conf; then
    echo "[main]" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
  fi

  declare -A dnf_options=(
    [fastestmirror]="True"
    [max_parallel_downloads]="10"
    [defaultyes]="True"
    [keepcache]="True"
    [deltarpm]="True"
    [gpgcheck]="True"
    [install_weak_deps]="False"
    [clean_requirements_on_remove]="True"
    [installonly_limit]="3"
    [minrate]="1M"
    [timeout]="30"
  )

  for key in "${!dnf_options[@]}"; do
    sudo sed -i "/^${key}=.*/d" /etc/dnf/dnf.conf
  done

  for key in "${!dnf_options[@]}"; do
    echo "${key}=${dnf_options[$key]}" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
  done

  echo "✔ DNF optimizado correctamente."
}
