run:
	valac main.vala Window.vala Menu.vala Drawer.vala Utils.vala function.vala --pkg=gtk+-3.0 --pkg=posix --vapidir=./vapi -o main
	./main 5

run2:
	valac main.vala Window.vala Menu.vala Drawer.vala Utils.vala function.vala --pkg=gtk+-3.0 --pkg=posix --vapidir=./vapi -o main
	
	GTK_DEBUG=interactive ./main 5
