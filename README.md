Detox
=====

This is a library for haxeJS that makes it easier to work with the DOM or XML.  It is mostly inspired by JQuery but aims to give a more haxe-like way of coding.

It makes heavy use of haxe's ["using" mixin](http://haxe.org/manual/using), which allows you to write some really easy code.

Here's some code so you can get an idea of what I mean:

```

// You include this at the top of your file

using Detox;

// Now you can write code like this:

"h1".find();                // Find all <h1> elements on the page
"#myID .myclass".find();    // Find elements using CSS selectors
"div".create();             // Create <div>
"table".create();           // Create <table>
"Hello <i>you</i>".parse()  // Turn this into DOM/XML objects

// And traverse it like this:

var listItems = "#menu li".find();
for (listItem in listItems)
{
    trace (listItem.text());
    trace (listItem.find('a').attr('href'));
}

// Or like this

var myParent = "#parent".find();
for (thisChild in myParent.children())
{
    var thisText = thisChild.text()
    var prevChild = thisChild.prev().text();
    var nextChild = thisChild.next().text();
    Std.format("$thisText comes after $prevText and before $nextText");
}

// Or manipulate it like this:

var mylink = "a".create();              // Create <a></a>
mylink.setText("My Link");              // <a>My Link</a>
mylink.setAttr("href", "#");            // <a href="#">My Link</a>
myLink.setInnerHTML("Hi <i>There</i>"); // <a href="#">Hi <i>There</i></a>

// And then you can move things around like this
var icon = "<img src='create.png' alt='create' />".parse();
myLink.append(icon); 
icon.appendTo(myLink); // or the other way around


// And then you can add events like this:

myLink.click(function (e) {
    trace ("You clicked " + e.currentTarget.text());
})
"form#myform".find().submit(function (e) {
    e.preventDefault();
    for (input in e.currentTarget.find("input"))
    {
        trace (input.attr('name') + ": " + input.val());
    }
});

```

Basic Aims
----------

* Have jQuery-like functionality
* Be very haxe-like and easy to use.
* Provide a base for building HTML/JS widgets using haxe classes.
* Be null-safe, that is, if something is missing fail silently, don't throw errors.
* Provide a cross-platform friendly way of working with XML / DOM trees.  This is 
  implemented using Haxe's Xml class and SelectHXML for the selection engine.  Obviously 
  style, animation and events won't make much sense on the server side, but certainly the 
  general DOM manipulation and traversing can work.

Demos
=====

Here are some very basic demos to show how it works.  Currently they are working in 
both Firefox and Webkit, though our EventManagement code is not IE-friendly yet.  But
none of you would be using IE, would you?

*Todo List*

* Code: https://github.com/jasononeil/detox/tree/gh-pages/demo/todo
* Example: http://jasononeil.github.com/detox/demo/todo/build/
* Demonstrates: Basic usage.  Creating elements, manipulating elements, reading from 
  a form, traversing and moving things around the DOM.

*Growl-Like Notifications*

* Code: https://github.com/jasononeil/detox/tree/gh-pages/demo/growl
* Example: http://jasononeil.github.com/detox/demo/growl/build/
* Demonstrates: Basic usage as above.  Mostly demonstrates "Widgets" - how we can make
  our own custom classes in haxe that are closely tied to Elements on our HTML page.

Full Usage
==========

General helpers
---------------

* "myselector".find();
* "div".create();
* "<div>Some <i>HTML</i> code.</div>".parse();

Node / Element Manipulation
---------------------------

* isElement()
* isComment()
* isTextNode()
* isDocument()
* toCollection() - Element Only
* get() - Get first Node out of query
* get(1) - Get second Node out of query
* attr("src")
* setAttr("src", "image.jpg")
* removeAttr("src")
* hasClass("myClass")
* hasClass("myfirstclass mysecondclass")
* addClass("myClass")
* addClass("myfirstclass mysecondclass")
* removeClass("myClass")
* removeClass("myfirstclass mysecondclass")
* toggleClass("myClass")
* toggleClass("myfirstclass mysecondclass")
* tagName()
* val()
* setVal("newValue")
* text()
* setText()
* innerHTML()
* setInnerHTML()
* html() - get the full XML/HTML of this node and it's children
* clone()

Traversing
----------

* children()
* firstChildren() - open to changing name
* lastChildren() - open to changing name
* parent()
* parents() - on Xml targets, "parent" is already taken.  Use parents() for a null-safe option.
* ancestors()
* next()
* prev()
* find()

DOM Manipulation
----------------

