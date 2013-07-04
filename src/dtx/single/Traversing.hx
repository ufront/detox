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

#if js 
	import js.html.Element;
#else 
	using dtx.XMLWrapper;
#end

/*
	parentsUntil(selector)
	nextAll
	nextUntil
	prevAll
	prevUntil
	siblings
	closest() - 
*/
import Detox;

class Traversing
{
	/** Return a collection of all child nodes of the current node. */
	static public function children(node:Node, ?elementsOnly = true):Nodes
	{
		var children:Nodes = null;
		if (node != null && node.isElement())
		{
			// Add any child elements
			#if js
				var n:js.html.Node = node;
				children = Nodes.fromNodeList(node.toDom().childNodes);
			#else 
				// With Xml, "node" itself is iterable, so we can just pass that
				children = [];
				for(c in node.toXml()) {
					children.add(c, elementsOnly);
				}
			#end
		}
		return children;
	}

	/** Gets the direct parents of each element in the collection. */
	static public function parent(node:Node):Null<Node>
	{
		var p:Node = null;
		if (node != null && !node.isDocument())
		{
			#if js
				p = node.toDom().parentNode;
			#else 
				p = node.parentNode();
			#end
		}
		return p;
	}

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function ancestors(node:Node):Nodes
	{
		// start with the direct parents
		var ancestorsList:Nodes = [];
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
	static public function descendants(node:Node, ?elementsOnly:Bool = true):Nodes
	{
		var descendantList:Nodes = [];

		var childNodes = (elementsOnly) ? node.elements : node.children;
		for ( child in childNodes ) {
			// Add this child
			descendantList.add(child);

			// Add it's descendants (recurse)
			descendantList.addCollection(descendants(child, elementsOnly));
		}

		// Then pass the list back up the line...
		return descendantList;
	}

	static public function next(node:Node, ?elementsOnly:Bool = true):Null<Node>
	{
		// Get the next sibling if we're not null already
		var sibling = (node != null) 
			? #if js node.toDom().nextSibling #else node.nextSibling() #end : null;

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
		return sibling;
	}

	static public function prev(node:Node, ?elementsOnly:Bool = true):Null<Node>
	{
		// Get the previous sibling if it's not already null
		var sibling = (node != null) 
			? #if js node.toDom().previousSibling #else node.previousSibling() #end : null;

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

	static public function find(node:Null<Node>, selector:String):Nodes
	{
		var newDOMCollection:Nodes = null;
		if (node!=null && selector!=null && selector!="" && node.isElement() || node.isDocument())
		{
			#if js
				var element:Element = cast node;
				if (untyped __js__("document.querySelectorAll"))
				{
					var results = element.querySelectorAll(selector);
					newDOMCollection = results;
				}
				else 
				{
					var engine:String->Node->Array<Node> = untyped __js__("
						(('undefined' != typeof Sizzle && Sizzle) || 
						(('undefined' != typeof jQuery) && jQuery.find) || 
						(('undefined' != typeof $) && $.find))
					");
					var results = engine(selector, node);
					throw "DETOX TODO: Need to iterate over results and add them manually";
					newDOMCollection = results;
				}
			#elseif !macro
				var results = selecthxml.SelectDom.runtimeSelect(node, selector);
				// SelectHxml also includes our original node in the search.
				// We should match the querySelectorAll() functionality from JS, which
				// only searches descendant nodes.  Therefore, remove the current node
				// if it was returned as a match.
				results.remove(node);
				newDOMCollection = results;
			#else 
				throw "Sorry, our selector engine doesn't currently work in macros, so you can't use find()";
			#end
		}
		if (newDOMCollection == null) newDOMCollection = [];
		return newDOMCollection;
	}
}

