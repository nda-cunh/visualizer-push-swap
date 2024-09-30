/***
 *  Class Options
 *  This class is used to parse the command line arguments
 *  and set the options for the program
 ******************************************************************************/

public class Options {

	public static bool		version = false;
	public static string?	push_swap_emp = null;
	public static int		nb_max = 100;
	public static string?	input = null;
	public static int		speed = 3;

	public static void parse(string[] args) throws Error {
		var context = new GLib.OptionContext("push_swap visualizer");
		context.set_help_enabled(true);
		context.add_main_entries(options, null);
		context.parse(ref args);

		if (Options.version) {
			print("push_swap visualizer %s\n", Config.VERSION);
			Process.exit (0);
		}

		if (Options.push_swap_emp == null) {
			var? path = search_path();
			Options.push_swap_emp = (!)path ?? "./push_swap";
		}
	}

	private const GLib.OptionEntry[] options = {
		{ "version", 'v', OptionFlags.NONE, OptionArg.NONE, ref version, "Display version number", null },
		{ "push_swap", 'p', OptionFlags.NONE, OptionArg.STRING, ref push_swap_emp, "The path of push_swap binary", "PATH" },
		{ "number_max", 'n', OptionFlags.NONE, OptionArg.INT, ref nb_max, "How many numbers will be generated (100 default)"  , "INT" },
		{ "input", 'i', OptionFlags.NONE, OptionArg.STRING, ref nb_max, "Your input if you want like '5 4 2 1 3'"  , "INPUT" },
		{ "speed", 's', OptionFlags.NONE, OptionArg.INT, ref speed, "Default speed (3)"  , "INT" },
		{ null }
	};
}



/***
 *  Function search_path
 *  This function is used to search the push_swap binary in the current directory
 *  and the parent directory
 ******************************************************************************/
private string? search_path () {
	bool is_good (string path) {
		if (FileUtils.test(path, FileTest.EXISTS | FileTest.IS_EXECUTABLE)) {
			if (FileUtils.test(path, FileTest.IS_DIR))
				return false;
			return true;
		}
		return false;
	}

	print("looking for:	 ./push_swap\n");
	if (is_good("./push_swap"))
		return "./push_swap";

	print("looking for:	 ../push_swap\n");
	if (is_good("../push_swap"))
		return "../push_swap";

	print("looking for:	 ../push_swap/push_swap\n");
	if (is_good("../push_swap/push_swap"))
		return "../push_swap/push_swap";

	printerr("your push_swap is not found :)\n");
	return null;
}
