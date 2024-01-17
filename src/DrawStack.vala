
enum DrawType {
	A,
	B
}


class DrawStack {
	public DrawStack (Gtk.DrawingArea area, DrawType type) {
		this.area = area;
		this.type = type;

		area.set_draw_func(drawing_func);
	}

	public void drawing_func (Gtk.DrawingArea self, Cairo.Context ctx, int width, int height) {
		if (type == A)
			ctx.set_source_rgb(1.0, 0.0, 1.0);
		else
			ctx.set_source_rgb(0.0, 0.0, 1.0);
		ctx.paint();
	}

	private DrawType type;
	private Queue<int> stack;
	private unowned Gtk.DrawingArea area;
}
