#!/bin/sh -e
# Uso: sh build.sh 3.22 x86_64
VER="${1:?informe a versao do Alpine, ex: 3.22}"
ARCH="${2:-x86_64}"
HERE="$(cd "$(dirname "$0")" && pwd)"

# So precisamos da pasta "scripts" do aports. O GitLab do Alpine as vezes nao responde
# para os servidores do GitHub, entao usamos o espelho no GitHub (e o GitLab so como reserva).
if [ ! -d "$HOME/aports/scripts" ]; then
  rm -rf "$HOME/aports"
  for URL in https://github.com/alpinelinux/aports.git https://gitlab.alpinelinux.org/alpine/aports.git; do
    echo ">> baixando aports de $URL"
    if timeout 120 git clone --depth=1 --filter=blob:none --sparse --branch "${VER}-stable" "$URL" "$HOME/aports"; then
      git -C "$HOME/aports" sparse-checkout set scripts
      break
    fi
    rm -rf "$HOME/aports"
  done
fi
[ -f "$HOME/aports/scripts/mkimage.sh" ] || { echo "ERRO: nao consegui baixar o aports"; exit 1; }

cp -a "$HERE/scripts/." "$HOME/aports/scripts/"
chmod +x "$HOME/aports/scripts/"*.sh
cd "$HOME/aports/scripts"
sh mkimage.sh --tag "$VER" --outdir "$HOME/iso" --arch "$ARCH" \
  --repository "https://dl-cdn.alpinelinux.org/alpine/v${VER}/main" \
  --repository "https://dl-cdn.alpinelinux.org/alpine/v${VER}/community" \
  --profile andorinha
echo "ISO em $HOME/iso"
