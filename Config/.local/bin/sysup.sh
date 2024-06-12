#!/bin/bash

command_exists() {
    command -v "$1" &> /dev/null
}

update_system() {
    if command_exists yay || command_exists paru || command_exists trizen || command_exists pamac || command_exists pacaur || command_exists aura; then
        if command_exists yay; then
            yay -Syu --noconfirm
        elif command_exists paru; then
            paru -Syu --noconfirm
        elif command_exists trizen; then
            trizen -Syu --noconfirm
        elif command_exists pamac; then
            pamac update --aur --no-confirm
        elif command_exists pacaur; then
            pacaur -Syu --noconfirm
        elif command_exists aura; then
            aura -Ayu --noconfirm
        fi
    else
        sudo pacman -Syu --noconfirm
    fi

    if command_exists flatpak; then
        flatpak update -y
    fi

    if command_exists snap; then
        sudo snap refresh
    fi
}

update_system
