#!/bin/bash

packages=(
  wget
  git
  viewnior
  cliphist
  mpv
  mpvpaper
  swww
  ttf-font-awesome
  ttf-jetbrains-mono-nerd
  wireplumber
  pavucontrol
  playerctl
  blueman
  networkmanager
  network-manager-applet
  thunar
  catppuccin-cursors-mocha
  cups
  system-config-printer
  print-manager
  rocm-smi-lib
  lm_sensors
  7zip
  wine
  ark
  spectacle
  timeshift
  fastfetch
  btop
  coolercontrol
)

echo "Installing system utilities..."
for package in "${packages[@]}"; do
  yay -S --noconfirm --needed "$package"
done

echo
echo "Attempting to enable system services..."

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

enable_service "networkmanager"
enable_service "bluetooth.service"
enable_service "cups"

# Prompt user before running sensors-detect
echo "Running fan and thermal sensor detection (lm_sensors)"
read -rp "This will prompt for several yes/no hardware questions. Run now? [y/N]: " run_sensors
if [[ "$run_sensors" =~ ^[Yy]$ ]]; then
  sudo sensors-detect
else
  echo "Skipped sensors-detect."
fi

echo "System utilities setup complete."

