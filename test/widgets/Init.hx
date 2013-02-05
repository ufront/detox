package widgets;

import dtx.widget.Widget;

class Init extends Widget
{
	override public function init()
	{
		title = "Init Test";
		myPartial.partialName = "My Partial";
		myPartial.partialContent = "Some Content";
	}
}