using Gtk;
using Cairo;

public class DrawStack {

    private int hovered_index = -1;
    private double mouse_x = 0;
    private double mouse_y = 0;

    public Queue<int> stack;
    private int len_max;
    private DrawType type;
    private Gtk.DrawingArea area;

    public enum DrawType {
        A,
        B
    }

    public DrawStack (Gtk.DrawingArea area, DrawType type) {
        this.area = area;
        this.type = type;
        this.stack = new Queue<int>();

        var motion = new Gtk.EventControllerMotion();
        motion.motion.connect(on_mouse_move);
        motion.leave.connect(on_mouse_leave);
        ((Gtk.Widget)area).add_controller(motion);

        area.set_draw_func(drawing_func);
    }

	private double get_g_size() {
		if (len_max <= 10) return 30.0;
		if (len_max <= 25) return 10.0;
		if (len_max <= 50) return 8.0;
		if (len_max <= 100) return 3.8;
		if (len_max <= 150) return 2.0;
		if (len_max <= 350) return 1.5;
		if (len_max <= 520) return 1.0;
		return 0.5;
	}

	private void on_mouse_move(double x, double y) {
		this.mouse_x = x;
		this.mouse_y = y;
		
		if (len_max <= 0 || stack.get_length() == 0) return;

		int zoom = get_zoom_level();
		int index = (int) Math.round((y - zoom) / (double)zoom);

		bool is_inside_bar = false;
		if (index >= 0 && index < stack.get_length()) {
			double g_size = get_g_size(); // On utilise une petite fonction helper
			int val = stack.peek_nth(index);
			double bar_width = (val == 0 ? 50 : val) * g_size;

			if (x >= 0 && x <= bar_width) {
				is_inside_bar = true;
			}
		}

		if (is_inside_bar) {
			if (hovered_index != index) {
				hovered_index = index;
				area.queue_draw();
			}
		} else if (hovered_index != -1) {
			hovered_index = -1;
			area.queue_draw();
		}
	}


	private void on_mouse_leave() {
        hovered_index = -1;
        area.queue_draw();
    }

    private int get_zoom_level() {
        if (len_max <= 10) return 40;
        if (len_max <= 25) return 20;
        if (len_max <= 50) return 7;
        if (len_max <= 100) return 5;
        if (len_max <= 150) return 3;
        if (len_max <= 350) return 2;
        if (len_max <= 520) return 1;
        return 1;
    }

    public void clear (int nb_max) {
        stack.clear();
        this.len_max = nb_max;
        this.hovered_index = -1;
        this.area.queue_draw();
    }

    public void refresh () {
        area.queue_draw();
    }

    public void drawing_func (Gtk.DrawingArea self, Cairo.Context ctx, int width, int height) {
        double color_a;
        double y_pos;
        double G_SIZE;
        int G_ZOOM = get_zoom_level();

        if (len_max <= 10) G_SIZE = 30.0;
			else if (len_max <= 25) G_SIZE = 10.0;
			else if (len_max <= 50) G_SIZE = 8.0;
			else if (len_max <= 100) G_SIZE = 3.8;
			else if (len_max <= 150) G_SIZE = 2.0;
			else if (len_max <= 350) G_SIZE = 1.5;
			else if (len_max <= 520) G_SIZE = 1.0;
        else G_SIZE = 0.5;

        y_pos = G_ZOOM;

        Queue<int> copy = stack.copy();
        
        while (copy.get_length() != 0) {
            double item = (double)copy.pop_head();
            
            color_a = (item / len_max) + 0.2;
			ctx.set_source_rgb (color_a, 0, 0);
            
            if (item == 0) {
                item = 50;
                ctx.set_source_rgb(0, 1.0, 1.0);
            }

            ctx.set_line_width(G_ZOOM);
            ctx.move_to(0, y_pos);
            ctx.line_to(item * G_SIZE, y_pos);
            y_pos += G_ZOOM;
            ctx.stroke();
        }
	
        if (hovered_index != -1 && hovered_index < stack.get_length()) {
            int val = stack.peek_nth(hovered_index);
            string text = @"Val: $val";

            ctx.select_font_face("Sans", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
            ctx.set_font_size(13.0);
            
            Cairo.TextExtents extents;
            ctx.text_extents(text, out extents);

            ctx.set_source_rgba(0, 0, 0, 0.8);
            ctx.rectangle(mouse_x + 15, mouse_y + 25, extents.width + 10, extents.height + 10);
            ctx.fill();

            ctx.set_source_rgb(1.0, 1.0, 1.0);
            ctx.move_to(mouse_x + 20, mouse_y + 25 + extents.height + 2);
            ctx.show_text(text);
        }
    }
}
