#!/bin/bash

# Print the logo
print_logo() {
    cat << "EOF"
███▄▄▄▄      ▄████████ ▀████    ▐████▀ ███    █▄     ▄████████ 
███▀▀▀██▄   ███    ███   ███▌   ████▀  ███    ███   ███    ███ 
███   ███   ███    █▀     ███  ▐███    ███    ███   ███    █▀  
███   ███  ▄███▄▄▄        ▀███▄███▀    ███    ███   ███        
███   ███ ▀▀███▀▀▀        ████▀██▄     ███    ███ ▀███████████ 
███   ███   ███    █▄    ▐███  ▀███    ███    ███          ███ 
███   ███   ███    ███  ▄███     ███▄  ███    ███    ▄█    ███ 
 ▀█   █▀    ██████████ ████       ███▄ ████████▀   ▄████████▀  
                                                             
EOF
}

# Clear screen and show logo
clear
print_logo

# Exit on any error
set -e

# Update the system first
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install yay AUR helper if not present
if ! command -v yay &> /dev/null; then
  echo "Installing yay AUR helper..."
  sudo pacman -S --needed git base-devel --noconfirm
  if [[ ! -d "yay" ]]; then
    echo "Cloning yay repository..."
  else
    echo "yay directory already exists, removing it..."
    rm -rf yay
  fi

  git clone https://aur.archlinux.org/yay.git

  cd yay
  echo "building yay...."
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "yay is already installed"
fi

#Install Desktop Environment
  echo "Configuring Desktop Environment and Window Manager..."
  . install-DE-WM.sh
  
#Install GPU Drivers 
 echo "Launching GPU Installer"
  . install-drivers.sh

#Install System Utilities
 echo "Installing System Utilities..."
  . install-system-utilities.sh

#Install App Packages
 echo "Installing apps..."
  . install-packages.sh


echo "Setup complete! Please reboot your system."
