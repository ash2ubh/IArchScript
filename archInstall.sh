#!/usr/bin/env bash

bash curl https://archinstall.ash2ubh.xyz/01-Install.sh
bash arch-chroot /mnt curl https://archinstall.ash2ubh.xyz/02-Chroot.sh ${1}

umount -IR /mnt