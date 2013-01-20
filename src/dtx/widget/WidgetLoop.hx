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

	override function generateItem(input:T):WidgetLoopItem<T, W>
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
			w.mapData(input, propMap);
		}
		if (autoPropMap)
		{
			w.mapData(input);
		}
		return new WidgetLoopItem(input, w);
	}

	public function getWidgetLoopItems():Array<WidgetLoopItem<T, W>>
	{
		return cast items;
	}
}

class WidgetLoopItem<T, W:dtx.widget.Widget> extends LoopItem<T>
{
	public var widget(get,null):W;

	public function new(?input:T, ?dom:W)
	{
		super(input, dom);
	}

	public function get_widget()
	{
		return cast dom;
	}
}