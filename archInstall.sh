#!/usr/bin/env bash

bash curl https://archinstall.ash2ubh.xyz/01-Install.sh
arch-chroot /mnt bash curl https://archinstall.ash2ubh.xyz/02-Chroot.sh ${1}

umount -IR /mnt