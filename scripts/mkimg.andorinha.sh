profile_andorinha() {
	profile_base
	profile_abbrev="and"
	title="Andorinha"
	desc="Andorinha Linux - leve, rapido, roda na RAM"
	image_ext="iso"
	output_format="iso"
	arch="x86 x86_64"
	kernel_flavors="lts"
	hostname="andorinha"
	# o mkimage procura o arquivo relativo a pasta scripts/
	apkovl="genapkovl-andorinha.sh"
	# so o que a Andorinha precisa (substitui a lista padrao, que traz openssh, chrony etc.)
	local _dir="$(readlink -f "$scriptdir")"
	apks="$(grep -v '^#' "$_dir/packages.txt" | tr '\n' ' ')"
}
