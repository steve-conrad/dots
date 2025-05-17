#!/bin/bash

DOTFILES_DIR="$HOME/Dot-Files"
ARCH_DIR="$DOTFILES_DIR/Arch"

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning Dot-Files repo..."
  git clone https://github.com/steve-conrad/Dot-Files.git "$DOTFILES_DIR"
  CLONED=true
else
  echo "Dot-Files repo already exists."
  CLONED=false
fi

mkdir -p "$HOME/.config"

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

echo ""
read -rp "Select a theme to install [1-${#themes[@]}]: " choice

if [[ ! "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#themes[@]} )); then
  echo "Invalid selection."
  exit 1
fi

THEME_NAME="${themes[$((choice-1))]}"
THEME_DIR="$ARCH_DIR/$THEME_NAME"

echo ""
echo "Installing '$THEME_NAME' theme..."

for folder in "$THEME_DIR"/*; do
  if [ -d "$folder" ]; then
    config_name=$(basename "$folder")
    echo "Copying $config_name → ~/.config/$config_name"
    rm -rf "$HOME/.config/$config_name"
    cp -r "$folder" "$HOME/.config/$config_name"
  fi
done

if [ "$CLONED" = true ]; then
  echo "Cleaning up cloned repo..."
  rm -rf "$DOTFILES_DIR"
fi

echo ""
echo "Dotfiles installed for theme: $THEME_NAME"
