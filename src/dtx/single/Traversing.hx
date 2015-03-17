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

package dtx.single;

import dtx.DOMNode;

/**
	This class provides static helper methods to traverse the DOM starting from a given `dtx.DOMNode`.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then operate on a DOMNode as if they were methods on the DOMNode object itself.
	If a method expects to return a single node, either a `DOMNode` or `null` will be returned.
	If a method expects to return multiple nodes, a `DOMCollection` will always be returned, even if it is empty.
	Each method is null-safe, and will silently return null or an empty collection in the case of an error.
**/
class Traversing
{
	static inline function unsafeGetChildren( elm:DOMNode, elementsOnly:Bool = true):DOMCollection
	{
		return new DOMCollection().addCollection(elm.childNodes, elementsOnly);
	}

	/**
		Return all the child elements or nodes for the current node.

		@param node The parent DOMNode.  If null or not an element an empty collection will be returned.
		@param elementsOnly Should we retrieve only elements (`true`, default) or should we include other node types such as text nodes and comments (`false`).
		@return A DOMCollection containing the children, if any were able to be found.  Otherwise the DOMCollection will be empty.
	**/
	static public function children(node:DOMNode, ?elementsOnly:Bool = true):DOMCollection
	{
		if (node != null && ElementManipulation.isElement(node))
		{
			return unsafeGetChildren( node, elementsOnly );
		}
		else return new DOMCollection();
	}

	/**
		Return the first child for the current node.

		@param node The parent node.  If null or not an element the result will be `null`.
		@param elementsOnly Should we retrieve the first *element* (`true`, default) or should we retrieve the first *node*, regardless of node type (`false`).
		@return The first child or element.  Null if no child node or element was found.

		Trivia: the reason this is `firstChildren` instead of `firstChild` is because the `firstChild` name is already taken on the underlying `Xml` or `js.html.Node` objects, so static extension will not work.
		Also, the equivalent method that runs on a collection will return all of the first children for each node in the collection, and so the plural name is appropriate.
		In future if we have an abstract implementation of `DOMNode` we will be able to rename this and avoid collision with the native `firstChild` field or method.
	**/
	static public function firstChildren(node:DOMNode, ?elementsOnly:Bool = true):Null<DOMNode>
	{
		var firstChild:DOMNode = null;
		if (node != null && ElementManipulation.isElement(node))
		{
			// Add first child node that is an element
			var e = node.firstChild;
			while (elementsOnly == true && e != null && ElementManipulation.isElement(cast e) == false)
			{
				e = e.nextSibling;
			}
			if (e != null) firstChild = e;
		}
		return firstChild;
	}

	/**
		Return the last child for the current node.

		@param node The parent node.  If null or not an element the result will be `null`.
		@param elementsOnly Should we retrieve the last *element* (`true`, default) or should we retrieve the last *node*, regardless of node type (`false`).
		@return The last child or element.  Null if no child node or element was found.

		Trivia: the reason this is `lastChildren` instead of `lastChild` is because the `lastChild` name is already taken on the underlying `Xml` or `js.html.Node` objects, so static extension will not work.
		Also, the equivalent method that runs on a collection will return all of the last children for each node in the collection, and so the plural name is appropriate.
		In future if we have an abstract implementation of `DOMNode` we will be able to rename this and avoid collision with the native `lastChild` field or method.
	**/
	static public function lastChildren(node:DOMNode, ?elementsOnly:Bool = true):Null<DOMNode>
	{
		var lastChild:DOMNode = null;
		if (node != null && ElementManipulation.isElement(node))
		{
			// Add last child node that is an element
			var e = node.lastChild;
			while (elementsOnly == true && e != null && ElementManipulation.isElement(cast e) == false)
			{
				e = e.previousSibling;
			}
			if (e != null) lastChild = cast e;
		}
		return cast lastChild;
	}

	/**
		Gets the direct parent of the current node.

		If the parent is the current `Detox.document`, the result will return null - only elements inside the tree are returned as a parent.

		Please note that on platforms other than JS, the underlying `DOMNode` is an `Xml` object, so it already has a `parent` field - and this is a variable, not a method.
		If writing code for platforms other than JS, or if writing cross platform code, it is recommended you use the `parents()` method, which is a simple alias, but avoids the name collision.
		The equivalent `parents` method that operates on a `DOMCollection` rather than a `DOMNode` will return multiple parents - one for each node in the collection, so the plural naming may be appropriate.
		In future if we have an abstract implementation of `DOMNode` we will be able to rename this and avoid collision with the native `parent` field.

		@param node The current (child) node.  If this is null, the result will be `null`.
		@return The parent element.  Null if no parent was found.
	**/
	static public function parent(node:DOMNode):Null<DOMNode>
	{
		var p:DOMNode = null;
		if (node != null && node != Detox.document)
		{
			p = node.parentNode;
		}
		return p;
	}

