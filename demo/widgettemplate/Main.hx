using DOMTools;

class Main 
{
	public static function main()
	{
		haxe.Log.trace = haxe.Firebug.trace;
		
		domtools.Query.window.onload = run;
	}

	public static function run(e)
	{
		var view = new ContactView();
		var view2 = new mypackage.EmailView();
		"body".find().append(view);
		"body".find().append(view2);
	}
}