#!/bin/bash

choice=$(printf "  Shutdown\n  Restart\n  Logout\n  Lock" | wofi --dmenu --width 300 --height 410 --cache-file /dev/null)

case "$choice" in
    "  Shutdown") systemctl poweroff ;;
    "  Restart") systemctl reboot ;;
    "  Logout") hyprctl dispatch exit ;;
    "  Lock") hyprlock ;;
esac
