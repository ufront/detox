/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools.collection;

import js.w3c.level3.Core;
class DOMManipulation
{
	/** Append the specified child to all nodes in this collection, cloning when necessary */
	static public function append(parentCollection:Query, ?childNode:Node = null, ?childCollection:Query = null)
	{
		var firstChildUsed = true;
		if (parentCollection != null)
		{
			for (parent in parentCollection)
			{
				// if the first child has been used, then clone whichever of these is not null
				childNode = (firstChildUsed || childNode == null) ? childNode : childNode.cloneNode(true);
				childCollection = (firstChildUsed || childCollection == null) ? childCollection : childCollection.clone();

				// now run the append from before
				domtools.single.DOMManipulation.append(parent, childNode, childCollection);
				firstChildUsed = false;
			}
		}
		return parentCollection;
	}

	/** Prepend the specified child to this node */
	static public function prepend(parentCollection:Query, ?childNode:Node = null, ?childCollection:Query = null)
	{
		var firstChildUsed = false;
		if (parentCollection != null)
		{
			for (parent in parentCollection)
			{
				if (firstChildUsed)
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
	static public function appendTo(children:Query, ?parentNode:Node = null, ?parentCollection:Query = null)
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
	static public inline function prependTo(children:Query, ?parentNode:Node = null, ?parentCollection:Query = null)
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

	static public function insertThisBefore(content:Query, ?targetNode:Node = null, ?targetCollection:Query = null)
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
					insertThisBefore(childCollection, target);

					// mark as used so next time we clone the children
					firstChildUsed = true;
				}
			}
		}
		return content;
	}

	static public function insertThisAfter(content:Query, ?targetNode:Node = null, ?targetCollection:Query = null)
	{
		if (content != null)
		{
			if (targetNode != null)
			{
				// because we are adding many, the target is changing.
				var currentTarget:Node = targetNode;

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

	static public inline function beforeThisInsert(target:Query, ?contentNode:Node, ?contentCollection:Query)
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

	static public inline function afterThisInsert(target:Query, ?contentNode:Node, ?contentCollection:Query)
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
	static public function remove(nodesToRemove:Query)
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
	static public function removeChildren(parents:Query, ?childToRemove:Node, ?childrenToRemove:domtools.Query)
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
	static public function empty(containers:Query)
	{
		if (containers != null)
		{
			for (container in containers)
			{
				while (container.hasChildNodes())
				{
					container.removeChild(container.firstChild);
				}
			}
		}
		
		return containers;
	}
}