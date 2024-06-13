#!/bin/bash

get_swww_wallpaper_path() {
    output=$(swww query)
    wallpaper_path=$(echo "$output" | grep -oP 'currently displaying: image: \K.*')
    echo "$wallpaper_path"
}

get_current_sddm_theme() {
    sddm_conf="/etc/sddm.conf"
    sddm_theme=$(awk -F'=' '/^\[Theme\]/{flag=1} flag && /^Current/{print $2; exit}' "$sddm_conf" | tr -d '[:space:]')
    echo "$sddm_theme"
}

wallpaper_path=$(get_swww_wallpaper_path)
sddm_theme=$(get_current_sddm_theme)

if [[ -n "$wallpaper_path" ]]; then
    if [[ -n "$sddm_theme" ]]; then
        extension="${wallpaper_path##*.}"
        wallpaper_directory="/usr/share/sddm/themes/$sddm_theme/Backgrounds"
        wallpaper_destination="$wallpaper_directory/wp.$extension"

        if [[ ! -d "$wallpaper_directory" ]]; then
            sudo mkdir -p "$wallpaper_directory"
            echo "Created directory $wallpaper_directory"
        fi

        sudo cp "$wallpaper_path" "$wallpaper_destination"
        echo "Wallpaper copied to $wallpaper_destination"

        theme_conf="/usr/share/sddm/themes/$sddm_theme/theme.conf"
        sudo sed -i "s|^Background=.*|Background=\"Backgrounds/wp.$extension\"|" "$theme_conf"
        echo "Background path updated in $theme_conf"
    else
        echo "Failed to determine the current SDDM theme."
    fi
else
    echo "Failed to get the wallpaper path from swww."
fi

