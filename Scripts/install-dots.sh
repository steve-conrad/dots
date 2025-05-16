#Create config folders and install config
# Clone your dotfiles repo
git clone https://github.com/steve-conrad/Dot-Files.git ~/Dot-Files
# Make sure the .config directory exists
mkdir -p ~/.config
# Copy the dotfiles from your repo
cp -r ~/Dot-Files/Arch/.config/* ~/.config/
# Clean up cloned repo
rm -rf ~/Dot-Files


