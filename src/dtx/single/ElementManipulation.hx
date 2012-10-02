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
import dtx.DOMType;
#if !js using dtx.XMLWrapper; #end

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
		return node != null && node.nodeType == dtx.DOMType.ELEMENT_NODE;
	}

	public static function isComment(node:DOMNode):Bool
	{
		return node != null && node.nodeType == dtx.DOMType.COMMENT_NODE;
	}

	public static function isTextNode(node:DOMNode):Bool
	{
		return node != null && node.nodeType == dtx.DOMType.TEXT_NODE;
	}

	public static function isDocument(node:DOMNode):Bool
	{
		return node != null && node.nodeType == dtx.DOMType.DOCUMENT_NODE;
	}

	public static function toQuery(n:DOMNode):DOMCollection
	{
		return new DOMCollection(n);
	}

	public static function index(n:DOMNode):Int 
	{
		#if js
			return Lambda.indexOf(dtx.single.Traversing.children(dtx.single.Traversing.parents(n), false), n);
		#else
			return Lambda.indexOf(n.parent, n);
		#end 
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
		if (elm!= null && elm.nodeType == dtx.DOMType.ELEMENT_NODE)
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
		if (elm!=null && elm.nodeType == dtx.DOMType.ELEMENT_NODE)
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
				case dtx.DOMType.ELEMENT_NODE:
					elm.nodeName.toLowerCase();
				case dtx.DOMType.DOCUMENT_NODE:
					"#document";
				case dtx.DOMType.TEXT_NODE:
					"#text";
				case dtx.DOMType.COMMENT_NODE:
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
				case dtx.DOMType.ELEMENT_NODE:
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
				case dtx.DOMType.ELEMENT_NODE:
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
				case dtx.DOMType.ELEMENT_NODE:
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

	// JS doesn't have a built in html() method
	public static inline function html(elm:DOMNode):String
	{
		#if js
		var div = Detox.create("div");
		dtx.single.DOMManipulation.append(div, clone(elm));
		return innerHTML(div);
		#else 
		return (elm != null) ? elm.toString() : "";
		#end
	}

}

