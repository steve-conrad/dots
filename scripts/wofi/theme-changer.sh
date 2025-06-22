#!/bin/bash

DOTFILES_DIR="$HOME/dots"
THEME_DIR="$DOTFILES_DIR/arch/themes"

mapfile -t THEMES < <(ls -1 "$THEME_DIR")

THEME_MENU=$(printf "%s\n" "${THEMES[@]}" | wofi --dmenu --width 300 --height 400 --cache-file /dev/null --prompt "Select a theme")

[[ -z "$THEME_MENU" ]] && exit 0

SELECTED_THEME="$THEME_MENU"
THEME_PATH="$THEME_DIR/$SELECTED_THEME"

echo "Installing theme: $SELECTED_THEME"

cp -r "$THEME_PATH/"* "$HOME/.config/"

if command -v hyprctl &> /dev/null; then
  echo "Reloading Hyprland config..."
  hyprctl reload
fi

chmod +x ~/.config/waybar/scripts/mediaplayer.py

echo "Reloading Waybar..."
killall waybar 2>/dev/null || true
if command -v waybar &> /dev/null; then
  nohup waybar > /dev/null 2>&1 &
fi

echo "Reloading Hyprpaper..."
killall hyprpaper 2>/dev/null || true
if command -v hyprpaper &> /dev/null; then
  nohup hyprpaper > /dev/null 2>&1 &
fi

notify-send "Theme Changed" "Theme '$SELECTED_THEME' applied."