	/**
		This is an alias of `parent` that avoids the name collision with the native `parent` property of `Xml`.

		It is recommended you use this on platforms other than JS, as it provides null safety and makes it easier to port code between platforms.
	**/
	static inline public function parents(node:DOMNode):Null<DOMNode>
	{
		return parent(node);
	}

	/**
		Retrieve all ancestors (parent nodes, grandparent nodes etc) of the current node.

		This will include all parents up to, but not including, the current `Detox.document`.

		@param node The current (child) node.  If null then the method will return an empty collection.
		@return A DOMCollection containing all of the ancestors.  It will be empty if `node` was null or if `node` has no parent.
	**/
	static public function ancestors(node:DOMNode):DOMCollection
	{
		var ancestorList:DOMCollection = new DOMCollection();

		var p = parent(node);
		while (p != null)
		{
			ancestorList.add(p);
			p = parent(p);
		}

		return ancestorList;
	}

	/**
		Fetch all the descendants of the current node.

		This will include all children, and their descendants recursively.

		@param node The current (parent) node.  If null the result will be an empty collection.
		@elementsOnly Should the collection of descendants include only elements (`true`, default) or should it include all nodes, including text nodes and comments (`false`).
		@return A collection of all descendant elements or nodes.  Will be empty if the current node was null or has no children.
	**/
	static public function descendants(node:DOMNode, ?elementsOnly:Bool = true):DOMCollection
	{
		var descendantList = new DOMCollection();

		for (child in children(node, elementsOnly))
		{
			descendantList.add(child);
			descendantList.addCollection(descendants(child, elementsOnly));
		}

		return descendantList;
	}

	/**
		Fetch the next element or node that is a sibling of this node.

		This will search for siblings (nodes that share the same parent) and return the next sibling along from the current one, if it exists.

		@param node The current node.  If null, the result will also be null.
		@elementsOnly Whether to search for the next element (`true`, default) or the next node, regardless of type (`false`).
		@return The next element or node if one was found, or null otherwise.
	**/
	static public function next(node:DOMNode, ?elementsOnly:Bool = true):Null<DOMNode>
	{
		var sibling = (node != null) ? node.nextSibling : null;

		// While this "nextSibling" actually still exists and if we only want elements but this "nextSibling" isn't an element...
		while (sibling != null && elementsOnly && sibling.nodeType != DOMType.ELEMENT_NODE)
		{
			// Find the next sibling down the line, maybe it is an element.
			// Otherwise eventually it will be null, meaning no element was found.
			sibling = sibling.nextSibling;
		}

		return sibling;
	}

	/**
		Fetch the previous element or node that is a sibling of this node.

		This will search for siblings (nodes that share the same parent) and return the previous sibling to the current one, if it exists.

		@param node The current node.  If null, the result will also be null.
		@elementsOnly Whether to search for the previous element (`true`, default) or the previous node, regardless of type (`false`).
		@return The previous element or node if one was found, or null otherwise.
	**/
	static public function prev(node:DOMNode, ?elementsOnly:Bool = true):Null<DOMNode>
	{
		var sibling = (node != null) ? node.previousSibling : null;

		// While this "previousSibling" actually still exists and if we only want elements but this "previousSibling" isn't an element...
		while (sibling != null && elementsOnly && sibling.nodeType != dtx.DOMType.ELEMENT_NODE)
		{
			// Find the previous sibling up the line, maybe it is an element.
			// Otherwise eventually it will be null, meaning no element was found.
			sibling = sibling.previousSibling;
		}

		return sibling;
	}

	/**
		Find the descendants which match a particular selector.

		On Javascript, this will attempt to use `elm.querySelectorAll` if it is available.
		If it is not available, a fallback will be attempted to `Sizzle`, `jQuery` or `$`.

		On platforms other than Javascript, `selecthxml.SelectDom.runtimeSelect` will be used.

		This does not include the current node in the search, only child / descendant nodes will be matched.

		@param node The parent DOMNode to search.  If it is null or not an element or document, an empty collection will be returned.
		@param selector The CSS selector to use when searching for a child.
		@return The collection of matching elements.  Will be empty if no match was found or the parent node was null / had no children.
	**/
	static public function find(node:DOMNode, selector:String):DOMCollection
	{
		var newDOMCollection = new DOMCollection();
		if (node != null && ElementManipulation.isElement(node) || dtx.single.ElementManipulation.isDocument(node))
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
				var results = selecthxml.SelectDom.runtimeSelect(node, selector);
				// SelectHxml also includes our original node in the search.
				// We should match the querySelectorAll() functionality from JS, which
				// only searches descendant nodes.  Therefore, remove the current node
				// if it was returned as a match.
				results.remove(node);

				newDOMCollection.addCollection(results);
			#end
		}
		return newDOMCollection;
	}
}

