package dtx.widget;

import dtx.widget.Loop;
import ufcommon.view.dbadmin.*;
using Detox;

class WidgetLoop<T> extends Loop<T>
{
	var widgetClass:Class<dtx.widget.Widget>;
	var propName:String;
	var propMap:Dynamic<String>;

	public function new(widgetClass:Class<dtx.widget.Widget>, ?propName:String = null, ?propMap:Dynamic<String> = null)
	{
		super();
		this.widgetClass = widgetClass;
		this.propName = propName;
		this.propMap = propMap;
	}

	override function generateItem(input:T):LoopItem<T>
	{
		// Create a new instance of [widgetClass]
		// Remember dtx.widget.Widget has one optional constructor argument, we'll leave it null.
		var w:dtx.widget.Widget = Type.createInstance(widgetClass, [null]);

		// Set the property or the map of properties
		if (propName != null)
		{
			Reflect.setProperty(w, propName, input);
		}
		if (propMap != null)
		{
			for (modelVar in Reflect.fields(propMap))
			{
				var templateVar = Reflect.field(propMap, modelVar);
				var modelValue = Reflect.getProperty(input, modelVar);
				Reflect.setProperty(w, templateVar, modelValue);
			}
		}
		return new LoopItem(input, w);
	}
}