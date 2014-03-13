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
	A generic DOM Node that references the underlying node type for each platform.

	On Javascript, this is a typedef alias for `js.html.Node`.

	On other targets, this is a typedef alias for `Xml`.

	Even though these two types (`Xml` and `js.html.Node`) differ considerably, this typedef can be used with most Detox classes for a unified approach to interacting with DOM / Xml content.

	Classes for interacting with DOMNode include:

	- `dtx.single.ElementManipulation`
	- `dtx.single.DOMManipulation`
	- `dtx.single.Traversing`
	- `dtx.single.EventManagement`
	- `dtx.single.Style`
**/
typedef DOMNode = #if js js.html.Node #else Xml #end;

/**
	A generic DOM Element.

	Similar to `dtx.DOMNode` this changes depending on the platform.
	`DOMElement` is a typedef alias for `js.html.Element` on Javascript, and `Xml` on other platforms.
**/
typedef DOMElement = #if js js.html.Element #else DOMNode #end;

/**
	An element that can contain other elements.

	On JS this is a typedef capable of using `querySelector` and `querySelectorAll`, so usually an Element or a Document.
	On other platforms this is simple an alias for `Xml`.
**/
typedef DocumentOrElement = 
	#if js
		{
			> DOMNode,
			var querySelector:String->Dynamic->DOMElement;
			var querySelectorAll:String->Dynamic->js.html.NodeList;
		}
	#else
		DOMNode
	#end
;


