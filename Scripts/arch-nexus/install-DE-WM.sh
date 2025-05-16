#!/bin/bash

while true; do
  echo "Which desktop environment and display manager do you want to install?"
  echo "  1) Hyprland - Systemd auto-login"
  echo "  2) KDE Plasma - SDDM"
  echo "  3) GNOME - GDM"
  echo -n "Enter 1, 2, or 3: "
  read -r DE_CHOICE

  case "$DE_CHOICE" in
    1)
      echo "🛠 Installing Hyprland..."
      packages=(
        hyprland
        waybar
        wofi
        swaync
        hyprshot
        hyprlock
        hypridle
        xdg-desktop-portal-hyprland
        hyprpolkitagent
      )

      for package in "${packages[@]}"; do
        yay -S --noconfirm --needed "$package"
      done

      echo "🛠 Configuring Hyprland autologin on TTY..."

      # Step 1: Append uwsm check to ~/.bash_profile
      BASH_PROFILE="$HOME/.bash_profile"
      if ! grep -q "uwsm check may-start" "$BASH_PROFILE"; then
        cat >> "$BASH_PROFILE" << 'EOF'

# Start Hyprland via uwsm if available
if uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi
EOF
        echo "✅ Appended autostart lines to ~/.bash_profile"
      else
        echo "ℹ️  ~/.bash_profile already contains Hyprland autostart logic."
      fi

      # Step 2: Create a systemd override for getty@tty1
      while true; do
        read -rp "Enter your username for autologin setup: " username1
        read -rp "Confirm username for autologin setup: " username2
        if [[ -z "$username1" ]]; then
          echo "❌ Username was empty. Please enter a valid username."
        elif [[ "$username1" != "$username2" ]]; then
          echo "❌ Usernames did not match. Please try again."
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

      sudo systemctl daemon-reexec
      sudo systemctl restart getty@tty1

      echo "✅ Enabled systemd autologin for user: $username"
      ;;

    2)
      echo "🛠 Installing KDE Plasma..."
      yay -S --noconfirm sddm plasma-desktop
      ;;

    3)
      echo "🛠 Installing GNOME..."
      yay -S --noconfirm gdm gnome gnome-tweaks
      ;;

    *)
      echo "❌ Invalid choice. Please enter 1, 2, or 3."
      ;;
  esac

  break
done

