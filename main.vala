//valac main.vala window.vala --pkg=gtk+-3.0

string? search_path() {
	print("recherche de:	 ./push_swap\n");
	if (FileUtils.test("push_swap", FileTest.EXISTS | FileTest.IS_EXECUTABLE)) {
		FileUtils.chmod("push_swap", 0000755);
		return "push_swap";
	}
	print("recherche de:	 ../push_swap\n");
	if (FileUtils.test("../push_swap", FileTest.EXISTS | FileTest.IS_EXECUTABLE)) {
		FileUtils.chmod("../push_swap", 0000755);
		return "../push_swap";
	}
	printerr("le programme push_swap n'existe pas ou n'est pas executable.\n");
	return null;
}

public unowned string PUSH_SWAP_EMP;

int	main(string []args)
{
	string? path;
	int []range_nb = {};

	if ((path = search_path()) == null)
		return -1;
	PUSH_SWAP_EMP = path;
	if (args[1] == null){
		printerr("Il manque un parametre : visualizer 1-1000\n");
		return -1;
	}
	if (args.length >= 3) {
		foreach (var i in args[1 : args.length]) {
			range_nb += int.parse(i);
		}
	}
	int nb = int.parse(args[1]);
	if (nb >= 1 && nb <= 1000)
	{
		Gtk.init(ref args);
		new Window(nb, ref range_nb);
		Gtk.main();
		return (0);
	}
	printerr("Un nombre entre 1 et 1000\n");
	return (-1);
}

public const string css_data = """

#menu {
	padding:8px;
}

.right{
	border-radius: 0px 25px 25px 0px / 0px 50px 50px 0px;
}
.left{
	border-radius: 25px 0px 0px 25px / 50px 0px 0px 50px;
}
""";
