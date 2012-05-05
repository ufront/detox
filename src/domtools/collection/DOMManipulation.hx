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

import domtools.DOMNode;
#if !js using domtools.XMLWrapper; #end

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
				domtools.single.DOMManipulation.append(parent, childNode, childCollection);
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
				domtools.single.DOMManipulation.prepend(parent, childNode, childCollection);
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
			domtools.single.DOMManipulation.append(parentNode, children);
		}
		else if (parentCollection != null)
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
				domtools.single.DOMManipulation.prependTo(child, parentNode, parentCollection);
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
					domtools.single.DOMManipulation.insertThisBefore(childToAdd, targetNode);
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
					insertThisBefore(cast childCollection, cast target);

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
					domtools.single.DOMManipulation.insertThisAfter(childToAdd, currentTarget);

					// target the next one to go after this one
					currentTarget = childToAdd;
				}
			}
			else if (targetCollection != null)
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
			domtools.single.DOMManipulation.insertThisBefore(contentNode, target);
		}
		else if (contentCollection != null)
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
			// before this target (multiple), insert content (single)
			domtools.single.DOMManipulation.insertThisAfter(contentNode, target);
		}
		else if (contentCollection != null)
		{
			// before this target (multiple), insert content (multiple)
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
				domtools.single.DOMManipulation.remove(node);
			}
		}
		return nodesToRemove;
	}

	/** Remove a child element from the DOM.  Return the parent */
	static public function removeChildren(parents:DOMCollection, ?childToRemove:DOMNode, ?childrenToRemove:domtools.DOMCollection)
	{
		if (parents != null)
		{
			for (parent in parents)
			{
				domtools.single.DOMManipulation.removeChildren(parent, childToRemove, childrenToRemove);
			}
		}
			
		return parents;
	}

	/** Empty the current element of all children. */
	static public function empty(containers:DOMCollection)
	{
		if (containers != null)
		{
			for (container in containers)
			{
				while (container.hasChildNodes())
				{
					container.removeChild(cast container.firstChild);
				}
			}
		}
		
		return containers;
	}
}