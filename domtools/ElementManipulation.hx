/*
JQuery has these classes, let's copy:

	//later? outerHTML()
	//later? setOuterHTML()
	clone() - create a deep copy of this set of matched elements
*/ 
package domtools;

import js.w3c.level3.Core;
import CommonJS; 

class ElementManipulation
{
	static var NodeTypeElement = 1;
	static var NodeTypeAttribute = 2;
	static var NodeTypeText = 3;

	public static function isElement(node:Node):Bool
	{
		return node.nodeType == NodeTypeElement;
	}

	public static function attr(elm:Node, attName:String):String
	{
		var ret = "";
		if (isElement(elm))
		{
			var element:Element = cast elm;
			ret = element.getAttribute(attName);
			if (ret == null) ret = "";
		}
		return ret;
	}

	public static function setAttr(elm:Node, attName:String, attValue:String):Node
	{
		if (elm.nodeType == NodeTypeElement)
		{
			var element:Element = cast elm;
			element.setAttribute(attName, attValue);
		}
		return elm;
	}

	public static function removeAttr(elm:Node, attName:String):Node
	{
		if (elm.nodeType == NodeTypeElement)
		{
			var element:Element = cast elm;
			element.removeAttribute(attName);
		}
		return elm;
	}

	public static function hasClass(elm:Node, className:String):Bool
	{
		return ((" " + attr(elm, "class") + " ").indexOf(" " + className + " ") > -1);
	}

	public static function addClass(elm:Node, className:String):Node
	{
		if (hasClass(elm, className) == false)
		{
			var oldClassName = attr(elm, "class");
			var newClassName =  (oldClassName == "") ? className : oldClassName + " " + className;
			setAttr(elm, "class", newClassName);
		}
		
		return elm;
	}

	public static function removeClass(elm:Node, className:String):Node
	{
		// Get the current list of classes
		var classes = attr(elm, "class").split(" ");

		// Remove the current one, re-assemble as a string
		classes.remove(className);
		var newClassValue = classes.join(" ");

		setAttr(elm, "class", newClassValue);
		
		return elm;
	}

	public static function toggleClass(elm:Node, className:String):Node
	{
		if (hasClass(elm, className))
		{
			removeClass(elm,className);
		}
		else 
		{
			addClass(elm,className);
		}
		return elm;
	}

	public static inline function tagName(elm:Node):String
	{
		return elm.nodeName.toLowerCase();
	}

	public static inline function val(elm:Node):String
	{
		return attr(elm,"value");
	}
	
	public static inline function text(elm:Node):String
	{
		return elm.textContent;
	}
	
	public static inline function setText(elm:Node, text:String):Node
	{
		return { elm.textContent = text; elm; };
	}

	public static function innerHTML(elm:Node):String
	{
		var ret = "";
		switch (elm.nodeType)
		{
			case NodeTypeElement:
				var element:Element = cast elm;
				ret = element.innerHTML;
			default:
				ret = elm.textContent;
		}
		return ret;
	}

	public static function setInnerHTML(elm:Node, html:String):Node
	{
		switch (elm.nodeType)
		{
			case NodeTypeElement:
				var element:Element = cast elm;
				element.innerHTML = html;
			default:
				elm.textContent = html;
		}
		return elm;
	}

	public static inline function clone(elm:Node, ?deep:Bool = true):Node
	{
		return elm.cloneNode(deep);
	}

}

class QueryElementManipulation
{
	/** Assume we're operating on the first element. */
	public static function attr(query:Query, attName:String):String
	{
		return (query.length > 0) ? ElementManipulation.attr(query.getNode(), attName) : "";
	}

	public static function setAttr(query:Query, attName:String, attValue:String):Query
	{
		for (node in query)
		{
			ElementManipulation.setAttr(node, attName, attValue);
		}
		return query;
	}

	public static function removeAttr(query:Query, attName:String):Query
	{
		for (node in query)
		{
			ElementManipulation.removeAttr(node,attName);
		}
		return query;
	}

	/** Checks if the first element in the collection has the given class */
	public static function hasClass(query:Query, className:String):Bool
	{
		return (query.length > 0) ? ElementManipulation.hasClass(query.getNode(), className) : false;
	}

	public static function addClass(query:Query, className:String):Query
	{
		for (node in query)
		{
			ElementManipulation.addClass(node,className);
		}
		return query;
	}

	public static function removeClass(query:Query, className:String):Query
	{
		for (node in query)
		{
			ElementManipulation.removeClass(node,className);
		}
		return query;
	}

	public static function toggleClass(query:Query, className:String):Query
	{
		for (node in query)
		{
			ElementManipulation.toggleClass(node,className);
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
		return (query.length > 0) ? ElementManipulation.val(query.getNode()) : "";
	}
	
	public static function text(query:Query):String
	{
		var text = "";
		for (node in query)
		{
			text = text + ElementManipulation.text(node);
		}
		return text;
	}
	
	public static function setText(query:Query, text:String):Query
	{
		for (node in query)
		{
			ElementManipulation.setText(node,text);
		}
		return query;
	}

	public static function innerHTML(query:Query):String
	{
		var ret = "";
		for (node in query)
		{
			ret += ElementManipulation.innerHTML(node);
		}
		return ret;
	}

	public static function setInnerHTML(query:Query, html:String):Query
	{
		for (node in query)
		{
			ElementManipulation.setInnerHTML(node,html);
		}
		return query;
	}

	public static function clone(query:Query, ?deep:Bool = true):Query
	{
		var newQuery = new Query();
		for (node in query)
		{
			newQuery.add(ElementManipulation.clone(node));
		}
		return newQuery;
	}

}

