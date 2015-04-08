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

import dtx.DOMNode;
import js.html.*;

/**
	This class provides static helper methods to listen to or trigger events for a DOMNode.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then operate on a DOMNode as if they were methods of the DOMNode object itself.
	Each method is chainable, and returns the original DOMNode.
	Each method is null-safe, if a node is null or of the wrong type it will have no effect.
**/
class EventManagement
{
	/**
		Trigger an event as if it occured on this node.

		Custom event names can be used.
		Several functions in the `EventManagement` class can provide a shortcut to a common event trigger, for example calling `myNode.click()` is the same as calling `EventManagement.trigger(myNode,"click")`.
		The implementation uses `Bean.fire` to provide a consistent cross-browser implementation.
		On targets other than Javascript this method has no effect.

		@param target The node to use as the event target.  If `target` is null no event will be triggered.
		@param eventName The name of the event to trigger.  If `eventName` is null no event will be triggered.
		@return The target node.
	**/
	public static inline function trigger(target:DOMNode, eventName:String):DOMNode
	{
		#if js
			if (target!=null && eventName!=null) Bean.fire(target, eventName);
		#end
		return target;
	}

	/**
		Add an event listener to a node.

		The listener can optionally apply only to certian child nodes matching a selector.
		If no selector is specified, the listener will be triggered for the given event type on this node and any child nodes.

		Please note that if `listener` is null, this will currently have the effect of calling `trigger(target,eventType)`, but this is an implementation detail and may change in future - you should not rely on this behaviour.

		Currently this is implemented with BeanJS, the code is either:

		- `Bean.on(target,eventType,selector,listener);` if a selector is defined, or
		- `Bean.on(target,eventType,listener);` if a selector is not defined.

		In future we may change to using standard DOM methods rather than Bean, and drop support for old Internet Explorer browsers.

		This method has no effect on targets other than Javascript.

		@param target The DOMNode to add the listener to.  If null, this method will have no effect.
		@param eventType The name of the event to listen to, for example, "click".  If null, this method will have no effect.
		@param selector An optional selector - the listener will only be triggered if the event was on a child node which matches the selector.
                        For example `on(document,"click","a",listener)` will trigger for all clicks on `<a>` elements inside the document.
		@param listener The event listener function.  It should take a single parameter containing the current event.
		@return The original DOMNode.
	**/
	public static function on(target:DOMNode, eventType:String, ?selector:String, ?listener:Event->Void):DOMNode
	{
		#if js
			if (target != null && eventType != null)
			{
				if (listener != null)
				{
					if (selector!=null) Bean.on(target, eventType, selector, listener);
					else Bean.on(target, eventType, listener);
				}
				else trigger (target, eventType);
			}
		#end
		return target;
	}

	/**
		Remove an event listener from a node.

		- If only `listener` is specified, that specific listener will be removed on all event types.
		- If only `eventType` is specified, all listeners for that event type will be removed.
		- If both `listener` and `eventType` are specified, only that exact listener on that event type will be removed.
		- If neither `listener` or `eventType` are specified, then all event listeners on that node will be removed.

		Currently this is implemented with BeanJS, using `Bean.off()` with the given arguments.
		In future we may change to using standard DOM methods rather than Bean, and drop support for old Internet Explorer browsers.

		This method has no effect on targets other than Javascript.

		@param target The DOMNode to add the listener to.  If null, this method will have no effect.
		@param eventType The name of the event to listen to, for example, "click".  If null, this method will have no effect.
		@param listener The event listener function.  It should take a single parameter containing the current event.
		@return The original DOMNode.
	**/
	public static function off(target:DOMNode, ?eventType:String, ?listener:Event->Void):DOMNode
	{
		#if js
			if (target != null)
			{
				if (eventType != null && listener != null) Bean.off(target, eventType, listener);
				else if (eventType != null) Bean.off(target, eventType);
				else if (listener != null) Bean.off(target, listener);
				else Bean.off(target);
			}
		#end
		return target;
	}

