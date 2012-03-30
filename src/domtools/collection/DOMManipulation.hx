package domtools.collection;

import js.w3c.level3.Core;
class DOMManipulation
{
	/** Append the specified child to all nodes in this collection, cloning when necessary */
	static public function append(parentCollection:Query, ?childNode:Node = null, ?childCollection:Query = null)
	{
		var firstChildUsed = true;
		for (parent in parentCollection)
		{
			// if the first child has been used, then clone whichever of these is not null
			childNode = (firstChildUsed || childNode == null) ? childNode : childNode.cloneNode(true);
			childCollection = (firstChildUsed || childCollection == null) ? childCollection : childCollection.clone();

			// now run the append from before
			domtools.single.DOMManipulation.append(parent, childNode, childCollection);
			firstChildUsed = false;
		}
		return parentCollection;
	}

	/** Prepend the specified child to this node */
	static public function prepend(parentCollection:Query, ?childNode:Node = null, ?childCollection:Query = null)
	{
		var firstChildUsed = false;
		for (parent in parentCollection)
		{
			// if the first child has been used, then clone whichever of these is not null
			childNode = (firstChildUsed || childNode == null) ? childNode : childNode.cloneNode(true);
			childCollection = (firstChildUsed || childCollection == null) ? childCollection : childCollection.clone();

			// now run the append from before
			domtools.single.DOMManipulation.prepend(parent, childNode, childCollection);
			firstChildUsed = true;
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
		// add this collection of children to a single parent Node
		return insertThisBefore(children, parentNode.firstChild, domtools.collection.Traversing.firstChildren(parentCollection));
	}

	static public function insertThisBefore(content:Query, ?targetNode:Node = null, ?targetCollection:Query = null)
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
		else if (targetCollection != null)
		{
			// insert this collection of content just before this collection of targets
			var firstChildUsed = false;
			var childCollection = content;
			for (target in targetCollection)
			{
				// if the first childCollection has been used, then clone it
				childCollection = (firstChildUsed) ? childCollection : childCollection.clone();

				// insert the (possibly cloned) collection into a single target node
				insertThisBefore(childCollection, target);

				// mark as used so next time we clone the children
				firstChildUsed = true;
			}
		}
		return content;
	}

	static public inline function insertThisAfter(content:Query, ?targetNode:Node = null, ?targetCollection:Query = null)
	{
		// insert content (collection) after target (node or collection)
		return insertThisBefore(content, targetNode.nextSibling, domtools.collection.Traversing.next(targetCollection));
	}

	static public inline function beforeThisInsert(target:Query, contentNode:Node, contentCollection:Query)
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

	static public inline function afterThisInsert(target:Query, contentNode:Node, contentCollection:Query)
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
		for (node in nodesToRemove)
		{
			domtools.single.DOMManipulation.remove(node);
		}
		return nodesToRemove;
	}

	/** Empty the current element of all children. */
	static public function empty(containers:Query)
	{
		for (container in containers)
		{
			while (container.hasChildNodes())
			{
				container.removeChild(container.firstChild);
			}
		}
		
		return containers;
	}
}