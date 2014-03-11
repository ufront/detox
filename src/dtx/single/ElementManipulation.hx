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

import dtx.DOMCollection;
import dtx.DOMNode;
import dtx.DOMType;
#if !js using dtx.XMLWrapper; #end
using Lambda;

/*
JQuery has these classes, let's copy:

	//later? outerHTML()
	//later? setOuterHTML()
	clone() - create a deep copy of this set of matched elements
*/ 


class ElementManipulation
{
	static inline var NodeTypeElement = 1;
	static inline var NodeTypeAttribute = 2;
	static inline var NodeTypeText = 3;
	static inline var NodeTypeComment = 8;
	static inline var NodeTypeDocument = 9;

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
			return dtx.single.Traversing.children(dtx.single.Traversing.parents(n), false).indexOf(n);
		#else
			return (n != null && n.parent != null) ? n.parent.indexOf(n) : -1;
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

	public static #if js inline #end function tagName(elm:DOMNode):String
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
				default:
					"#other";
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
						// TODO: Make this more intelligent. Handle <select> especially
						// What does jQuery do here?
						if ( node.nodeName.toLowerCase()=="input" && attr(node,"type")=="checkbox" ) {
							if ( Reflect.field(node,'checked') ) {
								val = attr( node, "value" );
								if ( val=="" ) val = "checked";
							} 
							else {
								"";
							}
						}
						else {
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

	@:access(dtx.single.Traversing)
	public static function innerHTML(elm:DOMNode):String
	{
		var ret="";
		if (elm != null)
		{
			switch (elm.nodeType)
			{
				case dtx.DOMType.ELEMENT_NODE:
					var sb = new StringBuf();
					for ( child in dtx.single.Traversing.unsafeGetChildren(elm,false) ) 
					{
						printHtml( child, sb, false );
					}
					ret = sb.toString();
				default:
					ret = elm.textContent #if !js () #end; 

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
	public static function html(elm:DOMNode):String
	{
		if ( elm == null ) return "";
		
		var sb = new StringBuf();
		printHtml( elm, sb, false );
		return sb.toString();
	}

	static var selfClosingElms = ["area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr"];
	
	@:access(dtx.single.Traversing)
	static function printHtml( n:DOMNode, sb:StringBuf, preserveTagNameCase:Bool ) {
		if ( isElement(n) ) {
			var elmName = preserveTagNameCase ? n.nodeName : n.nodeName.toLowerCase();
			sb.add('<$elmName');
			
			#if js
				for ( i in 0...n.attributes.length ) {
					var attNode = n.attributes[i];
					sb.add(' ${attNode.nodeName}="');
					addHtmlEscapedString( attNode.nodeValue, sb, true );
					sb.add('"');
				}
			#else
				for ( a in n.attributes() ) {
					sb.add(' $a="');
					addHtmlEscapedString( attr(n,a), sb, true );
					sb.add('"');
				}
			#end
			
			var children = dtx.single.Traversing.unsafeGetChildren(n,false);
			if ( children.length > 0 ) {
				sb.add(">");
				for ( child in children ) {
					printHtml( child, sb, preserveTagNameCase );
				}
				sb.add('</$elmName>');
			}
			else {
				if ( selfClosingElms.has(elmName) ) sb.add(" />");
				else sb.add('></$elmName>');
			}
		} 
		else if ( isDocument(n) ) {
			for ( child in dtx.single.Traversing.children(n, false) ) {
				printHtml( child, sb, preserveTagNameCase );
			}
		} 
		else if ( isTextNode(n) ) {
			addHtmlEscapedString( n.nodeValue, sb, false );
		} 
		else if ( isComment(n) ) {
			sb.add( '<!--' );
			sb.add( n.nodeValue );
			sb.add( '-->' );
		}
	}

	static function addHtmlEscapedString( str:String, sb:StringBuf, encodeQuotes:Bool )
	{
		for ( i in 0...str.length ) {
			var charCode = StringTools.fastCodeAt( str, i );

			if ( charCode=='&'.code ) {
				// Peek ahead and see if we're in a HTML entity code
				// If we are, insert the entity as is, if not, and it's just an ampersand, insert as `&amp;`
				var peekIndex = i+1;
				var isEntity:Bool = false;
				while (peekIndex<str.length) {
					var c = StringTools.fastCodeAt( str, peekIndex );
					if ( c == ';'.code ) {
						// This is the end of an entity.  Providing it's not empty (we peeked at least one character before 
						// the semicolon), then "isEntity" is true.
						isEntity = peekIndex > i+1;
						break;
					}
					if ( (c >= 'a'.code && c <= 'z'.code) || (c >= 'A'.code && c <= 'Z'.code) || (c >= '0'.code && c <= '9'.code) || c == '#'.code) {
						// This could well be part of an entity, keep peeking ahead...
						peekIndex++;
						continue;
					}
					else {
						// There was a character that is not a valid entity, so break
						break;
					}

				}
				sb.add( isEntity ? "&" : "&amp;" );
			}
			else if ( charCode=='<'.code ) sb.add( "&lt;" );
			else if ( charCode=='>'.code ) sb.add( "&gt;" );
			else if ( charCode==160 ) sb.add( "&nbsp;" );
			else if ( encodeQuotes && charCode=="'".code ) sb.add( "&#039;" );
			else if ( encodeQuotes && charCode=='"'.code ) sb.add( "&quot;" );
			else if ( charCode<161 ) sb.addChar( charCode );
			else sb.add( '&#$charCode;' );
		}
	}
}

