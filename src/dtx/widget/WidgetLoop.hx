package dtx.widget;

import dtx.widget.Loop;
import ufcommon.view.dbadmin.*;
using Detox;

class WidgetLoop<T> extends Loop<T>
{
	var widgetClass:Class<dtx.widget.Widget>;
	var propName:String;
	var propMap:Dynamic<String>;
	var autoPropMap:Bool;

	public function new(widgetClass:Class<dtx.widget.Widget>, ?propName:String = null, ?propMap:Dynamic<String> = null, ?autoPropMap = true)
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
		if (autoPropMap)
		{
			var fieldNames:Array<String>;
			switch (Type.typeof(input))
			{
				case TObject:
					// Anonymous object, use Reflect.fields()
					fieldNames = Reflect.fields(input);
				case TClass(c):
					// Class instance, use Type.getInstanceFields()
					fieldNames = Type.getInstanceFields(c);
				default:
					// This is not an object, so don't do property mapping
					fieldNames = [];
			}

			for (fieldName in fieldNames)
			{
				var modelValue = Reflect.getProperty(input, fieldName);
				Reflect.setProperty(w, fieldName, modelValue);
			}
		}
		return new LoopItem(input, w);
	}
}