/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools.collection;

class ElementManipulation
{
	/** Assume we're operating on the first element. */
	public static function attr(query:Query, attName:String):String
	{
		return (query != null && query.length > 0) ? domtools.single.ElementManipulation.attr(query.getNode(), attName) : "";
	}

	public static function setAttr(query:Query, attName:String, attValue:String):Query
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.setAttr(node, attName, attValue);
			}
		}
		return query;
	}

	public static function removeAttr(query:Query, attName:String):Query
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.removeAttr(node,attName);
			}
		}
		return query;
	}

	/** Checks if every element in the collection has the given class */
	public static function hasClass(query:Query, className:String):Bool
	{
		var result = false;

		if (query != null && query.length > 0)
		{
			// If there's at least one result, we'll begin with "true"
			// and loop around and see if it gets switched to "false"
			result = true;

			for (node in query)
			{
				if (domtools.single.ElementManipulation.hasClass(node, className) == false)
				{
					result = false;
					break;
				}
			}
		}

		return result;
	}

	public static function addClass(query:Query, className:String):Query
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.addClass(node,className);
			}
		}
		return query;
	}

	public static function removeClass(query:Query, className:String):Query
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.removeClass(node,className);
			}
		}
		return query;
	}

	public static function toggleClass(query:Query, className:String):Query
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.toggleClass(node,className);
			}
		}
		return query;
	}

	public static inline function tagName(query:Query):String
	{
		return (query != null && query.length > 0) ? domtools.single.ElementManipulation.tagName(query.getNode()) : "";
	}

	public static function val(query:Query):String
	{
		return (query != null && query.length > 0) ? domtools.single.ElementManipulation.val(query.getNode()) : "";
	}

	public static function setVal(query:Query, val:Dynamic)
	{
		var value = Std.string(val);
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.setVal(node, value);
			}
		}
		return query;
	}
	
	public static function text(query:Query):String
	{
		var text = "";
		if (query != null)
		{
			for (node in query)
			{
				text = text + domtools.single.ElementManipulation.text(node);
			}
		}
		return text;
	}
	
	public static function setText(query:Query, text:String):Query
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.setText(node,text);
			}
		}
		return query;
	}

	public static function innerHTML(query:Query):String
	{
		var ret = "";
		if (query != null)
		{
			for (node in query)
			{
				ret += domtools.single.ElementManipulation.innerHTML(node);
			}
		}
		return ret;
	}

	public static function setInnerHTML(query:Query, html:String):Query
	{
		if (query != null)
		{
			for (node in query)
			{
				domtools.single.ElementManipulation.setInnerHTML(node,html);
			}
		}
		return query;
	}

}