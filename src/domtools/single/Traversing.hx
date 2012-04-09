/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools.single;

import js.w3c.level3.Core;
/*
	parentsUntil(selector)
	nextAll
	nextUntil
	prevAll
	prevUntil
	siblings
	closest() - 
*/



/** When returning a Null<Node>, it might be worth creating a static NullNode that won't generate errors (so we can chain easily and carelessly) but also not affect the DOM.   For now I'll leave it null.  */
class Traversing
{
	/** Return a collection of all child nodes of the current node. */
	static public function children(node:Node, ?elementsOnly = true)
	{
		var children = new Query();
		if (node != null && ElementManipulation.isElement(node))
		{
			// Add any child elements
			children.addNodeList(node.childNodes, elementsOnly);
		}
		return children;
	}

	static public function firstChildren(node:Node, ?elementsOnly = true)
	{
		var firstChild:Node = null;
		if (node != null && ElementManipulation.isElement(node))
		{
			// Add first child node that is an element
			var e = node.firstChild;
			while (elementsOnly == true && e != null && ElementManipulation.isElement(e) == false)
			{
				e = e.nextSibling;
			}
			if (e != null) firstChild = e;
		}
		return firstChild;
	}

	static public function lastChildren(node:Node, ?elementsOnly = true)
	{
		var lastChild:Node = null;
		if (node != null && ElementManipulation.isElement(node))
		{
			// Add first child node that is an element
			var e = node.lastChild;
			while (elementsOnly == true && e != null && ElementManipulation.isElement(e) == false)
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
		return (node != null && node.parentNode != null && node != domtools.Query.document) ? node.parentNode : null;
	}

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function ancestors(node:Node):Query
	{
		// start with the direct parents
		var ancestorsList:Query = new Query();
		var parent = parent(node);
		ancestorsList.add(parent);

		// if there were any parents on this round, then add the parents of the parents, recursively
		if (ancestorsList.length > 0)
		{
			var ancestorsOfThisParent = ancestors(parent);
			ancestorsList.addCollection(ancestorsOfThisParent);
		}

		return ancestorsList;
	}

	static public function next(node:Node, ?elementsOnly:Bool = true)
	{
		// Get the next sibling
		var sibling = (node != null) ? node.nextSibling : null;

		// While this "nextSibling" actually still exists
		// and if we only want elements
		// but this "nextSibling" isn't an element 
		while (sibling != null 
			&& elementsOnly
			&& sibling.nodeType != Node.ELEMENT_NODE)
		{
			// find the next sibling down the line.
			// If there is none, this will return null, which is okay.
			sibling = sibling.nextSibling;
		}

		// This will either be null or the next valid sibling
		return sibling;
	}

	static public function prev(node:Node, ?elementsOnly:Bool = true)
	{
		// Get the next sibling
		var sibling = (node != null) ? node.previousSibling : null;

		// While this "previousSibling" actually still exists
		// and if we only want elements
		// but this "previousSibling" isn't an element 
		while (sibling != null 
			&& elementsOnly
			&& sibling.nodeType != Node.ELEMENT_NODE)
		{
			// find the prev sibling up the line.
			// If there is none, this will return null, which is okay.
			sibling = sibling.previousSibling;
		}

		// This will either be null or the previous valid sibling
		return sibling;
	}

	static public function find(node:Node, selector:String)
	{
		var newQuery = new Query();
		if (node != null && ElementManipulation.isElement(node))
		{
			var element:Element = cast node;
			newQuery.addNodeList(element.querySelectorAll(selector));
		}
		return newQuery;
	}
}

