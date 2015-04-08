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

/**
	This class provides static helper methods to listen to or trigger events for all nodes in a `dtx.DOMCollection`.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then operate on DOMCollections as if they were methods on the DOMCollection object itself.
	Each method is chainable, and returns the original collection with the original type information.
	Each method is null-safe, if a collection is empty or null it will have no effect.
**/
class EventManagement
{
	/** Run `dtx.single.EventManagement.trigger` for each node in the target collection. **/
	public static function trigger<T:DOMCollection>(targetCollection:T, eventType:String):T
	{
		if (targetCollection!=null) for (target in targetCollection)
		{
			dtx.single.EventManagement.trigger(target, eventType);
		}
		return targetCollection;
	}

	/** Run `dtx.single.EventManagement.on` for each node in the target collection. **/
	public static function on<T:DOMCollection>(targetCollection:T, eventType:String, ?selector:String, ?listener:Event->Void):T
	{
		if (targetCollection!=null) for (target in targetCollection)
		{
			dtx.single.EventManagement.on(target, eventType, selector, listener);
		}
		return targetCollection;
	}

	/** Run `dtx.single.EventManagement.off` for each node in the target collection. **/
	public static function off<T:DOMCollection>(targetCollection:T, ?eventType:String, ?listener:Event->Void):T
	{
		if (targetCollection!=null) for (target in targetCollection)
		{
			dtx.single.EventManagement.off(target, eventType, listener);
		}
		return targetCollection;
	}

	/** Run `dtx.single.EventManagement.one` for each node in the target collection. **/
	public static function one<T:DOMCollection>(targetCollection:T, eventType:String, ?selector:String, listener:Event->Void):T
	{
		if (targetCollection!=null) for (target in targetCollection)
		{
			dtx.single.EventManagement.one(target, eventType, selector, listener);
		}
		return targetCollection;
	}

	/** A shortcut for `on(target, "mousedown", selector, listener)`. **/
	public static inline function mousedown<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mousedown", selector, untyped listener);
	}

	/** A shortcut for `on(target, "mouseenter", selector, listener)`. **/
	public static inline function mouseenter<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseenter", selector, untyped listener);
	}

	/** A shortcut for `on(target, "mouseleave", selector, listener)`. **/
	public static inline function mouseleave<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseleave", selector, untyped listener);
	}

	/** A shortcut for `on(target, "mousemove", selector, listener)`. **/
	public static inline function mousemove<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mousemove", selector, untyped listener);
	}

	/** A shortcut for `on(target, "mouseout", selector, listener)`. **/
	public static inline function mouseout<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseout", selector, untyped listener);
	}

	/** A shortcut for `on(target, "mouseover", selector, listener)`. **/
	public static inline function mouseover<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseover", selector, untyped listener);
	}

	/** A shortcut for `on(target, "mouseup", selector, listener)`. **/
	public static inline function mouseup<T:DOMCollection>(target:T, ?selector:String, ?listener:MouseEvent->Void):T
	{
		return on(target, "mouseup", selector, untyped listener);
	}

	/** A shortcut for `on(target, "keydown", selector, listener)`. **/
	public static inline function keydown<T:DOMCollection>(target:T, ?selector:String, ?listener:KeyboardEvent->Void):T
	{
		return on(target, "keydown", selector, untyped listener);
	}

	/** A shortcut for `on(target, "keypress", selector, listener)`. **/
	public static inline function keypress<T:DOMCollection>(target:T, ?selector:String, ?listener:KeyboardEvent->Void):T
	{
		return on(target, "keypress", selector, untyped listener);
	}

	/** A shortcut for `on(target, "keyup", selector, listener)`. **/
	public static inline function keyup<T:DOMCollection>(target:T, ?selector:String, ?listener:KeyboardEvent->Void):T
	{
		return on(target, "keyup", selector, untyped listener);
	}

	/** Run `dtx.single.EventManagement.hover` for each node in the target collection. **/
	public static function hover<T:DOMCollection>(targetCollection:T, ?selector: String, listener1:MouseEvent->Void, ?listener2:MouseEvent->Void):T
	{
		if (targetCollection!=null) for (node in targetCollection)
		{
			dtx.single.EventManagement.hover(node, selector, listener1, listener2);
		}
		return targetCollection;
	}

	/** A shortcut for `on(target, "submit", selector, listener)`. **/
	public static inline function submit<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "submit", selector, listener);
	}

	/** Run `dtx.single.EventManagement.toggleClick` for each node in the target collection. **/
	public static function toggleClick<T:DOMCollection>(targetCollection:T, ?selector: String, listenerFirstClick:MouseEvent->Void, listenerSecondClick:MouseEvent->Void):T
	{
		if (targetCollection!=null) for (target in targetCollection)
		{
			dtx.single.EventManagement.toggleClick(target, selector, listenerFirstClick, listenerSecondClick);
		}
		return targetCollection;
	}

	/** A shortcut for `on(target, "blur", selector, listener)`. **/
	public static inline function blur<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "blur", selector, listener);
	}

	/** A shortcut for `on(target, "change", selector, listener)`. **/
	public static inline function change<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "change", selector, listener);
	}

	/** A shortcut for `on(target, "click", selector, listener)`. **/
	public static inline function click<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "click", selector, listener);
	}

	/** A shortcut for `on(target, "dblclick", selector, listener)`. **/
	public static inline function dblclick<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "dblclick", selector, listener);
	}

	/** A shortcut for `on(target, "focus", selector, listener)`. **/
	public static inline function focus<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "focus", selector, listener);
	}

	/** A shortcut for `on(target, "focusIn", selector, listener)`. **/
	public static inline function focusIn<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "focusIn", selector, listener);
	}

	/** A shortcut for `on(target, "focusOut", selector, listener)`. **/
	public static inline function focusOut<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "focusOut", selector, listener);
	}

	/** A shortcut for `on(target, "resize", selector, listener)`. **/
	public static inline function resize<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "resize", selector, listener);
	}

	/** A shortcut for `on(target, "scroll", selector, listener)`. **/
	public static inline function scroll<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "scroll", selector, listener);
	}

	/** Run `dtx.single.EventManagement.wheel` for each node in the target collection. **/
	public static function wheel<T:DOMCollection>(target:T, ?selector:String, ?listener:WheelEvent->Void):T
	{
		if (target!=null) for (n in target)
		{
			dtx.single.EventManagement.wheel(n, selector, listener);
		}
		return target;
	}

	/** A shortcut for `on(target, "select", selector, listener)`. **/
	public static inline function select<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "select", selector, listener);
	}

	/** A shortcut for `on(target, "load", selector, listener)`. **/
	public static inline function load<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "load", selector, listener);
	}

	/** A shortcut for `on(target, "unload", selector, listener)`. **/
	public static inline function unload<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "unload", selector, listener);
	}

	/** A shortcut for `on(target, "error", selector, listener)`. **/
	public static inline function error<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "error", selector, listener);
	}

	/** A shortcut for `on(target, "ready", selector, listener)`. **/
	public static inline function ready<T:DOMCollection>(target:T, ?selector:String, ?listener:Event->Void):T
	{
		return on(target, "ready", selector, listener);
	}
}
