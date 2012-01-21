/*
	parentsUntil(selector)
	nextAll
	nextUntil
	prevAll
	prevUntil
	siblings
	closest() - 
*/
package domtools;

import js.w3c.level3.Core;
import CommonJS;
using domtools.ElementManipulation;
import domtools.Query;

/** When returning a Null<Node>, it might be worth creating a static NullNode that won't generate errors (so we can chain easily and carelessly) but also not affect the DOM.   For now I'll leave it null.  */
class Traversing
{
	/** Return a collection of all child nodes of the current node. */
	static public function children(node:Node, ?elementsOnly = true)
	{
		var children = new Query();
		if (node.isElement())
		{
			// Add any child elements
			children.addNodeList(node.childNodes, elementsOnly);
		}
		return children;
	}

	static public function firstChild(node:Node, ?elementsOnly = true)
	{
		var firstChild:Node = null;
		if (node.isElement())
		{
			// Add first child node that is an element
			var e = node.firstChild;
			while (elementsOnly == true && e != null && e.isElement() == false)
			{
				e = e.nextSibling;
			}
			if (e != null) firstChild = e;
		}
		return firstChild;
	}

	static public function lastChild(node:Node, ?elementsOnly = true)
	{
		var lastChild:Node = null;
		if (node.isElement())
		{
			// Add first child node that is an element
			var e = node.lastChild;
			while (elementsOnly == true && e != null && e.isElement() == false)
			{
				e = e.previousSibling;
			}
			if (e != null) lastChild = e;
		}
		return lastChild;
	}

	/** Gets the direct parents of each element in the collection. */
	static public function parent(node:Node)
	{
		return (node.parentNode != null) ? node.parentNode : null;
	}

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function ancestors(node:Node)
	{
		// start with the direct parents
		var ancestors = new Query();
		ancestors.add(parent(node));

		// if there were any parents on this round, then add the parents of the parents, recursively
		if (ancestors.length > 0)
		{
			ancestors.addCollection(QueryTraversing.parent(ancestors));
		}

		return ancestors;
	}

	static public function next(node:Node)
	{
		return (node.nextSibling != null) ? node.nextSibling : null;
	}

	static public function prev(node:Node)
	{
		return (node.previousSibling != null) ? node.previousSibling : null;
	}

	static public function find(node:Node, selector:String)
	{
		var newQuery = new Query();
		if (node.isElement())
		{
			var element:Element = cast node;
			newQuery.addNodeList(element.querySelectorAll(selector));
		}
		return newQuery;
	}
}

class QueryTraversing
{
	/** Return a new collection of all child nodes of the current collection. */
	static public function children(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		for (node in query)
		{
			if (node.isElement())
			{
				// Add any child elements
				children.addNodeList(node.childNodes, elementsOnly);
			}
		}
		return children;
	}

	static public function firstChild(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		for (node in query)
		{
			if (node.isElement())
			{
				// Add first child node that is an element
				var e = node.firstChild;
				while (elementsOnly == true && e != null && e.isElement() == false)
				{
					e = e.nextSibling;
				}
				if (e != null) children.add(e);
			}
		}
		return children;
	}

	static public function lastChild(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		for (node in query)
		{
			if (node.isElement())
			{
				// Add first child node that is an element
				var e = node.lastChild;
				while (elementsOnly == true && e != null && e.isElement() == false)
				{
					e = e.previousSibling;
				}
				if (e != null) children.add(e);
			}
		}
		return children;
	}

	/** Gets the direct parents of each element in the collection. */
	static public function parent(query:Query)
	{
		var parents = new Query();
		for (node in query)
		{
			if (node.parentNode != null)
				parents.add(node.parentNode);
		}
		return parents;
	}

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function ancestors(query:Query)
	{
		// start with the direct parents
		var ancestors = parent(query);

		// then add the parents of the parents, recursively
		if (ancestors.length > 0)
		{
			ancestors.addCollection(parent(ancestors));
		}

		return ancestors;
	}

	static public function next(query:Query)
	{
		var siblings = new Query();
		for (node in query)
		{
			var sibling = node.nextSibling;
			if (sibling != null) siblings.add(sibling);
		}
		return siblings;
	}

	static public function prev(query:Query)
	{
		var siblings = new Query();
		for (node in query)
		{
			var sibling = node.previousSibling;
			if (sibling != null) siblings.add(sibling);
		}
		return siblings;
	}

	static public function find(query:Query, selector:String)
	{
		var newQuery = new Query();
		for (node in query)
		{
			if (node.isElement())
			{
				var element:Element = cast node;
				newQuery.addNodeList(element.querySelectorAll(selector));
			}
		}
		return newQuery;
	}
}
