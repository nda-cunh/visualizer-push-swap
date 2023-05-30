//valac main.vala window.vala --pkg=gtk+-3.0

bool search_path(out string? path) {
	print("recherche de:	 ./push_swap\n");
	if (FileUtils.test("push_swap", FileTest.EXISTS | FileTest.IS_EXECUTABLE)) {
		FileUtils.chmod("push_swap", 755);
		path = "push_swap";
		return true;
	}
	print("recherche de:	 ../push_swap\n");
	if (FileUtils.test("../push_swap", FileTest.EXISTS | FileTest.IS_EXECUTABLE)) {
		FileUtils.chmod("../push_swap", 755);
		path = "../push_swap";
		return true;
	}
	printerr("le programme push_swap n'existe pas ou n'est pas executable.\n");
	path = null;
	return false;
}

int	main(string []args)
{
	string? path;
	if (search_path(out path) == false)
		return -1;
	if (args[1] == null){
		printerr("Il manque un parametre : visualizer 1-1000\n");
		return -1;
	}
	int nb = int.parse(args[1]);
	if (nb >= 1 && nb <= 1000)
	{
		Gtk.init(ref args);
		try {
			var css = new Gtk.CssProvider();
			css.load_from_buffer(css_data.data);
			Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), css, 3);
		}catch(Error e){
			printerr("Erreur au niveau du chargement CSS (%s)\n", e.message);
		}
		new Window(ref path, nb);
		Gtk.main();
	} else {
		printerr("Un nombre entre 1 et 1000\n");
	}
	return (0);
}

public const string css_data = """
#menu {
	padding:8px;
}
#menu button,entry{
	margin-top: 10px;
	padding-right:10px;
	padding-left:10px;
}
#replay{

	border-radius: 0px 25px 25px 0px / 0px 50px 50px 0px;
}
#nouveau{
	border-radius: 25px 0px 0px 25px / 50px 0px 0px 50px;
}
""";
