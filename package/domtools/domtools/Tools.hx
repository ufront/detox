/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools;

import js.w3c.level3.Core;
import CommonJS; 
import domtools.Query;
import js.w3c.css.CSSOM;

/** 
* Designed to be used with "using domtools.Tools;" this gives you access
* to all of the classes defined in this module.  These include
*   - ElementManipulation
*   - DOMManipulation
*   - Traversing
*   - EventManagement (Client JS only)
*   - Style (Client JS only?)
*   - Animation (Client JS only)
* 
* I have so far made no effort at making these work cross platform,
* though I am designing unit tests which should hopefully simplify the process.
* 
* The API is designed to be similar to JQuery, though not as complete
* nor as robust in the cross-platform department.  JQuery will still be the
* better pick for many client side projects.
*
* There are a few advantages
*  - better integration into haxe's Object Oriented style
*  - hopefully a smaller codebase, thanks to Dead Code Elimination
*  - works with native DOMNode or XMLNode, can work without wrapping
*  - works on non-js haxe platforms, hopefully
*/

class Tools 
{
	function new()
	{
		
	}
}

//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------
//
// ELEMENT MANIPULATION
//
//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------

/*
JQuery has these classes, let's copy:

	//later? outerHTML()
	//later? setOuterHTML()
	clone() - create a deep copy of this set of matched elements
*/ 


class ElementManipulation
{
	static var NodeTypeElement = 1;
	static var NodeTypeAttribute = 2;
	static var NodeTypeText = 3;

	public static function isElement(node:Node):Bool
	{
		return node.nodeType == NodeTypeElement;
	}

	public static function attr(elm:Node, attName:String):String
	{
		var ret = "";
		if (isElement(elm))
		{
			var element:Element = cast elm;
			ret = element.getAttribute(attName);
			if (ret == null) ret = "";
		}
		return ret;
	}

	public static function setAttr(elm:Node, attName:String, attValue:String):Node
	{
		if (elm.nodeType == NodeTypeElement)
		{
			var element:Element = cast elm;
			element.setAttribute(attName, attValue);
		}
		return elm;
	}

	public static function removeAttr(elm:Node, attName:String):Node
	{
		if (elm.nodeType == NodeTypeElement)
		{
			var element:Element = cast elm;
			element.removeAttribute(attName);
		}
		return elm;
	}

	public static function hasClass(elm:Node, className:String):Bool
	{
		return ((" " + attr(elm, "class") + " ").indexOf(" " + className + " ") > -1);
	}

	public static function addClass(elm:Node, className:String):Node
	{
		if (hasClass(elm, className) == false)
		{
			var oldClassName = attr(elm, "class");
			var newClassName =  (oldClassName == "") ? className : oldClassName + " " + className;
			setAttr(elm, "class", newClassName);
		}
		
		return elm;
	}

	public static function removeClass(elm:Node, className:String):Node
	{
		// Get the current list of classes
		var classes = attr(elm, "class").split(" ");

		// Remove the current one, re-assemble as a string
		classes.remove(className);
		var newClassValue = classes.join(" ");

		setAttr(elm, "class", newClassValue);
		
		return elm;
	}

	public static function toggleClass(elm:Node, className:String):Node
	{
		if (hasClass(elm, className))
		{
			removeClass(elm,className);
		}
		else 
		{
			addClass(elm,className);
		}
		return elm;
	}

	public static inline function tagName(elm:Node):String
	{
		return elm.nodeName.toLowerCase();
	}

	public static inline function val(elm:Node):String
	{
		return attr(elm,"value");
	}
	
	public static inline function text(elm:Node):String
	{
		return elm.textContent;
	}
	
	public static inline function setText(elm:Node, text:String):Node
	{
		return { elm.textContent = text; elm; };
	}

	public static function innerHTML(elm:Node):String
	{
		var ret = "";
		switch (elm.nodeType)
		{
			case NodeTypeElement:
				var element:Element = cast elm;
				ret = element.innerHTML;
			default:
				ret = elm.textContent;
		}
		return ret;
	}

	public static function setInnerHTML(elm:Node, html:String):Node
	{
		switch (elm.nodeType)
		{
			case NodeTypeElement:
				var element:Element = cast elm;
				element.innerHTML = html;
			default:
				elm.textContent = html;
		}
		return elm;
	}

	public static inline function clone(elm:Node, ?deep:Bool = true):Node
	{
		return elm.cloneNode(deep);
	}

}

