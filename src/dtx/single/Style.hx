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

/* 
Functionality to implement:
	innerHeight
	innerWidth
	css() - 
	offset()
	offsetParent()
	scrollLeft - int
	scrollTop - int
	position(top, left)
	width()
	height() - 
	outerHeight()
	outerWidth()
*/

class Style
{
	public static function getComputedStyle(node:DOMNode)
	{
		var style:CSSStyleDeclaration = null;
		if (ElementManipulation.isElement(node))
		{
			style = Detox.window.getComputedStyle(cast node);
		}
		return style;
	}
	
	public static function css(node:DOMNode, prop:String)
	{
		return getComputedStyle(node).getPropertyValue(prop);
	}

	public static function setCSS(node:DOMNode, prop:String, val:String)
	{
		if (ElementManipulation.isElement(node))
		{
			var style:Dynamic = untyped node.style;
			Reflect.setField(style, prop, val);
		}
		return node;
	}

	public static function show(n:DOMNode) return setCSS(n, "display", "");
	public static function hide(n:DOMNode) return setCSS(n, "display", "none");

	public static function pos(node:DOMNode)
	{
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
		else 
		{
			return {
				top: 0,
				left: 0,
				width: 0,
				height: 0
			}
		}
	}
} 