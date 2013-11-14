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
import dtx.DOMNode;
import dtx.DOMCollection;

#if !js
class XMLWrapper
{
	static public inline function parentNode(xml:Xml)
	{
		return xml.parent;
	}

	static public function hasChildNodes(xml:Xml):Bool 
	{
		return xml.iterator().hasNext();
	}

	static public function lastChild(xml:Xml)
	{
		var lastChild:Xml = null;
		
		if (xml != null) 
			for (child in xml)
				lastChild = child;
		return lastChild;
	}

	static public function appendChild(xml:Xml, child:Xml)
	{
		if (xml != null && child != null)
		{
			#if flash 
				var flashXML:flash.xml.XML = untyped xml._node;
				if( xml.nodeType != Xml.Element && xml.nodeType != Xml.Document )
					throw "bad nodeType";		
				flashXML.appendChild(untyped child._node);
			#else 
				xml.addChild(child);
			#end
		}
	}

	static public function insertBefore(xml:Xml, content:DOMNode, target:DOMNode)
	{
		if (xml != null && content != null && target != null)
		{
			#if flash
				if (content.parent != null) content.parent.removeChild(content);
				if( xml.nodeType != Xml.Element && xml.nodeType != Xml.Document )
					throw "bad nodeType";
				untyped xml._node.insertChildBefore(target._node, content._node);
			#else 
				var targetIndex = 0;
				var iter = xml.iterator();
				while (iter.hasNext() && iter.next() != target)
				{
					targetIndex++;
				}
				xml.insertChild(content, targetIndex);
			#end
		}
	}

	static public function nextSibling(xml:Xml)
	{
		#if flash 
			var sibling:Xml = null;
			if (xml != null)
			{
				// get the flash node
				var flashXML:flash.xml.XML = untyped xml._node;
				// get the index
				var i = flashXML.childIndex();
				// get the siblings
				var parent = flashXML.parent();
				if (parent != null)
				{
					var children:flash.xml.XMLList = parent.children();
					// get the previous item
					var index = i + 1;
					if (index >= 0 && index < children.length())
					{
						sibling = untyped Xml.wrap( children[index] );
					}
				}
			}
			return sibling;
		#else 
			var sibling:Xml = null;

			if (xml != null)
			{
				var itsTheNextOne = false;
				var p = xml.parent;
				if (p != null)
				{
					for (child in p)
					{
						if (itsTheNextOne)
						{
							sibling = child;
							break;
						}
						if (child == xml) itsTheNextOne = true;
					}
				}
			}
			return sibling;
		#end
	}

	static public function previousSibling(xml:Xml)
	{
		#if flash
			var sibling:Xml = null;
			if (xml != null)
			{
				// get the flash node
				var flashXML:flash.xml.XML = untyped xml._node;
				// get the index
				var i = flashXML.childIndex();
				// get the siblings
				var children:flash.xml.XMLList = flashXML.parent().children();
				// get the previous item
				var index = i - 1;
				if (index >= 0 && index < children.length())
				{
					sibling = untyped Xml.wrap( children[index] );
				}
			}
			return sibling;
		#else 
			var sibling:Xml = null;
			if (xml != null)
			{
				var p = xml.parent;
				if (p != null)
				{
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
				}
			}
			return sibling;
		#end 
	}

	static public function empty(xml:Xml)
	{
		if (xml != null)
		{
			while (xml.firstChild() != null)
			{
				xml.removeChild(xml.firstChild());
			}
		}
	}

	static public function textContent(xml:Xml)
	{
		var ret = "";
		if (xml != null)
		{
			if (xml.nodeType == dtx.DOMType.ELEMENT_NODE || xml.nodeType == dtx.DOMType.DOCUMENT_NODE)
			{
				var allDescendants:DOMCollection;
				var textDescendants:DOMCollection;
				
				allDescendants = dtx.single.Traversing.descendants(xml, false);
				
				textDescendants = allDescendants.filter(function(x:Xml)
				{
					return x.nodeType == dtx.DOMType.TEXT_NODE;
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
		}
		return ret;
	}

	static public function setTextContent(xml:DOMNode, text:String)
	{
		// if element or document
		if (xml.nodeType == dtx.DOMType.ELEMENT_NODE || xml.nodeType == dtx.DOMType.DOCUMENT_NODE)
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
			#if macro 
			xmlDocNode = Xml.parse("<doc>" + html + "</doc>").firstChild();
			#else 
			xmlDocNode = Xml.parse(html);
			#end
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

	static public function cloneNode(xml:DOMNode, ?deep=true)
	{
		var clone = switch (xml.nodeType) {
			case Xml.Element:
				Xml.createElement( xml.nodeName );
			case Xml.PCData:
				Xml.createPCData( StringTools.htmlEscape(xml.nodeValue) );
			case Xml.CData:
				Xml.createCData( StringTools.htmlEscape(xml.nodeValue) );
			case Xml.Comment:
				Xml.createComment( StringTools.htmlEscape(xml.nodeValue) );
			case Xml.DocType:
				Xml.createDocType( StringTools.htmlEscape(xml.nodeValue) );
			case Xml.ProcessingInstruction:
				Xml.createProcessingInstruction( StringTools.htmlEscape(xml.nodeValue) );
			case Xml.Document:
				Xml.createDocument();
			default: throw null;
		}
		if (xml.nodeType==Xml.Element) {
			for ( attName in xml.attributes() ) {
				clone.set( attName, xml.get(attName) );
			}
		}
		if ( xml.nodeType==Xml.Element || xml.nodeType==Xml.Document ) {
			for ( child in xml ) {
				clone.addChild( cloneNode(child) );
			}
		}
		return clone;
	}
}
#end