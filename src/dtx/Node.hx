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
	import dtx.XMLWrapper;
	import Xml in NodeBase;
#end

/**
An abstract type representing a DOM / Xml node.

The underlying type changes depending on the platform.  On JS it is `js.html.Node`, on 
every other platform it is `Xml`.
**/
abstract Node ( NodeBase )
{
	/**
	Construct a new node based on the underlying data type.
	**/
	inline function new( n: NodeBase )
		this = n;

	//
	//
	// Casts
	//
	//
	
	/** 
	Print the Xml/HTML for the given node.

	Auto casts from `dtx.Node` to `String`.
	
	On Javascript this works by placing the node inside another and using 
	the "innerHTML" property to get a straight printout.

	On other targets, this has a custom printing algorithm that takes into account
	that in HTML only some tags are allowed to self-close, which Xml.toString() gets
	wrong.
	**/
	@:to public inline function toString():String {
		#if js
			return Detox.create("div").append(clone()).innerHTML;
		#else 
			return ( this==null ) ? "" : dtx.single.ElementManipulation.printHtml( this, new StringBuf() ).toString();
		#end
	}

	/** 
	Cast from `Xml` to `dtx.Node`. 

	On Javascript this will create a new object by re-parsing the Xml code.  On 
	other targets it will use the same underlying object.
	**/
	@:from #if !js inline #end static public function fromXml(x:Xml) {
		#if js 
			var nodes = dtx.Tools.parse( x.toString() );
			switch (nodes.length) {
				case 0: new Node( null );
				case 1: Node.fromDom( nodes[0] );
				case _: Node.fromDom( nodes[0].parent );
			}
			return null;
		#else
			return new Node( x ); 
		#end 
	}
	
	/** 
	Cast from `dtx.Node` to `Xml` 

	On Javascript this will create a new object by re-parsing the Xml code.  On 
	other targets it will use the same underlying object.
	**/
	@:to public inline function toXml():Xml {
		#if js 
			return Xml.parse( get_xmlString() );
		#else 
			return this;
		#end
	}
	
	/** Cast from `dtx.Node` to `dtx.Nodes`.  Basically wraps `Node` in an `Array<Node>`. **/
	@:to public inline function toNodes():Nodes {
		return new Nodes(new Node(this));
	}

	#if js
		/** Cast from `NodeBase` to `dtx.Node` **/
		@:from static public inline function fromDom(n:NodeBase):Node {
			return new Node( n );
		}

		/** Cast from `js.html.EventTarget` to `dtx.Node` **/
		@:from static public inline function fromEventTarget(n:EventTarget):Node {
			var node:NodeBase = try cast(n,NodeBase) catch (e:Dynamic) null;
			return new Node( node );
		}

		/** Cast from `dtx.Node` to `NodeBase` **/
		@:to public inline function toDom():NodeBase {
			return this;
		}

		/** Cast from `dtx.Node` to `NodeBase` **/
		@:to public inline function toElement():js.html.Element {
			return isElement() ? cast this : null;
		}

		/** Cast from `dtx.Node` to `NodeBase` **/
		@:to public inline function toDocument():js.html.Document {
			return isDocument() ? cast this : null;
		}
	#end

	//
	//
	// ElementManipulation
	//
	//

	/** 
	The nodeValue of the current Node. 

	If the node is an element or document, it returns "".

	When setting, it only has effect on nodes that are not a document or element.
	**/
	public var nodeValue(get,set):String;
	inline function get_nodeValue():String 
		return if (isElement() || isDocument()) "" else this.nodeValue;
	inline function set_nodeValue( val:String ):String {
		if (!isElement() && !isDocument()) this.nodeValue = val; 
		return val;
	}

	/** 
	The nodeType of the current Node. 

	If the node is an element or document, it returns "".
	**/
	public var nodeType(get,never):#if js Int #else Xml.XmlType #end;
	inline function get_nodeType():#if js Int #else Xml.XmlType #end 
		return this.nodeType;

	/** Returns true if this Node is an element.  If node is "null", it returns false. **/
	inline public function isElement():Bool 
		return this != null && this.nodeType == DOMType.ELEMENT_NODE;

	/** Returns true if this Node is a comment.  If node is "null", it returns false. **/
	inline public function isComment():Bool 
		return this != null && this.nodeType == DOMType.COMMENT_NODE;

	/** Returns true if this Node is a text node.  If node is "null", it returns false. **/
	inline public function isTextNode():Bool 
		return this != null && this.nodeType == DOMType.TEXT_NODE;

	/** Returns true if this Node is a document.  If node is "null", it returns false. **/
	inline public function isDocument():Bool 
		return this != null && this.nodeType == DOMType.DOCUMENT_NODE;

	/** 
	Returns the index of this particular node in relation to it's siblings.  
	The index is zero-based, so the first child has an index of 0. 
	Returns -1 if parent is null. 

	Read only.
	**/
	public var index(get,never):Int;
	inline function get_index():Int
		return dtx.single.ElementManipulation.index( this );
	
	/**
	Tells if a given node has the specified attribute.

	If the Node is not an Element then this returns false.
	**/
	inline public function hasAttr( attName:String ):Bool 
		return dtx.single.ElementManipulation.hasAttr( this, attName );

	/** 
	Returns the value of the given attribute on this Node.

	If the Node is not an Element, or if the attribute is not present, it returns "" (an empty string).

	Can be used with array access:

	    node[title]; // Return the title attribute from the given node.
	**/
	@:arrayAccess inline public function attr( attName:String ):String 
		return dtx.single.ElementManipulation.attr( this, attName );

	/** 
	Sets the value of the attribute on this Node.

	If the Node is not an Element, it has no effect.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function setAttr( attName:String, attValue:String ):Node 
		return dtx.single.ElementManipulation.setAttr( this, attName, attValue );
	
	/**
	Same as `setAttr()`, but provides array write access for setting attributes.

	    node[title] = "My Element";

	Also returns the value set, rather than the node.
	**/
	@:arrayAccess inline function setAttrArrayWrite<T>(attName:String, attValue:String):String {
		setAttr( attName, attValue );
		return attValue;
	}
	
	/**
	Remove the given attribute from this node.  

	If the Node is not an Element or if the attribute was not present, this has no effect.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function removeAttr( attName:String ):Node
		return dtx.single.ElementManipulation.removeAttr( this, attName );

	/**
	Tells if the given node has the specified class (or classes) in the Node's "class" attribute.

	To check for multiple classes, separate class names with a space.

	If the Node is not an Element, or does not have a "class" attribute, this returns false
	**/
	inline public function hasClass( className:String ):Bool 
		return dtx.single.ElementManipulation.hasClass( this, className );

	/**
	Add the given class (or classes) to the Node's "class" attribute.

	Separate multiple class names with a space.  Additional whitespace will be trimmed.

	If the Node is not an Element, or already has the given class, this has no effect.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function addClass( className:String ):Node 
		return dtx.single.ElementManipulation.addClass( this, className );

	/**
	Remove the given class (or classes) to the Node's "class" attribute.

	Separate multiple class names with a space.  Additional whitespace will be trimmed.

	If the Node is not an Element, or does not have the given class, this has no effect.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function removeClass( className:String ):Node 
		return dtx.single.ElementManipulation.removeClass( this, className );

	/**
	Toggle the given class (or classes) to the Node's "class" attribute.

	If the class already exists, it will be removed.  If it does not, it will be added.

	Separate multiple class names with a space.  Additional whitespace will be trimmed.

	If the Node is not an Element this has no effect.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function toggleClass( className:String ):Node 
		return dtx.single.ElementManipulation.toggleClass( this, className );

	/**
	The tag name of the given element, in lowercase.

	If the node is a document, text node or comment node, or other, it 
	returns "#document", "#text", "#comment" or "#other" respectively.

	If the Node is null, it returns "" (an empty string).

	Read only.
	**/
	public var tagName(get,never):String;
	inline function get_tagName():String
		return dtx.single.ElementManipulation.tagName( this );

	/**
	The "value" of the given node.

	If the node is something other than an Element, it will return the nodeValue.
	
	If it is an Element, on Javascript, it checks for a "value" field on the object, 
	as is the case with various input controls.  On other targets, or if a "value" 
	field is not present, it returns the attribute "value" on the given element.

	If the node is null, or the above tests yield no result, it returns "" (an empty string).

	For setting the value, see notes on `setVal()`;
	**/
	public var val(get,set):String;
	inline function get_val():String
		return dtx.single.ElementManipulation.val( this );
	inline function set_val(v:String):String {
		setVal(v);
		return v;
	}

	/**
	Sets the "value" of the given node.
	
	If the Node is not an element, it will set the nodeValue.

	Otherwise, on Javascript, it will attempt to set a "value" field on the object, 
	which will work for input controls etc.  On other targets, it sets the "value" 
	attribute.

	Behaviour on Javascript with elements which do not have a "value" property is undefined.

	If the node is null, this has no effect.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function setVal( val:String ):Node 
		return dtx.single.ElementManipulation.setVal( this, val );

	/**
	The "text" of the given node.

	If the node is something other than an Element, it will return the nodeValue.
	
	If it is an Element, the text content of it's children (and descendants) will be used.

	If the node is null, it returns "" (an empty string).

	For setting the value, see notes on `setText()`.
	**/
	public var text(get,set):String;
	inline function get_text():String
		return dtx.single.ElementManipulation.text( this );
	inline function set_text(v:String):String {
		setText(v);
		return v;
	}

	/**
	Sets the "text" of the given node.
	
	If the Node is not an element, it will set the nodeValue.

	Otherwise, it will replace all of the Element's children with a single text node.

	If the node is null, this has no effect.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function setText( text:String ):Node 
		return dtx.single.ElementManipulation.setText( this, text );

	/**
	Returns the inner HTML of the given node.

	If the node is something other than an Element, it will return the text content.
	
	If it is an Element, it will return the HTML for it's children.

	If the node is null, it returns "" (an empty string).

	For setting the value, see notes on `setInnerHTML()`.
	**/
	public var innerHTML(get,set):String;
	inline function get_innerHTML():String
		return dtx.single.ElementManipulation.innerHTML( this );
	inline function set_innerHTML(v:String):String {
		setInnerHTML(v);
		return v;
	}

	/**
	Sets the inner HTML of the given node.
	
	If the Node is not an element, it will set the text content.

	Otherwise, it will remove all the current child nodes, parse the HTML, and add 
	the resulting nodes as children.

	If the node is null, this has no effect.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function setInnerHTML( html:String ):Node 
		return dtx.single.ElementManipulation.setInnerHTML( this, html );

	/**
	Clone the given element.
	
	Creates an exact copy of the element and all of it's child nodes / descendant nodes.
	**/
	inline public function clone():Node 
		#if js 
			return (this == null) ? null : this.cloneNode(true);
		#else 
			return (this == null) ? null : XMLWrapper.cloneNode(this,true);
		#end

	/**
	Returns the HTML string of the current Node.  Same as `toString()`.

	Read only.
	**/
	public var html(get,never):String;
	inline function get_html():String 
		return toString();

	/**
	Returns the Xml string of the current Node.  

	On JS this is the same as `toString()`.  On other targets it prints the
	output of the `Xml` toString() method, which does not account for the limits
	on self-closing tags in HTML.
	**/
	public var xmlString(get,never):String;
	inline function get_xmlString():String {
		#if js 
			return toString();
		#else
			return this.toString(); 
		#end 
	}

	//
	//
	// Traversing
	//
	//

	/** 
	The nodeValue of the current Node. 

	If the node is an element or document, it returns "".
	**/
	public var hasChildNodes(get,never):Bool;
	inline function get_hasChildNodes():Bool 
		return if (isElement() || isDocument()) children.length>0 else false;

	/**
	A `Nodes` of the child elements of this node.

	If this node is not an element or has no child elements, it will return an empty collection.

	Read only.
	**/
	public var elements(get,never):Nodes;
	inline function get_elements():Nodes 
		return dtx.single.Traversing.children( this, true );

	/**
	A `Nodes` of all the child nodes of the current node, regardless of type.

	If this node is not an element or has no children, it will return an empty collection.

	Read only.
	**/
	public var children(get,never):Nodes;
	inline function get_children():Nodes 
		return dtx.single.Traversing.children( this, false );
	
	/**
	Get the first child of this node.

	If this node is not an element or has no children, it will return null.

	Read only.
	**/
	public var firstChild(get,never):Node;
	inline function get_firstChild():Node 
		return children.first;
	
	/**
	Get the first element of this node.

	If this node is not an element or has no child elements, it will return null.

	Read only.
	**/
	public var firstElement(get,never):Node;
	inline function get_firstElement():Node 
		return elements.first;
	
	/**
	Get the last child of this node.

	If this node is not an element or has no children, it will return null.

	Read only.
	**/
	public var lastChild(get,never):Node;
	inline function get_lastChild():Node 
		return children.last;
	
	/**
	Get the last element of this node.

	If this node is not an element or has no child elements, it will return null.

	Read only.
	**/
	public var lastElement(get,never):Node;
	inline function get_lastElement():Node 
		return elements.last;

	/**
	The parent node.

	If this node has no parent, it will return null.

	Read only.
	**/
	public var parent(get,never):Node;
	inline function get_parent():Node 
		return dtx.single.Traversing.parent( this );

	/**
	A `Nodes` of all ancestor nodes, from this node's parent upwards.

	If this node has no parent, it will return an empty collection.

	Read only.
	**/
	public var ancestors(get,never):Nodes;
	inline function get_ancestors():Nodes 
		return dtx.single.Traversing.ancestors( this );

	/**
	A `Nodes` of all descendant elements, from this node's descendants down.

	Non-elements will not be included.  

	If this node has no child elements, it will return an empty collection.

	Read only.
	**/
	public var descendantElements(get,never):Nodes;
	inline function get_descendantElements():Nodes 
		return dtx.single.Traversing.descendants( this, true );

	/**
	A `Nodes` of all descendant nodes, from this node's descendants down.

	If this node has no children, it will return an empty collection.

	Read only.
	**/
	public var descendants(get,never):Nodes;
	inline function get_descendants():Nodes 
		return dtx.single.Traversing.descendants( this, false );

	/**
	The next sibling node that is an element.

	If this node has no next siblings that are elements, or it is null, it will return null.

	Read only.
	**/
	public var nextElement(get,never):Node;
	inline function get_nextElement():Node 
		return dtx.single.Traversing.next( this, true );

	/**
	The next sibling node.

	If this node has no next siblings, or is null, it will return null.

	Read only.
	**/
	public var next(get,never):Node;
	inline function get_next():Node 
		return dtx.single.Traversing.next( this, false );

	/**
	The prev sibling node that is an element.

	If this node has no prev siblings that are elements, or it is null, it will return null.

	Read only.
	**/
	public var prevElement(get,never):Node;
	inline function get_prevElement():Node 
		return dtx.single.Traversing.prev( this, true );

	/**
	The prev sibling node.

	If this node has no prev siblings, or is null, it will return null.

	Read only.
	**/
	public var prev(get,never):Node;
	inline function get_prev():Node 
		return dtx.single.Traversing.prev( this, false );

	/**
	Do a search using a CSS selector, and return the result as a `Nodes`.

	On Javascript, it will use `document.querySelectorAll` if available, or will
	attempt to fall back to Sizzle, jQuery, or a generic `$()` function.

	On other targets, `selecthxml.SelectDom.runtimeSelect` will be used.

	If no results are found, or if the current node is not an element or 
	document, it will return an empty collection.

	Please note this function does not work inside macros.
	**/
	inline public function find( selector:String ):Nodes 
		return dtx.single.Traversing.find( this, selector );

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
	public function append( ?n:Node, ?c:Nodes ):Node {
		if ( this!=null ) {
			if ( n!=null ) 
				#if js 
					this.appendChild( n );
				#else
					dtx.XMLWrapper.appendChild( this, n ); 
				#end 

			if ( c!=null )
				for (n in c)
					#if js 
						this.appendChild( n );
					#else
						dtx.XMLWrapper.appendChild( this, n ); 
					#end 
		}
		return this;
	}

	/** 
	Prepend the specified child or collection to the start of this node.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function prepend( ?childToAdd:Node, ?childrenToAdd:Nodes ):Node {
		if ( this!=null ) {
			if ( childToAdd!=null ) {
				if ( hasChildNodes ) childToAdd.insertThisBefore( children.first );
				else append( childToAdd );
			}
			if (childrenToAdd != null) {
				childrenToAdd.insertThisBefore(children.first);
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
	public function appendTo( ?parentNode:Node, ?parentNodes:Nodes ):Node {
		if (parentNode != null) {
			parentNode.append( this );
		}
		if (parentNodes != null) {
			parentNodes.append( this );
		}

		return this;
	}

	/** 
	Prepend this node to the specified parent or collection.

	If a collection is specified, this node will be cloned as required so that
	it will appear in each parent.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function prependTo( ?parentNode:Node, ?parentNodes:Nodes ):Node {
		if ( parentNode!=null ) {
			if ( parentNode.hasChildNodes ) {
				insertThisBefore( parentNode.children.first, parentNodes );
			}
			else {
				parentNode.append( this );
			}
		}
		if ( parentNodes!=null ) {
			parentNodes.prepend(this);
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
	public function insertThisBefore( ?targetNode:Node, ?targetNodes:Nodes ):Node {
		if ( this!=null ) {
			if ( targetNode!=null ) {
				var parent = targetNode.parent; 
				if ( parent!=null ) {
					#if js
						parent.toDom().insertBefore(this, targetNode);
					#else 
						dtx.XMLWrapper.insertBefore(parent, this, targetNode);
					#end
				}
			}
			if ( targetNodes!=null ) {
				var firstChildUsed = false;
				for ( target in targetNodes ) {
					var childToInsert = firstChildUsed ? clone() : this;
					var parent:Node = target.parent;
					if (parent != null) {
						#if js
							parent.toDom().insertBefore(childToInsert, target);
						#else 
							dtx.XMLWrapper.insertBefore(parent, childToInsert, target);
						#end
					}
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
	public function insertThisAfter( ?targetNode:Node, ?targetNodes:Nodes):Node {
		if ( this!=null ) {
			if ( targetNode!=null ) {
				var next = targetNode.next;
				var parent = targetNode.parent;
				if ( parent!=null ) {
					if ( next!=null )
						#if js
							parent.toDom().insertBefore( this, next );
						#else 
							dtx.XMLWrapper.insertBefore( parent, this, next );
						#end
					else 
						#if js
							parent.toDom().appendChild(this);
						#else 
							dtx.XMLWrapper.appendChild( parent, this );
						#end
				}
			}
			if ( targetNodes!=null ) {
				var firstChildUsed = false;
				for (target in targetNodes) {
					// clone the child if we've already used it
					var childToInsert = (firstChildUsed) ? clone() : this;
					
					var next = target.next;
					if ( next!=null ) {
						// add the (possibly cloned) child after.the target
						// (that is, before the targets next sibling)
						var parent:Node = target.parent;
						if (parent != null)
							#if js
								parent.toDom().insertBefore( childToInsert, next );
							#else 
								dtx.XMLWrapper.insertBefore( parent, childToInsert, next );
							#end
					}
					else {
						// add the (possibly cloned) child after the target
						// by appending it to the very end of the parent
						target.parent.append( childToInsert );
					}
					
					firstChildUsed = true;
				}
			}
		}
		return this;
	}

	/** 
	Insert the specified node or collection before this node, as a sibling.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function beforeThisInsert( ?contentNode:Node, ?contentNodes:Nodes):Node {
		if ( this!=null ) {
			if ( contentNode!=null )
				contentNode.insertThisBefore( this );
			if ( contentNodes!=null )
				contentNodes.insertThisBefore(this);
		}
		return this;
	}

	/** 
	Insert the specified node or collection after this node, as a sibling.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function afterThisInsert( ?contentNode:Node, ?contentNodes:Nodes):Node {
		if ( this!=null ) {
			if ( contentNode!=null )
				contentNode.insertThisAfter(this);
			if ( contentNodes!=null )
				contentNodes.insertThisAfter(this);
		}
		return this;
	}

	/** 
	Remove this element from the DOM.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function remove():Node{
		if (this != null) {
			#if js 
				var parent = this.parentNode;
			#else 
				var parent = this.parent;
			#end 

			if ( parent!=null ) parent.removeChild(this);
		}
		return this;
	}

	/** 
	Alias for remove()
	**/
	inline public function removeFromDOM():Node
		return remove();

	/** 
	Remove the specified node or collection from this node's children.
	
	If the specified nodes to remove are not a child of this node, no action will occur.

	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function removeChildren( ?child:Node, ?children:Nodes):Node {
		if ( this!=null ) {
			if ( child!=null &&  child.parent == this)
				this.removeChild(child);

			if ( children!=null )
				for ( child in children )
					if (child.parent == this) this.removeChild(child);
		}
		return this;
	}

	/** 
	Replace this with another node or collection.  This should then be removed from the DOM.
	
	This method is null-safe, any null values will be silently ignored.

	This method returns the Node you started with, so that chaining is enabled.
	**/
	public function replaceWith( ?contentNode:Node, ?contentNodes:Nodes):Node {
		afterThisInsert( contentNode, contentNodes );
		remove();
		return this;
	}

	/** 
	Empty the current element of all children. 
	
	This method returns the Node you started with, so that chaining is enabled.
	**/
	inline public function empty():Node {
		if (this != null) {
			while (hasChildNodes) 
				this.removeChild(children.first);
		}
		return this;
	}

	#if js

		//
		//
		// EventManagement
		//
		//

		/** 
		Trigger the specified event on this node.

		This will fire all the related handlers and let the event bubble up through the DOM.  If the `eventString` is recognised by the browser,
		it will trigger it's default functionality also.
		
		This method returns the Node you started with, so that chaining is enabled.
		**/
		public inline function trigger( eventString:String ):Node
			return dtx.single.EventManagement.trigger( this, eventString );

		/** 
		Add an event handler for this node.

		If a selector is supplied, the handler will be called only when a child 
		node matching the selector fires the event.  Otherwise it will call the 
		handler when the event fires on this node.

		If no listener is supplied, it acts as a shortcut for `trigger()` with the
		specified eventType.
		
		This method returns the Node you started with, so that chaining is enabled.
		**/
		public inline function on( eventType:String, ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.on( this, eventType, selector, listener );

		/** 
		Remove an event handler from this node.
		
		If both the eventType and the listener are specified, it will only remove
		that specific handler.

		If the eventType is specified but not the handler, all the handlers for 
		that eventType will be removed.

		If the handler is specified but not the eventType, that handler will be 
		removed on all eventTypes.

		If neither is specified, all the handlers attached to this node will be
		removed.
		
		This method returns the Node you started with, so that chaining is enabled.
		**/
		public function off( ?eventType:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.off( this, eventType, listener );

		/** 
		Similar to "on", but the handler will only fire the first time.

		After the first time it is fired, the event handler will be removed.
		
		This method returns the Node you started with, so that chaining is enabled.
		**/
		public function one( eventType:String, ?selector:String, listener:EventListener ):Node
			return dtx.single.EventManagement.one( this, eventType, selector, listener );

		/** Shortcut for `node.on("mousedown", selector, listener)` **/
		public inline function mousedown( ?selector:String, ?listener:MouseEvent->Void ):Node
			return dtx.single.EventManagement.mousedown( this, selector, listener );

		/** Shortcut for `node.on("mouseover", selector, listener)` **/
		public inline function mouseenter( ?selector:String, ?listener:MouseEvent->Void ):Node
			return dtx.single.EventManagement.mouseover( this, selector, listener );

		/** Shortcut for `node.on("mouseout", selector, listener)` **/
		public inline function mouseleave( ?selector:String, ?listener:MouseEvent->Void ):Node
			return dtx.single.EventManagement.mouseout( this, selector, listener );

		/** Shortcut for `node.on("mousemove", selector, listener)` **/
		public inline function mousemove( ?selector:String, ?listener:MouseEvent->Void ):Node
			return dtx.single.EventManagement.mousemove( this, selector, listener );

		/** Shortcut for `node.on("mouseout", selector, listener)` **/
		public inline function mouseout( ?selector:String, ?listener:MouseEvent->Void ):Node
			return dtx.single.EventManagement.mouseout( this, selector, listener );

		/** Shortcut for `node.on("mouseover", selector, listener)` **/
		public inline function mouseover( ?selector:String, ?listener:MouseEvent->Void ):Node
			return dtx.single.EventManagement.mouseover( this, selector, listener );

		/** Shortcut for `node.on("mouseup", selector, listener)` **/
		public inline function mouseup( ?selector:String, ?listener:MouseEvent->Void ):Node
			return dtx.single.EventManagement.mouseup( this, selector, listener );

		/** Shortcut for `node.on("keydown", selector, listener)` **/
		public inline function keydown( ?selector:String, ?listener:KeyboardEvent->Void ):Node
			return dtx.single.EventManagement.keydown( this, selector, listener );

		/** Shortcut for `node.on("keypress", selector, listener)` **/
		public inline function keypress( ?selector:String, ?listener:KeyboardEvent->Void ):Node
			return dtx.single.EventManagement.keypress( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function keyup( ?selector:String, ?listener:KeyboardEvent->Void ):Node
			return dtx.single.EventManagement.keyup( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function hover( ?selector:String, listener1:MouseEvent->Void, ?listener2:MouseEvent->Void = null ):Node
			return dtx.single.EventManagement.hover( this, selector, listener1, listener2 );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function submit( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.submit( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function toggleClick( ?selector:String, listenerFirstClick:MouseEvent->Void, listenerSecondClick:MouseEvent->Void ):Node
			return dtx.single.EventManagement.toggleClick( this, selector, listenerFirstClick, listenerSecondClick );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function blur( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.blur( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function change( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.change( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function click( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.click( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function dblclick( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.dblclick( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function focus( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.focus( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function focusIn( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.focusIn( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function focusOut( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.focusOut( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function resize( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.resize( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function scroll( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.scroll( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function wheel( ?selector:String, ?listener:js.html.WheelEvent->Void ):Node
			return dtx.single.EventManagement.wheel( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function select( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.select( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function load( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.load( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function unload( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.unload( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function error( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.error( this, selector, listener );

		/** Shortcut for `node.on("keyup", selector, listener)` **/
		public inline function ready( ?selector:String, ?listener:EventListener ):Node
			return dtx.single.EventManagement.ready( this, selector, listener );

		//
		//
		// Style
		//
		//

		/**
		Get the computed style object for the current node.
		**/
		public var computedStyle(get,never):CSSStyleDeclaration;
		inline function get_computedStyle()
			return dtx.single.Style.getComputedStyle( this );
		
		/**
		Get the computed style for the specified property.

		The underlying implementation is simply:

		`computedStyle.getPropertyValue(prop)`

		so no cross-browser compatibility is taken into account.

		This method does not provide null safety.
		**/
		public inline function css( prop:String )
			return dtx.single.Style.css( this, prop );

		/**
		Set's the specified property and value on the element's style object.

		The underlying implementation is fairly simple:
		
		`Reflect.setField( node.style, prop, val );`

		so no cross-browser compatibility is taken into account.

		This method returns the Node you started with, so that chaining is enabled.
		**/
		public inline function setCSS( prop:String, val:String ):Node
			return dtx.single.Style.setCSS( this, prop, val );

		/**
		Set's the element's "display" property to "" (an empty string), which
		will undo a "display: hidden" style directive.
		
		If the node is not an element, this has no effect.

		This method returns the Node you started with, so that chaining is enabled.
		**/
		public inline function show():Node
			return dtx.single.Style.show( this );

		/**
		Set's the element's "display" property to "none", hiding the element.
		
		If the node is not an element, this has no effect.

		This method returns the Node you started with, so that chaining is enabled.
		**/
		public inline function hide():Node
			return dtx.single.Style.hide( this );

		/**
		The position of the element.

		The co-ordinates are calculated using offsetTop, offsetLeft, 
		offsetWidth and offsetHeight

		If the node is not an element, the value of each dimension in the 
		returned position is 0.
		**/
		public var pos(get,never):{ top:Int, left:Int, width:Int, height:Int };
		inline function get_pos()
			return dtx.single.Style.pos( this );

		//
		//
		// Animation
		//
		//

		/* Nothing yet */

	#end
}