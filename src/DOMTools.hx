/****
* Copyright 2012 Jason O'Neil. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE "AS IS" AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Jason O'Neil.
* 
****/

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

typedef DOMNode = domtools.DOMNode;
typedef DOMCollection = domtools.DOMCollection;
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


