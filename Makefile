all:
	valac *.vala --pkg=gtk+-3.0 --pkg=posix -X -O3 -o vizualizer

run:
	./vizualizer
	
install:
	echo null	
