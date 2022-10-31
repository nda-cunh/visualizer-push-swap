// modules: gtk+-3.0 posix
// sources: function.vala inde.vala
using Posix;
using Gtk;

Queue<int> s_a;
Queue<int> s_b;
Mutex mutex_gtk;
int G_SIZE = 100;
int G_ZOOM = 4;
int G_SPEED = 25000;
Gtk.DrawingArea va;
Gtk.DrawingArea vb;
bool G_KILL = false;
bool G_PAUSE = false;
int []G_TAB;
bool g_running = true;
Label g_label;

bool draw_stack(Cairo.Context cr, bool stack)
{
	Queue<int>	copy;                                  
	double		color_a;                                   
	var			x = 0;
	var			y = 0.0;

	if (G_SIZE >= 2)
		y = 35.0;
	if (G_SIZE >= 25)
		y = 6.0;
	if (G_SIZE >= 45)
		y = 5.0;
	if (G_SIZE >= 90)
		y = 2.0;
	if (G_SIZE >= 299)
		y = 0.8;
	if (G_SIZE >= 400)
		y = 0.5;

	cr.set_line_width (1);
	if(stack)
		copy = s_a.copy();
	else
		copy = s_b.copy();
	while(copy.get_length() != 0)
	{
		int item = copy.pop_head();

		color_a = ((double)item * 0.8 / G_SIZE) + 0.2;
		cr.set_source_rgb (color_a, 0, 0);
		cr.set_line_width(G_ZOOM);
		cr.move_to (0, x);            
		cr.line_to (item * y, x);
		x += G_ZOOM;
		cr.stroke ();
	}
	return true;
}

void main(string []args)
{
	Gtk.init (ref args);
	mutex_gtk = Mutex();
	G_SIZE = (args[1] == null) ? 44 : int.parse(args[1]);

	var builder = new Gtk.Builder.from_string(INDEX_UI, INDEX_UI.length);
	builder.connect_signals (null);

	va = builder.get_object ("drawing_a") as Gtk.DrawingArea;
	vb = builder.get_object ("drawing_b") as Gtk.DrawingArea;
	va.draw.connect((cr) => {return (draw_stack(cr, true));});
	vb.draw.connect((cr) => {return (draw_stack(cr, false));});
	g_label = builder.get_object ("nbr_coup") as Gtk.Label;
	programme();
	while(g_running)
	{
		usleep(500);
		mutex_gtk.lock();
		main_iteration_do(false);
		mutex_gtk.unlock();
	}
	G_KILL = true;
	main_quit();
}

public void kick()
{
	print("terminee\n");
	g_running = false;
}

//redraw the stack A and B
void refresh()
{
	va.queue_draw();
	vb.queue_draw();
}

// Analyse Flux Stdin of push_swap and call good function
void list_dir(int	fd_in) {

	var fd = FileStream.fdopen(fd_in, "r");
	var s = "";
	var nb = 0;

	while(!fd.eof())
	{
		if (G_PAUSE)
		{
			usleep(500);
			continue;
		}
		if(G_KILL)
		{
			G_KILL = false;
			print("Thread terminée");
			return ;
		}
		s = fd.read_line();
		if(s == "ra")
			ra();
		else if (s == "rra")
			rra();
		else if (s == "sa")
			sa();
		else if (s == "sb")
			sb();
		else if (s == "ss")
			ss();
		else if (s == "pb")
			pb();
		else if (s == "pa")
			pa();
		else if (s == "rb")
			rb();
		else if (s == "rrb")
			rrb();
		else if (s == "rr")
			rr();
		else if (s == "rrr")
			rrr();
		else
			continue;
		nb++;
		mutex_gtk.lock();
		g_label.label = nb.to_string();
		refresh();
		mutex_gtk.unlock();
		Posix.usleep(G_SPEED);
	}
}

// run the push_swap programme
int run_push_swap(string tab, out int pid)
{
	int fds[2];
	string	emp;

	if (!(Posix.access("./push_swap", X_OK) == 0))
	{
		print("[Info]: recherche de push_swap ../");
		emp = "../push_swap";
	}
	else
		emp = "./push_swap";
	pipe(fds);
	pid = fork();
	if (pid == 0)
	{	
		close(fds[0]);
		dup2(fds[1], 1);
		execv(emp, {"push_swap", tab});
		exit(0);
	}
	close(fds[1]);
	return (fds[0]);
}

void programme(bool replay = false)
{
	s_a = new Queue<int>();
	s_b = new Queue<int>();
	print("nouveau programme\n");
	new Thread<void>("prog", () => {
		var s = "";
		if (replay == false)
			G_TAB = get_random_tab(G_SIZE);	
		while (s_a.get_length() != 0 || s_b.get_length() != 0)
		{
			s_a.pop_head();
			s_b.pop_head();
		}
		foreach (var i in G_TAB)
		{
			s_a.push_tail(i);
			s +=i.to_string() + " ";
		}
		print("lancement avec :%s\n", s);
		int pid;
		int fd = run_push_swap(s, out pid);
		list_dir(fd);
		kill(pid, 9);
	});
}

int []get_random_tab(int size)
{
	var tab = new int[size];
	var nb = 0;
	for(int i = 0; i!= size; i++)
	{
		nb = Random.int_range(1, size + 1);
		if(nb in tab)
			i--;
		else
			tab[i] = nb;
	}
	return tab;
}
