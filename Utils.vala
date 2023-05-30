namespace Utils{

public string new_prog(ref string path, int []tab, ref bool is_running) {
	int fds[2];
	string str = "";
	bool timeout = false;

	Posix.pipe(fds);
	var pid = Posix.fork();
	if (pid == 0) {
		Posix.close(fds[0]);
		Posix.dup2(fds[1], 1);
		string nb_string = "";
		foreach (var i in tab) {
			nb_string += @"$i ";
		}
		printerr("Execution de push_swap avec %s\n", nb_string);
		Posix.execv(path, {"push_swap", nb_string.strip()});
		printerr("Error impossible d'ouvrir %s\n", path);
		Posix.exit(-1);
	} 
	Posix.close(fds[1]);
	var thread = new Thread<void>("dsfsdf", () =>{
		int i = 0;
		while (timeout == false) {
			Posix.sleep(1);
			if (i == 15) {
				timeout = true;
				Posix.exit(pid);
				break;
			}
		}
	});
	var stream = FileStream.fdopen(fds[0], "r");
	while (is_running) {
		var tmp = stream.read_line();
		if (tmp == null)
			break;
		str += @"$tmp\n";
		Gtk.main_iteration_do(false);
	}
	if (is_running == false)
		Posix.kill(pid, Posix.Signal.INT);
	Posix.close(fds[0]);
	Posix.waitpid(pid, null, 0);
	if (timeout == true)
		return "";
	timeout = true;
	thread.join();
	return str;
}

public int []get_random_tab(int size)
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
}
