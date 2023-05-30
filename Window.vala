//valac main.vala Window.vala Menu.vala Drawer.vala Utils.vala function.vala  --pkg=gtk+-3.0 --pkg=posix --vapidir=./vapi

class Window : Gtk.Window {
	public Window(ref string exec, int nb) {
		Object(default_width: 1000, default_height: 600);
		this.exec = exec;
		this.nb_max = nb;
		book = new Gtk.Notebook(){show_tabs=false};
		box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		stackA = new Queue<int>();
		stackB = new Queue<int>();
		draw_stackA = new DrawStack(ref stackA, nb);
		draw_stackB = new DrawStack(ref stackB, nb);
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
		book.page = 1; 
	}

	public void init() {
		is_running = false;
		is_step = false;
		stackA.clear();
		stackB.clear();
		menu.init();
		is_stop = true;
	}

	public void loading() {
		is_running = true;
		if (is_replay == false){
			tab = Utils.get_random_tab(nb_max);
			stream = Utils.new_prog(ref exec, tab, ref is_running);
		}
		is_replay = false;
		if (stream == null || stream == ""){
			printerr("Error: timeout, ou chaine vide [%s] ", stream);
			book.page = 0;
			is_running = false;
			return ;
		}
		foreach (var i in tab) {
			stackA.push_tail(i);
		}
		book.page = 0;
		run_programme(stream);
		is_running = false;
	}

	private void run_programme(string stream) {
		var split = stream.strip().split("\n");
		int count = 0;
		ulong microseconds;
		Timer timer = new Timer();
		timer.start();

		foreach(var line in split) {
			timer.reset();
			timer.elapsed(out microseconds);
			while(speed >= microseconds || is_stop == true) {
				timer.elapsed(out microseconds);
				if (is_step) {
					is_step = false;
					break;
				}
				if (is_running == false)
					break;
				Gtk.main_iteration_do(false);
			}
			if (is_running == false)
				break;
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
			menu.iterate_count(ref line);
			draw_stackA.queue_draw();
			draw_stackB.queue_draw();
		}
		print("Fin du programme\n");
	}

	
	private void init_event() {
		
		book.notify["page"].connect(()=> {
			if (book.page == 1) {
				print("CONTINUE");
				this.init();
				Gtk.main_iteration();
				this.loading();
			}
		});

		this.destroy.connect(() => {
			is_running = false;
			Gtk.main_quit();
			Posix.exit(0);
		});
		
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
			}
		});
		menu.onEvent.connect((type) => {
			switch (type) {
				case TypeEvent.CONTINUE:
					print("Continue");
					is_stop = false;
					break;
				case TypeEvent.NEW:
					print("nouveau\n");
					is_stop = false;
					book.page = 1;
					break;
				case TypeEvent.REPLAY:
					print("replay");
					is_stop = false;
					is_replay = true;
					book.page = 1;
					break;
				case TypeEvent.STOP:
					print("stop");
					is_stop = true;
					break;
				case TypeEvent.STEP:
					print("step");
					is_step = true;
					break;
			}
		}
		);
	}

	private int speed;
	private string stream;
	private int []tab;
	private Gtk.Notebook book;
	private bool is_stop;
	private bool is_step;
	private bool is_replay;
	private bool is_running;
	private int nb_max;
	private string exec;
	private Queue<int> stackA;
	private Queue<int> stackB;
	private DrawStack draw_stackA;
	private DrawStack draw_stackB;
	private Menu menu;
	private Gtk.Box box;
}
