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
package domtools;
import domtools.Query;
using domtools.ElementManipulation;
import js.w3c.level3.Events;
import js.w3c.level3.Core;
class Events
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

	/** Trigger an event, as if it has actually happened 
	public static function trigger(target:Node, eventString:String):Node
	{
		if (target.isElement())
		{
			var elm:Element = cast target;

			var event;
			var useW3EventModel:Bool = untyped __js__('document.createEvent');
			if (useW3EventModel) 
			{
				event = untyped __js__("document.createEvent('HTMLEvents')");
				event.initEvent(eventString, true, true);
			} 
			else 
			{
				event = untyped __js__("document.createEventObject()");
				event.eventType = "on" + eventString;
			}

			event.eventName = eventString;
			event.memo = memo || { };

			if (useW3EventModel)
			{
				elm.dispatchEvent(event);
			}
			else
			{
				untyped __js__("elm.fireEvent(event.eventType, event)");
			}
		}

		return target;
	}*/

	/** Trigger the handler for the event, but don't emulate the event itself */
	public static function triggerHandler(target:Node, event:String):Node
	{
		return target;
	}

	/** add an event listener */
	public static function on(target:Node, eventType:String, listener:Event->Void):Node
	{
		var elm:Element = cast target;

		// eventType, listener, useCapture.  For info on useCapture, see http://blog.seankoole.com/addeventlistener-explaining-usecapture
		// will not work on IE8 or below.  Can't be bothered adding at the moment.
		elm.addEventListener(eventType, listener, false);

		return target;
	}

	public static function off(target:Node, eventType:String, listener:Event->Void):Node
	{
		var elm:Element = cast target;

		// eventType, listener, useCapture.  For info on useCapture, see http://blog.seankoole.com/addeventlistener-explaining-usecapture
		// will not work on IE8 or below.  Can't be bothered adding at the moment.
		// This code may also be an alternative: https://developer.mozilla.org/en/DOM/element.removeEventListener#section_4
		elm.removeEventListener(eventType, listener, false);
		
		return target;
	}

	/** Attach an event but only let it run once */
	public static function one(target:Node, eventType:String, listener:Event->Void):Node
	{
		var fn:Event->Void = null;
		fn = function (e:Event)
		{
			listener(e);
			target.removeEventListener(eventType, fn, false);
		}
		target.addEventListener(eventType, fn, false);
		return target;
	}

	public static inline function mousedown(target:Node, listener:Event->Void):Node
	{
		return on(target, "mousedown", listener);
	}

	public static inline function mouseenter(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseleave(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mousemove(target:Node, listener:Event->Void):Node
	{
		return on(target, "mousemove", listener);
	}

	public static inline function mouseout(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mouseover(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseup(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseup", listener);
	}

	public static inline function keydown(target:Node, listener:Event->Void):Node
	{
		return on(target, "keydown", listener);
	}

	public static inline function keypress(target:Node, listener:Event->Void):Node
	{
		return on(target, "keypress", listener);
	}

	public static inline function keyup(target:Node, listener:Event->Void):Node
	{
		return on(target, "keyup", listener);
	}

	public static function hover(target:Node, listener1:Event->Void, ?listener2:Event->Void = null):Node
	{
		mouseenter(target, listener1);

		if (listener2 == null)
		{
			// no 2nd listener, that means run the first again
			mouseleave(target, listener1);
		}
		else
		{
			// there is a second listener, so run that when the mouse leaves the hover-area
			mouseleave(target, listener2);
		}
		return target;
	}

	public static inline function submit(target:Node, listener:Event->Void):Node
	{
		return on(target, "submit", listener);
	}

	public static function toggleClick(target:Node, listenerFirstClick:Event->Void, listenerSecondClick:Event->Void):Node
	{
		// Wrap the first click function to run once, then remove itself and add the second click function
		var fn1:Event->Void = null;
		fn1 = function (e:Event)
		{
			listenerFirstClick(e);
			target.removeEventListener("click", fn1, false);
			target.addEventListener("click", fn2, false);
		}

		// Wrap the second click function to run once, then remove itself and add the first click function
		var fn2:Event->Void = null;
		fn2 = function (e:Event)
		{
			listenerSecondClick(e);
			target.removeEventListener("click", fn2, false);
			target.addEventListener("click", fn1, false);
		}

		// Add the first one to begin with
		target.addEventListener(eventType, fn1, false);

		return target;
	}

	public static inline function blur(target:Node, listener:Event->Void):Node
	{
		return on(target, "blur", listener);
	}

	public static inline function change(target:Node, listener:Event->Void):Node
	{
		return on(target, "change", listener);
	}

	public static inline function click(target:Node, listener:Event->Void):Node
	{
		return on(target, "click", listener);
	}

	public static inline function dblclick(target:Node, listener:Event->Void):Node
	{
		return on(target, "dblclick", listener);
	}

	public static inline function focus(target:Node, listener:Event->Void):Node
	{
		return on(target, "focus", listener);
	}

	public static inline function focusIn(target:Node, listener:Event->Void):Node
	{
		return on(target, "focusIn", listener);
	}

	public static inline function focusOut(target:Node, listener:Event->Void):Node
	{
		return on(target, "focusOut", listener);
	}

	public static inline function resize(target:Node, listener:Event->Void):Node
	{
		return on(target, "resize", listener);
	}

	public static inline function scroll(target:Node, listener:Event->Void):Node
	{
		return on(target, "scroll", listener);
	}

	public static inline function select(target:Node, listener:Event->Void):Node
	{
		return on(target, "select", listener);
	}

	public static inline function load(target:Node, listener:Event->Void):Node
	{
		return on(target, "load", listener);
	}

	public static inline function unload(target:Node, listener:Event->Void):Node
	{
		return on(target, "unload", listener);
	}

	public static inline function error(target:Node, listener:Event->Void):Node
	{
		return on(target, "error", listener);
	}

	public static inline function ready(target:Node, listener:Event->Void):Node
	{
		return on(target, "ready", listener);
	}

}

class QueryEvents
{
	public static function on(targetCollection:Query, eventType:String, listener:Event->Void):Query
	{
		for (target in targetCollection)
		{
			Events.on(target, eventType, listener);
		}
		return targetCollection;
	}

	public static function off(targetCollection:Query, eventType:String, listener:Event->Void):Query
	{
		for (target in targetCollection)
		{
			Events.off(target, eventType, listener);
		}
		return targetCollection;
	}

	public static function one(targetCollection:Query, eventType:String, listener:Event->Void):Query
	{
		for (target in targetCollection)
		{
			Events.one(target, eventType, listener);
		}
		return targetCollection;
	}

	public static inline function mousedown(target:Query, listener:Event->Void):Query
	{
		return on(target, "mousedown", listener);
	}

	public static inline function mouseenter(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseenter", listener);
	}

	public static inline function mouseleave(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseleave", listener);
	}

	public static inline function mousemove(target:Query, listener:Event->Void):Query
	{
		return on(target, "mousemove", listener);
	}

	public static inline function mouseout(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mouseover(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseup(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseup", listener);
	}

	public static inline function keydown(target:Query, listener:Event->Void):Query
	{
		return on(target, "keydown", listener);
	}

	public static inline function keypress(target:Query, listener:Event->Void):Query
	{
		return on(target, "keypress", listener);
	}

	public static inline function keyup(target:Query, listener:Event->Void):Query
	{
		return on(target, "keyup", listener);
	}

	public static function hover(targetCollection:Query, listener1:Event->Void, ?listener2:Event->Void = null):Query
	{
		for (node in targetCollection)
		{
			Events.hover(node, listener1, listener2);
		}
		return targetCollection;
	}

	public static inline function submit(target:Query, listener:Event->Void):Query
	{
		return on(target, "submit", listener);
	}

	public static function toggleClick(targetCollection:Query, listenerFirstClick:Event->Void, listenerSecondClick:Event->Void):Query
	{
		for (target in targetCollection)
		{
			Events.toggleClick(target, listenerFirstClick, listenerSecondClick);
		}
		return targetCollection;
	}

	public static inline function blur(target:Query, listener:Event->Void):Query
	{
		return on(target, "blur", listener);
	}

	public static inline function change(target:Query, listener:Event->Void):Query
	{
		return on(target, "change", listener);
	}

	public static inline function click(target:Query, listener:Event->Void):Query
	{
		return on(target, "click", listener);
	}

	public static inline function dblclick(target:Query, listener:Event->Void):Query
	{
		return on(target, "dblclick", listener);
	}

	public static inline function focus(target:Query, listener:Event->Void):Query
	{
		return on(target, "focus", listener);
	}

	public static inline function focusIn(target:Query, listener:Event->Void):Query
	{
		return on(target, "focusIn", listener);
	}

	public static inline function focusOut(target:Query, listener:Event->Void):Query
	{
		return on(target, "focusOut", listener);
	}

	public static inline function resize(target:Query, listener:Event->Void):Query
	{
		return on(target, "resize", listener);
	}

	public static inline function scroll(target:Query, listener:Event->Void):Query
	{
		return on(target, "scroll", listener);
	}

	public static inline function select(target:Query, listener:Event->Void):Query
	{
		return on(target, "select", listener);
	}

	public static inline function load(target:Query, listener:Event->Void):Query
	{
		return on(target, "load", listener);
	}

	public static inline function unload(target:Query, listener:Event->Void):Query
	{
		return on(target, "unload", listener);
	}

	public static inline function error(target:Query, listener:Event->Void):Query
	{
		return on(target, "error", listener);
	}

	public static inline function ready(target:Query, listener:Event->Void):Query
	{
		return on(target, "ready", listener);
	}
}