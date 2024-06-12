#!/bin/bash

# Function to check if paru is installed
check_paru() {
    if ! command -v paru &> /dev/null; then
        echo "Paru is not installed. Please install paru first."
        exit 1
    fi
}

# Function to process the package list and install packages
install_packages() {
    local package_file="$1"

    if [[ ! -f "$package_file" ]]; then
        echo "Package list file $package_file not found!"
        exit 1
    fi

    echo "Reading package list from $package_file..."

    while IFS= read -r line; do
        # Use grep to check if the line matches the pattern <---- ... ---->
        if echo "$line" | grep -q '^<----.*---->$'; then
            continue
        fi

        # Trim any leading/trailing whitespace
        package=$(echo "$line" | xargs)

        # Skip empty lines
        if [[ -z "$package" ]]; then
            continue
        fi

        echo "Installing package: $package"
        paru -S --needed --noconfirm "$package" || { echo "Failed to install $package"; exit 1; }

    done < "$package_file"
}

# Main script execution
main() {
    # Ensure the script is run with a package list file as an argument
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <package_list_file>"
        exit 1
    fi

    package_list_file="$1"

    # Check if paru is installed
    check_paru

    # Process and install packages from the list
    install_packages "$package_list_file"

    echo "All packages installed successfully."
}

# Run the main function
main "$@"
