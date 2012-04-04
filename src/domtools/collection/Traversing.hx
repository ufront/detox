package domtools.collection;

import js.w3c.level3.Core;

class Traversing
{
	/** Return a new collection of all child nodes of the current collection. */
	static public function children(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		for (node in query)
		{
			if (domtools.single.ElementManipulation.isElement(node))
			{
				// Add any child elements
				children.addCollection(node.childNodes, elementsOnly);
			}
		}
		return children;
	}

	static public function firstChildren(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
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
		return children;
	}

	static public function lastChildren(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
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
			if (domtools.single.ElementManipulation.isElement(node))
			{
				var element:Element = cast node;
				newQuery.addCollection(element.querySelectorAll(selector));
			}
		}
		return newQuery;
	}
}