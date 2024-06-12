#!/bin/bash

# Script to detect and launch an app from path, flatpak or snap
command_exists() {
    command -v "$1" &> /dev/null
}


launch_flatpak() {
    local app_id="$1"
    local app_name="$2"

    if command_exists flatpak; then
        flatpak run "$app_id" &
        if [ $? -eq 0 ]; then
            echo "Launched with Flatpak"
            exit 0
        fi
    else
        echo "flatpak command not found."
    fi
}


launch_snap() {
    local app_name="$1"

    if command_exists snap; then
        snap_app=$(snap list | grep -i "$app_name" | awk '{print $1}' | head -n 1)
        if [ -n "$snap_app" ]; then
            snap run "$snap_app" &
            if [ $? -eq 0 ]; then
                echo "Launched with Snap"
                exit 0
            fi
        fi
    else
        echo "snap command not found."
    fi
}


find_flatpak_id() {
    local app_name="$1"

    
    if command_exists flatpak; then
        flatpak_id=$(flatpak list --columns name,application | awk -F'\t' -v name="$app_name" 'tolower($1) == tolower(name) {print $2}')
        if [ -n "$flatpak_id" ]; then
            echo "$flatpak_id"
            return 0
        else
            echo "Flatpak ID not found for $app_name"
            return 1
        fi
    else
        echo "flatpak command not found."
        return 1
    fi
}

launch_app() {
    local app_name="$1"

    if command_exists "$app_name"; then
        "$app_name" &
        if [ $? -eq 0 ]; then
            echo "Successfully launched $app_name"
            exit 0
        fi
    fi

    app_id=$(find_flatpak_id "$app_name")
    if [ $? -eq 0 ]; then
        launch_flatpak "$app_id" "$app_name"
    fi

    launch_snap "$app_name"

    echo "Unable to launch $app_name using any method."
    exit 1
}

if [ $# -eq 0 ]; then
    echo "Usage: $0 <app_name>"
    exit 1
fi

app_name=$(echo "$1" | tr '[:upper:]' '[:lower:]')
launch_app "$app_name"
