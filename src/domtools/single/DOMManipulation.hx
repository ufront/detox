package domtools.single;

import js.w3c.level3.Core;
/*
wrap()
unwrap
wrapAll()
wrapInner()
detach() - removes element, but keeps data
replaceAll(selector) - replace each element matching selector with our collection
replaceWith(newContent) - replace collection with new content
*/ 


/** This class could do with some more DRY - Don't Repeat Yourself.  I feel like between 
append() and insertBefore() there should be no need for any other functions */

class DOMManipulation
{
	/** Append the specified child to this node */
	static public function append(parent:Node, ?childNode:Node = null, ?childCollection:Query = null)
	{
		if (childNode != null)
		{
			parent.appendChild(childNode);
		}
		else if (childCollection != null)
		{
			for (child in childCollection)
			{
				parent.appendChild(child);
			}
		}

		return parent;
	}

	/** Prepend the specified child to this node */
	static public function prepend(parent:Node, ?newChildNode:Node = null, ?newChildCollection:Query = null)
	{
		if (newChildNode != null)
		{
			insertThisBefore(newChildNode, parent.firstChild);
		}
		else if (newChildCollection != null)
		{
			domtools.collection.DOMManipulation.insertThisBefore(newChildCollection, parent.firstChild);
		}

		return parent;
	}

	/** Append this node to the specified parent */
	static public function appendTo(child:Node, ?parentNode:Node = null, ?parentCollection:Query = null)
	{
		if (parentNode != null)
		{
			append(parentNode, child);
		}
		else if (parentCollection != null)
		{
			domtools.collection.DOMManipulation.append(parentCollection, child);
		}

		return child;
	}

	/** Prepend this node to the specified parent */
	static public inline function prependTo(child:Node, ?parentNode:Node = null, ?parentCollection:Query = null)
	{
		return insertThisBefore(child, parentNode.firstChild, parentCollection);
	}

	static public function insertThisBefore(content:Node, ?targetNode:Node = null, ?targetCollection:Query = null)
	{
		if (targetNode != null)
		{
			targetNode.parentNode.insertBefore(content, targetNode);
		}
		else if (targetCollection != null)
		{
			var firstChildUsed = false;
			for (target in targetCollection)
			{
				var childToInsert:Node;
				if (firstChildUsed)
				{
					childToInsert = content;
					firstChildUsed = true;
				}
				else 
				{
					// First child has been used, but we have more to add, so clone it
					childToInsert = content.cloneNode(true);
				}
				target.parentNode.insertBefore(childToInsert, target);
			}
		}
		return content;
	}

	static public inline function insertThisAfter(content:Node, ?targetNode:Node, ?targetCollection:Query)
	{
		return insertThisBefore(content, targetNode.nextSibling, targetCollection);
	}

	static public function beforeThisInsert(target:Node, contentNode:Node, contentQuery:Query)
	{
		if (contentNode != null)
		{
			insertThisBefore(contentNode, target);
		}
		else if (contentQuery != null)
		{
			domtools.collection.DOMManipulation.insertThisBefore(contentQuery, target);
		}
		return target;
	}

	static public function afterThisInsert(target:Node, contentNode:Node, contentQuery:Query)
	{
		if (contentNode != null)
		{
			insertThisAfter(contentNode, target);
		}
		else if (contentQuery != null)
		{
			domtools.collection.DOMManipulation.insertThisAfter(contentQuery, target);
		}
		return target;
	}

	/** Remove this element from the DOM.  Return the child in case you want to save it for later. */
	static public function remove(childToRemove:Node)
	{
		childToRemove.parentNode.removeChild(childToRemove);
		return childToRemove;
	}

	/** Empty the current element of all children. */
	static public function empty(container:Node)
	{
		while (container.hasChildNodes())
		{
			container.removeChild(container.firstChild);
		}
		return container;
	}
}

