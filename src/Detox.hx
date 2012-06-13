/****
* Copyright (c) 2012 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/

/**
* This file wraps all the dtx functionality into 
* one module, so it's easy to use at once.
* 
* The aim is that pretty much all of our main usage can
* be included with this line at the top of your file:
*     
*    using Detox;
*/

// None of our actual code is defined in this file.
// However, by using `typedef = dtx.Tools`
// We can include that class with haxe's "using" magic.

// dtx.Tools provides 3 handy functions:
// 
//    "div".create();
//    "<b>Some Text</b>".parse();
//    "#title".find();
typedef Detox = dtx.Tools;

// 
// Core classes
// 

// Include ElementManipulation
typedef SingleElementManipulation = dtx.single.ElementManipulation;
typedef CollectionElementManipulation = dtx.collection.ElementManipulation;

// Include DOMManipulation
typedef SingleDOMManipulation = dtx.single.DOMManipulation;
typedef CollectionDOMManipulation = dtx.collection.DOMManipulation;

// Include Traversing
typedef SingleTraversing = dtx.single.Traversing;
typedef CollectionTraversing = dtx.collection.Traversing;

typedef DOMNode = dtx.DOMNode;
typedef DOMCollection = dtx.DOMCollection;
// 
// Client JS only classes
// 

#if (js && !nodejs)

// Include Style
typedef SingleStyle = dtx.single.Style;
typedef CollectionStyle = dtx.collection.Style;

// Include Animation
//typedef SingleAnimation = dtx.single.Animation;
//typedef CollectionAnimation = dtx.collection.Animation;

// Include EventManagement
typedef SingleEventManagement = dtx.single.EventManagement;
typedef CollectionEventManagement = dtx.collection.EventManagement;

#end


