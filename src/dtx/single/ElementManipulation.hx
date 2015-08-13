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
using Lambda;

/**
	This class provides static helper methods to interact with DOM nodes and elements.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then operate on a DOMNode as if they were methods on the DOMNode object itself.
	Any method which does not retrieve a specific value will return the original node, allowing method chaining.
	Each method is null-safe, if a node is null it will have no effect.
**/
class ElementManipulation
{
	static inline var NodeTypeElement:Int = 1;
	static inline var NodeTypeAttribute:Int = 2;
	static inline var NodeTypeText:Int = 3;
	static inline var NodeTypeComment:Int = 8;
	static inline var NodeTypeDocument:Int = 9;

	/** @return Returns true if the given node is not null and is an element node. **/
	public static function isElement(node:DOMNode):Bool
	{
		return node != null && node.nodeType == dtx.DOMType.ELEMENT_NODE;
	}

	/** @return Returns true if the given node is not null and is a comment node. **/
	public static function isComment(node:DOMNode):Bool
	{
		return node != null && node.nodeType == dtx.DOMType.COMMENT_NODE;
	}

	/** @return Returns true if the given node is not null and is a CData. **/
	public static function isCData(node:DOMNode):Bool
	{
		return node != null && node.nodeType == dtx.DOMType.CDATA_NODE;
	}

	/** @return Returns true if the given node is not null and is a text node. **/
	public static function isTextNode(node:DOMNode):Bool
	{
		return node != null && node.nodeType == dtx.DOMType.TEXT_NODE;
	}

	/** @return Returns true if the given node is not null and is a document node. **/
	public static function isDocument(node:DOMNode):Bool
	{
		return node != null && node.nodeType == dtx.DOMType.DOCUMENT_NODE;
	}

	/**
		Get the position/index of this node relative to its sibling nodes.

		@return The zero-based index of this node relative to it's siblings, or -1 if this node was null or did not have a parent.
	**/
	public static function index(n:DOMNode):Int
	{
		return dtx.single.Traversing.children(dtx.single.Traversing.parents(n), false).indexOf(n);
	}

	/**
		Return the value of a given element attribute.

		@param elm The DOM Node.  If it is null or not an element, the returned value will be an empty string.
		@param attName The attribute name to fetch.  If the element does not have an attribute with this name, or if attName is null, the returned value will be an empty string.
		@return The attribute value if it existed, or an empty string otherwise.
	**/
	public static function attr(elm:DOMNode, attName:String):String
	{
		var ret = "";
		if (isElement(elm) && attName != null)
		{
			var element:DOMElement = cast elm;
			ret = element.getAttribute(attName);
			if (ret == null) ret = "";
		}
		return ret;
	}

	/**
		Set an attribute value on a DOM element.

		@param elm The DOMNode to operate on.  If it is null or not an element, this will have no effect.
		@param attName The name of the attribute to set.  If the value is null, this method will have no effect.
		@param attValue The value to set the attribute to.  If null an empty string will be used.
		@return The original DOMNode.
	**/
	public static function setAttr(elm:DOMNode, attName:String, attValue:String):DOMNode
	{
		if (elm != null && elm.nodeType == dtx.DOMType.ELEMENT_NODE && attName != null)
		{
			if (attValue == null) {
				attValue = "";
			}
			var element:DOMElement = cast elm;
			element.setAttribute(attName, attValue);
		}
		return elm;
	}

	/**
		Remove an attribute from a DOM element.

		@param elm The DOMNode to operate on.  If it is null or not an element, this will have no effect.
		@param attName The name of the attribute to remove.  If the value is null, this method will have no effect.
		@return The original DOMNode.
	**/
	public static function removeAttr(elm:DOMNode, attName:String):DOMNode
	{
		if (elm!=null && elm.nodeType == dtx.DOMType.ELEMENT_NODE && attName != null)
		{
			var element:DOMElement = cast elm;
			element.removeAttribute(attName);
		}
		return elm;
	}

	private static inline function testForClass(elm:DOMNode, className:String):Bool
	{
		return attr(elm,"class").split(" ").indexOf(className)>-1;
	}

	/**
		Test if a node has a given class (or list of classes) as part of it's "class" attribute.

		This will test for a complete class name, matching only if the exact name exists in the "class" attribute.
		Multiple names can be tested by separating the names with a single space: `elm.hasClass("btn btn-large btn-primary")`.
		The class names do not have to appear in a particular order to match, and other class names may be present without affecting the match.

		@param elm The DOMNode to test.  If it is null or not an element, this will always return false.
		@param className The class name (or list of names, separated by a single space) to search for.  If this is null or an empty string, this will always return false.
		@return True if the node is an element, and has all of the specified class names.  False otherwise.
	**/
	public static function hasClass(elm:DOMNode, className:String):Bool
	{
		var hasClass = false;
		if (isElement(elm) && className!=null && className!="")
		{
			hasClass = true;
			for (name in className.split(" "))
			{
				if (name!="" && testForClass(elm, name) == false) {
					hasClass = false;
					break;
				}
			}
		}
		return hasClass;
	}