	/**
		Add an event listener to a node, but remove it after the first time it has been triggered.

		The event listener will only be called once.

		The listener can optionally apply only to certian child nodes matching a selector.
		If no selector is specified, the listener will be triggered for the given event type on this node and any child nodes.

		Currently this is implemented with BeanJS, the code is either:

		- `Bean.one(target,eventType,selector,listener);` if a selector is defined, or
		- `Bean.one(target,eventType,listener);` if a selector is not defined.

		In future we may change to using standard DOM methods rather than Bean, and drop support for old Internet Explorer browsers.

		This method has no effect on targets other than Javascript.

		@param target The DOMNode to add the listener to.  If null, this method will have no effect.
		@param eventType The name of the event to listen to, for example, "click".  If null, this method will have no effect.
		@param selector An optional selector - the listener will only be triggered if the event was on a child node which matches the selector.
                        For example `on(document,"click","a",listener)` will trigger for all clicks on `<a>` elements inside the document.
		@param listener The event listener function.  It should take a single parameter containing the current event.
		@return The original DOMNode.
	**/
	public static function one(target:DOMNode, eventType:String, ?selector:String, listener:Event->Void):DOMNode
	{
		#if js
			if (target != null)
			{
				if (selector != null) Bean.one(target, eventType, selector, listener);
				else Bean.one(target, eventType, listener);
			}
		#end
		return target;
	}

	/** A typed shortcut for `on(target,"mousedown",selector,listener)`. **/
	public static inline function mousedown(target:DOMNode, ?selector:String, ?listener:MouseEvent->Void):DOMNode
	{
		return on(target, "mousedown", selector, untyped listener);
	}

	/** A typed shortcut for `on(target,"mouseover",selector,listener)`. **/
	public static inline function mouseenter(target:DOMNode, ?selector:String, ?listener:MouseEvent->Void):DOMNode
	{
		return on(target, "mouseover", selector, untyped listener);
	}

	/** A typed shortcut for `on(target,"mouseout",selector,listener)`. **/
	public static inline function mouseleave(target:DOMNode, ?selector:String, ?listener:MouseEvent->Void):DOMNode
	{
		return on(target, "mouseout", selector, untyped listener);
	}

	/** A typed shortcut for `on(target,"mousemove",selector,listener)`. **/
	public static inline function mousemove(target:DOMNode, ?selector:String, ?listener:MouseEvent->Void):DOMNode
	{
		return on(target, "mousemove", selector, untyped listener);
	}

	/** A typed shortcut for `on(target,"mouseout",selector,listener)`. **/
	public static inline function mouseout(target:DOMNode, ?selector:String, ?listener:MouseEvent->Void):DOMNode
	{
		return on(target, "mouseout", selector, untyped listener);
	}

	/** A typed shortcut for `on(target,"mouseover",selector,listener)`. **/
	public static inline function mouseover(target:DOMNode, ?selector:String, ?listener:MouseEvent->Void):DOMNode
	{
		return on(target, "mouseover", selector, untyped listener);
	}

	/** A typed shortcut for `on(target,"mouseup",selector,listener)`. **/
	public static inline function mouseup(target:DOMNode, ?selector:String, ?listener:MouseEvent->Void):DOMNode
	{
		return on(target, "mouseup", selector, untyped listener);
	}

	/** A typed shortcut for `on(target,"keydown",selector,listener)`. **/
	public static inline function keydown(target:DOMNode, ?selector:String, ?listener:KeyboardEvent->Void):DOMNode
	{
		return on(target, "keydown", selector, untyped listener);
	}

	/** A typed shortcut for `on(target,"keypress",selector,listener)`. **/
	public static inline function keypress(target:DOMNode, ?selector:String, ?listener:KeyboardEvent->Void):DOMNode
	{
		return on(target, "keypress", selector, untyped listener);
	}

	/** A typed shortcut for `on(target,"keyup",selector,listener)`. **/
	public static inline function keyup(target:DOMNode, ?selector:String, ?listener:KeyboardEvent->Void):DOMNode
	{
		return on(target, "keyup", selector, untyped listener);
	}

