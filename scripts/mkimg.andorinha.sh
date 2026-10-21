profile_andorinha() {
	profile_standard
	profile_abbrev="and"
	title="Andorinha"
	desc="Andorinha Linux - leve, rapido, roda na RAM"
	arch="x86 x86_64"
	kernel_flavors="lts"
	kernel_cmdline="modules=loop,squashfs,sd-mod,usb-storage quiet"
	local _dir="$(dirname "$(readlink -f "$0")")"
	apks="$apks $(grep -v '^#' "$_dir/packages.txt" | tr '\n' ' ')"
	local _k
	for _k in $kernel_flavors; do apks="$apks linux-$_k"; done
	apkovl="$_dir/genapkovl-andorinha.sh"
}
