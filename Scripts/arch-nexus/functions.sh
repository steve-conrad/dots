#!/bin/bash

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


