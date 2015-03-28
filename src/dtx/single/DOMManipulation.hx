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

import dtx.DOMNode;

/**
	This class provides static helper methods to manipulate the DOM, adding, moving and removing nodes or collections starting from a given `dtx.DOMNode`.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then perform the operation with the current DOMNode as if they were methods on the DOMNode itself.

	When working with collections, some operations will require nodes to be duplicated.
	For example, when appending a single node to a collection, that node will be appended to the first node in the collection, and a clone will be created and appended to each remaining node in the collection.
	The cloned nodes will not be added to the original collection.

	All methods will return the same DOMCollection that was originally operated on.
	Each method is null-safe, and will silently have no effect in the case of a null value or incorrect node type.
**/
class DOMManipulation
{
	/**
		Append the specified child (or children) to the current node.

		The child (or children) are added as the final child of the `parent` node.

		@param parent - The parent node that children will be appended to. If null this method has no effect.
		@param childNode - (optional) A single node to append to the parent. If null this will be ignored.
		@param childCollection - (optional) A collection of nodes to append to the parent. If null or empty this will be ignored.
		@return The original `parent`.
	**/
	static public function append(parent:DOMNode, ?childNode:DOMNode, ?childCollection:DOMCollection):DOMNode
	{
		if (parent != null)
		{
			if (childNode != null)
			{
				parent.appendChild(childNode);
			}
			if (childCollection != null)
			{
				for (child in childCollection)
				{
					parent.appendChild(child);
				}
			}
		}

		return parent;
	}

	/**
		Prepend the specified child (or children) to the current node.

		The child (or children) are added as the first child of the `parent` node.

		@param parent - The parent node that children will be prepended to. If null this method has no effect.
		@param childNode - (optional) A single node to prepend to the parent. If null this will be ignored.
		@param childCollection - (optional) A collection of nodes to prepend to the parent. If null or empty this will be ignored.
		@return The original `parent`.
	**/
	static public function prepend(parent:DOMNode, ?childNode:DOMNode, ?childCollection:DOMCollection):DOMNode
	{
		if (parent != null)
		{
			if (childNode != null)
			{
				if (parent.hasChildNodes())
				{
					insertThisBefore(childNode, parent.firstChild);
				}
				else
				{
					append(parent, childNode);
				}
			}
			if (childCollection != null)
			{
				dtx.collection.DOMManipulation.insertThisBefore(childCollection, parent.firstChild);
			}
		}

		return parent;
	}

	/**
		Append this node to a given parent or collection, cloning when necessary.

		This node will be inserted as the final child of the parent node(s).
		If there is more than one parent node, the child will be appended to the first node, and then a clone will be created and appended to each subsequent parent node.

		@param child - The child node that will be appended to any parent nodes.  If null this method has no effect.
		@param parentNode - (optional) A single parent node to append each child to. If null it will be ignored.
		@param parentCollection - (optional) A parent collection to append each child to. If null or empty it will be ignored.
		@return The original `child` node.
	**/
	static public function appendTo(child:DOMNode, ?parentNode:DOMNode, ?parentCollection:DOMCollection):DOMNode
	{
		if (parentNode != null)
		{
			append(parentNode, child);
		}
		if (parentCollection != null)
		{
			var childToInsert = (parentNode!=null) ? dtx.single.ElementManipulation.clone(child) : child;
			dtx.collection.DOMManipulation.append(parentCollection, childToInsert);
		}

		return child;
	}

	/**
		Prepend this node to a given parent or collection, cloning when necessary.

		This node will be inserted as the first child of the parent node(s).
		If there is more than one parent node, the child will be prepended to the first node, and then a clone will be created and prepended to each subsequent parent node.

		@param child - The child node that will be prepended to any parent nodes.  If null this method has no effect.
		@param parentNode - (optional) A single parent node to prepend each child to. If null it will be ignored.
		@param parentCollection - (optional) A parent collection to prepend each child to. If null or empty it will be ignored.
		@return The original `child` node.
	**/
	static public function prependTo(child:DOMNode, ?parentNode:DOMNode, ?parentCollection:DOMCollection):DOMNode
	{
		if (parentNode != null)
		{
			if (parentNode.hasChildNodes())
			{
				insertThisBefore(child, parentNode.firstChild, parentCollection);
			}
			else
			{
				append(parentNode, child);
			}
		}
		if (parentCollection != null)
		{
			var childToInsert = (parentNode!=null) ? dtx.single.ElementManipulation.clone(child) : child;
			dtx.collection.DOMManipulation.prepend(parentCollection, childToInsert);
		}
		return child;
	}

