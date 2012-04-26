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

package domtools.collection;

import js.w3c.level3.Core;

class Traversing
{
	/** Return a new collection of all child nodes of the current collection. */
	static public function children(query:DOMCollection, ?elementsOnly = true)
	{
		var children = new DOMCollection();
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

	static public function firstChildren(query:DOMCollection, ?elementsOnly = true)
	{
		var children = new DOMCollection();
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

	static public function lastChildren(query:DOMCollection, ?elementsOnly = true)
	{
		var children = new DOMCollection();
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
	static public function parent(query:DOMCollection)
	{
		var parents = new DOMCollection();
		if (query != null)
		{
			for (node in query)
			{
				if (node.parentNode != null && node != domtools.DOMCollection.document)
					parents.add(node.parentNode);
			}
		}
		return parents;
	}

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function ancestors(query:DOMCollection):DOMCollection
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

	static public function next(query:DOMCollection, ?elementsOnly:Bool = true)
	{
		var siblings = new DOMCollection();
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

	static public function prev(query:DOMCollection, ?elementsOnly:Bool = true)
	{
		var siblings = new DOMCollection();
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

	static public function find(query:DOMCollection, selector:String)
	{
		var newDOMCollection = new DOMCollection();
		if (query != null && selector != null && selector != "")
		{
			for (node in query)
			{
				if (domtools.single.ElementManipulation.isElement(node))
				{
					var element:Element = cast node;
					newDOMCollection.addNodeList(element.querySelectorAll(selector));
				}
			}
		}
		return newDOMCollection;
	}
}