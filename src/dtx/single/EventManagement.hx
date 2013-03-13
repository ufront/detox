/****
* Copyright (c) 2012 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/

package dtx.single;

import dtx.DOMNode;
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
	import js.html.EventListener;
	typedef DtxEvent = js.html.Event;
#else 
	typedef EventListener = BnEvent->Void;
	typedef DtxEvent = BnEvent;
#end

class EventManagement
{
	/*private static var eventTypeMap = {
		'click':'MouseEvent',
		'dblclick':'MouseEvent',
		'mousedown':'MouseEvent',
		'mouseup':'MouseEvent',
		'mouseover':'MouseEvent',
		'mousemove':'MouseEvent',
		'mouseout':'MouseEvent',
		'keydown':'KeyboardEvent',
		'keypress':'KeyboardEvent',
		'keyup':'KeyboardEvent',
		'':'HTMLEvents',

	}

	/** Trigger an event, as if it has actually happened */
	public static inline function trigger(target:DOMNode, eventString:String):DOMNode
	{
		#if js 
		Bean.fire(target, eventString);
		#else 
		trace ("Detox events only work on the Javascript target, sorry.");
		#end
		return target;
	}

	// /** Trigger the handler for the event, but don't emulate the event itself */
	// public static function triggerHandler(target:DOMNode, event:String):DOMNode
	// {
	// 	return target;
	// }

	/** add an event listener */
	public static inline function on(target:DOMNode, eventType:String, ?selector:String, listener:EventListener):DOMNode
	{
		#if js 
			if (selector != null) Bean.on(target, eventType, selector, listener);
			else Bean.on(target, eventType, listener);
		#else 
			trace ("Detox events only work on the Javascript target, sorry.");
		#end
		return target;
	}

	public static function off(target:DOMNode, eventType:String, ?listener:EventListener=null):DOMNode
	{
		#if js 
		Bean.off(target, eventType, listener);
		#else 
		trace ("Detox events only work on the Javascript target, sorry.");
		#end
		return target;
	}

	/** Attach an event but only let it run once */
	public static function one(target:DOMNode, eventType:String, ?selector:String, listener:EventListener):DOMNode
	{
		#if js 
			if (selector != null) Bean.one(target, eventType, selector, listener);
			else Bean.one(target, eventType, listener);
		#else 
			trace ("Detox events only work on the Javascript target, sorry.");
		#end
		return target;
	}

	public static inline function mousedown(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "mousedown", selector, listener);
	}

	public static inline function mouseenter(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "mouseover", selector, listener);
	}

	public static inline function mouseleave(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "mouseout", selector, listener);
	}

	public static inline function mousemove(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "mousemove", selector, listener);
	}

	public static inline function mouseout(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "mouseout", selector, listener);
	}

	public static inline function mouseover(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "mouseover", selector, listener);
	}

	public static inline function mouseup(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "mouseup", selector, listener);
	}

	public static inline function keydown(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "keydown", selector, listener);
	}

	public static inline function keypress(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "keypress", selector, listener);
	}

	public static inline function keyup(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "keyup", selector, listener);
	}

	public static function hover(target:DOMNode, ?selector:String, listener1:EventListener, ?listener2:EventListener = null):DOMNode
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

	public static inline function submit(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "submit", selector, listener);
	}

	public static function toggleClick(target:DOMNode, ?selector:String, listenerFirstClick:EventListener, listenerSecondClick:EventListener):DOMNode
	{
		// Declare and initialise now so they can reference each other in their function bodies.
		var fn1:EventListener = null;
		var fn2:EventListener = null;

		// Wrap the first click function to run once, then remove itself and add the second click function
		fn1 = function (e:DtxEvent)
		{
			listenerFirstClick(e);
			off(target, "click", fn1);
			on(target, "click", selector, fn2);
		}

		// Wrap the second click function to run once, then remove itself and add the first click function
		fn2 = function (e:DtxEvent)
		{
			listenerSecondClick(e);
			off(target, "click", fn2);
			on(target, "click", selector, fn1);
		}

		// Add the first one to begin with
		on(target, "click", selector, fn1);

		return target;
	}

	public static inline function blur(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "blur", selector, listener);
	}

	public static inline function change(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "change", selector, listener);
	}

	public static inline function click(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "click", selector, listener);
	}

	public static inline function dblclick(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "dblclick", selector, listener);
	}

	public static inline function focus(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "focus", selector, listener);
	}

	public static inline function focusIn(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "focusIn", selector, listener);
	}

	public static inline function focusOut(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "focusOut", selector, listener);
	}

	public static inline function resize(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "resize", selector, listener);
	}

	public static inline function scroll(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "scroll", selector, listener);
	}

	public static inline function select(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "select", selector, listener);
	}

	public static inline function load(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "load", selector, listener);
	}

	public static inline function unload(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "unload", selector, listener);
	}

	public static inline function error(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "error", selector, listener);
	}

	public static inline function ready(target:DOMNode, ?selector:String, listener:EventListener):DOMNode
	{
		return on(target, "ready", selector, listener);
	}

}