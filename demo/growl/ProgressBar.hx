using DOMTools;

class ProgressBar extends domtools.Widget 
{
	static var template = "<div class='progress'>
		<div class='bar' style='width: '>
	</div>";

	var percentage:Float;
	
	public function new(?percentage:Float = 0)
	{
		super(template);

		// You can use functions and class members for your widgets
		updateProgress(percentage);

		// You can also tie events to your widget
		this.click(function (e) {
			// When we click, generate a random number and update
			var p = Math.random() * 100;
			updateProgress(p);
		});
	}

	public function updateProgress(percentage:Float)
	{
		// Later we will support changing style in our API
		// For now, do it by changing the attribute
		this.find('.bar').setAttr('style', "width: " + percentage + "%");
	}
}