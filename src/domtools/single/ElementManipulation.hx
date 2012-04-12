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

package domtools.single;

import js.w3c.level3.Core;
/*
JQuery has these classes, let's copy:

	//later? outerHTML()
	//later? setOuterHTML()
	clone() - create a deep copy of this set of matched elements
*/ 


class ElementManipulation
{
	static var NodeTypeElement = 1;
	static var NodeTypeAttribute = 2;
	static var NodeTypeText = 3;
	static var NodeTypeComment = 8;
	static var NodeTypeDocument = 9;

	public static function isElement(node:Node):Bool
	{
		return node != null && node.nodeType == NodeTypeElement;
	}

	public static function isComment(node:Node):Bool
	{
		return node != null && node.nodeType == NodeTypeComment;
	}

	public static function isTextNode(node:Node):Bool
	{
		return node != null && node.nodeType == NodeTypeText;
	}

	public static function isDocument(node:Node):Bool
	{
		return node != null && node.nodeType == NodeTypeDocument;
	}

	public static function toQuery(n:Node):Query
	{
		return new Query(n);
	}

	public static function attr(elm:Node, attName:String):String
	{
		var ret = "";
		if (isElement(elm))
		{
			var element:Element = cast elm;
			ret = element.getAttribute(attName);
			if (ret == null) ret = "";
		}
		return ret;
	}

	public static function setAttr(elm:Node, attName:String, attValue:String):Node
	{
		if (elm!= null && elm.nodeType == NodeTypeElement)
		{
			var element:Element = cast elm;
			element.setAttribute(attName, attValue);
		}
		return elm;
	}

	public static function removeAttr(elm:Node, attName:String):Node
	{
		if (elm!=null && elm.nodeType == NodeTypeElement)
		{
			var element:Element = cast elm;
			element.removeAttribute(attName);
		}
		return elm;
	}

	private static inline function testForClass(elm:Node, className:String):Bool
	{
		return ((" " + attr(elm, "class") + " ").indexOf(" " + className + " ") > -1);
	}

	public static function hasClass(elm:Node, className:String):Bool
	{
		var hasClass = true;
		if (className.indexOf(' ') > -1)
		{
			var anyWhitespace = ~/\s+/g;
			for (name in anyWhitespace.split(className))
			{
				hasClass = testForClass(elm, name);
				if (hasClass == false) break;
			}
		}
		else 
		{
			hasClass = testForClass(elm, className);
		}
		return hasClass;
	}

	public static function addClass(elm:Node, className:String):Node
	{
		for (name in className.split(' '))
		{
			if (hasClass(elm, className) == false)
			{
				var oldClassName = attr(elm, "class");
				var newClassName =  (oldClassName == "") ? className : oldClassName + " " + className;
				setAttr(elm, "class", newClassName);
			}
		}
		
		return elm;
	}

	public static function removeClass(elm:Node, className:String):Node
	{
		// Get the current list of classes
		var classes = attr(elm, "class").split(" ");

		for (name in className.split(' '))
		{
			// Remove the current one
			classes.remove(name);
		}

		// reassemble as a string
		var newClassValue = classes.join(" ");

		setAttr(elm, "class", newClassValue);
		
		return elm;
	}

	public static function toggleClass(elm:Node, className:String):Node
	{
		for (name in className.split(' '))
		{
			if (hasClass(elm, name))
			{
				removeClass(elm,name);
			}
			else 
			{
				addClass(elm,name);
			}
		}
		return elm;
	}

	public static inline function tagName(elm:Node):String
	{
		return (elm == null) ? "" : elm.nodeName.toLowerCase();
	}

	public static function val(node:Node):String
	{
		var val = "";

		if (node != null)
		{
			switch (node.nodeType)
			{
				case NodeTypeElement:
					val = Reflect.field(node, 'value');
					
					// If the value is null, that means
					// the element did not have a field
					// "value".  See if it has an attr
					// instead.  This will return "" if
					// it doesn't, which is a sane default
					// also.
					if (val == null)
					{
						val = attr(node, "value");
					}
				default:
					val = node.nodeValue;
			}
		}
			

		return val;
	}

	public static function setVal(node:Node, val:Dynamic)
	{
		if (node != null)
		{
			switch (node.nodeType)
			{
				case NodeTypeElement:
					// Set value with Javascript
					#if (js && !nodejs)
					Reflect.setField(node, "value", val);
					
					// Set Attr for non client / js targets
					#else
					setAttr(elm, "value", Std.string(val));
					#end
				default:
					// For comments, text nodes etc, set the nodeValue directly...
					node.nodeValue = val;
			}
		}

		return node;
	}
	
	public static inline function text(elm:Node):String
	{
		var text = "";
		if (elm != null) 
		{
			if (isElement(elm))
			{
				text = elm.textContent;
			}
			else 
			{
				text = elm.nodeValue;
			}
		}
		return text;
	}
	
	public static function setText(elm:Node, text:String):Node
	{
		if (elm != null)
		{
			if (isElement(elm))
			{
				elm.textContent = text;
			}
			else 
			{
				elm.nodeValue = text;
			}
			
		} 
		return elm;
	}

	public static function innerHTML(elm:Node):String
	{
		var ret = "";
		if (elm != null)
		{
			switch (elm.nodeType)
			{
				case NodeTypeElement:
					var element:Element = cast elm;
					ret = element.innerHTML;
				default:
					ret = elm.textContent;
			}
		}
		return ret;
	}

	public static function setInnerHTML(elm:Node, html:String):Node
	{
		if (elm != null)
		{
			switch (elm.nodeType)
			{
				case NodeTypeElement:
					var element:Element = cast elm;
					element.innerHTML = html;
				default:
					elm.textContent = html;
			}
		}
		return elm;
	}

	public static inline function clone(elm:Node, ?deep:Bool = true):Node
	{
		return (elm == null) ? null : elm.cloneNode(deep);
	}

}
