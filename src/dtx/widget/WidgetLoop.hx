package dtx.widget;

import dtx.widget.Loop;
import ufcommon.view.dbadmin.*;
using Detox;

class WidgetLoop<T, W:dtx.widget.Widget> extends Loop<T>
{
	var widgetClass:Class<W>;
	var propName:String;
	var propMap:Dynamic<String>;
	var autoPropMap:Bool;

	public function new(widgetClass:Class<W>, ?propName:String = null, ?propMap:Dynamic<String> = null, ?autoPropMap = true)
	{
		super();
		this.widgetClass = widgetClass;
		this.propName = propName;
		this.propMap = propMap;
		this.autoPropMap = autoPropMap;
	}

	override function generateItem(input:T):LoopItem<T>
	{
		// Create a new instance of [widgetClass]
		var w:W = Type.createInstance(widgetClass, []);

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
		if (autoPropMap)
		{
			w.mapData(input);
		}
		return new LoopItem(input, w);
	}
}