#!/bin/bash

DOTFILES_DIR="$HOME/Dot-Files"
ARCH_DIR="$DOTFILES_DIR/Arch"

# Clone or update the Dot-Files repo
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning Dot-Files repo..."
  git clone https://github.com/steve-conrad/Dot-Files.git "$DOTFILES_DIR"
else
  echo "Updating existing Dot-Files repo..."
  git -C "$DOTFILES_DIR" pull
fi

# Make sure ~/.config exists
mkdir -p "$HOME/.config"

# Prompt user to select a theme
echo ""
echo "Available themes:"
themes=()
i=1
for dir in "$ARCH_DIR"/*/; do
  theme=$(basename "$dir")
  themes+=("$theme")
  echo "  [$i] $theme"
  ((i++))
done
echo "  [q] Cancel"

echo ""
read -rp "Select a theme to install [1-${#themes[@]} or q]: " choice

if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
  echo "Theme installation canceled."
  exit 0
fi

if [[ ! "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#themes[@]} )); then
  echo "Invalid selection."
  exit 1
fi

selected_theme="${themes[choice-1]}"
theme_path="$ARCH_DIR/$selected_theme"

echo "Installing theme: $selected_theme"

# Copy theme folders into ~/.config, overwriting as needed
for folder in "$theme_path"/*/; do
  config_folder=$(basename "$folder")
  echo "  Installing $config_folder..."
  rm -rf "$HOME/.config/$config_folder"
  cp -r "$folder" "$HOME/.config/"
done

echo "Theme '$selected_theme' installed."
