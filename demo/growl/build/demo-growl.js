(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,r: null
	,__class__: EReg
}
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var Lambda = function() { }
Lambda.__name__ = true;
Lambda.has = function(it,elt) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x == elt) return true;
	}
	return false;
}
var Main = function() { }
Main.__name__ = true;
Main.main = function() {
	dtx.Tools.ready(Main.run);
}
Main.run = function() {
	var form = dtx.Tools.find("form");
	var titleInput = dtx.Tools.find("#title");
	var commentInput = dtx.Tools.find("#comment");
	dtx.collection.EventManagement.on(form,"submit",null,function(e) {
		var n = new Notification(dtx.collection.ElementManipulation.val(titleInput),dtx.collection.ElementManipulation.val(commentInput));
		dtx.collection.DOMManipulation.prepend(dtx.Tools.find("#notifications"),null,n);
		e.stopPropagation();
		e.preventDefault();
		return false;
	});
	dtx.collection.EventManagement.on(dtx.Tools.find("#notifyWithProgress"),"click",null,function(e) {
		var n = new Notification(dtx.collection.ElementManipulation.val(titleInput),dtx.collection.ElementManipulation.val(commentInput));
		var percentage = Math.random() * 100;
		var p = new ProgressBar(percentage);
		dtx.collection.DOMManipulation.append(n,null,p);
		dtx.collection.DOMManipulation.prepend(dtx.Tools.find("#notifications"),null,n);
		e.stopPropagation();
		e.preventDefault();
		return false;
	});
}
var dtx = {}
dtx.DOMCollection = function(selector,node,collection) {
	if(selector == null) selector = "";
	this.collection = new Array();
	if(node != null) this.add(node);
	if(collection != null) this.addCollection(collection);
	if(selector != "") this.addCollection(dtx.single.Traversing.find(dtx.Tools.get_document(),selector));
};
dtx.DOMCollection.__name__ = true;
dtx.DOMCollection.prototype = {
	clone: function(deep) {
		if(deep == null) deep = true;
		var q = new dtx.DOMCollection();
		var $it0 = HxOverrides.iter(this.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			q.add(node.cloneNode(deep));
		}
		return q;
	}
	,addNodeList: function(nodeList,elementsOnly) {
		if(elementsOnly == null) elementsOnly = true;
		var _g1 = 0, _g = nodeList.length;
		while(_g1 < _g) {
			var i = _g1++;
			var node = nodeList.item(i);
			if(elementsOnly == false || dtx.single.ElementManipulation.isElement(node)) this.add(node);
		}
		return this;
	}
	,addCollection: function(collection,elementsOnly) {
		if(elementsOnly == null) elementsOnly = false;
		if(collection != null) {
			var $it0 = $iterator(collection)();
			while( $it0.hasNext() ) {
				var node = $it0.next();
				if(elementsOnly == false || dtx.single.ElementManipulation.isElement(node)) this.add(node);
			}
		}
		return this;
	}
	,add: function(node,pos) {
		if(pos == null) pos = -1;
		if(pos < 0 || pos > this.collection.length) pos = this.collection.length;
		if(node != null) {
			if(Lambda.has(this.collection,node) == false) this.collection.splice(pos,0,node);
		}
		return this;
	}
	,getNode: function(i) {
		if(i == null) i = 0;
		return this.collection.length > i && i >= 0?this.collection[i]:null;
	}
	,iterator: function() {
		return HxOverrides.iter(this.collection);
	}
	,collection: null
	,__class__: dtx.DOMCollection
}
dtx.widget = {}
dtx.widget.Widget = function() {
	dtx.DOMCollection.call(this);
	var q = dtx.Tools.parse(this.get_template());
	this.collection = q.collection;
};
dtx.widget.Widget.__name__ = true;
dtx.widget.Widget.__super__ = dtx.DOMCollection;
dtx.widget.Widget.prototype = $extend(dtx.DOMCollection.prototype,{
	mapData: function(input,propMap) {
		if(propMap != null) {
			var _g = 0, _g1 = Reflect.fields(propMap);
			while(_g < _g1.length) {
				var templateVar = _g1[_g];
				++_g;
				var modelValue = Reflect.field(propMap,templateVar);
				Reflect.setProperty(this,templateVar,modelValue);
			}
		} else if(input != null) {
			var fieldNames;
			var _g = Type["typeof"](input);
			var $e = (_g);
			switch( $e[1] ) {
			case 4:
				fieldNames = Reflect.fields(input);
				break;
			case 6:
				var _g_eTClass_0 = $e[2];
				fieldNames = Type.getInstanceFields(_g_eTClass_0);
				break;
			default:
				fieldNames = [];
			}
			var _g1 = 0;
			while(_g1 < fieldNames.length) {
				var fieldName = fieldNames[_g1];
				++_g1;
				var modelValue = Reflect.getProperty(input,fieldName);
				Reflect.setProperty(this,fieldName,modelValue);
			}
		}
	}
	,init: function() {
	}
	,get_template: function() {
		return "";
	}
	,__class__: dtx.widget.Widget
});
var Notification = function(title,comment) {
	var _g = this;
	dtx.widget.Widget.call(this);
	dtx.collection.ElementManipulation.setText(dtx.collection.Traversing.find(this,"h4"),title);
	dtx.collection.ElementManipulation.setInnerHTML(dtx.collection.Traversing.find(this,"p"),StringTools.replace(comment,"\n","\n<br />"));
	dtx.collection.EventManagement.on(dtx.collection.Traversing.find(this,".close"),"click",null,function(e) {
		console.log("remove");
		dtx.collection.DOMManipulation.remove(_g);
	});
	this.init();
};
Notification.__name__ = true;
Notification.__super__ = dtx.widget.Widget;
Notification.prototype = $extend(dtx.widget.Widget.prototype,{
	get_template: function() {
		return "<div class=\"notification alert fade in out\"><a href=\"#\" class=\"close\">&times;</a><h4 class=\"alert-heading\">Title</h4><p>Description goes here</p></div>";
	}
	,__class__: Notification
});
var ProgressBar = function(percentage) {
	if(percentage == null) percentage = 0;
	var _g = this;
	dtx.widget.Widget.call(this);
	this.updateProgress(percentage);
	dtx.collection.EventManagement.on(this,"click",null,function(e) {
		var p = Math.random() * 100;
		_g.updateProgress(p);
	});
	this.init();
};
ProgressBar.__name__ = true;
ProgressBar.__super__ = dtx.widget.Widget;
ProgressBar.prototype = $extend(dtx.widget.Widget.prototype,{
	get_template: function() {
		return "<div class=\"progress\"><div class=\"bar\" style=\"width: \"/></div>";
	}
	,updateProgress: function(percentage) {
		dtx.collection.ElementManipulation.setAttr(dtx.collection.Traversing.find(this,".bar"),"style","width: " + percentage + "%");
	}
	,percentage: null
	,__class__: ProgressBar
});
var Reflect = function() { }
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
var StringTools = function() { }
StringTools.__name__ = true;
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
var ValueType = { __ename__ : true, __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { }
Type.__name__ = true;
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
}
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
dtx.Tools = function() { }
dtx.Tools.__name__ = true;
dtx.Tools.__properties__ = {get_document:"get_document"}
dtx.Tools.find = function(selector) {
	return new dtx.DOMCollection(selector);
}
dtx.Tools.create = function(name) {
	var elm = null;
	if(name != null) try {
		elm = document.createElement(name);
	} catch( e ) {
		elm = null;
	}
	return elm;
}
dtx.Tools.parse = function(html) {
	var q;
	if(html != null && html != "") {
		var parentTag = "div";
		if(dtx.Tools.firstTag.match(html)) {
			var tagName = dtx.Tools.firstTag.matched(1);
			parentTag = (function($this) {
				var $r;
				switch(tagName) {
				case "tbody":
					$r = "table";
					break;
				case "tfoot":
					$r = "table";
					break;
				case "thead":
					$r = "table";
					break;
				case "colgroup":
					$r = "table";
					break;
				case "col":
					$r = "colgroup";
					break;
				case "tr":
					$r = "tbody";
					break;
				case "th":
					$r = "tr";
					break;
				case "td":
					$r = "tr";
					break;
				default:
					$r = "div";
				}
				return $r;
			}(this));
		}
		var n = dtx.Tools.create(parentTag);
		dtx.single.ElementManipulation.setInnerHTML(n,html);
		q = dtx.single.Traversing.children(n,false);
	} else q = new dtx.DOMCollection();
	return q;
}
dtx.Tools.get_document = function() {
	if(dtx.Tools.document == null) dtx.Tools.document = document;
	return dtx.Tools.document;
}
dtx.Tools.ready = function(f) {
	(function(h,a,c,k){if(h[a]==null&&h[c]){h[a]="loading";h[c](k,c=function(){h[a]="complete";h.removeEventListener(k,c,!1)},!1)}})(document,"readyState","addEventListener","DOMContentLoaded");
	window.checkReady = dtx.Tools.checkReady;
	dtx.Tools.checkReady(f);
}
dtx.Tools.checkReady = function(f) {
	/in/.test(document.readyState) ? setTimeout(function () { checkReady(f) }, 9) : f();
}
dtx.collection = {}
dtx.collection.DOMManipulation = function() { }
dtx.collection.DOMManipulation.__name__ = true;
dtx.collection.DOMManipulation.append = function(parentCollection,childNode,childCollection) {
	var firstChildUsed = false;
	if(parentCollection != null) {
		var $it0 = HxOverrides.iter(parentCollection.collection);
		while( $it0.hasNext() ) {
			var parent = $it0.next();
			childNode = firstChildUsed && childNode != null?childNode.cloneNode(true):childNode;
			childCollection = firstChildUsed && childCollection != null?childCollection.clone():childCollection;
			dtx.single.DOMManipulation.append(parent,childNode,childCollection);
			firstChildUsed = true;
		}
	}
	return parentCollection;
}
dtx.collection.DOMManipulation.prepend = function(parentCollection,childNode,childCollection) {
	var firstChildUsed = false;
	if(parentCollection != null) {
		var $it0 = HxOverrides.iter(parentCollection.collection);
		while( $it0.hasNext() ) {
			var parent = $it0.next();
			if(firstChildUsed == false) firstChildUsed = true; else {
				if(childNode != null) childNode = childNode.cloneNode(true);
				if(childCollection != null) childCollection = childCollection.clone(true);
			}
			dtx.single.DOMManipulation.prepend(parent,childNode,childCollection);
		}
	}
	return parentCollection;
}
dtx.collection.DOMManipulation.insertThisBefore = function(content,targetNode,targetCollection) {
	if(content != null) {
		if(targetNode != null) {
			var $it0 = HxOverrides.iter(content.collection);
			while( $it0.hasNext() ) {
				var childToAdd = $it0.next();
				dtx.single.DOMManipulation.insertThisBefore(childToAdd,targetNode);
			}
		}
		if(targetCollection != null) {
			var firstChildUsed = false;
			var childCollection = content;
			var $it1 = HxOverrides.iter(targetCollection.collection);
			while( $it1.hasNext() ) {
				var target = $it1.next();
				childCollection = firstChildUsed?childCollection.clone():childCollection;
				dtx.collection.DOMManipulation.insertThisBefore(childCollection,target);
				firstChildUsed = true;
			}
		}
	}
	return content;
}
dtx.collection.DOMManipulation.remove = function(nodesToRemove) {
	if(nodesToRemove != null) {
		var $it0 = HxOverrides.iter(nodesToRemove.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			dtx.single.DOMManipulation.remove(node);
		}
	}
	return nodesToRemove;
}
dtx.collection.ElementManipulation = function() { }
dtx.collection.ElementManipulation.__name__ = true;
dtx.collection.ElementManipulation.setAttr = function(query,attName,attValue) {
	if(query != null) {
		var $it0 = HxOverrides.iter(query.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			dtx.single.ElementManipulation.setAttr(node,attName,attValue);
		}
	}
	return query;
}
dtx.collection.ElementManipulation.val = function(query) {
	return query != null && query.collection.length > 0?dtx.single.ElementManipulation.val(query.getNode()):"";
}
dtx.collection.ElementManipulation.setText = function(query,text) {
	if(query != null) {
		var $it0 = HxOverrides.iter(query.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			dtx.single.ElementManipulation.setText(node,text);
		}
	}
	return query;
}
dtx.collection.ElementManipulation.setInnerHTML = function(query,html) {
	if(query != null) {
		var $it0 = HxOverrides.iter(query.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			dtx.single.ElementManipulation.setInnerHTML(node,html);
		}
	}
	return query;
}
dtx.collection.EventManagement = function() { }
dtx.collection.EventManagement.__name__ = true;
dtx.collection.EventManagement.on = function(targetCollection,eventType,selector,listener) {
	var $it0 = HxOverrides.iter(targetCollection.collection);
	while( $it0.hasNext() ) {
		var target = $it0.next();
		if(selector != null) bean.on(target,eventType,selector,listener); else bean.on(target,eventType,listener);
		target;
	}
	return targetCollection;
}
dtx.collection.Traversing = function() { }
dtx.collection.Traversing.__name__ = true;
dtx.collection.Traversing.find = function(query,selector) {
	var newDOMCollection = new dtx.DOMCollection();
	if(query != null && selector != null && selector != "") {
		var $it0 = HxOverrides.iter(query.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			if(dtx.single.ElementManipulation.isElement(node) || dtx.single.ElementManipulation.isDocument(node)) {
				var element = node;
				if(document.querySelectorAll) {
					var results = element.querySelectorAll(selector);
					newDOMCollection.addNodeList(results);
				} else {
					var engine = 
								(('undefined' != typeof Sizzle && Sizzle) || 
								(('undefined' != typeof jQuery) && jQuery.find) || 
								(('undefined' != typeof $) && $.find))
							;
					var results = engine(selector,node);
					newDOMCollection.addCollection(results);
				}
			}
		}
	}
	return newDOMCollection;
}
dtx.single = {}
dtx.single.DOMManipulation = function() { }
dtx.single.DOMManipulation.__name__ = true;
dtx.single.DOMManipulation.append = function(parent,childNode,childCollection) {
	if(parent != null) {
		if(childNode != null) parent.appendChild(childNode);
		if(childCollection != null) {
			var $it0 = HxOverrides.iter(childCollection.collection);
			while( $it0.hasNext() ) {
				var child = $it0.next();
				parent.appendChild(child);
			}
		}
	}
	return parent;
}
dtx.single.DOMManipulation.prepend = function(parent,newChildNode,newChildCollection) {
	if(parent != null) {
		if(newChildNode != null) {
			if(parent.hasChildNodes()) dtx.single.DOMManipulation.insertThisBefore(newChildNode,parent.firstChild); else dtx.single.DOMManipulation.append(parent,newChildNode);
		}
		if(newChildCollection != null) dtx.collection.DOMManipulation.insertThisBefore(newChildCollection,parent.firstChild);
	}
	return parent;
}
dtx.single.DOMManipulation.insertThisBefore = function(content,targetNode,targetCollection) {
	if(content != null) {
		if(targetNode != null) {
			var parent = targetNode.parentNode;
			if(parent != null) parent.insertBefore(content,targetNode);
		}
		if(targetCollection != null) {
			var firstChildUsed = false;
			var $it0 = HxOverrides.iter(targetCollection.collection);
			while( $it0.hasNext() ) {
				var target = $it0.next();
				var childToInsert = firstChildUsed?content.cloneNode(true):content;
				var parent = target.parentNode;
				if(parent != null) parent.insertBefore(childToInsert,target);
				firstChildUsed = true;
			}
		}
	}
	return content;
}
dtx.single.DOMManipulation.remove = function(childToRemove) {
	if(childToRemove != null) {
		var parent = childToRemove.parentNode;
		if(parent != null) parent.removeChild(childToRemove);
	}
	return childToRemove;
}
dtx.single.ElementManipulation = function() { }
dtx.single.ElementManipulation.__name__ = true;
dtx.single.ElementManipulation.isElement = function(node) {
	return node != null && node.nodeType == 1;
}
dtx.single.ElementManipulation.isDocument = function(node) {
	return node != null && node.nodeType == 9;
}
dtx.single.ElementManipulation.attr = function(elm,attName) {
	var ret = "";
	if(dtx.single.ElementManipulation.isElement(elm)) {
		var element = elm;
		ret = element.getAttribute(attName);
		if(ret == null) ret = "";
	}
	return ret;
}
dtx.single.ElementManipulation.setAttr = function(elm,attName,attValue) {
	if(elm != null && elm.nodeType == 1) {
		var element = elm;
		element.setAttribute(attName,attValue);
	}
	return elm;
}
dtx.single.ElementManipulation.val = function(node) {
	var val = "";
	if(node != null) switch(node.nodeType) {
	case 1:
		val = Reflect.field(node,"value");
		if(val == null) val = dtx.single.ElementManipulation.attr(node,"value");
		break;
	default:
		val = node.nodeValue;
	}
	return val;
}
dtx.single.ElementManipulation.setText = function(elm,text) {
	if(elm != null) {
		if(dtx.single.ElementManipulation.isElement(elm)) elm.textContent = text; else elm.nodeValue = text;
	}
	return elm;
}
dtx.single.ElementManipulation.setInnerHTML = function(elm,html) {
	if(elm != null) switch(elm.nodeType) {
	case 1:
		var element = elm;
		element.innerHTML = html;
		break;
	default:
		elm.textContent = html;
	}
	return elm;
}
dtx.single.Traversing = function() { }
dtx.single.Traversing.__name__ = true;
dtx.single.Traversing.children = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var children = new dtx.DOMCollection();
	if(node != null && dtx.single.ElementManipulation.isElement(node)) children.addNodeList(node.childNodes,elementsOnly);
	return children;
}
dtx.single.Traversing.find = function(node,selector) {
	var newDOMCollection = new dtx.DOMCollection();
	if(node != null && dtx.single.ElementManipulation.isElement(node) || dtx.single.ElementManipulation.isDocument(node)) {
		var element = node;
		if(document.querySelectorAll) {
			var results = element.querySelectorAll(selector);
			newDOMCollection.addNodeList(results);
		} else {
			var engine = 
						(('undefined' != typeof Sizzle && Sizzle) || 
						(('undefined' != typeof jQuery) && jQuery.find) || 
						(('undefined' != typeof $) && $.find))
					;
			var results = engine(selector,node);
			newDOMCollection.addCollection(results);
		}
	}
	return newDOMCollection;
}
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
/*!
  * Bean - copyright (c) Jacob Thornton 2011-2012
  * https://github.com/fat/bean
  * MIT license
  */
