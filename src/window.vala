public enum runMode {
	NEW,
	REPLAY
}


public void gtk_warn (Gtk.InfoBar bar, Gtk.Label bar_label, string txt) {
	bar.revealed = true;
	bar_label.label = txt;
	Timeout.add(2500, ()=> {
		bar.revealed = false;
		return false;
	});
}

[GtkTemplate (ui = "/ui/window.ui")]
public class MainWindow : Gtk.ApplicationWindow {

	public bool main_param {get;set;}
	DrawStack stackA;
	DrawStack stackB;


	public MainWindow(Gtk.Application app) {
		Object(application: app);
		stream = "";

		stackA = new DrawStack(area_a, A);
		stackB = new DrawStack(area_b, B);


		scale.change_value.connect((a, b)=> {
			scale.set_value(b);
			target = (int)scale.get_value();
			is_scaling = true;
			is_stop = false;
			speed = 25;
			return false;
		});
		
		speed_button.value_changed.connect(() => {
			var _speed = (int)speed_button.value;
			switch (_speed) {
				case 1:
					this.speed = 40000;
					break;
				case 2:
					this.speed = 25000;
					break;
				case 3:
					this.speed = 5000;
					break;
				case 4:
					this.speed = 2500;
					break;
				case 5:
					this.speed = 500;
					break;
				case 6:
					this.speed = 150;
					break;
				case 7:
					this.speed = 1;
					break;
			}
		});


		book.page = 1;
	}

	public void run() {

	}

	async void run_push_swap (runMode mode) {

		if (FileUtils.test(push_swap_emp, FileTest.EXISTS) == false) {
			gtk_warn(warningbar, warningbar_label, @"push_swap not found ! path: [$(push_swap_emp)]");
			return;	
		}
		
		if (is_running == true) {
			is_killing = true;
			book.page = 1;
			while (is_killing == true)
				yield Utils.sleep(500);
		}
		is_running = true;

		book.page = 0;

		if (mode == NEW) {
			var lst = Utils.get_random_tab(nb_max);
			var sb = new StringBuilder.sized(nb_max * 5);
			if (better_way.active == true) {
				sb.append_c('"');
				foreach (var i in lst) {
					sb.append_printf("%d ", i);
				}
				sb.append_c('"');
			}
			else {
				foreach (var i in lst) {
					sb.append_printf("\"%d\" ", i);
				}
			}
			buffer.set_text(sb.str.data);
			int wait_status = 0;
			var thread = new Thread<string>(null, () => {
					string stdout;
				try {
					Process.spawn_command_line_sync(@"$(push_swap_emp) $(buffer.get_text())", out stdout, null, out wait_status);
				} catch (Error e) {
					printerr(e.message);
				} 
				Idle.add(run_push_swap.callback);
				return stdout;
			});

			yield;
			stream = thread.join();
		}
		book.page = 1;
		if (stream == "") {
			gtk_warn(warningbar, warningbar_label, "nothing to replay or push_swap did'nt print anything");
			is_running = false;
			return ;
		}


		stackA.clear(nb_max);
		stackB.clear(nb_max);
		var bfs = buffer.get_text().replace("\"", "");
		foreach (var i in bfs.split(" ")) {
			if (i == "")
				continue ;
			stackA.stack.push_tail(int.parse(i));
		}

		run_programme.begin(stream);
	}

	async void run_programme(string stream) {
		var split = stream.strip().split("\n");
		string []tmp = {};
		int split_len;
		int count = 0;
		target = 0;

		var regex = /^sa$|^sb$|^ss$|^pa$|^pb$|^ra$|^rb$|^rr$|^rra$|^rrb$|^rrr$/;
		foreach (var i in split) {
			if (regex.match(i))
				tmp += i;
		}
		split = tmp;
		
		split_len = split.length;

		scale.set_value(0);
		scale.set_range(0.0, (double)split_len);

		while (true) {

			yield Utils.usleep(speed);

			while (is_stop && is_killing == false) {
				yield Utils.sleep(200);
				if (is_step == true) {
					is_step = false;
					if (target < split_len)
						target++;
					break;
				}
				if (is_backstep == true) {
					is_backstep = false;
					if (target > 0)
						target--;
					break;
				}
			}

			// Loading Kill infinit loop
			if (is_killing == true) {
				is_killing = false;
				return ;
			}


			if (is_stop == false && is_scaling == false) {
				if (is_reverse) {
					if (target > 0)
						target--;
				}
				else if (target < split_len)
					target++;
			}

			if (target > count) {
				if (count < split_len) {
					if (forward(split[count]))
						count++;
				}
			}
			else if (target < count) {
				if (reverse(split[count - 1]))
					count--;
			}

			scale.set_value((double)target);
			if (count == 0)
				hit_label.label = @"0 $count";
			else
				hit_label.label = @"$(split[count - 1]) $count";
			stackA.refresh();
			stackB.refresh();
		}
	}

	
	public bool reverse(string line)
	{
		switch (line)
		{
			case "ra":
				rra(stackA.stack);
				break;
			case "rra":
				ra(stackA.stack);
				break;
			case "sa":
				sa(stackA.stack);
				break;
			case "pa":
				pb(stackA.stack, stackB.stack);
				break;
			case "rb":
				rrb(stackB.stack);
				break;
			case "rrb":
				rb(stackB.stack);
				break;
			case "sb":
				sb(stackB.stack);
				break;
			case "pb":
				pa(stackA.stack, stackB.stack);
				break;
			case "ss":
				ss(stackA.stack, stackB.stack);
				break;
			case "rr":
				rrr(stackA.stack, stackB.stack);
				break;
			case "rrr":
				rr(stackA.stack, stackB.stack);
				break;
			default:
				warning(line);
				return false;
		}
		return true;
	}










