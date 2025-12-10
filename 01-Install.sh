echo -ne "
#########################################################
#                    Arch Installation                  #
#########################################################
"
pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode nano sudo make cmake bluez bluez-utils networkmanager dhclient cargo gcc pipewire wget curl git glibc --noconfirm --needed

genfstab -U /mnt >> /mnt/etc/fstab
echo " 
  Generated /etc/fstab:
"
cat /mnt/etc/fstab

arch-root /mnt
passwd

useradd -m -g users -G wheel,storage,video,audio -s /bin/bash ${1}
passwd ${1}
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers.tmp

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
hwclock --systohc

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
cat /etc/locale.conf

echo "${1}" > /etc/hostname
echo -e "127.0.1.1\t${1}.localdomain\t${1}" > /etc/hosts

systemctl enable --now NetworkManager
systemctl enable --now bluetooth

exit

umount -IR /mnt