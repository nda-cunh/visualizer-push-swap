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
		Object(orientation: Gtk.Orientation.VERTICAL, spacing:8);
		base.name = "menu";
		box_replay_new = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		b_replay = new Gtk.Button.with_label("Replay"){name="replay"};
		b_nouveau = new Gtk.Button.with_label("New"){name="nouveau"};
		b_step = new Gtk.Button.with_label("Step");
		t_continue = new Gtk.ToggleButton.with_label("Stop");
		l_count = new Gtk.Label("0");
		b_spin = new Gtk.SpinButton.with_range(1.0, 7.0, 1.0);
		b_spin.value = 3.0;
		this.attach();
		b_step.visible = false;
		init_event();
	}
	
	public void iterate_count(string line, int count) {
		l_count.label = @"$line $count";
	}

	private void attach() {
		box_replay_new.pack_start(b_nouveau, false, false, 0);
		box_replay_new.pack_start(b_replay, false, false, 0);
		base.pack_start(box_replay_new, false, false, 0);
		base.pack_start(b_spin, false, false, 0);
		base.pack_start(t_continue, false, false, 0);
		base.pack_start(b_step, false, false, 0);
		base.pack_start(l_count, false, false, 0);
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
	
	private Gtk.SpinButton		b_spin;
	private Gtk.Box				box_replay_new;
	private Gtk.Button			b_replay;
	private Gtk.Button			b_step;
	private Gtk.Button			b_nouveau;
	private Gtk.ToggleButton	t_continue;
	private Gtk.Label			l_count;
}
