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

// Include ElementManipulation
@:noDoc typedef SingleElementManipulation = dtx.single.ElementManipulation;
@:noDoc typedef CollectionElementManipulation = dtx.collection.ElementManipulation;

// Include DOMManipulation
@:noDoc typedef SingleDOMManipulation = dtx.single.DOMManipulation;
@:noDoc typedef CollectionDOMManipulation = dtx.collection.DOMManipulation;

// Include Traversing
@:noDoc typedef SingleTraversing = dtx.single.Traversing;
@:noDoc typedef CollectionTraversing = dtx.collection.Traversing;

// Include DOMNode and DOMCollection definitions
@:noDoc typedef DOMNode = dtx.DOMNode;
@:noDoc typedef DOMCollection = dtx.DOMCollection;
@:noDoc typedef DOMElement = dtx.DOMNode.DOMElement;

/**
	The `Detox` module provides a top-level shortcut to access most of the key functionality of the Detox lib.

	It is intended to be used via static extension, that is, by placing `using Detox;` in your imports.

	This will provide both import and static extension for the following classes:

	- `dtx.single.ElementManipulation`
	- `dtx.collection.ElementManipulation`
	- `dtx.single.DOMManipulation`
	- `dtx.collection.DOMManipulation`
	- `dtx.single.Traversing`
	- `dtx.collection.Traversing`
	- `dtx.DOMNode`
	- `dtx.DOMCollection`
	- `dtx.Tools`
	- `dtx.single.Style` (Client JS Only)
	- `dtx.collection.Style` (Client JS Only)
	- `dtx.single.EventManagement` (Client JS Only)
	- `dtx.collection.EventManagement` (Client JS Only)

	The `Detox` type itself is an alias for `dtx.Tools`.
**/
typedef Detox = dtx.Tools;

#if (js && !nodejs)

	// Include Style
	@:noDoc typedef SingleStyle = dtx.single.Style;
	@:noDoc typedef CollectionStyle = dtx.collection.Style;

	// Include EventManagement
	@:noDoc typedef SingleEventManagement = dtx.single.EventManagement;
	@:noDoc typedef CollectionEventManagement = dtx.collection.EventManagement;

#end
