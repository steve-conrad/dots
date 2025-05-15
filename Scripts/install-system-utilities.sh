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
)

for package in ${packages[@]}; do
  yay -S --noconfirm --needed ${package}
done

echo "Enabling Network Services.."
sudo systemctl start networkmanager
sudo systemctl enable networkmanager
echo "Enabling Bluetooth Services.."
sudo systemctl enable bluetooth