!function(e,t,n){typeof module!="undefined"&&module.exports?module.exports=n(e,t):typeof define=="function"&&typeof define.amd=="object"?define(n):t[e]=n(e,t)}("bean",window,function(e,t){var n=window,r=t[e],i=/[^\.]*(?=\..*)\.|.*/,s=/\..*/,o="addEventListener",u="removeEventListener",a=document||{},f=a.documentElement||{},l=f[o],c=l?o:"attachEvent",h={},p=Array.prototype.slice,d=function(e,t){return e.split(t||" ")},v=function(e){return typeof e=="string"},m=function(e){return typeof e=="function"},g="click dblclick mouseup mousedown contextmenu mousewheel mousemultiwheel DOMMouseScroll mouseover mouseout mousemove selectstart selectend keydown keypress keyup orientationchange focus blur change reset select submit load unload beforeunload resize move DOMContentLoaded readystatechange message error abort scroll ",y="show input invalid touchstart touchmove touchend touchcancel gesturestart gesturechange gestureend textinputreadystatechange pageshow pagehide popstate hashchange offline online afterprint beforeprint dragstart dragenter dragover dragleave drag drop dragend loadstart progress suspend emptied stalled loadmetadata loadeddata canplay canplaythrough playing waiting seeking seeked ended durationchange timeupdate play pause ratechange volumechange cuechange checking noupdate downloading cached updateready obsolete ",b=function(e,t,n){for(n=0;n<t.length;n++)t[n]&&(e[t[n]]=1);return e}({},d(g+(l?y:""))),w=function(){var e="compareDocumentPosition"in f?function(e,t){return t.compareDocumentPosition&&(t.compareDocumentPosition(e)&16)===16}:"contains"in f?function(e,t){return t=t.nodeType===9||t===window?f:t,t!==e&&t.contains(e)}:function(e,t){while(e=e.parentNode)if(e===t)return 1;return 0},t=function(t){var n=t.relatedTarget;return n?n!==this&&n.prefix!=="xul"&&!/document/.test(this.toString())&&!e(n,this):n==null};return{mouseenter:{base:"mouseover",condition:t},mouseleave:{base:"mouseout",condition:t},mousewheel:{base:/Firefox/.test(navigator.userAgent)?"DOMMouseScroll":"mousewheel"}}}(),E=function(){var e=d("altKey attrChange attrName bubbles cancelable ctrlKey currentTarget detail eventPhase getModifierState isTrusted metaKey relatedNode relatedTarget shiftKey srcElement target timeStamp type view which propertyName"),t=e.concat(d("button buttons clientX clientY dataTransfer fromElement offsetX offsetY pageX pageY screenX screenY toElement")),r=t.concat(d("wheelDelta wheelDeltaX wheelDeltaY wheelDeltaZ axis")),i=e.concat(d("char charCode key keyCode keyIdentifier keyLocation location")),s=e.concat(d("data")),o=e.concat(d("touches targetTouches changedTouches scale rotation")),u=e.concat(d("data origin source")),l=e.concat(d("state")),c=/over|out/,h=[{reg:/key/i,fix:function(e,t){return t.keyCode=e.keyCode||e.which,i}},{reg:/click|mouse(?!(.*wheel|scroll))|menu|drag|drop/i,fix:function(e,n,r){n.rightClick=e.which===3||e.button===2,n.pos={x:0,y:0};if(e.pageX||e.pageY)n.clientX=e.pageX,n.clientY=e.pageY;else if(e.clientX||e.clientY)n.clientX=e.clientX+a.body.scrollLeft+f.scrollLeft,n.clientY=e.clientY+a.body.scrollTop+f.scrollTop;return c.test(r)&&(n.relatedTarget=e.relatedTarget||e[(r=="mouseover"?"from":"to")+"Element"]),t}},{reg:/mouse.*(wheel|scroll)/i,fix:function(){return r}},{reg:/^text/i,fix:function(){return s}},{reg:/^touch|^gesture/i,fix:function(){return o}},{reg:/^message$/i,fix:function(){return u}},{reg:/^popstate$/i,fix:function(){return l}},{reg:/.*/,fix:function(){return e}}],p={},v=function(e,t,r){if(!arguments.length)return;e=e||((t.ownerDocument||t.document||t).parentWindow||n).event,this.originalEvent=e,this.isNative=r,this.isBean=!0;if(!e)return;var i=e.type,s=e.target||e.srcElement,o,u,a,f,l;this.target=s&&s.nodeType===3?s.parentNode:s;if(r){l=p[i];if(!l)for(o=0,u=h.length;o<u;o++)if(h[o].reg.test(i)){p[i]=l=h[o].fix;break}f=l(e,this,i);for(o=f.length;o--;)!((a=f[o])in this)&&a in e&&(this[a]=e[a])}};return v.prototype.preventDefault=function(){this.originalEvent.preventDefault?this.originalEvent.preventDefault():this.originalEvent.returnValue=!1},v.prototype.stopPropagation=function(){this.originalEvent.stopPropagation?this.originalEvent.stopPropagation():this.originalEvent.cancelBubble=!0},v.prototype.stop=function(){this.preventDefault(),this.stopPropagation(),this.stopped=!0},v.prototype.stopImmediatePropagation=function(){this.originalEvent.stopImmediatePropagation&&this.originalEvent.stopImmediatePropagation(),this.isImmediatePropagationStopped=function(){return!0}},v.prototype.isImmediatePropagationStopped=function(){return this.originalEvent.isImmediatePropagationStopped&&this.originalEvent.isImmediatePropagationStopped()},v.prototype.clone=function(e){var t=new v(this,this.element,this.isNative);return t.currentTarget=e,t},v}(),S=function(e,t){return!l&&!t&&(e===a||e===n)?f:e},x=function(){var e=function(e,t,n,r){var i=function(n,i){return t.apply(e,r?p.call(i,n?0:1).concat(r):i)},s=function(n,r){return t.__beanDel?t.__beanDel.ft(n.target,e):r},o=n?function(e){var t=s(e,this);if(n.apply(t,arguments))return e&&(e.currentTarget=t),i(e,arguments)}:function(e){return t.__beanDel&&(e=e.clone(s(e))),i(e,arguments)};return o.__beanDel=t.__beanDel,o},t=function(t,n,r,i,s,o,u){var a=w[n],f;n=="unload"&&(r=A(O,t,n,r,i)),a&&(a.condition&&(r=e(t,r,a.condition,o)),n=a.base||n),this.isNative=f=b[n]&&!!t[c],this.customType=!l&&!f&&n,this.element=t,this.type=n,this.original=i,this.namespaces=s,this.eventType=l||f?n:"propertychange",this.target=S(t,f),this[c]=!!this.target[c],this.root=u,this.handler=e(t,r,null,o)};return t.prototype.inNamespaces=function(e){var t,n,r=0;if(!e)return!0;if(!this.namespaces)return!1;for(t=e.length;t--;)for(n=this.namespaces.length;n--;)e[t]==this.namespaces[n]&&r++;return e.length===r},t.prototype.matches=function(e,t,n){return this.element===e&&(!t||this.original===t)&&(!n||this.handler===n)},t}(),T=function(){var e={},t=function(n,r,i,s,o,u){var a=o?"r":"$";if(!r||r=="*")for(var f in e)f.charAt(0)==a&&t(n,f.substr(1),i,s,o,u);else{var l=0,c,h=e[a+r],p=n=="*";if(!h)return;for(c=h.length;l<c;l++)if((p||h[l].matches(n,i,s))&&!u(h[l],h,l,r))return}},n=function(t,n,r,i){var s,o=e[(i?"r":"$")+n];if(o)for(s=o.length;s--;)if(!o[s].root&&o[s].matches(t,r,null))return!0;return!1},r=function(e,n,r,i){var s=[];return t(e,n,r,null,i,function(e){return s.push(e)}),s},i=function(t){var n=!t.root&&!this.has(t.element,t.type,null,!1),r=(t.root?"r":"$")+t.type;return(e[r]||(e[r]=[])).push(t),n},s=function(n){t(n.element,n.type,null,n.handler,n.root,function(t,n,r){return n.splice(r,1),t.removed=!0,n.length===0&&delete e[(t.root?"r":"$")+t.type],!1})},o=function(){var t,n=[];for(t in e)t.charAt(0)=="$"&&(n=n.concat(e[t]));return n};return{has:n,get:r,put:i,del:s,entries:o}}(),N,C=function(e){arguments.length?N=e:N=a.querySelectorAll?function(e,t){return t.querySelectorAll(e)}:function(){throw new Error("Bean: No selector engine installed")}},k=function(e,t){if(!l&&t&&e&&e.propertyName!="_on"+t)return;var n=T.get(this,t||e.type,null,!1),r=n.length,i=0;e=new E(e,this,!0),t&&(e.type=t);for(;i<r&&!e.isImmediatePropagationStopped();i++)n[i].removed||n[i].handler.call(this,e)},L=l?function(e,t,n){e[n?o:u](t,k,!1)}:function(e,t,n,r){var i;n?(T.put(i=new x(e,r||t,function(t){k.call(e,t,r)},k,null,null,!0)),r&&e["_on"+r]==null&&(e["_on"+r]=0),i.target.attachEvent("on"+i.eventType,i.handler)):(i=T.get(e,r||t,k,!0)[0],i&&(i.target.detachEvent("on"+i.eventType,i.handler),T.del(i)))},A=function(e,t,n,r,i){return function(){r.apply(this,arguments),e(t,n,i)}},O=function(e,t,n,r){var i=t&&t.replace(s,""),o=T.get(e,i,null,!1),u={},a,f;for(a=0,f=o.length;a<f;a++)(!n||o[a].original===n)&&o[a].inNamespaces(r)&&(T.del(o[a]),!u[o[a].eventType]&&o[a][c]&&(u[o[a].eventType]={t:o[a].eventType,c:o[a].type}));for(a in u)T.has(e,u[a].t,null,!1)||L(e,u[a].t,!1,u[a].c)},M=function(e,t){var n=function(t,n){var r,i=v(e)?N(e,n):e;for(;t&&t!==n;t=t.parentNode)for(r=i.length;r--;)if(i[r]===t)return t},r=function(e){var r=n(e.target,this);r&&t.apply(r,arguments)};return r.__beanDel={ft:n,selector:e},r},_=l?function(e,t,r){var i=a.createEvent(e?"HTMLEvents":"UIEvents");i[e?"initEvent":"initUIEvent"](t,!0,!0,n,1),r.dispatchEvent(i)}:function(e,t,n){n=S(n,e),e?n.fireEvent("on"+t,a.createEventObject()):n["_on"+t]++},D=function(e,t,n){var r=v(t),o,u,a,f;if(r&&t.indexOf(" ")>0){t=d(t);for(f=t.length;f--;)D(e,t[f],n);return e}u=r&&t.replace(s,""),u&&w[u]&&(u=w[u].type);if(!t||r){if(a=r&&t.replace(i,""))a=d(a,".");O(e,u,n,a)}else if(m(t))O(e,null,t);else for(o in t)t.hasOwnProperty(o)&&D(e,o,t[o]);return e},P=function(e,t,n,r){var o,u,a,f,l,v,g;if(n===undefined&&typeof t=="object"){for(u in t)t.hasOwnProperty(u)&&P.call(this,e,u,t[u]);return}m(n)?(l=p.call(arguments,3),r=o=n):(o=r,l=p.call(arguments,4),r=M(n,o,N)),a=d(t),this===h&&(r=A(D,e,t,r,o));for(f=a.length;f--;)g=T.put(v=new x(e,a[f].replace(s,""),r,o,d(a[f].replace(i,""),"."),l,!1)),v[c]&&g&&L(e,v.eventType,!0,v.customType);return e},H=function(e,t,n,r){return P.apply(null,v(n)?[e,n,t,r].concat(arguments.length>3?p.call(arguments,5):[]):p.call(arguments))},B=function(){return P.apply(h,arguments)},j=function(e,t,n){var r=d(t),o,u,a,f,l;for(o=r.length;o--;){t=r[o].replace(s,"");if(f=r[o].replace(i,""))f=d(f,".");if(!f&&!n&&e[c])_(b[t],t,e);else{l=T.get(e,t,null,!1),n=[!1].concat(n);for(u=0,a=l.length;u<a;u++)l[u].inNamespaces(f)&&l[u].handler.apply(e,n)}}return e},F=function(e,t,n){var r=T.get(t,n,null,!1),i=r.length,s=0,o,u;for(;s<i;s++)r[s].original&&(o=[e,r[s].type],(u=r[s].handler.__beanDel)&&o.push(u.selector),o.push(r[s].original),P.apply(null,o));return e},I={on:P,add:H,one:B,off:D,remove:D,clone:F,fire:j,setSelectorEngine:C,noConflict:function(){return t[e]=r,this}};if(n.attachEvent){var q=function(){var e,t=T.entries();for(e in t)t[e].type&&t[e].type!=="unload"&&D(t[e].element,t[e].type);n.detachEvent("onunload",q),n.CollectGarbage&&n.CollectGarbage()};n.attachEvent("onunload",q)}return C(),I});
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
Notification.__meta__ = { obj : { template : ["<div class='notification alert fade in out'>\n\t<a class='close' href='#'>&times;</a>\n\t<h4 class='alert-heading'>Title</h4>\n\t<p>Description goes here</p>\n</div>"]}};
ProgressBar.__meta__ = { obj : { template : ["<div class='progress'>\n\t<div class='bar' style='width: ' />\n</div>"]}};
dtx.Tools.firstTag = new EReg("<([a-z]+)[ />]","");
Main.main();
})();
