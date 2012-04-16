import domtools.Widget;

class ContactView extends Widget 
{
	static var tpl = domtools.Macros.loadTemplate("ContactView.tpl");

	public function new()
	{
		super(tpl);
	}
}