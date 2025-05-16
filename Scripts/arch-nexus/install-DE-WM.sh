#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Helper function to install packages with yay and report errors but continue
install_packages() {
  local pkgs=("$@")
  for pkg in "${pkgs[@]}"; do
    echo "Installing package: $pkg"
    if ! yay -S --noconfirm --needed "$pkg"; then
      echo "Warning: Failed to install package $pkg. Continuing..."
    fi
  done
}

# Helper to enable and start a systemd user service if it exists
enable_user_service() {
  local svc=$1
  if systemctl --user list-unit-files | grep -q "^${svc}"; then
    if systemctl --user enable --now "$svc"; then
      echo "Enabled and started $svc"
    else
      echo "Warning: Failed to enable/start $svc"
    fi
  else
    echo "Warning: Service $svc not found, skipping enable/start"
  fi
}

while true; do
  echo "Which desktop environment and display manager do you want to install?"
  echo "  1) Hyprland - Systemd auto-login (optional)"
  echo "  2) KDE Plasma - SDDM"
  echo "  3) GNOME - GDM"
  echo -n "Enter 1, 2, or 3: "
  read -r DE_CHOICE

  case "$DE_CHOICE" in
    1)
      echo "Installing Hyprland and related packages..."
      packages=(
        hyprland
        uwsm
        waybar
        wofi
        swaync
        hyprshot
        hyprlock
        hypridle
        xdg-desktop-portal-hyprland
        hyprpolkitagent
      )
      install_packages "${packages[@]}"
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
      install_packages plasma-desktop sddm
      echo "KDE Plasma and SDDM installed."
      ;;

    3)
      echo "Installing GNOME, GDM, and gnome-tweaks..."
      install_packages gnome gdm gnome-tweaks
      echo "GNOME and GDM installed."
      ;;

    *)
      echo "Invalid choice. Please enter 1, 2, or 3."
      continue
      ;;
  esac

  break
done

