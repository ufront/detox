/****
* Copyright (c) 2013 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/

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
		return new WidgetLoopItem(this, input, w);
	}

	override public function addItem(input:T, ?pos:Int):WidgetLoopItem<T, W>
	{
		return cast super.addItem(input, pos);
	}

	inline public function getWidgetLoopItems():Array<WidgetLoopItem<T, W>>
	{
		return cast items;
	}

	override public function findItem(?input:T, ?node:DOMNode, ?collection:DOMCollection):WidgetLoopItem<T,W>
	{
		return cast super.findItem(input, node, collection);
	}
}

class WidgetLoopItem<T, W:dtx.widget.Widget> extends LoopItem<T>
{
	public var widget(get,null):W;

	public function new(loop:Loop<T>, ?input:T, ?dom:W)
	{
		super(loop, input, dom);
	}

	public function get_widget()
	{
		return cast dom;
	}
}