//valac main.vala Window.vala Menu.vala --pkg=gtk+-3.0

enum TypeEvent {
	CONTINUE,
	REPLAY,
	NEW,
	STOP,
	STEP
}

class Menu : Gtk.Box {
	public Menu() {
		Object(orientation: Gtk.Orientation.VERTICAL);
		b_replay = new Gtk.Button.with_label("Replay");
		b_step = new Gtk.Button.with_label("Step");
		b_nouveau = new Gtk.Button.with_label("New");
		t_continue = new Gtk.ToggleButton.with_label("Stop");
		l_count = new Gtk.Label("0");
		l_action = new Gtk.Label("");
		b_spin = new Gtk.SpinButton.with_range(1.0, 5.0, 1.0);
		b_spin.value = 3.0;
		this.attach();
		b_step.visible = false;
		init_event();
	}
	
	public void init() {
		t_continue.label = "Continue";
		b_step.visible = true;
		t_continue.set_active(true);
		count = 0;
		l_count.label = "0";
		l_action.label = "";

	}
	
	public void iterate_count(ref string line) {
		count++;
		l_count.label = @"$count";
		l_action.label = line;
	}

	private void attach() {
		base.pack_start(b_replay, false, false, 0);
		base.pack_start(b_nouveau, false, false, 0);
		base.pack_start(b_spin, false, false, 0);
		base.pack_start(t_continue, false, false, 0);
		base.pack_start(b_step, false, false, 0);
		base.pack_start(l_count, false, false, 0);
		base.pack_start(l_action, false, false, 0);
	}

	private void init_event() {
		b_replay.clicked.connect(() => {
			onEvent(TypeEvent.REPLAY);
		});
		b_nouveau.clicked.connect(() => {
			onEvent(TypeEvent.NEW);
		});
		b_step.clicked.connect(() => {
			onEvent(TypeEvent.STEP);
		});
		t_continue.toggled.connect(() => {
			if (t_continue.get_active()) {
				t_continue.label = "Continue";
				b_step.visible = true;
				onEvent(TypeEvent.STOP);
			}
			else {
				t_continue.label = "Stop";
				b_step.visible = false;
				onEvent(TypeEvent.CONTINUE);
			}
		});
		b_spin.value_changed.connect(() => {
			onChangeSpeed((int)b_spin.value);
		});
	}

	public signal void onEvent(TypeEvent type);
	public signal void onChangeSpeed(int speed);
	
	public int					count;
	private Gtk.SpinButton		b_spin;
	private Gtk.Button			b_replay;
	private Gtk.Button			b_step;
	private Gtk.Button			b_nouveau;
	private Gtk.ToggleButton	t_continue;
	private Gtk.Label			l_count;
	private Gtk.Label			l_action;
}
