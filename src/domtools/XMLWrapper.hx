package domtools;
import domtools.DOMNode;
import domtools.DOMCollection;

class XMLWrapper
{
	static public inline function parentNode(xml:Xml)
	{
		return xml.parent;
	}

	static public inline function hasChildNodes(xml:Xml):Bool 
	{
		return xml.iterator().hasNext();
	}

	static public function lastChild(xml:Xml)
	{
		var lastChild:Xml = null;
		for (child in xml)
		{
			lastChild = child;
		}
		return lastChild;
	}

	static public inline function appendChild(xml:Xml, child:Xml)
	{
		xml.insertChild(child, Lambda.count(xml));
	}

	static public inline function insertBefore(xml:Xml, content:DOMNode, target:DOMNode)
	{
		var targetIndex = 0;
		while (xml.iterator().hasNext() && xml.iterator().next() != target)
		{
			targetIndex++;
		}
		xml.insertChild(content, targetIndex);
	}

	static public inline function nextSibling(xml:Xml)
	{
		var p = xml.parent;
		var itsTheNextOne = false;
		var sibling:Xml = null;
		for (child in p)
		{
			if (itsTheNextOne)
			{
				sibling = child;
				break;
			}
			if (child == xml) itsTheNextOne = true;
		}
		return sibling;
	}

	static public inline function previousSibling(xml:Xml)
	{
		var p = xml.parent;
		var sibling:Xml;
		for (child in p)
		{
			if (child != xml)
			{
				sibling = child;
			}
			else
			{
				// If it's equal, leave "sibling" set to the previous value,
				// and exit the loop...
				break;
			}
		}
		return sibling;
	}

	static public function empty(xml:Xml)
	{
		while (xml.firstChild() != null)
		{
			xml.removeChild(xml.firstChild());
		}
	}

	static public function textContent(xml:Xml)
	{
		var ret = "";
		if (xml.nodeType == domtools.DOMType.ELEMENT_NODE || xml.nodeType == domtools.DOMType.DOCUMENT_NODE)
		{
			var allDescendants:DOMCollection;
			var textDescendants:DOMCollection;
			
			allDescendants = domtools.single.Traversing.descendants(xml, false);
			
			textDescendants = allDescendants.filter(function(x:Xml)
			{
				return x.nodeType == domtools.DOMType.TEXT_NODE;
			});
			
			
			var s = new StringBuf();
			for (textNode in textDescendants)
			{
				s.add(textNode.toString());
			}
			
			ret = s.toString();
		}
		else 
		{
			ret = xml.nodeValue;
		}
		return ret;
	}

	static public function setTextContent(xml:DOMNode, text:String)
	{
		// if element or document
		if (xml.nodeType == domtools.DOMType.ELEMENT_NODE || xml.nodeType == domtools.DOMType.DOCUMENT_NODE)
		{
			empty(xml);
			var textNode = Xml.createPCData(text);
			xml.addChild(textNode);
		}
		else 
		{
			xml.nodeValue = text;
		}
		
		return text;
	}

	static public function innerHTML(xml:DOMNode)
	{
		var html = "";
		for (child in xml)
		{
			html += child.toString();
		}
		return html;
	}

	static public function setInnerHTML(xml:DOMNode, html:String)
	{
		var xmlDocNode:Xml = null;
		try {
			xmlDocNode = Xml.parse(html);
		} catch (e:Dynamic)
		{
			xmlDocNode = Xml.createDocument();
		}
		

		empty(xml);

		// Just doing `for (child in xmlDocNode) xml.addChild(child)` seems to break things
		// Basically, If there are 2 children, the loop only runs once.  I think the way the
		// iterator works must break when you change the number of children half way through 
		// a loop.  As a workaround, add all children to a List, then move them
		var list = new List();
		for (child in xmlDocNode)
		{
			list.add(child);
		}
		for (child in list)
		{
		 	xml.addChild(cloneNode(child));
		}
		return html;
	}

	static public function cloneNode(xml:DOMNode, ?deep:Bool = true)
	{
		return Xml.parse(xml.toString()).firstChild();
	}
}