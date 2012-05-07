/****
* Copyright 2012 Jason O'Neil. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE "AS IS" AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Jason O'Neil.
* 
****/

package domtools.single;

import domtools.DOMNode;
#if !js using domtools.XMLWrapper; #end

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
		if (node != null && node.parentNode != null && node != DOMTools.document)
		{
			#if js
			p = node.parentNode;
			#else 
			p = node.parentNode();
			#end
		}
		return p;
	}

	/** This is identical to parents() but it's necessary to use this on non 
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
		var descendantList = new domtools.DOMCollection();

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
			&& sibling.nodeType != domtools.DOMType.ELEMENT_NODE)
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
			#else 
			// This next line is a workaround to a bug in selecthxml
			// See http://code.google.com/p/selecthxml/issues/detail?id=2
			// And http://code.google.com/p/selecthxml/issues/detail?id=3
			selecthxml.SelectDom.runtimeSelect(Xml.createDocument(), "a");
			var results = selecthxml.SelectDom.runtimeSelect(node, selector);
			newDOMCollection.addCollection(results);
			#end
		}
		return newDOMCollection;
	}
}

