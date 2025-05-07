##Hyprland Setup##

#################
#Useful Commands#
#################

#View Monitors for setting resolution/scale/refresh rate: hyprctl monitors all
#Edit hyprland config: vim /home/steve/.config/hypr/hyprland.conf

##############
#Install Apps#
##############

#App Launcher
sudo pacman -S wofi
#Fonts
sudo pacman -S ttf-font-awesome
#Notifications
sudo pacman -S swaync
#Screenshots
sudo pacman -S hyprshot #or yay -S hyprshot
#Lockscreen
sudo pacman -S hyprlock
#System idle manager
sudo pacman -S hypridle
#Audio
sudo pacman -S wireplumber
sudo pacman -S pavucontrol
#Additional compatibility
sudo pacman -S xdg-desktop-portal-hyprland
#Authentication
sudo pacman -S hyprpolkitagent
#Media Commands
sudo pacman -S playerctl
#Bluetooth Management
sudo pacman -S blueman
#Network Management
sudo pacman -S networkmanager
sudo pacman -S network-manager-applet
#File Manager
sudo pacman -S thunar
#Set Thunar as the default file manager for XDG
xdg-mime default thunar.desktop inode/directory
#Clipboard History
sudo pacman -S cliphist

#Menu bars
#Waybar -
sudo pacman -S waybar

##Video player
sudo pacman -S mpv

#Enable bluetooth services
sudo systemctl enable bluetooth
#Enable network services
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
#Enable waybar service to launch waybar (UWSM)
systemctl --user enable --now waybar.service

#Wallpapers
#Video Wallpapers
yay -S mpvpaper
#Gif or static wallpapers
sudo pacman -S swww

#Make detect_idle script executable to detect borderless fullscreen apps in Hypridle
chmod +x ~/.config/hypr/detect_borderless.sh

#Fix KDE/Dolphin file association issues
#sudo pacman -S archlinux-xdg-menu
#XDG_MENU_PREFIX=arch- kbuildsycoca6
#Add to hyprland config file if needed: env = XDG_MENU_PREFIX,arch-

#Create config folders
#touch ~/.config/waybar/config
#touch ~/.config/hypr/hyprpaper.conf
#touch ~/.config/hypr/hyprlock.conf

############################
###Enable Systemd Startup###
############################

#Step 1: Create or update ~/.bash_profile
# Add these lines to the end of the file:

# if uwsm check may-start; then
#     exec uwsm start hyprland.desktop
# fi


#Step 2:Create a systemd override:
#sudo systemctl edit getty@tty1
#
#Paste this and replace "yourusername":
#[Service]
#ExecStart=
#ExecStart=-/usr/bin/agetty --autologin yourusername --noclear %I $TERM
