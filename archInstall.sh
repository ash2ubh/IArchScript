#!/usr/bin/env bash

bash https://archinstall.ash2ubh.xyz/01-Install.sh
bash arch-chroot /mnt https://archinstall.ash2ubh.xyz/02-Chroot.sh ${1}

umount -IR /mnt