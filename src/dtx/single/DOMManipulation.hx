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
#if !js using dtx.XMLWrapper; #end

/** This class could do with some more DRY - Don't Repeat Yourself.  I feel like between 
append() and insertBefore() there should be no need for any other functions */

class DOMManipulation
{
	/** Append the specified child to this node */
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

	/** Prepend the specified child to this node */
	static public function prepend(parent:DOMNode, ?newChildNode:DOMNode, ?newChildCollection:DOMCollection):DOMNode
	{
		if (parent != null)
		{
			if (newChildNode != null)
			{
				if (parent.hasChildNodes())
				{
					insertThisBefore(newChildNode, parent.firstChild#if !js () #end);
				}
				else 
				{
					append(parent, newChildNode);
				}
			}
			if (newChildCollection != null)
			{
				dtx.collection.DOMManipulation.insertThisBefore(newChildCollection, parent.firstChild#if !js () #end);
			}
		}

		return parent;
	}

	/** Append this node to the specified parent */
	static public function appendTo(child:DOMNode, ?parentNode:DOMNode, ?parentCollection:DOMCollection):DOMNode
	{
		if (parentNode != null)
		{
			append(parentNode, child);
		}
		if (parentCollection != null)
		{
			dtx.collection.DOMManipulation.append(parentCollection, child);
		}

		return child;
	}

	/** Prepend this node to the specified parent */
	static public function prependTo(child:DOMNode, ?parentNode:DOMNode, ?parentCollection:DOMCollection):DOMNode
	{
		if (parentNode != null)
		{
			if (parentNode.hasChildNodes())
			{
				insertThisBefore(child, parentNode.firstChild#if !js () #end, parentCollection);
			}
			else 
			{
				append(parentNode, child);
			}
		}
		if (parentCollection != null)
		{
			dtx.collection.DOMManipulation.prepend(parentCollection, child);
		}
		return child;
	}

	static public function insertThisBefore(content:DOMNode, ?targetNode:DOMNode, ?targetCollection:DOMCollection):DOMNode
	{
		if (content != null)
		{
			if (targetNode != null)
			{
				var parent:DOMNode = #if js targetNode.parentNode; #else targetNode.parent; #end
				if (parent != null)
				{
					parent.insertBefore(content, targetNode);
				}
			}
			if (targetCollection != null)
			{
				var firstChildUsed = false;
				for (target in targetCollection)
				{
					var childToInsert = (firstChildUsed) ? content.cloneNode(true) : content;
					var parent:DOMNode = #if js target.parentNode; #else target.parent; #end
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

	static public function insertThisAfter(content:DOMNode, ?targetNode:DOMNode, ?targetCollection:DOMCollection):DOMNode
	{
		if (content != null)
		{
			if (targetNode != null)
			{
				var next = targetNode.nextSibling #if !js () #end;
				var parent:DOMNode = targetNode.parentNode #if !js () #end;
				if (parent != null)
				{
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
				var firstChildUsed = false;
				for (target in targetCollection)
				{
					// clone the child if we've already used it
					var childToInsert = (firstChildUsed) ? content.cloneNode(true) : content;
					
					var next = #if js target.nextSibling #else target.nextSibling() #end;
					if (next != null)
					{
						// add the (possibly cloned) child after.the target
						// (that is, before the targets next sibling)
						var parent:DOMNode = #if js target.parentNode #else target.parentNode() #end;
						if (parent != null)
						{
							parent.insertBefore(childToInsert, next);
						}
					}
					else 
					{
						// add the (possibly cloned) child after the target
						// by appending it to the very end of the parent
						append(target.parentNode#if !js () #end, childToInsert);
					}
					
					firstChildUsed = true;
				}
			}
		}
		return content;
	}

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

	/** Remove this element from the DOM.  Return the child in case you want to save it for later. */
	static public function remove(childToRemove:DOMNode):DOMNode
	{
		if (childToRemove != null)
		{
			var parent:DOMNode = #if js childToRemove.parentNode; #else childToRemove.parent; #end
			if (parent != null)
			{
				parent.removeChild(childToRemove);
			}
		}
		return childToRemove;
	}

	static public inline function removeFromDOM(nodesToRemove:DOMNode):DOMNode
	{
		return remove(nodesToRemove);
	}

	/** Remove this element from the DOM.  Return the child in case you want to save it for later. */
	static public function removeChildren(parent:DOMNode, ?childToRemove:DOMNode, ?childrenToRemove:DOMCollection):DOMNode
	{
		if (parent != null)
		{
			if (childToRemove != null && childToRemove.parentNode #if !js () #end == parent)
			{
				parent.removeChild(childToRemove);
			}
			if (childrenToRemove != null)
			{
				for (child in childrenToRemove)
				{
					if (child.parentNode #if !js () #end == parent)
					{
						parent.removeChild(child);
					}
				}
			}
		}
		return parent;
	}

	/** Replace this with another node or collection.  This should then be removed from the DOM.  Returns the node that was removed.  */
	static public function replaceWith(target:DOMNode, ?contentNode:DOMNode, ?contentCollection:DOMCollection):DOMNode
	{
		afterThisInsert(target, contentNode, contentCollection);
		remove(target);
		return target;
	}

	/** Empty the current element of all children. */
	static public function empty(container:DOMNode):DOMNode
	{
		if (container != null)
		{
			while (container.hasChildNodes())
			{
				container.removeChild(container.firstChild#if !js()#end);
			}
		}
		return container;
	}
}

