using Detox;

class Main 
{
	public static function main()
	{
		haxe.Log.trace = haxe.Firebug.trace;
		
		Detox.Query.window.onload = run;
	}

	public static function run(e)
	{
		var view = new ContactView("Jason", "jason.oneil@gmail.com", 24);
		var view2 = new mypackage.EmailView({
			to: "mrcottonsocks@cats.com",
			from: "jason.oneil@gmail.com",
			subject: "Who's a cute kitty?",
			message: "Yes you are.  Cute kitty.  Yes you are."
		});
		"body".find().append(view);
		"body".find().append(view2);
	}
}