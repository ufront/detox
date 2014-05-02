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

import dtx.DOMNode;
import Bean;

#if (haxe_211 || haxe3)
	import js.html.*;
	typedef DtxEvent = js.html.Event;
#else 
	typedef EventListener = BnEvent->Void;
	typedef DtxEvent = BnEvent;
#end

class EventManagement
{
	public static function trigger<T:DOMCollection>(targetCollection:T, eventType:String):T
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.trigger(target, eventType);
		}
		return targetCollection;
	}

	public static function on<T:DOMCollection>(targetCollection:T, eventType:String, ?selector:String, ?listener:EventListener):T
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.on(target, eventType, selector, listener);
		}
		return targetCollection;
	}

	public static function off<T:DOMCollection>(targetCollection:T, ?eventType:String, ?listener:EventListener):T
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.off(target, eventType, listener);
		}
		return targetCollection;
	}

	public static function one<T:DOMCollection>(targetCollection:T, eventType:String, ?selector:String, listener:EventListener):T
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.one(target, eventType, selector, listener);
		}
		return targetCollection;
	}

	public static inline function mousedown<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mousedown", selector, untyped listener);
	}

	public static inline function mouseenter<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseenter", selector, untyped listener);
	}

	public static inline function mouseleave<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseleave", selector, untyped listener);
	}

	public static inline function mousemove<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mousemove", selector, untyped listener);
	}

	public static inline function mouseout<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseout", selector, untyped listener);
	}

	public static inline function mouseover<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseover", selector, untyped listener);
	}

	public static inline function mouseup<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseup", selector, untyped listener);
	}

	public static inline function keydown<T:DOMCollection>(target:T, ?selector:String, ?listener:KeyboardEvent->Void):T
	{
		return on(target, "keydown", selector, untyped listener);
	}

	public static inline function keypress<T:DOMCollection>(target:T, ?selector:String, ?listener:KeyboardEvent->Void):T
	{
		return on(target, "keypress", selector, untyped listener);
	}

	public static inline function keyup<T:DOMCollection>(target:T, ?selector:String, ?listener:KeyboardEvent->Void):T
	{
		return on(target, "keyup", selector, untyped listener);
	}

	public static function hover<T:DOMCollection>(targetCollection:T, ?selector: String, listener1:MouseEvent->Void, ?listener2:MouseEvent->Void):T
	{
		for (node in targetCollection)
		{
			dtx.single.EventManagement.hover(node, selector, listener1, listener2);
		}
		return targetCollection;
	}

	public static inline function submit<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "submit", selector, listener);
	}

	public static function toggleClick<T:DOMCollection>(targetCollection:T, ?selector: String, listenerFirstClick:MouseEvent->Void, listenerSecondClick:MouseEvent->Void):T
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.toggleClick(target, selector, listenerFirstClick, listenerSecondClick);
		}
		return targetCollection;
	}

	public static inline function blur<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "blur", selector, listener);
	}

	public static inline function change<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "change", selector, listener);
	}

	public static inline function click<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "click", selector, listener);
	}

	public static inline function dblclick<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "dblclick", selector, listener);
	}

	public static inline function focus<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "focus", selector, listener);
	}

	public static inline function focusIn<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "focusIn", selector, listener);
	}

	public static inline function focusOut<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "focusOut", selector, listener);
	}

	public static inline function resize<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "resize", selector, listener);
	}

	public static inline function scroll<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "scroll", selector, listener);
	}

	public static function wheel<T:DOMCollection>(target:T, ?selector:String, ?listener:WheelEvent->Void):T
	{
		for (n in target)
		{
			dtx.single.EventManagement.wheel(n, selector, listener);
		}
		return target;
	}

	public static inline function select<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "select", selector, listener);
	}

	public static inline function load<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "load", selector, listener);
	}

	public static inline function unload<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "unload", selector, listener);
	}

	public static inline function error<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "error", selector, listener);
	}

	public static inline function ready<T:DOMCollection>(target:T, ?selector:String, ?listener:EventListener):T
	{
		return on(target, "ready", selector, listener);
	}
}
