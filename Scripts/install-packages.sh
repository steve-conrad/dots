#!/bin/bash

packages=(
  firefox
  kitty
  neovim
  steam
  fastfetch
  discord
  wget
  git
  viewnior
  btop
  coolercontrol
)

for package in ${packages[@]}; do
  yay -S --noconfirm --needed ${package}
done