	/**
		Add one or more class names to the "class" attribute on a given element.

		If the class name was already present in the "class" attribute, it will not be added again.
		If the class attribute was not present or was empty, the attribute will be set to the new class name.
		If the class attribute was already present and not empty, the attribute will be appended with a space and the new class name.

		@param elm The node to add the classes to.  If it is not an element, or is null, this method will have no effect.
		@param className The name to add (or multiple names, separated by a single space).  If the name is empty or null, it will have no effect.
		@return The original DOMNode.
	**/
	public static function addClass(elm:DOMNode, className:String):DOMNode
	{
		if (className != null)
		{
			for (name in className.split(' '))
			{
				if (name != "" && hasClass(elm, name) == false)
				{
					var oldClassAttr = attr(elm, "class");
					var newClassAttr =  (oldClassAttr == "") ? name : '$oldClassAttr $name';
					setAttr(elm, "class", newClassAttr);
				}
			}
		}

		return elm;
	}

	/**
		Remove one or more class names from the "class" attribute on a given element.

		If the class name was already present in the "class" attribute, it will have no effect.
		If the class name existed multiple times inside the "class" attribute, only the first occurence will be removed.

		@param elm The node to remove the classes from.  If it is not an element, or is null, this method will have no effect.
		@param className The name to remove (or multiple names, separated by a single space).  If the name is empty or null, it will have no effect.
		@return The original DOMNode.
	**/
	public static function removeClass(elm:DOMNode, className:String):DOMNode
	{
		// Get the current list of classes
		var classes = attr(elm, "class").split(" ");

		if (className != null)
		{
			for (name in className.split(' '))
			{
				// Remove the current one
				classes.remove(name);
			}
		}

		// reassemble as a string
		var newClassValue = classes.join(" ");

		setAttr(elm, "class", newClassValue);

		return elm;
	}

