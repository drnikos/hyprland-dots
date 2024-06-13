#!/bin/bash
chmod +x install_pkg.sh
chmod +x aurhelperinstall.sh

./aurhelperinstall.sh
./install_pkg.sh essential_pkg.txt


read -p "Install font packages? (y/n): " answer1
answer1=$(echo "$answer1" | tr '[:upper:]' '[:lower:]')

read -p "Install apps? (y/n): " answer2
answer2=$(echo "$answer2" | tr '[:upper:]' '[:lower:]')



if [[ "$answer1" == "yes" || "$answer1" == "y" ]]; then
    echo "Installing font packages..."
    ./install_pkg.sh font_list.txt
else
    echo "Skipping font package installation."
fi



if [[ "$answer2" == "yes" || "$answer2" == "y" ]]; then
    echo "Installing apps..."
    ./install_pkg.sh app_list.txt
else
    echo "Skipping app installation."
fi

echo "Package installation completed."