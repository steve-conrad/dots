#!/bin/bash

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

clear
print_logo

set -e
source ./functions.sh
source ./packages.sh

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

menu_order=(0 1 2 3 4 5 6 7 q)
quit_chosen=0

# Function blocks for actions
run_1() {
  echo "Updating system..."
  sudo pacman -Syu --noconfirm
}

run_2() {
  echo "Checking for yay..."
  if ! command -v yay &> /dev/null; then
    echo "🛠 Installing yay AUR helper..."
    sudo pacman -S --needed git base-devel --noconfirm
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
  else
    echo "yay is already installed."
  fi
}

run_3() {
  echo "Running desktop environment and window manager setup..."
  install_de_wm
}

run_4() {
  echo "Running GPU driver installer..."
  install_gpu_driver
}

run_5() {
  echo "Installing system utilities..."
  install_packages "${system_utils[@]}"
  echo "Installed system utilities"

  echo "Enabling system services..."
  enable_service "networkmanager"
  enable_service "bluetooth.service"
  enable_service "cups"

  #Prompt before running sensors-detect
  echo "Running fan and thermal sensor detection (lm_sensors)"
  read -rp "This will prompt for several yes/no hardware questions. Run now? [y/N]: " run_sensors
  if [[ "$run_sensors" =~ ^[Yy]$ ]]; then
    sudo sensors-detect
  else
    echo "Skipped sensors-detect."
  fi
  echo "System utilities and services setup complete."
  
}

run_6() {
  echo "Installing app packages..."
  install_packages "${app_packages[@]}"
}

run_7() {
  echo "Installing dot files..."
  install_dots
}

while true; do
  echo -e "\nWelcome to Arch Nexus. Select a menu option and press enter:"
  for key in "${menu_order[@]}"; do
    echo "  $key) ${scripts[$key]}"
  done
  echo -n "Enter 1-7 or q to quit: "
  read -r choice

  case "$choice" in
    0)
      echo "Running full setup..."
      run_1
      run_2
      run_3
      run_4
      run_5
      run_6
      run_7
      quit_chosen=1
      break
      ;;
    1) run_1 ;;
    2) run_2 ;;
    3) run_3 ;;
    4) run_4 ;;
    5) run_5 ;;
    6) run_6 ;;
    7) run_7 ;;
    q|Q)
      echo "Quitting Script."
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