* append(newChild)
* prepend(newChild)
* appendTo(newParent)
* prependTo(newParent)
* insertThisBefore(sibling)
* insertThisAfter(sibling)
* beforeThisInsert(newSibling)
* afterThisInsert(newSibling)
* remove() - remove the current element
* removeChildren(childElement)
* removeChildren(childElements)
* empty()

Event Management
----------------

For each of these, `eventType` is a String, for example "click", "move", "keyup".  Listener should be `function (e) { trace("Do something..."); }`

* trigger(eventType) - not implemented yet
* triggerHandler(eventType)
* on(eventType, listener)
* off(eventType, listener)
* one(eventType, listener)
* mousedown(listener)
* mouseenter(listener)
* mouseleave(listener)
* mousemove(listener)
* mouseout(listener)
* mouseover(listener)
* mouseup(listener)
* keydown(listener)
* keypress(listener)
* keyup(listener)
* hover(listener)
* submit(listener)
* toggleClick(listener)
* blur(listener)
* change(listener)
* click(listener)
* dblclick(listener)
* focus(listener)
* focusIn(listener)
* focusOut(listener)
* resize(listener)
* scroll(listener)
* select(listener)
* load(listener)
* unload(listener)
* error(listener)
* ready(listener)

Style
-----

* Mostly not implemented yet.

Animation
---------

* Mostly not implemented yet.

Status
======

* NA: this feature does not apply to this platform
* NotYet: this feature has not been written yet
* NoTests: implemented, but no tests written - no guarantee it works
* NotRun: implemented, and tests written, but not run yet on this platform.
* TestFails: implemented, tested, some tests failing
* Okay: implemented, tests passing, could do with a few more tests.
* Good: implemented, tests passing, good coverage, good to go.

<table>
<thead>
    <tr>
        <th>Feature</th>
        <th colspan="6">Browser JS</th>
        <th colspan="5">Other Platforms</th>
    </tr>
    <tr>
        <th></th>
        <th>Firefox</th>
        <th>WebKit</th>
        <th>Opera</th>
        <th>IE7</th>
        <th>IE8</th>
        <th>IE9</th>
        <th>Flash 9+</th>
        <th>Neko</th>
        <th>PHP</th>
        <th>NodeJS</th>
        <th>CPP</th>
    </tr>
</thead>
<tbody>
    <tr>
        <th>Element Manipulation</th>
        <td colspan="3">Good</td>
        <td colspan="2">NotRun</td>   
        <td colspan="1">Good</td>
        <td colspan="2">Good</td>
        <td colspan="1">NotRun</td>
        <td colspan="1">NotYet</td>
        <td colspan="1">Good</td>
    </tr>
    <tr>
        <th>Query (Collection)</th>
        <td colspan="3">Good</td>
        <td colspan="2">NotRun</td>   
        <td colspan="1">Good</td>
        <td colspan="2">Good</td>
        <td colspan="1">NotRun</td>
        <td colspan="1">NotYet</td>
        <td colspan="1">Good</td>
    </tr>
    <tr>
        <th>DOM Manipulation</th>
        <td colspan="3">Good</td>
        <td colspan="2">NotRun</td>   
        <td colspan="1">Good</td>
        <td colspan="2">Good</td>
        <td colspan="1">NotRun</td>
        <td colspan="1">NotYet</td>
        <td colspan="1">Good</td>
    </tr>
    <tr>
        <th>Traversing</th>
        <td colspan="3">Good</td>
        <td colspan="2">NotRun</td>   
        <td colspan="1">Good</td>
        <td colspan="2">Good</td>
        <td colspan="1">NotRun</td>
        <td colspan="1">NotYet</td>
        <td colspan="1">Good</td>
    </tr>
    <tr>
        <th>Event Management</th>
        <td colspan="6">NoTests (should work)</td>   
        <td colspan="5">NA</td>    
    </tr>
    <tr>
        <th>Style</th>
        <td colspan="6">NotYet</td>   
        <td colspan="5">NA</td>    
    </tr>
    <tr>
        <th>Animation</th>
        <td colspan="6">NotYet</td>   
        <td colspan="5">NA</td>    
    </tr>
</tbody>
</table>

Platform Inconsistencies
========================

* On XML based targets (non JS), parent is an Node, not a function that returns a Node.  It is not null-safe.  Use parents() instead to be safe and consistent across platforms.
* On XML based targets (non JS), remove() is a method to remove attributes.  Because it already exists, our "remove()" mixin does not work.  Use removeFromDOM() instead.

Future
======

Small things to add:

 * node.index() - index in parent
 * node.hasAttr('style'):Bool