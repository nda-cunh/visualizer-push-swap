
namespace Utils {
	// take a string[] and return a int[] sorted
	int[] normalize (string[] bfs) {
		var vala_tab = new int[bfs.length];
		for (int i = 0; i < bfs.length - 1; i++)
		{
			int nb = int.parse(bfs[i]);
			vala_tab[i] = nb;
		}
		Array<int> tab = new GLib.Array<int>();
		tab.append_vals (vala_tab, vala_tab.length - 1);

		tab.sort ((a, b) => {
			return a - b;
		});

		return (owned)tab.data;
	}

	// Simple asynchrone sleep
	public async void sleep(int time) {
		Timeout.add(time, sleep.callback);
		yield;
	}

	// Simple asynchrone usleep
	public async void usleep(int time) {
		if (time != 0) {
			new Thread<void>(null, ()=> {
				Thread.usleep(time);
				Idle.add(usleep.callback);
			});
		}
		else
			Idle.add(usleep.callback, Priority.HIGH_IDLE);
		yield;
	}

	// Return a random int[] of size
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
