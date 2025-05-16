# 📁 Create config folders and install config
DOTFILES_DIR="$HOME/Dot-Files"

# Check if the Dot-Files repo already exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repo..."
  git clone https://github.com/steve-conrad/Dot-Files.git "$DOTFILES_DIR"
  CLONED=true
else
  echo "Dot-Files repo already exists. Skipping clone."
  CLONED=false
fi

# Make sure ~/.config exists
mkdir -p "$HOME/.config"

# Copy dotfiles
echo "Copying configs to ~/.config..."
cp -r "$DOTFILES_DIR/Arch/.config/"* "$HOME/.config/"

# Clean up if we cloned it in this session
if [ "$CLONED" = true ]; then
  echo "Cleaning up cloned repo..."
  rm -rf "$DOTFILES_DIR"
fi

echo "Dotfiles installed."

