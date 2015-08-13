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

package dtx;

/**
	A typedef pointing to the underlying type for each platform - `js.html.Node` on JS, and `Xml` on other platforms.
**/
private typedef DOMNodeImplementationType = #if js js.html.Node #else Xml #end;

/**
	A generic DOM Node. This is an abstract that wraps the underlying XML/DOM type for each platform.

	On Javascript, this wraps `js.html.Node` and forwards most fields.
	Please note `childNodes` and `attributes` as we chose to expose them with a different type signiature to make cross platform implementations simpler.
	Also note that `hasAttributes`, `getAttribute`, `setAttribute` and `removeAttribute` are also exposed, even though these belong to Element, not Node.

	On other targets, this wraps `Xml` and provides an interface similar to `js.html.Node`.
	Not every property or method is implemented, but enough are implemented to allow our various Detox methods to function correctly.

	Classes for interacting with DOMNode include:

	- `dtx.single.ElementManipulation`
	- `dtx.single.DOMManipulation`
	- `dtx.single.Traversing`
	- `dtx.single.EventManagement`
	- `dtx.single.Style`
**/
#if js
	@:forward(
		nodeType, nodeValue, nodeName,
		parentNode, firstChild, lastChild, nextSibling, previousSibling,
		removeChild, hasChildNodes, appendChild, insertBefore,
		hasAttributes, getAttribute, setAttribute, removeAttribute, // Should these only be on elements?
		textContent, cloneNode,
		addEventListener
		// Notably absent: childNodes, attributes.
		// I considered the implementations too JS specific to replicate on other platforms.
	)
#else
	@:forward(
		nodeType, nodeValue, nodeName,
		removeChild
	)
#end
abstract DOMNode( DOMNodeImplementationType ) from DOMNodeImplementationType to DOMNodeImplementationType {

	public var attributes(get,never):Iterable<{ name:String, value:String }>;
	public var childNodes(get,never):Iterable<DOMNode>;
	#if !js
		public var parentNode(get,never):DOMNode;
		public var firstChild(get,never):DOMNode;
		public var lastChild(get,never):DOMNode;
		public var nextSibling(get,never):DOMNode;
		public var previousSibling(get,never):DOMNode;
		public var textContent(get,set):String;
	#end

	inline function new( n:#if js js.html.Node #else Xml #end ) {
		this=n;
	}

	@:allow(dtx)
	function _getInnerHTML():String {
		#if js
			if ( this.nodeType==DOMType.ELEMENT_NODE ) {
				var elm:js.html.Element = cast this;
				return elm.innerHTML;
			}
			else return null;
		#else
			var html = "";
			for ( child in this ) {
				html += child.toString();
			}
			return html;
		#end
	}

	@:allow(dtx)
	function _setInnerHTML( html:String ):String {
		#if js
			if ( this.nodeType==DOMType.ELEMENT_NODE ) {
				var elm:js.html.Element = cast this;
				elm.innerHTML = html;
			}
		#else
			var xmlDocNode:Xml = null;
			try {
				#if macro
					xmlDocNode = haxe.xml.Parser.parse( "<doc>" + html + "</doc>" ).firstChild();
				#elseif (neko || cpp)
					// Neko's native parser has issues with over-encoding HTML entities.
					// The Haxe based parser is a little better, it at least gets <, &, and > correct.
					xmlDocNode = html.indexOf("&")>-1 ? haxe.xml.Parser.parse( html ) : Xml.parse( html );
				#else
					xmlDocNode = Xml.parse( html );
				#end
			}
			catch ( e:Dynamic ) {
				xmlDocNode = Xml.createDocument();
			}

			_empty();
			for ( child in Lambda.list(xmlDocNode) ) {
				this.addChild( child );
			}
		#end
		return html;
	}

	// Member methods (Platforms other than JS)
	#if !js
		public inline function hasChildNodes():Bool {
			return this.iterator().hasNext();
		}

		public inline function getAttribute( name:String ):String {
			return this.get( name );
		}

		public inline function setAttribute( name:String, value:String ):Void {
			this.set( name, value );
		}

		public inline function removeAttribute( name:String ):Void {
			this.remove( name );
		}

		@:access(Xml)
		public function appendChild( newChild:DOMNode ):DOMNode {
			this.addChild( newChild );
			return newChild;
		}

		@:access(Xml)
		public function insertBefore( newChild:DOMNode, refChild:DOMNode ):DOMNode {
			var targetIndex = 0;
			var iter = this.iterator();
			while ( iter.hasNext() && iter.next()!=refChild ) {
				targetIndex++;
			}
			this.insertChild( newChild, targetIndex );
			return newChild;
		}

		public function removeChild( oldChild:DOMNode ):DOMNode {
			this.removeChild( oldChild );
			return oldChild;
		}

		public function cloneNode( deep:Bool ):DOMNode {
			var clone = switch this.nodeType {
				case Xml.Element: Xml.createElement( this.nodeName );
				case Xml.PCData: Xml.createPCData( this.nodeValue );
				case Xml.CData: Xml.createCData( this.nodeValue );
				case Xml.Comment: Xml.createComment( this.nodeValue );
				case Xml.DocType: Xml.createDocType( this.nodeValue );
				case Xml.ProcessingInstruction: Xml.createProcessingInstruction( this.nodeValue );
				case Xml.Document: Xml.createDocument();
			}
			if ( this.nodeType==Xml.Element ) {
				for ( attName in this.attributes() ) {
					clone.set( attName, this.get(attName) );
				}
			}
			if ( deep && (this.nodeType==Xml.Element || this.nodeType==Xml.Document) ) {
				for ( child in this ) {
					clone.addChild( (child:DOMNode).cloneNode(true) );
				}
			}
			return clone;
		}
	#end

	// Getters (All platforms)

	function get_attributes():Iterable<{ name:String, value:String }> {
		var list = new List();
		#if js
			if ( this.nodeType==js.html.Node.ELEMENT_NODE ) {
				var element:DOMElement = cast this;
				for ( i in 0...element.attributes.length ) {
					var attNode = element.attributes[i];
					list.push({ name: attNode.nodeName, value: attNode.nodeValue });
				}
			}
		#else
			for ( a in this.attributes() ) {
				list.push({ name: a, value: this.get(a) });
			}
		#end
		return list;
	}

	function get_childNodes():Array<DOMNode> {
		var children = [];
		#if js
			for ( i in 0...this.childNodes.length ) {
				children.push( this.childNodes.item(i) );
			}
		#else
			for ( n in this ) {
				children.push( n );
			}
		#end
		return children;
	}

	// Getters (Non JS Platforms)

	#if !js
		inline function get_parentNode():DOMNode {
			return this.parent;
		}

		inline function get_firstChild():DOMNode {
			return this.firstChild();
		}

		function get_lastChild():DOMNode {
			var lastChild:Xml = null;
			if ( this!=null )
				for ( child in this )
					lastChild = child;
			return lastChild;
		}

		@:access(Xml)
		function get_nextSibling():DOMNode {
			var itsTheNextOne = false;
			var p = this.parent;
			if ( p!=null ) {
				for ( child in p ){
					if ( itsTheNextOne ) {
						return child;
						break;
					}
					if ( child==this ) itsTheNextOne = true;
				}
			}
			return null;
		}

		@:access(Xml)
		function get_previousSibling():DOMNode {
			var sibling:Xml = null;
			var p = this.parent;
			if ( p!=null ) {
				for ( child in p ) {
					if ( child!=this ) {
						sibling = child;
					}
					else {
						// If it's equal, leave "sibling" set to the previous value,
						// and exit the loop...
						break;
					}
				}
			}
			return sibling;
		}

		function get_textContent():String {
			var ret = "";
			if ( this.nodeType==dtx.DOMType.ELEMENT_NODE || this.nodeType==dtx.DOMType.DOCUMENT_NODE ) {
				var allDescendants = dtx.single.Traversing.descendants( this, false );
				var textDescendants = allDescendants.filter(function(x:Xml) {
					return x.nodeType==dtx.DOMType.TEXT_NODE;
				});

				var s = new StringBuf();
				for ( textNode in textDescendants ) {
					s.add( textNode.nodeValue );
				}

				ret = s.toString();
			}
			else {
				ret = this.nodeValue;
			}
			return ret;
		}

		function _empty():Void {
			for ( child in Lambda.list(this) ) {
				removeChild( child );
			}
		}

		function set_textContent( text:String ):String {
			if ( this.nodeType==dtx.DOMType.ELEMENT_NODE || this.nodeType==dtx.DOMType.DOCUMENT_NODE ) {
				_empty();
				var textNode = Xml.createPCData( text );
				this.addChild( textNode );
			}
			else {
				this.nodeValue = text;
			}
			return text;
		}
	#end
}

