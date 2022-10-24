all:
	valac *.vala -g --pkg=gtk+-3.0 --pkg=posix -X -export-dynamic -o vizualizer

run:
	./vizualizer
	
install:
	echo null	
