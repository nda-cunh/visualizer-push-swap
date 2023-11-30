public class Window : Gtk.Window {
	public Window(int nb, ref int []range) {
		Object(default_width: 1000, default_height: 600);

		this.range = range;
		this.nb_max = nb;

		book = new Gtk.Notebook(){show_tabs=false};
		box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		stackA = new Queue<int>();
		stackB = new Queue<int>();
		draw_stackA = new DrawStack(ref stackA, nb_max);
		draw_stackB = new DrawStack(ref stackB, nb_max);
		menu = new Menu();

		box.pack_start(menu, false, false, 0);
		box.pack_start(draw_stackA, true, true, 0);
		box.pack_start(draw_stackB, true, true, 0);
		book.append_page(box);
		book.append_page(new Gtk.Label("Loading"));

		var top = new Gtk.Box(Gtk.Orientation.VERTICAL, 0){child=book};
		scale = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 0.0, 100.0, 1.0);
		scale.change_value.connect((a, b)=> {
				scale.set_value(b);
				target = (int)scale.get_value();
				is_scaling = true;
				is_stop = false;
				speed = 0;
				menu.scaling_mode();
				return false;
				});
		top.pack_end(scale, false);
		base.child = top;
		base.show_all ();

		var provider = new Gtk.CssProvider();
		try {
			provider.load_from_data(css_data);
		} catch (Error e) {
			warning(e.message);
		}
		Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

		this.init_event();
		loading.begin();
	}

	public async void loading() {
		if (is_running == true) {
			is_killing = true;
			book.page = 1;
			while (is_killing == true)
				yield Utils.sleep(500);
		}
		is_running = true;
		book.page = 1;

		// Run a push_swap thread if replay is false
		if (is_replay == false) {
			tab = Utils.get_random_tab(nb_max);
			var thread = new Thread<string>(null, () => {
					var tab_str = new StringBuilder.sized(16384);
					string output;

					foreach (var i in tab) {
					tab_str.append_printf("%d ", i);
					}
					print("Input :[%s]", tab_str.str);
					try {
					Process.spawn_sync(null, {PUSH_SWAP_EMP, tab_str.str}, null, 0, null, out output);
					}
					catch(Error e) {
					printerr(e.message);
					}
					Idle.add(loading.callback);
					return output;
					});
			yield;
			stream = thread.join();
		}

		stackA.clear();
		stackB.clear();
		menu.iterate_count("", 0);
		foreach (var i in tab) {
			stackA.push_tail(i);
		}
		book.page = 0;
		run_programme.begin(stream);
	}

	private async void run_programme(string stream) {
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
				menu.iterate_count("", count);
			else
				menu.iterate_count(split[count - 1], count);
			draw_stackA.queue_draw();
			draw_stackB.queue_draw();
		}
	}

	
	public bool reverse(string line)
	{
		switch (line)
		{
			case "ra":
				rra(stackA);
				break;
			case "rra":
				ra(stackA);
				break;
			case "sa":
				sa(stackA);
				break;
			case "pa":
				pb(stackA, stackB);
				break;
			case "rb":
				rrb(stackB);
				break;
			case "rrb":
				rb(stackB);
				break;
			case "sb":
				sb(stackB);
				break;
			case "pb":
				pa(stackA, stackB);
				break;
			case "ss":
				ss(stackA, stackB);
				break;
			case "rr":
				rrr(stackA, stackB);
				break;
			case "rrr":
				rr(stackA, stackB);
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
				ra(stackA);
				break;
			case "rra":
				rra(stackA);
				break;
			case "sa":
				sa(stackA);
				break;
			case "pa":
				pa(stackA, stackB);
				break;
			case "rb":
				rb(stackB);
				break;
			case "rrb":
				rrb(stackB);
				break;
			case "sb":
				sb(stackB);
				break;
			case "pb":
				pb(stackA, stackB);
				break;
			case "ss":
				ss(stackA, stackB);
				break;
			case "rr":
				rr(stackA, stackB);
				break;
			case "rrr":
				rrr(stackA, stackB);
				break;
			default:
				warning(line);
				return false;
			}
		return true;
	}



	private void init_event() {
		// Event window cross
		this.destroy.connect(() => {
			is_running = false;
			Gtk.main_quit();
		});

		// Event Speed [-/+]
		menu.onChangeSpeed.connect((speed) => {
			switch (speed) {
				case 1:
					this.speed = 20000;
					break;
				case 2:
					this.speed = 10000;
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

		// Button  [Continue] [Replay] and other...
		menu.onEvent.connect((type) => {
			is_scaling = false;
			menu.refresh_speed();
			switch (type) {
				case TypeEvent.CONTINUE:
					is_stop = false;
					break;
				case TypeEvent.NEW:
					Idle.add(()=> {
						loading.begin();
						is_stop = true;
						menu.scaling_mode();
						return false;
					});
					break;
				case TypeEvent.STOP:
					is_stop = true;
					break;
				case TypeEvent.STEP:
					is_stop = true;
					is_step = true;
					break;
				case TypeEvent.BACKSTEP:
					is_stop = true;
					is_backstep = true;
					break;
				case TypeEvent.FORWARD:
					is_reverse = false;
					break;
				case TypeEvent.REVERSE:
					is_reverse = true;
					break;
			}
		});
	}


	// STATUS
	private bool is_killing		{get; set; default=false;}
	private bool is_stop		{get; set; default=true;}
	private bool is_step		{get; set; default=false;}
	private bool is_backstep	{get; set; default=false;}
	private bool is_replay		{get; set; default=false;}
	private bool is_running		{get; set; default=false;}
	private bool is_reverse		{get; set; default=false;}
	private bool is_scaling		{get; set; default=false;}

	// WIDGET
	private DrawStack draw_stackA;
	private DrawStack draw_stackB;
	private Menu menu;
	private Gtk.Box box;
	private Gtk.Notebook book;
	private Gtk.Scale scale;

	// GLOBAL
	private int target;
	private unowned int []range;
	private int speed {get; set; default=4000;}
	private string stream;
	private int []tab;
	private int nb_max;
	private Queue<int> stackA;
	private Queue<int> stackB;

}
