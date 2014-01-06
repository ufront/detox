(function () { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var DataWidgetExample = function() { };
DataWidgetExample.__name__ = ["DataWidgetExample"];
DataWidgetExample.main = function() {
	dtx.Tools.ready(function() {
		var person = DataWidgetExample.generateRandomPerson();
		DataWidgetExample.widget = new PersonWidget();
		DataWidgetExample.widget.set_p(person);
		var doc = window.document;
		dtx.collection.DOMManipulation.appendTo(DataWidgetExample.widget,null,dtx.Tools.find(".container"));
		var target = dtx.Tools.find(".btn");
		dtx.collection.EventManagement.on(target,"click",null,function(e) {
			DataWidgetExample.changePerson();
		});
	});
};
DataWidgetExample.changePerson = function() {
	var person = DataWidgetExample.generateRandomPerson();
	DataWidgetExample.widget.set_p(person);
};
DataWidgetExample.generateRandomPerson = function() {
	var p = new Person();
	var _g = 1 + Math.floor(4 * Math.random());
	switch(_g) {
	case 1:
		p.name = "Jason O'Neil";
		p.email = "jason.oneil@gmail.com";
		p.dob = new Date(1987,9,16,0,0,0);
		break;
	case 2:
		p.name = "Barrack Obama";
		p.email = "barrack.obama@whitehouse.gov";
		p.dob = new Date(1961,7,4,0,0,0);
		break;
	case 3:
		p.name = "Julia Gillard";
		p.email = "julia.gillard@primeminister.gov.au";
		p.dob = new Date(1961,8,29,0,0,0);
		break;
	default:
		p.name = "Jacob Zuma";
		p.email = "jacob.zuma@thepresidency.gov.za";
		p.dob = new Date(1942,3,12,0,0,0);
	}
	return p;
};
var Person = function() {
};
Person.__name__ = ["Person"];
Person.prototype = {
	getAge: function() {
		var ageInSeconds = new Date().getTime() - this.dob.getTime();
		return Math.floor(ageInSeconds / 86400 / 365.25 / 1000);
	}
	,__class__: Person
};
var dtx = {};
dtx.DOMCollection = function(selector,node,collection) {
	if(selector == null) selector = "";
	this.collection = new Array();
	if(node != null) this.add(node);
	if(collection != null) this.addCollection(collection);
	if(selector != "") this.addCollection(dtx.single.Traversing.find(dtx.Tools.get_document(),selector));
};
dtx.DOMCollection.__name__ = ["dtx","DOMCollection"];
dtx.DOMCollection.prototype = {
	iterator: function() {
		return HxOverrides.iter(this.collection);
	}
	,getNode: function(i) {
		if(i == null) i = 0;
		if(this.collection.length > i && i >= 0) return this.collection[i]; else return null;
	}
	,add: function(node,pos) {
		if(pos == null) pos = -1;
		if(pos < 0 || pos > this.collection.length) pos = this.collection.length;
		if(node != null) {
			if(Lambda.has(this.collection,node) == false) this.collection.splice(pos,0,node);
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
	,addNodeList: function(nodeList,elementsOnly) {
		if(elementsOnly == null) elementsOnly = true;
		var _g1 = 0;
		var _g = nodeList.length;
		while(_g1 < _g) {
			var i = _g1++;
			var node = nodeList.item(i);
			if(elementsOnly == false || dtx.single.ElementManipulation.isElement(node)) this.add(node);
		}
		return this;
	}
	,clone: function(deep) {
		if(deep == null) deep = true;
		var q = new dtx.DOMCollection();
		var $it0 = HxOverrides.iter(this.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			q.add(node.cloneNode(deep));
		}
		return q;
	}
	,__class__: dtx.DOMCollection
};
dtx.widget = {};
dtx.widget.Widget = function() {
	dtx.DOMCollection.call(this);
	var name = Type.getClassName(Type.getClass(this));
	if(dtx.widget.Widget.useCache && dtx.widget.Widget.cache.exists(name)) {
		var _g = 0;
		var _g1 = dtx.widget.Widget.cache.get(name);
		while(_g < _g1.length) {
			var n = _g1[_g];
			++_g;
			this.collection.push(n == null?null:n.cloneNode(true));
		}
	} else {
		var c = dtx.Tools.parse(this.get_template());
		this.collection = c.collection;
		if(dtx.widget.Widget.useCache) {
			var v;
			var _g = [];
			var _g1 = 0;
			var _g2 = c.collection;
			while(_g1 < _g2.length) {
				var n = _g2[_g1];
				++_g1;
				_g.push(n == null?null:n.cloneNode(true));
			}
			v = _g;
			dtx.widget.Widget.cache.set(name,v);
			v;
		}
	}
	this._dtxWidgetNodeIndex = [];
	var _g = 0;
	var _g1 = this.collection.concat(dtx.collection.Traversing.descendants(this).collection);
	while(_g < _g1.length) {
		var n = _g1[_g];
		++_g;
		if(dtx.single.ElementManipulation.isElement(n)) {
			var att = dtx.single.ElementManipulation.attr(n,"data-dtx-id");
			if(att != "") {
				this._dtxWidgetNodeIndex[Std.parseInt(att)] = n;
				dtx.single.ElementManipulation.removeAttr(n,"data-dtx-id");
			}
		}
	}
	this.init();
};
dtx.widget.Widget.__name__ = ["dtx","widget","Widget"];
dtx.widget.Widget.__super__ = dtx.DOMCollection;
dtx.widget.Widget.prototype = $extend(dtx.DOMCollection.prototype,{
	get_template: function() {
		return "";
	}
	,init: function() {
	}
	,__class__: dtx.widget.Widget
});
var PersonWidget = function() {
	this.p = null;
	dtx.widget.Widget.call(this);
};
PersonWidget.__name__ = ["PersonWidget"];
PersonWidget.__super__ = dtx.widget.Widget;
PersonWidget.prototype = $extend(dtx.widget.Widget.prototype,{
	set_p: function(v) {
		this.p = v;
		dtx.single.ElementManipulation.setText(dtx.single.Traversing.children(this._dtxWidgetNodeIndex[5],false).getNode(0),this.p != null?this.p != null?"" + this.p.name + " is " + this.p.getAge() + " years old.":"":"");
		dtx.single.ElementManipulation.setText(dtx.single.Traversing.children(this._dtxWidgetNodeIndex[5],false).getNode(0),this.p != null?this.p != null?"" + this.p.name + " is " + this.p.getAge() + " years old.":"":"");
		dtx.single.ElementManipulation.setText(dtx.single.Traversing.children(this._dtxWidgetNodeIndex[4],false).getNode(0),this.p != null?"" + DateTools.format(this.p.dob,"%Y-%m-%d"):"");
		dtx.single.ElementManipulation.setText(dtx.single.Traversing.children(this._dtxWidgetNodeIndex[3],false).getNode(0),this.p != null?"" + this.p.email:"");
		dtx.single.ElementManipulation.setAttr(this._dtxWidgetNodeIndex[3],"href",this.p != null?"mailto:" + this.p.email:"");
		dtx.single.ElementManipulation.setText(dtx.single.Traversing.children(this._dtxWidgetNodeIndex[2],false).getNode(0),this.p != null?"" + this.p.name:"");
		dtx.single.ElementManipulation.setAttr(this._dtxWidgetNodeIndex[1],"src",this.p != null?"http://www.gravatar.com/avatar/" + haxe.crypto.Md5.encode(this.p.email):"");
		dtx.single.ElementManipulation.setAttr(this._dtxWidgetNodeIndex[1],"alt",this.p != null?"" + this.p.name + "'s Avatar":"");
		dtx.single.ElementManipulation.setText(dtx.single.Traversing.children(this._dtxWidgetNodeIndex[0],false).getNode(0),this.p != null?"" + this.p.name:"");
		return v;
	}
	,init: function() {
		this.set_p(null);
		this.set_p(null);
		this.set_p(null);
		this.set_p(null);
		this.set_p(null);
		this.set_p(null);
	}
	,get_template: function() {
		return "<div class=\"well\"><h1 data-dtx-id=\"0\">${p.name}</h1><div class=\"row\"><div class=\"col-sm-3\"><img data-dtx-id=\"1\" alt=\"${p.name}'s Avatar\" src=\"http://www.gravatar.com/avatar/${Md5.encode(p.email)}\" /></div><div class=\"col-sm-9\"><dl><dt>Name:</dt><dd data-dtx-id=\"2\">${p.name}</dd><dt>Email:</dt><dd><a href=\"mailto:${p.email}\" data-dtx-id=\"3\">${p.email}</a></dd><dt>Date of Birth</dt><dd data-dtx-id=\"4\">${p.dob.format(\"%Y-%m-%d\")}</dd></dl><p data-dtx-id=\"5\">${p.name} is ${p.getAge()} years old.</p></div></div></div>";
	}
	,__class__: PersonWidget
});
var DateTools = function() { };
DateTools.__name__ = ["DateTools"];
DateTools.__format_get = function(d,e) {
	switch(e) {
	case "%":
		return "%";
	case "C":
		return StringTools.lpad("" + (function($this) {
			var $r;
			var x = d.getFullYear() / 100;
			$r = x | 0;
			return $r;
		}(this)),"0",2);
	case "d":
		return StringTools.lpad("" + d.getDate(),"0",2);
	case "D":
		return DateTools.__format(d,"%m/%d/%y");
	case "e":
		return "" + d.getDate();
	case "H":case "k":
		return StringTools.lpad("" + d.getHours(),e == "H"?"0":" ",2);
	case "I":case "l":
		var hour = d.getHours() % 12;
		return StringTools.lpad(Std.string(hour == 0?12:hour),e == "I"?"0":" ",2);
	case "m":
		return StringTools.lpad("" + (d.getMonth() + 1),"0",2);
	case "M":
		return StringTools.lpad("" + d.getMinutes(),"0",2);
	case "n":
		return "\n";
	case "p":
		if(d.getHours() > 11) return "PM"; else return "AM";
		break;
	case "r":
		return DateTools.__format(d,"%I:%M:%S %p");
	case "R":
		return DateTools.__format(d,"%H:%M");
	case "s":
		return "" + (function($this) {
			var $r;
			var x = d.getTime() / 1000;
			$r = x | 0;
			return $r;
		}(this));
	case "S":
		return StringTools.lpad("" + d.getSeconds(),"0",2);
	case "t":
		return "\t";
	case "T":
		return DateTools.__format(d,"%H:%M:%S");
	case "u":
		var t = d.getDay();
		if(t == 0) return "7"; else return "" + t;
		break;
	case "w":
		return "" + d.getDay();
	case "y":
		return StringTools.lpad("" + d.getFullYear() % 100,"0",2);
	case "Y":
		return "" + d.getFullYear();
	default:
		throw "Date.format %" + e + "- not implemented yet.";
	}
};
DateTools.__format = function(d,f) {
	var r = new StringBuf();
	var p = 0;
	while(true) {
		var np = f.indexOf("%",p);
		if(np < 0) break;
		var len = np - p;
		r.b += len == null?HxOverrides.substr(f,p,null):HxOverrides.substr(f,p,len);
		var x = DateTools.__format_get(d,HxOverrides.substr(f,np + 1,1));
		r.b += Std.string(x);
		p = np + 2;
	}
	var len = f.length - p;
	r.b += len == null?HxOverrides.substr(f,p,null):HxOverrides.substr(f,p,len);
	return r.b;
};
DateTools.format = function(d,f) {
	return DateTools.__format(d,f);
};
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw "EReg::matched";
	}
	,__class__: EReg
};
var HxOverrides = function() { };
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.__name__ = ["Lambda"];
Lambda.has = function(it,elt) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x == elt) return true;
	}
	return false;
};
var IMap = function() { };
IMap.__name__ = ["IMap"];
Math.__name__ = ["Math"];
var Std = function() { };
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = ["StringTools"];
StringTools.lpad = function(s,c,l) {
	if(c.length <= 0) return s;
	while(s.length < l) s = c + s;
	return s;
};
var Type = function() { };
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	return o.__class__;
};
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
};
dtx.Tools = function() { };
dtx.Tools.__name__ = ["dtx","Tools"];
dtx.Tools.find = function(selector) {
	return new dtx.DOMCollection(selector);
};
dtx.Tools.create = function(name) {
	var elm = null;
	if(name != null) try {
		elm = document.createElement(name);
	} catch( e ) {
		elm = null;
	}
	return elm;
};
dtx.Tools.parse = function(html) {
	var q;
	if(html != null && html != "") {
		var parentTag = "div";
		if(dtx.Tools.firstTag.match(html)) {
			var tagName = dtx.Tools.firstTag.matched(1);
			switch(tagName) {
			case "tbody":
				parentTag = "table";
				break;
			case "tfoot":
				parentTag = "table";
				break;
			case "thead":
				parentTag = "table";
				break;
			case "colgroup":
				parentTag = "table";
				break;
			case "col":
				parentTag = "colgroup";
				break;
			case "tr":
				parentTag = "tbody";
				break;
			case "th":
				parentTag = "tr";
				break;
			case "td":
				parentTag = "tr";
				break;
			default:
				parentTag = "div";
			}
		}
		var n = dtx.Tools.create(parentTag);
		dtx.single.ElementManipulation.setInnerHTML(n,html);
		q = dtx.single.Traversing.children(n,false);
	} else q = new dtx.DOMCollection();
	return q;
};
dtx.Tools.get_document = function() {
	if(dtx.Tools.document == null) dtx.Tools.document = document;
	return dtx.Tools.document;
};
dtx.Tools.ready = function(f) {
	(function(h,a,c,k){if(h[a]==null&&h[c]){h[a]="loading";h[c](k,c=function(){h[a]="complete";h.removeEventListener(k,c,!1)},!1)}})(document,"readyState","addEventListener","DOMContentLoaded");
	var o = window;
	o.checkReady = dtx.Tools.checkReady;
	dtx.Tools.checkReady(f);
};
dtx.Tools.checkReady = function(f) {
	/in/.test(document.readyState) ? setTimeout(function () { checkReady(f) }, 9) : f();
};
dtx.collection = {};
dtx.collection.DOMManipulation = function() { };
dtx.collection.DOMManipulation.__name__ = ["dtx","collection","DOMManipulation"];
dtx.collection.DOMManipulation.append = function(parentCollection,childNode,childCollection) {
	var firstChildUsed = false;
	if(parentCollection != null) {
		var $it0 = HxOverrides.iter(parentCollection.collection);
		while( $it0.hasNext() ) {
			var parent = $it0.next();
			if(firstChildUsed && childNode != null) childNode = childNode.cloneNode(true); else childNode = childNode;
			if(firstChildUsed && childCollection != null) childCollection = childCollection.clone(); else childCollection = childCollection;
			dtx.single.DOMManipulation.append(parent,childNode,childCollection);
			firstChildUsed = true;
		}
	}
	return parentCollection;
};
dtx.collection.DOMManipulation.appendTo = function(children,parentNode,parentCollection) {
	if(parentNode != null) dtx.single.DOMManipulation.append(parentNode,null,children);
	if(parentCollection != null) dtx.collection.DOMManipulation.append(parentCollection,null,children);
	return children;
};
dtx.collection.EventManagement = function() { };
dtx.collection.EventManagement.__name__ = ["dtx","collection","EventManagement"];
dtx.collection.EventManagement.on = function(targetCollection,eventType,selector,listener) {
	var $it0 = HxOverrides.iter(targetCollection.collection);
	while( $it0.hasNext() ) {
		var target = $it0.next();
		if(target != null) {
			if(listener != null) {
				if(selector != null) bean.on(target,eventType,selector,listener); else bean.on(target,eventType,listener);
			} else {
				if(target != null) bean.fire(target,eventType);
				target;
			}
		}
		target;
	}
	return targetCollection;
};
dtx.collection.Traversing = function() { };
dtx.collection.Traversing.__name__ = ["dtx","collection","Traversing"];
dtx.collection.Traversing.descendants = function(query,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var descendantList = new dtx.DOMCollection();
	if(query != null) {
		var $it0 = HxOverrides.iter(query.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			var l = dtx.single.Traversing.descendants(node,elementsOnly);
			descendantList.addCollection(l);
		}
	}
	return descendantList;
};
dtx.single = {};
dtx.single.DOMManipulation = function() { };
dtx.single.DOMManipulation.__name__ = ["dtx","single","DOMManipulation"];
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
};
dtx.single.ElementManipulation = function() { };
dtx.single.ElementManipulation.__name__ = ["dtx","single","ElementManipulation"];
dtx.single.ElementManipulation.isElement = function(node) {
	return node != null && node.nodeType == 1;
};
dtx.single.ElementManipulation.isDocument = function(node) {
	return node != null && node.nodeType == 9;
};
dtx.single.ElementManipulation.attr = function(elm,attName) {
	var ret = "";
	if(dtx.single.ElementManipulation.isElement(elm)) {
		var element = elm;
		ret = element.getAttribute(attName);
		if(ret == null) ret = "";
	}
	return ret;
};
dtx.single.ElementManipulation.setAttr = function(elm,attName,attValue) {
	if(elm != null && elm.nodeType == 1) {
		var element = elm;
		element.setAttribute(attName,attValue);
	}
	return elm;
};
dtx.single.ElementManipulation.removeAttr = function(elm,attName) {
	if(elm != null && elm.nodeType == 1) {
		var element = elm;
		element.removeAttribute(attName);
	}
	return elm;
};
dtx.single.ElementManipulation.setText = function(elm,text) {
	if(elm != null) {
		if(dtx.single.ElementManipulation.isElement(elm)) elm.textContent = text; else elm.nodeValue = text;
	}
	return elm;
};
dtx.single.ElementManipulation.setInnerHTML = function(elm,html) {
	if(elm != null) {
		var _g = elm.nodeType;
		switch(_g) {
		case 1:
			var element = elm;
			element.innerHTML = html;
			break;
		default:
			elm.textContent = html;
		}
	}
	return elm;
};
dtx.single.Traversing = function() { };
dtx.single.Traversing.__name__ = ["dtx","single","Traversing"];
dtx.single.Traversing.children = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var children = new dtx.DOMCollection();
	if(node != null && dtx.single.ElementManipulation.isElement(node)) children.addNodeList(node.childNodes,elementsOnly);
	return children;
};
dtx.single.Traversing.descendants = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	var descendantList = new dtx.DOMCollection();
	var $it0 = (function($this) {
		var $r;
		var _this = dtx.single.Traversing.children(node,elementsOnly);
		$r = HxOverrides.iter(_this.collection);
		return $r;
	}(this));
	while( $it0.hasNext() ) {
		var child = $it0.next();
		descendantList.add(child);
		descendantList.addCollection(dtx.single.Traversing.descendants(child,elementsOnly));
	}
	return descendantList;
};
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
};
var haxe = {};
haxe.crypto = {};
haxe.crypto.Md5 = function() {
};
haxe.crypto.Md5.__name__ = ["haxe","crypto","Md5"];
haxe.crypto.Md5.encode = function(s) {
	var m = new haxe.crypto.Md5();
	var h = m.doEncode(haxe.crypto.Md5.str2blks(s));
	return m.hex(h);
};
haxe.crypto.Md5.str2blks = function(str) {
	var nblk = (str.length + 8 >> 6) + 1;
	var blks = new Array();
	var blksSize = nblk * 16;
	var _g = 0;
	while(_g < blksSize) {
		var i = _g++;
		blks[i] = 0;
	}
	var i = 0;
	while(i < str.length) {
		blks[i >> 2] |= HxOverrides.cca(str,i) << (str.length * 8 + i) % 4 * 8;
		i++;
	}
	blks[i >> 2] |= 128 << (str.length * 8 + i) % 4 * 8;
	var l = str.length * 8;
	var k = nblk * 16 - 2;
	blks[k] = l & 255;
	blks[k] |= (l >>> 8 & 255) << 8;
	blks[k] |= (l >>> 16 & 255) << 16;
	blks[k] |= (l >>> 24 & 255) << 24;
	return blks;
};
haxe.crypto.Md5.prototype = {
	bitOR: function(a,b) {
		var lsb = a & 1 | b & 1;
		var msb31 = a >>> 1 | b >>> 1;
		return msb31 << 1 | lsb;
	}
	,bitXOR: function(a,b) {
		var lsb = a & 1 ^ b & 1;
		var msb31 = a >>> 1 ^ b >>> 1;
		return msb31 << 1 | lsb;
	}
	,bitAND: function(a,b) {
		var lsb = a & 1 & (b & 1);
		var msb31 = a >>> 1 & b >>> 1;
		return msb31 << 1 | lsb;
	}
	,addme: function(x,y) {
		var lsw = (x & 65535) + (y & 65535);
		var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
		return msw << 16 | lsw & 65535;
	}
	,hex: function(a) {
		var str = "";
		var hex_chr = "0123456789abcdef";
		var _g = 0;
		while(_g < a.length) {
			var num = a[_g];
			++_g;
			var _g1 = 0;
			while(_g1 < 4) {
				var j = _g1++;
				str += hex_chr.charAt(num >> j * 8 + 4 & 15) + hex_chr.charAt(num >> j * 8 & 15);
			}
		}
		return str;
	}
	,rol: function(num,cnt) {
		return num << cnt | num >>> 32 - cnt;
	}
	,cmn: function(q,a,b,x,s,t) {
		return this.addme(this.rol(this.addme(this.addme(a,q),this.addme(x,t)),s),b);
	}
	,ff: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitOR(this.bitAND(b,c),this.bitAND(~b,d)),a,b,x,s,t);
	}
	,gg: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitOR(this.bitAND(b,d),this.bitAND(c,~d)),a,b,x,s,t);
	}
	,hh: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitXOR(this.bitXOR(b,c),d),a,b,x,s,t);
	}
	,ii: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitXOR(c,this.bitOR(b,~d)),a,b,x,s,t);
	}
	,doEncode: function(x) {
		var a = 1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d = 271733878;
		var step;
		var i = 0;
		while(i < x.length) {
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;
			step = 0;
			a = this.ff(a,b,c,d,x[i],7,-680876936);
			d = this.ff(d,a,b,c,x[i + 1],12,-389564586);
			c = this.ff(c,d,a,b,x[i + 2],17,606105819);
			b = this.ff(b,c,d,a,x[i + 3],22,-1044525330);
			a = this.ff(a,b,c,d,x[i + 4],7,-176418897);
			d = this.ff(d,a,b,c,x[i + 5],12,1200080426);
			c = this.ff(c,d,a,b,x[i + 6],17,-1473231341);
			b = this.ff(b,c,d,a,x[i + 7],22,-45705983);
			a = this.ff(a,b,c,d,x[i + 8],7,1770035416);
			d = this.ff(d,a,b,c,x[i + 9],12,-1958414417);
			c = this.ff(c,d,a,b,x[i + 10],17,-42063);
			b = this.ff(b,c,d,a,x[i + 11],22,-1990404162);
			a = this.ff(a,b,c,d,x[i + 12],7,1804603682);
			d = this.ff(d,a,b,c,x[i + 13],12,-40341101);
			c = this.ff(c,d,a,b,x[i + 14],17,-1502002290);
			b = this.ff(b,c,d,a,x[i + 15],22,1236535329);
			a = this.gg(a,b,c,d,x[i + 1],5,-165796510);
			d = this.gg(d,a,b,c,x[i + 6],9,-1069501632);
			c = this.gg(c,d,a,b,x[i + 11],14,643717713);
			b = this.gg(b,c,d,a,x[i],20,-373897302);
			a = this.gg(a,b,c,d,x[i + 5],5,-701558691);
			d = this.gg(d,a,b,c,x[i + 10],9,38016083);
			c = this.gg(c,d,a,b,x[i + 15],14,-660478335);
			b = this.gg(b,c,d,a,x[i + 4],20,-405537848);
			a = this.gg(a,b,c,d,x[i + 9],5,568446438);
			d = this.gg(d,a,b,c,x[i + 14],9,-1019803690);
			c = this.gg(c,d,a,b,x[i + 3],14,-187363961);
			b = this.gg(b,c,d,a,x[i + 8],20,1163531501);
			a = this.gg(a,b,c,d,x[i + 13],5,-1444681467);
			d = this.gg(d,a,b,c,x[i + 2],9,-51403784);
			c = this.gg(c,d,a,b,x[i + 7],14,1735328473);
			b = this.gg(b,c,d,a,x[i + 12],20,-1926607734);
			a = this.hh(a,b,c,d,x[i + 5],4,-378558);
			d = this.hh(d,a,b,c,x[i + 8],11,-2022574463);
			c = this.hh(c,d,a,b,x[i + 11],16,1839030562);
			b = this.hh(b,c,d,a,x[i + 14],23,-35309556);
			a = this.hh(a,b,c,d,x[i + 1],4,-1530992060);
			d = this.hh(d,a,b,c,x[i + 4],11,1272893353);
			c = this.hh(c,d,a,b,x[i + 7],16,-155497632);
			b = this.hh(b,c,d,a,x[i + 10],23,-1094730640);
			a = this.hh(a,b,c,d,x[i + 13],4,681279174);
			d = this.hh(d,a,b,c,x[i],11,-358537222);
			c = this.hh(c,d,a,b,x[i + 3],16,-722521979);
			b = this.hh(b,c,d,a,x[i + 6],23,76029189);
			a = this.hh(a,b,c,d,x[i + 9],4,-640364487);
			d = this.hh(d,a,b,c,x[i + 12],11,-421815835);
			c = this.hh(c,d,a,b,x[i + 15],16,530742520);
			b = this.hh(b,c,d,a,x[i + 2],23,-995338651);
			a = this.ii(a,b,c,d,x[i],6,-198630844);
			d = this.ii(d,a,b,c,x[i + 7],10,1126891415);
			c = this.ii(c,d,a,b,x[i + 14],15,-1416354905);
			b = this.ii(b,c,d,a,x[i + 5],21,-57434055);
			a = this.ii(a,b,c,d,x[i + 12],6,1700485571);
			d = this.ii(d,a,b,c,x[i + 3],10,-1894986606);
			c = this.ii(c,d,a,b,x[i + 10],15,-1051523);
			b = this.ii(b,c,d,a,x[i + 1],21,-2054922799);
			a = this.ii(a,b,c,d,x[i + 8],6,1873313359);
			d = this.ii(d,a,b,c,x[i + 15],10,-30611744);
			c = this.ii(c,d,a,b,x[i + 6],15,-1560198380);
			b = this.ii(b,c,d,a,x[i + 13],21,1309151649);
			a = this.ii(a,b,c,d,x[i + 4],6,-145523070);
			d = this.ii(d,a,b,c,x[i + 11],10,-1120210379);
			c = this.ii(c,d,a,b,x[i + 2],15,718787259);
			b = this.ii(b,c,d,a,x[i + 9],21,-343485551);
			a = this.addme(a,olda);
			b = this.addme(b,oldb);
			c = this.addme(c,oldc);
			d = this.addme(d,oldd);
			i += 16;
		}
		return [a,b,c,d];
	}
	,__class__: haxe.crypto.Md5
};
haxe.ds = {};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,__class__: haxe.ds.StringMap
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = ["js","Boot"];
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
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
		for( var k in o ) {
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
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
/*!
  * Bean - copyright (c) Jacob Thornton 2011-2012
  * https://github.com/fat/bean
  * MIT license
  */
!function(e,t,n){typeof module!="undefined"&&module.exports?module.exports=n(e,t):typeof define=="function"&&typeof define.amd=="object"?define(n):t[e]=n(e,t)}("bean",window,function(e,t){var n=window,r=t[e],i=/[^\.]*(?=\..*)\.|.*/,s=/\..*/,o="addEventListener",u="removeEventListener",a=document||{},f=a.documentElement||{},l=f[o],c=l?o:"attachEvent",h={},p=Array.prototype.slice,d=function(e,t){return e.split(t||" ")},v=function(e){return typeof e=="string"},m=function(e){return typeof e=="function"},g="click dblclick mouseup mousedown contextmenu mousewheel mousemultiwheel DOMMouseScroll mouseover mouseout mousemove selectstart selectend keydown keypress keyup orientationchange focus blur change reset select submit load unload beforeunload resize move DOMContentLoaded readystatechange message error abort scroll ",y="show input invalid touchstart touchmove touchend touchcancel gesturestart gesturechange gestureend textinputreadystatechange pageshow pagehide popstate hashchange offline online afterprint beforeprint dragstart dragenter dragover dragleave drag drop dragend loadstart progress suspend emptied stalled loadmetadata loadeddata canplay canplaythrough playing waiting seeking seeked ended durationchange timeupdate play pause ratechange volumechange cuechange checking noupdate downloading cached updateready obsolete ",b=function(e,t,n){for(n=0;n<t.length;n++)t[n]&&(e[t[n]]=1);return e}({},d(g+(l?y:""))),w=function(){var e="compareDocumentPosition"in f?function(e,t){return t.compareDocumentPosition&&(t.compareDocumentPosition(e)&16)===16}:"contains"in f?function(e,t){return t=t.nodeType===9||t===window?f:t,t!==e&&t.contains(e)}:function(e,t){while(e=e.parentNode)if(e===t)return 1;return 0},t=function(t){var n=t.relatedTarget;return n?n!==this&&n.prefix!=="xul"&&!/document/.test(this.toString())&&!e(n,this):n==null};return{mouseenter:{base:"mouseover",condition:t},mouseleave:{base:"mouseout",condition:t},mousewheel:{base:/Firefox/.test(navigator.userAgent)?"DOMMouseScroll":"mousewheel"}}}(),E=function(){var e=d("altKey attrChange attrName bubbles cancelable ctrlKey currentTarget detail eventPhase getModifierState isTrusted metaKey relatedNode relatedTarget shiftKey srcElement target timeStamp type view which propertyName"),t=e.concat(d("button buttons clientX clientY dataTransfer fromElement offsetX offsetY pageX pageY screenX screenY toElement")),r=t.concat(d("wheelDelta wheelDeltaX wheelDeltaY wheelDeltaZ axis")),i=e.concat(d("char charCode key keyCode keyIdentifier keyLocation location")),s=e.concat(d("data")),o=e.concat(d("touches targetTouches changedTouches scale rotation")),u=e.concat(d("data origin source")),l=e.concat(d("state")),c=/over|out/,h=[{reg:/key/i,fix:function(e,t){return t.keyCode=e.keyCode||e.which,i}},{reg:/click|mouse(?!(.*wheel|scroll))|menu|drag|drop/i,fix:function(e,n,r){n.rightClick=e.which===3||e.button===2,n.pos={x:0,y:0};if(e.pageX||e.pageY)n.clientX=e.pageX,n.clientY=e.pageY;else if(e.clientX||e.clientY)n.clientX=e.clientX+a.body.scrollLeft+f.scrollLeft,n.clientY=e.clientY+a.body.scrollTop+f.scrollTop;return c.test(r)&&(n.relatedTarget=e.relatedTarget||e[(r=="mouseover"?"from":"to")+"Element"]),t}},{reg:/mouse.*(wheel|scroll)/i,fix:function(){return r}},{reg:/^text/i,fix:function(){return s}},{reg:/^touch|^gesture/i,fix:function(){return o}},{reg:/^message$/i,fix:function(){return u}},{reg:/^popstate$/i,fix:function(){return l}},{reg:/.*/,fix:function(){return e}}],p={},v=function(e,t,r){if(!arguments.length)return;e=e||((t.ownerDocument||t.document||t).parentWindow||n).event,this.originalEvent=e,this.isNative=r,this.isBean=!0;if(!e)return;var i=e.type,s=e.target||e.srcElement,o,u,a,f,l;this.target=s&&s.nodeType===3?s.parentNode:s;if(r){l=p[i];if(!l)for(o=0,u=h.length;o<u;o++)if(h[o].reg.test(i)){p[i]=l=h[o].fix;break}f=l(e,this,i);for(o=f.length;o--;)!((a=f[o])in this)&&a in e&&(this[a]=e[a])}};return v.prototype.preventDefault=function(){this.originalEvent.preventDefault?this.originalEvent.preventDefault():this.originalEvent.returnValue=!1},v.prototype.stopPropagation=function(){this.originalEvent.stopPropagation?this.originalEvent.stopPropagation():this.originalEvent.cancelBubble=!0},v.prototype.stop=function(){this.preventDefault(),this.stopPropagation(),this.stopped=!0},v.prototype.stopImmediatePropagation=function(){this.originalEvent.stopImmediatePropagation&&this.originalEvent.stopImmediatePropagation(),this.isImmediatePropagationStopped=function(){return!0}},v.prototype.isImmediatePropagationStopped=function(){return this.originalEvent.isImmediatePropagationStopped&&this.originalEvent.isImmediatePropagationStopped()},v.prototype.clone=function(e){var t=new v(this,this.element,this.isNative);return t.currentTarget=e,t},v}(),S=function(e,t){return!l&&!t&&(e===a||e===n)?f:e},x=function(){var e=function(e,t,n,r){var i=function(n,i){return t.apply(e,r?p.call(i,n?0:1).concat(r):i)},s=function(n,r){return t.__beanDel?t.__beanDel.ft(n.target,e):r},o=n?function(e){var t=s(e,this);if(n.apply(t,arguments))return e&&(e.currentTarget=t),i(e,arguments)}:function(e){return t.__beanDel&&(e=e.clone(s(e))),i(e,arguments)};return o.__beanDel=t.__beanDel,o},t=function(t,n,r,i,s,o,u){var a=w[n],f;n=="unload"&&(r=A(O,t,n,r,i)),a&&(a.condition&&(r=e(t,r,a.condition,o)),n=a.base||n),this.isNative=f=b[n]&&!!t[c],this.customType=!l&&!f&&n,this.element=t,this.type=n,this.original=i,this.namespaces=s,this.eventType=l||f?n:"propertychange",this.target=S(t,f),this[c]=!!this.target[c],this.root=u,this.handler=e(t,r,null,o)};return t.prototype.inNamespaces=function(e){var t,n,r=0;if(!e)return!0;if(!this.namespaces)return!1;for(t=e.length;t--;)for(n=this.namespaces.length;n--;)e[t]==this.namespaces[n]&&r++;return e.length===r},t.prototype.matches=function(e,t,n){return this.element===e&&(!t||this.original===t)&&(!n||this.handler===n)},t}(),T=function(){var e={},t=function(n,r,i,s,o,u){var a=o?"r":"$";if(!r||r=="*")for(var f in e)f.charAt(0)==a&&t(n,f.substr(1),i,s,o,u);else{var l=0,c,h=e[a+r],p=n=="*";if(!h)return;for(c=h.length;l<c;l++)if((p||h[l].matches(n,i,s))&&!u(h[l],h,l,r))return}},n=function(t,n,r,i){var s,o=e[(i?"r":"$")+n];if(o)for(s=o.length;s--;)if(!o[s].root&&o[s].matches(t,r,null))return!0;return!1},r=function(e,n,r,i){var s=[];return t(e,n,r,null,i,function(e){return s.push(e)}),s},i=function(t){var n=!t.root&&!this.has(t.element,t.type,null,!1),r=(t.root?"r":"$")+t.type;return(e[r]||(e[r]=[])).push(t),n},s=function(n){t(n.element,n.type,null,n.handler,n.root,function(t,n,r){return n.splice(r,1),t.removed=!0,n.length===0&&delete e[(t.root?"r":"$")+t.type],!1})},o=function(){var t,n=[];for(t in e)t.charAt(0)=="$"&&(n=n.concat(e[t]));return n};return{has:n,get:r,put:i,del:s,entries:o}}(),N,C=function(e){arguments.length?N=e:N=a.querySelectorAll?function(e,t){return t.querySelectorAll(e)}:function(){throw new Error("Bean: No selector engine installed")}},k=function(e,t){if(!l&&t&&e&&e.propertyName!="_on"+t)return;var n=T.get(this,t||e.type,null,!1),r=n.length,i=0;e=new E(e,this,!0),t&&(e.type=t);for(;i<r&&!e.isImmediatePropagationStopped();i++)n[i].removed||n[i].handler.call(this,e)},L=l?function(e,t,n){e[n?o:u](t,k,!1)}:function(e,t,n,r){var i;n?(T.put(i=new x(e,r||t,function(t){k.call(e,t,r)},k,null,null,!0)),r&&e["_on"+r]==null&&(e["_on"+r]=0),i.target.attachEvent("on"+i.eventType,i.handler)):(i=T.get(e,r||t,k,!0)[0],i&&(i.target.detachEvent("on"+i.eventType,i.handler),T.del(i)))},A=function(e,t,n,r,i){return function(){r.apply(this,arguments),e(t,n,i)}},O=function(e,t,n,r){var i=t&&t.replace(s,""),o=T.get(e,i,null,!1),u={},a,f;for(a=0,f=o.length;a<f;a++)(!n||o[a].original===n)&&o[a].inNamespaces(r)&&(T.del(o[a]),!u[o[a].eventType]&&o[a][c]&&(u[o[a].eventType]={t:o[a].eventType,c:o[a].type}));for(a in u)T.has(e,u[a].t,null,!1)||L(e,u[a].t,!1,u[a].c)},M=function(e,t){var n=function(t,n){var r,i=v(e)?N(e,n):e;for(;t&&t!==n;t=t.parentNode)for(r=i.length;r--;)if(i[r]===t)return t},r=function(e){var r=n(e.target,this);r&&t.apply(r,arguments)};return r.__beanDel={ft:n,selector:e},r},_=l?function(e,t,r){var i=a.createEvent(e?"HTMLEvents":"UIEvents");i[e?"initEvent":"initUIEvent"](t,!0,!0,n,1),r.dispatchEvent(i)}:function(e,t,n){n=S(n,e),e?n.fireEvent("on"+t,a.createEventObject()):n["_on"+t]++},D=function(e,t,n){var r=v(t),o,u,a,f;if(r&&t.indexOf(" ")>0){t=d(t);for(f=t.length;f--;)D(e,t[f],n);return e}u=r&&t.replace(s,""),u&&w[u]&&(u=w[u].type);if(!t||r){if(a=r&&t.replace(i,""))a=d(a,".");O(e,u,n,a)}else if(m(t))O(e,null,t);else for(o in t)t.hasOwnProperty(o)&&D(e,o,t[o]);return e},P=function(e,t,n,r){var o,u,a,f,l,v,g;if(n===undefined&&typeof t=="object"){for(u in t)t.hasOwnProperty(u)&&P.call(this,e,u,t[u]);return}m(n)?(l=p.call(arguments,3),r=o=n):(o=r,l=p.call(arguments,4),r=M(n,o,N)),a=d(t),this===h&&(r=A(D,e,t,r,o));for(f=a.length;f--;)g=T.put(v=new x(e,a[f].replace(s,""),r,o,d(a[f].replace(i,""),"."),l,!1)),v[c]&&g&&L(e,v.eventType,!0,v.customType);return e},H=function(e,t,n,r){return P.apply(null,v(n)?[e,n,t,r].concat(arguments.length>3?p.call(arguments,5):[]):p.call(arguments))},B=function(){return P.apply(h,arguments)},j=function(e,t,n){var r=d(t),o,u,a,f,l;for(o=r.length;o--;){t=r[o].replace(s,"");if(f=r[o].replace(i,""))f=d(f,".");if(!f&&!n&&e[c])_(b[t],t,e);else{l=T.get(e,t,null,!1),n=[!1].concat(n);for(u=0,a=l.length;u<a;u++)l[u].inNamespaces(f)&&l[u].handler.apply(e,n)}}return e},F=function(e,t,n){var r=T.get(t,n,null,!1),i=r.length,s=0,o,u;for(;s<i;s++)r[s].original&&(o=[e,r[s].type],(u=r[s].handler.__beanDel)&&o.push(u.selector),o.push(r[s].original),P.apply(null,o));return e},I={on:P,add:H,one:B,off:D,remove:D,clone:F,fire:j,setSelectorEngine:C,noConflict:function(){return t[e]=r,this}};if(n.attachEvent){var q=function(){var e,t=T.entries();for(e in t)t[e].type&&t[e].type!=="unload"&&D(t[e].element,t[e].type);n.detachEvent("onunload",q),n.CollectGarbage&&n.CollectGarbage()};n.attachEvent("onunload",q)}return C(),I});
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
String.__name__ = ["String"];
Array.prototype.__class__ = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
dtx.widget.Widget.useCache = true;
dtx.widget.Widget.cache = new haxe.ds.StringMap();
dtx.Tools.firstTag = new EReg("<([a-z]+)[ />]","");
DataWidgetExample.main();
})();
