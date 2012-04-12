$estr = function() { return js.Boot.__string_rec(this,''); }
if(typeof domtools=='undefined') domtools = {}
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
		haxe.Log.trace("broken",{ fileName : "Query.hx", lineNumber : 192, className : "domtools.Query", methodName : "create"});
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
domtools.Query.setDocument = function(newDocument) {
	if(newDocument != null) {
		if(newDocument.nodeType == 9 || newDocument.nodeType == 1) domtools.Query.document = newDocument;
	}
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
domtools.Query.prototype.eq = function(i) {
	if(i == null) i = 0;
	return new domtools.Query(null,this.collection[i]);
}
domtools.Query.prototype.first = function() {
	return new domtools.Query(null,this.collection[0]);
}
domtools.Query.prototype.last = function() {
	return new domtools.Query(null,this.collection[this.collection.length - 1]);
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
domtools.Query.prototype.removeFromCollection = function(node,nodeCollection) {
	if(node != null) this.collection.remove(node);
	if(nodeCollection != null) {
		var $it0 = nodeCollection.collection.iterator();
		while( $it0.hasNext() ) {
			var n = $it0.next();
			this.collection.remove(n);
		}
	}
	return this;
}
domtools.Query.prototype.each = function(f) {
	if(f != null) Lambda.iter(this.collection,f);
	return this;
}
domtools.Query.prototype.filter = function(fn) {
	var newCollection;
	if(fn != null) {
		var filtered = Lambda.filter(this.collection,fn);
		newCollection = new domtools.Query(null,null,filtered);
	} else newCollection = new domtools.Query(null,null,this.collection);
	return newCollection;
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
domtools.single.DOMManipulation.appendTo = function(child,parentNode,parentCollection) {
	if(parentNode != null) domtools.single.DOMManipulation.append(parentNode,child);
	if(parentCollection != null) domtools.collection.DOMManipulation.append(parentCollection,child);
	return child;
}
domtools.single.DOMManipulation.prependTo = function(child,parentNode,parentCollection) {
	if(parentNode != null) {
		if(parentNode.hasChildNodes()) domtools.single.DOMManipulation.insertThisBefore(child,parentNode.firstChild,parentCollection); else domtools.single.DOMManipulation.append(parentNode,child);
	}
	if(parentCollection != null) domtools.collection.DOMManipulation.prepend(parentCollection,child);
	return child;
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
domtools.single.DOMManipulation.insertThisAfter = function(content,targetNode,targetCollection) {
	if(content != null) {
		if(targetNode != null) {
			if(targetNode.nextSibling != null) targetNode.parentNode.insertBefore(content,targetNode.nextSibling); else targetNode.parentNode.appendChild(content);
		}
		if(targetCollection != null) {
			var firstChildUsed = false;
			var $it0 = targetCollection.collection.iterator();
			while( $it0.hasNext() ) {
				var target = $it0.next();
				var childToInsert = firstChildUsed?content.cloneNode(true):content;
				if(target.nextSibling != null) target.parentNode.insertBefore(childToInsert,target.nextSibling); else domtools.single.DOMManipulation.append(target.parentNode,childToInsert);
				firstChildUsed = true;
			}
		}
	}
	return content;
}
domtools.single.DOMManipulation.beforeThisInsert = function(target,contentNode,contentQuery) {
	if(target != null) {
		if(contentNode != null) domtools.single.DOMManipulation.insertThisBefore(contentNode,target);
		if(contentQuery != null) domtools.collection.DOMManipulation.insertThisBefore(contentQuery,target);
	}
	return target;
}
domtools.single.DOMManipulation.afterThisInsert = function(target,contentNode,contentQuery) {
	if(target != null) {
		if(contentNode != null) domtools.single.DOMManipulation.insertThisAfter(contentNode,target,null);
		if(contentQuery != null) domtools.collection.DOMManipulation.insertThisAfter(contentQuery,target);
	}
	return target;
}
domtools.single.DOMManipulation.remove = function(childToRemove) {
	if(childToRemove != null && childToRemove.parentNode != null) childToRemove.parentNode.removeChild(childToRemove);
	return childToRemove;
}
domtools.single.DOMManipulation.removeChildren = function(parent,childToRemove,childrenToRemove) {
	if(parent != null) {
		if(childToRemove != null && childToRemove.parentNode == parent) parent.removeChild(childToRemove);
		if(childrenToRemove != null) {
			var $it0 = childrenToRemove.collection.iterator();
			while( $it0.hasNext() ) {
				var child = $it0.next();
				if(child.parentNode == parent) parent.removeChild(child);
			}
		}
	}
	return parent;
}
domtools.single.DOMManipulation.empty = function(container) {
	if(container != null) while(container.hasChildNodes()) container.removeChild(container.firstChild);
	return container;
}
domtools.single.DOMManipulation.prototype.__class__ = domtools.single.DOMManipulation;
domtools.single.EventManagement = function() { }
domtools.single.EventManagement.__name__ = ["domtools","single","EventManagement"];
domtools.single.EventManagement.triggerHandler = function(target,event) {
	return target;
}
domtools.single.EventManagement.on = function(target,eventType,listener) {
	var elm = target;
	elm.addEventListener(eventType,listener,false);
	return target;
}
domtools.single.EventManagement.off = function(target,eventType,listener) {
	var elm = target;
	elm.removeEventListener(eventType,listener,false);
	return target;
}
domtools.single.EventManagement.one = function(target,eventType,listener) {
	var fn = null;
	fn = function(e) {
		listener(e);
		target.removeEventListener(eventType,fn,false);
	};
	target.addEventListener(eventType,fn,false);
	return target;
}
domtools.single.EventManagement.mousedown = function(target,listener) {
	return domtools.single.EventManagement.on(target,"mousedown",listener);
}
domtools.single.EventManagement.mouseenter = function(target,listener) {
	return domtools.single.EventManagement.on(target,"mouseover",listener);
}
domtools.single.EventManagement.mouseleave = function(target,listener) {
	return domtools.single.EventManagement.on(target,"mouseout",listener);
}
domtools.single.EventManagement.mousemove = function(target,listener) {
	return domtools.single.EventManagement.on(target,"mousemove",listener);
}
domtools.single.EventManagement.mouseout = function(target,listener) {
	return domtools.single.EventManagement.on(target,"mouseout",listener);
}
domtools.single.EventManagement.mouseover = function(target,listener) {
	return domtools.single.EventManagement.on(target,"mouseover",listener);
}
domtools.single.EventManagement.mouseup = function(target,listener) {
	return domtools.single.EventManagement.on(target,"mouseup",listener);
}
domtools.single.EventManagement.keydown = function(target,listener) {
	return domtools.single.EventManagement.on(target,"keydown",listener);
}
domtools.single.EventManagement.keypress = function(target,listener) {
	return domtools.single.EventManagement.on(target,"keypress",listener);
}
domtools.single.EventManagement.keyup = function(target,listener) {
	return domtools.single.EventManagement.on(target,"keyup",listener);
}
domtools.single.EventManagement.hover = function(target,listener1,listener2) {
	domtools.single.EventManagement.on(target,"mouseover",listener1);
	if(listener2 == null) domtools.single.EventManagement.on(target,"mouseout",listener1); else domtools.single.EventManagement.on(target,"mouseout",listener2);
	return target;
}
domtools.single.EventManagement.submit = function(target,listener) {
	return domtools.single.EventManagement.on(target,"submit",listener);
}
domtools.single.EventManagement.toggleClick = function(target,listenerFirstClick,listenerSecondClick) {
	var fn1 = null;
	var fn2 = null;
	fn1 = function(e) {
		listenerFirstClick(e);
		target.removeEventListener("click",fn1,false);
		target.addEventListener("click",fn2,false);
	};
	fn2 = function(e) {
		listenerSecondClick(e);
		target.removeEventListener("click",fn2,false);
		target.addEventListener("click",fn1,false);
	};
	target.addEventListener("click",fn1,false);
	return target;
}
domtools.single.EventManagement.blur = function(target,listener) {
	return domtools.single.EventManagement.on(target,"blur",listener);
}
domtools.single.EventManagement.change = function(target,listener) {
	return domtools.single.EventManagement.on(target,"change",listener);
}
domtools.single.EventManagement.click = function(target,listener) {
	return domtools.single.EventManagement.on(target,"click",listener);
}
domtools.single.EventManagement.dblclick = function(target,listener) {
	return domtools.single.EventManagement.on(target,"dblclick",listener);
}
domtools.single.EventManagement.focus = function(target,listener) {
	return domtools.single.EventManagement.on(target,"focus",listener);
}
domtools.single.EventManagement.focusIn = function(target,listener) {
	return domtools.single.EventManagement.on(target,"focusIn",listener);
}
domtools.single.EventManagement.focusOut = function(target,listener) {
	return domtools.single.EventManagement.on(target,"focusOut",listener);
}
domtools.single.EventManagement.resize = function(target,listener) {
	return domtools.single.EventManagement.on(target,"resize",listener);
}
domtools.single.EventManagement.scroll = function(target,listener) {
	return domtools.single.EventManagement.on(target,"scroll",listener);
}
domtools.single.EventManagement.select = function(target,listener) {
	return domtools.single.EventManagement.on(target,"select",listener);
}
domtools.single.EventManagement.load = function(target,listener) {
	return domtools.single.EventManagement.on(target,"load",listener);
}
domtools.single.EventManagement.unload = function(target,listener) {
	return domtools.single.EventManagement.on(target,"unload",listener);
}
domtools.single.EventManagement.error = function(target,listener) {
	return domtools.single.EventManagement.on(target,"error",listener);
}
domtools.single.EventManagement.ready = function(target,listener) {
	return domtools.single.EventManagement.on(target,"ready",listener);
}
domtools.single.EventManagement.prototype.__class__ = domtools.single.EventManagement;
List = function(p) {
	if( p === $_ ) return;
	this.length = 0;
}
List.__name__ = ["List"];
List.prototype.h = null;
List.prototype.q = null;
List.prototype.length = null;
List.prototype.add = function(item) {
	var x = [item];
	if(this.h == null) this.h = x; else this.q[1] = x;
	this.q = x;
	this.length++;
}
List.prototype.push = function(item) {
	var x = [item,this.h];
	this.h = x;
	if(this.q == null) this.q = x;
	this.length++;
}
List.prototype.first = function() {
	return this.h == null?null:this.h[0];
}
List.prototype.last = function() {
	return this.q == null?null:this.q[0];
}
List.prototype.pop = function() {
	if(this.h == null) return null;
	var x = this.h[0];
	this.h = this.h[1];
	if(this.h == null) this.q = null;
	this.length--;
	return x;
}
List.prototype.isEmpty = function() {
	return this.h == null;
}
List.prototype.clear = function() {
	this.h = null;
	this.q = null;
	this.length = 0;
}
List.prototype.remove = function(v) {
	var prev = null;
	var l = this.h;
	while(l != null) {
		if(l[0] == v) {
			if(prev == null) this.h = l[1]; else prev[1] = l[1];
			if(this.q == l) this.q = prev;
			this.length--;
			return true;
		}
		prev = l;
		l = l[1];
	}
	return false;
}
List.prototype.iterator = function() {
	return { h : this.h, hasNext : function() {
		return this.h != null;
	}, next : function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		return x;
	}};
}
List.prototype.toString = function() {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	s.b[s.b.length] = "{" == null?"null":"{";
	while(l != null) {
		if(first) first = false; else s.b[s.b.length] = ", " == null?"null":", ";
		s.add(Std.string(l[0]));
		l = l[1];
	}
	s.b[s.b.length] = "}" == null?"null":"}";
	return s.b.join("");
}
List.prototype.join = function(sep) {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	while(l != null) {
		if(first) first = false; else s.b[s.b.length] = sep == null?"null":sep;
		s.add(l[0]);
		l = l[1];
	}
	return s.b.join("");
}
List.prototype.filter = function(f) {
	var l2 = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		if(f(v)) l2.add(v);
	}
	return l2;
}
List.prototype.map = function(f) {
	var b = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		b.add(f(v));
	}
	return b;
}
List.prototype.__class__ = List;
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
domtools.collection.EventManagement.off = function(targetCollection,eventType,listener) {
	var $it0 = targetCollection.collection.iterator();
	while( $it0.hasNext() ) {
		var target = $it0.next();
		domtools.single.EventManagement.off(target,eventType,listener);
	}
	return targetCollection;
}
domtools.collection.EventManagement.one = function(targetCollection,eventType,listener) {
	var $it0 = targetCollection.collection.iterator();
	while( $it0.hasNext() ) {
		var target = $it0.next();
		domtools.single.EventManagement.one(target,eventType,listener);
	}
	return targetCollection;
}
domtools.collection.EventManagement.mousedown = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"mousedown",listener);
}
domtools.collection.EventManagement.mouseenter = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"mouseenter",listener);
}
domtools.collection.EventManagement.mouseleave = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"mouseleave",listener);
}
domtools.collection.EventManagement.mousemove = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"mousemove",listener);
}
domtools.collection.EventManagement.mouseout = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"mouseout",listener);
}
domtools.collection.EventManagement.mouseover = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"mouseover",listener);
}
domtools.collection.EventManagement.mouseup = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"mouseup",listener);
}
domtools.collection.EventManagement.keydown = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"keydown",listener);
}
domtools.collection.EventManagement.keypress = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"keypress",listener);
}
domtools.collection.EventManagement.keyup = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"keyup",listener);
}
domtools.collection.EventManagement.hover = function(targetCollection,listener1,listener2) {
	var $it0 = targetCollection.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		domtools.single.EventManagement.hover(node,listener1,listener2);
	}
	return targetCollection;
}
domtools.collection.EventManagement.submit = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"submit",listener);
}
domtools.collection.EventManagement.toggleClick = function(targetCollection,listenerFirstClick,listenerSecondClick) {
	var $it0 = targetCollection.collection.iterator();
	while( $it0.hasNext() ) {
		var target = $it0.next();
		domtools.single.EventManagement.toggleClick(target,listenerFirstClick,listenerSecondClick);
	}
	return targetCollection;
}
domtools.collection.EventManagement.blur = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"blur",listener);
}
domtools.collection.EventManagement.change = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"change",listener);
}
domtools.collection.EventManagement.click = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"click",listener);
}
domtools.collection.EventManagement.dblclick = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"dblclick",listener);
}
domtools.collection.EventManagement.focus = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"focus",listener);
}
domtools.collection.EventManagement.focusIn = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"focusIn",listener);
}
domtools.collection.EventManagement.focusOut = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"focusOut",listener);
}
domtools.collection.EventManagement.resize = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"resize",listener);
}
domtools.collection.EventManagement.scroll = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"scroll",listener);
}
domtools.collection.EventManagement.select = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"select",listener);
}
domtools.collection.EventManagement.load = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"load",listener);
}
domtools.collection.EventManagement.unload = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"unload",listener);
}
domtools.collection.EventManagement.error = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"error",listener);
}
domtools.collection.EventManagement.ready = function(target,listener) {
	return domtools.collection.EventManagement.on(target,"ready",listener);
}
domtools.collection.EventManagement.prototype.__class__ = domtools.collection.EventManagement;
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
IntIter = function(min,max) {
	if( min === $_ ) return;
	this.min = min;
	this.max = max;
}
IntIter.__name__ = ["IntIter"];
IntIter.prototype.min = null;
IntIter.prototype.max = null;
IntIter.prototype.hasNext = function() {
	return this.min < this.max;
}
IntIter.prototype.next = function() {
	return this.min++;
}
IntIter.prototype.__class__ = IntIter;
domtools.single.Style = function() { }
domtools.single.Style.__name__ = ["domtools","single","Style"];
domtools.single.Style.getComputedStyle = function(node) {
	var style = null;
	if(domtools.single.ElementManipulation.isElement(node)) {
	}
	return style;
}
domtools.single.Style.css = function(node,property) {
	domtools.single.Style.getComputedStyle(node).getPropertyValue("property");
}
domtools.single.Style.setCSS = function(node,property,value) {
	if(domtools.single.ElementManipulation.isElement(node)) {
		var style = node.style;
		style[property] = value;
	}
}
domtools.single.Style.innerWidth = function(node) {
	var style = domtools.single.Style.getComputedStyle(node);
	if(style != null) {
	}
	return 0;
}
domtools.single.Style.prototype.__class__ = domtools.single.Style;
if(typeof js=='undefined') js = {}
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
if(typeof haxe=='undefined') haxe = {}
haxe.Firebug = function() { }
haxe.Firebug.__name__ = ["haxe","Firebug"];
haxe.Firebug.detect = function() {
	try {
		return console != null && console.error != null;
	} catch( e ) {
		return false;
	}
}
haxe.Firebug.redirectTraces = function() {
	haxe.Log.trace = haxe.Firebug.trace;
	js.Lib.setErrorHandler(haxe.Firebug.onError);
}
haxe.Firebug.onError = function(err,stack) {
	var buf = err + "\n";
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		buf += "Called from " + s + "\n";
	}
	haxe.Firebug.trace(buf,null);
	return true;
}
haxe.Firebug.trace = function(v,inf) {
	var type = inf != null && inf.customParams != null?inf.customParams[0]:null;
	if(type != "warn" && type != "info" && type != "debug" && type != "error") type = inf == null?"error":"log";
	console[type]((inf == null?"":inf.fileName + ":" + inf.lineNumber + " : ") + Std.string(v));
}
haxe.Firebug.prototype.__class__ = haxe.Firebug;
domtools.collection.Traversing = function() { }
domtools.collection.Traversing.__name__ = ["domtools","collection","Traversing"];
domtools.collection.Traversing.children = function(query,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var children = new domtools.Query();
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			if(domtools.single.ElementManipulation.isElement(node)) children.addNodeList(node.childNodes,elementsOnly);
		}
	}
	return children;
}
domtools.collection.Traversing.firstChildren = function(query,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var children = new domtools.Query();
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			if(domtools.single.ElementManipulation.isElement(node)) {
				var e = node.firstChild;
				while(elementsOnly == true && e != null && domtools.single.ElementManipulation.isElement(e) == false) e = e.nextSibling;
				if(e != null) {
					if(e != null) {
						if(Lambda.has(children.collection,e) == false) children.collection.push(e);
					}
					children;
				}
			}
		}
	}
	return children;
}
domtools.collection.Traversing.lastChildren = function(query,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var children = new domtools.Query();
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			if(domtools.single.ElementManipulation.isElement(node)) {
				var e = node.lastChild;
				while(elementsOnly == true && e != null && domtools.single.ElementManipulation.isElement(e) == false) e = e.previousSibling;
				if(e != null) {
					if(e != null) {
						if(Lambda.has(children.collection,e) == false) children.collection.push(e);
					}
					children;
				}
			}
		}
	}
	return children;
}
domtools.collection.Traversing.parent = function(query) {
	var parents = new domtools.Query();
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			if(node.parentNode != null && node != (function($this) {
				var $r;
				if(domtools.Query.document == null) domtools.Query.document = document;
				$r = domtools.Query.document;
				return $r;
			}(this))) parents.add(node.parentNode);
		}
	}
	return parents;
}
domtools.collection.Traversing.ancestors = function(query) {
	var ancestorList = domtools.collection.Traversing.parent(query);
	if(ancestorList.collection.length > 0) ancestorList.addCollection(domtools.collection.Traversing.ancestors(ancestorList));
	return ancestorList;
}
domtools.collection.Traversing.next = function(query,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var siblings = new domtools.Query();
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			var sibling = node.nextSibling;
			while(sibling != null && sibling.nodeType != 1 && elementsOnly) sibling = sibling.nextSibling;
			if(sibling != null) {
				if(sibling != null) {
					if(Lambda.has(siblings.collection,sibling) == false) siblings.collection.push(sibling);
				}
				siblings;
			}
		}
	}
	return siblings;
}
domtools.collection.Traversing.prev = function(query,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var siblings = new domtools.Query();
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			var sibling = node.previousSibling;
			while(sibling != null && sibling.nodeType != 1 && elementsOnly) sibling = sibling.previousSibling;
			if(sibling != null) {
				if(sibling != null) {
					if(Lambda.has(siblings.collection,sibling) == false) siblings.collection.push(sibling);
				}
				siblings;
			}
		}
	}
	return siblings;
}
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
domtools.single.ElementManipulation = function() { }
domtools.single.ElementManipulation.__name__ = ["domtools","single","ElementManipulation"];
domtools.single.ElementManipulation.isElement = function(node) {
	return node != null && node.nodeType == domtools.single.ElementManipulation.NodeTypeElement;
}
domtools.single.ElementManipulation.isComment = function(node) {
	return node != null && node.nodeType == domtools.single.ElementManipulation.NodeTypeComment;
}
domtools.single.ElementManipulation.isTextNode = function(node) {
	return node != null && node.nodeType == domtools.single.ElementManipulation.NodeTypeText;
}
domtools.single.ElementManipulation.isDocument = function(node) {
	return node != null && node.nodeType == domtools.single.ElementManipulation.NodeTypeDocument;
}
domtools.single.ElementManipulation.toQuery = function(n) {
	return new domtools.Query(null,n);
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
domtools.single.ElementManipulation.removeAttr = function(elm,attName) {
	if(elm != null && elm.nodeType == domtools.single.ElementManipulation.NodeTypeElement) {
		var element = elm;
		element.removeAttribute(attName);
	}
	return elm;
}
domtools.single.ElementManipulation.testForClass = function(elm,className) {
	return (" " + domtools.single.ElementManipulation.attr(elm,"class") + " ").indexOf(" " + className + " ") > -1;
}
domtools.single.ElementManipulation.hasClass = function(elm,className) {
	var hasClass = true;
	if(className.indexOf(" ") > -1) {
		var anyWhitespace = new EReg("\\s+","g");
		var _g = 0, _g1 = anyWhitespace.split(className);
		while(_g < _g1.length) {
			var name = _g1[_g];
			++_g;
			hasClass = (" " + domtools.single.ElementManipulation.attr(elm,"class") + " ").indexOf(" " + name + " ") > -1;
			if(hasClass == false) break;
		}
	} else hasClass = (" " + domtools.single.ElementManipulation.attr(elm,"class") + " ").indexOf(" " + className + " ") > -1;
	return hasClass;
}
domtools.single.ElementManipulation.addClass = function(elm,className) {
	var _g = 0, _g1 = className.split(" ");
	while(_g < _g1.length) {
		var name = _g1[_g];
		++_g;
		if(domtools.single.ElementManipulation.hasClass(elm,className) == false) {
			var oldClassName = domtools.single.ElementManipulation.attr(elm,"class");
			var newClassName = oldClassName == ""?className:oldClassName + " " + className;
			domtools.single.ElementManipulation.setAttr(elm,"class",newClassName);
		}
	}
	return elm;
}
domtools.single.ElementManipulation.removeClass = function(elm,className) {
	var classes = domtools.single.ElementManipulation.attr(elm,"class").split(" ");
	var _g = 0, _g1 = className.split(" ");
	while(_g < _g1.length) {
		var name = _g1[_g];
		++_g;
		classes.remove(name);
	}
	var newClassValue = classes.join(" ");
	domtools.single.ElementManipulation.setAttr(elm,"class",newClassValue);
	return elm;
}
domtools.single.ElementManipulation.toggleClass = function(elm,className) {
	var _g = 0, _g1 = className.split(" ");
	while(_g < _g1.length) {
		var name = _g1[_g];
		++_g;
		if(domtools.single.ElementManipulation.hasClass(elm,name)) domtools.single.ElementManipulation.removeClass(elm,name); else domtools.single.ElementManipulation.addClass(elm,name);
	}
	return elm;
}
domtools.single.ElementManipulation.tagName = function(elm) {
	return elm == null?"":elm.nodeName.toLowerCase();
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
domtools.single.ElementManipulation.setVal = function(node,val) {
	if(node != null) switch(node.nodeType) {
	case domtools.single.ElementManipulation.NodeTypeElement:
		node["value"] = val;
		break;
	default:
		node.nodeValue = val;
	}
	return node;
}
domtools.single.ElementManipulation.text = function(elm) {
	var text = "";
	if(elm != null) {
		if(domtools.single.ElementManipulation.isElement(elm)) text = elm.textContent; else text = elm.nodeValue;
	}
	return text;
}
domtools.single.ElementManipulation.setText = function(elm,text) {
	if(elm != null) {
		if(domtools.single.ElementManipulation.isElement(elm)) elm.textContent = text; else elm.nodeValue = text;
	}
	return elm;
}
domtools.single.ElementManipulation.innerHTML = function(elm) {
	var ret = "";
	if(elm != null) switch(elm.nodeType) {
	case domtools.single.ElementManipulation.NodeTypeElement:
		var element = elm;
		ret = element.innerHTML;
		break;
	default:
		ret = elm.textContent;
	}
	return ret;
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
domtools.single.ElementManipulation.clone = function(elm,deep) {
	if(deep == null) deep = true;
	return elm == null?null:elm.cloneNode(deep);
}
domtools.single.ElementManipulation.prototype.__class__ = domtools.single.ElementManipulation;
domtools.Tools = function(p) {
}
domtools.Tools.__name__ = ["domtools","Tools"];
domtools.Tools.find = function(selector) {
	return new domtools.Query(selector);
}
domtools.Tools.create = function(elmName) {
	return domtools.Query.create(elmName);
}
domtools.Tools.parse = function(html) {
	return domtools.Query.parse(html);
}
domtools.Tools.toNode = function(eventHandler) {
	var elm;
	try {
		elm = eventHandler;
	} catch( e ) {
		elm = null;
	}
	return elm;
}
domtools.Tools.prototype.__class__ = domtools.Tools;
domtools.collection.ElementManipulation = function() { }
domtools.collection.ElementManipulation.__name__ = ["domtools","collection","ElementManipulation"];
domtools.collection.ElementManipulation.attr = function(query,attName) {
	return query != null && query.collection.length > 0?domtools.single.ElementManipulation.attr(query.collection[0],attName):"";
}
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
domtools.collection.ElementManipulation.removeAttr = function(query,attName) {
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			domtools.single.ElementManipulation.removeAttr(node,attName);
		}
	}
	return query;
}
domtools.collection.ElementManipulation.hasClass = function(query,className) {
	var result = false;
	if(query != null && query.collection.length > 0) {
		result = true;
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			if(domtools.single.ElementManipulation.hasClass(node,className) == false) {
				result = false;
				break;
			}
		}
	}
	return result;
}
domtools.collection.ElementManipulation.addClass = function(query,className) {
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			domtools.single.ElementManipulation.addClass(node,className);
		}
	}
	return query;
}
domtools.collection.ElementManipulation.removeClass = function(query,className) {
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			domtools.single.ElementManipulation.removeClass(node,className);
		}
	}
	return query;
}
domtools.collection.ElementManipulation.toggleClass = function(query,className) {
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			domtools.single.ElementManipulation.toggleClass(node,className);
		}
	}
	return query;
}
domtools.collection.ElementManipulation.tagName = function(query) {
	return query != null && query.collection.length > 0?domtools.single.ElementManipulation.tagName(query.collection[0]):"";
}
domtools.collection.ElementManipulation.val = function(query) {
	return query != null && query.collection.length > 0?domtools.single.ElementManipulation.val(query.collection[0]):"";
}
domtools.collection.ElementManipulation.setVal = function(query,val) {
	var value = Std.string(val);
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			domtools.single.ElementManipulation.setVal(node,value);
		}
	}
	return query;
}
domtools.collection.ElementManipulation.text = function(query) {
	var text = "";
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			text = text + domtools.single.ElementManipulation.text(node);
		}
	}
	return text;
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
domtools.collection.ElementManipulation.innerHTML = function(query) {
	var ret = "";
	if(query != null) {
		var $it0 = query.collection.iterator();
		while( $it0.hasNext() ) {
			var node = $it0.next();
			ret += domtools.single.ElementManipulation.innerHTML(node);
		}
	}
	return ret;
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
StringBuf = function(p) {
	if( p === $_ ) return;
	this.b = new Array();
}
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype.add = function(x) {
	this.b[this.b.length] = x == null?"null":x;
}
StringBuf.prototype.addSub = function(s,pos,len) {
	this.b[this.b.length] = s.substr(pos,len);
}
StringBuf.prototype.addChar = function(c) {
	this.b[this.b.length] = String.fromCharCode(c);
}
StringBuf.prototype.toString = function() {
	return this.b.join("");
}
StringBuf.prototype.b = null;
StringBuf.prototype.__class__ = StringBuf;
CommonJS = function() { }
CommonJS.__name__ = ["CommonJS"];
CommonJS.getWindow = function() {
	var window = window;
	return window;
}
CommonJS.getHtmlDocument = function() {
	var htmlDocument = document;
	return htmlDocument;
}
CommonJS.newElement = function(elementType,htmlElement) {
	var htmlDocument = CommonJS.getHtmlDocument();
	if(htmlElement == null) htmlElement = htmlDocument.body;
	return htmlElement.createElement(elementType);
}
CommonJS.get = function(domSelection) {
	var htmlDocument = CommonJS.getHtmlDocument();
	return htmlDocument.body.querySelector(domSelection);
}
CommonJS.getAll = function(domSelection) {
	var htmlDocument = CommonJS.getHtmlDocument();
	return htmlDocument.body.querySelectorAll(domSelection);
}
CommonJS.stopEventPropergation = function(event) {
	if(event.stopPropagation != null) event.stopPropagation(); else if(event.cancelBubble != null) event.cancelBubble = true;
	if(event.preventDefault != null) event.preventDefault(); else if(event.returnValue != null) event.returnValue = false;
}
CommonJS.addEventListener = function(domSelection,eventType,eventHandler,useCapture) {
	if(useCapture == null) useCapture = true;
	var nodeList = CommonJS.getAll(domSelection);
	var _g1 = 0, _g = nodeList.length;
	while(_g1 < _g) {
		var i = _g1++;
		var element = nodeList[i];
		element.addEventListener(eventType,eventHandler,useCapture);
	}
}
CommonJS.removeEventListener = function(domSelection,eventType,eventHandler,useCapture) {
	if(useCapture == null) useCapture = true;
	var nodeList = CommonJS.getAll(domSelection);
	var _g1 = 0, _g = nodeList.length;
	while(_g1 < _g) {
		var i = _g1++;
		var element = nodeList[i];
		element.removeEventListener(eventType,eventHandler,useCapture);
	}
}
CommonJS.getComputedStyle = function(element,style) {
	var computedStyle;
	var htmlDocument = CommonJS.getHtmlDocument();
	if(element.currentStyle != null) computedStyle = element.currentStyle; else computedStyle = htmlDocument.defaultView.getComputedStyle(element,null);
	return computedStyle.getPropertyValue(style);
}
CommonJS.setStyle = function(domSelection,cssStyle,value) {
	var nodeList = CommonJS.getAll(domSelection);
	var _g1 = 0, _g = nodeList.length;
	while(_g1 < _g) {
		var i = _g1++;
		var element = nodeList[i];
		element.style[cssStyle] = value;
	}
}
CommonJS.prototype.__class__ = CommonJS;
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
ProgressBar.prototype.percentage = null;
ProgressBar.prototype.updateProgress = function(percentage) {
	domtools.collection.ElementManipulation.setAttr(domtools.collection.Traversing.find(this,".bar"),"style","width: " + percentage + "%");
}
ProgressBar.prototype.__class__ = ProgressBar;
Lambda = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.list = function(it) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		l.add(i);
	}
	return l;
}
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
}
Lambda.mapi = function(it,f) {
	var l = new List();
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(i++,x));
	}
	return l;
}
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
Lambda.exists = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
}
Lambda.foreach = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
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
Lambda.fold = function(it,f,first) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
Lambda.empty = function(it) {
	return !it.iterator().hasNext();
}
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = a.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = b.iterator();
	while( $it1.hasNext() ) {
		var x = $it1.next();
		l.add(x);
	}
	return l;
}
Lambda.prototype.__class__ = Lambda;
domtools.collection.Style = function() { }
domtools.collection.Style.__name__ = ["domtools","collection","Style"];
domtools.collection.Style.setCSS = function(collection,property,value) {
	var $it0 = collection.collection.iterator();
	while( $it0.hasNext() ) {
		var node = $it0.next();
		domtools.single.Style.setCSS(node,property,value);
	}
}
domtools.collection.Style.prototype.__class__ = domtools.collection.Style;
haxe.Log = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype.__class__ = haxe.Log;
domtools.single.Traversing = function() { }
domtools.single.Traversing.__name__ = ["domtools","single","Traversing"];
domtools.single.Traversing.children = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var children = new domtools.Query();
	if(node != null && domtools.single.ElementManipulation.isElement(node)) children.addNodeList(node.childNodes,elementsOnly);
	return children;
}
domtools.single.Traversing.firstChildren = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var firstChild = null;
	if(node != null && domtools.single.ElementManipulation.isElement(node)) {
		var e = node.firstChild;
		while(elementsOnly == true && e != null && domtools.single.ElementManipulation.isElement(e) == false) e = e.nextSibling;
		if(e != null) firstChild = e;
	}
	return firstChild;
}
domtools.single.Traversing.lastChildren = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var lastChild = null;
	if(node != null && domtools.single.ElementManipulation.isElement(node)) {
		var e = node.lastChild;
		while(elementsOnly == true && e != null && domtools.single.ElementManipulation.isElement(e) == false) e = e.previousSibling;
		if(e != null) lastChild = e;
	}
	return lastChild;
}
domtools.single.Traversing.parent = function(node) {
	return node != null && node.parentNode != null && node != (function($this) {
		var $r;
		if(domtools.Query.document == null) domtools.Query.document = document;
		$r = domtools.Query.document;
		return $r;
	}(this))?node.parentNode:null;
}
domtools.single.Traversing.ancestors = function(node) {
	var ancestorsList = new domtools.Query();
	var parent = domtools.single.Traversing.parent(node);
	{
		if(parent != null) {
			if(Lambda.has(ancestorsList.collection,parent) == false) ancestorsList.collection.push(parent);
		}
		ancestorsList;
	}
	if(ancestorsList.collection.length > 0) {
		var ancestorsOfThisParent = domtools.single.Traversing.ancestors(parent);
		ancestorsList.addCollection(ancestorsOfThisParent);
	}
	return ancestorsList;
}
domtools.single.Traversing.next = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var sibling = node != null?node.nextSibling:null;
	while(sibling != null && elementsOnly && sibling.nodeType != 1) sibling = sibling.nextSibling;
	return sibling;
}
domtools.single.Traversing.prev = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var sibling = node != null?node.previousSibling:null;
	while(sibling != null && elementsOnly && sibling.nodeType != 1) sibling = sibling.previousSibling;
	return sibling;
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
		e1.preventDefault();
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
EReg = function(r,opt) {
	if( r === $_ ) return;
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
}
EReg.__name__ = ["EReg"];
EReg.prototype.r = null;
EReg.prototype.match = function(s) {
	this.r.m = this.r.exec(s);
	this.r.s = s;
	this.r.l = RegExp.leftContext;
	this.r.r = RegExp.rightContext;
	return this.r.m != null;
}
EReg.prototype.matched = function(n) {
	return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
		var $r;
		throw "EReg::matched";
		return $r;
	}(this));
}
EReg.prototype.matchedLeft = function() {
	if(this.r.m == null) throw "No string matched";
	if(this.r.l == null) return this.r.s.substr(0,this.r.m.index);
	return this.r.l;
}
EReg.prototype.matchedRight = function() {
	if(this.r.m == null) throw "No string matched";
	if(this.r.r == null) {
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	return this.r.r;
}
EReg.prototype.matchedPos = function() {
	if(this.r.m == null) throw "No string matched";
	return { pos : this.r.m.index, len : this.r.m[0].length};
}
EReg.prototype.split = function(s) {
	var d = "#__delim__#";
	return s.replace(this.r,d).split(d);
}
EReg.prototype.replace = function(s,by) {
	return s.replace(this.r,by);
}
EReg.prototype.customReplace = function(s,f) {
	var buf = new StringBuf();
	while(true) {
		if(!this.match(s)) break;
		buf.add(this.matchedLeft());
		buf.add(f(this));
		s = this.matchedRight();
	}
	buf.b[buf.b.length] = s == null?"null":s;
	return buf.b.join("");
}
EReg.prototype.__class__ = EReg;
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
domtools.collection.DOMManipulation.appendTo = function(children,parentNode,parentCollection) {
	if(parentNode != null) domtools.single.DOMManipulation.append(parentNode,null,children); else if(parentCollection != null) domtools.collection.DOMManipulation.append(parentCollection,null,children);
	return children;
}
domtools.collection.DOMManipulation.prependTo = function(children,parentNode,parentCollection) {
	if(children != null) {
		children.collection.reverse();
		var $it0 = children.collection.iterator();
		while( $it0.hasNext() ) {
			var child = $it0.next();
			{
				if(parentNode != null) {
					if(parentNode.hasChildNodes()) domtools.single.DOMManipulation.insertThisBefore(child,parentNode.firstChild,parentCollection); else domtools.single.DOMManipulation.append(parentNode,child);
				}
				if(parentCollection != null) domtools.collection.DOMManipulation.prepend(parentCollection,child);
				child;
			}
		}
	}
	return children;
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
domtools.collection.DOMManipulation.insertThisAfter = function(content,targetNode,targetCollection) {
	if(content != null) {
		if(targetNode != null) {
			var currentTarget = targetNode;
			var $it0 = content.collection.iterator();
			while( $it0.hasNext() ) {
				var childToAdd = $it0.next();
				domtools.single.DOMManipulation.insertThisAfter(childToAdd,currentTarget,null);
				currentTarget = childToAdd;
			}
		} else if(targetCollection != null) {
			var firstChildUsed = false;
			var childCollection = content;
			var $it1 = targetCollection.collection.iterator();
			while( $it1.hasNext() ) {
				var target = $it1.next();
				childCollection = firstChildUsed?childCollection.clone():childCollection;
				domtools.collection.DOMManipulation.insertThisAfter(childCollection,target);
				firstChildUsed = true;
			}
		}
	}
	return content;
}
domtools.collection.DOMManipulation.beforeThisInsert = function(target,contentNode,contentCollection) {
	if(contentNode != null) domtools.single.DOMManipulation.insertThisBefore(contentNode,null,target); else if(contentCollection != null) domtools.collection.DOMManipulation.insertThisBefore(contentCollection,null,target);
	return target;
}
domtools.collection.DOMManipulation.afterThisInsert = function(target,contentNode,contentCollection) {
	if(contentNode != null) domtools.single.DOMManipulation.insertThisAfter(contentNode,null,target); else if(contentCollection != null) domtools.collection.DOMManipulation.insertThisAfter(contentCollection,null,target);
	return target;
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
domtools.collection.DOMManipulation.removeChildren = function(parents,childToRemove,childrenToRemove) {
	if(parents != null) {
		var $it0 = parents.collection.iterator();
		while( $it0.hasNext() ) {
			var parent = $it0.next();
			domtools.single.DOMManipulation.removeChildren(parent,childToRemove,childrenToRemove);
		}
	}
	return parents;
}
domtools.collection.DOMManipulation.empty = function(containers) {
	if(containers != null) {
		var $it0 = containers.collection.iterator();
		while( $it0.hasNext() ) {
			var container = $it0.next();
			while(container.hasChildNodes()) container.removeChild(container.firstChild);
		}
	}
	return containers;
}
domtools.collection.DOMManipulation.prototype.__class__ = domtools.collection.DOMManipulation;
js.Lib = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
js.Lib.prototype.__class__ = js.Lib;
StringTools = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && s.substr(0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && s.substr(slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = s.charCodeAt(pos);
	return c >= 9 && c <= 13 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return s.substr(r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return s.substr(0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += c.substr(0,l - sl);
		sl = l;
	} else {
		s += c;
		sl += cl;
	}
	return s;
}
StringTools.lpad = function(s,c,l) {
	var ns = "";
	var sl = s.length;
	if(sl >= l) return s;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		ns += c.substr(0,l - sl);
		sl = l;
	} else {
		ns += c;
		sl += cl;
	}
	return ns + s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.cca(index);
}
StringTools.isEOF = function(c) {
	return c != c;
}
StringTools.prototype.__class__ = StringTools;
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
	js.Lib.document = document;
	js.Lib.window = window;
	onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if( f == null )
			return false;
		return f(msg,[url+":"+line]);
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
Notification.template = "<div class='notification alert fade in out'>\n\t\t<a class='close' href='#'>&times;</a>\n\t\t<h4 class='alert-heading'>Title</h4>\n\t\t<p>Description goes here</p>\n\t</div>";
domtools.single.ElementManipulation.NodeTypeElement = 1;
domtools.single.ElementManipulation.NodeTypeAttribute = 2;
domtools.single.ElementManipulation.NodeTypeText = 3;
domtools.single.ElementManipulation.NodeTypeComment = 8;
domtools.single.ElementManipulation.NodeTypeDocument = 9;
ProgressBar.template = "<div class='progress'>\n\t\t<div class='bar' style='width: '>\n\t</div>";
js.Lib.onerror = null;
Main.main()