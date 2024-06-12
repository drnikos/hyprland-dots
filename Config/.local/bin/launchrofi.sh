#!/bin/bash

# Function to display help information
show_help() {
    script_name=$(basename "$0")
    echo "Usage: $script_name [options]"
    echo
    echo "This script launches or terminates the rofi application launcher."
    echo "If rofi is running, the script will terminate it. Otherwise, it starts rofi with the given options."
    echo
    echo "Options:"
    echo "  -h, --help           Show this help message and exit"
    echo "  Any valid rofi options can be passed to customize the behavior."
    echo
    echo "Examples:"
    echo "  $script_name -show-icons -show drun"

}

# Function to check if rofi is running
is_rofi_running() {
    pgrep -xu $(id -u) rofi > /dev/null
}

# Function to start rofi with provided or default arguments
start_rofi() {
    local args="$@"
    rofi $args
}

# Function to kill running rofi processes
kill_rofi() {
    pkill -xu $(id -u) rofi
}

# Main script logic
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Set default arguments if none are provided
ROFI_ARGS="${@:-"-show-icons -show drun"}"

if is_rofi_running; then
    kill_rofi
else
    start_rofi $ROFI_ARGS
fi
