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

class ElementManipulation
{
	/** Find the index of the node relevent to it's siblings.  First child of parent has an index of 0.  When operating on a collection, this returns the index of the first element. */
	public static function index(q:Nodes):Int 
	{
		return (q != null) ? dtx.single.ElementManipulation.index(q.getNode()) : -1;
	}

	/** Assume we're operating on the first element. */
	public static function attr(query:Nodes, attName:String):String
	{
		return (query != null && query.length > 0) ? dtx.single.ElementManipulation.attr(query.getNode(), attName) : "";
	}

	public static function setAttr(query:Nodes, attName:String, attValue:String):Nodes
	{
		if (query != null)
		{
			for (node in query)
			{
				dtx.single.ElementManipulation.setAttr(node, attName, attValue);
			}
		}
		return query;
	}

	public static function removeAttr(query:Nodes, attName:String):Nodes
	{
		if (query != null)
		{
			for (node in query)
			{
				dtx.single.ElementManipulation.removeAttr(node,attName);
			}
		}
		return query;
	}

	/** Checks if every element in the collection has the given class */
	public static function hasClass(query:Nodes, className:String):Bool
	{
		var result = false;

		if (query != null && query.length > 0)
		{
			// If there's at least one result, we'll begin with "true"
			// and loop around and see if it gets switched to "false"
			result = true;

			for (node in query)
			{
				if (dtx.single.ElementManipulation.hasClass(node, className) == false)
				{
					result = false;
					break;
				}
			}
		}

		return result;
	}

	public static function addClass(query:Nodes, className:String):Nodes
	{
		if (query != null)
		{
			for (node in query)
			{
				dtx.single.ElementManipulation.addClass(node,className);
			}
		}
		return query;
	}

	public static function removeClass(query:Nodes, className:String):Nodes
	{
		if (query != null)
		{
			for (node in query)
			{
				dtx.single.ElementManipulation.removeClass(node,className);
			}
		}
		return query;
	}

	public static function toggleClass(query:Nodes, className:String):Nodes
	{
		if (query != null)
		{
			for (node in query)
			{
				dtx.single.ElementManipulation.toggleClass(node,className);
			}
		}
		return query;
	}

	public static inline function tagName(query:Nodes):String
	{
		return (query != null && query.length > 0) ? dtx.single.ElementManipulation.tagName(query.getNode()) : "";
	}

	public static function val(query:Nodes):String
	{
		return (query != null && query.length > 0) ? dtx.single.ElementManipulation.val(query.getNode()) : "";
	}

	public static function setVal(query:Nodes, val:Dynamic)
	{
		var value = Std.string(val);
		if (query != null)
		{
			for (node in query)
			{
				dtx.single.ElementManipulation.setVal(node, value);
			}
		}
		return query;
	}
	
	public static function text(query:Nodes):String
	{
		var text = "";
		if (query != null)
		{
			for (node in query)
			{
				text = text + dtx.single.ElementManipulation.text(node);
			}
		}
		return text;
	}
	
	public static function setText(query:Nodes, text:String):Nodes
	{
		if (query != null)
		{
			for (node in query)
			{
				dtx.single.ElementManipulation.setText(node,text);
			}
		}
		return query;
	}

	public static function innerHTML(query:Nodes):String
	{
		var ret = "";
		if (query != null)
		{
			for (node in query)
			{
				ret += dtx.single.ElementManipulation.innerHTML(node);
			}
		}
		return ret;
	}

	public static function setInnerHTML(query:Nodes, html:String):Nodes
	{
		if (query != null)
		{
			for (node in query)
			{
				dtx.single.ElementManipulation.setInnerHTML(node,html);
			}
		}
		return query;
	}

	public static inline function html(collection:Nodes):String
	{
		var sb = new StringBuf();
		if (collection != null)
		{
			for (node in collection)
			{
				sb.add( dtx.single.ElementManipulation.html(node) );
			}
		}
		return sb.toString();
	}

}