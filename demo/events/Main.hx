using Detox;

class Main 
{
	public static function main()
	{
		// Set up trace to use the console
		haxe.Log.trace = haxe.Firebug.trace;

		// Run out function when the page is ready
		Detox.ready(run);
	}

	public static function run()
	{
		var container = "#mainarea".find();
		for (i in 0...10)
		{
			var b = new Button();
			b.appendTo(container);
			b.setText("Button " + i);
		}
	}
}

@template("<button class='btn btn-danger'>My Button</button>")
class Button extends dtx.widget.Widget {}