package dtx.widget;

import dtx.widget.Loop;
using Detox;

class TemplateLoop<T> extends Loop<T>
{
	var template:T->String;

	public function new(template:T->String)
	{
		super();
		this.template = template;
	}

	override function generateItem(input:T):LoopItem<T>
	{
		var html = this.template(input);
		return new LoopItem(input, html.parse());
	}
}