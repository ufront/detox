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

package dtx.collection;

import dtx.DOMNode;
#if !js using dtx.XMLWrapper; #end

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
				if (dtx.single.ElementManipulation.isElement(node))
				{
					// Add any child elements
					#if js
					children.addNodeList(node.childNodes, elementsOnly);
					#else 
					children.addCollection(node, elementsOnly);
					#end
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
				if (dtx.single.ElementManipulation.isElement(node))
				{
					// Add first child node that is an element
					var e = #if js node.firstChild #else node.firstChild() #end;
					while (elementsOnly == true && e != null && dtx.single.ElementManipulation.isElement(cast e) == false)
					{
						e = #if js e.nextSibling; #else  e = e.nextSibling(); #end
					}
					if (e != null) children.add(cast e);
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
				if (dtx.single.ElementManipulation.isElement(node))
				{
					// Add first child node that is an element
					var e = #if js node.lastChild #else node.lastChild() #end;
					while (elementsOnly == true && e != null && dtx.single.ElementManipulation.isElement(e) == false)
					{
						#if js
						e = e.previousSibling;
						#else 
						e = e.previousSibling();
						#end
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
				if (node.parentNode != null && node != DTX.document)
					#if js
					parents.add(node.parentNode);
					#else 
					parents.add(node.parent);
					#end
			}
		}
		return parents;
	}

	/** This is identical to parents() but it's necessary to use this on non 
	JS platforms if you want to have null-safety etc. */
	static inline public function parents(query:DOMCollection)
	{
		return parent(query);
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

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function descendants(query:DOMCollection, ?elementsOnly:Bool = true):DOMCollection
	{
		var descendantList = new dtx.DOMCollection();

		for (node in query)
		{
			var l = dtx.single.Traversing.descendants(node, elementsOnly);
			descendantList.addCollection(l);
		}

		// Then pass the list back up the line...
		return descendantList;
	}

	static public function next(query:DOMCollection, ?elementsOnly:Bool = true)
	{
		var siblings = new DOMCollection();
		if (query != null)
		{
			for (node in query)
			{
				// Get the next sibling
				var sibling = #if js node.nextSibling #else node.nextSibling() #end ;
				
				// If it's not null, but isn't an element, and we want an element,
				// keep going.
				while (sibling != null 
					&& sibling.nodeType != dtx.DOMType.ELEMENT_NODE
					&& elementsOnly )
				{
					sibling = #if js sibling.nextSibling #else sibling.nextSibling() #end;
				}

				// if we found a match, add it to our group
				if (sibling != null) siblings.add(cast sibling);
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
				var sibling = #if js node.previousSibling #else node.previousSibling() #end;

				// If it's not null, but isn't an element, and we want an element,
				// keep going.
				while (sibling != null  
					&& sibling.nodeType != dtx.DOMType.ELEMENT_NODE
					&& elementsOnly)
				{
					sibling = #if js sibling.previousSibling #else sibling.previousSibling() #end;
				}

				// if we found a match, add it to our group
				if (sibling != null) siblings.add(cast sibling);
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
				if (dtx.single.ElementManipulation.isElement(node))
				{
					#if js
					var element:DOMElement = cast node;
					newDOMCollection.addNodeList(element.querySelectorAll(selector));
					#else 
					// This next line is a workaround to a bug in selecthxml
					// See http://code.google.com/p/selecthxml/issues/detail?id=2
					// And http://code.google.com/p/selecthxml/issues/detail?id=3
					var results = selecthxml.SelectDom.runtimeSelect(node, selector);
					newDOMCollection.addCollection(results);
					#end
				}
			}
		}
		return newDOMCollection;
	}
}