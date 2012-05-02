package domtools;

#if js
import js.w3c.level3.Core;
typedef DOMNode = js.w3c.level3.Core.Node;
typedef DOMElement = js.w3c.level3.Core.Element;
typedef Event = js.w3c.level3.Events.Event;
typedef DocumentOrElement = {> DOMNode,
	var querySelector:String->Dynamic->DOMElement;
	var querySelectorAll:String->Dynamic->NodeList;
}

#else 
import selecthxml.engine.XmlDom;
class DOMNode extends XmlDom
{
	static public var DOCUMENT_NODE:Int;
	static public var ELEMENT_NODE:Int;
	static public var TEXT_NODE:Int;
	public var lastChild(default, null):DOMNode;

	public function new(xml:Xml, ?parent:XmlDom, ?index:Null<Int>)
	{
		super(xml, parent, index);
		lastChild = cast childNodes[childNodes.length - 1];
	}

	public function hasChildNodes():Bool 
	{
		return null;
	}


	public function appendChild(content:DOMNode)
	{
		
	}

	public function prependChild(content:DOMNode)
	{
		
	}

	public function insertBefore(content:DOMNode, target:DOMNode)
	{
		
	}

	public function removeChild(node:DOMNode)
	{
		
	}

	public function setAttribute(attName:String, attValue:String)
	{
		throw "not implemented";
	}

	public function hasAttributes()
	{
		throw "not implemented";
		return false;
	}

	public function removeAttribute(attName:String)
	{
		throw 'not implemented';
	} 

	public function cloneNode(deep:Bool)
	{
		return new DOMNode(Xml.parse(this.xml.toString()).firstChild());
	}

	public var nodeValue(get_nodeValue, set_nodeValue):String;
	function get_nodeValue()
	{
		return "";
	}

	function set_nodeValue(value:String)
	{
		throw "not implemented";
		return value;
	}

	public var textContent(get_textContent, set_textContent):String;
	function get_textContent()
	{
		return "";
	}

	function set_textContent(text:String)
	{
		throw "not implemented yet";
		return text;
	}

	public var inner_html(get_innerHTML, set_innerHTML):String;
	function get_innerHTML()
	{
		return "";
	}

	function set_innerHTML(html:String)
	{
		throw "not implemented yet";
		return html;
	}
}

typedef DOMElement = DOMNode;
typedef DocumentOrElement = {> DOMNode,
	var querySelector:String->Dynamic->DOMElement;
	var querySelectorAll:String->Dynamic->Array<selecthxml.engine.Type.SelectableDom>;
}
#end


