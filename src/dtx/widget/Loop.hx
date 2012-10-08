package dtx.widget;

using Detox;
using Lambda;

class Loop<T> extends DOMCollection
{
	var counter:Int;
	var inputs:IntHash<T>;
	var items:IntHash<DOMCollection>;
	var sortOrder:Array<LoopItemID>;
	var referenceNode:dtx.DOMNode;

	function new()
	{
		counter = 0;
		inputs = new IntHash();
		items = new IntHash();
		sortOrder = [];

		// A reference node is added to the collection, so that we can immediately add this loop
		// to a DOM tree somewhere, and the reference node will be inserted.  Later we can add or
		// remove items, but the reference node remains as a marker for where our loop belongs
		// in the DOM tree.
		// Just don't go using any methods which duplicate this DOMCollection, or we might be in trouble.
		// eg. No `myLoop.appendTo('ul'.find());` // append to (and duplicate for) every ul in the body
		referenceNode = "<!-- Detox Loop -->".parse().getNode();
		this.collection.add(referenceNode);
	}
	
	public var preventDuplicates(default,set_preventDuplicates):Bool;

	function set_preventDuplicates(v:Bool)
	{
		preventDuplicates = v;
		if (v == true && inputs.count() > 0 && items.count() > 0)
		{
			// Remove current duplicates
			var filteredInputs = new IntHash();
			var filteredItems = new IntHash();
			for (key in inputs.keys())
			{
				if (filteredInputs.has(inputs.get(key))
				{
					filteredInputs.set(key, inputs.get(key));
					filteredItems.set(key, items.get(key));
				}
				else 
				{
					// it's a duplicate, remove from the DOM
					items.get(key).removeFromDOM();
				}
			}
			inputs = filteredInputs;
			items = filteredItems;
		}
		return v;
	}
	
	public function setList(list:Iterable<T>):Array<LoopItemID>
	{
		empty();
		return addList(list);
	}
	
	public function addList(list:Iterable<T>):Array<LoopItemID>
	{
		var itemIDs:Array<Int> = [];
		for (item in list)
		{
			var id = addItem(item);
			itemIDs.push(id);
		}
		return itemIDs;
	}
	
	public function addItem(input:T, pos:Int = -1):LoopItemID
	{
		// If this is not a duplicate, or we don't care
		if (preventDuplicates == false || inputs.has(input) == false)
		{
			// if no position given, set to the length of items, so it goes at the end.
			if (pos == -1) pos = items.count();

			// Keep reference to both the original input and the generated item/collection
			counter++;
			inputs.set(counter, input);
			var collection = generateItem(input);
			items.set(counter, collection);

			for (node in collection)
			{
				this.collection.add(node);
			}

			insertItemAt(counter, pos);
		}
	}

	function generateItem(input:T):DOMCollection
	{
		// Override this in sub classes...
		return Std.string(input).parse();
	}

	function insertItemAt(itemID:LoopItemID, pos:Int)
	{
		var collection = items.get(itemID);
		sortOrder.insert(pos,itemID);

		if (sortOrder.length > pos)
		{
			// there is at least one item after this in the list.  
			// Add this to the DOM before that item
			var idOfNextItem = sortOrder[pos + 1];
			var nextItem = items.get(idOfNextItem);
			nextItem.getNode(0).insertBeforeThis(collection);
		}
		else if (sortOrder.length == 1)
		{
			// this is the first item, insert after the referenceNode
			referenceNode.insertAfterThis(collection);
		}
		else 
		{
			// It is the last element in the sortOrder
			// Find the item before this one and insert our item after
			var idOfPrevItem = sortOrder[pos + 1];
			var prevItem = items.get(idOfPrevItem);
			prevItem.last().getNode(0).insertAfterThis(collection);
		}
	}
	
	public function removeItem(item:LoopItemID)
	{
		if (inputs.exists(item)) inputs.remove(item);
		if (items.exists(item))
		{
			var i = items.get(item);
			for (node in i)
			{
				node.removeFromDOM();
				this.collection.remove(i);
			}
			items.remove(item);
			sortOrder.remove(item);
		}
	}
	
	public function changeItem(itemID:LoopItemID, newInput:T)
	{
		// If the existing one exists
		if (inputs.exists(itemID) && items.exists(itemID))
		{
			// If this is not a duplicate, or we don't care
			if (preventDuplicates == false || inputs.has(newInput)) == false)
			{
				pos = getItemPos(itemID);
				oldCollection = items.get(itemID);
				var newCollection = generateItem(input);

				inputs.set(itemID, input);
				items.set(itemID, newCollection);

				for (item in oldCollection)
				{
					item.removeFromDOM();
					this.collection.remove(item);
				}
				for (item in newCollection)
				{
					this.collection.add(item);
				}
				insertItemAt(itemID, pos);
			}
		}
	}
	
	public function moveItem(item:LoopItemID, newPos:Int)
	{
		// Change the item in our position tracker
		var oldPos = sortOrder.indexOf(item);
		sortOrder.remove(item);

		// Does removing the oldPos affect the position we are inserting to?
		// If newPos < oldPos, it's to the left, and won't be affected by removing oldPos 
		// If newPos > oldPos, it's to the right, and will be one less further along after removing oldPos
		newPos = (newPos < oldPos) ? newPos : newPos - 1;

		// Remove the old items from the DOM, and we'll replace them at the new position
		for (node in items.get(item))
		{
			node.removeFromDOM();
		}

		// Re add the items at newPos, and update our sortOrder
		insertItemAt(item, newPos);
	}
	
	/** Returns the position of an item, so that we can insert relative to other items. */
	public function getItemPos(item:LoopItemID):Int
	{
		return sortOrder.indexOf(item);
	}
	
	/** Returns the index of the item based on either the input or the resulting DOMCollection.  
	Use this index for other functions that take an Int. Returns -1 if failed... */
	public function findItem(?input:T, ?item:DOMCollection):LoopItemID
	{
		if (input != null)
		{
			for (itemID in inputs.keys())
			{
				if (inputs.get(itemID) == input)
				{
					return itemID;
				}
			}
		}
		if (item != null)
		{
			for (itemID in items.keys())
			{
				if (items.get(itemID) == item)
				{
					return itemID;
				}
			}
		}
		return -1;
	}
	
	public function empty()
	{
		for (node in this.collection)
		{
			if (node != referenceNode)
			{
				// Remove from the DOM, and from collection
				node.removeFromDOM();
				this.collection.remove(node);
			}
		}

		counter = 0;
		inputs = new IntHash();
		items = new IntHash();
		sortOrder = [];
	}
}

typedef LoopItemID = Int;
