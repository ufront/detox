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
		return (query.length > 0) ? domtools.single.ElementManipulation.attr(query.getNode(), attName) : "";
	}

	public static function setAttr(query:Query, attName:String, attValue:String):Query
	{
		for (node in query)
		{
			domtools.single.ElementManipulation.setAttr(node, attName, attValue);
		}
		return query;
	}

	public static function removeAttr(query:Query, attName:String):Query
	{
		for (node in query)
		{
			domtools.single.ElementManipulation.removeAttr(node,attName);
		}
		return query;
	}

	/** Checks if the first element in the collection has the given class */
	public static function hasClass(query:Query, className:String):Bool
	{
		return (query.length > 0) ? domtools.single.ElementManipulation.hasClass(query.getNode(), className) : false;
	}

	public static function addClass(query:Query, className:String):Query
	{
		for (node in query)
		{
			domtools.single.ElementManipulation.addClass(node,className);
		}
		return query;
	}

	public static function removeClass(query:Query, className:String):Query
	{
		for (node in query)
		{
			domtools.single.ElementManipulation.removeClass(node,className);
		}
		return query;
	}

	public static function toggleClass(query:Query, className:String):Query
	{
		for (node in query)
		{
			domtools.single.ElementManipulation.toggleClass(node,className);
		}
		return query;
	}

	public static function tagName(query:Query):String
	{
		return (query.length > 0) ? query.getNode().nodeName.toLowerCase() : "";
	}

	public static function tagNames(query:Query):Array<String>
	{
		var names = new Array<String>();
		for (node in query)
		{
			names.push(node.nodeName.toLowerCase());
		}
		return names;
	}

	public static function val(query:Query):String
	{
		return (query.length > 0) ? domtools.single.ElementManipulation.val(query.getNode()) : "";
	}

	public static function setVal(query:Query, val:Dynamic)
	{
		var value = Std.string(val);
		for (node in query)
		{
			domtools.single.ElementManipulation.setVal(node, value);
		}
		return query;
	}
	
	public static function text(query:Query):String
	{
		var text = "";
		for (node in query)
		{
			text = text + domtools.single.ElementManipulation.text(node);
		}
		return text;
	}
	
	public static function setText(query:Query, text:String):Query
	{
		for (node in query)
		{
			domtools.single.ElementManipulation.setText(node,text);
		}
		return query;
	}

	public static function innerHTML(query:Query):String
	{
		var ret = "";
		for (node in query)
		{
			ret += domtools.single.ElementManipulation.innerHTML(node);
		}
		return ret;
	}

	public static function setInnerHTML(query:Query, html:String):Query
	{
		for (node in query)
		{
			domtools.single.ElementManipulation.setInnerHTML(node,html);
		}
		return query;
	}

	public static function clone(query:Query, ?deep:Bool = true):Query
	{
		var newQuery = new Query();
		for (node in query)
		{
			newQuery.add(domtools.single.ElementManipulation.clone(node));
		}
		return newQuery;
	}

}