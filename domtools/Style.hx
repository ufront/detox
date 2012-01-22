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
package domtools;
import domtools.Query;
import js.w3c.level3.Core;
import js.w3c.css.CSSOM;
using domtools.ElementManipulation;

class Style
{
	public static function getComputedStyle(node:Node)
	{
		var style:CSSStyleDeclaration = null;
		if (node.isElement())
		{
			style = Query.window.getComputedStyle(cast node).width;
		}
		return style;
	}

	
	public static function css(node:Node, property:String)
	{
		getComputedStyle(node).getPropertyValue("property");
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

class QueryStyle
{
	
}