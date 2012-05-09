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

class ElementManipulation
{
	/** Assume we're operating on the first element. */
	public static function attr(query:DOMCollection, attName:String):String
	{
		return (query != null && query.length > 0) ? domtools.single.ElementManipulation.attr(query.getNode(), attName) : "";
	}

	public static function setAttr(query:DOMCollection, attName:String, attValue:String):DOMCollection
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.setAttr(node, attName, attValue);
			}
		}
		return query;
	}

	public static function removeAttr(query:DOMCollection, attName:String):DOMCollection
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.removeAttr(node,attName);
			}
		}
		return query;
	}

	/** Checks if every element in the collection has the given class */
	public static function hasClass(query:DOMCollection, className:String):Bool
	{
		var result = false;

		if (query != null && query.length > 0)
		{
			// If there's at least one result, we'll begin with "true"
			// and loop around and see if it gets switched to "false"
			result = true;

			for (node in query)
			{
				if (domtools.single.ElementManipulation.hasClass(node, className) == false)
				{
					result = false;
					break;
				}
			}
		}

		return result;
	}

	public static function addClass(query:DOMCollection, className:String):DOMCollection
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.addClass(node,className);
			}
		}
		return query;
	}

	public static function removeClass(query:DOMCollection, className:String):DOMCollection
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.removeClass(node,className);
			}
		}
		return query;
	}

	public static function toggleClass(query:DOMCollection, className:String):DOMCollection
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.toggleClass(node,className);
			}
		}
		return query;
	}

	public static inline function tagName(query:DOMCollection):String
	{
		return (query != null && query.length > 0) ? domtools.single.ElementManipulation.tagName(query.getNode()) : "";
	}

	public static function val(query:DOMCollection):String
	{
		return (query != null && query.length > 0) ? domtools.single.ElementManipulation.val(query.getNode()) : "";
	}

	public static function setVal(query:DOMCollection, val:Dynamic)
	{
		var value = Std.string(val);
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.setVal(node, value);
			}
		}
		return query;
	}
	
	public static function text(query:DOMCollection):String
	{
		var text = "";
		if (query != null)
		{
			for (node in query)
			{
				text = text + domtools.single.ElementManipulation.text(node);
			}
		}
		return text;
	}
	
	public static function setText(query:DOMCollection, text:String):DOMCollection
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.setText(node,text);
			}
		}
		return query;
	}

	public static function innerHTML(query:DOMCollection):String
	{
		var ret = "";
		if (query != null)
		{
			for (node in query)
			{
				ret += domtools.single.ElementManipulation.innerHTML(node);
			}
		}
		return ret;
	}

	public static function setInnerHTML(query:DOMCollection, html:String):DOMCollection
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.setInnerHTML(node,html);
			}
		}
		return query;
	}

	public static inline function toString(collection:DOMCollection, ?deep:Bool = true):DOMNode
	{
		var str = "";
		for (node in collection)
		{
			#if js
			str += domtools.single.ElementManipulation.toString(node);
			#else 
			str += node.toString();
			#end
		}
		return str;
	}

}