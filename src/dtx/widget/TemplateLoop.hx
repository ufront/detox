package dtx.widget;

using Detox;

class TemplateLoop<T> extends dtx.widget.Loop<T>
{
	var template:T->String;

	public function new(template:T->String)
	{
		super();
		this.template = template;
	}

	override function generateItem(input:T):DOMCollection
	{
		var html = this.template(input);
		return html.parse();
	}
}