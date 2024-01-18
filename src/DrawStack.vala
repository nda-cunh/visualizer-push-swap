
enum DrawType {
	A,
	B
}


class DrawStack {
	public DrawStack (Gtk.DrawingArea area, DrawType type) {
		this.area = area;
		this.type = type;

		stack = new Queue<int>();
		area.set_draw_func(drawing_func);
	}
	
	public void clear (int nb_max) {
		stack.clear ();
		this.len_max = nb_max;
	}
	
	public void refresh () {
		area.queue_draw ();
	}

	public void drawing_func (Gtk.DrawingArea self, Cairo.Context ctx, int width, int height) {
		if (type == A)
			ctx.set_source_rgb(1.0, 0.0, 1.0);
		else
			ctx.set_source_rgb(0.0, 0.0, 1.0);
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
			G_SIZE = 1.0;
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
			if (item == 0) {
				item = 50;
				ctx.set_source_rgb (0, 1.0, 1.0);
			}
			ctx.set_line_width(G_ZOOM);
			ctx.move_to (0, y);
			ctx.line_to (item * G_SIZE, y);
			y += G_ZOOM;
			ctx.stroke ();
		}
	}

	public int len_max;
	private DrawType type;
	public Queue<int> stack;
	private unowned Gtk.DrawingArea area;
}
