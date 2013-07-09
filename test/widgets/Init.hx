package widgets;

import dtx.widget.Widget;

class Init extends Widget
{
	public function new()
	{
		super();
		title = "Init Test";
		myPartial.partialName = "My Partial";
		myPartial.partialContent = "Some Content";
	}
}