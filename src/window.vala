public enum runMode {
	NEW,
	RUN
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
		cancel = new Cancellable ();
		init_event();
		timer_click_run = new Timer();
		stackA = new DrawStack(area_a, A);
		stackB = new DrawStack(area_b, B);

		speed_button.value = 3;
		stream = "";

		book.page = 1;
	}


	void init_event ()  {
		scale.change_value.connect((a, b)=> {
			scale.set_value(b);
			target = (int)scale.get_value();
			is_scaling = true;
			continue_stop.active = true;
			speed = 0;
			return false;
		});
		
		speed_button.value_changed.connect(() => {
				change_speed();
		});

		continue_stop.toggled.connect(()=> {
			if (continue_stop.active == true) {
				continue_stop.label = "Continue";
			}
			else {
				continue_stop.label = "Stop";
				is_scaling = false;
				change_speed();
			}
			is_stop = continue_stop.active;
		});
	}


	void change_speed () {
		var _speed = (int)speed_button.value;
		switch (_speed) {
			case 1:
				this.speed = 200000;
				break;
			case 2:
				this.speed = 40001;
				break;
			case 3:
				this.speed = 25001;
				break;
			case 4:
				this.speed = 5001;
				break;
			case 5:
				this.speed = 2501;
				break;
			case 6:
				this.speed = 501;
				break;
			case 7:
				this.speed = 151;
				break;
			case 8:
				this.speed = 2;
				break;
		}
	}


	async void run_push_swap (runMode mode) {

		if (FileUtils.test(push_swap_emp, FileTest.EXISTS) == false) {
			gtk_warn(warningbar, warningbar_label, @"push_swap not found ! path: [$(push_swap_emp)]");
			return;	
		}
		if (FileUtils.test(push_swap_emp, FileTest.IS_DIR)) {
			gtk_warn(warningbar, warningbar_label, @"push_swap is a directory");
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

		// Generate some random number is is a `new` test
		if (mode == NEW) {
			var lst = Utils.get_random_tab(nb_max);
			var sb = new StringBuilder.sized(nb_max * 5);

			if (better_way.active == true) {
				sb.append_c('"');
				foreach (var i in lst)
					sb.append_printf("%d ", i);
				sb.append_c('"');
			}
			else {
				foreach (var i in lst)
					sb.append_printf("\"%d\" ", i);
			}
			buffer.set_text(sb.str.data);
		}

			//here
		FileUtils.chmod(push_swap_emp, 0000755);

		// Run the push_swap in thread (ASync)
		var thread = new Thread<string>(null, () => {
			var sb = new StringBuilder.sized (16384);
			string []argvp;
			Subprocess proc;
			InputStream pipe;

			try {
				Shell.parse_argv (@"$(push_swap_emp) $(buffer.text)", out argvp);
				proc = new Subprocess.newv (argvp, SubprocessFlags.STDOUT_PIPE);
				pipe = proc.get_stdout_pipe ();
			} catch (Error e) {
				gtk_warn(warningbar, warningbar_label, @"$(e.message)");
				return "";
			} 

			// Get all output of push_swap
			uint8 buffer[33];
			size_t len;

			cancel.cancelled.connect (()=> {
				proc.force_exit ();
			});

			try {
				while ((len = pipe.read (buffer[0:32], cancel) ) > 0) {
					buffer[len] = '\0';
					sb.append ((string)buffer);
				}
				proc.wait (cancel);
			}catch (Error e) {
				printerr("[Cancel]> %s\n", e.message);
				cancel.reset ();
				Idle.add(run_push_swap.callback);
				print ("Output: [%s]\n", sb.str);
				return sb.str;
			}
			if (proc.get_exit_status () != 0 || proc.get_if_signaled ()) {
				gtk_warn(warningbar, warningbar_label, @"ERROR PushSwap your push_swap crash ???");
				warning (@"Here the input: [[[$(string.joinv (" ", argvp))]]]");
			}
			cancel.reset ();
			Idle.add(run_push_swap.callback);
			return sb.str;
		});

		yield;
		stream = thread.join();

		book.page = 1;
		if (stream == "") {
			gtk_warn(warningbar, warningbar_label, "nothing to replay or push_swap did'nt print anything");
			is_running = false;
			return ;
		}

		int[] normalize (string[] bfs) {
			var list = new SList<int>();
			int []tab = {};
			foreach(var i in bfs) {
				if (i == "")
					continue ;
				int nb = int.parse(i);	
				list.append(nb);
				tab += nb;
			}

			list.sort ((a, b) => {
				return a - b;
			});

			for (var i = 0; i!= tab.length; ++i) {
				tab[i] = list.index (tab[i]) + 1;
			}
			return tab;
		}


		var bfs = buffer.text.replace("\"", "").split(" ");
		int []tab = normalize(bfs);

		int max = bfs.length - 1;

		stackA.clear(max);
		stackB.clear(max);
		foreach (var i in tab) {
			stackA.stack.push_tail(i);
		}

		run_programme.begin(stream, ()=> {
			is_killing = false;
		});
	}


	// Lit le stream du push_swap  (sa\n pa\n ra\n  ...)
	async void run_programme(string stream) {
		var split = stream.strip().split("\n");
		int split_len;
		int count = 0;
		target = 0;

		{
			string []tmp = {};
			var regex = /^sa$|^sb$|^ss$|^pa$|^pb$|^ra$|^rb$|^rr$|^rra$|^rrb$|^rrr$/;
			foreach (var i in split) {
				if (regex.match(i))
					tmp += i;
			}
			split = tmp;
			split_len = split.length;
			hit_label.label = "---";
		}
		

		scale.set_value(0);
		scale.set_range(0.0, (double)split_len);

		// fill the window_dialog
		var lst_button = new List<Gtk.Button>();
		dialog_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0) {
			name = "dialog_box"
		};
		dialog_view.child = dialog_box;
		for (var i = 0; i != split.length + 1; i++) {
			Gtk.Button tmp;
			if (i == split_len) {
				tmp = new Gtk.Button.with_label(@"- $split_len -");
			}
			else
				tmp = new Gtk.Button.with_label(@"$(i) $(split[i])");
			tmp.has_frame = false;
			lst_button.append(tmp);
			int n = i;
			tmp.clicked.connect(()=> {
				scale.set_value (n);
				if (i == split_len) {
					scale.set_value (split_len);
					target = split_len;
				}
				else
					target = n;
				is_scaling = true;
				continue_stop.active = true;
				speed = 0;
			});
			dialog_box.append (tmp);
		}

		Timer timer = new Timer();
		while (true) {
			yield Utils.usleep(speed);

			// si le programme est sur stop il doit tourner ici en boucle
			// sauf si le programme est entrain de mourir ou que l'utilisateur utilise le scale
			while (is_stop && is_killing == false && is_scaling == false) {
				yield Utils.sleep(50);
			}

			if (is_killing == true)
				return ;


			if (is_scaling == false) {
				if (is_reverse) {
					if (target > 0)
						--target;
				}
				else if (target < split_len)
					++target;
			}

			if (target > count) {
				if (count < split_len) {
					if (forward(split[count], stackA.stack, stackB.stack))
						++count;
				}
			}
			else if (target < count) {
				if (reverse(split[count - 1], stackA.stack, stackB.stack))
					--count;
			}
			
			if (target >= split_len)
				target = split_len;
			if (count > split_len) {
				continue;
			}

			if (count == target) {
				is_scaling = false;
				scale.set_value((double)target);
			}
			
			if (count != target && timer.elapsed() >= 0.02) {
				lst_button.nth_data(target).focus(Gtk.DirectionType.DOWN);
				timer.reset ();
			}

			if (count != split_len) {
				if (count >= 0)
					hit_label.label = @"$(split[count]) $(count)";
			}
			else {
				hit_label.label = @"- $split_len -";
			}

			stackA.refresh();
			stackB.refresh();
		}
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
	Gtk.Box dialog_box; 
	[GtkChild]
	unowned Gtk.Viewport dialog_view; 

	private string _push_swap_emp;
	public string push_swap_emp {
		get {
			_push_swap_emp = "./" + buffer_push_swap.text;
			return _push_swap_emp;
		}
		set {
			buffer_push_swap.set_text(value.data);
		}
	}
	public int nb_max { get {return (int)number_max.value;} set {number_max.value =(double)value;}}


	/**
	* All Gtk - Signals 
	*/

	[GtkCallback]
	public void sig_cancel() {
		print("Cancel !\n");
		cancel.cancel ();
	}

	[GtkCallback]
	public void sig_step_left() {
		if (target != 0)
			target--;
		is_scaling = true;
	}

	[GtkCallback]
	public void sig_step_right() {
		target++;
		is_scaling = true;
	}
	[GtkCallback]
	public void sig_new () {
		if (timer_click_run.elapsed () >= 1.0) {
			run_push_swap.begin(NEW);
			timer_click_run.reset ();
		}
	} 

	[GtkCallback]
	public void sig_replay() {
		if (timer_click_run.elapsed () >= 1.0) {
			run_push_swap.begin(RUN);
			timer_click_run.reset ();
		}
	}
	[GtkCallback]
	public void sig_hide_img (Gtk.ToggleButton btn) {
		var img = (Gtk.Image)btn.child;
		img.icon_name = img.icon_name == "go-previous-symbolic" ? "go-next-symbolic" : "go-previous-symbolic";
	}

	
	[GtkCallback]
	public void sig_better_way_toggle(Gtk.ToggleButton button) {
		if (button.active)
			button.label = "'5 4 3 2 1'";
		else
			button.label = "'5' '4' '3' '2' '1'";
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
	private bool is_stop		{get; set;}

	private int target = 0;
	public int speed = 0; 
	public Cancellable			cancel;
	private string stream;
	public Timer timer_click_run;
	private bool is_replay		{get; set; default=false;}
	private bool is_running		{get; set; default=false;}
	private bool is_reverse		{get; set; default=false;}
	private bool is_scaling		{get; set; default=false;}

}
