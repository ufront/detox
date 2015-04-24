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
	A collection of static variables used to identify node type.

	Because these are different underlying types on different platforms, and because they are not constant, we cannot use an enum or a fake "abstract enum".

	Instead you can compare a `nodeType` from a `dtx.DOMNode` with one of these values.
	This will work with both `js.html.Node` and `Xml`.
**/
class DOMType {
	static public var DOCUMENT_NODE = #if js js.html.Node.DOCUMENT_NODE #else Xml.Document #end;
	static public var ELEMENT_NODE = #if js js.html.Node.ELEMENT_NODE #else Xml.Element #end;
	static public var TEXT_NODE = #if js js.html.Node.TEXT_NODE #else Xml.PCData #end;
	static public var COMMENT_NODE = #if js js.html.Node.COMMENT_NODE #else Xml.Comment #end;
	static public var CDATA_NODE = #if js js.html.Node.CDATA_SECTION_NODE #else Xml.CData #end;
}
