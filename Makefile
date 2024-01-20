_SRC= window_program.vala Utils.vala functions.vala DrawStack.vala main.vala window.vala
SRC= $(addprefix src/,$(_SRC))
CFLAGS= -Ofast -flto -w
PKG=gtk4
FLAGS=--enable-experimental -g

FLAGSVALA = $(addprefix --pkg=,$(PKG))  $(addprefix -X ,$(CFLAGS)) $(FLAGS) 
NAME=visualizer

all: t $(NAME)

t : 
	rm -rf src/*.c

$(NAME): ui/window.ui build/gresource.c $(SRC)
	valac $(SRC) $(FLAGSVALA) build/gresource.c --gresources=gresource.xml -o $(NAME)

build/gresource.c : gresource.xml ui/window.ui ui/style.css
	glib-compile-resources --generate-source gresource.xml	
	mkdir -p build
	mv gresource.c build/ 

ui/window.ui: window.blp
	blueprint-compiler compile $< > $@

re: fclean all

fclean: clean
	rm -rf $(NAME)

clean:
	rm -rf ui/window.ui
	rm -rf build

run: all
	./$(NAME) 50 
