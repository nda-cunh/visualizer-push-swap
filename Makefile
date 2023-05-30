SRC = main.vala Window.vala Menu.vala Drawer.vala Utils.vala function.vala
LIB = --pkg=gtk+-3.0 --pkg=posix
NAME = visualiser

all: $(NAME)

$(NAME) : $(SRC)
	valac $(SRC) $(LIB) -o $(NAME)

run: all
	./$(NAME) $(ARG)

run2: all
	GTK_DEBUG=interactive ./$(NAME) $(ARG)
