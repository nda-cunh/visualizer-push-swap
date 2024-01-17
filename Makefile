_SRC= Utils.vala functions.vala main.vala window.vala
SRC= $(addprefix src/,$(_SRC))
CFLAGS= -O2 -flto -w
PKG=gtk4 gee-0.8 

FLAGSVALA = $(addprefix --pkg=,$(PKG))  $(addprefix -X ,$(CFLAGS))
NAME=out

all: $(NAME)

$(NAME): ui/window.ui build/gresource.c 
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
	./$(NAME)