	/**
		Insert this node before a target node (as a sibling). Clone when necessary.

		This node will be inserted before the target node(s), so they will share the same parent(s).
		If there is more than one target node, the content node will be inserted for the first target, and cloned and inserted for each subsequent target.

		@param content The node to insert. If null this method will have no effect.
		@param targetNode A target node for the content node to be inserted before. Once finished this will be the next sibling of the content node. If null it will be ignored.
		@param targetCollection A target collection containing nodes for the content node to be inserted before. Once finished these will be the next siblings of the content nodes. If null or empty it will be ignored.
		@return The original `content` node.
	**/
	static public function insertThisBefore(content:DOMNode, ?targetNode:DOMNode, ?targetCollection:DOMCollection):DOMNode
	{
		if (content != null)
		{
			var firstChildUsed = false;
			if (targetNode != null)
			{
				var parent:DOMNode = targetNode.parentNode;
				if (parent != null)
				{
					firstChildUsed = true;
					parent.insertBefore(content, targetNode);
				}
			}
			if (targetCollection != null)
			{
				for (target in targetCollection)
				{
					var childToInsert = (firstChildUsed) ? content.cloneNode(true) : content;
					var parent:DOMNode = target.parentNode;
					if (parent != null)
					{
						parent.insertBefore(childToInsert, target);
					}

					firstChildUsed = true;
				}
			}
		}
		return content;
	}

	/**
		Insert this node after a target node (as a sibling). Clone when necessary.

		This node will be inserted after the target node(s), so they will share the same parent(s).
		If there is more than one target node, the content node will be inserted for the first target, and cloned and inserted for each subsequent target.

		@param content The node to insert. If null this method will have no effect.
		@param targetNode A target node for the content node to be inserted after. Once finished this will be the previous sibling of the content node. If null it will be ignored.
		@param targetCollection A target collection containing nodes for the content node to be inserted after. Once finished these will be the previous siblings of the content nodes. If null or empty it will be ignored.
		@return The original `content` node.
	**/
	static public function insertThisAfter(content:DOMNode, ?targetNode:DOMNode, ?targetCollection:DOMCollection):DOMNode
	{
		if (content != null)
		{
			var firstChildUsed = false;
			if (targetNode != null)
			{
				var next = targetNode.nextSibling;
				var parent:DOMNode = targetNode.parentNode;
				if (parent != null)
				{
					firstChildUsed = true;
					if (next != null)
					{
						parent.insertBefore(content, next);
					}
					else
					{
						parent.appendChild(content);
					}
				}
			}
			if (targetCollection != null)
			{
				for (target in targetCollection)
				{
					// clone the child if we've already used it
					var childToInsert = (firstChildUsed) ? content.cloneNode(true) : content;

					var next = target.nextSibling;
					if (next != null)
					{
						// add the (possibly cloned) child after.the target
						// (that is, before the targets next sibling)
						var parent:DOMNode = target.parentNode;
						if (parent != null)
						{
							parent.insertBefore(childToInsert, next);
						}
					}
					else
					{
						// add the (possibly cloned) child after the target
						// by appending it to the very end of the parent
						append(target.parentNode, childToInsert);
					}

					firstChildUsed = true;
				}
			}
		}
		return content;
	}

	/**
		Before this node insert a content node or content collection (as a sibling). Clone when necessary.

		Each content node will be inserted before the current node, so they will share the same parent.
		If there is more than one content node, their order once inserted will match their order inside the collection.

		@param target A target node for each content node to be inserted before. Once finished this will be the next sibling of the content nodes. If null this method will have no effect.
		@param contentNode A content node to insert. If null it will be ignored.
		@param contentCollection A collection of content nodes to insert. If null or empty it will be ignored.
		@return The original `target` node.
	**/
	static public function beforeThisInsert(target:DOMNode, ?contentNode:DOMNode, ?contentCollection:DOMCollection):DOMNode
	{
		if (target != null)
		{
			if (contentNode != null)
			{
				insertThisBefore(contentNode, target);
			}
			if (contentCollection != null)
			{
				dtx.collection.DOMManipulation.insertThisBefore(contentCollection, target);
			}
		}

		return target;
	}

