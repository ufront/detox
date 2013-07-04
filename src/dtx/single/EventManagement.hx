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

package dtx.single;


/*
JQuery has these methods.  I'll try break them down into core functionality and implementations of specific events
For now I'm only testing in Firefox / W3 conforming browsers.  Almost certainly broken in IE8 and below.

Core functionality
==================
trigger()
triggerHandler()
WORKING on() - addEventListener, basically
WORKING off() - removeEventListener, basically
WORKING one() - like on(), but runs once and removes itself


Specific Events
===============
mousedown
mouseenter
mouseleave
mousemove
mouseout
mouseover
mouseup
keydown
keypress
keyup
hover() - 
submit()
toggleClick(callBackFirstClick, callBackSecondClick)
blur() - 
change() - 
click() - 
dblclick() - 
focus()
focusIn()
focusOut()
resize - event
scroll - event
select - event
load()
unload (events)
error() - 
ready()


noBubble // not sure what this is... haxe specific by the looks of it


bind() - addEventListener() basically - Replaced by on()
unbind (events) - replaced by off
live // deprecated
die(?eventType) - remove all event handlers // deprecated
*/ 

#if (haxe_211 || haxe3)
	import js.html.*;
	typedef DtxEvent = js.html.Event;
#else 
	typedef EventListener = BnEvent->Void;
	typedef DtxEvent = BnEvent;
#end

class EventManagement
{
	/** Trigger an event, as if it has actually happened */
	public static inline function trigger(target:Node, eventString:String):Node
	{
		#if js 
		if (target!=null) Bean.fire(target, eventString);
		#else 
		trace ("Detox events only work on the Javascript target, sorry.");
		#end
		return target;
	}

	// /** Trigger the handler for the event, but don't emulate the event itself */
	// public static function triggerHandler(target:Node, event:String):Node
	// {
	// 	return target;
	// }

	/** add an event listener */
	public static inline function on(target:Node, eventType:String, ?selector:String, ?listener:EventListener):Node
	{
		#if js 
			if (target != null)
			{
				if (listener != null)
				{
					if (selector!=null) Bean.on(target, eventType, selector, listener);
					else Bean.on(target, eventType, listener);
				}
				else trigger (target, eventType);
			}
		#else 
			trace ("Detox events only work on the Javascript target, sorry.");
		#end
		return target;
	}

	public static function off(target:Node, ?eventType:String = null, ?listener:EventListener=null):Node
	{
		#if js 
			if (target != null)
			{
				if (eventType != null && listener != null) Bean.off(target, eventType, listener);
				else if (eventType != null) Bean.off(target, eventType);
				else if (listener != null) Bean.off(target, listener);
				else Bean.off(target);
			}
		#else 
			trace ("Detox events only work on the Javascript target, sorry.");
		#end
		return target;
	}

	/** Attach an event but only let it run once */
	public static function one(target:Node, eventType:String, ?selector:String, listener:EventListener):Node
	{
		#if js 
			if (target != null)
			{
				if (selector != null) Bean.one(target, eventType, selector, listener);
				else Bean.one(target, eventType, listener);
			}
		#else 
			trace ("Detox events only work on the Javascript target, sorry.");
		#end
		return target;
	}

	public static inline function mousedown(target:Node, ?selector:String, ?listener:MouseEvent->Void):Node
	{
		return on(target, "mousedown", selector, untyped listener);
	}

	public static inline function mouseenter(target:Node, ?selector:String, ?listener:MouseEvent->Void):Node
	{
		return on(target, "mouseover", selector, untyped listener);
	}

	public static inline function mouseleave(target:Node, ?selector:String, ?listener:MouseEvent->Void):Node
	{
		return on(target, "mouseout", selector, untyped listener);
	}

	public static inline function mousemove(target:Node, ?selector:String, ?listener:MouseEvent->Void):Node
	{
		return on(target, "mousemove", selector, untyped listener);
	}