/**
	A generic DOM Element.

	Similar to `dtx.DOMNode` this changes depending on the platform.
	`DOMElement` is a typedef alias for `js.html.Element` on Javascript, and `DOMNode` on other platforms.

	At some point it may be worth changing this as now that DOMNode is an abstract, this extension is sometimes awkward and leads to unexpected behaviour.
**/
typedef DOMElement =
	#if (js && haxe_ver >= "3.2")
		js.html.DOMElement
	#elseif (js)
		js.html.Element
	#else
		DOMNode
	#end;

/**
	An element that can contain other elements.

	On JS this is a typedef capable of using `querySelector` and `querySelectorAll`, so usually an Element or a Document.
	On other platforms this is simple an alias for `Xml`.
**/
abstract DocumentOrElement(DOMNode) to DOMNode {
	inline function new(n:DOMNode) {
		this = n;
	}

	#if js
		/** Allow casts from Element **/
		@:from static inline function fromElement( e:js.html.Element ) return new DocumentOrElement( e );

		/** Allow casts from Document **/
		@:from static inline function fromDocument( d:js.html.Document ) return new DocumentOrElement( d );

		/** Allow access to the `querySelector` function **/
		public inline function querySelector( selectors:String ):js.html.Element return untyped this.querySelector( selectors );

		/** Allow access to the `querySelectorAll` function **/
		public inline function querySelectorAll( selectors:String ):js.html.NodeList return untyped this.querySelectorAll( selectors );
	#else
		/** On non-JS platforms, all nodes are Xml objects, and all can be used with the `selecthxml` selector engine, so accept casts from all nodes. **/
		@:from static inline function fromXml( x:Xml ) return new DocumentOrElement( x );
	#end
}
