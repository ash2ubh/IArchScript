#!/usr/bin/env bash

echo -ne "
#########################################################
#                    Arch Installation                  #
#########################################################
"
pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode nano sudo make cmake bluez bluez-utils networkmanager dhclient cargo gcc pipewire wget curl git glibc grub efibootmgr dosfstools mtools --noconfirm --needed

genfstab -U /mnt >> /mnt/etc/fstab
echo " 
  Generated /etc/fstab:
"
cat /mnt/etc/fstab

