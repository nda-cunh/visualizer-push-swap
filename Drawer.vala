//valac main.vala Window.vala Menu.vala Drawer.vala --pkg=gtk+-3.0

class DrawStack : Gtk.DrawingArea {
	private unowned Queue<int>	stack;
	public DrawStack(ref Queue<int> stack, int len_max) {
		Object(expand: true, hexpand:true, vexpand:true);
		this.stack = stack;
		base.draw.connect(this.drawing);
		this.len_max = len_max;
	}

	public bool drawing(Cairo.Context ctx) {
		double		color_a;
		double		y;
		int G_ZOOM;
		double G_SIZE;

		if (len_max <= 10) {
			G_ZOOM = 40;
			G_SIZE = 30.0;
		}
		else if (len_max <= 25) {
			G_ZOOM = 20;
			G_SIZE = 10.0;
		}
		else if (len_max <= 50) {
			G_ZOOM = 7;
			G_SIZE = 8.0;
		}
		else if (len_max <= 100) {
			G_ZOOM = 5;
			G_SIZE = 3.8;
		}
		else if (len_max <= 150) {
			G_ZOOM = 3;
			G_SIZE = 2;
		}
		else if (len_max <= 350) {
			G_ZOOM = 2;
			G_SIZE = 1.5;
		}
		else if (len_max <= 520) {
			G_ZOOM = 1;
			G_SIZE = 0.7;
		}
		else{
			G_ZOOM = 1;
			G_SIZE = 0.5;
		}

		y = G_ZOOM;

		Queue<int> copy = stack.copy();
		ctx.set_line_width (1);
		while(copy.get_length() != 0)
		{
			double item = (double)copy.pop_head();
			color_a = (item / len_max) + 0.2;
			ctx.set_source_rgb (color_a, 0, 0);
			ctx.set_line_width(G_ZOOM);
			ctx.move_to (0, y);
			ctx.line_to (item * G_SIZE, y);
			y += G_ZOOM;
			ctx.stroke ();
		}
		return true;
	}
	private int len_max;
}
