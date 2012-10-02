/****
* Copyright (c) 2012 Jason O'Neil
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
#if !js using dtx.XMLWrapper; #end

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
	static public function children(node:DOMNode, ?elementsOnly = true)
	{
		var children = new DOMCollection();
		if (node != null && ElementManipulation.isElement(node))
		{
			// Add any child elements
			#if js
			children.addNodeList(node.childNodes, elementsOnly);
			#else 
			// With Xml, "node" itself is iterable, so we can just pass that
			children.addCollection(node, elementsOnly);
			#end

		}
		return children;
	}

	static public function firstChildren(node:DOMNode, ?elementsOnly = true)
	{
		var firstChild:DOMNode = null;
		if (node != null && ElementManipulation.isElement(node))
		{
			// Add first child node that is an element
			var e = #if js node.firstChild #else node.firstChild() #end;
			while (elementsOnly == true && e != null && ElementManipulation.isElement(cast e) == false)
			{
				e = #if js e.nextSibling #else e.nextSibling() #end;
			}
			if (e != null) firstChild = cast e;
		}
		return firstChild;
	}

	static public function lastChildren(node:DOMNode, ?elementsOnly = true):DOMNode
	{
		var lastChild:DOMNode = null;
		if (node != null && ElementManipulation.isElement(node))
		{
			// Add last child node that is an element
			var e = #if js node.lastChild #else node.lastChild() #end;
			while (elementsOnly == true && e != null && ElementManipulation.isElement(cast e) == false)
			{
				e = #if js e.previousSibling #else e.previousSibling() #end;
			}
			if (e != null) lastChild = cast e;
		}
		return cast lastChild;
	}

	/** Gets the direct parents of each element in the collection. */
	static public function parent(node:DOMNode)
	{
		var p:DOMNode = null;
		if (node != null && node.parentNode != null && node != Detox.document)
		{
			#if js
			p = node.parentNode;
			#else 
			p = node.parentNode();
			#end
		}
		return p;
	}

	/** This is identical to parent() but it's necessary to use this on non 
	JS platforms if you want to have null-safety etc. */
	static inline public function parents(node:DOMNode)
	{
		return parent(node);
	}

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function ancestors(node:DOMNode):DOMCollection
	{
		// start with the direct parents
		var ancestorsList:DOMCollection = new DOMCollection();
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

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function descendants(node:DOMNode, ?elementsOnly:Bool = true):DOMCollection
	{
		var descendantList = new dtx.DOMCollection();

		for (child in children(node, elementsOnly))
		{
			// Add this child
			descendantList.add(child);

			// Add it's descendants (recurse)
			descendantList.addCollection(descendants(child, elementsOnly));
		}

		// Then pass the list back up the line...
		return descendantList;
	}

	static public function next(node:DOMNode, ?elementsOnly:Bool = true):DOMNode
	{
		// Get the next sibling if we're not null already
		var sibling = (node != null) 
			? #if js node.nextSibling #else node.nextSibling() #end : null;

		// While this "nextSibling" actually still exists
		// and if we only want elements
		// but this "nextSibling" isn't an element 
		while (sibling != null 
			&& elementsOnly
			&& sibling.nodeType != DOMType.ELEMENT_NODE)
		{
			// find the next sibling down the line.
			// If there is none, this will return null, which is okay.
			sibling = #if js sibling.nextSibling #else sibling.nextSibling() #end ;
		}

		// This will either be null or the next valid sibling
		return cast sibling;
	}

	static public function prev(node:DOMNode, ?elementsOnly:Bool = true):DOMNode
	{
		// Get the previous sibling if it's not already null
		var sibling = (node != null) 
			? #if js node.previousSibling #else node.previousSibling() #end : null;

		// While this "previousSibling" actually still exists
		// and if we only want elements
		// but this "previousSibling" isn't an element 
		while (sibling != null 
			&& elementsOnly
			&& sibling.nodeType != dtx.DOMType.ELEMENT_NODE)
		{
			// find the prev sibling up the line.
			// If there is none, this will return null, which is okay.
			#if js 
			sibling = sibling.previousSibling;
			#else 
			sibling = sibling.previousSibling();
			#end
		}

		// This will either be null or the previous valid sibling
		return cast sibling;
	}

	static public function find(node:DOMNode, selector:String)
	{
		var newDOMCollection = new DOMCollection();
		if (node != null && ElementManipulation.isElement(node))
		{
			#if js
			var element:DOMElement = cast node;
			newDOMCollection.addNodeList(element.querySelectorAll(selector));
			#elseif !macro
			// This next line is a workaround to a bug in selecthxml
			// See http://code.google.com/p/selecthxml/issues/detail?id=2
			// And http://code.google.com/p/selecthxml/issues/detail?id=3
			selecthxml.SelectDom.runtimeSelect(Xml.createDocument(), "a");
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

