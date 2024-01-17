[GtkTemplate (ui = "/ui/window.ui")]
public class MainWindow : Gtk.ApplicationWindow {
	
	public MainWindow(Gtk.Application app) {
		Object(application: app);
		area_a.set_draw_func((self, ctx, w, h) => {
			ctx.set_source_rgb(1.0, 0.0, 1.0);
			ctx.paint();
		});
		area_b.set_draw_func((self, ctx, w, h) => {
			ctx.set_source_rgb(0.0, 1.0, 1.0);
			ctx.paint();
		});
		book.page = 1;	
	}

	/**
	* All Gtk - Childs 
	*/
	
	[GtkChild]
	unowned Gtk.Notebook book; 
	[GtkChild]
	unowned Gtk.DrawingArea area_a; 
	[GtkChild]
	unowned Gtk.DrawingArea area_b; 


	/**
	* All Gtk - Signals 
	*/
	[GtkCallback]
	public void sig_new () {
		print ("Nouveau\n");
	} 

	[GtkCallback]
	public void sig_replay() {
		print ("Replay\n");
	} 

	[GtkCallback]
	public void sig_continue_stop(Gtk.ToggleButton abc) {
		if (abc.active == true)
			abc.label = "Continue";
		else
			abc.label = "Stop";
	} 
}
