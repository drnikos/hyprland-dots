#!/usr/bin/env sh
# Script from https://github.com/prasanthrangan/hyprdots
scrDir=`dirname "$(realpath "$0")"`

hyprctl devices -j | jq -r '.keyboards[].name' | while read keyName
do
    hyprctl switchxkblayout "$keyName" next
done

layMain=$(hyprctl -j devices | jq '.keyboards' | jq '.[] | select (.main == true)' | awk -F '"' '{if ($2=="active_keymap") print $4}')