	/**
		Trigger a listener for when a mouse hovers over an element, and again for when it leaves an element.

		@param target The DOMNode to listen to.
		@param selector An optional selector to listen to.
		@listener1 A listener for the "mouseenter" event.  If `listener2` is not specified it will also be used for the "mouseleave" event.
		@listener2 A listener for the "mouseleave" event.  If not specified, then `listener1` will trigger on "mouseleave" also.
		@return The original DOMNode.
	**/
	public static function hover(target:DOMNode, ?selector:String, listener1:MouseEvent->Void, ?listener2:MouseEvent->Void):DOMNode
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

	/** A shortcut for `on(target,"submit",selector,listener)`. **/
	public static inline function submit(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "submit", selector, listener);
	}

	/**
		Trigger a listener for alternating clicks on an element.

		The first click will trigger `listenerFirstClick`, the second will trigger `listenerSecondClick`, the third `listenerFirstClick` and so on.

		@param target The DOMNode to listen to.
		@param selector An optional selector to listen to.
		@listenerFirstClick A listener for the first "click" event.
		@listenerSecondClick A listener for the second "click" event.
		@return The original DOMNode.
	**/
	public static function toggleClick(target:DOMNode, ?selector:String, listenerFirstClick:MouseEvent->Void, listenerSecondClick:MouseEvent->Void):DOMNode
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

	/** A shortcut for `on(target,"blur",selector,listener)`. **/
	public static inline function blur(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "blur", selector, listener);
	}

	/** A shortcut for `on(target,"change",selector,listener)`. **/
	public static inline function change(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "change", selector, listener);
	}

	/** A shortcut for `on(target,"click",selector,listener)`. **/
	public static inline function click(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "click", selector, listener);
	}

	/** A shortcut for `on(target,"dblclick",selector,listener)`. **/
	public static inline function dblclick(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "dblclick", selector, listener);
	}

	/** A shortcut for `on(target,"focus",selector,listener)`. **/
	public static inline function focus(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "focus", selector, listener);
	}

	/** A shortcut for `on(target,"focusIn",selector,listener)`. **/
	public static inline function focusIn(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "focusIn", selector, listener);
	}

	/** A shortcut for `on(target,"focusOut",selector,listener)`. **/
	public static inline function focusOut(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "focusOut", selector, listener);
	}

	/** A shortcut for `on(target,"resize",selector,listener)`. **/
	public static inline function resize(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "resize", selector, listener);
	}

	/** A shortcut for `on(target,"scroll",selector,listener)`. **/
	public static inline function scroll(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "scroll", selector, listener);
	}

	/**
		Add a listener to the wheel event.

		Please note this implementation is incomplete - selector will have no effect, and it is not guaranteed to work cross browser.

		Pull requests are welcome.
	**/
	public static function wheel(target:DOMNode, ?selector:String, ?listener:js.html.WheelEvent->Void):DOMNode
	{
		// Just use the HTML5 standard for now.  Works in IE9+ and FF17+, probably not webkit/opera yet.
		target.addEventListener("wheel", untyped listener);
		return target;

		// Later, we can try implement this, which has good fallbacks
		// https://developer.mozilla.org/en-US/docs/Mozilla_event_reference/wheel?redirectlocale=en-US&redirectslug=DOM%2FDOM_event_reference%2Fwheel
	}

	/** A shortcut for `on(target,"select",selector,listener)`. **/
	public static inline function select(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "select", selector, listener);
	}

	/** A shortcut for `on(target,"load",selector,listener)`. **/
	public static inline function load(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "load", selector, listener);
	}

	/** A shortcut for `on(target,"unload",selector,listener)`. **/
	public static inline function unload(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "unload", selector, listener);
	}

	/** A shortcut for `on(target,"error",selector,listener)`. **/
	public static inline function error(target:DOMNode, ?selector:String, ?listener:Event->Void):DOMNode
	{
		return on(target, "error", selector, listener);
	}
}
