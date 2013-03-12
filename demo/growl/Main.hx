using Detox;
import Notification;
import ProgressBar;

class Main 
{
	public static function main()
	{
		// Run out function when the page is ready
		Detox.ready(run);
	}

	public static function run()
	{
		var form = "form".find();
		var titleInput = "#title".find();
		var commentInput = "#comment".find();

		// When the form is submitted (either by click or by pressing enter)
		form.submit(function (e) {
			// Create a new Notification widget, based off the form values
			var n = new Notification(titleInput.val(), commentInput.val());

			// Append this widget to our notifications area
			"#notifications".find().prepend(n);

			e.stopPropagation();
			e.preventDefault();
			return false;
		});

		// When the "Notify + Progress" button is clicked
		"#notifyWithProgress".find().click(function (e) {
			// Create a new notification widget, as before
			var n = new Notification(titleInput.val(), commentInput.val());

			// Generate a random percentage, create a progress bar
			var percentage = Math.random() * 100;
			var p = new ProgressBar(percentage);

			// Because both of these widgets are essentially HTML objects
			// we can move them around and treat them like any other DOM node.
			// Here, we attach the progress bar to the notification
			n.append(p);

			// Now attach the notification (with progress bar) to the notifications area
			"#notifications".find().prepend(n);

			e.stopPropagation();
			e.preventDefault();
			return false;
		});
	}


}