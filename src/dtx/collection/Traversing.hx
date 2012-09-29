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
				if (node.parentNode != null && node != Detox.document)
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
					#elseif !macro
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