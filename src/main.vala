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
	bool is_good  (string path) {
		if (FileUtils.test(path, FileTest.EXISTS | FileTest.IS_EXECUTABLE)) {
			if (FileUtils.test(path, FileTest.IS_DIR))
				return false;
			return true;
		}
		return false;
	}
	
	print("looking for:	 ./push_swap\n");
	if (is_good("./push_swap"))
		return "./push_swap";
	
	print("looking for:	 ../push_swap\n");
	if (is_good("../push_swap"))
		return "../push_swap";
	
	print("looking for:	 ../push_swap/push_swap\n");
	if (is_good("../push_swap/push_swap"))
		return "../push_swap/push_swap";

	printerr("your push_swap is not found :)\n");
	return null;
}

