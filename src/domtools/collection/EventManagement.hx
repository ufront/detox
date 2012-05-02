/****
* Copyright 2012 Jason O'Neil. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE "AS IS" AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Jason O'Neil.
* 
****/

package domtools.collection;

#if js
import domtools.DOMNode;
import js.w3c.level3.Events;

class EventManagement
{
	public static function on(targetCollection:DOMCollection, eventType:String, listener:Event->Void):DOMCollection
	{
		for (target in targetCollection)
		{
			domtools.single.EventManagement.on(target, eventType, listener);
		}
		return targetCollection;
	}

	public static function off(targetCollection:DOMCollection, eventType:String, listener:Event->Void):DOMCollection
	{
		for (target in targetCollection)
		{
			domtools.single.EventManagement.off(target, eventType, listener);
		}
		return targetCollection;
	}

	public static function one(targetCollection:DOMCollection, eventType:String, listener:Event->Void):DOMCollection
	{
		for (target in targetCollection)
		{
			domtools.single.EventManagement.one(target, eventType, listener);
		}
		return targetCollection;
	}

	public static inline function mousedown(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "mousedown", listener);
	}

	public static inline function mouseenter(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "mouseenter", listener);
	}

	public static inline function mouseleave(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "mouseleave", listener);
	}

	public static inline function mousemove(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "mousemove", listener);
	}

	public static inline function mouseout(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mouseover(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseup(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "mouseup", listener);
	}

	public static inline function keydown(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "keydown", listener);
	}

	public static inline function keypress(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "keypress", listener);
	}

	public static inline function keyup(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "keyup", listener);
	}

	public static function hover(targetCollection:DOMCollection, listener1:Event->Void, ?listener2:Event->Void = null):DOMCollection
	{
		for (node in targetCollection)
		{
			domtools.single.EventManagement.hover(node, listener1, listener2);
		}
		return targetCollection;
	}

	public static inline function submit(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "submit", listener);
	}

	public static function toggleClick(targetCollection:DOMCollection, listenerFirstClick:Event->Void, listenerSecondClick:Event->Void):DOMCollection
	{
		for (target in targetCollection)
		{
			domtools.single.EventManagement.toggleClick(target, listenerFirstClick, listenerSecondClick);
		}
		return targetCollection;
	}

	public static inline function blur(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "blur", listener);
	}

	public static inline function change(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "change", listener);
	}

	public static inline function click(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "click", listener);
	}

	public static inline function dblclick(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "dblclick", listener);
	}

	public static inline function focus(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "focus", listener);
	}

	public static inline function focusIn(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "focusIn", listener);
	}

	public static inline function focusOut(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "focusOut", listener);
	}

	public static inline function resize(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "resize", listener);
	}

	public static inline function scroll(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "scroll", listener);
	}

	public static inline function select(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "select", listener);
	}

	public static inline function load(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "load", listener);
	}

	public static inline function unload(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "unload", listener);
	}

	public static inline function error(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "error", listener);
	}

	public static inline function ready(target:DOMCollection, listener:Event->Void):DOMCollection
	{
		return on(target, "ready", listener);
	}
}
#end