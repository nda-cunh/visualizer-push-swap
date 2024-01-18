class Application : Gtk.Application {

	public Application() {
		Object(application_id: "org.gtk.Example");
	}

	public override void activate() {
		base.activate();
		var provider = new Gtk.CssProvider();
		provider.load_from_resource("/ui/style.css");
		Gtk.StyleContext.add_provider_for_display(Gdk.Display.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
		var win = new MainWindow(this);
		win.main_param = Application.main_param;
		win.push_swap_emp = Application.push_swap_emp;
		win.nb_max = Application.NB_MAX;
		win.present();
	}

	public static void main(string []args) {
		var app = new Application();
		if (args.length != 1)
			Application.main_param = true;
			
		if (args.length == 2)
			Application.NB_MAX = int.parse(args[1]);
		else
			Application.NB_MAX = 100;

		var? path = search_path();
		Application.push_swap_emp = (!)path ?? "./push_swap";

		app.run({args[0]});
	}

	public static bool main_param = false;
	public static string push_swap_emp;
	public static int NB_MAX;
}




string? search_path() {
	print("recherche de:	 ./push_swap\n");
	if (FileUtils.test("push_swap", FileTest.EXISTS | FileTest.IS_EXECUTABLE))
		return "./push_swap";
	print("recherche de:	 ../push_swap\n");
	if (FileUtils.test("../push_swap", FileTest.EXISTS | FileTest.IS_EXECUTABLE))
		return "../push_swap";
	printerr("le programme push_swap n'existe pas ou n'est pas executable.\n");
	return null;
}

