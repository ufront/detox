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

import dtx.Nodes;
import dtx.Node;
#if js
	import js.html.EventTarget;
	typedef Window = js.html.DOMWindow;
#end

/** 
* Designed to be used with "using dtx.Tools;" this gives you access
* to all of the classes defined in this module.  These include
*   - ElementManipulation
*   - DOMManipulation
*   - Traversing
*   - EventManagement (Client JS only)
*   - Style (Client JS only?)
*   - Animation (Client JS only)
* 
* I have so far made no effort at making these work cross platform,
* though I am designing unit tests which should hopefully simplify the process.
* 
* The API is designed to be similar to JQuery, though not as complete
* nor as robust in the cross-platform department.  JQuery will still be the
* better pick for many client side projects.
*
* There are a few advantages
*  - better integration into haxe's Object Oriented style
*  - hopefully a smaller codebase, thanks to Dead Code Elimination
*  - works with native Node or XMLNode, can work without wrapping
*  - works on non-js haxe platforms, hopefully
*/

class Tools 
{
	public static var document(get_document,null):Node;
	#if js 
	public static var body(get_body,null):Node;
	public static var window(get_window,null):Window; 
	#end

	/**
	* A helper function that lets you do this:
	* "#myElm".find().addClass("super");
	*/
	public static function find(selector:String)
	{
		return dtx.single.Traversing.find(Detox.document, selector);
	} 

	/**
	* A helper function that lets you do this:
	* "div".create().setAttr("id","myElm");
	*/
	public static function create(name:String):Node
	{
		var elm:Node = null;
		if (name != null)
		{
			#if js
				try {
					elm = untyped __js__("document").createElement(name);
				} 
				catch (e:Dynamic) {
					elm = null;
				}
			#else
				// Haxe doesn't validate the name, so we should.
				// I'm going to use a simplified (but not entirely accurate) validation.  See:
				// http://stackoverflow.com/questions/3158274/what-would-be-a-regex-for-valid-xml-names
				
				// If it is valid, create, if it's not, return null
				var valid = ~/^[a-zA-Z_:]([a-zA-Z0-9_:\.])*$/;
				elm = (valid.match(name)) ? Xml.createElement(name) : null;
			#end
		}
		return elm;
	}

	static var firstTag = ~/<([a-z]+)[ \/>]/;
	// static var firstTag = ~/^[^<]<([a-z]+)[ \/>]/;
	/**
	* A helper function that lets you do this:
	* "<div>Hello <i>There</i></div>".parse().find('i');
	*/
	public static function parse(html:String):Nodes
	{
		if (html != null && html != "")
		{
			#if js 
				var fragment = js.Browser.document.createDocumentFragment();
				var parentTag = "div";
				if (firstTag.match(html))
				{
					// It begins with a 
					var tagName = firstTag.matched(1);
					parentTag = switch(tagName) {
						case "tbody": "table";
						case "tfoot": "table";
						case "thead": "table";
						case "colgroup": "table";
						case "col": "colgroup";
						case "tr": "tbody";
						case "th": "tr";
						case "td": "tr";
						default: "div";
					};
				}
				var nodes = create(parentTag).setInnerHTML(html).children;
				for (child in nodes) {
					// Set the parent to a document fragment, so it's behaviour isn't odd for ancestors etc
					fragment.appendChild(child);
				}
				return nodes;
			#else 
				try {
					var doc = Xml.parse(html);
					function removeEmptyTextNodes(n:Xml) {
						if (n.nodeType==Xml.PCData && n.nodeValue=="") {
							n.parent.removeChild(n);
						}
						else if (n.nodeType==Xml.Document || n.nodeType==Xml.Element) {
							for (child in n) {
								removeEmptyTextNodes(child);
							}
						}
					}
					removeEmptyTextNodes(doc);
					return [ for (node in doc) node ];
				} catch (e:Dynamic) {
					return [];
				}
			#end
		}
		else return [];
	} 

	static function get_document():Node
	{
		if (document == null) 
		{
			#if js 
				// Sensible default: window.document in JS
				document = untyped __js__("document");
			#else 
				document = Xml.parse("<html></html>");
			#end
		}
		return document;
	}

	public static function setDocument(newDocument:Node)
	{
		// Only change the document if it has the right NodeType
		if (newDocument != null)
		{
			if (newDocument.nodeType == dtx.DOMType.DOCUMENT_NODE
				|| newDocument.nodeType == dtx.DOMType.ELEMENT_NODE)
			{
				document = newDocument;
			}
		}
	}

	#if js
		static inline function get_window():Window
		{
			return untyped __js__("window");
		}

		static inline function get_body():Node
		{
			return untyped document.body;
		}

		public static function ready(f:Void->Void)
		{
			/*
			SHIM TO MAKE SURE IT WORKS IN FF3.5 OR UNDER
			OTHERWISE: document.ready() will fire when the page loads, but if the page has already loaded
			it will never fire, so your javascript may never run.

			The below line of code is basically a highly minified version of this:

			// verify that document.readyState is undefined
			// verify that document.addEventListener is there
			// these two conditions are basically telling us
			// we are using Firefox < 3.6
			if(document.readyState == null && document.addEventListener){
			    // on DOMContentLoaded event, supported since ages
			    document.addEventListener("DOMContentLoaded", function DOMContentLoaded(){
			        // remove the listener itself
			        document.removeEventListener("DOMContentLoaded", DOMContentLoaded, false);
			        // assign readyState as complete
			        document.readyState = "complete";
			    }, false);
			    // set readyState = loading or interactive
			    // it does not really matter for this purpose
			    document.readyState = "loading";
			}

			Shim taken from:
			http://webreflection.blogspot.com.au/2009/11/195-chars-to-help-lazy-loading.html
			*/
			untyped __js__('(function(h,a,c,k){if(h[a]==null&&h[c]){h[a]="loading";h[c](k,c=function(){h[a]="complete";h.removeEventListener(k,c,!1)},!1)}})(document,"readyState","addEventListener","DOMContentLoaded")');

			// checkReady must be in the window's global namespace so we can call it again with setTimeOut
			Reflect.setField(get_window(), "checkReady", checkReady);
			checkReady(f);
		}

		static function checkReady(f:Void->Void)
		{
			/*
			Mini ready() function taken from:
			http://dustindiaz.com/smallest-domready-ever
			*/
			// untyped __js__('/in/.test(document.readyState) ? setTimeout("checkReady("+f+")", 9) : f()');
			untyped __js__('/in/.test(document.readyState) ? setTimeout(function () { checkReady(f) }, 9) : f()');
		}

		/** Ensure that Sizzle.js is included as a fallback for browsers that don't support querySelectorAll() (IE8 or lower) */
		public static function includeSizzle()
		{
			#if embed_js
				untyped haxe.macro.Compiler.includeFile("sizzle.js");
				throw "May need to expose sizzle here...";
			#end
		}

		/** Ensure that jQuery is included, as a fallback for browsers that don't support querySelectorAll() (IE8 or lower) */
		public static function includeJQuery()
		{
			#if embed_js
				untyped haxe.macro.Compiler.includeFile("js/jquery-latest.min.js");
				throw "May need to expose jquery here...";
			#end
		}
	#end
}