	/**
		Toggle one or more class names from appearing in the "class" attribute of an element.

		If a class name exists already, it will be removed.
		If a class name does not exist, it will be added.
		If the class name existed multiple times inside the "class" attribute, only the first occurence will be removed.

		@param elm The node to remove the classes from.  If it is not an element, or is null, this method will have no effect.
		@param className The name to remove (or multiple names, separated by a single space).  If the name is empty or null, it will have no effect.
		@return The original DOMNode.
	**/
	public static function toggleClass(elm:DOMNode, className:String):DOMNode
	{
		if (className != null)
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
		}
		return elm;
	}

	/**
		Return the tag name for a given node.

		If the node is an element, the element name will be returned.  (For example, `<div>` will have the tag name "div").
		If the node is a document, the value "#document" will be returned.
		If the node is a text node, the value "#text" will be returned.
		If the node is a comment node, the value "#comment" will be returned.
		If the node is null, an empty string will be returned.
		If the node is of a different type, the return string is unspecified.
	**/
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

	/**
		Return the value of a given node.

		If the node is an element, the behaviour is as follows:

		* On platforms other than Javascript, `attr(node,"value")` is returned.
		* On Javascript, if the element is a checkbox, it returns either the "value" attribute, or the string "checked" if the box was checked, or an empty string if the box was not checked.
		* On Javascript, if the node has a "value" property, such as on an "<input>" element, the value is returned.
		* On Javascript, if the node does not have a "value" property, or if it returns null, then `attr(node,"value")` is returned.

		If the node is not an element, then the node's "nodeValue" will be returned.
	**/
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

	/**
		Set the value of a given node.

		If the node is an element, the following behaviour is used:

		* On Javascript, the "value" property is set - this will for instance update an input with the new value.
		* On other platforms, the "value" attribute is set.

		If the node is not an element, then the node's `nodeValue` is set to `val`.
	**/
	public static function setVal(node:DOMNode, val:Dynamic):DOMNode
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

	/**
		This returns the text value of a node.

		If the node is null, an empty string is returned.
		If the node is an element or document, then the `textContent` will be returned - this is the content of all child text nodes, and does not include comments.
		If the node is not an element or document, then the node's `nodeValue` will be returned.
	**/
	public static function text(elm:DOMNode):String
	{
		var text = "";
		if (elm != null)
			text = elm.textContent;
		return text;
	}

	/**
		This sets the text content of the node.  If the node is null, then this method has no effect.

		If the node is an element or document, then the `textContent` will be set - all child nodes will be replaced by a single text node with the given content.
		If the node is not an element or document, then the node's `nodeValue` will be set.

		@param elm The node to operate on.
		@param text The text to set.  If null, an empty string will be used.
		@return The original DOMNode.
	**/
	public static function setText(elm:DOMNode, text:String):DOMNode
	{
		if (text == null)
			text = "";

		if (elm != null)
		{
			if (isElement(elm) || isDocument(elm))
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

	/**
		This returns the inner HTML value of a node.

		If the node is null, an empty string is returned.
		If the node is not an element or document, then the node's `nodeValue` will be returned.
		If the node is an element or document, then the combined html of each child node will be printed.

		See `html` for a detailed description of the HTML printing process that will be used.
	**/
	@:access(dtx.single.Traversing)
	public static function innerHTML(elm:DOMNode):String
	{
		var ret="";
		if (isElement(elm) || isDocument(elm))
		{
			var sb = new StringBuf();
			for ( child in dtx.single.Traversing.unsafeGetChildren(elm,false) )
			{
				printHtml( child, sb, false );
			}
			ret = sb.toString();
		}
		else if (elm != null)
		{
			ret = elm.textContent;
		}
		return ret;
	}

	/**
		This sets the inner HTML content of the node.

		If the node is an element or document, then the `innerHTML` will be set - the html string will be parsed, and the resulting nodes will replace all of the current child nodes.
		If the node is not an element or document, then the node's `textContent` will be set.

		@param elm The node to operate on.  If the node is null, then this method has no effect.
		@param html The html to set.  If null, an empty string will be used.
		@return The original DOMNode.
	**/
	public static function setInnerHTML(elm:DOMNode, html:String):DOMNode
	{
		if (html == null)
			html = "";

		if (elm != null)
		{
			switch (elm.nodeType)
			{
				case dtx.DOMType.ELEMENT_NODE:
					elm._setInnerHTML(html);
				default:
					elm.textContent = html;
			}
		}
		return elm;
	}

	/**
		This will clone the current node (and any child nodes).

		The resulting node should be identical in structure, though details such as the ordering of attributes is not gauranteed.

		This performs a "deep" clone - all child nodes are also cloned.

		If the node is null, this will return null.
	**/
	public static inline function clone(elm:Null<DOMNode>):Null<DOMNode>
	{
		return (elm == null) ? null : elm.cloneNode( true );
	}

	/**
		Get a HTML String representation of the current DOMNode.

		If `node` is null an empty string will be returned.

		The following process is applied when printing HTML:

		- Document nodes will have all children printed.
		- Element nodes will be printed `<$tag></$tag>` or `<$tag />` depending on if the tag name is in the `selfClosingElms` array.
		- Element attributes will be printed in an unspecified order, with the attribute value being HTML escaped.
		- Comment nodes will be wrapped in `'<!--$comment-->'`.
		- Text nodes will be HTML escaped.
		- All other nodes will be ignored.

		The HTML escaping process is a little fragile, and suggestions for a better implementations are welcome.
		This is to work around inconsistencies in the various Haxe XML parsers the leave entities in differing states in the DOM.

		Currently, it is:

		- If an ampersand is encountered and it is a HTML entity (eg `&nbsp;`), then the entity is inserted.
		- If an empersand is encountered and it is not an entity, the entity representing an ampersand is inserted (`&amp;`).
		- The characters "<" and ">" are inserted as the entities `&lt;` and `&gt;` respectively.
		- The character with code `160` is inserted as the entity `&nbsp;`.
		- Any character with a code above `160` is inserted as `&#${code}`.
		- If we are escaping a HTML attribute value, `'` and `"` are also escaped as `&#039;` and `&quot;` respectively.
	**/
	public static function html(node:DOMNode):String
	{
		if ( node == null ) return "";

		var sb = new StringBuf();
		printHtml( node, sb, false );
		return sb.toString();
	}

	/**
		The array of tags which are allowed to be "self closing" in HTML5.

		If you believe there is a mistake or ommission, please consider opening an issue or pull request on Github.
		You can edit this array at runtime if needed.
	**/
	public static var selfClosingElms:Array<String> = ["area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr"];

	@:access(dtx.single.Traversing)
	static function printHtml( n:DOMNode, sb:StringBuf, preserveTagNameCase:Bool ):Void {
		if ( isElement(n) ) {
			var elmName = preserveTagNameCase ? n.nodeName : n.nodeName.toLowerCase();
			sb.add('<$elmName');

			for ( att in n.attributes ) {
				sb.add(' ${att.name}="');
				addHtmlEscapedString( att.value, sb, true );
				sb.add('"');
			}

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
		else if ( isCData(n) ) {
			sb.add( '<![CDATA[' );
			sb.add( n.nodeValue );
			sb.add( ']]>' );
		}
	}

	static function addHtmlEscapedString( str:String, sb:StringBuf, encodeQuotes:Bool ):Void
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
			else sb.addChar( charCode );
		}
	}
}
