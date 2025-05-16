#!/bin/bash

packages=(
  wget
  git
  viewnior
  cliphist
  mpv
  mpvpaper
  swww
  ttf-font-awesome
  wireplumber
  pavucontrol
  playerctl
  blueman
  networkmanager
  network-manager-applet
  thunar
  catppuccin-cursors-mocha
  cups
  system-config-printer
  print-manager
  rocm-smi-lib
  lm_sensors
  7zip
  wine
  ark
  spectacle
  timeshift
  fastfetch
  btop
  coolercontrol
)

for package in ${packages[@]}; do
  yay -S --noconfirm --needed ${package}
done

echo "Enabling Network Service.."
sudo systemctl start networkmanager
sudo systemctl enable networkmanager
echo "Enabling Bluetooth Service.."
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth
echo "Enabling Printer Service.."
systemctl start cups
systemctl enable cups
echo "Enabling Fan Controller.."
sudo sensors-detect
