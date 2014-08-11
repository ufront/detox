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

package dtx.collection;

import dtx.DOMCollection;
using dtx.collection.ElementManipulation;
#if js
	import js.html.*;
#end

/**
	This class provides static helper methods to access or modify style properties of all nodes in a `dtx.DOMCollection`.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then operate on DOMCollections as if they were methods on the DOMCollection object itself.
	Each setter method is chainable, and returns the original collection with the original type information.
	Each method is null-safe, if a collection is empty or null it will have no effect.
**/
class Style
{
	#if js
		/** Run `dtx.single.Style.getStyle` for the first node in the collection. **/
		public static function getStyle(c:DOMCollection):Null<CSSStyleDeclaration>
		{
			return (c!=null) ? dtx.single.Style.getStyle(c.getNode(0)) : null;
		}

		/** Run `dtx.single.Style.getComputedStyle` for the first node in the collection. **/
		public static function getComputedStyle(c:DOMCollection):Null<CSSStyleDeclaration>
		{
			return (c!=null) ? dtx.single.Style.getComputedStyle(c.getNode(0)) : null;
		}

		/** Run `dtx.single.Style.css` for the first node in the collection. **/
		public static function css(c:DOMCollection, property:String):Null<String>
		{
			return (c!=null) ? dtx.single.Style.css(c.getNode(0), property) : null;
		}

		/** Run `dtx.single.Style.setCSS` for each node in the collection. **/
		public static function setCSS<T:DOMCollection>(c:T, prop:String, val:Null<String>, ?important:Bool=false):T
		{
			if (c != null)
			{
				for (node in c)
				{
					dtx.single.Style.setCSS(node, prop, val, important);
				}
			}
			return c;
		}

		/** Run `dtx.single.Style.removeCSS` for each node in the collection. **/
		public static function removeCSS<T:DOMCollection>(c:T, prop:String):T
		{
			if (c != null)
			{
				for (node in c)
				{
					dtx.single.Style.removeCSS(node, prop);
				}
			}
			return c;
		}
	#end

	/**
		Show each element in the collection.

		On JS this is a shortcut for `removeCSS(c, "display")`.
		On other platforms this is a shortcut for `dtx.collection.ElementManipulation.removeClass("hidden")`.
	**/
	public static inline function show<T:DOMCollection>(c:T):T
	{
		#if js
			return removeCSS(c, "display");
		#else
			return c.removeClass("hidden");
		#end
	}

	/**
		Hide each element in the collection.

		On JS this is a shortcut for `setCSS(c, "display", "none", true)`.
		On other platforms this is a shortcut for `dtx.collection.ElementManipulation.addClass("hidden")`.
	**/
	public static inline function hide<T:DOMCollection>(c:T):T
	{
		#if js
			return setCSS(c, "display", "none", true);
		#else
			return c.addClass("hidden");
		#end
	}

	/** Run `dtx.single.Style.pos` for the first node in the collection. **/
	public static function pos(c:DOMCollection):{ top:Int, left:Int, width:Int, height:Int }
	{
		return dtx.single.Style.pos(c.getNode(0));
	}
}
