package mypackage;
import domtools.Widget;

class EmailView extends Widget 
{
	static var tpl = domtools.Macros.loadTemplate();

	public function new()
	{
		super(tpl);
	}
}