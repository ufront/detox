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

import dtx.DOMType;
#if js 
	import js.html.Element;
#else
	using dtx.XMLWrapper;
#end

class ElementManipulation
{
	static inline var NodeTypeElement = 1;
	static inline var NodeTypeAttribute = 2;
	static inline var NodeTypeText = 3;
	static inline var NodeTypeComment = 8;
	static inline var NodeTypeDocument = 9;

	public static function toNodes(n:Node):Nodes
	{
		return [n];
	}

	public static function index(n:Node):Int 
	{
		return n.parent.children.indexOf(n);
	}

	public static function hasAttr(elm:Node, attName:String):Bool
	{
		var ret = false;
		if (elm.isElement())
		{
			#if js
				var element:Element = cast elm.toDom();
				var attr = element.getAttribute(attName);
			#else 
				var attr = elm.toXml().get(attName);
			#end 
			ret = (attr == null);
		}
		return ret;
	}

	public static function attr(elm:Node, attName:String):String
	{
		var ret = "";
		if (elm.isElement())
		{
			#if js
				var element:Element = cast elm;
				ret = element.getAttribute(attName);
			#else 
				ret = elm.toXml().get(attName);
			#end 
			if (ret == null) ret = "";
		}
		return ret;
	}

	public static function setAttr(elm:Node, attName:String, attValue:String):Node
	{
		if (elm!= null && elm.nodeType == dtx.DOMType.ELEMENT_NODE)
		{
			#if js
				var element:Element = cast elm;
				element.setAttribute(attName, attValue);
			#else 
				elm.toXml().set(attName, attValue);
			#end 
		}
		return elm;
	}

	public static function removeAttr(elm:Node, attName:String):Node
	{
		if (elm!=null && elm.nodeType == dtx.DOMType.ELEMENT_NODE)
		{
			#if js 
				var element:Element = cast elm;
				element.removeAttribute(attName);
			#else 
				elm.toXml().remove(attName);
			#end 
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
		for (name in className.split(' ')) {
			if (hasClass(elm, name)) removeClass(elm,name);
			else addClass(elm,name);
		}
		return elm;
	}

	public static inline function tagName(elm:Node):String
	{
		#if js
			var node:js.html.Node = elm;
			return (node == null) ? "" : node.nodeName.toLowerCase();
		#else 
			var ret = "";
			// Make XML behaviour mimic the JS DOM behaviour
			if (elm != null)
			{
				var node = elm.toXml();
				ret = switch (node.nodeType)
				{
					case DOMType.ELEMENT_NODE:
						node.nodeName.toLowerCase();
					case DOMType.DOCUMENT_NODE:
						"#document";
					case DOMType.TEXT_NODE:
						"#text";
					case DOMType.COMMENT_NODE:
						"#comment";
					default:
						"#other";
				}
				
			}
			return ret;
		#end
	}

	public static function val(node:Node):String
	{
		var val = "";

		if (node != null)
		{
			switch (node.nodeType)
			{
				case DOMType.ELEMENT_NODE:
					#if js
					// TODO: Make this more intelligent. Handle <select> especiallyg
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

	public static function setVal(node:Node, val:Dynamic)
	{
		if (node != null)
		{
			switch (node.nodeType)
			{
				case DOMType.ELEMENT_NODE:
					// TODO: Make this more intelligent. Handle <select> especially

					// Set value with Javascript
					#if js
					Reflect.setField(node, "value", val);
					
					// Set Attr for non client / js targets
					#else
					setAttr(node, "value", Std.string(val));
					#end
				default:
					// For comments, text nodes etc, set the nodeValue directly...
					#if js 
						node.toDom().nodeValue = val;
					#else 
						node.toXml().nodeValue = val;
					#end
			}
		}

		return node;
	}
	
	public static inline function text(elm:Node):String
	{
		var text = "";
		if (elm != null) 
		{
			if (elm.isElement())
			{
				text = #if js elm.toDom().textContent #else elm.textContent() #end;
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
			if (elm.isElement())
			{
				#if js
				elm.toDom().textContent = text;
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

	public static function innerHTML(elm:Node):String
	{
		var ret = "";
		if (elm != null)
		{
			switch (elm.nodeType)
			{
				case DOMType.ELEMENT_NODE:
					#if js
						var element:Element = cast elm;
						ret = element.innerHTML;
					#else 
						ret = dtx.XMLWrapper.innerHTML( elm );
					#end
				default:
					#if js 
						ret = elm.toDom().textContent; 
					#else 
						ret = elm.toXml().textContent(); 
					#end 

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
				case DOMType.ELEMENT_NODE:
					#if js
						var element:Element = cast elm;
						element.innerHTML = html;
					#else
						XMLWrapper.setInnerHTML(elm, html);
					#end
				default:
					#if js
					elm.toDom().textContent = html;
					#else 
					elm.setTextContent(html);
					#end
			}
		}
		return elm;
	}

	public static inline function clone(elm:Node, ?deep:Bool = true):Node
	{
		#if js 
			return (elm == null) ? null : elm.toDom().cloneNode(deep);
		#else 
			return (elm == null) ? null : XMLWrapper.cloneNode(elm, deep);
		#end
	}

	#if !js
		static var selfClosingElms = ["area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr"];
		static public function printHtml( n:Xml, sb:StringBuf ) {
			if ( n.nodeType == DOMType.ELEMENT_NODE ) {
				var elmName = n.nodeName;
				sb.add('<$elmName');
				
				for ( a in n.attributes() ) {
					var value = n.get(a);
					sb.add(' $a="$value"');
				}
				
				var children = Lambda.array(n);
				if ( children.length > 0 ) {
					sb.add(">");
					for ( child in children ) {
						printHtml( child, sb );
					}
					sb.add('</$elmName>');
				}
				else {
					sb.add( 
						if ( Lambda.has(selfClosingElms, elmName) ) " />" 
						else '></$elmName>' 
					);
				}
			} else if ( n.nodeType == DOMType.DOCUMENT_NODE ) {
				for ( child in n ) {
					printHtml( child, sb );
				}
			} else {
				sb.add( n.toString() );
			}
			return sb;
		}
	#end
}

