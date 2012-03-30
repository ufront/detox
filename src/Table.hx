
using DOMTools;

class Table extends domtools.AbstractCustomElement
{
	public function new()
	{
		super("table");
		this.setInnerHTML("<tr><td>Sample</td><td>Table!</td></tr><tr><td>Pretty</td><td>Great</td></tr>");
	}
}