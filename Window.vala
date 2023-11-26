class Window : Gtk.Window {
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
		is_replay = false;
		speed = 4000;
		box.pack_start(menu, false, false, 0);
		box.pack_start(draw_stackA, true, true, 0);
		box.pack_start(draw_stackB, true, true, 0);
		base.child = book;
		book.append_page(box);
		book.append_page(new Gtk.Label("Loading"));
		base.show_all ();
		this.init_event();
			var css_provider = new Gtk.CssProvider();
			css_provider.load_from_data(css_data);
			Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
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

		if (is_replay == false) {
			tab = Utils.get_random_tab(nb_max);
			var thread = new Thread<string>(null, () => {
				var tab_str = new StringBuilder.sized(16384);
				string output;
				
				foreach (var i in tab) {
					tab_str.append_printf("%d ", i);
				}
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
		int count = 0;
		
		foreach(var line in split) {
			yield Utils.usleep(speed);
			while (is_stop && is_killing == false) {
				yield Utils.sleep(200);
				if (is_step == true) {
					is_step = false;
					break;
				}
			}
			
			if (is_killing == true) {
				is_killing = false;
				return ;
			}
			count++;
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
					count--;
					print(@"Commentaire : $line\n");
					  break;
			}
			menu.iterate_count(line, count);
			draw_stackA.queue_draw();
			draw_stackB.queue_draw();
		}
		is_running = false;
		print("Fin du programme\n");
	}

	
	private void init_event() {
		
		// Event window cross
		this.destroy.connect(() => {
			is_running = false;
			Gtk.main_quit();
			Process.exit(0);
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
			switch (type) {
				case TypeEvent.CONTINUE:
					print("continue\n");
					is_stop = false;
					break;
				case TypeEvent.NEW:
					print("nouveau\n");
					Idle.add(()=> {
						loading.begin();
						return false;
					});
					break;
				case TypeEvent.REPLAY:
					print("replay\n");
					is_replay = true;
					Idle.add(()=> {
						loading.begin();
						return false;
					});
					break;
				case TypeEvent.STOP:
					print("stop\n");
					is_stop = true;
					break;
				case TypeEvent.STEP:
					print("step\n");
					is_step = true;
					break;
			}
		}
		);
	}

	// STATUS
	private bool is_killing;
	private bool is_stop;
	private bool is_step;
	private bool is_replay;
	private bool is_running;

	// WIDGET
	private DrawStack draw_stackA;
	private DrawStack draw_stackB;
	private Menu menu;
	private Gtk.Box box;
	private Gtk.Notebook book;

	// GLOBAL
	private unowned int []range;
	private int speed;
	private string stream;
	private int []tab;
	private int nb_max;
	private Queue<int> stackA;
	private Queue<int> stackB;
}
