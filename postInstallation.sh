#!/usr/bin/env bash

if ! ping -c 5 google.com &> /dev/null; then
    echo -ne "Connect the internet with command:\n"
    echo -ne "- iwctl\n"
    echo -ne "- device list\n"
    echo -ne "- station DeviceName get-networks\n"
    echo -ne "- station DeviceName connect NetworkNames\n"
    echo -ne "- exit\n"
    
    exit 1
fi

pacman -S --noconfirm --needed pacman-contrib curl
pacman -S --noconfirm --needed reflector rsync grub arch-install-scripts git
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak


#Add parallel downloading
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm --needed

check_pkg_i(){
    if pacman -Qi "${1}" &>/dev/null; then
        return 0
    else 
        return 1
    fi
}

check_svc(){
    if [[ $(systemctl list-units --all -t service --full --no-legend "${1}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${1}.service" ]]; then
        return 0
    else
        return 1
    fi 
}

###############
# Chaotic-AUR #
###############
if ! check_pkg_i "chaotic-mirrorlist"; then
    printf "\n%s - Start Install and Configuration Chaotic AUR \n"
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com 
    sudo pacman-key --lsign-key 3056513887B78AEB 
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

    sudo echo -e '\n# Chaotic Aur\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf
    printf "\n%s - Finish Install and Configuration Chaotic AUR \n"

    printf "\n%s - Start full system update along syncing our mirrorlist \n"
    sudo pacman -Syu --noconfirm
    printf "\n%s - Finish update along syncing our mirrorlist \n"
else
    printf "\n%s - Chaotic AUR is Already Exist \n"
fi

#######
# Yay #
#######
if ! check_pkg_i "yay"; then
    printf "\n%s - Start Install Yay \n"
    sudo pacman -S yay --noconfirm
    printf "\n%s - Finish Install Yay \n"
else 
    printf "\n%s - Yay is Already Exist \n"
fi

########################
# Base-devel & Keyring #
########################
base_key_lst=(
    base-devel 
    archlinux-keyring
)
printf "\n%s - Start Install base-devel & archlinux-keyring \n"
for PKG in "${base_key_lst[@]}"; do
    printf "\n%s - Start Install "$PKG" \n"
    sudo pacman -S --noconfirm "$PKG" 
    printf "\n%s - Finished Install "$PKG" \n"
done
printf "\n%s - Finish Install base-devel & archlinux-keyring \n"

# pacman -S --noconfirm --needed nvidia-xconfig
# pacman -S --noconfirm --needed libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
# pacman -S --noconfirm --needed fastfetch htop 
