/***
 *  Class Application
 *  This class is used to create the main Gtk window of the program
 ******************************************************************************/
class Application : Gtk.Application {
	construct {
		application_id = "org.gtk.Example";
	}

	public override void activate () {
		var provider = new Gtk.CssProvider();
		provider.load_from_resource("/data/style.css");
		Gtk.StyleContext.add_provider_for_display(Gdk.Display.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
		var win = new MainWindow(this);
		win.present();
	}

}

/* Main function */
void main (string []args) {
	try {
		// Parse the command line arguments
		Options.parse(args);

		// Create the main application
		var app = new Application();
		app.run(args);
	}
	catch (Error e) {
		printerr("Error: %s\n", e.message);
	}
}
