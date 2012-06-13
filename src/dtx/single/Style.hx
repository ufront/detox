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

import js.w3c.level3.Core;
import js.w3c.css.CSSOM;

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
			//style = DOMCollection.window.getComputedStyle(cast node).width;
		}
		return style;
	}

	
	public static function css(node:DOMNode, property:String)
	{
		getComputedStyle(node).getPropertyValue("property");
	}

	public static function setCSS(node:DOMNode, property:String, value:String)
	{
		if (ElementManipulation.isElement(node))
		{
			var style:Dynamic = untyped node.style;
			Reflect.setField(style, property, value);
		}
	}

	/** Get the current computed width for the first element in the set of matched elements, including padding but not border. */
	public static function innerWidth(node:DOMNode):Int
	{
		var style = getComputedStyle(cast node);
		if (style != null)
		{
			
		}
		return 0;
	}
} 