#!/bin/bash


echo ''
echo '███████╗██╗  ██╗██████╗ ██████╗  █████╗'
echo '██╔════╝██║  ██║██╔══██╗██╔══██╗██╔══██╗'
echo '███████╗██║  ██║██████╔╝██████╔╝███████║'
echo '╚════██║██║  ██║██╔═══╝ ██╔══██╗██╔══██║'
echo '███████║╚█████╔╝██║     ██║  ██║██║  ██║'
echo '╚══════╝ ╚════╝ ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝'
echo ''

# install meson or ninja if not exist

if ! [ -x "$(command -v meson)" ] || ! [ -x "$(command -v ninja)" ]; then 
	echo "meson not found, installing..."
	pip install meson ninja --user
fi

export PATH=$PATH:$HOME/.local/bin

if ! [ -x "$(command -v meson)" ] || ! [ -x "$(command -v ninja)" ]; then 
	echo "meson install failed, please install manually"
	echo ""
	echo "	Ubuntu    (apt install meson ninja-build)"
	echo "	Fedora    (dnf install meson ninja-build)"
	echo "	ArchLinux (pacman -S meson ninja)"
	exit 1
fi
	
# build if build/build.ninja doesnt exist

if [ ! -f build/build.ninja ]; then
	echo "building..."
	meson build --prefix="$PWD" --bindir='' --buildtype=release
fi
ninja install -C build
