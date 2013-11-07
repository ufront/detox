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

/**
* 
* All the rest provided through "using"
*
* Static methods:
* - create()
* - parse()
**/
#if !js
using dtx.XMLWrapper; 
#end
import dtx.DOMNode;
import Detox;
using Detox;

class DOMCollection
{
	public var collection(default,null):Array<DOMNode>;
	public var length(get_length,null):Int;

	public function new(?selector:String = "", ?node:DOMNode = null, ?collection:Iterable<DOMNode>)
	{
		this.collection = new Array();

		if (node != null)
		{
			add(node);
		}
		if (collection != null)
		{
			addCollection(collection);
		}
		if (selector != "")
		{
			addCollection(dtx.single.Traversing.find(Detox.document, selector));
		}
	}

	public inline function iterator()
	{
		return collection.iterator();
	}

	public function getNode(?i:Int = 0)
	{
		return if (collection.length > i && i >= 0) collection[i] else null;
	}

	public function eq(?i:Int = 0)
	{
		return new DOMCollection(getNode(i));
	}

	public function first()
	{
		return eq(0);
	}

	public function last()
	{
		return eq(this.length - 1);
	}

	public function add(node:DOMNode, ?pos = -1):DOMCollection
	{
		if (pos < 0 || pos > collection.length) pos = collection.length;
		if (node != null)   
		{
			#if !php
				if (Lambda.has(collection, node) == false)
				{
					collection.insert(pos,node);
				}
			#else
				// PHP chokes because Lambda.has doesn't use physical equality... 
				var hasAlready = false;
				for (n in collection) {
					if (untyped __physeq__(n,node)) {
						hasAlready = true;
						break;
					}
				}
				if (!hasAlready) collection.insert(pos,node);
			#end
		}
		return this;
	}

	public function addCollection(collection:Iterable<DOMNode>, ?elementsOnly = false):DOMCollection
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

	#if js
	public function addNodeList(nodeList:NodeList, ?elementsOnly = true):DOMCollection
	{
		for (i in 0...nodeList.length)
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
	public function addNodeList(nodeList:Iterable<DOMNode>, ?elementsOnly = true):DOMCollection
	{
		addCollection(nodeList, elementsOnly);
		return this;
	}
	#end

	public function removeFromCollection(?node:DOMNode, ?nodeCollection:DOMCollection):DOMCollection
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

	function removeNode(n)
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

	public function each(f : DOMNode -> Void):DOMCollection
	{
		if (f != null) { Lambda.iter(collection, f); }
		return this; 
	}

	/** Use a function to return a filtered list. In future might allow a selector as well. */
	public function filter(fn:DOMNode->Bool)
	{
		var newCollection:DOMCollection;

		if (fn != null)
		{
			var filtered = Lambda.filter(collection, fn);
			newCollection = new DOMCollection(filtered);
		}
		else 
		{
			newCollection = new DOMCollection(collection);
		}

		return newCollection;
	}

	public function clone(?deep:Bool = true):DOMCollection
	{
		var q = new DOMCollection();
		for (node in this)
		{
			q.add(node.cloneNode(deep));
		}
		return q;
	}

	inline function get_length():Int
	{
		return collection.length;
	}
}