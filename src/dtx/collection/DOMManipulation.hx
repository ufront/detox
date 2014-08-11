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

package dtx.collection;

import dtx.DOMNode;

/**
	This class provides static helper methods to manipulate the DOM, adding, moving and removing nodes or collections starting from a given `dtx.DOMCollection`.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then perform the operation with the current DOMCollection as if they were methods on the DOMCollection object itself.

	When working with collections, some operations will require nodes to be duplicated.
	For example, when appending a single node to a collection, that node will be appended to the first node in the collection, and a clone will be created and appended to each remaining node in the collection.
	The cloned nodes will not be added to the original collection.

	All methods will return the same DOMCollection that was originally operated on.
	Each method is null-safe, and will silently have no effect in the case of a null value or incorrect node type.
**/
class DOMManipulation
{
	/**
		Append the specified child (or children) to all nodes in this collection, cloning when necessary.

		The child (or children) are added as the final child of each node in `parentCollection`.
		Each node in the parent collection will have the children appended using `dtx.single.DOMManipulation.append`.
		If there is more than one node in the parent collection, the children will be appended to the first node, and then a clone will be created and appended to each subsequent node.

		@param parentCollection - The parent nodes that children will be appended to.  If null or empty this method has no effect.
		@param childNode - (optional) A single node to append to the parent. If null this will be ignored.
		@param childCollection - (optional) A collection of nodes to append to the parent. If null or empty this will be ignored.
		@return The original `parentCollection`.
	**/
	static public function append<T:DOMCollection>(parentCollection:T, ?childNode:DOMNode, ?childCollection:DOMCollection):T
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

