#!/usr/bin/env bash

echo -ne "Pre Installation"

setfont ter-120n

if ! ping -c 5 google.com &> /dev/null; then
    echo -ne "Connect the internet with command:\n"
    echo -ne "- iwctl\n"
    echo -ne "- device list\n"
    echo -ne "- station DeviceName get-networks\n"
    echo -ne "- station DeviceName connect NetworkNames\n"
    echo -ne "- exit\n"
    
    exit 1
fi

iso=$(curl -4 ifconfig.co/country-iso)
timedatectl set-ntp true

pacman -Sy 
pacman -S --noconfirm archlinux-keyring archinstall
pacman -S --noconfirm --needed pacman-contrib

sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
pacman -S --noconfirm --needed reflector rsync grub
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
mkdir /mnt &>/dev/null 

echo -ne "Partition Pre Setup command:\n"
echo -ne "- lsblk\n"
echo -ne "- gdisk /dev/sda/... input x, then z, then Y, then Y\n"
echo -ne "- cfdisk /dev/... then create EFI and Linux Filesystem and Linux Swap\n"
echo -ne "- done\n"