	public static inline function mouseout(target:Node, ?selector:String, ?listener:MouseEvent->Void):Node
	{
		return on(target, "mouseout", selector, untyped listener);
	}

	public static inline function mouseover(target:Node, ?selector:String, ?listener:MouseEvent->Void):Node
	{
		return on(target, "mouseover", selector, untyped listener);
	}

	public static inline function mouseup(target:Node, ?selector:String, ?listener:MouseEvent->Void):Node
	{
		return on(target, "mouseup", selector, untyped listener);
	}

	public static inline function keydown(target:Node, ?selector:String, ?listener:KeyboardEvent->Void):Node
	{
		return on(target, "keydown", selector, untyped listener);
	}

	public static inline function keypress(target:Node, ?selector:String, ?listener:KeyboardEvent->Void):Node
	{
		return on(target, "keypress", selector, untyped listener);
	}

	public static inline function keyup(target:Node, ?selector:String, ?listener:KeyboardEvent->Void):Node
	{
		return on(target, "keyup", selector, untyped listener);
	}

	public static function hover(target:Node, ?selector:String, listener1:MouseEvent->Void, ?listener2:MouseEvent->Void = null):Node
	{
		mouseenter(target, selector, listener1);

		if (listener2 == null)
		{
			// no 2nd listener, that means run the first again
			mouseleave(target, selector, listener1);
		}
		else
		{
			// there is a second listener, so run that when the mouse leaves the hover-area
			mouseleave(target, selector, listener2);
		}
		return target;
	}

	public static inline function submit(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "submit", selector, listener);
	}

	public static function toggleClick(target:Node, ?selector:String, listenerFirstClick:MouseEvent->Void, listenerSecondClick:MouseEvent->Void):Node
	{
		// Declare and initialise now so they can reference each other in their function bodies.
		var fn1:MouseEvent->Void = null;
		var fn2:MouseEvent->Void = null;

		// Wrap the first click function to run once, then remove itself and add the second click function
		fn1 = function (e:MouseEvent)
		{
			listenerFirstClick(e);
			off(target, "click", untyped fn1);
			on(target, "click", selector, untyped fn2);
		}

		// Wrap the second click function to run once, then remove itself and add the first click function
		fn2 = function (e:MouseEvent)
		{
			listenerSecondClick(e);
			off(target, "click", untyped fn2);
			on(target, "click", selector, untyped fn1);
		}

		// Add the first one to begin with
		on(target, "click", selector, untyped fn1);

		return target;
	}

	public static inline function blur(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "blur", selector, listener);
	}

	public static inline function change(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "change", selector, listener);
	}

	public static inline function click(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "click", selector, listener);
	}

	public static inline function dblclick(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "dblclick", selector, listener);
	}

	public static inline function focus(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "focus", selector, listener);
	}

	public static inline function focusIn(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "focusIn", selector, listener);
	}

	public static inline function focusOut(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "focusOut", selector, listener);
	}

	public static inline function resize(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "resize", selector, listener);
	}

	public static inline function scroll(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "scroll", selector, listener);
	}

	public static function wheel(target:Node, ?selector:String, ?listener:js.html.WheelEvent->Void):Node
	{
		// Just use the HTML5 standard for now.  Works in IE9+ and FF17+, probably not webkit/opera yet.
		target.addEventListener("wheel", untyped listener);
		return target;
		
		// Later, we can try implement this, which has good fallbacks
		// https://developer.mozilla.org/en-US/docs/Mozilla_event_reference/wheel?redirectlocale=en-US&redirectslug=DOM%2FDOM_event_reference%2Fwheel
	}

	public static inline function select(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "select", selector, listener);
	}

	public static inline function load(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "load", selector, listener);
	}

	public static inline function unload(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "unload", selector, listener);
	}

	public static inline function error(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "error", selector, listener);
	}

	public static inline function ready(target:Node, ?selector:String, ?listener:EventListener):Node
	{
		return on(target, "ready", selector, listener);
	}

}