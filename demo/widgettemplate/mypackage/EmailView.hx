package mypackage;
import domtools.Widget;

class EmailView extends Widget 
{
	static var tpl = Widget.loadTemplate();

	public function new()
	{
		super(tpl);
	}
}