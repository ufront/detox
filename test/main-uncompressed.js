var $_, $hxClasses = $hxClasses || {}, $estr = function() { return js.Boot.__string_rec(this,''); }
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var test = test || {}
test.Main = $hxClasses["test.Main"] = function() { }
test.Main.__name__ = ["test","Main"];
test.Main.main = function() {
	haxe.Log.trace = haxe.Firebug.trace;
	window.onload = test.Main.run;
}
test.Main.run = function(e) {
	var h1Node = new domtools.Query("h1");
	var hiddenField = new domtools.Query("#hiddenfield");
	var textContentTest = new domtools.Query("#textcontenttest");
	var innerHTMLTest = new domtools.Query("#innerhtmltest");
	domtools.QueryElementManipulation.setAttr(h1Node,"id","bigtitle");
	haxe.Log.trace(domtools.QueryElementManipulation.attr(h1Node,"id"),{ fileName : "Main.hx", lineNumber : 31, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.text(domtools.QueryElementManipulation.setText(h1Node,"New Title")),{ fileName : "Main.hx", lineNumber : 32, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.text(textContentTest),{ fileName : "Main.hx", lineNumber : 33, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.text(domtools.QueryElementManipulation.setText(textContentTest,"Simplified")),{ fileName : "Main.hx", lineNumber : 34, className : "test.Main", methodName : "run"});
	domtools.QueryElementManipulation.addClass(h1Node,"big");
	domtools.QueryElementManipulation.addClass(h1Node,"ass");
	domtools.QueryElementManipulation.addClass(h1Node,"title");
	haxe.Log.trace(domtools.QueryElementManipulation.attr(h1Node,"class"),{ fileName : "Main.hx", lineNumber : 40, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.hasClass(h1Node,"big"),{ fileName : "Main.hx", lineNumber : 42, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.hasClass(h1Node,"massive"),{ fileName : "Main.hx", lineNumber : 43, className : "test.Main", methodName : "run"});
	domtools.QueryElementManipulation.removeAttr(h1Node,"class");
	haxe.Log.trace(domtools.QueryElementManipulation.hasClass(h1Node,"big"),{ fileName : "Main.hx", lineNumber : 46, className : "test.Main", methodName : "run"});
	domtools.QueryElementManipulation.addClass(domtools.QueryElementManipulation.addClass(h1Node,"no-duplicate"),"no-duplicate");
	haxe.Log.trace(domtools.QueryElementManipulation.attr(h1Node,"class"),{ fileName : "Main.hx", lineNumber : 48, className : "test.Main", methodName : "run"});
	domtools.QueryElementManipulation.removeAttr(h1Node,"class");
	domtools.QueryElementManipulation.addClass(domtools.QueryElementManipulation.addClass(domtools.QueryElementManipulation.addClass(domtools.QueryElementManipulation.addClass(domtools.QueryElementManipulation.addClass(h1Node,"one"),"two"),"three"),"four"),"five");
	haxe.Log.trace(domtools.QueryElementManipulation.attr(h1Node,"class"),{ fileName : "Main.hx", lineNumber : 52, className : "test.Main", methodName : "run"});
	domtools.QueryElementManipulation.removeClass(domtools.QueryElementManipulation.removeClass(domtools.QueryElementManipulation.removeClass(h1Node,"one"),"three"),"five");
	haxe.Log.trace(domtools.QueryElementManipulation.attr(h1Node,"class"),{ fileName : "Main.hx", lineNumber : 54, className : "test.Main", methodName : "run"});
	domtools.QueryElementManipulation.removeClass(h1Node,"fake-class");
	domtools.QueryElementManipulation.removeClass(domtools.QueryElementManipulation.removeClass(h1Node,"two"),"four");
	haxe.Log.trace(domtools.QueryElementManipulation.attr(h1Node,"class"),{ fileName : "Main.hx", lineNumber : 58, className : "test.Main", methodName : "run"});
	domtools.QueryElementManipulation.toggleClass(h1Node,"toggle-on");
	haxe.Log.trace(domtools.QueryElementManipulation.attr(h1Node,"class"),{ fileName : "Main.hx", lineNumber : 61, className : "test.Main", methodName : "run"});
	domtools.QueryElementManipulation.toggleClass(h1Node,"toggle-on");
	haxe.Log.trace(domtools.QueryElementManipulation.attr(h1Node,"class"),{ fileName : "Main.hx", lineNumber : 63, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.val(hiddenField),{ fileName : "Main.hx", lineNumber : 65, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.innerHTML(innerHTMLTest),{ fileName : "Main.hx", lineNumber : 67, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.innerHTML(domtools.QueryTraversing.firstChild(innerHTMLTest)),{ fileName : "Main.hx", lineNumber : 68, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryTraversing.firstChild(domtools.QueryElementManipulation.setInnerHTML(innerHTMLTest,"Welcome to the <strong>WORLD</strong> of tomorrow")).collection[0].nodeType,{ fileName : "Main.hx", lineNumber : 69, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.innerHTML(domtools.QueryTraversing.firstChild(innerHTMLTest)),{ fileName : "Main.hx", lineNumber : 70, className : "test.Main", methodName : "run"});
	var clonedNode = domtools.QueryElementManipulation.setAttr(h1Node.clone(),"id","secondTitle");
	domtools.DOMManipulation.append(CommonJS.getHtmlDocument().body,null,clonedNode);
	domtools.QueryElementManipulation.setText(clonedNode,"Second Title");
	haxe.Log.trace(new domtools.Query("#secondTitle") != null,{ fileName : "Main.hx", lineNumber : 75, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.text(h1Node.clone()),{ fileName : "Main.hx", lineNumber : 76, className : "test.Main", methodName : "run"});
	var allListItems = new domtools.Query("li");
	haxe.Log.trace(domtools.QueryElementManipulation.text(new domtools.Query(null,allListItems.collection[0])),{ fileName : "Main.hx", lineNumber : 79, className : "test.Main", methodName : "run"});
	haxe.Log.trace(allListItems.collection.length,{ fileName : "Main.hx", lineNumber : 80, className : "test.Main", methodName : "run"});
	var i = 0;
	var $it0 = allListItems.collection.iterator();
	while( $it0.hasNext() ) {
		var n = $it0.next();
		i = i + 1;
	}
	haxe.Log.trace(i == allListItems.collection.length,{ fileName : "Main.hx", lineNumber : 83, className : "test.Main", methodName : "run"});
	haxe.Log.trace(new domtools.Query(null,allListItems.collection[allListItems.collection.length - 1]).collection[0].textContent,{ fileName : "Main.hx", lineNumber : 84, className : "test.Main", methodName : "run"});
	var secondListItems = new domtools.Query("li.second");
	{
		Lambda.iter(secondListItems.collection,function(n) {
			if(domtools.ElementManipulation.hasClass(n,"second")) {
				n.textContent = "This is the 2nd";
				n;
			}
		});
		secondListItems;
	}
	var secondListItemInSecondList = new domtools.Query("ul.second li.second");
	haxe.Log.trace(domtools.QueryElementManipulation.text(secondListItemInSecondList),{ fileName : "Main.hx", lineNumber : 94, className : "test.Main", methodName : "run"});
	var listItemsWithLetterI = new domtools.Query(null,null,Lambda.filter(allListItems.collection,function(n) {
		return n.textContent.indexOf("i") > -1;
	}));
	haxe.Log.trace(listItemsWithLetterI.collection.length,{ fileName : "Main.hx", lineNumber : 99, className : "test.Main", methodName : "run"});
	var $it1 = domtools.QueryTraversing.ancestors(secondListItemInSecondList).collection.iterator();
	while( $it1.hasNext() ) {
		var node = $it1.next();
		haxe.Log.trace(node.nodeName,{ fileName : "Main.hx", lineNumber : 103, className : "test.Main", methodName : "run"});
	}
	haxe.Log.trace(domtools.QueryTraversing.ancestors(secondListItemInSecondList).collection.length,{ fileName : "Main.hx", lineNumber : 105, className : "test.Main", methodName : "run"});
	haxe.Log.trace(domtools.QueryElementManipulation.text(domtools.QueryElementManipulation.addClass(domtools.QueryTraversing.find(new domtools.Query("ul"),"li.first"),"first-list-item")),{ fileName : "Main.hx", lineNumber : 107, className : "test.Main", methodName : "run"});
	var table = new test.Table();
	haxe.Log.trace(domtools.QueryElementManipulation.text(table),{ fileName : "Main.hx", lineNumber : 110, className : "test.Main", methodName : "run"});
	document.body.appendChild(table.collection[0]);
	domtools.QueryElementManipulation.setAttr(domtools.QueryTraversing.find(table,"td"),"style","border:1px solid black");
	var face = "hello";
	domtools.QueryEvents.on(table,"click",function(e1) {
		var table1 = e1.currentTarget;
		var clickedNode = e1.target;
		haxe.Log.trace(table1.nodeName.toLowerCase(),{ fileName : "Main.hx", lineNumber : 118, className : "test.Main", methodName : "run"});
		haxe.Log.trace(clickedNode.nodeName.toLowerCase() + ": " + clickedNode.textContent,{ fileName : "Main.hx", lineNumber : 119, className : "test.Main", methodName : "run"});
	});
	domtools.QueryEvents.one(new domtools.Query("#secondTitle"),"click",function(e1) {
		haxe.Log.trace("You got me! Never again...",{ fileName : "Main.hx", lineNumber : 123, className : "test.Main", methodName : "run"});
	});
	haxe.Log.trace(domtools.QueryEvents.hover(new domtools.Query("#innerhtmltest"),function(e1) {
		var n = e1.currentTarget;
		domtools.ElementManipulation.setAttr(n,"style","color:blue");
	},function(e1) {
		var n = e1.currentTarget;
		domtools.ElementManipulation.setAttr(n,"style","");
	}).collection.length,{ fileName : "Main.hx", lineNumber : 126, className : "test.Main", methodName : "run"});
}
test.Main.prototype = {
	__class__: test.Main
}
var haxe = haxe || {}
haxe.Log = $hxClasses["haxe.Log"] = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.prototype = {
	__class__: haxe.Log
}
var domtools = domtools || {}
domtools.Traversing = $hxClasses["domtools.Traversing"] = function() { }
domtools.Traversing.__name__ = ["domtools","Traversing"];
domtools.Traversing.firstChild = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var firstChild = null;
	if(domtools.ElementManipulation.isElement(node)) {
		var e = node.firstChild;
		while(elementsOnly == true && e != null && domtools.ElementManipulation.isElement(e) == false) e = e.nextSibling;
		if(e != null) firstChild = e;
	}
	return firstChild;
}
domtools.Traversing.parent = function(node) {
	return node.parentNode != null?node.parentNode:null;
}
domtools.Traversing.ancestors = function(node) {
	var ancestors = new domtools.Query();
	{
		ancestors.collection.push(domtools.Traversing.parent(node));
		ancestors;
	}
	if(ancestors.collection.length > 0) ancestors.addCollection(domtools.QueryTraversing.parent(ancestors));
	return ancestors;
}
domtools.Traversing.find = function(node,selector) {
	var newQuery = new domtools.Query();
	if(domtools.ElementManipulation.isElement(node)) {
		var element = node;
		newQuery.addNodeList(element.querySelectorAll(selector));
	}
	return newQuery;
}
domtools.Traversing.prototype = {
	__class__: domtools.Traversing
}
domtools.QueryTraversing = $hxClasses["domtools.QueryTraversing"] = function() { }
domtools.QueryTraversing.__name__ = ["domtools","QueryTraversing"];
domtools.QueryTraversing.firstChild = function(query,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var children = new domtools.Query();
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		if(domtools.ElementManipulation.isElement(node)) {
			var e = node.firstChild;
			while(elementsOnly == true && e != null && domtools.ElementManipulation.isElement(e) == false) e = e.nextSibling;
			if(e != null) {
				children.collection.push(e);
				children;
			}
		}
	}
	return children;
}
domtools.QueryTraversing.parent = function(query) {
	var parents = new domtools.Query();
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		if(node.parentNode != null) {
			parents.collection.push(node.parentNode);
			parents;
		}
	}
	return parents;
}
domtools.QueryTraversing.ancestors = function(query) {
	var ancestors = domtools.QueryTraversing.parent(query);
	if(ancestors.collection.length > 0) ancestors.addCollection(domtools.QueryTraversing.parent(ancestors));
	return ancestors;
}
domtools.QueryTraversing.find = function(query,selector) {
	var newQuery = new domtools.Query();
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		if(domtools.ElementManipulation.isElement(node)) {
			var element = node;
			newQuery.addNodeList(element.querySelectorAll(selector));
		}
	}
	return newQuery;
}
domtools.QueryTraversing.prototype = {
	__class__: domtools.QueryTraversing
}
haxe.Firebug = $hxClasses["haxe.Firebug"] = function() { }
haxe.Firebug.__name__ = ["haxe","Firebug"];
haxe.Firebug.trace = function(v,inf) {
	var type = inf != null && inf.customParams != null?inf.customParams[0]:null;
	if(type != "warn" && type != "info" && type != "debug" && type != "error") type = inf == null?"error":"log";
	console[type]((inf == null?"":inf.fileName + ":" + inf.lineNumber + " : ") + Std.string(v));
}
haxe.Firebug.prototype = {
	__class__: haxe.Firebug
}
domtools.DOMManipulation = $hxClasses["domtools.DOMManipulation"] = function() { }
domtools.DOMManipulation.__name__ = ["domtools","DOMManipulation"];
domtools.DOMManipulation.append = function(parent,childNode,childCollection) {
	if(childNode != null) parent.appendChild(childNode); else if(childCollection != null) {
		var $it0 = childCollection.collection.iterator();
		while( $it0.hasNext() ) {
			var child = $it0.next();
			parent.appendChild(child);
		}
	}
	return parent;
}
domtools.DOMManipulation.prototype = {
	__class__: domtools.DOMManipulation
}
var Std = $hxClasses["Std"] = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	if(x < 0) return Math.ceil(x);
	return Math.floor(x);
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && x.charCodeAt(1) == 120) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
Std.prototype = {
	__class__: Std
}
domtools.Query = $hxClasses["domtools.Query"] = function(selector,node,collection) {
	if(selector == null) selector = "";
	this.collection = new Array();
	if(node != null) {
		this.collection.push(node);
		this;
	} else if(collection != null) this.addCollection(collection); else if(selector != "") {
		var nodeList = CommonJS.getAll(selector);
		this.addNodeList(nodeList);
	}
}
domtools.Query.__name__ = ["domtools","Query"];
domtools.Query.__properties__ = {get_window:"get_window",get_document:"get_document"}
domtools.Query.document = null;
domtools.Query.window = null;
domtools.Query.createElement = function(name) {
	return document.createElement(name);
}
domtools.Query.get_window = function() {
	return window;
}
domtools.Query.get_document = function() {
	return document;
}
domtools.Query.prototype = {
	collection: null
	,length: null
	,iterator: function() {
		return this.collection.iterator();
	}
	,getNode: function(i) {
		if(i == null) i = 0;
		return this.collection[i];
	}
	,eq: function(i) {
		if(i == null) i = 0;
		return new domtools.Query(null,this.collection[i]);
	}
	,first: function() {
		return new domtools.Query(null,this.collection[0]);
	}
	,last: function() {
		return new domtools.Query(null,this.collection[this.collection.length - 1]);
	}
	,add: function(node) {
		return (function($this) {
			var $r;
			$this.collection.push(node);
			$r = $this;
			return $r;
		}(this));
	}
	,addCollection: function(collection) {
		var $it0 = collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			this.collection.push(node);
		}
		return this;
	}
	,addNodeList: function(nodeList,elementsOnly) {
		if(elementsOnly == null) elementsOnly = true;
		var _g1 = 0, _g = nodeList.length;
		while(_g1 < _g) {
			var i = _g1++;
			var node = nodeList.item(i);
			if(elementsOnly == false || domtools.ElementManipulation.isElement(node)) {
				this.collection.push(node);
				this;
			}
		}
		return this;
	}
	,each: function(f) {
		return (function($this) {
			var $r;
			Lambda.iter($this.collection,f);
			$r = $this;
			return $r;
		}(this));
	}
	,filter: function(fn) {
		return new domtools.Query(null,null,Lambda.filter(this.collection,fn));
	}
	,clone: function() {
		var q = new domtools.Query();
		var $it0 = this.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			{
				q.collection.push(node.cloneNode(true));
				q;
			}
		}
		return q;
	}
	,get_length: function() {
		return this.collection.length;
	}
	,__class__: domtools.Query
	,__properties__: {get_length:"get_length"}
}
var Lambda = $hxClasses["Lambda"] = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.iter = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
}
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
}
Lambda.prototype = {
	__class__: Lambda
}
domtools.AbstractCustomElement = $hxClasses["domtools.AbstractCustomElement"] = function(name) {
	domtools.Query.call(this);
	var elm = document.createElement(name);
	{
		this.collection.push(elm);
		this;
	}
}
domtools.AbstractCustomElement.__name__ = ["domtools","AbstractCustomElement"];
domtools.AbstractCustomElement.__super__ = domtools.Query;
domtools.AbstractCustomElement.prototype = $extend(domtools.Query.prototype,{
	__class__: domtools.AbstractCustomElement
});
var List = $hxClasses["List"] = function() {
	this.length = 0;
}
List.__name__ = ["List"];
List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,__class__: List
}
domtools.Events = $hxClasses["domtools.Events"] = function() { }
domtools.Events.__name__ = ["domtools","Events"];
domtools.Events.on = function(target,eventType,listener) {
	var elm = target;
	elm.addEventListener(eventType,listener,false);
	return target;
}
domtools.Events.one = function(target,eventType,listener) {
	var fn = null;
	fn = function(e) {
		listener(e);
		target.removeEventListener(eventType,fn,false);
	};
	target.addEventListener(eventType,fn,false);
	return target;
}
domtools.Events.mouseenter = function(target,listener) {
	return domtools.Events.on(target,"mouseover",listener);
}
domtools.Events.mouseleave = function(target,listener) {
	return domtools.Events.on(target,"mouseout",listener);
}
domtools.Events.hover = function(target,listener1,listener2) {
	domtools.Events.on(target,"mouseover",listener1);
	if(listener2 == null) domtools.Events.on(target,"mouseout",listener1); else domtools.Events.on(target,"mouseout",listener2);
	return target;
}
domtools.Events.prototype = {
	__class__: domtools.Events
}
domtools.QueryEvents = $hxClasses["domtools.QueryEvents"] = function() { }
domtools.QueryEvents.__name__ = ["domtools","QueryEvents"];
domtools.QueryEvents.on = function(targetCollection,eventType,listener) {
	var $it0 = targetCollection.collection.iterator();
	while( $it0.hasNext() ) {
		var target = $it0.next();
		domtools.Events.on(target,eventType,listener);
	}
	return targetCollection;
}
domtools.QueryEvents.one = function(targetCollection,eventType,listener) {
	var $it0 = targetCollection.collection.iterator();
	while( $it0.hasNext() ) {
		var target = $it0.next();
		domtools.Events.one(target,eventType,listener);
	}
	return targetCollection;
}
domtools.QueryEvents.hover = function(targetCollection,listener1,listener2) {
	var $it0 = targetCollection.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		domtools.Events.hover(node,listener1,listener2);
	}
	return targetCollection;
}
domtools.QueryEvents.prototype = {
	__class__: domtools.QueryEvents
}
var js = js || {}
js.Lib = $hxClasses["js.Lib"] = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.prototype = {
	__class__: js.Lib
}
js.Boot = $hxClasses["js.Boot"] = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ != null || o.__ename__ != null)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__ != null) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		return o.__enum__ == cl || cl == Class && o.__name__ != null || cl == Enum && o.__ename__ != null;
	}
}
js.Boot.__init = function() {
	js.Lib.isIE = typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null;
	js.Lib.isOpera = typeof window!='undefined' && window.opera != null;
	Array.prototype.copy = Array.prototype.slice;
	Array.prototype.insert = function(i,x) {
		this.splice(i,0,x);
	};
	Array.prototype.remove = Array.prototype.indexOf?function(obj) {
		var idx = this.indexOf(obj);
		if(idx == -1) return false;
		this.splice(idx,1);
		return true;
	}:function(obj) {
		var i = 0;
		var l = this.length;
		while(i < l) {
			if(this[i] == obj) {
				this.splice(i,1);
				return true;
			}
			i++;
		}
		return false;
	};
	Array.prototype.iterator = function() {
		return { cur : 0, arr : this, hasNext : function() {
			return this.cur < this.arr.length;
		}, next : function() {
			return this.arr[this.cur++];
		}};
	};
	if(String.prototype.cca == null) String.prototype.cca = String.prototype.charCodeAt;
	String.prototype.charCodeAt = function(i) {
		var x = this.cca(i);
		if(x != x) return undefined;
		return x;
	};
	var oldsub = String.prototype.substr;
	String.prototype.substr = function(pos,len) {
		if(pos != null && pos != 0 && len != null && len < 0) return "";
		if(len == null) len = this.length;
		if(pos < 0) {
			pos = this.length + pos;
			if(pos < 0) pos = 0;
		} else if(len < 0) len = this.length + len - pos;
		return oldsub.apply(this,[pos,len]);
	};
	Function.prototype["$bind"] = function(o) {
		var f = function() {
			return f.method.apply(f.scope,arguments);
		};
		f.scope = o;
		f.method = this;
		return f;
	};
}
js.Boot.prototype = {
	__class__: js.Boot
}
var CommonJS = $hxClasses["CommonJS"] = function() { }
CommonJS.__name__ = ["CommonJS"];
CommonJS.getHtmlDocument = function() {
	var htmlDocument = document;
	return htmlDocument;
}
CommonJS.getAll = function(domSelection) {
	var htmlDocument = CommonJS.getHtmlDocument();
	return htmlDocument.body.querySelectorAll(domSelection);
}
CommonJS.prototype = {
	__class__: CommonJS
}
test.Table = $hxClasses["test.Table"] = function() {
	domtools.AbstractCustomElement.call(this,"table");
	domtools.QueryElementManipulation.setInnerHTML(this,"<tr><td>Sample</td><td>Table!</td></tr><tr><td>Pretty</td><td>Great</td></tr>");
}
test.Table.__name__ = ["test","Table"];
test.Table.__super__ = domtools.AbstractCustomElement;
test.Table.prototype = $extend(domtools.AbstractCustomElement.prototype,{
	__class__: test.Table
});
domtools.ElementManipulation = $hxClasses["domtools.ElementManipulation"] = function() { }
domtools.ElementManipulation.__name__ = ["domtools","ElementManipulation"];
domtools.ElementManipulation.isElement = function(node) {
	return node.nodeType == domtools.ElementManipulation.NodeTypeElement;
}
domtools.ElementManipulation.attr = function(elm,attName) {
	var ret = "";
	if(domtools.ElementManipulation.isElement(elm)) {
		var element = elm;
		ret = element.getAttribute(attName);
		if(ret == null) ret = "";
	}
	return ret;
}
domtools.ElementManipulation.setAttr = function(elm,attName,attValue) {
	if(elm.nodeType == domtools.ElementManipulation.NodeTypeElement) {
		var element = elm;
		element.setAttribute(attName,attValue);
	}
	return elm;
}
domtools.ElementManipulation.removeAttr = function(elm,attName) {
	if(elm.nodeType == domtools.ElementManipulation.NodeTypeElement) {
		var element = elm;
		element.removeAttribute(attName);
	}
	return elm;
}
domtools.ElementManipulation.hasClass = function(elm,className) {
	return (" " + domtools.ElementManipulation.attr(elm,"class") + " ").indexOf(" " + className + " ") > -1;
}
domtools.ElementManipulation.addClass = function(elm,className) {
	if(domtools.ElementManipulation.hasClass(elm,className) == false) {
		var oldClassName = domtools.ElementManipulation.attr(elm,"class");
		var newClassName = oldClassName == ""?className:oldClassName + " " + className;
		domtools.ElementManipulation.setAttr(elm,"class",newClassName);
	}
	return elm;
}
domtools.ElementManipulation.removeClass = function(elm,className) {
	var classes = domtools.ElementManipulation.attr(elm,"class").split(" ");
	classes.remove(className);
	var newClassValue = classes.join(" ");
	domtools.ElementManipulation.setAttr(elm,"class",newClassValue);
	return elm;
}
domtools.ElementManipulation.toggleClass = function(elm,className) {
	if(domtools.ElementManipulation.hasClass(elm,className)) domtools.ElementManipulation.removeClass(elm,className); else domtools.ElementManipulation.addClass(elm,className);
	return elm;
}
domtools.ElementManipulation.tagName = function(elm) {
	return elm.nodeName.toLowerCase();
}
domtools.ElementManipulation.val = function(elm) {
	return domtools.ElementManipulation.attr(elm,"value");
}
domtools.ElementManipulation.text = function(elm) {
	return elm.textContent;
}
domtools.ElementManipulation.setText = function(elm,text) {
	return (function($this) {
		var $r;
		elm.textContent = text;
		$r = elm;
		return $r;
	}(this));
}
domtools.ElementManipulation.innerHTML = function(elm) {
	var ret = "";
	switch(elm.nodeType) {
	case domtools.ElementManipulation.NodeTypeElement:
		var element = elm;
		ret = element.innerHTML;
		break;
	default:
		ret = elm.textContent;
	}
	return ret;
}
domtools.ElementManipulation.setInnerHTML = function(elm,html) {
	switch(elm.nodeType) {
	case domtools.ElementManipulation.NodeTypeElement:
		var element = elm;
		element.innerHTML = html;
		break;
	default:
		elm.textContent = html;
	}
	return elm;
}
domtools.ElementManipulation.prototype = {
	__class__: domtools.ElementManipulation
}
domtools.QueryElementManipulation = $hxClasses["domtools.QueryElementManipulation"] = function() { }
domtools.QueryElementManipulation.__name__ = ["domtools","QueryElementManipulation"];
domtools.QueryElementManipulation.attr = function(query,attName) {
	return query.collection.length > 0?domtools.ElementManipulation.attr(query.collection[0],attName):"";
}
domtools.QueryElementManipulation.setAttr = function(query,attName,attValue) {
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		domtools.ElementManipulation.setAttr(node,attName,attValue);
	}
	return query;
}
domtools.QueryElementManipulation.removeAttr = function(query,attName) {
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		domtools.ElementManipulation.removeAttr(node,attName);
	}
	return query;
}
domtools.QueryElementManipulation.hasClass = function(query,className) {
	return query.collection.length > 0?domtools.ElementManipulation.hasClass(query.collection[0],className):false;
}
domtools.QueryElementManipulation.addClass = function(query,className) {
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		domtools.ElementManipulation.addClass(node,className);
	}
	return query;
}
domtools.QueryElementManipulation.removeClass = function(query,className) {
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		domtools.ElementManipulation.removeClass(node,className);
	}
	return query;
}
domtools.QueryElementManipulation.toggleClass = function(query,className) {
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		domtools.ElementManipulation.toggleClass(node,className);
	}
	return query;
}
domtools.QueryElementManipulation.val = function(query) {
	return query.collection.length > 0?domtools.ElementManipulation.attr(query.collection[0],"value"):"";
}
domtools.QueryElementManipulation.text = function(query) {
	var text = "";
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		text = text + node.textContent;
	}
	return text;
}
domtools.QueryElementManipulation.setText = function(query,text) {
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		{
			node.textContent = text;
			node;
		}
	}
	return query;
}
domtools.QueryElementManipulation.innerHTML = function(query) {
	var ret = "";
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		ret += domtools.ElementManipulation.innerHTML(node);
	}
	return ret;
}
domtools.QueryElementManipulation.setInnerHTML = function(query,html) {
	var $it0 = query.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		domtools.ElementManipulation.setInnerHTML(node,html);
	}
	return query;
}
domtools.QueryElementManipulation.prototype = {
	__class__: domtools.QueryElementManipulation
}
js.Boot.__res = {}
js.Boot.__init();
{
	Object.prototype.iterator = function() {
      var o = this.instanceKeys();
      var y = this;
      return {
        cur : 0,
        arr : o,
        hasNext: function() { return this.cur < this.arr.length; },
        next: function() { return y[this.arr[this.cur++]]; }
      };
    }
	Object.prototype.instanceKeys = function(proto) {
      var keys = [];
      proto = !proto;
      for(var i in this) {
        if(proto && Object.prototype[i]) continue;
        keys.push(i);
      }
      return keys;
    }
}
{
	var d = Date;
	d.now = function() {
		return new Date();
	};
	d.fromTime = function(t) {
		var d1 = new Date();
		d1["setTime"](t);
		return d1;
	};
	d.fromString = function(s) {
		switch(s.length) {
		case 8:
			var k = s.split(":");
			var d1 = new Date();
			d1["setTime"](0);
			d1["setUTCHours"](k[0]);
			d1["setUTCMinutes"](k[1]);
			d1["setUTCSeconds"](k[2]);
			return d1;
		case 10:
			var k = s.split("-");
			return new Date(k[0],k[1] - 1,k[2],0,0,0);
		case 19:
			var k = s.split(" ");
			var y = k[0].split("-");
			var t = k[1].split(":");
			return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
		default:
			throw "Invalid date format : " + s;
		}
	};
	d.prototype["toString"] = function() {
		var date = this;
		var m = date.getMonth() + 1;
		var d1 = date.getDate();
		var h = date.getHours();
		var mi = date.getMinutes();
		var s = date.getSeconds();
		return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d1 < 10?"0" + d1:"" + d1) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
	};
	d.prototype.__class__ = $hxClasses["Date"] = d;
	d.__name__ = ["Date"];
}
{
	String.prototype.__class__ = $hxClasses["String"] = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = $hxClasses["Array"] = Array;
	Array.__name__ = ["Array"];
	Int = $hxClasses["Int"] = { __name__ : ["Int"]};
	Dynamic = $hxClasses["Dynamic"] = { __name__ : ["Dynamic"]};
	Float = $hxClasses["Float"] = Number;
	Float.__name__ = ["Float"];
	Bool = $hxClasses["Bool"] = { __ename__ : ["Bool"]};
	Class = $hxClasses["Class"] = { __name__ : ["Class"]};
	Enum = { };
	Void = $hxClasses["Void"] = { __ename__ : ["Void"]};
}
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	$hxClasses["Math"] = Math;
	Math.isFinite = function(i) {
		return isFinite(i);
	};
	Math.isNaN = function(i) {
		return isNaN(i);
	};
}
{
	js.Lib.document = document;
	js.Lib.window = window;
	onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if( f == null )
			return false;
		return f(msg,[url+":"+line]);
	}
}
domtools.ElementManipulation.NodeTypeElement = 1;
test.Main.main()