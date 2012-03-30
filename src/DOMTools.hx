/**
* This file wraps all the domtools functionality into 
* one module, so it's easy to use at once.
* 
* The aim is that pretty much all of our main usage can
* be included with this line at the top of your file:
*     
*    using DOMTools;
*/

// None of our actual code is defined in this file.
// However, by using `typedef = domtools.Tools`
// We can include that class with haxe's "using" magic.

// domtools.Tools provides 3 handy functions:
// 
//    "div".create();
//    "<b>Some Text</b>".parse();
//    "#title".find();
typedef DOMTools = domtools.Tools;

// 
// Core classes
// 

// Include ElementManipulation
typedef SingleElementManipulation = domtools.single.ElementManipulation;
typedef CollectionElementManipulation = domtools.collection.ElementManipulation;

// Include DOMManipulation
typedef SingleDOMManipulation = domtools.single.DOMManipulation;
typedef CollectionDOMManipulation = domtools.collection.DOMManipulation;

// Include Traversing
typedef SingleTraversing = domtools.single.Traversing;
typedef CollectionTraversing = domtools.collection.Traversing;


// 
// Client JS only classes
// 

#if (js && !nodejs)

// Include Style
typedef SingleStyle = domtools.single.Style;
typedef CollectionStyle = domtools.collection.Style;

// Include Animation
//typedef SingleAnimation = domtools.single.Animation;
//typedef CollectionAnimation = domtools.collection.Animation;

// Include EventManagement
typedef SingleEventManagement = domtools.single.EventManagement;
typedef CollectionEventManagement = domtools.collection.EventManagement;

#end