#!/bin/bash

while true; do
  echo "Which desktop environment do you want to install?"
  echo "  1) Hyprland"
  echo "  2) KDE Plasma"
  echo "  3) GNOME"
  echo -n "Enter 1, 2, or 3: "
  read -r DE_CHOICE

  case "$DE_CHOICE" in
    1)
      echo "🛠 Installing Hyprland..."
	packages=(
	waybar	
  	wofi
	swaync
	hyprshot
	hyprlock
	hypridle
	xdg-desktop-portal-hyprland
	hyprpolkitagent
	)

	for package in ${packages[@]}; do
  	yay -S --noconfirm --needed ${package}
	done
      break
      ;;
    2)
      echo "🛠 Installing KDE Plasma..."
      yay -S plasma
      break
      ;;
    3)
      echo "Installing GNOME..."
      yay -S gnome
      break
      ;;
    *)
      echo "❌ Invalid choice. Please enter 1, 2, or 3."
      ;;
  esac
done
