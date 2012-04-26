package domtools;

import js.w3c.level3.Core;

typedef DOMNode = js.w3c.level3.Core.Node;
typedef Event = js.w3c.level3.Events.Event;

typedef DocumentOrElement = {> Node,
	var querySelector:String->Dynamic->Element;
	var querySelectorAll:String->Dynamic->NodeList;
}

