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

package dtx;

import dtx.DOMNode;
import Detox;
#if js
	import js.html.NodeList;
#end
using Detox;

/**
	A `DOMCollection` is a collection of DOM / Xml nodes.

	Working with collections of nodes is essential when interacting with the DOM.

	Examples of places where DOMCollection could be used:

	- Getting the children of a node
	- Getting all the descendants of a node
	- Getting all the nodes in a document that match a certain CSS selector
	- A collection of nodes that you wish to interact with as one (append, remove, addClass etc)
	- A set of nodes that you create programattically, for example, looping rows in a table, with the intention of inserting them.

	The nodes can be of any node type, not just elements.

	Detox is set up to interact with individual nodes (`dtx.DOMNode`) or multiple (`dtx.DOMCollection`) seamlessly.

	Classes for interacting with DOMCollections include:

	- `dtx.collection.ElementManipulation`
	- `dtx.collection.DOMManipulation`
	- `dtx.collection.Traversing`
	- `dtx.collection.EventManagement`
	- `dtx.collection.Style`
**/
class DOMCollection
{
	/**
		The array of `dtx.DOMNode` nodes we are interacting with.

		This array is created during the constructor.
		While you cannot set a new array, you can interact with the contents of the given array.
	**/
	public var collection(default,null):Array<DOMNode>;

	/**
		The number of nodes in the current collection.
	**/
	public var length(get_length,null):Int;

	/**
		Create a new DOMCollection.

		Initializes with a new array, and will add any nodes.
	**/
	public function new( ?nodes:Iterable<DOMNode> )
	{
		this.collection = [];
		if ( nodes!=null ) for ( n in nodes ) if ( n!=null ) this.collection.push( n );
	}

	/**
		An iterator for all nodes in this collecction.

		Usage: `for ( n in myCollection ) trace( n.nodeName )`
	**/
	public inline function iterator():Iterator<DOMNode>
	{
		return collection.iterator();
	}

	/**
		Get a specific node from the collection (specified by it's index in the collection).

		By default will fetch the first node.

		If no node is found at the given index, null is returned.

		@param i The index of the node to retrieve.  Default is `0` (first node).
		@return The given node, or null.
	**/
	public function getNode(?i:Int = 0):Null<DOMNode>
	{
		return if (collection.length > i && i >= 0) collection[i] else null;
	}

	/**
		Return a new collection containing only the node at the given index.

		The node remains in the old collection also.

		If no node is found at the given index, an empty collection is returned.

		@param i The index of the node to retrieve.  Default is `0` (first node).
		@return A new collection containing the specified node.
	**/
	public function eq(?i:Int = 0):DOMCollection
	{
		return new DOMCollection().add( getNode(i) );
	}

	/**
		Return the first node in the connection.

		This inline function is a shortcut for `getNode(0)`.
	**/
	public inline function first():Null<DOMNode>
	{
		return getNode(0);
	}

	/**
		Return the last node in the connection.

		This inline function is a shortcut for `getNode(this.length - 1)`.
	**/
	public function last():Null<DOMNode>
	{
		return getNode(this.length - 1);
	}

	/**
		Add a node to the collection, at a specified position.

		@param node The node to add to our collection.  If the node is already in the collection, it will be ignored.  If the node is null, it will be ignored.
		@param pos The position to insert the node (zero based).  If the position is less than zero or greater than the current length of the collection, the node will be inserted at the end of the collection.
		@return The same DOMCollection, to provide a fluid interface.
	**/
	public function add(node:DOMNode, ?pos = -1):DOMCollection
	{
		if (pos < 0 || pos > collection.length) pos = collection.length;
		if (node != null)
		{
			if (collection.indexOf(node) == -1)
			{
				collection.insert(pos,node);
			}
		}
		return this;
	}

	/**
		Add several nodes to the collection.

		All nodes will be added to the end of the collection.

		@param collection An iterable of DOMNodes to add.  If null or empty, it will be ignored.
		@param elementsOnly If true, only element nodes will be added to the collection.  Default: `false`.
		@return The same DOMCollection, to provide a fluid interface.
	**/
	public function addCollection(collection:Iterable<DOMNode>, ?elementsOnly:Bool = false):DOMCollection
	{
		if (collection != null)
		{
			for (node in collection)
			{
				// Only add if we are allowing elements only or if it is in fact an element
				if (elementsOnly == false || dtx.single.ElementManipulation.isElement(node))
					add(node);
			}
		}
		return this;
	}

