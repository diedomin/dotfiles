# Dotfiles & Setup Scripts

This repository stores the configuration files and setup scripts for my essential tools and environment.
It is still under development; more tools and configurations will be added over time.

## Features

- Automated installation and configuration for Fedora (adaptable to other distros)
- Modular setup: functions and tasks organized in separate files for easy customization
- Personal preferences for editors, terminal, shell, fonts, and more

## Usage

1. **Clone this repository:**
    ```bash
    git clone https://github.com/diedomin/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2. **Run the main setup script:**
    ```bash
    ./setup.sh
    ```

    > **Note:** The script is designed for a clean Fedora installation, but you can adapt it for other distributions.

3. **Follow the on-screen prompts to complete the setup.**

## Structure

- `setup.sh` – Main script to automate the setup and apply configurations
- `functions/` – Modular scripts for installing/configuring tools
- `dotfiles/` – Configuration files for editors, terminal, shell, etc.

## Requirements

- Fedora (tested with recent versions)
- Internet connection
- [git](https://git-scm.com/)
- [jq](https://jqlang.org/)

## Notes

- Feel free to adapt the scripts for your own setup or another distro.
- **Do not store private keys or sensitive information in this repository.**
