    Everything below here is kept for interests sake - it was my thoughts as I've been writing the library.  It may shine insight on to decisions I've made or on to why things are the way they are.

domtools - HaXe DOM Integration
===============================

The idea here is to create a JQuery-like library for haxe, but which wraps native DOM elements.  We can use several features of haxe to make this work really well.

* "Using" - allows us to use custom methods on a standard DOM Node object, without extending or wrapping the object.
* Dead Code Elimination - if a function is not used, it is not included in the output.  This can keep your output small (note, this is in theory.  I have no real-world usage stats)
* Possibility to port to all targets - while this is currently aimed at javascript development, several of the classes could easily be made to work with Haxe XML, by creating a typedef / class that bridges the gap between DOM Nodes and XML Nodes.  Integration with "SelectHx" (https://code.google.com/p/selecthx/) could replicate the functionality of "document.querySelectorAll()".

Similarities to JQuery
----------------------

* Similar API - I have tried to replicate the API where possible.  It is not complete yet, but I'm adding things as I need them.  Feel free to make a request.  One key difference is the lack of overloading in haxe.  So instead of having text() and text(string), I have used text() and setText(string), etc.
* Chaining - most methods allow chaining, so you can use "firstElement.next().addClass('secondElement')"
* Failsafe API - with JQuery, if an element is not found it fails silently - preventing you from having to write too many "if-then" or "try-catch" statements in your code.  I'm aiming for the same here.   
* API should work identically whether applying to a single Node or a collection
* Easy collections - use "new Query('div.myclass')" and you have a collection of all the matching objects, which can be manipulated as a group.  In the next section, I'll show you an even easier way.

Advantages over JQuery
----------------------

* Some really easy "using" mixins for getting started:
    * "ul#myelement".find()
    * "ul#myelement li.child".find()
    * "div".create()
    * "<div>My Div</div>".parse()
* Can work on individual elements, don't have to wrap everything in a jQuery object (thanks to "using").
* You can include only "using" statements for one thing, eg "using ElementManipulation".  This keeps autocomplete from getting too cluttered.
* Thanks to "dead code elimination", the compile size of the library can be smaller.
* Native Haxe - API feels more haxe-like.  Should be easier to integrate into existing haxe workflow.
* AbstractCustomElement can be extended by haxe classes to make a class automatically tie into the DOM.  This allows tight integration of haxe features with the DOM.

Where JQuery wins
-----------------

* Cross browser support - I have not tested this cross browser.  The unit tests I've written (which don't have full coverage) currently pass on Firefox and Chrome.  Haven't even looked at anything else.  It almost certainly won't work on IE7 or less.
* Completeness - currently only ElementManipulation, DOMManipulation, Traversing and Query are completed.  Event support is implemented, but not tested.  We are still lacking support for Style and Animation.
* Testing - JQuery is used on thousands (millions?) of websites, and is thoroughly tested.  This, not so much.  You can help change that!
* Plugins - JQuery has a lot of plugins, which we obviously can't support here.  However, they have never been easy to get working in haxe, because you have to write an extern for each one.  With this it should be easier to extend your own functionality in a haxe-like way - either object oriented or through the "using" mixins.

Current Status
--------------



* Query - the main object you work with, essentially a collection of Nodes that you can group and manage together.  Working.
* ElementManipulation - largely working, tested thoroughly on firefox only.
* DOMManipulation - appears to be working, not thoroughly tested.
* Traversing - appears to be working in Firefox, not thoroughly tested.
* Events - basic structure for code is in for each jquery event.  Only events that are native to the browser will work.  Currently using only "addEventListener", so will not work in IE8 or less.
* Style - not implemented yet.
* Animation - not implemented yet.

The Plan
--------

* Use xirsys' "StdJS" library to get proper typedefs for html5/js
* Implement JQuery like functions, but as a collection of "Using" libraries.
* package domtools;
    * using domtools.Traversing;
    * using domtools.ElementManipulation;
    * using domtools.DOMManipulation;
    * using domtools.Events;
    * using domtools.Animation;
    * using domtools.Style;
* Create the basic files and method signiatures, but with #error statements
* Post to git.  Fill them out as I go.
    * Start with Traversing, ElementManipulation, DOMManipulation.  Later add Events.  Then Style.  Then Animation.
