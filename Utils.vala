namespace Utils{
	public async void sleep(int time) {
		Timeout.add(time, sleep.callback);
		yield;
	}
	public async void usleep(int time) {
		if (time != 0) {
			new Thread<void>(null, ()=> {
				Thread.usleep(time);
				Idle.add(usleep.callback);
			});
		}
		else
			Idle.add(usleep.callback);
		yield;
	}

	public int []get_random_tab(int size)
	{
		var rand = new Rand();
		var tab = new int[size];
		var nb = 0;

		for(int i = 0; i!= size; ++i)
		{
			nb = rand.int_range(1, size + 1);
			if(nb in tab)
				--i;
			else
				tab[i] = nb;
		}
		return tab;
	}
}