	public bool forward (string line)
	{
		switch (line) {
			case "ra":
				ra(stackA.stack);
				break;
			case "rra":
				rra(stackA.stack);
				break;
			case "sa":
				sa(stackA.stack);
				break;
			case "pa":
				pa(stackA.stack, stackB.stack);
				break;
			case "rb":
				rb(stackB.stack);
				break;
			case "rrb":
				rrb(stackB.stack);
				break;
			case "sb":
				sb(stackB.stack);
				break;
			case "pb":
				pb(stackA.stack, stackB.stack);
				break;
			case "ss":
				ss(stackA.stack, stackB.stack);
				break;
			case "rr":
				rr(stackA.stack, stackB.stack);
				break;
			case "rrr":
				rrr(stackA.stack, stackB.stack);
				break;
			default:
				warning(line);
				return false;
			}
		return true;
	}



	/**
	* All Gtk - Childs 
	*/
	
	[GtkChild]
	unowned Gtk.EntryBuffer buffer; 
	[GtkChild]
	unowned Gtk.Notebook book; 
	[GtkChild]
	unowned Gtk.DrawingArea area_a; 
	[GtkChild]
	unowned Gtk.DrawingArea area_b; 
	[GtkChild]
	unowned Gtk.SpinButton number_max; 
	[GtkChild]
	unowned Gtk.InfoBar warningbar; 
	[GtkChild]
	unowned Gtk.Label warningbar_label; 
	[GtkChild]
	unowned Gtk.Label hit_label; 
	[GtkChild]
	unowned Gtk.ToggleButton better_way; 
	[GtkChild]
	unowned Gtk.ToggleButton continue_stop; 
	[GtkChild]
	unowned Gtk.EntryBuffer buffer_push_swap; 
	[GtkChild]
	unowned Gtk.Scale scale; 
	[GtkChild]
	unowned Gtk.Image reverse_img; 
	[GtkChild]
	unowned Gtk.SpinButton speed_button; 

	public string push_swap_emp {get {return buffer_push_swap.text;} set {buffer_push_swap.set_text(value.data);}}
	public int nb_max { get {return (int)number_max.value;} set {number_max.value =(double)value;}}


	/**
	* All Gtk - Signals 
	*/

	[GtkCallback]
	public void sig_step_left() {
		is_backstep = true;
	}
	[GtkCallback]
	public void sig_step_right() {
		is_step = true;
	}
	[GtkCallback]
	public void sig_new () {
		print ("Nouveau\n");
		run_push_swap.begin(NEW);
	} 

	[GtkCallback]
	public void sig_replay() {
		print ("Replay\n");
		run_push_swap.begin(REPLAY);
	} 
	
	[GtkCallback]
	public void sig_better_way_toggle(Gtk.ToggleButton button) {
		if (button.active)
			button.label = "'5 4 3 2 1'";
		else
			button.label = "'5' '4' '3' '2' '1'";
	} 


	[GtkCallback]
	public void sig_continue_stop(Gtk.ToggleButton abc) {
		if (abc.active == true)
			abc.label = "Continue";
		else
			abc.label = "Stop";
	} 

	[GtkCallback]
	public void sig_reverse_button() {
		is_reverse = !is_reverse;
		if (is_reverse)
			reverse_img.icon_name = "media-skip-backward-symbolic";
		else
			reverse_img.icon_name = "media-skip-forward-symbolic";
	} 




	private bool is_killing		{get; set; default=false;}
	private bool is_stop		{get {return continue_stop.active; }
		set {
			if (value == true) 
				continue_stop.label = "Continue";
			else
				continue_stop.label = "Continue";
			continue_stop.active = value;
		}
	}

	private int target = 0;
	public int speed = 0; 
	private string stream;
	private bool is_step		{get; set; default=false;}
	private bool is_backstep	{get; set; default=false;}
	private bool is_replay		{get; set; default=false;}
	private bool is_running		{get; set; default=false;}
	private bool is_reverse		{get; set; default=false;}
	private bool is_scaling		{get; set; default=false;}

}
