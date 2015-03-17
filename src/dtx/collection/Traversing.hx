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

import dtx.DOMNode;

/**
	This class provides static helper methods to traverse the DOM starting from a given `dtx.DOMCollection`.

	In contrast to `dtx.single.Traversing`, this will operate on each of the current nodes.
	For example when calling `next`, if you have 3 nodes in your collection, it will attempt to find the next sibling for all 3 nodes.
	This would result in you having up to 3 nodes in the returned collection, depending on how many of the nodes in the current collection had a `nextSibling`.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then operate on a DOMCollection as if they were methods on the DOMCollection object itself.
	All methods will return a DOMCollection, even if the method seems to imply there is only a single result, such as `parent`.
	This is because there may be a result for multiple nodes in the collection, and all results will be combined into the returned collection.
	Each method is null-safe, and will silently return an empty collection in the case of an error.
**/
class Traversing
{
	/**
		Return all the child elements or nodes for each node in the current collection.

		@param collection The parent DOMCollection.  If null or empty an empty collection will be returned.  Any nodes in the collection which are not elements will be ignored.
		@param elementsOnly Should we retrieve only elements (`true`, default) or should we include other node types such as text nodes and comments (`false`).
		@return A DOMCollection containing all the children of each node in the collection.
	**/
	static public function children(collection:DOMCollection, ?elementsOnly:Bool = true):DOMCollection
	{
		var children = new DOMCollection();
		if (collection != null)
		{
			for (node in collection)
			{
				if (dtx.single.ElementManipulation.isElement(node))
				{
					// Add any child elements
					children.addCollection(node.childNodes, elementsOnly);
				}
			}
		}
		return children;
	}

	/**
		Return all the "first child" elements or nodes for each node in the current collection.

		@param collection The parent DOMCollection.  If null or empty an empty collection will be returned.  Any nodes in the collection which are not elements will be ignored.
		@param elementsOnly Should we get for the first *elements* (`true`, default) or should we get for first nodes, regardless of type (`false`).
		@return A DOMCollection containing all the "first" children of each node in the collection.  The length of the returned collection will be between 0 and the length of the original collection, inclusive, depending on how many of the original nodes had a child.
	**/
	static public function firstChildren(collection:DOMCollection, ?elementsOnly:Bool = true):DOMCollection
	{
		var children = new DOMCollection();
		if (collection != null)
		{
			for (node in collection)
			{
				if (dtx.single.ElementManipulation.isElement(node))
				{
					// Add first child node that is an element
					var e = node.firstChild;
					while (elementsOnly == true && e != null && dtx.single.ElementManipulation.isElement(cast e) == false)
					{
						e = e.nextSibling;
					}
					if (e != null) children.add(cast e);
				}
			}
		}
		return children;
	}

	/**
		Return all the "last child" elements or nodes for each node in the current collection.

		@param collection The parent DOMCollection.  If null or empty an empty collection will be returned.  Any nodes in the collection which are not elements will be ignored.
		@param elementsOnly Should we get the last *elements* (`true`, default) or should we get the last nodes, regardless of type (`false`).
		@return A DOMCollection containing all the "last" children of each node in the collection.  The length of the returned collection will be between 0 and the length of the original collection, inclusive, depending on how many of the original nodes had a child.
	**/
	static public function lastChildren(collection:DOMCollection, ?elementsOnly:Bool = true):DOMCollection
	{
		var children = new DOMCollection();
		if (collection != null)
		{
			for (node in collection)
			{
				if (dtx.single.ElementManipulation.isElement(node))
				{
					// Add first child node that is an element
					var e = node.lastChild;
					while (elementsOnly == true && e != null && dtx.single.ElementManipulation.isElement(e) == false)
					{
						e = e.previousSibling;
					}
					if (e != null) children.add(e);
				}
			}
		}
		return children;
	}

	/**
		Return all the "parent" elements for each node in the current collection.

		If a parent is the current `Detox.document`, it will not be included in the returned collection - only elements inside the tree are counted as a parent.

		@param node The current DOMCollection (children).  If null or empty, an empty collection will be returned.
		@return A DOMCollection containing all the "parent" elements for each node in the collection.  The length of the returned collection will be between 0 and the length of the original collection, inclusive, depending on how many of the original nodes had a parent.
	**/
	static public function parent(collection:DOMCollection):DOMCollection
	{
		var parents = new DOMCollection();
		if (collection != null)
		{
			for (node in collection)
			{
				if (node.parentNode != null && node != Detox.document)
					parents.add(node.parentNode);
			}
		}
		return parents;
	}

	/**
		This is an alias for `parent`.

		Other than reflecting the fact that multiple parents may be returned, this provides consistency when switching between a `DOMNode` and a `DOMCollection`, as a `DOMNode` on platforms other than JS must use the `parents()` method to avoid naming conflicts.
	**/
	static inline public function parents(collection:DOMCollection):DOMCollection
	{
		return parent(collection);
	}

	/**
		Retrieve all ancestors (parent nodes, grandparent nodes etc) of each node in the current collection.

		This will include all parents up to, but not including, the current `Detox.document`.

		If an ancestor is an ancestor for multiple nodes in the current collection, it will only be included once.

		@param collection The current collection (children).  If null or empty, then the method will return an empty collection.
		@return A DOMCollection containing all of the ancestors.
	**/
	static public function ancestors(collection:DOMCollection):DOMCollection
	{
		var ancestorList:DOMCollection = new DOMCollection();

		if (collection != null)
		{
			for (node in collection)
			{
				var p = dtx.single.Traversing.parent(node);
				while (p != null)
				{
					ancestorList.add(p);
					p = dtx.single.Traversing.parent(p);
				}
			}
		}

		return ancestorList;
	}

