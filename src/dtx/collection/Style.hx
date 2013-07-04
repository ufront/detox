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

class Style
{
	/** Return the style object for the first node in the collection */
	public static function getComputedStyle(c:Nodes)
	{
		return dtx.single.Style.getComputedStyle(c.getNode(0));
	}
	
	/** Return the computed style value for the given style property (on the first node in the collection) */
	public static function css(c:Nodes, property:String)
	{
		return dtx.single.Style.css(c.getNode(0), property);
	}

	/** Set a CSS property for every node in the collection */
	public static function setCSS(c:Nodes, prop:String, val:String)
	{
		for (node in c)
		{
			dtx.single.Style.setCSS(node, prop, val);
		}
		return c;
	}

	public static function show(c:Nodes) return setCSS(c, "display", "");
	public static function hide(c:Nodes) return setCSS(c, "display", "none");

	/** Return the position info for the first node in the collection */
	public static function pos(c:Nodes)
	{
		return dtx.single.Style.pos(c.getNode(0));
	}
}