class QueryElementManipulation
{
	/** Assume we're operating on the first element. */
	public static function attr(query:Query, attName:String):String
	{
		return (query.length > 0) ? ElementManipulation.attr(query.getNode(), attName) : "";
	}

	public static function setAttr(query:Query, attName:String, attValue:String):Query
	{
		for (node in query)
		{
			ElementManipulation.setAttr(node, attName, attValue);
		}
		return query;
	}

	public static function removeAttr(query:Query, attName:String):Query
	{
		for (node in query)
		{
			ElementManipulation.removeAttr(node,attName);
		}
		return query;
	}

	/** Checks if the first element in the collection has the given class */
	public static function hasClass(query:Query, className:String):Bool
	{
		return (query.length > 0) ? ElementManipulation.hasClass(query.getNode(), className) : false;
	}

	public static function addClass(query:Query, className:String):Query
	{
		for (node in query)
		{
			ElementManipulation.addClass(node,className);
		}
		return query;
	}

	public static function removeClass(query:Query, className:String):Query
	{
		for (node in query)
		{
			ElementManipulation.removeClass(node,className);
		}
		return query;
	}

	public static function toggleClass(query:Query, className:String):Query
	{
		for (node in query)
		{
			ElementManipulation.toggleClass(node,className);
		}
		return query;
	}

	public static function tagName(query:Query):String
	{
		return (query.length > 0) ? query.getNode().nodeName.toLowerCase() : "";
	}

	public static function tagNames(query:Query):Array<String>
	{
		var names = new Array<String>();
		for (node in query)
		{
			names.push(node.nodeName.toLowerCase());
		}
		return names;
	}

	public static function val(query:Query):String
	{
		return (query.length > 0) ? ElementManipulation.val(query.getNode()) : "";
	}
	
	public static function text(query:Query):String
	{
		var text = "";
		for (node in query)
		{
			text = text + ElementManipulation.text(node);
		}
		return text;
	}
	
	public static function setText(query:Query, text:String):Query
	{
		for (node in query)
		{
			ElementManipulation.setText(node,text);
		}
		return query;
	}

	public static function innerHTML(query:Query):String
	{
		var ret = "";
		for (node in query)
		{
			ret += ElementManipulation.innerHTML(node);
		}
		return ret;
	}

	public static function setInnerHTML(query:Query, html:String):Query
	{
		for (node in query)
		{
			ElementManipulation.setInnerHTML(node,html);
		}
		return query;
	}

	public static function clone(query:Query, ?deep:Bool = true):Query
	{
		var newQuery = new Query();
		for (node in query)
		{
			newQuery.add(ElementManipulation.clone(node));
		}
		return newQuery;
	}

}



//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------
//
// DOM MANIPULATION
//
//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------

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
			QueryDOMManipulation.insertThisBefore(newChildCollection, parent.firstChild);
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
			QueryDOMManipulation.append(parentCollection, child);
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
			QueryDOMManipulation.insertThisBefore(contentQuery, target);
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
			QueryDOMManipulation.insertThisAfter(contentQuery, target);
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

