using Detox;
import Detox;

class Main
{
	static public function main()
	{
		// Run out app after the window has finished loading.
		Detox.ready(run);
	}

	static function run()
	{
		trace ("Welcome to my app!");

		// Find the key parts of our app.
		var form = "#inputform".find();
		var input = "#task".find();
		var tasks = "#tasks".find();
		var clear = "#clear".find();

		// On submit, add a new item to our list.
		"#inputform".find().submit(function (e) {

			// Get the value
			var val = input.val();

			// Create the list item, add it to the bottom
			var li = "li".create().setText(val);
			tasks.append(li);

			// Reset the input field
			input.setVal("");

			// Prevent the page from going anywhere
			e.preventDefault();
		});

		// When someone clicks on a task, toggle it
		tasks.click(function (e) {
			var target:DOMNode = cast e.target;
			if (target.tagName() == "li")
			{
				target.toggleClass('completed');
			}
		});

		// When someone clicks "Clear Completed", do it
		clear.click(function (e) {
			tasks.find(".completed").remove();
		});

	}
}