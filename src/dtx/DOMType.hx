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

class DOMType
{

	#if js
		static public var DOCUMENT_NODE(get,null):Int;
		static public var ELEMENT_NODE(get,null):Int;
		static public var TEXT_NODE(get,null):Int;
		static public var COMMENT_NODE(get,null):Int;

		static inline function get_DOCUMENT_NODE() return dtx.DOMNode.DOCUMENT_NODE;
		static inline function get_ELEMENT_NODE() return dtx.DOMNode.ELEMENT_NODE;
		static inline function get_TEXT_NODE() return dtx.DOMNode.TEXT_NODE;
		static inline function get_COMMENT_NODE() return dtx.DOMNode.COMMENT_NODE;
	#else 
		static public var DOCUMENT_NODE(get,null):Xml.XmlType;
		static public var ELEMENT_NODE(get,null):Xml.XmlType;
		static public var TEXT_NODE(get,null):Xml.XmlType;
		static public var COMMENT_NODE(get,null):Xml.XmlType;

		static inline function get_DOCUMENT_NODE() return Xml.Document;
		static inline function get_ELEMENT_NODE() return Xml.Element;
		static inline function get_TEXT_NODE() return Xml.PCData;
		static inline function get_COMMENT_NODE() return Xml.Comment;
	#end 
}