* Start with basic functions, don't worry too much about extra selectors on methods where it's not necessary yet.
* All functions should have an overload, so it can take both a Node and a Query (collection).  This means all Node or Query objects will work with the API.
* To make "using" work for both Node and Query, the API will need to be duplicated.  Both of these are stored in the same class, and the code for "Query" mostly calls the code for "Node" on each of its elements.  See domtools.ElementManipulation for an example.

Questions
---------

* If I use "class Button implements HtmlDom", will my object be found via the DOM inspector in firebug?  Can I find my object using JQuery?

    Answer: this doesn't work, you can't construct a HtmlDom.  What does work is constructing a query, using document.createNode("div"), adding it to the query collection and having your class extend that query.


Aim
---

I want to be able to:

* Create "blank canvas" html, with no styling, but with enough markup to be REALLY easy to CSS.
* Easily add / remove classes and ids
* Easily add / remove event listeners
* Basic animations (show/hide?)

API
---

These are the API functions from JQuery.  I've split them up into different groupings.  
My plan is to use haxe's "using" functionality to add these to normal Node elements, or to Query objects (collections of nodes, JQuery style).

JQuery functions
================

DOM Traversing
--------------
	children() - 
	parent()
	parents()
	parentsUntil(selector)
	next
	nextAll
	nextUntil
	prev
	prevAll
	prevUntil
	siblings
	closest() - 
	find(selector) - find child that matches selector
	contents() - similar to children, but returns all nodes, including text nodes and comments.

Can use DOM, minus selector


DOM Element Manipulation
------------------------
	removeAttr()
	removeClass()
	addClass()
	hasClass() - 
	toggleClass()
	attr() - read / write attribute
	text()
	html() - is this inner or outer?
	val()
	clone() - create a deep copy of this set of matched elements




DOM Tree Manipulation
---------------------
	wrap()
	unwrap
	empty() - 
	wrapAll()
	wrapInner()
	insertAfter
	insertBefore
	prepend
	prependTo
	append() - append a string (or html) to each object
	appendTo() - adds the collection to each item that matches the selector
	remove() - remove element from DOM, destroys
	detach() - removes element, but keeps data
	replaceAll(selector) - replace each element matching selector with our collection
	replaceWith(newContent) - replace collection with new content
	after() - places html after each element in collection
	before() - places html before each element in collection



Events
------
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
	live
	die(?eventType) - remove all event handlers
	load()
	ready()
	noBubble
	one()
	trigger
	triggerHandler
	bind() - addEventListener() basically
	unbind (events)
	unload (events)
	error() - 

Animation
---------
	hide() - 
	slideDown
	slideToggle
	slideUp
	show
	stop()
	fadeIn() - 
	fadeOut() - 
	fadeTo() - 
	fadeToggle() - 
	toggle() - animation
	clearQueue() -
	delay() - 
	queue() - get queue of animations?
	dequeue() - 
	animate() - 

Style
-----
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

Collection Management
---------------------
	add() - adds an object to the collection
	each() - 
	first() - first element in a set
	get() - an array of the DOM elements
	iterator()
	size - number of objects in collection
	toArray()
	eq() - 
	filter() - 
	last() - final matched element in set
	slice
	not - removes elements (or selector) from set
	is("") - like filter, but returns Bool rather than new list if(element.is("li.menu"))
	has(selector) - does it have a certain children
	andSelf() - previous set of matched elements to the current set
	index(?selector) - 

Probably no need to implement
-----------------------------
	data<T>(key, ?value) - basically a hash
	removeData(key)
	noConflict()
	end() - to undo the last filter.  Probably irrelevant if we use static methods?
	serialise - string
	serialiseArray()
	pushStack(Array<HtmlDom>):JQuery - if we are using statics this is unnecessary - we're operating on regular elements.
	delegate() - superseded
	undelegate - superseded
	loadURL() / load() - let other haxe classes do this?

Static
------

	browser.webkit, browser.version, browser.opera, browser.msie, browser.mozilla, 
	cur() - current element in callback (like $(this))
	fx.off, fx.interval
	contains(parent, child)
	JQuery.of(dom:HtmlDom):JQuery
	parseJSON

