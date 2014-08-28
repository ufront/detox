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

class WidgetLoop<T, W:KeepWidget> extends Loop<T>
{
	var widgetClass:Class<W>;
	var propName:String;
	var constructorArgs:Array<Widget>;
	public var autoMapData:Bool;

	public function new(widgetClass:Class<W>, ?propName:String = null, ?autoMapData = false)
	{
		super();
		this.widgetClass = widgetClass;
		this.propName = propName;
		this.autoMapData = autoMapData;
		this.constructorArgs = [];
	}

	override function generateItem(input:T):WidgetLoopItem<T, W>
	{
		var w:W = Type.createInstance(widgetClass, constructorArgs);
		return new WidgetLoopItem(this, input, w).bindData();
	}

	override public function addItem(input:T, ?pos:Int):WidgetLoopItem<T, W>
	{
		return cast super.addItem(input, pos);
	}

	inline public function getWidgetLoopItems():Array<WidgetLoopItem<T, W>>
	{
		return cast items;
	}
	
	public function refreshItems()
	{
		for ( item in getWidgetLoopItems() )
		{
			item.bindData();
		}
	}

	override public function findItem(?input:T, ?node:DOMNode, ?collection:DOMCollection):WidgetLoopItem<T,W>
	{
		return cast super.findItem(input, node, collection);
	}
}

class WidgetLoopItem<T, W:KeepWidget> extends LoopItem<T>
{
	public var widget(get,null):W;

	public function new(loop:Loop<T>, ?input:T, ?dom:W)
	{
		super(loop, input, dom);
	}
	
	/**
		Re-bind the data for this loop item.
		Used when first creating the loop, and if you want to trigger a refresh.
	**/
	@:access(dtx.widget.WidgetLoop)
	public function bindData()
	{
		var widgetLoop = Std.instance( loop, WidgetLoop );
		// Set the property or the map of properties
		if (widgetLoop.propName != null)
		{
			Reflect.setProperty(widget, widgetLoop.propName, input);
		}
		if (widgetLoop.autoMapData)
		{
			widget.mapData(input);
		}
		return this;
	}

	function get_widget()
	{
		return cast dom;
	}
}
