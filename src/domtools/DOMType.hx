package domtools;

class DOMType
{
	#if js
	static public var DOCUMENT_NODE = domtools.DOMNode.DOCUMENT_NODE;
	static public var ELEMENT_NODE = domtools.DOMNode.ELEMENT_NODE;
	static public var TEXT_NODE = domtools.DOMNode.TEXT_NODE;
	static public var COMMENT_NODE = domtools.DOMNode.COMMENT_NODE;
	#else
	static public var DOCUMENT_NODE = Xml.Document;
	static public var ELEMENT_NODE = Xml.Element;
	static public var TEXT_NODE = Xml.PCData;
	static public var COMMENT_NODE = Xml.Comment;
	#end
}