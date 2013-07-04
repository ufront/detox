package dtx;

#if js 
	import js.html.EventTarget;
	import js.html.MouseEvent;
	import js.html.KeyboardEvent;
	import js.html.CSSStyleDeclaration;
	import js.html.EventListener;
	import js.html.Element;
	import js.html.Node in NodeBase;
#else 
	import Xml in NodeBase;
#end

/**
An abstract type representing a collection of DOM / Xml nodes.

The underlying type changes depending on the platform.  On JS it is `Array<js.html.Node>`, on 
every other platform it is `Array<Xml>`.
**/
abstract Nodes (Array<Node>)
{
	/**
	Construct a new nodes collection based on the underlying array.
	**/
	public function new( ?n:Node, ?c:Array<Node> ) {
		this = ( c!=null ) ? c : [];
		if ( n!=null ) this.unshift(n);
	}

	//
	//
	// Casts
	//
	//

	/** 
	Parse the string, and return the various nodes.
	
	Auto casts from String to Nodes.
	**/
	@:from static public inline function fromString(s:String) {
		return Detox.parse(s);
	}
	
	/** 
	Print the Xml/HTML for the collection of nodes.

	Auto casts from `dtx.Node` to `String`.
	
	On Javascript this works by placing each node inside another and using 
	the "innerHTML" property to get a straight printout.

	On other targets, this has a custom printing algorithm that takes into account
	that in HTML only some tags are allowed to self-close, which Xml.toString() gets
	wrong.
	**/
	@:to public inline function toString():String {
		return get_html();
	}

	/** 
	Cast from `Array<Xml>` to `dtx.Nodes`. 

	On Javascript this will create a new object by re-parsing the Xml code.  On 
	other targets it will use the same underlying object.
	**/
	@:from static public inline function fromIterable(a:Iterable<Xml>) {
		#if js 
			return fromString( [ for (x in a) x.toString ].join("") ); 
		#else
			return new Nodes( Lambda.array(a) ); 
		#end 
	}
	
	/** 
	Cast from `dtx.Nodes` to `Array<Node>` 

	On Javascript this will create a new object by re-parsing the Xml code.  On 
	other targets it will use the same underlying object.
	**/
	@:to public inline function toArray():Array<Node> {
		return this;
	}
	
	/** 
	Cast from `dtx.Nodes` to `Array<Xml>` 

	On Javascript this will create a new object by re-parsing the Xml code.  On 
	other targets it will use the same underlying object.
	**/
	@:to public inline function toXmlArray():Array<Xml> {
		#if js 
			return [ for (x in this) Xml.parse( x.xmlString ) ];
		#else 
			return [ for (x in this) x ];
		#end
	}
	
	/** 
	Cast from `dtx.widget.Loop` to `dtx.Nodes` 
	**/
	@:from public static inline function fromLoop<T>(l:dtx.widget.Loop<T>)
		return l.nodes;
	
	/** 
	Cast from `dtx.widget.Widget` to `dtx.Nodes` 
	**/
	@:from public static inline function fromWidget(w:dtx.widget.Widget)
		return w.nodes;

	#if js
		/** Cast from `js.html.Node` to `dtx.Nodes` **/
		@:from static public inline function fromDom(n:js.html.Node):Nodes {
			return new Nodes( Node.fromDom(n) );
		}

		/** Cast from `js.html.EventTarget` to `dtx.Nodes` **/
		@:from static public inline function fromEventTarget(n:js.html.EventTarget):Nodes {
			return new Nodes( Node.fromDom(cast n) );
		}

		/** Cast from `js.html.NodeList` to `dtx.Nodes` **/
		@:from static public function fromNodeList(nl:js.html.NodeList):Nodes {
			var arr = [];
			for (i in 0...nl.length)
			{
				arr.push( nl.item(i) );
			}
			return new Nodes( arr );
		}
	#end

	//
	//
	// Collection / Array Management
	//
	//

	/** The number of Node items in this collection **/
	public var length(get,never):Int;
	inline function get_length()
		return this.length;

	/** An iterator to loop over all Node items in this collection **/
	public function iterator():Iterator<Node>
		return this.iterator();

	/** 
	Get a specific Node item. 

	Will return null if it was not found. 
	**/
	@:arrayAccess public function getNode( ?i:Int=0 ):Node
		return if ( this!=null  && this.length > i && i >= 0) this[i] else null;
	/** 
	Get the first item in the collection

	Will return null if it was not found. 
	**/
	public var first(get,never):Node;
	inline function get_first()
		return getNode( 0 );

	/** 
	Get the last item in the collection

	Will return null if it was not found. 
	**/
	public var last(get,never):Node;
	inline function get_last()
		return getNode( this.length-1 );

	/** 
	Add an item to the collection at the given position.

	If the position is out of range or not specified, the item
	is added at the end of the collection.

	If elementsOnly is set to true, a node will only be added to the collection if ir is
	an element, other types will be ignored.  By default elementsOnly is false.

	If node is null, or is already in the list, this has no effect.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	public function add( node:Node, ?pos = -1, ?elementsOnly=false ):Nodes {
		if ( node!=null ) {
			if ( !elementsOnly || node.isElement() )  {
				if ( Lambda.has(this, node) == false ) {
					if ( pos==null || pos<0 || pos>this.length ) 
						pos = this.length;
					this.insert(pos,node);
				}
			}
		}
		return new Nodes(this);
	}

	/** 
	Add all nodes in given Nodes list to the current collection.

	If node is null, or is already in the list, this has no effect.

	If elementsOnly is set to true, nodes will only be added to the collection if they are
	an element, other nodes will be left out.  By default elementsOnly is false.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	public function addCollection( collection:Iterable<Node>, ?elementsOnly=false ):Nodes {
		if ( collection!=null ) for ( n in collection ) {
			#if (neko || cpp)
				// This is a workaround for a glitch in neko where parse("<!-- Comment -->") generates
				// a collection with 2 nodes - the comment and an empty text node.  Not sure if it comes
				// from a child of these or from neko's XML parser... It sometimes shows up elsewhere too.
				// I think it's safe to always remove an empty text node...
				// Note - also happens on CPP.
				if (n.isTextNode() && n.nodeValue == "") return this;
			#end
			add( n, elementsOnly );
		}
		return this;
	}

	/** 
	Remove an individual Node or collection of Nodes from the current collection.

	If the item was not in the collection, it has no effect.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	public function removeFromCollection( ?n:Node, ?c:Nodes):Nodes
	{
		if ( n!=null ) 
			removeNode(n);

		if ( c!=null ) 
			for (n in c)
				removeNode(n);

		return this;
	}

	function removeNode(n)
	{
		#if flash 
			// Fix bug with Flash where the usual array.remove() didn't work.
			// It seems that 
			//    a = xml.firstChild();
			//    b = xml.firstChild();
			//    a == b; // true
			//    Assert.areEqual(a,b); // false.
			// My guess is they are different objects in memory, but are physically equal.
			// This is a workaround.
			for (item in collection)
			{
				if (item==n)
				{
					this.remove(item);
					break;
				}
			}
		#else
			this.remove(n);
		#end 
	}

	/** 
	Run the specified function on each node in the collection.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	public inline function each(fn:Node->Void):Nodes {
		if ( fn!=null ) for ( n in this ) fn(n);
		return this;
	}

	/** 
	Filter the specified collection, returning a new Nodes collection
	**/
	public inline function filter(fn:Node->Bool):Nodes {
		return (fn!=null) ? this.filter(fn) : this.copy();
	}

	/** 
	Return a new Nodes collection, with each Node from the current collection being cloned into the new one.
	**/
	public inline function clone():Nodes {
		return [ for ( n in this ) n.clone() ];
	}

	/** 
	Return the index of the given node in this collection

	Note that this is the position in this collection of Nodes, not the given Node's position
	relative to it's parent.  For that use `node.index`.

	Will return -1 if the given node is not found in this collection.
	**/
	inline public function indexOf( n:Node ):Int {
		return Lambda.indexOf(this, n);
	}

	//
	//
	// ElementManipulation
	//
	//

	/** Returns true if the first Node in the collection is an element.  If node is "null", it returns false. **/
	inline public function isElement():Bool 
		return first.isElement();

	/** Returns true if the first Node in the collection is a comment.  If node is "null", it returns false. **/
	inline public function isComment():Bool 
		return first.isComment();

	/** Returns true if the first Node in the collection is a text node.  If node is "null", it returns false. **/
	inline public function isTextNode():Bool 
		return first.isTextNode();

	/** Returns true if the first Node in the collection is a document.  If node is "null", it returns false. **/
	inline public function isDocument():Bool 
		return first.isDocument();

	/** 
	Returns the index of the first node in the collection in relation 
	to it's siblings. The index is zero-based, so the first child 
	has an index of 0. Returns -1 if parent is null.

	Read only.
	**/
	public var index(get,never):Int;
	inline function get_index():Int
		return first.index;
	
	/**
	Tells if every node in the collection has the specified attribute.

	If one of the Nodes is not an Element then this returns false.
	**/
	inline public function hasAttr( attName:String ):Bool 
		return Lambda.foreach( this, function (n) return n.hasAttr(attName) );

	/** 
	Returns the value of the given attribute on the first node in the collection.

	If the Node is not an Element, or if the attribute is not present, it returns "" (an empty string).

	Can be used with array access:

	    node[title]; // Return the title attribute from the given node.
	**/
	@:arrayAccess inline public function attr( attName:String ):String 
		return first.attr( attName );

	/** 
	Sets the value of the attribute on all Nodes in the collection.

	If a Node is not an Element, it has no effect.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	inline public function setAttr( attName:String, attValue:String ):Nodes
		return each( function (n) n.setAttr(attName,attValue) );
	
	/**
	Same as `setAttr()`, but provides array write access for setting attributes.

	    node[title] = "My Element";

	Also returns the value provided, rather than the node.
	**/
	@:arrayAccess inline function setAttrArrayWrite(attName:String, attValue:String):String {
		setAttr( attName, attValue );
		return attValue;
	}
	
	/**
	Remove the given attribute from each node in the collection.  

	If a Node is not an Element or if the attribute was not present, this has no effect.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	inline public function removeAttr( attName:String ):Nodes
		return each( function (n) n.removeAttr(attName) );

	/**
	Tells if the every node in the collection has the specified class 
	(or classes) in the Node's "class" attribute.

	To check for multiple classes, separate class names with a space.

	If one of the Nodes is not an Element, or does not have a "class" attribute, this returns false
	**/
	inline public function hasClass( className:String ):Bool 
		return (this.length==0) ? false : Lambda.foreach( this, function (n) return n.hasClass(className) );

	/**
	Add the given class (or classes) to the each Node's "class" attribute.

	Separate multiple class names with a space.  Additional whitespace will be trimmed.

	If a Node is not an Element, or already has the given class, this has no effect.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	inline public function addClass( className:String ):Nodes 
		return each( function (n) n.addClass(className) );

	/**
	Remove the given class (or classes) from each Node's "class" attribute.

	Separate multiple class names with a space.  Additional whitespace will be trimmed.

	If a Node is not an Element, or does not have the given class, this has no effect.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	inline public function removeClass( className:String ):Nodes 
		return each( function (n) n.removeClass(className) );

	/**
	Toggle the given class (or classes) for each Node's "class" attribute.

	If the class already exists, it will be removed.  If it does not, it will be added.

	Separate multiple class names with a space.  Additional whitespace will be trimmed.

	If one of the Nodes is not an Element this has no effect on that element.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function toggleClass( className:String ):Nodes 
		return each( function (n) n.toggleClass(className) );

	/**
	The tag name of the first element in the collection, in lowercase.

	If the node is a document, text node or comment node, or other, it 
	returns "#document", "#text", "#comment" or "#other" respectively.

	If the Node is null, it returns "" (an empty string).

	Read only.
	**/
	public var tagName(get,never):String;
	inline function get_tagName():String
		return first.tagName;

	/**
	Gets the "value" of the first node in the collection, or sets the value of every node
	in the collection.

	If the node is something other than an Element, it will return the nodeValue.
	
	If it is an Element, on Javascript, it checks for a "value" field on the object, 
	as is the case with various input controls.  On other targets, or if a "value" 
	field is not present, it returns the attribute "value" on the given element.

	If the node is null, or the above tests yield no result, it returns "" (an empty string).

	For setting the value, see notes on `setVal()`;
	**/
	public var val(get,set):String;
	inline function get_val():String
		return first.val;
	inline function set_val(v:String):String {
		setVal(v);
		return v;
	}

	/**
	Sets the "value" of every node in the collection.
	
	If s Node is not an element, it will set the nodeValue.

	Otherwise, on Javascript, it will attempt to set a "value" field on the object, 
	which will work for input controls etc.  On other targets, it sets the "value" 
	attribute.

	Behaviour on Javascript with elements which do not have a "value" property is undefined.

	If a node is null, it will skip ahead silently.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	inline public function setVal( val:String ):Nodes 
		return each( function (n) n.setVal(val) );

	/**
	The combined "text" of the given nodes.

	If a node is something other than an Element, it will use the nodeValue.
	
	If it is an Element, the text content of it's children (and descendants) will be used.

	If the node is null, it returns "" (an empty string).

	For setting the value, see notes on `setText()`.
	**/
	public var text(get,set):String;
	inline function get_text():String
		return this.map( function(n) return n.text ).join('');
	inline function set_text(v:String):String {
		setText(v);
		return v;
	}

	/**
	Sets the "text" of each of the given nodes.
	
	If the Node is not an element, it will set the nodeValue.

	Otherwise, it will replace all of the Element's children with a single text node.

	If the node is null, this has no effect.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	inline public function setText( text:String ):Nodes
		return each( function (n) n.setText(text) );

	/**
	Returns the combined innerHTML of the given nodes.

	If a node is something other than an Element, it will return the text content.
	
	If it is an Element, it will return the HTML for it's children.

	If the node is null, it returns "" (an empty string).

	For setting the value, see notes on `setInnerHTML()`.
	**/
	public var innerHTML(get,set):String;
	inline function get_innerHTML():String
		return this.map( function(n) return n.innerHTML ).join('');
	inline function set_innerHTML(v:String):String {
		setInnerHTML(v);
		return v;
	}

	/**
	Sets the inner HTML of each node.
	
	If the Node is not an element, it will set the text content.

	Otherwise, it will remove all the current child nodes, parse the HTML, and add 
	the resulting nodes as children.

	This method returns the Nodes you started with, so that chaining is enabled.
	**/
	inline public function setInnerHTML( html:String ):Nodes 
		return each( function (n) n.setInnerHTML(html) );

	/**
	Returns the combined HTML string of the Node collection. 

	Read only.
	**/
	public var html(get,never):String;
	inline function get_html():String 
		return this.map( function(n) return n.html ).join('');

	/**
	Returns the Xml string of the current Node.  

	On JS this is the same as `toString()`.  On other targets it prints the
	output of the `Xml` toString() method, which does not account for the limits
	on self-closing tags in HTML.
	**/
	public var xmlString(get,never):String;
	inline function get_xmlString():String
		return this.map( function(n) return n.xmlString ).join('');

	//
	//
	// Traversing
	//
	//

	/**
	A `Nodes` of the combined child elements of each node in this collection.

	If a node is not an element or has no child elements, it will not add any items to the returned collection.

	Read only.
	**/
	public var elements(get,never):Nodes;
	function get_elements():Nodes {
		var c = new Nodes([]);
		for (n in this) 
			c.addCollection( n.elements );
		return c;
	}

	/**
	A Nodes collection of the combined child nodes of the current node, regardless of type.

	If a node is not an element or has no child nodes, it will not add any items to the returned collection.

	Read only.
	**/
	public var children(get,never):Nodes;
	inline function get_children():Nodes {
		var c = new Nodes([]);
		for (n in this) 
			c.addCollection( n.children );
		return c;
	}
	
	/**
	For each node in the current collection, get the first child node.

	If a node is not an element or has no children, it will not add anything to the 
	resulting collection..

	Read only.
	**/
	public var firstChild(get,never):Nodes;
	inline function get_firstChild():Nodes {
		var f:Nodes = [];
		for ( n in this ) f.add( n.firstChild );
		return f;
	}
	
	/**
	For each node in the current collection, get the first child element.

	If a node is not an element or has no child elements, it will not add anything to the 
	resulting collection..

	Read only.
	**/
	public var firstElement(get,never):Nodes;
	inline function get_firstElement():Nodes {
		var f:Nodes = [];
		for ( n in this ) f.add( n.firstElement, true );
		return f;
	}
	
	/**
	For each node in the current collection, get the last child node.

	If a node is not an element or has no children, it will not add anything to the 
	resulting collection..

	Read only.
	**/
	public var lastChild(get,never):Nodes;
	inline function get_lastChild():Nodes {
		var f:Nodes = [];
		for ( n in this ) f.add( n.lastChild );
		return f;
	}
	
	/**
	For each node in the current collection, get the last child element.

	If a node is not an element or has no child elements, it will not add anything to the 
	resulting collection..

	Read only.
	**/
	public var lastElement(get,never):Nodes;
	inline function get_lastElement():Nodes {
		var f:Nodes = [];
		for ( n in this ) f.add( n.lastElement, true ); 
		return f;
	}

	/**
	A collection containing the parent nodes of each element in this collection.

	If a node has no parent, nothing will be added to the resulting collection

	Read only.
	**/
	public var parent(get,never):Nodes;
	inline function get_parent():Nodes {
		var c = new Nodes([]);
		for (n in this) {
			var p = n.parent;
			if (p!=null) c.add( p );
		}
		return c;
	}

	/**
	A `Nodes` of all ancestor nodes, from each node's parent upwards.

	If this node has no parent, it will not add any items to the collection.

	Read only.
	**/
	public var ancestors(get,never):Nodes;
	inline function get_ancestors():Nodes {
		var c = new Nodes([]);
		for (n in this) 
			c.addCollection( n.ancestors );
		return c;
	}

	/**
	A `Nodes` of all descendant elements, from this node's descendants down.

	Non-elements will not be included.  

	If a node has no child elements, it will not add any items to the collection.

	Read only.
	**/
	public var descendantElements(get,never):Nodes;
	inline function get_descendantElements():Nodes {
		var c = new Nodes([]);
		for (n in this)
			c.addCollection( n.descendantElements );
		return c;
	}

	/**
	A `Nodes` of all descendant nodes, from this node's descendants down.

	If a node has no children, it will not add any items to the collection.

	Read only.
	**/
	public var descendants(get,never):Nodes;
	inline function get_descendants():Nodes {
		var c = new Nodes();
		for (n in this) {
			c.addCollection( n.descendants );
		}
		return c;
	}

	/**
	A collection of the next siblings along from each of the current nodes, only 
	counting elements.

	If this node has no next siblings that are elements, nothing will be added to the
	resulting collection.

	Read only.
	**/
	public var nextElement(get,never):Nodes;
	inline function get_nextElement():Nodes {
		var c = new Nodes([]);
		for (n in this) {
			var next = n.nextElement;
			if (next!=null) c.add( next );
		}
		return c;
	}

	/**
	A collection of the next sibling node.

	If this node has no next siblings, or is null, it will not be added 
	to the resulting collection.

	Read only.
	**/
	public var next(get,never):Nodes;
	inline function get_next():Nodes {
		var c = new Nodes([]);
		for (n in this) {
			var next = n.next;
			if (next!=null) c.add( next );
		}
		return c;
	}

	/**
	A collection of the previous siblings along from each of the current nodes, only 
	counting elements.

	If this node has no previous siblings that are elements, nothing will be added to the
	resulting collection.

	Read only.
	**/
	public var prevElement(get,never):Nodes;
	inline function get_prevElement():Nodes {
		var c = new Nodes([]);
		for (n in this) {
			var p = n.prevElement;
			if (p!=null) c.add( p );
		}
		return c;
	}

	/**
	A collection of the prev sibling node.

	If this node has no prev siblings, or is null, it will not be added 
	to the resulting collection.

	Read only.
	**/
	public var prev(get,never):Nodes;
	inline function get_prev():Nodes {
		var c = new Nodes([]);
		for (n in this) {
			var p = n.prev;
			if (p!=null) c.add( p );
		}
		return c;
	}

	/**
	Do a search using a CSS selector, and return the result as a `Nodes`.

	On Javascript, it will use `document.querySelectorAll` if available, or will
	attempt to fall back to Sizzle, jQuery, or a generic `$()` function.

	On other targets, `selecthxml.SelectDom.runtimeSelect` will be used.

	If no results are found, or if the current node is not an element or 
	document, it will return an empty collection.

	Please note this function does not work inside macros.
	**/
	inline public function find( selector:String ):Nodes {
		var c = new Nodes([]);
		for (n in this) {
			c.addCollection( n.find(selector) );
		}
		return c;
	}

	//
	//
	// DOMManipulation
	//
	//

	/** 
	Append the specified child or collection to the end of this node.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function append( ?childNode:Node, ?childNodes:Nodes ):Nodes {
		var firstChildUsed = false;
		if ( this!=null ) {
			for (parent in this) {
				// if the first child has been used, then clone whichever of these is not null
				childNode = (firstChildUsed && childNode!=null ) ? childNode.clone() : childNode; 
				childNodes = (firstChildUsed && childNodes!=null ) ? childNodes.clone() : childNodes;
				parent.append(childNode, childNodes);
				firstChildUsed = true;
			}
		}
		return this;
	}

	/** 
	Prepend the specified child or collection to the start of this node.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function prepend( ?childNode:Node, ?childNodes:Nodes ):Nodes {
		var firstChildUsed = false;
		if ( this!=null ) {
			for ( parent in this ) {
				if ( firstChildUsed==false ) {
					// first time through use the actual nodes without cloning.
					firstChildUsed = true;
				}
				else {
					// clone these so we can attach to every element in collection
					if ( childNode!=null ) childNode = childNode.clone(); 
					if ( childNodes!=null ) childNodes = childNodes.clone(); 
				}

				// now run the prepend from single.DOMManipulation
				parent.prepend( childNode, childNodes );
			}
		}
		return this;
	}

	/** 
	Append this node to the specified parent or collection.

	If a collection is specified, this node will be cloned as required so that
	it will appear in each parent.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function appendTo( ?parentNode:Node, ?parentNodes:Nodes ):Nodes {
		if ( parentNode!=null ) parentNode.append(this);
		if ( parentNodes!=null ) parentNodes.append(this);
		return this;
	}

	/** 
	Prepend this node to the specified parent or collection.

	If a collection is specified, this node will be cloned as required so that
	it will appear in each parent.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function prependTo( ?parentNode:Node, ?parentNodes:Nodes ):Nodes {
		if ( this!=null ) {
			this.reverse();
			for (child in this) {
				child.prependTo( parentNode, parentNodes );
			}
		}
		return this;
	}

	/** 
	Insert this node before the specified target as a sibling.

	If a collection is specified as the target, this node will be cloned as required so that
	it will appear next to each target.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function insertThisBefore( ?targetNode:Node, ?targetNodes:Nodes ):Nodes {
		if ( this!=null ) {
			if ( targetNode!=null ) {
				// insert this collection of content into a single parent
				for (childToAdd in this)
				{
					// insert a single child just before a single target
					childToAdd.insertThisBefore(targetNode);
				}
			}
			if ( targetNodes!=null ) {
				// insert this collection of content just before this collection of targets
				var firstChildUsed = false;
				var childCollection:Nodes = this;
				for ( target in targetNodes ) {
					// if the first childCollection has been used, then clone it
					childCollection = (firstChildUsed) ? childCollection.clone() : childCollection;

					// insert the (possibly cloned) collection into a single target node
					childCollection.insertThisBefore(target);

					// mark as used so next time we clone the children
					firstChildUsed = true;
				}
			}
		}
		return this;
	}

	/** 
	Insert this node after the specified target as a sibling.

	If a collection is specified as the target, this node will be cloned as required so that
	it will appear next to each target.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function insertThisAfter( ?targetNode:Node, ?targetNodes:Nodes ):Nodes {
		if ( this!=null ) {
			if ( targetNode!=null ) {
				// because we are adding many, the target is changing.
				var currentTarget:Node = targetNode;

				// insert this collection of content into a single parent
				for ( childToAdd in this ) {
					childToAdd.insertThisAfter( currentTarget );
					
					// target the next one to go after this one
					currentTarget = childToAdd;
				}
			}
			if ( targetNodes!=null ) {
				// insert this collection of content just before this collection of targets
				var firstChildUsed = false;
				var childCollection:Nodes = this;
				for ( target in targetNodes ) {
					// if the first childCollection has been used, then clone it
					childCollection = (firstChildUsed) ? childCollection.clone() : childCollection;

					// insert the (possibly cloned) collection into a single target node
					childCollection.insertThisAfter(target);

					// mark as used so next time we clone the children
					firstChildUsed = true;
				}
			}
		}
		// insert content (collection) after target (node or collection)
		return this;
	}

	/** 
	Insert the specified node or collection before this node, as a sibling.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function beforeThisInsert( ?contentNode:Node, ?contentNodes:Nodes):Nodes {
		if ( contentNode!=null ) 
			contentNode.insertThisBefore( this );

		if ( contentNodes!=null ) 
			contentNodes.insertThisBefore( this );

		return this;
	}

	/** 
	Insert the specified node or collection after this node, as a sibling.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function afterThisInsert( ?contentNode:Node, ?contentNodes:Nodes):Nodes {
		if ( contentNode!=null ) 
			contentNode.insertThisAfter(this);

		if ( contentNodes!=null ) 
			contentNodes.insertThisAfter(this);

		return this;
	}

	/** 
	Remove this element from the DOM.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function remove():Nodes {
		if ( this!=null ) {
			for (node in this)
			{
				node.remove();
			}
		}
		return this;
	}

	/** 
	Alias for remove()
	**/
	inline public function removeFromDOM():Nodes {
		return remove();
	}

	/** 
	Remove the specified node or collection from this node's children.
	
	If the specified nodes to remove are not a child of this node, no action will occur.

	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function removeChildren( ?childToRemove:Node, ?childrenToRemove:Nodes):Nodes {
		if ( this!=null ) {
			for (parent in this) {
				parent.removeChildren(childToRemove, childrenToRemove);
			}
		}
			
		return this;
	}

	/** 
	Replace this with another node or collection.  This should then be removed from the DOM.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function replaceWith( ?contentNode:Node, ?contentNodes:Nodes):Nodes {
		afterThisInsert(contentNode, contentNodes);
		remove();
		return this;
	}

	/** 
	Empty the current element of all children. 
	
	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function empty():Nodes {
		if ( this!=null )
			for (n in this) n.empty();
		
		return this;
	}

	//
	//
	// EventManagement
	//
	//

		#if js

		/** 
		Trigger the specified event on each node in the collection.

		This will fire all the related handlers and let the event bubble up through the DOM.  If the `eventString` is recognised by the browser,
		it will trigger it's default functionality also.
		
		This method returns the Nodes you started with, so that chaining is enabled.
		**/
		public inline function trigger( eventString:String ):Nodes {
			return each( function (n:Node) n.trigger(eventString) );
		}

		/** 
		Add an event handler for each node in the collection.

		If a selector is supplied, the handler will be called only when a child 
		node matching the selector fires the event.  Otherwise it will call the 
		handler when the event fires on this node.

		If no listener is supplied, it acts as a shortcut for `trigger()` with the
		specified eventType.
		
		This method returns the Nodes you started with, so that chaining is enabled.
		**/
		public inline function on( eventType:String, ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.on(eventType,selector,listener) );

		/** 
		Remove an event handler from any node in the collection.
		
		If both the eventType and the listener are specified, it will only remove
		that specific handler.

		If the eventType is specified but not the handler, all the handlers for 
		that eventType will be removed.

		If the handler is specified but not the eventType, that handler will be 
		removed on all eventTypes.

		If neither is specified, all the handlers attached to this node will be
		removed.
		
		This method returns the Nodes you started with, so that chaining is enabled.
		**/
		public inline function off( ?eventType:String, ?listener:EventListener ):Nodes
			return each( function (n) n.off(eventType,listener) );

		/** 
		Similar to "on", but the handler will only fire the first time.

		After the first time it is fired, the event handler will be removed.
		
		This method returns the Nodes you started with, so that chaining is enabled.
		**/
		public inline function one( eventType:String, ?selector:String, listener:EventListener ):Nodes
			return each( function (n) n.one(eventType,selector,listener) );

		/** Shortcut for `node.on("mousedown", selector, listener)` **/
		public inline function mousedown( ?selector:String, ?listener:MouseEvent->Void ):Nodes
			return each( function (n) n.mousedown(selector,listener) );

		/** Shortcut for `node.on("mouseover", selector, listener)` **/
		public inline function mouseenter( ?selector:String, ?listener:MouseEvent->Void ):Nodes
			return each( function (n) n.mouseenter(selector,listener) );

		/** Shortcut for `node.on("mouseout", selector, listener)` **/
		public inline function mouseleave( ?selector:String, ?listener:MouseEvent->Void ):Nodes
			return each( function (n) n.mouseleave(selector,listener) );

		/** Shortcut for `node.on("mousemove", selector, listener)` **/
		public inline function mousemove( ?selector:String, ?listener:MouseEvent->Void ):Nodes
			return each( function (n) n.mousemove(selector,listener) );

		/** Shortcut for `node.on("mouseout", selector, listener)` **/
		public inline function mouseout( ?selector:String, ?listener:MouseEvent->Void ):Nodes
			return each( function (n) n.mouseout(selector,listener) );

		/** Shortcut for `node.on("mouseover", selector, listener)` **/
		public inline function mouseover( ?selector:String, ?listener:MouseEvent->Void ):Nodes
			return each( function (n) n.mouseover(selector,listener) );

		/** Shortcut for `node.on("mouseup", selector, listener)` **/
		public inline function mouseup( ?selector:String, ?listener:MouseEvent->Void ):Nodes
			return each( function (n) n.mouseup(selector,listener) );

		/** Shortcut for `node.on("keydown", selector, listener)` **/
		public inline function keydown( ?selector:String, ?listener:KeyboardEvent->Void ):Nodes
			return each( function (n) n.keydown(selector,listener) );

		/** Shortcut for `node.on("keypress", selector, listener)` **/
		public inline function keypress( ?selector:String, ?listener:KeyboardEvent->Void ):Nodes
			return each( function (n) n.keypress(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function keyup( ?selector:String, ?listener:KeyboardEvent->Void ):Nodes
			return each( function (n) n.keyup(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function hover( ?selector:String, listener1:MouseEvent->Void, ?listener2:MouseEvent->Void = null ):Nodes
			return each( function (n) n.hover(selector,listener1,listener2) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function submit( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.submit(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function toggleClick( ?selector:String, listenerFirstClick:MouseEvent->Void, listenerSecondClick:MouseEvent->Void ):Nodes
			return each( function (n) n.toggleClick(selector,listenerFirstClick,listenerSecondClick) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function blur( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.blur(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function change( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.change(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function click( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.click(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function dblclick( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.dblclick(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function focus( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.focus(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function focusIn( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.focusIn(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function focusOut( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.focusOut(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function resize( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.resize(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function scroll( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.scroll(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function wheel( ?selector:String, ?listener:js.html.WheelEvent->Void ):Nodes
			return each( function (n) n.wheel(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function select( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.select(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function load( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.load(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function unload( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.unload(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function error( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.error(selector,listener) );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function ready( ?selector:String, ?listener:EventListener ):Nodes
			return each( function (n) n.ready(selector,listener) );

		//
		//
		// Style
		//
		//

		/**
		Get the computed style object for the first node in the collection.
		**/
		public var computedStyle(get,never):CSSStyleDeclaration;
		inline function get_computedStyle()
			return first.computedStyle;
		
		/**
		Get the computed style for the specified property for the first node in the collection.

		The underlying implementation is simply:

		`computedStyle.getPropertyValue(prop)`

		so no cross-browser compatibility is taken into account.

		This method does not provide null safety.
		**/
		public inline function css( prop:String )
			return first.css( prop );

		/**
		Set's the specified property and value on the element's style object.

		The underlying implementation is fairly simple:
		
		`Reflect.setField( node.style, prop, val );`

		so no cross-browser compatibility is taken into account.

		This method returns the Nodes you started with, so that chaining is enabled.
		**/
		public inline function setCSS( prop:String, val:String ):Nodes 
			return each( function (n) n.setCSS(prop,val) );

		/**
		Set's the element's "display" property to "" (an empty string), which
		will undo a "display: hidden" style directive.
		
		If the node is not an element, this has no effect.

		This method returns the Nodes you started with, so that chaining is enabled.
		**/
		public inline function show():Nodes
			return each( function (n) n.show() );

		/**
		Set's the element's "display" property to "none", hiding the element.
		
		If the node is not an element, this has no effect.

		This method returns the Node you started with, so that chaining is enabled.
		**/
		public inline function hide():Nodes
			return each( function (n) n.hide() );

		/**
		The position of the first element in the collection.

		The co-ordinates are calculated using offsetTop, offsetLeft, 
		offsetWidth and offsetHeight

		If the node is not an element, the value of each dimension in the 
		returned position is 0.
		**/
		public var pos(get,never):{ top:Int, left:Int, width:Int, height:Int };
		inline function get_pos()
			return first.pos;

		//
		//
		// Animation
		//
		//

		/* Nothing yet */

	#end
}