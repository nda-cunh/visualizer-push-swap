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
		win.present();
	}

	public static void main(string []args) {
		var app = new Application();
		app.run(args);
	}
}