	/**
		After this node insert a content node or content collection (as a sibling). Clone when necessary.

		Each content node will be inserted after the current node, so they will share the same parent.
		If there is more than one content node, their order once inserted will match their order inside the collection.

		@param target A target node for each content node to be inserted after. Once finished this will be the previous sibling of the content nodes. If null this method will have no effect.
		@param contentNode A content node to insert. If null it will be ignored.
		@param contentCollection A collection of content nodes to insert. If null or empty it will be ignored.
		@return The original `target` node.
	**/
	static public function afterThisInsert(target:DOMNode, ?contentNode:DOMNode, ?contentCollection:DOMCollection):DOMNode
	{
		if (target != null)
		{
			if (contentNode != null)
			{
				insertThisAfter(contentNode, target);
			}
			if (contentCollection != null)
			{
				dtx.collection.DOMManipulation.insertThisAfter(contentCollection, target);
			}
		}

		return target;
	}

	/**
		Detach this node from it's parent (and from the DOM).

		Please note `removeFromDOM` is an alias of this method designed to prevent a name clash with the `remove` method on `Xml`/`DOMNode` (for removing attributes) on platforms other than Javascript.

		@param childToRemove The node to remove from it's parent and the DOM. If null this method will have no effect.
		@return The original node that has now been removed.
	**/
	static public function remove(childToRemove:DOMNode):DOMNode
	{
		if (childToRemove != null)
		{
			var parent:DOMNode = childToRemove.parentNode;
			if (parent != null)
			{
				parent.removeChild(childToRemove);
			}
		}
		return childToRemove;
	}

	/**
		An alias for `remove` designed to prevent a name clash with the `remove` method on `Xml`/`DOMNode` (for removing attributes) on platforms other than Javascript.
	**/
	static public inline function removeFromDOM(nodesToRemove:DOMNode):DOMNode
	{
		return remove(nodesToRemove);
	}

	/**
		Remove one or more children from the current parent node.

		@param parent The parent node to remove children from. If null this method will have no effect.
		@param childToRemove An individual child node to look for and remove. If null it will be ignored.
		@param childrenToRemove A collection of nodes to look for and remove. If null or empty it will be ignored.
		@return The original parent node.
	**/
	static public function removeChildren(parent:DOMNode, ?childToRemove:DOMNode, ?childrenToRemove:DOMCollection):DOMNode
	{
		if (parent != null)
		{
			if (childToRemove != null && childToRemove.parentNode == parent)
			{
				parent.removeChild(childToRemove);
			}
			if (childrenToRemove != null)
			{
				for (child in childrenToRemove)
				{
					if (child.parentNode == parent)
					{
						parent.removeChild(child);
					}
				}
			}
		}
		return parent;
	}

	/**
		Replace this node with another node or collection.

		This is functionally the same as calling `afterThisInsert(target,content); remove(target);`.

		The order of the replacement nodes will match the order of the nodes in their collection.
		If both `contentNode` and `contentCollection` are specified, both will be inserted as a replacement, with the contentNode being inserted before the content collection.
		If neither `contentNode` nor `contentCollection` are specified, the target will be removed and nothing will be inserted as a replacement.

		@param target The node to be replaced.  If null this will have no effect.
		@param contentNode The node to be inserted as a replacement. If null, it will be ignored.
		@param contentCollection A collection of nodes to be inserted as a replacement. If null or empty, it will be ignored.
		@return The original target node which has now been replaced.
	**/
	static public function replaceWith(target:DOMNode, ?contentNode:DOMNode, ?contentCollection:DOMCollection):DOMNode
	{
		afterThisInsert(target, contentNode, contentCollection);
		remove(target);
		return target;
	}

	/**
		Empty the current nodes, so that it contains no child nodes.

		@param parent The parent node to empty. If null this method will have no effect.
		@return The original parent node.
	**/
	static public function empty(parent:DOMNode):DOMNode
	{
		if (parent != null)
		{
			for ( child in Lambda.list(parent.childNodes) )
			{
				parent.removeChild( child );
			}
		}
		return parent;
	}
}
