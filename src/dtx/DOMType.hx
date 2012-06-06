package dtx;

class DOMType
{
	#if js
	static public var DOCUMENT_NODE = dtx.DOMNode.DOCUMENT_NODE;
	static public var ELEMENT_NODE = dtx.DOMNode.ELEMENT_NODE;
	static public var TEXT_NODE = dtx.DOMNode.TEXT_NODE;
	static public var COMMENT_NODE = dtx.DOMNode.COMMENT_NODE;
	#else
	static public var DOCUMENT_NODE = Xml.Document;
	static public var ELEMENT_NODE = Xml.Element;
	static public var TEXT_NODE = Xml.PCData;
	static public var COMMENT_NODE = Xml.Comment;
	#end
}