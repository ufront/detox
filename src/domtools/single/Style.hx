/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools.single;

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
	public static function getComputedStyle(node:Node)
	{
		var style:CSSStyleDeclaration = null;
		if (ElementManipulation.isElement(node))
		{
			//style = Query.window.getComputedStyle(cast node).width;
		}
		return style;
	}

	
	public static function css(node:Node, property:String)
	{
		getComputedStyle(node).getPropertyValue("property");
	}

	public static function setCSS(node:Node, property:String, value:String)
	{
		if (ElementManipulation.isElement(node))
		{
			var style:Dynamic = untyped node.style;
			Reflect.setField(style, property, value);
		}
	}

	/** Get the current computed width for the first element in the set of matched elements, including padding but not border. */
	public static function innerWidth(node:Node):Int
	{
		var style = getComputedStyle(cast node);
		if (style != null)
		{
			
		}
		return 0;
	}
} 