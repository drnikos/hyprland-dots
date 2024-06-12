#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

if command_exists git; then
    echo "Git is already installed."
else
    echo "Git is not installed. Installing git..."
    sudo pacman -Sy git --noconfirm
fi

if command_exists rustup; then
    echo "Rustup is already installed."
else
    echo "Rustup is not installed. Installing rustup..."
    sudo pacman -S rustup --noconfirm
fi

if rustup show active-toolchain &>/dev/null; then
    echo "Rustup default toolchain is already set."
else
    echo "No default toolchain set. Setting stable as default..."
    rustup default stable
fi

PACKAGE_NAME="paru"
if pacman -Qi "$PACKAGE_NAME" &>/dev/null; then
    echo "Package $PACKAGE_NAME is already installed."
else
    echo "Package $PACKAGE_NAME is not installed. Cloning and installing..."

    REPO_URL="https://aur.archlinux.org/paru"

    
    REPO_DIR=$(basename "$REPO_URL" .git)
    cd "$REPO_DIR" || exit
    
    makepkg -si --noconfirm
fi
echo "AUR helper installed successfully."
