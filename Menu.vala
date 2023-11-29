//valac main.vala Window.vala Menu.vala --pkg=gtk+-3.0

enum TypeEvent {
	CONTINUE,
	NEW,
	STOP,
	STEP,
	BACKSTEP,
	REVERSE,
	FORWARD
}

class Menu : Gtk.Box {
	public Menu() {

		Object(orientation: Gtk.Orientation.VERTICAL, spacing:8, name: "menu");
		base.vexpand = true;

		// [ Widget Init ]
		b_nouveau = new Gtk.Button.with_label("New")				{name="new"};

		var box_step = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

		b_step = new Gtk.Button()	{name="step"};
		b_step.child = new Gtk.Image.from_icon_name("pan-end-symbolic", Gtk.IconSize.BUTTON);
		b_step.get_style_context().add_class("right");

		b_backstep = new Gtk.Button()			{name="backstep"};
		b_backstep.child = new Gtk.Image.from_icon_name("pan-start-symbolic", Gtk.IconSize.BUTTON);
		b_backstep.get_style_context().add_class("left");


		box_step.pack_start(b_backstep);
		box_step.pack_start(b_step);

		t_continue = new Gtk.ToggleButton.with_label("Continue")	{active = true};
		t_reverse = new Gtk.ToggleButton()		{active = true};
		i_reverse = new Gtk.Image.from_icon_name("media-skip-backward-symbolic", Gtk.IconSize.BUTTON);
		t_reverse.child = i_reverse;
		t_reverse.valign = Gtk.Align.END;
		t_reverse.vexpand = true;



		l_count = new Gtk.Label("0");
		b_spin = new Gtk.SpinButton.with_range(1.0, 7.0, 1.0) 		{value = 3.0};

		b_step.visible = false;

		init_menu(box_step);
		init_event();
	}

	// Add all element like button to Menu Bar
	private void init_menu(Gtk.Box box) {
		base.pack_start(b_nouveau, false, false, 0);
		base.pack_start(b_spin, false, false, 0);
		base.pack_start(t_continue, false, false, 0);
		base.pack_start(box, false, false, 0);
		base.pack_start(l_count, false, false, 0);
		base.pack_start(t_reverse, true, true, 5);
	}

	// Set label of Menu to '$line $count'
	public void iterate_count(string line, int count) {
		l_count.label = @"$line $count";
	}

	public void scaling_mode() {
		t_continue.active = true;
	}

	public void refresh_speed(){
		onChangeSpeed((int)b_spin.value);
	}

	// init all Events of widgets
	private void init_event() {
		b_nouveau.clicked.connect(() => {
			onEvent(TypeEvent.NEW);
		});
		b_step.clicked.connect(() => {
			onEvent(TypeEvent.STEP);
		});
		b_backstep.clicked.connect(() => {
			onEvent(TypeEvent.BACKSTEP);
		});

		t_continue.toggled.connect(() => {

			b_step.visible = !b_step.visible;
			b_backstep.visible = !b_backstep.visible;

			if (t_continue.get_active()) {
				t_continue.label = "Continue";
				onEvent(TypeEvent.STOP);
			}
			else {
				t_continue.label = "Stop";
				onEvent(TypeEvent.CONTINUE);
			}
		});

		t_reverse.toggled.connect(() => {

			if (t_reverse.get_active()) {
				i_reverse.icon_name = "media-skip-backward-symbolic";
				onEvent(TypeEvent.FORWARD);
			}
			else {
				i_reverse.icon_name = "media-skip-forward-symbolic";
				onEvent(TypeEvent.REVERSE);
			}
		});


		b_spin.value_changed.connect(() => {
			onChangeSpeed((int)b_spin.value);
		});
	}

	public signal void onEvent(TypeEvent type);
	public signal void onChangeSpeed(int speed);

	private Gtk.SpinButton		b_spin;
	private Gtk.Button			b_step;
	private Gtk.Button			b_backstep;
	private Gtk.Button			b_nouveau;
	private Gtk.ToggleButton	t_continue;
	private Gtk.ToggleButton	t_reverse;
	private Gtk.Image			i_reverse;
	private Gtk.Label			l_count;
}
