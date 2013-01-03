package dtx.widget;

import dtx.widget.Loop;
import ufcommon.view.dbadmin.*;
using Detox;

class WidgetLoop<T> extends Loop<T>
{
	var widgetClass:Class<dtx.widget.Widget>;
	var propName:String;

	public function new(widgetClass:Class<dtx.widget.Widget>, propName:String)
	{
		super();
		this.widgetClass = widgetClass;
		this.propName = propName;
	}

	override function generateItem(input:T):LoopItem<T>
	{
		// Create a new instance of [widgetClass]
		// Remember dtx.widget.Widget has one optional constructor argument, we'll leave it null.
		var w:dtx.widget.Widget = Type.createInstance(widgetClass, [null]);

		// Set the property - this should be a fancy 
		Reflect.setProperty(w, propName, input);
		return new LoopItem(input, w);
	}
}