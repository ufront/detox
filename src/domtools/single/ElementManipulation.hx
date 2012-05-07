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

import domtools.DOMNode;
#if !js using domtools.XMLWrapper; #end

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

	public static function isElement(node:DOMNode):Bool
	{
		return node != null && node.nodeType == domtools.DOMType.ELEMENT_NODE;
	}

	public static function isComment(node:DOMNode):Bool
	{
		return node != null && node.nodeType == domtools.DOMType.COMMENT_NODE;
	}

	public static function isTextNode(node:DOMNode):Bool
	{
		return node != null && node.nodeType == domtools.DOMType.TEXT_NODE;
	}

	public static function isDocument(node:DOMNode):Bool
	{
		return node != null && node.nodeType == domtools.DOMType.DOCUMENT_NODE;
	}

	public static function toQuery(n:DOMNode):DOMCollection
	{
		return new DOMCollection(n);
	}

	public static function attr(elm:DOMNode, attName:String):String
	{
		var ret = "";
		if (isElement(elm))
		{
			var element:DOMElement = cast elm;
			#if js
			ret = element.getAttribute(attName);
			#else 
			ret = element.get(attName);
			#end 
			if (ret == null) ret = "";
		}
		return ret;
	}

	public static function setAttr(elm:DOMNode, attName:String, attValue:String):DOMNode
	{
		if (elm!= null && elm.nodeType == domtools.DOMType.ELEMENT_NODE)
		{
			var element:DOMElement = cast elm;
			#if js
			element.setAttribute(attName, attValue);
			#else 
			element.set(attName, attValue);
			#end 
		}
		return elm;
	}

	public static function removeAttr(elm:DOMNode, attName:String):DOMNode
	{
		if (elm!=null && elm.nodeType == domtools.DOMType.ELEMENT_NODE)
		{
			var element:DOMElement = cast elm;
			#if js 
			element.removeAttribute(attName);
			#else 
			element.remove(attName);
			#end 
		}
		return elm;
	}

	private static inline function testForClass(elm:DOMNode, className:String):Bool
	{
		return ((" " + attr(elm, "class") + " ").indexOf(" " + className + " ") > -1);
	}

	public static function hasClass(elm:DOMNode, className:String):Bool
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

	public static function addClass(elm:DOMNode, className:String):DOMNode
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

	public static function removeClass(elm:DOMNode, className:String):DOMNode
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

	public static function toggleClass(elm:DOMNode, className:String):DOMNode
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

	public static inline function tagName(elm:DOMNode):String
	{
		#if js
		return (elm == null) ? "" : elm.nodeName.toLowerCase();
		#else 
		var ret = "";
		// Make XML behaviour mimic the JS DOM behaviour
		if (elm != null)
		{
			ret = switch (elm.nodeType)
			{
				case domtools.DOMType.ELEMENT_NODE:
					elm.nodeName.toLowerCase();
				case domtools.DOMType.DOCUMENT_NODE:
					"#document";
				case domtools.DOMType.TEXT_NODE:
					"#text";
				case domtools.DOMType.COMMENT_NODE:
					"#comment";
			}
			
		}
		return ret;
		#end
	}

	public static function val(node:DOMNode):String
	{
		var val = "";

		if (node != null)
		{
			switch (node.nodeType)
			{
				case domtools.DOMType.ELEMENT_NODE:
					#if js
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
					#else 
					val = attr(node, "value");
					#end
				default:
					val = node.nodeValue;
			}
		}
			

		return val;
	}

	public static function setVal(node:DOMNode, val:Dynamic)
	{
		if (node != null)
		{
			switch (node.nodeType)
			{
				case DOMType.ELEMENT_NODE:
					// Set value with Javascript
					#if js
					Reflect.setField(node, "value", val);
					
					// Set Attr for non client / js targets
					#else
					setAttr(node, "value", Std.string(val));
					#end
				default:
					// For comments, text nodes etc, set the nodeValue directly...
					node.nodeValue = val;
			}
		}

		return node;
	}
	
	public static inline function text(elm:DOMNode):String
	{
		var text = "";
		if (elm != null) 
		{
			if (isElement(elm))
			{
				text = #if js elm.textContent #else elm.textContent() #end;
			}
			else 
			{
				text = elm.nodeValue;
			}
		}
		return text;
	}
	
	public static function setText(elm:DOMNode, text:String):DOMNode
	{
		if (elm != null)
		{
			if (isElement(elm))
			{
				#if js
				elm.textContent = text;
				#else 
				elm.setTextContent(text);
				#end
			}
			else 
			{
				elm.nodeValue = text;
			}
			
		} 
		return elm;
	}

	public static function innerHTML(elm:DOMNode):String
	{
		var ret = "";
		if (elm != null)
		{
			switch (elm.nodeType)
			{
				case domtools.DOMType.ELEMENT_NODE:
					var element:DOMElement = cast elm;
					#if js
					ret = element.innerHTML;
					#else 
					ret = element.innerHTML();
					#end
				default:
					ret = #if js elm.textContent #else elm.textContent() #end; 

			}
		}
		return ret;
	}

	public static function setInnerHTML(elm:DOMNode, html:String):DOMNode
	{
		if (elm != null)
		{
			switch (elm.nodeType)
			{
				case domtools.DOMType.ELEMENT_NODE:
					var element:DOMElement = cast elm;
					#if js
					element.innerHTML = html;
					#else 
					elm.setInnerHTML(html);
					#end
				default:
					#if js
					elm.textContent = html;
					#else 
					elm.setTextContent(html);
					#end
			}
		}
		return elm;
	}

	public static inline function clone(elm:DOMNode, ?deep:Bool = true):DOMNode
	{
		return (elm == null) ? null : elm.cloneNode(deep);
	}

}

