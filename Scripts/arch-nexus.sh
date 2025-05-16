#!/bin/bash

# Print the logo
print_logo() {
    cat << "EOF"
   ▄████████    ▄████████  ▄████████    ▄█    █▄         ███▄▄▄▄      ▄████████ ▀████    ▐████▀ ███    █▄     ▄████████ 
  ███    ███   ███    ███ ███    ███   ███    ███        ███▀▀▀██▄   ███    ███   ███▌   ████▀  ███    ███   ███    ███ 
  ███    ███   ███    ███ ███    █▀    ███    ███        ███   ███   ███    █▀     ███  ▐███    ███    ███   ███    █▀  
  ███    ███  ▄███▄▄▄▄██▀ ███         ▄███▄▄▄▄███▄▄      ███   ███  ▄███▄▄▄        ▀███▄███▀    ███    ███   ███        
▀███████████ ▀▀███▀▀▀▀▀   ███        ▀▀███▀▀▀▀███▀       ███   ███ ▀▀███▀▀▀        ████▀██▄     ███    ███ ▀███████████ 
  ███    ███ ▀███████████ ███    █▄    ███    ███        ███   ███   ███    █▄    ▐███  ▀███    ███    ███          ███ 
  ███    ███   ███    ███ ███    ███   ███    ███        ███   ███   ███    ███  ▄███     ███▄  ███    ███    ▄█    ███ 
  ███    █▀    ███    ███ ████████▀    ███    █▀          ▀█   █▀    ██████████ ████       ███▄ ████████▀   ▄████████▀  
               ███    ███                                                                                                                                                       
EOF
}

# Clear screen and print logo
clear
print_logo

# Exit on any error
set -e

# Menu options with keys and labels
declare -A scripts=(
  ["0"]="Run All"
  ["1"]="Update system"
  ["2"]="Install yay AUR helper"
  ["3"]="Install Desktop Environment"
  ["4"]="Install GPU Drivers"
  ["5"]="Install System Utilities"
  ["6"]="Install App Packages"
  ["7"]="Install Dot Files"
  ["q"]="Quit"
)

# Define the order of keys explicitly
menu_order=(0 1 2 3 4 5 6 7 q)

quit_chosen=0

while true; do
  echo -e "\nWelcome to Arch Nexus. Select a menu option and press enter:"
  for key in "${menu_order[@]}"; do
    echo "  $key) ${scripts[$key]}"
  done
  echo -n "Choice: "
  read -r choice

  case "$choice" in
    0)
      echo "Running full setup..."
      "$0" 1
      "$0" 2
      "$0" 3
      "$0" 4
      "$0" 5
      "$0" 6
      "$0" 7
      quit_chosen=1
      break
      ;;
    1)
      echo "Updating system..."
      sudo pacman -Syu --noconfirm
      ;;
    2)
      echo "Checking for yay..."
      if ! command -v yay &> /dev/null; then
        echo "🛠 Installing yay AUR helper..."
        sudo pacman -S --needed git base-devel --noconfirm
        if [[ -d yay ]]; then
          echo " 'yay' directory exists, removing it..."
          rm -rf yay
        fi
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
      else
        echo "yay is already installed."
      fi
      ;;
    3)
      echo "Running Desktop Environment and Window Manager setup..."
      . install-DE-WM.sh
      ;;
    4)
      echo "Running GPU Driver installer..."
      . install-drivers.sh
      ;;
    5)
      echo "Installing System Utilities..."
      . install-system-utilities.sh
      ;;
    6)
      echo "Installing App Packages..."
      . install-packages.sh
      ;;
    7)
      echo "Installing Dot Files..."
      . install-dots.sh
      ;;
    q)
      echo "Closing Script."
      quit_chosen=1
      break
      ;;
    *)
      echo "Invalid choice. Please choose a valid option."
      ;;
  esac
done

if [[ $quit_chosen -eq 0 ]]; then
  echo -e "\nSetup complete! You may want to reboot your system."
fi