	/**
		Add a NodeList to the collection.

		On javascript platforms, this takes a `js.html.NodeList`, which is returned by several native methods and properties such as `node.querySelectorAll()` and `node.children`.

		On other platforms, this is an inline function mirroring `addCollection`.

		This method will add all nodes to the end of the current collection.

		@param nodeList The node list to add to our collection.  On JS, this is a `js.html.NodeList`, on other platforms, it is an `Iterable<DOMNode>`. If the node list is null or empty, it is ignored.
		@param elementsOnly If true, only element nodes will be added to the collection.  Default: `false`.
		@return The same DOMCollection, to provide a fluid interface.
	**/
	#if js
		public function addNodeList(nodeList:NodeList, ?elementsOnly:Bool = false):DOMCollection
		{
			if (nodeList!=null) for (i in 0...nodeList.length)
			{
				var node = nodeList.item(i);
				// Only add if we are allowing elements only or if it is in fact an element
				if (elementsOnly == false || dtx.single.ElementManipulation.isElement(node))
				{
					add(node);
				}
			}
			return this;
		}
	#else
		public inline function addNodeList(nodeList:Iterable<DOMNode>, ?elementsOnly:Bool = false):DOMCollection
		{
			return addCollection(nodeList, elementsOnly);
		}
	#end

	/**
		Remove a node (or collection of nodes) from this collection.

		Please note this removes the node from this collection, but it has no effect on the nodes place in the DOM.

		@param node An individual node to be removed.  If null, it will be ignored.
		@param nodeCollection A group of nodes to be removed.  If null or empty, it will be ignored.
		@return The same DOMCollection, to provide a fluid interface.
	**/
	public function removeFromCollection(?node:DOMNode, ?nodeCollection:Iterable<DOMNode>):DOMCollection
	{
		if (node != null)
		{
			removeNode(node);
		}
		if (nodeCollection != null)
		{
			for (n in nodeCollection)
			{
				removeNode(n);
			}
		}
		return this;
	}

	function removeNode(n:DOMNode):Void
	{
		#if flash
		// Fix bug with Flash where the usual array.remove() didn't work.
		// It seems that
		//    a = xml.firstChild();
		//    b = xml.firstChild();
		//    a == b; // true
		//    Assert.areEqual(a,b); // false.
		// My guess is they are different objects in memory, but are physically equal.
		// This is a workaround.
		for (item in collection)
		{
			if (item==n)
			{
				collection.remove(item);
				break;
			}
		}
		#else
		collection.remove(n);
		#end
	}

	/**
		Perform a function on each node in the collection.

		@param f A function to operate on each individual node.  If null, it will be ignored.
		@return The same DOMCollection, to provide a fluid interface.
	**/
	public function each(f : DOMNode -> Void):DOMCollection
	{
		if (f != null) for( n in collection ) { f(n); }
		return this;
	}

	/**
		Use a function to return a filtered list.

		@param f A function to filter out individual nodes.  If null, no nodes will be filtered - the new collection will contain all the same nodes.
		@return A new DOMCollection, with only the nodes that passed the filter.
	**/
	public function filter(f:DOMNode->Bool):DOMCollection
	{
		var newCollection:DOMCollection;

		if (f != null)
		{
			var filtered = collection.filter(f);
			newCollection = new DOMCollection(filtered);
		}
		else
		{
			newCollection = new DOMCollection(collection);
		}

		return newCollection;
	}

	/**
		Clone the current collection and all of it's nodes.

		This not only clones the collection, but each node inside it.

		@return A new DOMCollection with the cloned nodes.
	**/
	public function clone():DOMCollection
	{
		var q = new DOMCollection();
		for (node in this)
		{
			q.add(node.cloneNode(true));
		}
		return q;
	}

	inline function get_length():Int
	{
		return collection.length;
	}
}
