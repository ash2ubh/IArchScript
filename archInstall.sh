#!/usr/bin/env bash

echo -ne "Pre Installation"

# source $CONFIGS_DIR/setup.conf
# iso=$(curl -4 ifconfig.co/country-iso)
# timedatectl set-ntp true
# pacman -S --noconfirm archlinux-keyring 
# pacman -S --noconfirm --needed pacman-contrib terminus-font
# setfont ter-v22b
# sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
# pacman -S --noconfirm --needed reflector rsync grub
# cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

# reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
# mkdir /mnt &>/dev/null