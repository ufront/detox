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

class DOMManipulation
{
	/** Append the specified child to all nodes in this collection, cloning when necessary */
	static public function append(parentCollection:DOMCollection, ?childNode:DOMNode = null, ?childCollection:DOMCollection = null)
	{
		var firstChildUsed = false;
		if (parentCollection != null)
		{
			for (parent in parentCollection)
			{
				// if the first child has been used, then clone whichever of these is not null
				childNode = (firstChildUsed && childNode != null) ? childNode.cloneNode(true) : childNode;
				childCollection = (firstChildUsed && childCollection != null) ? childCollection.clone() : childCollection;

				// now run the append from before
				dtx.single.DOMManipulation.append(parent, childNode, childCollection);
				firstChildUsed = true;
			}
		}
		return parentCollection;
	}

	/** Prepend the specified child to this node */
	static public function prepend(parentCollection:DOMCollection, ?childNode:DOMNode = null, ?childCollection:DOMCollection = null)
	{
		var firstChildUsed = false;
		if (parentCollection != null)
		{
			for (parent in parentCollection)
			{
				if (firstChildUsed == false)
				{
					// first time through use the actual nodes without cloning.
					firstChildUsed = true;
				}
				else 
				{
					// clone these so we can attach to every element in collection
					if (childNode != null) childNode = childNode.cloneNode(true);
					if (childCollection != null) childCollection = childCollection.clone(true);
				}

				// now run the prepend from single.DOMManipulation
				dtx.single.DOMManipulation.prepend(parent, childNode, childCollection);
			}
		}
		return parentCollection;
	}

	/** Append this node to the specified parent */
	static public function appendTo(children:DOMCollection, ?parentNode:DOMNode = null, ?parentCollection:DOMCollection = null)
	{
		if (parentNode != null)
		{
			// add this collection of children to this single parentNode
			dtx.single.DOMManipulation.append(parentNode, children);
		}
		if (parentCollection != null)
		{
			// add this collection of children to this collection of parents
			append(parentCollection, children);
		}

		return children;
	}

	/** Prepend this node to the specified parent */
	static public inline function prependTo(children:DOMCollection, ?parentNode:DOMNode = null, ?parentCollection:DOMCollection = null)
	{
		if (children != null)
		{
			children.collection.reverse();
			for (child in children)
			{
				dtx.single.DOMManipulation.prependTo(child, parentNode, parentCollection);
			}
		}
		return children;
	}

	static public function insertThisBefore(content:DOMCollection, ?targetNode:DOMNode = null, ?targetCollection:DOMCollection = null)
	{
		if (content != null)
		{
			if (targetNode != null)
			{
				// insert this collection of content into a single parent
				for (childToAdd in content)
				{
					// insert a single child just before a single target
					dtx.single.DOMManipulation.insertThisBefore(childToAdd, targetNode);
				}
			}
			if (targetCollection != null)
			{
				// insert this collection of content just before this collection of targets
				var firstChildUsed = false;
				var childCollection = content;
				for (target in targetCollection)
				{
					// if the first childCollection has been used, then clone it
					childCollection = (firstChildUsed) ? childCollection.clone() : childCollection;

					// insert the (possibly cloned) collection into a single target node
					insertThisBefore(childCollection, target);

					// mark as used so next time we clone the children
					firstChildUsed = true;
				}
			}
		}
		return content;
	}

	static public function insertThisAfter(content:DOMCollection, ?targetNode:DOMNode = null, ?targetCollection:DOMCollection = null)
	{
		if (content != null)
		{
			if (targetNode != null)
			{
				// because we are adding many, the target is changing.
				var currentTarget:DOMNode = targetNode;

				// insert this collection of content into a single parent
				for (childToAdd in content)
				{
					// insert a single child just before a single target
					dtx.single.DOMManipulation.insertThisAfter(childToAdd, currentTarget);

					// target the next one to go after this one
					currentTarget = childToAdd;
				}
			}
			if (targetCollection != null)
			{
				// insert this collection of content just before this collection of targets
				var firstChildUsed = false;
				var childCollection = content;
				for (target in targetCollection)
				{
					// if the first childCollection has been used, then clone it
					childCollection = (firstChildUsed) ? childCollection.clone() : childCollection;

					// insert the (possibly cloned) collection into a single target node
					insertThisAfter(childCollection, target);

					// mark as used so next time we clone the children
					firstChildUsed = true;
				}
			}
		}
		// insert content (collection) after target (node or collection)
		return content;
	}

	static public inline function beforeThisInsert(target:DOMCollection, ?contentNode:DOMNode, ?contentCollection:DOMCollection)
	{
		if (contentNode != null)
		{
			// before this target (multiple), insert content (single)
			dtx.single.DOMManipulation.insertThisBefore(contentNode, target);
		}
		if (contentCollection != null)
		{
			// before this target (multiple), insert content (multiple)
			insertThisBefore(contentCollection, target);
		}

		return target;
	}

	static public inline function afterThisInsert(target:DOMCollection, ?contentNode:DOMNode, ?contentCollection:DOMCollection)
	{
		if (contentNode != null)
		{
			// after this target (multiple), insert content (single)
			dtx.single.DOMManipulation.insertThisAfter(contentNode, target);
		}
		if (contentCollection != null)
		{
			// after this target (multiple), insert content (multiple)
			insertThisAfter(contentCollection, target);
		}

		return target;
	}

	/** Remove this element from the DOM.  Return the child in case you want to save it for later. */
	static public function remove(nodesToRemove:DOMCollection)
	{
		if (nodesToRemove != null)
		{
			for (node in nodesToRemove)
			{
				dtx.single.DOMManipulation.remove(node);
			}
		}
		return nodesToRemove;
	}

	static public inline function removeFromDOM(nodesToRemove:DOMCollection)
	{
		return remove(nodesToRemove);
	}

	/** Remove a child element from the DOM.  Return the parent */
	static public function removeChildren(parents:DOMCollection, ?childToRemove:DOMNode, ?childrenToRemove:dtx.DOMCollection)
	{
		if (parents != null)
		{
			for (parent in parents)
			{
				dtx.single.DOMManipulation.removeChildren(parent, childToRemove, childrenToRemove);
			}
		}
			
		return parents;
	}

	/** Replace each element in this collection with another node or collection.  Each element in this collection should then be removed from the DOM.  Returns the collection that was removed. */
	static public function replaceWith(target:DOMCollection, ?contentNode:DOMNode, ?contentQuery:DOMCollection)
	{
		afterThisInsert(target, contentNode, contentQuery);
		remove(target);
		return target;
	}

	/** Empty the current element of all children. */
	static public function empty(containers:DOMCollection)
	{
		if (containers != null)
		{
			for (container in containers)
			{
				#if js 
				while (container.hasChildNodes()) 
					container.removeChild(container.firstChild);
				#else 
				container.empty();
				#end
			}
		}
		
		return containers;
	}
}