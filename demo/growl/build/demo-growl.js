$estr = function() { return js.Boot.__string_rec(this,''); }
if(typeof domtools=='undefined') domtools = {}
if(!domtools.single) domtools.single = {}
domtools.single.DOMManipulation = function() { }
domtools.single.DOMManipulation.__name__ = ["domtools","single","DOMManipulation"];
domtools.single.DOMManipulation.append = function(parent,childNode,childCollection) {
	if(parent != null) {
		if(childNode != null) parent.appendChild(childNode);
		if(childCollection != null) {
			var $it0 = childCollection.collection.iterator();
			while( $it0.hasNext() ) {
				var child = $it0.next();
				parent.appendChild(child);
			}
		}
	}
	return parent;
}
domtools.single.DOMManipulation.prepend = function(parent,newChildNode,newChildCollection) {
	if(parent != null) {
		if(newChildNode != null) {
			if(parent.hasChildNodes()) domtools.single.DOMManipulation.insertThisBefore(newChildNode,parent.firstChild); else domtools.single.DOMManipulation.append(parent,newChildNode);
		}
		if(newChildCollection != null) domtools.collection.DOMManipulation.insertThisBefore(newChildCollection,parent.firstChild);
	}
	return parent;
}
domtools.single.DOMManipulation.insertThisBefore = function(content,targetNode,targetCollection) {
	if(content != null) {
		if(targetNode != null) targetNode.parentNode.insertBefore(content,targetNode);
		if(targetCollection != null) {
			var firstChildUsed = false;
			var $it0 = targetCollection.collection.iterator();
			while( $it0.hasNext() ) {
				var target = $it0.next();
				var childToInsert = firstChildUsed?content.cloneNode(true):content;
				target.parentNode.insertBefore(childToInsert,target);
				firstChildUsed = true;
			}
		}
	}
	return content;
}
domtools.single.DOMManipulation.remove = function(childToRemove) {
	if(childToRemove != null && childToRemove.parentNode != null) childToRemove.parentNode.removeChild(childToRemove);
	return childToRemove;
}
domtools.single.DOMManipulation.prototype.__class__ = domtools.single.DOMManipulation;
if(!domtools.collection) domtools.collection = {}
domtools.collection.EventManagement = function() { }
domtools.collection.EventManagement.__name__ = ["domtools","collection","EventManagement"];
domtools.collection.EventManagement.on = function(targetCollection,eventType,listener) {
	var $it0 = targetCollection.collection.iterator();
	while( $it0.hasNext() ) {
		var target = $it0.next();
		domtools.single.EventManagement.on(target,eventType,listener);
	}
	return targetCollection;
}
domtools.collection.EventManagement.submit = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"submit",listener);
}
domtools.collection.EventManagement.click = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"click",listener);
}
domtools.collection.EventManagement.prototype.__class__ = domtools.collection.EventManagement;
domtools.single.Traversing = function() { }
domtools.single.Traversing.__name__ = ["domtools","single","Traversing"];
domtools.single.Traversing.children = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var children = new domtools.Query();
	if(node != null && domtools.single.ElementManipulation.isElement(node)) children.addNodeList(node.childNodes,elementsOnly);
	return children;
}
domtools.single.Traversing.find = function(node,selector) {
	var newQuery = new domtools.Query();
	if(node != null && domtools.single.ElementManipulation.isElement(node)) {
		var element = node;
		newQuery.addNodeList(element.querySelectorAll(selector));
	}
	return newQuery;
}
domtools.single.Traversing.prototype.__class__ = domtools.single.Traversing;
domtools.collection.DOMManipulation = function() { }
domtools.collection.DOMManipulation.__name__ = ["domtools","collection","DOMManipulation"];
domtools.collection.DOMManipulation.append = function(parentCollection,childNode,childCollection) {
	var firstChildUsed = false;
	if(parentCollection != null) {
		var $it0 = parentCollection.collection.iterator();
		while( $it0.hasNext() ) {
			var parent = $it0.next();
			childNode = firstChildUsed && childNode != null?childNode.cloneNode(true):childNode;
			childCollection = firstChildUsed && childCollection != null?childCollection.clone():childCollection;
			domtools.single.DOMManipulation.append(parent,childNode,childCollection);
			firstChildUsed = true;
		}
	}
	return parentCollection;
}
domtools.collection.DOMManipulation.prepend = function(parentCollection,childNode,childCollection) {
	var firstChildUsed = false;
	if(parentCollection != null) {
		var $it0 = parentCollection.collection.iterator();
		while( $it0.hasNext() ) {
			var parent = $it0.next();
			if(firstChildUsed == false) firstChildUsed = true; else {
				if(childNode != null) childNode = childNode.cloneNode(true);
				if(childCollection != null) childCollection = childCollection.clone(true);
			}
			domtools.single.DOMManipulation.prepend(parent,childNode,childCollection);
		}
	}
	return parentCollection;
}
domtools.collection.DOMManipulation.insertThisBefore = function(content,targetNode,targetCollection) {
	if(content != null) {
		if(targetNode != null) {
			var $it0 = content.collection.iterator();
			while( $it0.hasNext() ) {
				var childToAdd = $it0.next();
				domtools.single.DOMManipulation.insertThisBefore(childToAdd,targetNode);
			}
		}
		if(targetCollection != null) {
			var firstChildUsed = false;
			var childCollection = content;
			var $it1 = targetCollection.collection.iterator();
			while( $it1.hasNext() ) {
				var target = $it1.next();
				childCollection = firstChildUsed?childCollection.clone():childCollection;
				domtools.collection.DOMManipulation.insertThisBefore(childCollection,target);
				firstChildUsed = true;
			}
		}
	}
	return content;
}
domtools.collection.DOMManipulation.remove = function(nodesToRemove) {
	if(nodesToRemove != null) {
		var $it0 = nodesToRemove.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			domtools.single.DOMManipulation.remove(node);
		}
	}
	return nodesToRemove;
}
domtools.collection.DOMManipulation.prototype.__class__ = domtools.collection.DOMManipulation;
domtools.collection.ElementManipulation = function() { }
domtools.collection.ElementManipulation.__name__ = ["domtools","collection","ElementManipulation"];
domtools.collection.ElementManipulation.setAttr = function(query,attName,attValue) {
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			domtools.single.ElementManipulation.setAttr(node,attName,attValue);
		}
	}
	return query;
}
domtools.collection.ElementManipulation.val = function(query) {
	return query != null && query.collection.length > 0?domtools.single.ElementManipulation.val(query.collection[0]):"";
}
domtools.collection.ElementManipulation.setText = function(query,text) {
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			domtools.single.ElementManipulation.setText(node,text);
		}
	}
	return query;
}
domtools.collection.ElementManipulation.setInnerHTML = function(query,html) {
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			domtools.single.ElementManipulation.setInnerHTML(node,html);
		}
	}
	return query;
}
domtools.collection.ElementManipulation.prototype.__class__ = domtools.collection.ElementManipulation;
StringTools = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.prototype.__class__ = StringTools;
Reflect = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	if(o.hasOwnProperty != null) return o.hasOwnProperty(field);
	var arr = Reflect.fields(o);
	var $it0 = arr.iterator();
	while( $it0.hasNext() ) {
		var t = $it0.next();
		if(t == field) return true;
	}
	return false;
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	if(o == null) return new Array();
	var a = new Array();
	if(o.hasOwnProperty) {
		for(var i in o) if( o.hasOwnProperty(i) ) a.push(i);
	} else {
		var t;
		try {
			t = o.__proto__;
		} catch( e ) {
			t = null;
		}
		if(t != null) o.__proto__ = null;
		for(var i in o) if( i != "__proto__" ) a.push(i);
		if(t != null) o.__proto__ = t;
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && f.__name__ == null;
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && v.__name__ != null;
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = new Array();
		var _g1 = 0, _g = arguments.length;
		while(_g1 < _g) {
			var i = _g1++;
			a.push(arguments[i]);
		}
		return f(a);
	};
}
Reflect.prototype.__class__ = Reflect;
if(typeof haxe=='undefined') haxe = {}
haxe.Log = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.prototype.__class__ = haxe.Log;
domtools.Query = function(selector,node,collection) {
	if( selector === $_ ) return;
	if(selector == null) selector = "";
	this.collection = new Array();
	if(node != null) {
		if(node != null) {
			if(Lambda.has(this.collection,node) == false) this.collection.push(node);
		}
		this;
	}
	if(collection != null) this.addCollection(collection);
	if(selector != "") {
		var nodeList = ((function($this) {
			var $r;
			if(domtools.Query.document == null) domtools.Query.document = document;
			$r = domtools.Query.document;
			return $r;
		}(this))).querySelectorAll(selector,null);
		this.addNodeList(nodeList);
	}
}
domtools.Query.__name__ = ["domtools","Query"];
domtools.Query.document = null;
domtools.Query.window = null;
domtools.Query.create = function(name) {
	var elm = null;
	if(name != null) try {
		elm = document.createElement(name);
	} catch( e ) {
		haxe.Log.trace("broken",{ fileName : "Query.hx", lineNumber : 215, className : "domtools.Query", methodName : "create"});
		elm = null;
	}
	return elm;
}
domtools.Query.parse = function(html) {
	var q;
	if(html != null) {
		var n = domtools.Query.create("div");
		domtools.single.ElementManipulation.setInnerHTML(n,html);
		q = domtools.single.Traversing.children(n,false);
	} else q = new domtools.Query();
	return q;
}
domtools.Query.get_window = function() {
	return window;
}
domtools.Query.get_document = function() {
	if(domtools.Query.document == null) domtools.Query.document = document;
	return domtools.Query.document;
}
domtools.Query.prototype.collection = null;
domtools.Query.prototype.length = null;
domtools.Query.prototype.iterator = function() {
	return this.collection.iterator();
}
domtools.Query.prototype.getNode = function(i) {
	if(i == null) i = 0;
	return this.collection[i];
}
domtools.Query.prototype.add = function(node) {
	if(node != null) {
		if(Lambda.has(this.collection,node) == false) this.collection.push(node);
	}
	return this;
}
domtools.Query.prototype.addCollection = function(collection,elementsOnly) {
	if(elementsOnly == null) elementsOnly = false;
	if(collection != null) {
		var $it0 = collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			if(elementsOnly == false || domtools.single.ElementManipulation.isElement(node)) {
				if(node != null) {
					if(Lambda.has(this.collection,node) == false) this.collection.push(node);
				}
				this;
			}
		}
	}
	return this;
}
domtools.Query.prototype.addNodeList = function(nodeList,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var _g1 = 0, _g = nodeList.length;
	while(_g1 < _g) {
		var i = _g1++;
		var node = nodeList.item(i);
		if(elementsOnly == false || domtools.single.ElementManipulation.isElement(node)) {
			if(node != null) {
				if(Lambda.has(this.collection,node) == false) this.collection.push(node);
			}
			this;
		}
	}
	return this;
}
domtools.Query.prototype.clone = function(deep) {
	if(deep == null) deep = true;
	var q = new domtools.Query();
	var $it0 = this.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		q.add(node.cloneNode(deep));
	}
	return q;
}
domtools.Query.prototype.get_length = function() {
	return this.collection.length;
}
domtools.Query.prototype.__class__ = domtools.Query;
domtools.Widget = function(template) {
	if( template === $_ ) return;
	domtools.Query.call(this);
	var q = domtools.Query.parse(template);
	this.collection = q.collection;
}
domtools.Widget.__name__ = ["domtools","Widget"];
domtools.Widget.__super__ = domtools.Query;
for(var k in domtools.Query.prototype ) domtools.Widget.prototype[k] = domtools.Query.prototype[k];
domtools.Widget.prototype.__class__ = domtools.Widget;
Notification = function(title,comment) {
	if( title === $_ ) return;
	var me = this;
	domtools.Widget.call(this,Notification.template);
	domtools.collection.ElementManipulation.setText(domtools.collection.Traversing.find(this,"h4"),title);
	domtools.collection.ElementManipulation.setInnerHTML(domtools.collection.Traversing.find(this,"p"),StringTools.replace(comment,"\n","\n<br />"));
	domtools.collection.EventManagement.on(domtools.collection.Traversing.find(this,".close"),"click",function(e) {
		haxe.Log.trace("remove",{ fileName : "Notification.hx", lineNumber : 22, className : "Notification", methodName : "new"});
		domtools.collection.DOMManipulation.remove(me);
	});
}
Notification.__name__ = ["Notification"];
Notification.__super__ = domtools.Widget;
for(var k in domtools.Widget.prototype ) Notification.prototype[k] = domtools.Widget.prototype[k];
Notification.prototype.__class__ = Notification;
domtools.Tools = function() { }
domtools.Tools.__name__ = ["domtools","Tools"];
domtools.Tools.find = function(selector) {
	return new domtools.Query(selector);
}
domtools.Tools.prototype.__class__ = domtools.Tools;
domtools.collection.Traversing = function() { }
domtools.collection.Traversing.__name__ = ["domtools","collection","Traversing"];
domtools.collection.Traversing.find = function(query,selector) {
	var newQuery = new domtools.Query();
	if(query != null && selector != null && selector != "") {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			if(domtools.single.ElementManipulation.isElement(node)) {
				var element = node;
				newQuery.addNodeList(element.querySelectorAll(selector));
			}
		}
	}
	return newQuery;
}
domtools.collection.Traversing.prototype.__class__ = domtools.collection.Traversing;
ProgressBar = function(percentage) {
	if( percentage === $_ ) return;
	if(percentage == null) percentage = 0;
	var me = this;
	domtools.Widget.call(this,ProgressBar.template);
	this.updateProgress(percentage);
	domtools.collection.EventManagement.on(this,"click",function(e) {
		var p = Math.random() * 100;
		me.updateProgress(p);
	});
}
ProgressBar.__name__ = ["ProgressBar"];
ProgressBar.__super__ = domtools.Widget;
for(var k in domtools.Widget.prototype ) ProgressBar.prototype[k] = domtools.Widget.prototype[k];
ProgressBar.prototype.updateProgress = function(percentage) {
	domtools.collection.ElementManipulation.setAttr(domtools.collection.Traversing.find(this,".bar"),"style","width: " + percentage + "%");
}
ProgressBar.prototype.__class__ = ProgressBar;
haxe.Firebug = function() { }
haxe.Firebug.__name__ = ["haxe","Firebug"];
haxe.Firebug.trace = function(v,inf) {
	var type = inf != null && inf.customParams != null?inf.customParams[0]:null;
	if(type != "warn" && type != "info" && type != "debug" && type != "error") type = inf == null?"error":"log";
	console[type]((inf == null?"":inf.fileName + ":" + inf.lineNumber + " : ") + Std.string(v));
}
haxe.Firebug.prototype.__class__ = haxe.Firebug;
Std = function() { }
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
Std.prototype.__class__ = Std;
Lambda = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.has = function(it,elt,cmp) {
	if(cmp == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x == elt) return true;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(cmp(x,elt)) return true;
		}
	}
	return false;
}
Lambda.prototype.__class__ = Lambda;
List = function() { }
List.__name__ = ["List"];
List.prototype.length = null;
List.prototype.__class__ = List;
domtools.single.EventManagement = function() { }
domtools.single.EventManagement.__name__ = ["domtools","single","EventManagement"];
domtools.single.EventManagement.on = function(target,eventType,listener) {
	var elm = target;
	elm.addEventListener(eventType,listener,false);
	return target;
}
domtools.single.EventManagement.submit = function(target,listener) {
	return domtools.single.EventManagement.on(target,"submit",listener);
}
domtools.single.EventManagement.click = function(target,listener) {
	return domtools.single.EventManagement.on(target,"click",listener);
}
domtools.single.EventManagement.prototype.__class__ = domtools.single.EventManagement;
if(typeof js=='undefined') js = {}
js.Lib = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.prototype.__class__ = js.Lib;
js.Boot = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__unhtml(js.Boot.__string_rec(v,"")) + "<br/>";
	var d = document.getElementById("haxe:trace");
	if(d == null) alert("No haxe:trace element defined\n" + msg); else d.innerHTML += msg;
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.__closure = function(o,f) {
	var m = o[f];
	if(m == null) return null;
	var f1 = function() {
		return m.apply(o,arguments);
	};
	f1.scope = o;
	f1.method = m;
	return f1;
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
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__") {
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
		if(x != x) return null;
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
	$closure = js.Boot.__closure;
}
js.Boot.prototype.__class__ = js.Boot;
domtools.single.ElementManipulation = function() { }
domtools.single.ElementManipulation.__name__ = ["domtools","single","ElementManipulation"];
domtools.single.ElementManipulation.isElement = function(node) {
	return node != null && node.nodeType == domtools.single.ElementManipulation.NodeTypeElement;
}
domtools.single.ElementManipulation.attr = function(elm,attName) {
	var ret = "";
	if(domtools.single.ElementManipulation.isElement(elm)) {
		var element = elm;
		ret = element.getAttribute(attName);
		if(ret == null) ret = "";
	}
	return ret;
}
domtools.single.ElementManipulation.setAttr = function(elm,attName,attValue) {
	if(elm != null && elm.nodeType == domtools.single.ElementManipulation.NodeTypeElement) {
		var element = elm;
		element.setAttribute(attName,attValue);
	}
	return elm;
}
domtools.single.ElementManipulation.val = function(node) {
	var val = "";
	if(node != null) switch(node.nodeType) {
	case domtools.single.ElementManipulation.NodeTypeElement:
		val = Reflect.field(node,"value");
		if(val == null) val = domtools.single.ElementManipulation.attr(node,"value");
		break;
	default:
		val = node.nodeValue;
	}
	return val;
}
domtools.single.ElementManipulation.setText = function(elm,text) {
	if(elm != null) {
		if(domtools.single.ElementManipulation.isElement(elm)) elm.textContent = text; else elm.nodeValue = text;
	}
	return elm;
}
domtools.single.ElementManipulation.setInnerHTML = function(elm,html) {
	if(elm != null) switch(elm.nodeType) {
	case domtools.single.ElementManipulation.NodeTypeElement:
		var element = elm;
		element.innerHTML = html;
		break;
	default:
		elm.textContent = html;
	}
	return elm;
}
domtools.single.ElementManipulation.prototype.__class__ = domtools.single.ElementManipulation;
Main = function() { }
Main.__name__ = ["Main"];
Main.main = function() {
	haxe.Log.trace = haxe.Firebug.trace;
	window.onload = Main.run;
}
Main.run = function(e) {
	var form = domtools.Tools.find("form");
	var titleInput = domtools.Tools.find("#title");
	var commentInput = domtools.Tools.find("#comment");
	domtools.collection.EventManagement.on(form,"submit",function(e1) {
		var n = new Notification(domtools.collection.ElementManipulation.val(titleInput),domtools.collection.ElementManipulation.val(commentInput));
		domtools.collection.DOMManipulation.prepend(domtools.Tools.find("#notifications"),null,n);
	});
	domtools.collection.EventManagement.on(domtools.Tools.find("#notifyWithProgress"),"click",function(e1) {
		var n = new Notification(domtools.collection.ElementManipulation.val(titleInput),domtools.collection.ElementManipulation.val(commentInput));
		var percentage = Math.random() * 100;
		var p = new ProgressBar(percentage);
		domtools.collection.DOMManipulation.append(n,null,p);
		domtools.collection.DOMManipulation.prepend(domtools.Tools.find("#notifications"),null,n);
	});
}
Main.prototype.__class__ = Main;
$_ = {}
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
	d.prototype.__class__ = d;
	d.__name__ = ["Date"];
}
{
	String.prototype.__class__ = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = Array;
	Array.__name__ = ["Array"];
	Int = { __name__ : ["Int"]};
	Dynamic = { __name__ : ["Dynamic"]};
	Float = Number;
	Float.__name__ = ["Float"];
	Bool = { __ename__ : ["Bool"]};
	Class = { __name__ : ["Class"]};
	Enum = { };
	Void = { __ename__ : ["Void"]};
}
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
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
Notification.template = "<div class='notification alert fade in out'>\n\t\t<a class='close' href='#'>&times;</a>\n\t\t<h4 class='alert-heading'>Title</h4>\n\t\t<p>Description goes here</p>\n\t</div>";
ProgressBar.template = "<div class='progress'>\n\t\t<div class='bar' style='width: '>\n\t</div>";
domtools.single.ElementManipulation.NodeTypeElement = 1;
Main.main()