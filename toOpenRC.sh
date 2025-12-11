#!/usr/bin/env bash

cat << EOF >> /etc/pacman.conf
[arch-openrc]
SigLevel=Never
Server=http://downloads.sourceforge.net/project/archopenrc/\$repo/\$arch
Server=ftp://ftp.heanet.ie/mirrors/sourceforge/a/ar/archopenrc/\$repo/\$arch
Server=http://archbang.org/archopenrc/\$repo/\$arch

[arch-nosystemd]
SigLevel=Never
Server=http://downloads.sourceforge.net/project/archopenrc/\$repo/\$arch
Server=ftp://ftp.heanet.ie/mirrors/sourceforge/a/ar/archopenrc/\$repo/\$arch
Server=http://archbang.org/archopenrc/\$repo/\$arch
EOF

pacman -Syy openrc-keyring openrc-mirrorlist
pacman-key --populate openrc

sed -e :a -e '$d;N;2,11ba' -e 'P;D' -i /etc/pacman.conf		# remove the last 11 previously added lines
pacman -Sw repo-openrc
pacman -Udd /var/cache/pacman/pkg/repo-openrc-*.any.pkg.tar.xz	# this workaround is needed due to systemd-conflicting deps
cat << EOF >> /etc/pacman.conf

[openrc-eudev]
SigLevel=PackageOptional
Server=http://downloads.sourceforge.net/project/archopenrc/\$repo/\$arch
Server=ftp://ftp.heanet.ie/mirrors/sourceforge/a/ar/archopenrc/\$repo/\$arch
EOF

systemctl list-units --state=running | grep -v systemd | awk '{print $1}' | grep service > daemon.list

pacman -Sy
pacman -Sl arch-openrc arch-nosystemd
pacman -Sw sysvinit openrc eudev udev-openrc eudev-systemd libeudev-systemd dbus-openrc dbus-nosystemd procps-ng-nosystemd syslog-ng-nosystemd

pacman -Rdd systemd libsystemd

pacman -S sysvinit openrc eudev udev-openrc eudev-systemd libeudev-systemd

