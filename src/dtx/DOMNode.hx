package dtx;

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
typedef DOMElement = DOMNode;
typedef DocumentOrElement = DOMNode;
#end