class QueryDOMManipulation
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
			DOMManipulation.append(parent, childNode, childCollection);
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
			DOMManipulation.prepend(parent, childNode, childCollection);
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
			DOMManipulation.append(parentNode, children);
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
		return insertThisBefore(children, parentNode.firstChild, QueryTraversing.firstChildren(parentCollection));
	}

	static public function insertThisBefore(content:Query, ?targetNode:Node = null, ?targetCollection:Query = null)
	{
		if (targetNode != null)
		{
			// insert this collection of content into a single parent
			for (childToAdd in content)
			{
				// insert a single child just before a single target
				DOMManipulation.insertThisBefore(childToAdd, targetNode);
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
		return insertThisBefore(content, targetNode.nextSibling, QueryTraversing.next(targetCollection));
	}

	static public inline function beforeThisInsert(target:Query, contentNode:Node, contentCollection:Query)
	{
		if (contentNode != null)
		{
			// before this target (multiple), insert content (single)
			DOMManipulation.insertThisBefore(contentNode, target);
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
			DOMManipulation.insertThisAfter(contentNode, target);
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
			DOMManipulation.remove(node);
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

//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------
//
// TRAVERSING
//
//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------

/*
	parentsUntil(selector)
	nextAll
	nextUntil
	prevAll
	prevUntil
	siblings
	closest() - 
*/



/** When returning a Null<Node>, it might be worth creating a static NullNode that won't generate errors (so we can chain easily and carelessly) but also not affect the DOM.   For now I'll leave it null.  */
class Traversing
{
	/** Return a collection of all child nodes of the current node. */
	static public function children(node:Node, ?elementsOnly = true)
	{
		var children = new Query();
		if (ElementManipulation.isElement(node))
		{
			// Add any child elements
			children.addNodeList(node.childNodes, elementsOnly);
		}
		return children;
	}

	static public function firstChildren(node:Node, ?elementsOnly = true)
	{
		var firstChild:Node = null;
		if (ElementManipulation.isElement(node))
		{
			// Add first child node that is an element
			var e = node.firstChild;
			while (elementsOnly == true && e != null && ElementManipulation.isElement(e) == false)
			{
				e = e.nextSibling;
			}
			if (e != null) firstChild = e;
		}
		return firstChild;
	}

	static public function lastChildren(node:Node, ?elementsOnly = true)
	{
		var lastChild:Node = null;
		if (ElementManipulation.isElement(node))
		{
			// Add first child node that is an element
			var e = node.lastChild;
			while (elementsOnly == true && e != null && ElementManipulation.isElement(e) == false)
			{
				e = e.previousSibling;
			}
			if (e != null) lastChild = e;
		}
		return lastChild;
	}

	/** Gets the direct parents of each element in the collection. */
	static public function parent(node:Node)
	{
		return (node.parentNode != null) ? node.parentNode : null;
	}

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function ancestors(node:Node)
	{
		// start with the direct parents
		var ancestors = new Query();
		ancestors.add(parent(node));

		// if there were any parents on this round, then add the parents of the parents, recursively
		if (ancestors.length > 0)
		{
			ancestors.addCollection(QueryTraversing.parent(ancestors));
		}

		return ancestors;
	}

	static public function next(node:Node)
	{
		return (node.nextSibling != null) ? node.nextSibling : null;
	}

	static public function prev(node:Node)
	{
		return (node.previousSibling != null) ? node.previousSibling : null;
	}

	static public function find(node:Node, selector:String)
	{
		var newQuery = new Query();
		if (ElementManipulation.isElement(node))
		{
			var element:Element = cast node;
			newQuery.addNodeList(element.querySelectorAll(selector));
		}
		return newQuery;
	}
}

class QueryTraversing
{
	/** Return a new collection of all child nodes of the current collection. */
	static public function children(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		for (node in query)
		{
			if (ElementManipulation.isElement(node))
			{
				// Add any child elements
				children.addNodeList(node.childNodes, elementsOnly);
			}
		}
		return children;
	}

	static public function firstChildren(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		for (node in query)
		{
			if (ElementManipulation.isElement(node))
			{
				// Add first child node that is an element
				var e = node.firstChild;
				while (elementsOnly == true && e != null && ElementManipulation.isElement(e) == false)
				{
					e = e.nextSibling;
				}
				if (e != null) children.add(e);
			}
		}
		return children;
	}

	static public function lastChildren(query:Query, ?elementsOnly = true)
	{
		var children = new Query();
		for (node in query)
		{
			if (ElementManipulation.isElement(node))
			{
				// Add first child node that is an element
				var e = node.lastChild;
				while (elementsOnly == true && e != null && ElementManipulation.isElement(e) == false)
				{
					e = e.previousSibling;
				}
				if (e != null) children.add(e);
			}
		}
		return children;
	}

	/** Gets the direct parents of each element in the collection. */
	static public function parent(query:Query)
	{
		var parents = new Query();
		for (node in query)
		{
			if (node.parentNode != null)
				parents.add(node.parentNode);
		}
		return parents;
	}

	/** Gets all parents of the current collection, and is called recursively to get all ancestors. */
	static public function ancestors(query:Query)
	{
		// start with the direct parents
		var ancestors = parent(query);

		// then add the parents of the parents, recursively
		if (ancestors.length > 0)
		{
			ancestors.addCollection(parent(ancestors));
		}

		return ancestors;
	}

	static public function next(query:Query)
	{
		var siblings = new Query();
		for (node in query)
		{
			var sibling = node.nextSibling;
			if (sibling != null) siblings.add(sibling);
		}
		return siblings;
	}

	static public function prev(query:Query)
	{
		var siblings = new Query();
		for (node in query)
		{
			var sibling = node.previousSibling;
			if (sibling != null) siblings.add(sibling);
		}
		return siblings;
	}

	static public function find(query:Query, selector:String)
	{
		var newQuery = new Query();
		for (node in query)
		{
			if (ElementManipulation.isElement(node))
			{
				var element:Element = cast node;
				newQuery.addNodeList(element.querySelectorAll(selector));
			}
		}
		return newQuery;
	}
}


//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------
//
// STYLE
//
//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------

/* 
Functionality to implement:
	innerHeight
	innerWidth
	css() - 
	offset()
	offsetParent()
	scrollLeft - int
	scrollTop - int
	position(top, left)
	width()
	height() - 
	outerHeight()
	outerWidth()
*/

class Style
{
	public static function getComputedStyle(node:Node)
	{
		var style:CSSStyleDeclaration = null;
		if (ElementManipulation.isElement(node))
		{
			//style = Query.window.getComputedStyle(cast node).width;
		}
		return style;
	}

	
	public static function css(node:Node, property:String)
	{
		getComputedStyle(node).getPropertyValue("property");
	}

	public static function setCSS(node:Node, property:String, value:String)
	{
		if (ElementManipulation.isElement(node))
		{
			var style:Dynamic = untyped node.style;
			Reflect.setField(style, property, value);
		}
	}

	/** Get the current computed width for the first element in the set of matched elements, including padding but not border. */
	public static function innerWidth(node:Node):Int
	{
		var style = getComputedStyle(cast node);
		if (style != null)
		{
			
		}
		return 0;
	}
} 

class QueryStyle
{
	
	public static function setCSS(collection:Query, property:String, value:String)
	{
		for (node in collection)
		{
			Style.setCSS(node, property, value);
		}
	}
}

//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------
//
// EVENT MANAGEMENT
//
//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------

/*
JQuery has these methods.  I'll try break them down into core functionality and implementations of specific events
For now I'm only testing in Firefox / W3 conforming browsers.  Almost certainly broken in IE8 and below.

Core functionality
==================
trigger()
triggerHandler()
WORKING on() - addEventListener, basically
WORKING off() - removeEventListener, basically
WORKING one() - like on(), but runs once and removes itself


Specific Events
===============
mousedown
mouseenter
mouseleave
mousemove
mouseout
mouseover
mouseup
keydown
keypress
keyup
hover() - 
submit()
toggleClick(callBackFirstClick, callBackSecondClick)
blur() - 
change() - 
click() - 
dblclick() - 
focus()
focusIn()
focusOut()
resize - event
scroll - event
select - event
load()
unload (events)
error() - 
ready()


noBubble // not sure what this is... haxe specific by the looks of it


bind() - addEventListener() basically - Replaced by on()
unbind (events) - replaced by off
live // deprecated
die(?eventType) - remove all event handlers // deprecated
*/ 
class EventManagement
{
	/*private static var eventTypeMap = {
		'click':'MouseEvent',
		'dblclick':'MouseEvent',
		'mousedown':'MouseEvent',
		'mouseup':'MouseEvent',
		'mouseover':'MouseEvent',
		'mousemove':'MouseEvent',
		'mouseout':'MouseEvent',
		'keydown':'KeyboardEvent',
		'keypress':'KeyboardEvent',
		'keyup':'KeyboardEvent',
		'':'HTMLEvents',

	}

	/** Trigger an event, as if it has actually happened 
	public static function trigger(target:Node, eventString:String):Node
	{
		if (ElementManipulation.isElement(target))
		{
			var elm:Element = cast target;

			var event;
			var useW3EventModel:Bool = untyped __js__('document.createEvent');
			if (useW3EventModel) 
			{
				event = untyped __js__("document.createEvent('HTMLEvents')");
				event.initEvent(eventString, true, true);
			} 
			else 
			{
				event = untyped __js__("document.createEventObject()");
				event.eventType = "on" + eventString;
			}

			event.eventName = eventString;
			event.memo = memo || { };

			if (useW3EventModel)
			{
				elm.dispatchEvent(event);
			}
			else
			{
				untyped __js__("elm.fireEvent(event.eventType, event)");
			}
		}

		return target;
	}*/

	/** Trigger the handler for the event, but don't emulate the event itself */
	public static function triggerHandler(target:Node, event:String):Node
	{
		return target;
	}

	/** add an event listener */
	public static function on(target:Node, eventType:String, listener:Event->Void):Node
	{
		var elm:Element = cast target;

		// eventType, listener, useCapture.  For info on useCapture, see http://blog.seankoole.com/addeventlistener-explaining-usecapture
		// will not work on IE8 or below.  Can't be bothered adding at the moment.
		elm.addEventListener(eventType, listener, false);

		return target;
	}

	public static function off(target:Node, eventType:String, listener:Event->Void):Node
	{
		var elm:Element = cast target;

		// eventType, listener, useCapture.  For info on useCapture, see http://blog.seankoole.com/addeventlistener-explaining-usecapture
		// will not work on IE8 or below.  Can't be bothered adding at the moment.
		// This code may also be an alternative: https://developer.mozilla.org/en/DOM/element.removeEventListener#section_4
		elm.removeEventListener(eventType, listener, false);
		
		return target;
	}

	/** Attach an event but only let it run once */
	public static function one(target:Node, eventType:String, listener:Event->Void):Node
	{
		var fn:Event->Void = null;
		fn = function (e:Event)
		{
			listener(e);
			target.removeEventListener(eventType, fn, false);
		}
		target.addEventListener(eventType, fn, false);
		return target;
	}

	public static inline function mousedown(target:Node, listener:Event->Void):Node
	{
		return on(target, "mousedown", listener);
	}

	public static inline function mouseenter(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseleave(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mousemove(target:Node, listener:Event->Void):Node
	{
		return on(target, "mousemove", listener);
	}

	public static inline function mouseout(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mouseover(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseup(target:Node, listener:Event->Void):Node
	{
		return on(target, "mouseup", listener);
	}

	public static inline function keydown(target:Node, listener:Event->Void):Node
	{
		return on(target, "keydown", listener);
	}

	public static inline function keypress(target:Node, listener:Event->Void):Node
	{
		return on(target, "keypress", listener);
	}

	public static inline function keyup(target:Node, listener:Event->Void):Node
	{
		return on(target, "keyup", listener);
	}

	public static function hover(target:Node, listener1:Event->Void, ?listener2:Event->Void = null):Node
	{
		mouseenter(target, listener1);

		if (listener2 == null)
		{
			// no 2nd listener, that means run the first again
			mouseleave(target, listener1);
		}
		else
		{
			// there is a second listener, so run that when the mouse leaves the hover-area
			mouseleave(target, listener2);
		}
		return target;
	}

	public static inline function submit(target:Node, listener:Event->Void):Node
	{
		return on(target, "submit", listener);
	}

	public static function toggleClick(target:Node, listenerFirstClick:Event->Void, listenerSecondClick:Event->Void):Node
	{
		// Wrap the first click function to run once, then remove itself and add the second click function
		var fn1:Event->Void = null;
		var fn2:Event->Void = null;
		
		fn1 = function (e:Event)
		{
			listenerFirstClick(e);
			target.removeEventListener("click", fn1, false);
			target.addEventListener("click", fn2, false);
		}

		// Wrap the second click function to run once, then remove itself and add the first click function
		fn2 = function (e:Event)
		{
			listenerSecondClick(e);
			target.removeEventListener("click", fn2, false);
			target.addEventListener("click", fn1, false);
		}

		// Add the first one to begin with
		target.addEventListener("click", fn1, false);

		return target;
	}

	public static inline function blur(target:Node, listener:Event->Void):Node
	{
		return on(target, "blur", listener);
	}

	public static inline function change(target:Node, listener:Event->Void):Node
	{
		return on(target, "change", listener);
	}

	public static inline function click(target:Node, listener:Event->Void):Node
	{
		return on(target, "click", listener);
	}

	public static inline function dblclick(target:Node, listener:Event->Void):Node
	{
		return on(target, "dblclick", listener);
	}

	public static inline function focus(target:Node, listener:Event->Void):Node
	{
		return on(target, "focus", listener);
	}

	public static inline function focusIn(target:Node, listener:Event->Void):Node
	{
		return on(target, "focusIn", listener);
	}

	public static inline function focusOut(target:Node, listener:Event->Void):Node
	{
		return on(target, "focusOut", listener);
	}

	public static inline function resize(target:Node, listener:Event->Void):Node
	{
		return on(target, "resize", listener);
	}

	public static inline function scroll(target:Node, listener:Event->Void):Node
	{
		return on(target, "scroll", listener);
	}

	public static inline function select(target:Node, listener:Event->Void):Node
	{
		return on(target, "select", listener);
	}

	public static inline function load(target:Node, listener:Event->Void):Node
	{
		return on(target, "load", listener);
	}

	public static inline function unload(target:Node, listener:Event->Void):Node
	{
		return on(target, "unload", listener);
	}

	public static inline function error(target:Node, listener:Event->Void):Node
	{
		return on(target, "error", listener);
	}

	public static inline function ready(target:Node, listener:Event->Void):Node
	{
		return on(target, "ready", listener);
	}

}

class QueryEventManagement
{
	public static function on(targetCollection:Query, eventType:String, listener:Event->Void):Query
	{
		for (target in targetCollection)
		{
			EventManagement.on(target, eventType, listener);
		}
		return targetCollection;
	}

	public static function off(targetCollection:Query, eventType:String, listener:Event->Void):Query
	{
		for (target in targetCollection)
		{
			EventManagement.off(target, eventType, listener);
		}
		return targetCollection;
	}

	public static function one(targetCollection:Query, eventType:String, listener:Event->Void):Query
	{
		for (target in targetCollection)
		{
			EventManagement.one(target, eventType, listener);
		}
		return targetCollection;
	}

	public static inline function mousedown(target:Query, listener:Event->Void):Query
	{
		return on(target, "mousedown", listener);
	}

	public static inline function mouseenter(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseenter", listener);
	}

	public static inline function mouseleave(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseleave", listener);
	}

	public static inline function mousemove(target:Query, listener:Event->Void):Query
	{
		return on(target, "mousemove", listener);
	}

	public static inline function mouseout(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mouseover(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseup(target:Query, listener:Event->Void):Query
	{
		return on(target, "mouseup", listener);
	}

	public static inline function keydown(target:Query, listener:Event->Void):Query
	{
		return on(target, "keydown", listener);
	}

	public static inline function keypress(target:Query, listener:Event->Void):Query
	{
		return on(target, "keypress", listener);
	}

	public static inline function keyup(target:Query, listener:Event->Void):Query
	{
		return on(target, "keyup", listener);
	}

	public static function hover(targetCollection:Query, listener1:Event->Void, ?listener2:Event->Void = null):Query
	{
		for (node in targetCollection)
		{
			EventManagement.hover(node, listener1, listener2);
		}
		return targetCollection;
	}

	public static inline function submit(target:Query, listener:Event->Void):Query
	{
		return on(target, "submit", listener);
	}

	public static function toggleClick(targetCollection:Query, listenerFirstClick:Event->Void, listenerSecondClick:Event->Void):Query
	{
		for (target in targetCollection)
		{
			EventManagement.toggleClick(target, listenerFirstClick, listenerSecondClick);
		}
		return targetCollection;
	}

	public static inline function blur(target:Query, listener:Event->Void):Query
	{
		return on(target, "blur", listener);
	}

	public static inline function change(target:Query, listener:Event->Void):Query
	{
		return on(target, "change", listener);
	}

	public static inline function click(target:Query, listener:Event->Void):Query
	{
		return on(target, "click", listener);
	}

	public static inline function dblclick(target:Query, listener:Event->Void):Query
	{
		return on(target, "dblclick", listener);
	}

	public static inline function focus(target:Query, listener:Event->Void):Query
	{
		return on(target, "focus", listener);
	}

	public static inline function focusIn(target:Query, listener:Event->Void):Query
	{
		return on(target, "focusIn", listener);
	}

	public static inline function focusOut(target:Query, listener:Event->Void):Query
	{
		return on(target, "focusOut", listener);
	}

	public static inline function resize(target:Query, listener:Event->Void):Query
	{
		return on(target, "resize", listener);
	}

	public static inline function scroll(target:Query, listener:Event->Void):Query
	{
		return on(target, "scroll", listener);
	}

	public static inline function select(target:Query, listener:Event->Void):Query
	{
		return on(target, "select", listener);
	}

	public static inline function load(target:Query, listener:Event->Void):Query
	{
		return on(target, "load", listener);
	}

	public static inline function unload(target:Query, listener:Event->Void):Query
	{
		return on(target, "unload", listener);
	}

	public static inline function error(target:Query, listener:Event->Void):Query
	{
		return on(target, "error", listener);
	}

	public static inline function ready(target:Query, listener:Event->Void):Query
	{
		return on(target, "ready", listener);
	}
}

//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------
//
// ANIMATION
//
//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------

