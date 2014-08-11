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

#if js
	import js.html.CSSStyleDeclaration;
	import js.html.Element;
#end
using dtx.single.ElementManipulation;

/**
	This class provides static helper methods to access or modify style properties of a DOM node.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then operate on a DOMNode as if they were methods of the DOMNode object itself.
	Each setter method is chainable, and returns the original DOMNode.
	Each method is null-safe, if a node is null or of the wrong type it will have no effect.
**/
class Style
{
	#if js
		/**
			Get the computed style object for a given element.

			This uses `js.Browser.window.getComputedStyle(node)` to fetch the style.
			If the node is null or not an element, this will return null.
			On platforms other than Javascript this will always return null.

			Please note that this CSSStyleDeclaration object cannot set properties, only read properties.  If you attempt to set properties an error will be thrown.
		**/
		public static function getStyle(node:DOMNode):Null<CSSStyleDeclaration>
		{
			var style:CSSStyleDeclaration = null;
			#if js
				if (node.isElement())
				{
					var elm:Element = cast node;
					style = elm.style;
				}
			#end
			return style;
		}

		/**
			Get the computed style object for a given element.

			This uses `js.Browser.window.getComputedStyle(node)` to fetch the style.
			If the node is null or not an element, this will return null.
			On platforms other than Javascript this will always return null.

			Please note that this CSSStyleDeclaration object cannot set properties, only read properties.  If you attempt to set properties an error will be thrown.
		**/
		public static function getComputedStyle(node:DOMNode):Null<CSSStyleDeclaration>
		{
			var style:CSSStyleDeclaration = null;
			#if js
				if (node.isElement())
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

			This will use `getStyle(node).setProperty(prop,val)`.

			@param node The node to set the CSS on.  If the node is null or not an element, this method will have no effect.
			@param prop The CSS property name to set.  If it is null, it will have no effect.
			@param val The value to set the property to.  This should be a string similar to the one you would use in a CSS file.
			@param important Should the rule have the "important" flag.  Default is false.
			@return The same DOM node.

			On platforms other than Javascript this will have no effect.
		**/
		public static function setCSS(node:DOMNode, prop:String, val:Null<String>, ?important:Bool=false):DOMNode
		{
			if (node.isElement() && prop!=null)
			{
				var style = getStyle(node);
				var priority = important ? "important" : "";
				style.setProperty(prop, val, priority);
			}
			return node;
		}

		/**
			Remove a CSS property from an element's style declaration.

			This will use `getStyle(node).removeProperty(prop,val)`, meaning it will only affect style properties directly applied to the node, not those inherited, computed or applied via a stylesheet.

			@param node The node to set the CSS on.  If the node is null or not an element, this method will have no effect.
			@param prop The CSS property to remove.  If it is null, it will have no effect.
			@return The same DOM node.

			On platforms other than Javascript this will have no effect.
		**/
		public static function removeCSS(node:DOMNode, prop:String):DOMNode
		{
			if (node.isElement() && prop!=null)
			{
				var style = getStyle(node);
				style.removeProperty(prop);
			}
			return node;
		}
	#end

	/**
		Show each element in the collection.

		On JS this is a shortcut for `removeCSS(c, "display")`.
		On other platforms this is a shortcut for `dtx.single.ElementManipulation.removeClass("hidden")`.
	**/
	public static inline function show(node:DOMNode):DOMNode
	{
		#if js
			return removeCSS(node, "display");
		#else
			return node.removeClass("hidden");
		#end
	}

	/**
		Hide each element in the collection.

		On JS this is a shortcut for `setCSS(c, "display", "none", true)`.
		On other platforms this is a shortcut for `dtx.single.ElementManipulation.addClass("hidden")`.
	**/
	public static inline function hide(node:DOMNode):DOMNode
	{
		#if js
			return setCSS(node, "display", "none", true);
		#else
			return node.addClass("hidden");
		#end
	}

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
			if (node.isElement())
			{
				var e:Element = cast node;
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
