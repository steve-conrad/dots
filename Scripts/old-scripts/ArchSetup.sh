#Arch Driver and App Installs

#This script has been written to run line by line and to explain what each install actually is.

##---Firmware and Driver Config---##

#Update the system
sudo pacman -Syu

#Install Radeon Drivers
sudo pacman -S mesa
sudo pacman -S lib32-mesa
sudo pacman -S vulkan-radeon

#Install Nvidia Drivers and utilities
#sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils
#Install Vulkan
#sudo pacman -S vulkan-icd-loader
#sudo pacman -S lib32-vulkan-icd-loader

#Install and enable bluetooth
sudo pacman -S bluez
sudo pacman -S bluez-utils
#Start bluetooth service
sudo systemctl start bluetooth.service

#Install printer support packages
sudo pacman -S cups
sudo pacman -S system-config-printer
sudo pacman -S print-manager
#Enable printer service
systemctl start cups
systemctl enable cups

##---Software Installs---##
sudo pacman -S firefox
#Terminal Emulator
sudo pacman -S kitty
#Text Editor
sudo pacman -S neovim
#File manager
sudo pacman -S thunar
#Gaming
sudo pacman -S steam
#Commandline system info
sudo pacman -S fastfetch
#Run windows apps
sudo pacman -S wine
#Chat client
sudo pacman -S discord
#yay -S vesktop
#File extracting/compression
sudo pacman -S 7zip
#Ark is a program for managing various compressed file formats within KDE
sudo pacman -S ark
#Screenshots
sudo pacman -S spectacle
#System snapshots/restore
sudo pacman -S timeshift
#Network utility to retrieve files from the web
sudo pacman -S wget
sudo pacman -S git
#Desktop environments
sudo pacman -S hyprland
#sudo pacman -S plasma
#Photo viewer
sudo pacman -S viewnior


#System Monitoring
#Drivers/Tools
sudo pacman -S lm_sensors
##Commandline monitor
sudo pacman -S btop
#Enable GPU for btop
sudo pacman -S rocm-smi-lib

#Monitoring/Fan Control
yay -S coolercontrol

##---Repositories---##

##-Run each command to add the Yay repo-##
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

#Configure Fan Controls (Using Cooler Control)
sudo sensors-detect #run this and follow prompts (hit enter for defaults). This will find all fan controllers.

