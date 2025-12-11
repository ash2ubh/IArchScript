#!/usr/bin/env bash

TARGET_DISK="$1"
HOSTNAME="$2"
USERNAME="$3"
PASSWORD="$4"
TIMEZONE="$5"

BOOT_PART="1"
ROOT_PART="2"
SWAP_PART="3"

check_internet_connection(){
    if ! ping -c 5 google.com &> /dev/null; then
        echo -ne "Connect the internet with command:\n"
        echo -ne "- iwctl\n"
        echo -ne "- device list\n"
        echo -ne "- station DeviceName get-networks\n"
        echo -ne "- station DeviceName connect NetworkNames\n"
        echo -ne "- exit\n"
    
        exit 1
    else
        echo -ne "- Connected.\n"
    fi
}

format_partition(){
    echo "Start formatting partitions..."

    mkfs.fat -F32 "${TARGET_DISK}${BOOT_PART}"
    mkfs.ext4 "${TARGET_DISK}${ROOT_PART}" 

    mkswap "${TARGET_DISK}${SWAP_PART}"
    swapon "${TARGET_DISK}${SWAP_PART}"

    mount "${TARGET_DISK}${ROOT_PART}" /mnt
    mkdir -p /mnt/boot
    mount "${TARGET_DISK}${BOOT_PART}" /mnt/boot

    echo "Finished formatting partitions."
}

install_base(){
    echo "Start Installing base system..."

    pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode nano sudo make cmake man-db man-pages texinfo bluez bluez-utils networkmanager network-manager-applet dhclient openssh cargo gcc pipewire alsa-utils pipewire-pulse pipewire-jack sof-firmware wget curl git glibc grub efibootmgr dosfstools mtools iptable-nft ipset acpid --noconfirm --needed

    echo "Finished Installing base system."
}

generate_fstab(){
    echo "Start Generating fstab..."

    genfstab -U /mnt >> /mnt/etc/fstab
    echo "Generated /etc/fstab:"
    cat /mnt/etc/fstab

    echo "Finished Generating fstab."

}

arch_chroot(){
    echo "Start Configuring system..."

    cat > /mnt/chroot_script.sh << EOF
TARGET_DISK="$TARGET_DISK"
HOSTNAME="$HOSTNAME"
USERNAME="$USERNAME"
PASSWORD="$PASSWORD"
TIMEZONE="$TIMEZONE"

echo "root:\$PASSWORD" | chpasswd
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

useradd -m -G wheel,audio,video,storage,optical -s /bin/bash "\$USERNAME"
echo "\$USERNAME:\$PASSWORD" | chpasswd
mkdir -m 755 /etc/sudoers.d
echo "\$USERNAME ALL=(ALL) ALL" > /etc/sudoers.d/\$USERNAME
chmod 0440 /etc/sudoers.d/\$USERNAME

ln -sf /usr/share/zoneinfo/\$TIMEZONE /etc/localtime
hwclock --systohc

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
cat /etc/locale.conf

echo "KEYMAP=us" >> /etc/vconsole.conf

echo "\$HOSTNAME" > /etc/hostname
cat > /etc/hosts << HOSTS_EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   \$HOSTNAME.localdomain \$HOSTNAME
HOSTS_EOF

grub-install --target=x86_64-efi --efi-directory=\$TARGET_DISK --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable --now NetworkManager
systemctl enable --now bluetooth

EOF

    chmod +x /mnt/chroot_script.sh
    arch-chroot /mnt /chroot_script.sh
    rm /mnt/chroot_script.sh

    echo "Finished Configuring system."
}

result_installation(){
    
    umount -R /mnt

    echo -ne "
    ###########################################################
    #           Arch Linux Installation Completed             #
    ###########################################################
    "

    echo "Hostname: $HOSTNAME"
    echo "Username: $USERNAME"
    echo "Password: $PASSWORD"
    echo "Timezone: $TIMEZONE"

}

main(){
    echo "Starting Arch Linux installation..."

    check_internet_connection
    format_partition
    install_base
    generate_fstab
    arch_chroot
    result_installation

    echo "Finished Arch Linux installation."
}

main "$@"