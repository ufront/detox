package mypackage;
import Detox.Widget;
using Detox;

class EmailView extends Widget 
{
	static var tpl = Widget.loadTemplate();

	public function new(m:Message)
	{
		super(tpl);
		this.find(".from").setText(m.from);
		this.find(".to").setText(m.to);
		this.find(".subject").setText(m.subject);
		this.find(".message").setText(m.message);
	}
}

typedef Message = {
	var from:String;
	var to:String;
	var subject:String;
	var message:String;
}