	/**
		Prepend the specified child (or children) to all nodes in this collection, cloning when necessary.

		The child (or children) are added as the first child of each node in `parentCollection`.
		Each node in the parent collection will have the children prepended using `dtx.single.DOMManipulation.prepend`.
		If there is more than one node in the parent collection, the children will be prepended to the first node, and then a clone will be created and prepended to each subsequent node.

		@param parentCollection - The parent nodes that children will be prepended to.  If null or empty this method has no effect.
		@param childNode - (optional) A single node to prepend to the parent. If null this will be ignored.
		@param childCollection - (optional) A collection of nodes to prepend to the parent. If null or empty this will be ignored.
		@return The original `parentCollection`.
	**/
	static public function prepend<T:DOMCollection>(parentCollection:T, ?childNode:DOMNode, ?childCollection:DOMCollection):T
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
					if (childCollection != null) childCollection = childCollection.clone();
				}

				// now run the prepend from single.DOMManipulation
				dtx.single.DOMManipulation.prepend(parent, childNode, childCollection);
			}
		}
		return parentCollection;
	}

	/**
		Append each node in this collection to a given parent or collection, cloning when necessary.

		Each node in the child collection will be appended to each parent node.
		If there is more than one parent node, the children will be appended to the first node, and then a clone will be created and appended to each subsequent parent node.

		@param children - The child nodes that will be appended to any parent nodes.  If null or empty this method has no effect.
		@param parentNode - (optional) A single parent node to append each child to. If null it will be ignored.
		@param parentCollection - (optional) A parent collection to append each child to. If null or empty it will be ignored.
		@return The original `children` collection.
	**/
	static public function appendTo<T:DOMCollection>(children:T, ?parentNode:DOMNode, ?parentCollection:DOMCollection):T
	{
		if (parentNode != null)
		{
			// add this collection of children to this single parentNode
			dtx.single.DOMManipulation.append(parentNode, children);
		}
		if (parentCollection != null)
		{
			// add this collection of children to this collection of parents
			var childrenToAppend:DOMCollection = (parentNode!=null) ? children.clone() : children;
			append(parentCollection, childrenToAppend);
		}

		return children;
	}

	/**
		Prepend each node in this collection to a given parent or collection, cloning when necessary.

		Each node in the child collection will be prepended to each parent node.
		If there is more than one parent node, the children will be prepended to the first node, and then a clone will be created and prepended to each subsequent node.

		@param children - The child nodes that will be prepended to any parent nodes.  If null or empty this method has no effect.
		@param parentNode - (optional) A single parent node to prepend each child to. If null it will be ignored.
		@param parentCollection - (optional) A parent collection to prepend each child to. If null or empty it will be ignored.
		@return The original `children` collection.
	**/
	static public function prependTo<T:DOMCollection>(children:T, ?parentNode:DOMNode, ?parentCollection:DOMCollection):T
	{
		if (children != null)
		{
			var childArray = children.collection.copy();
			childArray.reverse();
			for (child in childArray)
			{
				dtx.single.DOMManipulation.prependTo(child, parentNode, parentCollection);
			}
		}
		return children;
	}

	/**
		Insert each node in this collection before a target node (as a sibling). Clone when necessary.

		Each node in the current collection will be inserted before the target nodes, so they will share the same parent.
		If there is more than one content node, their order once inserted will match their order inside the collection.
		If there is more than one target node, the content collection will be inserted for the first target, and cloned and inserted for each subsequent target.

		@param content The collection of nodes to insert. If null or empty this method will have no effect.
		@param targetNode A target node for each content node to be inserted before. Once finished this will be the next sibling of the content nodes. If null it will be ignored.
		@param targetCollection A target collection containing nodes for each node in the content collection to be inserted before. Once finished these will be the next siblings of the content nodes. If null or empty it will be ignored.
		@return The original `content` collection.
	**/
	static public function insertThisBefore<T:DOMCollection>(content:T, ?targetNode:DOMNode, ?targetCollection:DOMCollection):T
	{
		if (content != null)
		{
			var firstChildUsed = false;
			if (targetNode != null)
			{
				firstChildUsed = true;
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
				var childCollection:DOMCollection = content;
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

	/**
		Insert each node in this collection after a target node (as a sibling). Clone when necessary.

		Each node in the current collection will be inserted after the target nodes, so they will share the same parent.
		If there is more than one content node, their order once inserted will match their order inside the collection.
		If there is more than one target node, the content collection will be inserted for the first target, and cloned and inserted for each subsequent target.

		@param content The collection of nodes to insert. If null or empty this method will have no effect.
		@param targetNode A target node for each content node to be inserted after. Once finished this will be the previous sibling of the content nodes. If null it will be ignored.
		@param targetCollection A target collection containing nodes for each node in the content collection to be inserted after. Once finished these will be the previous siblings of the content nodes. If null or empty it will be ignored.
		@return The original `content` collection.
	**/
	static public function insertThisAfter<T:DOMCollection>(content:T, ?targetNode:DOMNode, ?targetCollection:DOMCollection):T
	{
		if (content != null)
		{
			var firstChildUsed = false;
			if (targetNode != null)
			{
				firstChildUsed = true;

				// because we are adding many, the target is changing.
				var currentTarget:DOMNode = targetNode;

				// insert this collection of content into a single parent
				for (childToAdd in content)
				{
					dtx.single.DOMManipulation.insertThisAfter(childToAdd, currentTarget);

					// target the next one to go after this one
					currentTarget = childToAdd;
				}
			}
			if (targetCollection != null)
			{
				// insert this collection of content just before this collection of targets
				var childCollection:DOMCollection = content;
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

	/**
		Before each node in this collection insert a content node or content collection (as a sibling). Clone when necessary.

		Each content node will be inserted before each node in the current collection, so they will share the same parent.
		If there is more than one content node, their order once inserted will match their order inside the collection.
		If there is more than one target node, the content nodes will be inserted for the first target, and cloned and inserted for each subsequent target.

		@param target A target collection containing nodes for each content node to be inserted before. Once finished these will be the next siblings of the content nodes. If null or empty this method will have no effect.
		@param contentNode A content node to insert. If null it will be ignored.
		@param contentCollection A collection of content nodes to insert. If null or empty it will be ignored.
		@return The original `target` collection.
	**/
	static public function beforeThisInsert<T:DOMCollection>(target:T, ?contentNode:DOMNode, ?contentCollection:DOMCollection):T
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

	/**
		After each node in this collection insert a content node or content collection (as a sibling). Clone when necessary.

		Each content node will be inserted after each node in the current collection, so they will share the same parent.
		If there is more than one content node, their order once inserted will match their order inside the collection.
		If there is more than one target node, the content nodes will be inserted for the first target, and cloned and inserted for each subsequent target.

		@param target A target collection containing nodes for each content node to be inserted after. Once finished these will be the previous siblings of the content nodes. If null or empty this method will have no effect.
		@param contentNode A content node to insert. If null it will be ignored.
		@param contentCollection A collection of content nodes to insert. If null or empty it will be ignored.
		@return The original `target` collection.
	**/
	static public function afterThisInsert<T:DOMCollection>(target:T, ?contentNode:DOMNode, ?contentCollection:DOMCollection):T
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

	/**
		Remove each node in this collection from it's parent (and from the DOM).

		Please note `removeFromDOM` is an alias of this method designed to prevent a name clash with the `remove` method on `Xml`/`DOMNode` (for removing attributes) on platforms other than Javascript.

		@param nodesToRemove The collection of nodes to remove from their parent and the DOM. If the collection is null or empty this method will have no effect.
		@return The original collection that has now been removed.
	**/
	static public function remove<T:DOMCollection>(nodesToRemove:T):T
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

	/**
		An alias for `remove` designed to prevent a name clash with the `remove` method on `Xml`/`DOMNode` (for removing attributes) on platforms other than Javascript.
	**/
	static public inline function removeFromDOM<T:DOMCollection>(nodesToRemove:T):T
	{
		return remove(nodesToRemove);
	}

	/**
		Remove one or more children from the parents in the current collection.

		For each parent in the current collection, `dtx.single.DOMManipulation.removeChildren()` will be called.

		@param parents The collection of parent nodes to remove children from. If null or empty this method will have no effect.
		@param childToRemove An individual child node to look for and remove. If null it will be ignored.
		@param childrenToRemove A collection of nodes to look for and remove. If null or empty it will be ignored.
		@return The original collection of parent nodes.
	**/
	static public function removeChildren<T:DOMCollection>(parents:T, ?childToRemove:DOMNode, ?childrenToRemove:DOMCollection):T
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

	/**
		Replace each element in this collection with another node or collection.

		This is functionally the same as calling `afterThisInsert(target,content); remove(target);`.

		The order of the replacement nodes will match the order of the nodes in their collection.
		If both `contentNode` and `contentCollection` are specified, both will be inserted as a replacement, with the contentNode being inserted before the content collection.
		If neither `contentNode` nor `contentCollection` are specified, the target will be removed and nothing will be inserted as a replacement.
		If there are multiple target nodes, the content nodes will replace the first target, and be cloned and replace each subsequent target.

		@param target The collection of nodes to be replaced.  If null or empty this will have no effect.
		@param contentNode The node to be inserted as a replacement. If null, it will be ignored.
		@param contentCollection A collection of nodes to be inserted as a replacement. If null or empty, it will be ignored.
		@return The original target collection which has now been replaced.
	**/
	static public function replaceWith<T:DOMCollection>(target:T, ?contentNode:DOMNode, ?contentCollection:DOMCollection):T
	{
		afterThisInsert(target, contentNode, contentCollection);
		remove(target);
		return target;
	}

	/**
		Empty each of the nodes in the current collection, so that it contains no child nodes.

		@param parents The parent nodes to empty. If null or empty this method will have no effect.
		@return The original collection of parents.
	**/
	static public function empty<T:DOMCollection>(parents:T):T
	{
		if (parents != null)
		{
			for (parent in parents)
			{
				for ( child in Lambda.list(parent.childNodes) )
					parent.removeChild( child );
			}
		}

		return parents;
	}
}
