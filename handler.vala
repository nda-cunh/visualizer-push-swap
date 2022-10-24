// modules: gtk+-3.0 posix
// sources: function.vala main.vala

public void ft_zoom(Gtk.SpinButton spin, Gtk.Adjustment a)
{
	G_ZOOM = (int) a.value;
	refresh();
}

public void ft_speed(Gtk.SpinButton spin, Gtk.Adjustment adj)
{
	int val;

	if (adj == null)
		return ;
	val = (int) adj.value;
	if(val == 1)
		G_SPEED = 50000;
	else if(val == 2)
		G_SPEED = 25000;
	else if(val == 3)
		G_SPEED = 10000;
	else if(val == 4)
		G_SPEED = 5000;
	else if(val == 5)
		G_SPEED = 2000;
	else if(val == 6)
		G_SPEED = 500;
}

public void ft_pause()
{
    print("Pause\n");
	if (G_PAUSE)
		G_PAUSE = false;
	else
		G_PAUSE = true;
}

public void ft_nouveau()
{
    print("Nouveau\n");
	G_KILL = true;
	Posix.usleep(50000);
	programme();
	G_KILL = false;
}

public void ft_replay()
{
    print("Replay\n");
	G_KILL = true;
	Posix.usleep(50000);
	programme(true);
	G_KILL = false;
}


