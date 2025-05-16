#!/bin/bash

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
