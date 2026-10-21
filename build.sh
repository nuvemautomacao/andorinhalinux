#!/bin/sh -e
# Uso: sh build.sh 3.22 x86_64
VER="${1:?informe a versao do Alpine, ex: 3.22}"
ARCH="${2:-x86_64}"
HERE="$(cd "$(dirname "$0")" && pwd)"
[ -d "$HOME/aports" ] || git clone --depth=1 --branch "${VER}-stable" https://gitlab.alpinelinux.org/alpine/aports.git "$HOME/aports"
cp -a "$HERE/scripts/." "$HOME/aports/scripts/"
chmod +x "$HOME/aports/scripts/"*.sh
cd "$HOME/aports/scripts"
sh mkimage.sh --tag "$VER" --outdir "$HOME/iso" --arch "$ARCH" \
  --repository "https://dl-cdn.alpinelinux.org/alpine/v${VER}/main" \
  --repository "https://dl-cdn.alpinelinux.org/alpine/v${VER}/community" \
  --profile andorinha
echo "ISO em $HOME/iso"
