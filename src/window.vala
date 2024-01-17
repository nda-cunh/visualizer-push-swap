[GtkTemplate (ui = "/ui/window.ui")]
public class MainWindow : Gtk.ApplicationWindow {

	public string push_swap_emp {get;set;}
	public bool main_param {get;set;}
	DrawStack stackA;
	DrawStack stackB;


	public MainWindow(Gtk.Application app) {
		Object(application: app);

		stackA = new DrawStack(area_a, A);
		stackB = new DrawStack(area_b, B);
		book.page = 1;
	}

	public void run() {
		if (main_param == true) {
			this.run_push_swap ();
		}

	}

	void run_push_swap () {
		print("Hello\n");
		book.page = 0;

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
	[GtkChild]
	unowned Gtk.SpinButton number_max; 

	public int nb_max { get {return (int)number_max.value;} set {number_max.value =(double)value;}}


	/**
	* All Gtk - Signals 
	*/
	[GtkCallback]
	public void sig_new () {
		print ("Nouveau\n");
	} 
	
	[GtkCallback]
	public void sig_better_way_toggle(Gtk.ToggleButton button) {
		if (button.active)
			button.label = "'5 4 3 2 1'";
		else
			button.label = "'5' '4' '3' '2' '1'";
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
