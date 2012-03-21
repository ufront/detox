/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools;

/**
* new() - runs a new query, creates a new collection. Alternatively pass DOM Node
* slice
* not - removes elements (or selector) from set
* is("") - like filter, but returns Bool rather than new list if(element.is("li.menu"))
* has(selector) - does it have a certain children
* andSelf() - previous set of matched elements to the current set
* index(?selector) - 
* 
* All the rest provided through "using"
*
* Static methods:
* - create()
* - parse()
**/
import js.w3c.level3.Core;
import UserAgentContext;
import CommonJS;
import domtools.Tools;

class Query
{
	public var collection(default,null):Array<Node>;
	public var length(get_length,null):Int;
	public static var document(get_document,null):HTMLDocument;
	public static var window(get_window,null):Window;

	public function new(?selector:String = "", ?node:Node = null, ?collection:Iterable<Node>)
	{
		this.collection = new Array();

		if (node != null)
		{
			add(node);
		}
		else if (collection != null)
		{
			addCollection(collection);
		}
		else if (selector != "")
		{
			var nodeList = CommonJS.getAll(selector);
			
			// performance cost of this operation
			// 1000000 times = 6sec;
			// 10000 times = 0.06sec
			// 1000 times = 0.006sec
			// Incredibly inaccurate but we're not on a scale I'm too worried about.
			addNodeList(nodeList);
		}
			
	}

	public inline function iterator()
	{
		return collection.iterator();
	}

	public inline function getNode(?i:Int = 0)
	{
		return collection[i];
	}

	public inline function eq(?i:Int = 0)
	{
		return new Query(getNode(i));
	}

	public inline function first()
	{
		return eq(0);
	}

	public inline function last()
	{
		return eq(this.length - 1);
	}

	public inline function add(node:Node):Query
	{
		return { collection.push(node); this; }
	}

	public function addCollection(collection:Iterable<Node>):Query
	{
		for (node in collection)
		{
			this.collection.push(node);
		}
		return this;
	}

	public function addNodeList(nodeList:NodeList, ?elementsOnly = true):Query
	{
		for (i in 0...nodeList.length)
		{
			var node = nodeList.item(i);
			// Only add if we are allowing elements only or if it is in fact an element
			if (elementsOnly == false || ElementManipulation.isElement(node))
				add(node);
		}
		return this;
	}

	public inline function removeFromCollection(node:Node):Query
	{
		return { collection.remove(node); this; }
	}

	public inline function each(f : Node -> Void):Query
	{
		return { Lambda.iter(collection, f); this; } 
	}

	/** Use a function to return a filtered list. In future might allow a selector as well. */
	public inline function filter(fn:Node->Bool)
	{
		return new Query(Lambda.filter(collection, fn));
	}

	public function clone():Query
	{
		var q = new Query();
		for (node in this)
		{
			q.add(node.cloneNode(true));
		}
		return q;
	}

	inline function get_length():Int
	{
		return collection.length;
	}

	public static inline function create(name:String):Element
	{
		return untyped __js__("document").createElement(name);
	}

	/*public static inline function create(str:String):Query
	{
		return new Query(Query.createElement(str));
	}*/


	static inline function get_window():Window
	{
		return untyped __js__("window");
	}

	static inline function get_document():HTMLDocument
	{
		return untyped __js__("document");
	}
}

typedef Node = js.w3c.level3.Core.Node;
typedef Event = js.w3c.level3.Events.Event;

import domtools.Tools;