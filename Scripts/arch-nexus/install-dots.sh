#!/bin/bash

DOTFILES_DIR="$HOME/Dot-Files"
ARCH_DIR="$DOTFILES_DIR/Arch"

# Check if the Dot-Files repo already exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repo..."
  git clone https://github.com/steve-conrad/Dot-Files.git "$DOTFILES_DIR"
else
  echo "Dot-Files repo already exists. Updating..."
  git -C "$DOTFILES_DIR" pull
fi

# List available themes
echo ""
echo "Available themes:"
THEMES=($(ls -1 "$ARCH_DIR"))
for i in "${!THEMES[@]}"; do
  echo "[$i] ${THEMES[$i]}"
done
echo "[q] Cancel and return"

# Prompt for selection
echo ""
read -p "Select a theme to install [0-${#THEMES[@]} or q]: " CHOICE

# Cancel option
if [[ "$CHOICE" == "q" ]]; then
  echo "Theme installation canceled."
  exit 0
fi

# Check valid choice
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || (( CHOICE < 0 || CHOICE >= ${#THEMES[@]} )); then
  echo "Invalid selection."
  exit 1
fi

SELECTED_THEME="${THEMES[$CHOICE]}"
THEME_PATH="$ARCH_DIR/$SELECTED_THEME"

echo "Installing theme: $SELECTED_THEME"

# Make sure ~/.config exists
mkdir -p "$HOME/.config"

# Copy theme files to ~/.config
cp -r "$THEME_PATH/"* "$HOME/.config/"

# Reload Hyprland if available
if command -v hyprctl &> /dev/null; then
  echo "Reloading Hyprland config..."
  hyprctl reload
fi

# Reload Waybar only
echo "Reloading Waybar..."
killall waybar 2>/dev/null || true
if command -v waybar &> /dev/null; then
  nohup waybar > /dev/null 2>&1 &
fi

echo "Theme '$SELECTED_THEME' installed."
echo "Please log out or reboot to apply full theme changes."

