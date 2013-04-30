package dtx.widget;

using Detox;
using Lambda;

/** A Loop is a class to help you display arrays, lists etc. on your page.  

### Interaction with data

It gives you a way to display a whole collection of information, for example, a table where each row represents a page on your site.  It then aims to keep these loop items in a state where Haxe can interact with them - making further changes or updates to the list, updating individual items in the list, responding to events, etc.

The Loop class accepts a type parameter <T>, which is the type of input that is expected.  This may be a simple String, Int etc, or it may be a complex object from a model.  If your data is kept in Haxe as Array<String>, you will use Loop<String>, if it is kept in Haxe as List<models.Person>, you will use Loop<models.Person>.

Each item in your loop should represent one input with the type T.

### The Loop as a DOMCollection

The Loop class is extended from DOMCollection, which means it can be added directly to other objects: `myLoop.appendTo(Detox.body);` 

You can also make changes to it like you would another collection: `myMenuItemLoop.addClass('menu-item')` would add the class 'menu-item' to all items in the loop.  

While you could go crazy and add to the collection or modify it manually, (eg. Add your own table row that is not a ListItem, or start deleting elements at random), this is weird and I make no promises as to anything working if you do that.  Stick 

### WidgetLoops, TemplateLoops etc

The Loop class is expected to be extended.  The function generateItem() by default just creates a text node with a string of whatever your input for that loop item was - probably not very useful!

There are two main extensions of Loop:

 * TemplateLoop: use a function T->String which generates the HTML to use for the Loop.  
 * WidgetLoop: use a Detox Widget for each LoopItem.  

Of course, you could also make your own variation where you override the `generateItem()` method with your own crazy ideas.

*/
class Loop<T> extends DOMCollection
{
	var referenceNode:dtx.DOMNode;
	var items:Array<LoopItem<T>>;

	/** Returns the number of items in the loop.  (In comparison to 'length', which returns the total number of DOMNodes in the loop's collection, which may differ from the number of items. */
	public var numItems(get_numItems,null):Int;

	/** Create a new, empty Loop. */
	public function new()
	{
		super();

		items = [];
		preventDuplicates = false;

		// A reference node is added to the collection, so that we can immediately add this loop
		// to a DOM tree somewhere, and the reference node will be inserted.  Later we can add or
		// remove items, but the reference node remains as a marker for where our loop belongs
		// in the DOM tree.
		// Just don't go using any methods which duplicate this DOMCollection, or we might be in trouble.
		// eg. No `myLoop.appendTo('ul'.find());` // append to (and duplicate for) every ul in the body
		referenceNode = "<!-- Detox Loop -->".parse().getNode();
		this.collection.push(referenceNode);
	}
	
	/** If preventDuplicates is true, then every item you add will check to see if an item with the same input already exists, and only add it if it is unique.  

	If you already have a bunch of items, and then change preventDuplicates to true, any existing duplicate items will be removed from the collection and from the DOM.  */
	public var preventDuplicates(default,set_preventDuplicates):Bool;

	function set_preventDuplicates(v:Bool)
	{
		#if (js || neko || php)
			if (v == null) v = false;
		#end 

		preventDuplicates = v;

		if (v == true && items.length > 0)
		{
			// Remove current duplicates
			var filteredInputs = [];

			// Because this loop modifies the items array, copy the array and iterate over the copy
			for (item in items.copy())
			{
				if (filteredInputs.has(item.input) == false)
				{
					// This is the first time (not a duplicate), so keep track of it
					filteredInputs.push(item.input);
				}
				else 
				{
					// it's a duplicate, remove it
					removeItem(item);
				}
			}
		}
		return v;
	}
	
	/** Remove all the current items, and replace them with a new group of items. */
	public function setList(list:Iterable<T>):Array<LoopItem<T>>
	{
		empty();
		return addList(list);
	}
	
	/** Add a new group of items to the current set of items */
	public function addList(list:Iterable<T>):Array<LoopItem<T>>
	{
		var newItems = [];
		if (list != null)
		{
			for (item in list)
			{
				newItems.push(addItem(item));
			}
		}
		return newItems;
	}
	
	/** Takes an input, generates a LoopItem, and includes it in the loop. 

	It will check for duplicates if `preventDuplicates` is true.  You can also set the position the item is to be inserted at.  Values for `pos` are the same as insertItem() */
	public function addItem(input:T, ?pos:Int = -1):LoopItem<T>
	{
		var item:LoopItem<T> = null;

		// If this is not null AND not a duplicate (or we don't care)
		if (input != null && (preventDuplicates == false || findItem(input) == null))
		{
			// Keep reference to both the original input and the generated item/collection
			item = generateItem(input);
			insertItem(item, pos);
		}

		return item;
	}

	/** Generate a LoopItem based on the input.  Override this if you want to have a custom Loop class that generates LoopItems in a particular fashion. */
	public function generateItem(input:T):LoopItem<T>
	{
		// Override this in sub classes...
		var item = new LoopItem(input);
		item.dom = Std.string(input).parse();
		return item;
	}

