SRC = main.vala Window.vala Menu.vala Drawer.vala Utils.vala function.vala
SRC_C = $(SRC:.vala=.c) 
LIB = --pkg=gtk+-3.0 -X -O2 -X -w
NAME = visualiser
ARG := 100

all: $(NAME)

$(NAME) : $(SRC)
	valac $(SRC) $(LIB) -o $(NAME)

prepare:
	valac $(SRC) $(LIB) -C
	tar -cf ccode.tar  $(SRC_C)	

$(SRC_C):
	tar -xf ccode.tar -C .

bootstrap: $(SRC_C)
	$(CC) $(SRC_C) -O2 -w `pkg-config --cflags --libs gtk+-3.0` -o $(NAME) 


re: clean all

clean:
	rm -f $(NAME)

run: all
	./$(NAME) $(ARG)

run2: all debug

debug:
	GTK_DEBUG=interactive ./$(NAME) $(ARG)
