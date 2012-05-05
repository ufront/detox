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

package domtools;

/**
* new() - runs a new query, creates a new collection. Alternatively pass DOM Node
* slice
* not - removes elements (or selector) from set
* is("") - like filter, but returns Bool rather than new list if(element.is("li.menu"))
* has(selector) - does it have a certain children
* andSelf() - previous set of matched elements to the current set
* index(?selector) - 
* 
* All the rest provided through "using"
*
* Static methods:
* - create()
* - parse()
**/
#if js
import js.w3c.level3.Core;
import UserAgentContext;
import CommonJS;
#end
import domtools.DOMNode;
import DOMTools;
using DOMTools;
#if !js using domtools.XMLWrapper; #end

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
			#if js 
			var nodeList = DOMTools.document.querySelectorAll(selector, null);
			#else  
			var nodeList = DOMTools.document.find(selector);
			#end
			addNodeList(cast nodeList);
		}
			
	}

	public inline function iterator()
	{
		return collection.iterator();
	}

	public inline function getNode(?i:Int = 0)
	{
		return collection[i];
	}

	public inline function eq(?i:Int = 0)
	{
		return new DOMCollection(getNode(i));
	}

	public inline function first()
	{
		return eq(0);
	}

	public inline function last()
	{
		return eq(this.length - 1);
	}

	public inline function add(node:DOMNode):DOMCollection
	{
		if (node != null)   
		{
			if (Lambda.has(collection, node) == false)
			{
				collection.push(node);
			}
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
				if (elementsOnly == false || domtools.single.ElementManipulation.isElement(node))
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
			if (elementsOnly == false || domtools.single.ElementManipulation.isElement(node))
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
			collection.remove(node);
		}
		if (nodeCollection != null)
		{
			for (n in nodeCollection)
			{
				collection.remove(n);
			}
		}
		return this;
	}

	public inline function each(f : DOMNode -> Void):DOMCollection
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