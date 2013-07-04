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

package dtx.collection;

#if (haxe_211 || haxe3)
	import js.html.*;
	typedef DtxEvent = js.html.Event;
#else 
	typedef EventListener = BnEvent->Void;
	typedef DtxEvent = BnEvent;
#end

class EventManagement
{
	public static function trigger(targetCollection:Nodes, eventType:String):Nodes
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.trigger(target, eventType);
		}
		return targetCollection;
	}

	public static function on(targetCollection:Nodes, eventType:String, ?selector:String, ?listener:EventListener):Nodes
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.on(target, eventType, selector, listener);
		}
		return targetCollection;
	}

	public static function off(targetCollection:Nodes, ?eventType:String=null, ?listener:EventListener=null):Nodes
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.off(target, eventType, listener);
		}
		return targetCollection;
	}

	public static function one(targetCollection:Nodes, eventType:String, ?selector:String, listener:EventListener):Nodes
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.one(target, eventType, selector, listener);
		}
		return targetCollection;
	}

	public static inline function mousedown(target:Nodes, ?selector:String, ?listener:MouseEvent->Void):Nodes
	{
		return on(target, "mousedown", selector, untyped listener);
	}

	public static inline function mouseenter(target:Nodes, ?selector:String, ?listener:MouseEvent->Void):Nodes
	{
		return on(target, "mouseenter", selector, untyped listener);
	}

	public static inline function mouseleave(target:Nodes, ?selector:String, ?listener:MouseEvent->Void):Nodes
	{
		return on(target, "mouseleave", selector, untyped listener);
	}

	public static inline function mousemove(target:Nodes, ?selector:String, ?listener:MouseEvent->Void):Nodes
	{
		return on(target, "mousemove", selector, untyped listener);
	}

	public static inline function mouseout(target:Nodes, ?selector:String, ?listener:MouseEvent->Void):Nodes
	{
		return on(target, "mouseout", selector, untyped listener);
	}

	public static inline function mouseover(target:Nodes, ?selector:String, ?listener:MouseEvent->Void):Nodes
	{
		return on(target, "mouseover", selector, untyped listener);
	}

	public static inline function mouseup(target:Nodes, ?selector:String, ?listener:MouseEvent->Void):Nodes
	{
		return on(target, "mouseup", selector, untyped listener);
	}

	public static inline function keydown(target:Nodes, ?selector:String, ?listener:KeyboardEvent->Void):Nodes
	{
		return on(target, "keydown", selector, untyped listener);
	}

	public static inline function keypress(target:Nodes, ?selector:String, ?listener:KeyboardEvent->Void):Nodes
	{
		return on(target, "keypress", selector, untyped listener);
	}

	public static inline function keyup(target:Nodes, ?selector:String, ?listener:KeyboardEvent->Void):Nodes
	{
		return on(target, "keyup", selector, untyped listener);
	}

	public static function hover(targetCollection:Nodes, ?selector: String, listener1:MouseEvent->Void, ?listener2:MouseEvent->Void = null):Nodes
	{
		for (node in targetCollection)
		{
			dtx.single.EventManagement.hover(node, selector, listener1, listener2);
		}
		return targetCollection;
	}

	public static inline function submit(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "submit", selector, listener);
	}

	public static function toggleClick(targetCollection:Nodes, ?selector: String, listenerFirstClick:MouseEvent->Void, listenerSecondClick:MouseEvent->Void):Nodes
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.toggleClick(target, selector, listenerFirstClick, listenerSecondClick);
		}
		return targetCollection;
	}

	public static inline function blur(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "blur", selector, listener);
	}

	public static inline function change(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "change", selector, listener);
	}

	public static inline function click(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "click", selector, listener);
	}

	public static inline function dblclick(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "dblclick", selector, listener);
	}

	public static inline function focus(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "focus", selector, listener);
	}

	public static inline function focusIn(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "focusIn", selector, listener);
	}

	public static inline function focusOut(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "focusOut", selector, listener);
	}

	public static inline function resize(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "resize", selector, listener);
	}

	public static inline function scroll(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "scroll", selector, listener);
	}

	public static function wheel(target:Nodes, ?selector:String, ?listener:js.html.WheelEvent->Void):Nodes
	{
		for (n in target)
		{
			dtx.single.EventManagement.wheel(n, selector, listener);
		}
		return target;
	}

	public static inline function select(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "select", selector, listener);
	}

	public static inline function load(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "load", selector, listener);
	}

	public static inline function unload(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "unload", selector, listener);
	}

	public static inline function error(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "error", selector, listener);
	}

	public static inline function ready(target:Nodes, ?selector:String, ?listener:EventListener):Nodes
	{
		return on(target, "ready", selector, listener);
	}
}