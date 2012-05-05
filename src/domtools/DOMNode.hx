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
typedef DOMNode = Xml;
import selecthxml.engine.XmlDom;
class OLD_DOMNode extends XmlDom
{
	public var lastChild(default, null):DOMNode;
	public var numChildren(get_numChildren, null):Int;

	public function new(xml:Xml, ?parent:XmlDom, ?index:Null<Int>)
	{
		super(xml, parent, index);
		lastChild = cast childNodes[childNodes.length - 1];
	}

	inline function get_numChildren()
	{
		return Lambda.count(this.xml);
	}

	public function hasChildNodes():Bool 
	{
		return null;
	}


	public function appendChild(content:DOMNode)
	{
		//this.xml.insertChild(content.xml, this.numChildren);
	}

	public function prependChild(content:DOMNode)
	{
		//this.xml.insertChild(content.xml, 0);
	}

	public function insertBefore(content:DOMNode, target:DOMNode)
	{
		// var targetIndex = 0;
		// while (this.xml.iterator().hasNext() && this.xml.iterator().next() != target.xml)
		// {
		// 	targetIndex++;
		// }
		// this.xml.insertChild(content.xml, targetIndex);
	}

	public function removeChild(node:DOMNode)
	{
		//this.xml.removeChild(node.xml);
	}

	public function setAttribute(attName:String, attValue:String)
	{
		//this.xml.set(attName, attValue);
	}

	public function hasAttributes()
	{
		// If hasNext() is true, the length is at least one, right?
		//return this.xml.attributes().hasNext();
	}

	public function removeAttribute(attName:String)
	{
		//this.xml.remove(attName);
	} 

	public function cloneNode(deep:Bool)
	{
		//return new DOMNode(Xml.parse(this.xml.toString()).firstChild());
	}	

	public var nodeValue(get_nodeValue, set_nodeValue):String;
	function get_nodeValue()
	{
		return (this.xml.nodeType != Xml.Document && this.xml.nodeType != Xml.Element)
			? "" : this.xml.nodeValue;
	}

	function set_nodeValue(value:String)
	{
		if (this.xml.nodeType != Xml.Document && this.xml.nodeType != Xml.Element)
		{
			this.xml.nodeValue = value;
		}
		return value;
	}

	public var textContent(get_textContent, set_textContent):String;
	function get_textContent()
	{
		return "boy this doesn't work";
	}

	function set_textContent(text:String)
	{
		for (child in this.xml)
		{
			this.xml.removeChild(child);
		}
		var textNode = Xml.createPCData(text);
		this.xml.addChild(textNode);
		return text;
	}

	public var inner_html(get_innerHTML, set_innerHTML):String;
	function get_innerHTML()
	{
		var html = "";
		for (child in this.xml)
		{
			html += child.toString();
		}
		return html;
	}

	function set_innerHTML(html:String)
	{
		var xmlDocNode = Xml.parse(html);
		for (child in this.xml)
		{
			this.xml.removeChild(child);
		}
		for (child in xmlDocNode)
		{
			this.xml.addChild(child);
		}
		return html;
	}
}

typedef DOMElement = DOMNode;
typedef DocumentOrElement = DOMNode;


#end


