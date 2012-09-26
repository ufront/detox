/****
* Copyright (c) 2012 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO BnEVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/

package dtx.collection;

#if js
import dtx.DOMNode;
import Bean;

class EventManagement
{
	public static function on(targetCollection:DOMCollection, BneventType:String, listener:BnEvent->Void):DOMCollection
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.on(target, BneventType, listener);
		}
		return targetCollection;
	}

	public static function off(targetCollection:DOMCollection, BneventType:String, listener:BnEvent->Void):DOMCollection
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.off(target, BneventType, listener);
		}
		return targetCollection;
	}

	public static function one(targetCollection:DOMCollection, BneventType:String, listener:BnEvent->Void):DOMCollection
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.one(target, BneventType, listener);
		}
		return targetCollection;
	}

	public static inline function mousedown(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "mousedown", listener);
	}

	public static inline function mouseenter(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "mouseenter", listener);
	}

	public static inline function mouseleave(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "mouseleave", listener);
	}

	public static inline function mousemove(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "mousemove", listener);
	}

	public static inline function mouseout(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mouseover(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseup(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "mouseup", listener);
	}

	public static inline function keydown(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "keydown", listener);
	}

	public static inline function keypress(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "keypress", listener);
	}

	public static inline function keyup(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "keyup", listener);
	}

	public static function hover(targetCollection:DOMCollection, listener1:BnEvent->Void, ?listener2:BnEvent->Void = null):DOMCollection
	{
		for (node in targetCollection)
		{
			dtx.single.EventManagement.hover(node, listener1, listener2);
		}
		return targetCollection;
	}

	public static inline function submit(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "submit", listener);
	}

	public static function toggleClick(targetCollection:DOMCollection, listenerFirstClick:BnEvent->Void, listenerSecondClick:BnEvent->Void):DOMCollection
	{
		for (target in targetCollection)
		{
			dtx.single.EventManagement.toggleClick(target, listenerFirstClick, listenerSecondClick);
		}
		return targetCollection;
	}

	public static inline function blur(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "blur", listener);
	}

	public static inline function change(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "change", listener);
	}

	public static inline function click(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "click", listener);
	}

	public static inline function dblclick(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "dblclick", listener);
	}

	public static inline function focus(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "focus", listener);
	}

	public static inline function focusIn(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "focusIn", listener);
	}

	public static inline function focusOut(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "focusOut", listener);
	}

	public static inline function resize(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "resize", listener);
	}

	public static inline function scroll(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "scroll", listener);
	}

	public static inline function select(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "select", listener);
	}

	public static inline function load(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "load", listener);
	}

	public static inline function unload(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "unload", listener);
	}

	public static inline function error(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "error", listener);
	}

	public static inline function ready(target:DOMCollection, listener:BnEvent->Void):DOMCollection
	{
		return on(target, "ready", listener);
	}
}
#end