	/**
		Fetch all the descendants of each node in the current collection.

		This will include the children of each node, and their descendants recursively.

		@param collection The current collection (parents).  If null or empty the result will be an empty collection.
		@elementsOnly Should the collection of descendants include only elements (`true`, default) or should it include all nodes, including text nodes and comments (`false`).
		@return A collection of all descendant elements or nodes.
	**/
	static public function descendants(collection:DOMCollection, ?elementsOnly:Bool = true):DOMCollection
	{
		var descendantList = new dtx.DOMCollection();

		if (collection != null)
		{
			for (node in collection)
			{
				var l = dtx.single.Traversing.descendants(node, elementsOnly);
				descendantList.addCollection(l);
			}
		}

		return descendantList;
	}

	/**
		Return all the "next sibling" elements or nodes for each node in the current collection.

		@param collection The current DOMCollection.  If null or empty an empty collection will be returned.
		@param elementsOnly Should we get the next *elements* (`true`, default) or should we get the next nodes, regardless of type (`false`).
		@return A DOMCollection containing all the "next siblings" of each node in the collection.  The length of the returned collection will be between 0 and the length of the original collection, inclusive, depending on how many of the original nodes had a next sibling.
	**/
	static public function next(collection:DOMCollection, ?elementsOnly:Bool = true):DOMCollection
	{
		var siblings = new DOMCollection();
		if (collection != null)
		{
			for (node in collection)
			{
				// Get the next sibling
				var sibling = node.nextSibling;

				// If it's not null, but isn't an element, and we want an element,
				// keep going.
				while (sibling != null
					&& sibling.nodeType != dtx.DOMType.ELEMENT_NODE
					&& elementsOnly )
				{
					sibling = sibling.nextSibling;
				}

				// if we found a match, add it to our group
				if (sibling != null) siblings.add(cast sibling);
			}
		}
		return siblings;
	}

	/**
		Return all the "previous sibling" elements or nodes for each node in the current collection.

		@param collection The current DOMCollection.  If null or empty an empty collection will be returned.
		@param elementsOnly Should we get the previous *elements* (`true`, default) or should we get the previous nodes, regardless of type (`false`).
		@return A DOMCollection containing all the "previous siblings" of each node in the collection.  The length of the returned collection will be between 0 and the length of the original collection, inclusive, depending on how many of the original nodes had a next sibling.
	**/
	static public function prev(collection:DOMCollection, ?elementsOnly:Bool = true):DOMCollection
	{
		var siblings = new DOMCollection();
		if (collection != null)
		{
			for (node in collection)
			{
				// get the previous sibling
				var sibling = node.previousSibling;

				// If it's not null, but isn't an element, and we want an element,
				// keep going.
				while (sibling != null
					&& sibling.nodeType != dtx.DOMType.ELEMENT_NODE
					&& elementsOnly)
				{
					sibling = sibling.previousSibling;
				}

				// if we found a match, add it to our group
				if (sibling != null) siblings.add(cast sibling);
			}
		}
		return siblings;
	}

	/**
		Find the descendants from each node in the current collection which match a particular selector.

		On Javascript, this will attempt to use `elm.querySelectorAll` if it is available.
		If it is not available, a fallback will be attempted to `Sizzle`, `jQuery` or `$`.

		On platforms other than Javascript, `selecthxml.SelectDom.runtimeSelect` will be used.

		This does not include the nodes from the current collection in the search, only child / descendant nodes will be matched.

		@param node The collection of parent nodes to search.  If it is null or empty, an empty collection will be returned.  Nodes in the collection which are not elements or documents will be ignored.
		@param selector The CSS selector to use when searching for a child.
		@return The collection of matching elements.  Will be empty if no match was found or the parent collection was null, empty or had no children.
	**/
	static public function find(collection:DOMCollection, selector:String):DOMCollection
	{
		var newDOMCollection = new DOMCollection();
		if (collection != null && selector != null && selector != "")
		{
			for (node in collection)
			{
				if (dtx.single.ElementManipulation.isElement(node) || dtx.single.ElementManipulation.isDocument(node))
				{
					#if (js && !macro)
						var element:DOMElement = cast node;
						if ( untyped __js__('element.querySelectorAll') )
						{
							var results = element.querySelectorAll(selector);
							newDOMCollection.addNodeList(results);
						}
						else
						{
							var engine:String->DOMNode->Array<DOMNode> = untyped __js__("
								(('undefined' != typeof Sizzle && Sizzle) ||
								(('undefined' != typeof jQuery) && jQuery.find) ||
								(('undefined' != typeof $) && $.find))
							");
							var results = engine(selector, node);
							newDOMCollection.addCollection(results);
						}
					#else
						// This next line is a workaround to a bug in selecthxml
						// See http://code.google.com/p/selecthxml/issues/detail?id=2
						// And http://code.google.com/p/selecthxml/issues/detail?id=3
						var results = selecthxml.SelectDom.runtimeSelect(node, selector);

						// SelectHxml also includes our original node in the search.
						// We should match the querySelectorAll() functionality from JS, which
						// only searches descendant nodes.  Therefore, remove the current node
						// if it was returned as a match.
						results.remove(node);

						newDOMCollection.addCollection(results);
					#end
				}
			}
		}
		return newDOMCollection;
	}
}
