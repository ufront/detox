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

#if (haxe_211 || haxe3)
	import js.html.CSSStyleDeclaration;
#else 
	import js.w3c.level3.Core;
	import js.w3c.css.CSSOM;
#end 

/**
	This class provides static helper methods to access or modify style properties of a DOM node.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then operate on a DOMNode as if they were methods of the DOMNode object itself.
	Each setter method is chainable, and returns the original DOMNode.
	Each method is null-safe, if a node is null or of the wrong type it will have no effect.
**/
class Style
{
	/**
		Get the computed style object for a given element.

		This uses `js.Browser.window.getComputedStyle(node)` to fetch the style.
		If the node is null or not an element, this will return null.
		On platforms other than Javascript this will always return null.
	**/
	public static function getComputedStyle(node:DOMNode):Null<CSSStyleDeclaration>
	{
		var style:CSSStyleDeclaration = null;
		#if js
			if (ElementManipulation.isElement(node))
			{
				style = js.Browser.window.getComputedStyle(cast node);
			}
		#end
		return style;
	}
	
	/**
		Return the computed CSS value for a given style property.

		Will use `getComputedStyle(node).getPropertyValue()` to retrieve a text representation of that style property.
		If the node is null, not an element, or the specified property is null or does not exist, this returns null.
	**/
	public static function css(node:DOMNode, prop:String):Null<String>
	{
		var style = getComputedStyle(node);
		return (style!=null && prop!=null) ? style.getPropertyValue(prop) : null;
	}

	/**
		Set the CSS value for a specific property.

		This will use `getComputedStyle(node).setProperty(prop,val)`.

		@param node The node to set the CSS on.  If the node is null or not an element, this method will have no effect.
		@param prop The CSS property name to set.  If it is null, it will have no effect.
		@param val The value to set the property to.  This should be a string similar to the one you would use in a CSS file.
		@param important Should the rule have the "important" flag.  Default is false.
		@return The same DOM node.

		On platforms other than Javascript this will have no effect.
	**/
	public static function setCSS(node:DOMNode, prop:String, val:Null<String>, ?important:Bool=false):DOMNode
	{
		var style = getComputedStyle(node);
		if (style!=null && prop!=null)
		{
			var priority = important ? "important" : "";
			style.setProperty(prop, val, priority);
		}
		return node;
	}

	/** A shortcut for `setCSS(c, "display", "")`. **/
	public static inline function show(n:DOMNode):DOMNode return setCSS(n, "display", "");

	/** A shortcut for `setCSS(c, "display", "none")`. **/
	public static inline function hide(n:DOMNode):DOMNode return setCSS(n, "display", "none");

	/**
		Get the position information for a given element.

		If we are on Javascript, and the node is an element, then the values will be provided:

		- top: node.offsetTop
		- left: node.offsetLeft
		- width: node.offsetWidth
		- height: node.offsetHeight

		If the node is null or not an element, or on platforms other than Javascript, the default `{ top:-1, left:-1, width:0, height:0 }` is used.
	**/
	public static function pos(node:DOMNode):{ top:Int, left:Int, width:Int, height:Int }
	{
		var pos = {
			top: -1,
			left: -1,
			width: 0,
			height: 0
		};
		#if js
			if (ElementManipulation.isElement(node))
			{
				var e:js.html.Element = cast node;
				return {
					top: e.offsetTop,
					left: e.offsetLeft,
					width: e.offsetWidth,
					height: e.offsetHeight
				}
			}
		#end
		return pos;
	}
}
