#!/bin/bash

choice=$(printf "  Power Off\n  Reboot\n  Log Out\n  Lock" | wofi --dmenu --width 300 --height 250 --cache-file /dev/null)

case "$choice" in
    "  Power Off") systemctl poweroff ;;
    "  Reboot") systemctl reboot ;;
    "  Log Out") hyprctl dispatch exit ;;
    "  Lock") hyprlock ;;
esac