	/** Insert an already defined item into a specific place in the loop.  Values for pos are 0-based, so 0 will be before the first item, 1 will be after the first item, 3 will be after the 3rd etc.  By default, or if the position given is out of range, the item will be added to the end of the loop. */
	public function insertItem(item:LoopItem<T>, ?pos:Int = -1)
	{
		if (pos < 0 || pos > items.length) pos = items.length;
		items.insert(pos,item);

		if (items.length == 1)
		{
			// this is the first item, insert after the referenceNode
			referenceNode.afterThisInsert(item.dom);

			// add to the end of the collection
			for (node in item.dom)
			{
				this.collection.push(node);
			}
		}
		else if (items.length == pos+1)
		{
			// is the last item, Find the item before this one and insert our item after
			var prevItem = items[pos - 1];
			prevItem.dom.last().getNode().afterThisInsert(item.dom);

			// add to the end of the collection
			for (node in item.dom)
			{
				this.collection.push(node);
			}
		}
		else 
		{
			// is an item in the middle, there is at least one item after this in the list.  
			// Add this to the DOM before that item
			var nextItem = items[pos + 1];
			nextItem.dom.getNode(0).beforeThisInsert(item.dom);

			// Insert into the right position in the collection, accounting for the change
			// in position as we add more elements to the collection.
			var pos = collection.indexOf(nextItem.dom.getNode(0));
			for (node in item.dom)
			{
				this.collection.insert(pos, node);
				pos++;
			}
		}
	}
	
	/** Remove an item from the items array, the collection, and the DOM. 

	You can either pass a specific item, or a value.  If you pass a value, the first item that matches that value will be removed. */
	public function removeItem(?item:LoopItem<T>, ?itemValue:T)
	{
		if (item == null) item = findItem(itemValue);

		if (items.has(item))
		{
			items.remove(item);
			for (node in item.dom)
			{
				node.removeFromDOM();
				this.collection.remove(node);
			}
		}
	}
	
	/** Update an item in place.  

	This will generate a new LoopItem based on the new input, and put it in the place of the old one.  This is useful for providing live updates of data without having to re-draw the entire list.

	If `preventDuplicates` is true, and the new input already exists, the old item will be removed and not replaced. 

	If the item was not found in the list, nothing will be added or modified. */
	public function changeItem(item:LoopItem<T>, newInput:T)
	{
		var pos = getItemPos(item);
		removeItem(item);

		// Only add if the item exists
		if (pos != -1)
		{
			// If this is not a duplicate, or we don't care, and input isn't null
			if (newInput != null && (preventDuplicates == false || findItem(newInput) == null))
			{
				var newItem = generateItem(newInput);
				insertItem(newItem, pos);
			}
		}
	}
	
	/** Move a current item to a new position in the list. 

	Position is zero based, so a position of 0 will insert before the first item, 1 will insert after the first item etc.  If a position is not given, or if the position is out of range, the item will be moved to the end of the list.
	
	As part of the moving process, the position of elements will be bumped around.  The position you put in is the position BEFORE anything changes.  So if you have loop items:

		[a,b,c,d]

	And you want to put A after C:

		myLoop.moveItem(a, 3);

	And your items will now look like:

		[b,c,a,d]

	If the item is null, nothing will change.  If the item is not in the list, it will be inserted at the given position.
	*/
	public function moveItem(item:LoopItem<T>, ?newPos:Int = -1)
	{
		if (item != null)
		{
			// make sure the positions are correct
			/* Does removing the oldPos affect the position we are inserting to?
			   If newPos <= oldPos, it's to the left, and won't be affected by removing oldPos 
			   If newPos > oldPos, it's to the right, and will be one less further along after removing oldPos 

			   Also worth noting: if oldPos is -1, (item is not found), then newPos should not change.
			*/
			var oldPos = getItemPos(item);
			newPos = (oldPos > -1 && newPos > oldPos) ? newPos - 1 : newPos;

			// remove the item from it's current location
			removeItem(item);

			// insert the item into it's new location
			insertItem(item, newPos);
		}
	}
	
	/** Returns the position of an item relative to other items. 

	The position if 0-based, so the first item will have a position of 0.  This method is useful if you want to insert an item before or after an item elsewhere in the list. 

	Returns -1 if the item is not found. */
	public function getItemPos(item:LoopItem<T>):Int
	{
		return items.indexOf(item);
	}
	
	/** This finds an item based on either the input or the DOM element and returns the LoopItem object.

	You can pass in either input (T), a single node (DOMNode), or a collection of nodes to match against (DOMCollection)

	If no match is found, it returns null. If both input and dom are provided, it will return an item matching 
	the input if that exists first, or else an item matching the DOMCollection if that exists.  It will not check
	that both match - it will search for a match on either criteria. */
	public function findItem(?input:T, ?node:DOMNode, ?collection:DOMCollection):LoopItem<T>
	{
		if (input != null)
		{
			var results = items.filter(function (item) { return item.input == input; });
			if (results.length > 0)
			{
				return results[0];
			}
		}
		if (node != null)
		{
			var results = items.filter(function (item) { return item.dom.has(node); });
			if (results.length > 0) return results[0];
		}
		if (collection != null)
		{
			for (n in collection)
			{
				for (item in items)
				{
					for (itemNode in item.dom)
					{
						if (n == itemNode)
						{
							return item;
						}
					}
				}
			}
		}
		return null;
	}
	
	/** Empties all items from the current loop, and removes them from the DOM too. */
	public function empty()
	{
		for (item in items.copy())
		{
			items.remove(item);
			for (node in item.dom)
			{
				this.collection.remove(node);
				node.removeFromDOM();
			}
		}
	}

	/** Returns the array of the LoopItems, so each one holds a reference to the input and to the resulting DOM.  Useful for gaining access to the individual nodes/widgets and their respective inputs. 
	Changing this array directly could break things, be warned. */
	public function getItems()
	{
		return items;
	}

	inline function get_numItems():Int
	{
		return items.length;
	}
}

/** A simple class representing an item in the loop.

It contains the original input, and the DOMCollection (which may be a widget, or just a collection of DOMNodes).  */
class LoopItem<T>
{
	public function new(?input, ?dom)
	{
		this.input = input;
		this.dom = dom;
	}

	public var input:T;
	public var dom:dtx.DOMCollection;
}