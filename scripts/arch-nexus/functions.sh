#!/bin/bash

source ./packages.sh

# Install packages and report errors
install_packages() {
  local pkgs=("$@")
  for pkg in "${pkgs[@]}"; do
    echo "Installing package: $pkg"
    if ! yay -S --noconfirm --needed "$pkg"; then
      echo "Warning: Failed to install package $pkg. Continuing..."
    fi
  done
}

# Enable and start a systemd user service if it exists
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

# Function to safely start and enable services
enable_service() {
  local service=$1
  echo "Enabling $service..."

  if systemctl list-unit-files | grep -q "^${service}"; then
    if sudo systemctl start "$service"; then
      echo "Started $service"
    else
      echo "Failed to start $service"
    fi

    if sudo systemctl enable "$service"; then
      echo "Enabled $service to start at boot"
    else
      echo "Failed to enable $service"
    fi
  else
    echo "Service '$service' not found. Skipping."
  fi
  echo
}


#Prompt DE/WM choice
install_de_wm() {

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
ExecStart=-/usr/bin/agetty --autologin "${username}" --noclear %I \$TERM
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

}


#Install GPU Driver
install_gpu_driver() {
while true; do
  echo "Which GPU driver do you want to install?"
  echo "  1) AMD"
  echo "  2) NVIDIA"
  echo "  3) Skip"
  echo -n "Enter 1, 2, or 3: "
  read -r GPU_CHOICE

  case "$GPU_CHOICE" in
    1)
      echo "🛠 Installing AMD GPU drivers..."
      sudo pacman -S --needed mesa lib32-mesa vulkan-radeon
      break
      ;;
    2)
      echo "🛠 Installing NVIDIA GPU drivers..."
      sudo pacman -S --needed nvidia nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader
      break
      ;;
    3)
      echo "⚠ Skipping GPU driver installation."
      break
      ;;
    *)
      echo "❌ Invalid choice. Please enter 1, 2, or 3."
      ;;
  esac
done
}


#Install Dots
install_dots() {

DOTFILES_DIR="$HOME/dots"
THEME_DIR="$DOTFILES_DIR/arch/themes"

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
THEMES=($(ls -1 "$THEME_DIR"))
for i in "${!THEMES[@]}"; do
  echo "[$i] ${THEMES[$i]}"
done
echo "[q] Quit"

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
THEME_PATH="$THEME_DIR/$SELECTED_THEME"

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

# Enable waybar mediaplayer
chmod +x ~/.config/waybar/mediaplayer.py

# Reload Waybar only
echo "Reloading Waybar..."
killall waybar 2>/dev/null || true
if command -v waybar &> /dev/null; then
  nohup waybar > /dev/null 2>&1 &
fi

echo "Theme '$SELECTED_THEME' installed."
echo "Please log out or reboot to apply full theme changes."

}
