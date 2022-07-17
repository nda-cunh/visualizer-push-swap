//valac main.vala function.vala --pkg=gtk+-3.0 --pkg=posix

using Gtk;

Queue<int> s_a;
Queue<int> s_b;
int G_ZOOM = 7;
int G_SPEED = 5000;
DrawingArea va;
DrawingArea vb;
int NBR_SIZE;
int G_NBR_COUP;
Gtk.Label label_coup;

public class MagikBox : Gtk.Box{
    public MagikBox()
    {
        label_coup = new Gtk.Label.with_mnemonic(@"\nNombre de coups $(G_NBR_COUP)\n");
        button = new Button.with_label("Replay");
        b_replay = new Button.with_label("NOUVEAU");
        spinspeed = new SpinButton.with_range(1.0, 5.0, 1.0);
        spinzoom = new SpinButton.with_range(1.0, 7.0, 1.0);
        this.set_orientation(Gtk.Orientation.VERTICAL);
        this.set_hexpand(false);
        this.set_vexpand(false);
        this.add(button);
        this.add(new Label("ZOOM"));
        this.add(spinzoom);
        this.add(new Label("SPEED"));
        this.add(spinspeed);
        this.add(new Label("\n\n"));
        this.add(b_replay);
        this.add(label_coup);
        timerclick = new Timer ();
        b_replay.clicked.connect(() =>{programme(1);});
        button.clicked.connect(() =>{programme();});
        spinzoom.set_value(5.0);
        spinzoom.value_changed.connect(() =>{
            if (spinzoom.get_value() == 7.0)
                G_ZOOM = 1;
            if (spinzoom.get_value() == 6.0)
                G_ZOOM = 3;
            if (spinzoom.get_value() == 5.0)
                G_ZOOM = 7;
            if (spinzoom.get_value() == 4.0)
                G_ZOOM = 12;
            if (spinzoom.get_value() == 3.0)
                G_ZOOM = 20;
            if (spinzoom.get_value() == 2.0)
                G_ZOOM = 30;
            if (spinzoom.get_value() == 1.0)
                G_ZOOM = 35;
            va.queue_draw();
            vb.queue_draw();
            Posix.usleep(5000);
        });
        spinspeed.set_value(2);
        spinspeed.value_changed.connect(() =>{
            if (spinspeed.get_value() == 1.0)
                G_SPEED = 8000;
            if (spinspeed.get_value() == 2.0)
                G_SPEED = 4000;
            if (spinspeed.get_value() == 3.0)
                G_SPEED = 2000;
            if (spinspeed.get_value() == 4.0)
                G_SPEED = 800;
            if (spinspeed.get_value() == 5.0)
                G_SPEED = 100;
            Posix.usleep(5000);
        });
        this.margin = 10;
    }
    private Gtk.Button button;
    private Gtk.Button b_replay;
    private Gtk.SpinButton spinspeed;
    private Gtk.SpinButton spinzoom;
    private Timer timerclick;
}

public int calme = 0;

bool list_dir() {
    
    var fd = FileStream.open("tmp_file", "r");
    var s = "";
    
    G_KILL = 0;
    G_NBR_COUP = 0;
    while(s != null)
    {
        s = fd.read_line();
        G_NBR_COUP++;
        label_coup.label = @"\nNombre de coups $(G_NBR_COUP)\n";
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
        if(G_KILL == 1)
            return (false);
        if(G_KILL == 1)
            return (false);

        Posix.usleep(G_SPEED);
    }
    label_coup.set_text(@"\nNombre de coups $(G_NBR_COUP)\n");
    return (true);
}

int main (string[] args) {
	Gtk.init (ref args);

    s_a = new Queue<int>();
    s_b = new Queue<int>();
	var window = new Window ();
	va = new DrawingArea ();
	vb = new DrawingArea ();
	window.set_default_size (900, 500);
	var box = new Box (Gtk.Orientation.HORIZONTAL, 0);
	var multibox = new MagikBox();
	box.add(multibox);
	//box.set_homogeneous (true);
	box.add (va);
	va.draw.connect((cr) => {return (draw_stack(cr, 1));});
	va.set_hexpand(true);
	vb.draw.connect((cr) => {return (draw_stack(cr, 2));});
	vb.set_hexpand(true);
	box.add (vb);
	window.title = "vizualizer";
	window.destroy.connect (Gtk.main_quit);
    window.add (box);
	window.show_all ();
	(args[1] != null) ? NBR_SIZE = int.parse(args[1]) : NBR_SIZE = 500;
	print("%d\n\n\n\n", NBR_SIZE);
	G_TAB = get_random_tab(NBR_SIZE);
	programme();
	Gtk.main ();
	return 0;
}
int G_KILL;
int []G_TAB;

public void programme(int x = 0)
{
    
	var s = "";
	if(x == 1)
	    G_TAB = get_random_tab(NBR_SIZE);
	while(s_a.get_length() != 0 || s_b.get_length() != 0)
    {
		s_a.pop_head();
		s_b.pop_head();
	}
	
	foreach (var i in G_TAB)
	{
	    s_a.push_tail(i);
	    s +=i.to_string() + " ";
	}
	G_KILL = 1;
	Posix.usleep(12000);
	Posix.system(@"./push_swap \"$(s)\" > tmp_file");
	try {
        var th1 = new Thread<bool>("CPU2", list_dir);
    }catch(ThreadError e){
        print ("ThreadError: %s\n", e.message);
    }
}

bool draw_stack(Cairo.Context cr, int s)
{
    Queue<int> copy;
    var x = 0;
    double color_a;    
    
	cr.set_line_width (1);
	
    if(s == 1)
        copy = s_a.copy();
    else
        copy = s_b.copy();
    while(copy.get_length() != 0)
    {
		int item = copy.pop_head();
		
		color_a = ((double)item * 0.8 / 1000) + 0.2;
		cr.set_source_rgb (color_a, 0, 0);
		cr.move_to (0, x);
	    cr.line_to (item / G_ZOOM, x);
		x += 2;
	    cr.stroke ();
	}
	va.queue_draw();
    vb.queue_draw();
    return true;
}

int []get_random_tab(int size)
{
    var tab = new int[size];
    var nb = 0;
    for(int i = 0; i!= size; i++)
 	{ 
 	    nb = Random.int_range(0, 1000); 
 		if(nb in tab) 
 			i--; 
 		else 
 			tab[i] = nb;
 	} 
    return tab;
}
