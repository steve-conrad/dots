#!/bin/bash

set -euo pipefail
IFS=$'\n\t'
source ./functions.sh
source ./packages.sh

while true; do
  echo "Which desktop environment/window manager would you like to install?"
  echo "  1) Hyprland (UWSM)/systemd autologin"
  echo "  2) KDE Plasma/sddm"
  echo "  3) GNOME/gdm"
  echo -n "Enter 1, 2, or 3: "
  read -r DE_CHOICE

  case "$DE_CHOICE" in
    1)
      echo "Installing Hyprland and related packages..."
      install_packages "${hypr_packages[@]}"
      echo "Hyprland and supporting packages installed."

      # Enable waybar user service safely
      enable_user_service "waybar.service"

      # Ask about .bash_profile update
      read -rp "Apply autostart changes to ~/.bash_profile? [y/N]: " apply_bash_profile
      if [[ "$apply_bash_profile" =~ ^[Yy]$ ]]; then
        BASH_PROFILE="$HOME/.bash_profile"
        if ! grep -q "uwsm check may-start" "$BASH_PROFILE"; then
          cat >> "$BASH_PROFILE" << 'EOF'

# Start Hyprland via uwsm if available
if uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi
EOF
          echo "Appended autostart lines to ~/.bash_profile"
        else
          echo "~/.bash_profile already contains Hyprland autostart logic."
        fi
      else
        echo "Skipped ~/.bash_profile changes."
      fi

      # Ask about systemd autologin
      read -rp "Enable systemd autologin on tty1 for Hyprland? [y/N]: " apply_getty
      if [[ "$apply_getty" =~ ^[Yy]$ ]]; then
        while true; do
          read -rp "Enter your username for autologin setup: " username1
          read -rp "Confirm username: " username2
          if [[ -z "$username1" ]]; then
            echo "Username was empty. Please enter a valid username."
          elif [[ "$username1" != "$username2" ]]; then
            echo "Usernames did not match. Please try again."
          else
            username="$username1"
            break
          fi
        done

        sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
        sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin ${username} --noclear %I \$TERM
EOF

        sudo systemctl daemon-reexec || echo "Warning: Failed to reload systemd daemon"
        sudo systemctl restart getty@tty1 || echo "Warning: Failed to restart getty@tty1 service"
        echo "Enabled systemd autologin for user: $username"
      else
        echo "Skipped getty@tty1 autologin configuration."
      fi
      ;;

    2)
      echo "Installing KDE Plasma and SDDM..."
      install_packages "${kde_packages[@]}"
      echo "KDE Plasma and SDDM installed."
      ;;

    3)
      echo "Installing GNOME, GDM, and gnome-tweaks..."
      install_packages "${gnome_packages[@]}"
      echo "GNOME and GDM installed."
      ;;

    *)
      echo "Invalid choice. Please enter 1, 2, or 3."
      continue
      ;;
  esac

  break
done

