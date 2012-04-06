/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools.collection;

import js.w3c.level3.Core;

class Traversing
{
	/** Return a new collection of all child nodes of the current collection. */
	static public function children(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		if (query != null)
		{
			for (node in query)
			{
				if (domtools.single.ElementManipulation.isElement(node))
				{
					// Add any child elements
					children.addNodeList(node.childNodes, elementsOnly);
				}
			}
		}
		return children;
	}

	static public function firstChildren(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		if (query != null)
		{
			for (node in query)
			{
				if (domtools.single.ElementManipulation.isElement(node))
				{
					// Add first child node that is an element
					var e = node.firstChild;
					while (elementsOnly == true && e != null && domtools.single.ElementManipulation.isElement(e) == false)
					{
						e = e.nextSibling;
					}
					if (e != null) children.add(e);
				}
			}
		}
		return children;
	}

	static public function lastChildren(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		if (query != null)
		{
			for (node in query)
			{
				if (domtools.single.ElementManipulation.isElement(node))
				{
					// Add first child node that is an element
					var e = node.lastChild;
					while (elementsOnly == true && e != null && domtools.single.ElementManipulation.isElement(e) == false)
					{
						e = e.previousSibling;
					}
					if (e != null) children.add(e);
				}
			}
		}
		return children;
	}

	/** Gets the direct parents of each element in the collection. */
	static public function parent(query:Query)
	{
		var parents = new Query();
		if (query != null)
		{
			for (node in query)
			{
				if (node.parentNode != null && node != domtools.Query.document)
					parents.add(node.parentNode);
			}
		}
		return parents;
	}

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function ancestors(query:Query):Query
	{
		// start with the direct parents
		var ancestorList = parent(query);
		
		// If there is at least one parent
		// Then recurse and add all ancestors of that parent
		if (ancestorList.length > 0)
		{
			ancestorList.addCollection(ancestors(ancestorList));
		}

		// Then pass the list back up the line...
		return ancestorList;
	}

	static public function next(query:Query, ?elementsOnly:Bool = true)
	{
		var siblings = new Query();
		if (query != null)
		{
			for (node in query)
			{
				// Get the next sibling
				var sibling = node.nextSibling;

				// If it's not null, but isn't an element, and we want an element,
				// keep going.
				while (sibling != null 
					&& sibling.nodeType != Node.ELEMENT_NODE
					&& elementsOnly )
				{
					sibling = sibling.nextSibling;
				}

				// if we found a match, add it to our group
				if (sibling != null) siblings.add(sibling);
			}
		}
		return siblings;
	}

	static public function prev(query:Query, ?elementsOnly:Bool = true)
	{
		var siblings = new Query();
		if (query != null)
		{
			for (node in query)
			{
				// get the previous sibling
				var sibling = node.previousSibling;

				// If it's not null, but isn't an element, and we want an element,
				// keep going.
				while (sibling != null  
					&& sibling.nodeType != Node.ELEMENT_NODE
					&& elementsOnly)
				{
					sibling = sibling.previousSibling;
				}

				// if we found a match, add it to our group
				if (sibling != null) siblings.add(sibling);
			}
		}
		return siblings;
	}

	static public function find(query:Query, selector:String)
	{
		var newQuery = new Query();
		if (query != null && selector != null && selector != "")
		{
			for (node in query)
			{
				if (domtools.single.ElementManipulation.isElement(node))
				{
					var element:Element = cast node;
					newQuery.addNodeList(element.querySelectorAll(selector));
				}
			}
		}
		return newQuery;
	}
}