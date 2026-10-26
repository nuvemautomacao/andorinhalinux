#!/bin/sh -e
HOSTNAME="$1"
[ -n "$HOSTNAME" ] || { echo "uso: $0 hostname"; exit 1; }
DIR="$(dirname "$(readlink -f "$0")")"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

rc_add() { mkdir -p "$tmp/etc/runlevels/$2"; ln -sf "/etc/init.d/$1" "$tmp/etc/runlevels/$2/$1"; }

cp -a "$DIR/overlay/." "$tmp/"
mkdir -p "$tmp/etc/apk" "$tmp/etc/network"

# o repositorio guarda esses arquivos sem ponto (upload pelo navegador ignora nomes ocultos)
mv "$tmp/root/dot-profile" "$tmp/root/.profile"
mv "$tmp/root/dot-xinitrc" "$tmp/root/.xinitrc"
mv "$tmp/root/dot-config" "$tmp/root/.config"
chmod +x "$tmp/usr/local/bin/autologin" "$tmp"/etc/local.d/*.start
echo "$HOSTNAME" > "$tmp/etc/hostname"
grep -v '^#' "$DIR/packages.txt" > "$tmp/etc/apk/world"
printf 'auto lo\niface lo inet loopback\n' > "$tmp/etc/network/interfaces"

for s in devfs dmesg hwdrivers udev udev-trigger udev-settle; do rc_add $s sysinit; done
for s in modules sysctl hostname bootmisc syslog; do rc_add $s boot; done
for s in local; do rc_add $s default; done
for s in mount-ro killprocs savecache; do rc_add $s shutdown; done

tar -c -C "$tmp" . | gzip -9n > "$HOSTNAME.apkovl.tar.gz"
