#!/bin/bash

packages=(
  firefox
  kitty
  neovim
  steam
  discord
  cava
  youtube-music-bin
)

for package in ${packages[@]}; do
  yay -S --noconfirm --needed ${package}
done
