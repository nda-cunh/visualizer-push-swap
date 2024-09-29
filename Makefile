# a Makefile using meson and ninja to build the project

all: build/build.ninja
	ninja -C build
	ninja install -C build

build/build.ninja:
	meson build --prefix="$(PWD)" --bindir="" --optimization=3 --buildtype=release

uninstall:
	ninja uninstall -C build
	rm -rf build

re: uninstall all

run: all
	./visualizer
