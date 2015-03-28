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

import dtx.DOMCollection;
import dtx.DOMNode;
using StringTools;
#if js
	import js.html.BodyElement;
	import js.html.EventTarget;
	import js.html.DOMWindow;
#end

/**
	Tools is a collection of helper methods designed to be used with static extension.

	A typedef alias `Detox` exists, pointing to this class, so that you can write `using Detox` to enable static extension on all of these methods.
**/
class Tools
{
	/**
		A reference to the `document` element or node to be used as a global.

		For example, when writing `"#myelm".find()`, this will become `Tools.document.find("#myelm")`.

		This is exposed not as a full `js.html.Document` but rather as a `Node` that happens to have `querySelector` or `querySelectorAll` methods.
		This is done so that you can artificially set an element to your "document", which is useful for running unit tests etc.

		If `setDocument` has not been called, on JS the default value will be the HTML Document object (`document` in Javascript).
		On other platforms, the default value will be `Xml.parse("<html></html>")`.
	**/
	public static var document(get_document,null):DocumentOrElement;

	static function get_document():DocumentOrElement {
		if (document == null) {
			#if js
				// Sensible default: window.document in JS
				document = untyped __js__("document");
			#else
				document = Xml.parse("<html></html>");
			#end
		}
		return document;
	}

	#if js
		/**
			Available on Javascript only, this is a shortcut for `document.body`.
		**/
		public static var body(get_body,null):BodyElement;
		static inline function get_body():BodyElement return untyped document.body;

		/**
			Available on Javascript only, this is a shortcut for `window`.
		**/
		public static var window(get_window,null):DOMWindow;
		static inline function get_window():DOMWindow return untyped __js__("window");
	#end

	/**
		A helper function to turn a single node into a collection.

		Usage: `someNode.toCollection()`
	**/
	public static function toCollection(n:DOMNode):DOMCollection
	{
		return new DOMCollection([n]);
	}

	/**
		Search the current `document` to fetch all elements matching a CSS selector.

		Usage: `"#myElm".find().addClass("shiny");`

		This uses `dtx.single.Traversing.find(Detox.document, selector)` as it's implementation.

		@param selector A CSS selector used to match nodes in the document.
		@return A DOMCollection containing all matching nodes, or an empty collection if no match was found.
	**/
	public static function find(selector:String):DOMCollection
	{
		return dtx.single.Traversing.find(document, selector);
	}

	/**
		Create a new element with the given tag name.

		Usage: `"div".create().setText("Hello World!")`

		@param tagName The name of the element to be created.  Must begin with [a-zA-z_:] and then have only [a-zA-Z0-9_:.].  If the tagName is null, the function will return null.
		@return The new element as a DOMNode, or `null` if an error occured.
	**/
	public static function create(tagName:String):DOMNode
	{
		var elm:DOMNode = null;
		if (tagName != null)
		{
			#if js
				try elm = try untyped __js__("document").createElement(tagName) catch (e:Dynamic) null;
			#else
				// Haxe doesn't validate the name, so we should.
				// I'm going to use a simplified (but not entirely accurate) validation.  See:
				// http://stackoverflow.com/questions/3158274/what-would-be-a-regex-for-valid-xml-names

				// If it is valid, create, if it's not, return null
				var valid = ~/^[a-zA-Z_:]([a-zA-Z0-9_:\.])*$/;
				elm = (valid.match(tagName)) ? Xml.createElement(tagName) : null;
			#end
		}
		return elm;
	}

	static var firstTag:EReg = ~/<([a-z]+)[ \/>]/;

	/**
		Parse a given Xml string and return a DOMCollection.

		Usage: `'<a href="/$page/">$name</a>'.parse().addClass("btn")`

		If there was an error parsing the xml, the resulting DOMCollection will be empty and no error will be given.

		This is implemented by creating a parent element and calling `parent.setInnerHTML(xml)`.
		This means that the collection does not contain a document node, but rather all the nodes in your fragment.
		For example `var collection = "<p>Para</p> Text Node <div>Div</div>".parse()` would result in `collection.length==3`.
		On Javascript, care is taken to make sure the parent tag is correct for whatever HTML you are parsing, as there are rules about which child tags can belong to certain parent tags.

		On Javascript, the browsers built in HTML/Xml parser is used via `setInnerHTML`.
		On other targets, either `Xml.parse` or `haxe.xml.Parser.parse` is used, depending on the platform and if the string has an ampersand.
		(Note: `haxe.xml.Parser.parse()` handles HTML entities slightly better than `Xml.parse()`.)

		@param xml The XML or HTML string to parse.  On Javascript the browser is fairly tolerant of both Xml and Html, and invalid code also.  On other platforms it must be valid Xml.
		@return A DOMCollection containing the parsed nodes.  It will be empty if the string is null, empty (""), or was unable to be parsed correctly.
	**/
	public static function parse(xml:String):DOMCollection
	{
		var q:DOMCollection;
		if (xml != null && xml != "")
		{
			#if js
				var parentTag = "div";
				if (firstTag.match(xml))
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
				var n:DOMNode = create(parentTag);
			#else
				var n:DOMNode = create("div");
			#end

			//
			// TODO: report this bug to haxe mailing list.
			// this is allowed:
			// n.setInnerHTML("");
			// But this doesn't get swapped out to it's "using" function
			// Presumably because this class is a dependency of the Detox?
			// Either way haxe shouldn't do that...
			dtx.single.ElementManipulation.setInnerHTML(n, xml);
			q = dtx.single.Traversing.children(n, false);

			#if (!js)
				// This is a workaround for a glitch where parse("<!-- Comment -->") generates
				// a collection with 2 nodes - the comment and an empty text node.
				// See https://github.com/HaxeFoundation/haxe/issues/4096
				for (child in q)
				{
					if (dtx.single.ElementManipulation.isTextNode(child) && child.nodeValue == "")
					{
						q.removeFromCollection(child);
					}
				}
			#end
		}
		else
		{
			q = new DOMCollection();
		}
		return q;
	}

	/**
		Set the `document` to be used as our global document, for `find()` etc to be based on.

		If `newDocument` is null, or a type other than DOCUMENT_NODE or ELEMENT_NODE, then `document` will remain unchanged.
	**/
	public static function setDocument(newDocument:DOMNode):Void
	{
		// Only change the document if it has the right NodeType
		if (newDocument != null)
		{
			if (newDocument.nodeType == dtx.DOMType.DOCUMENT_NODE
				|| newDocument.nodeType == dtx.DOMType.ELEMENT_NODE)
			{
				// Because of the NodeType we can safely use this node as our document
				document = cast newDocument;
			}
		}
	}

	#if js
	/**
		Allows you to convert a haxe `Xml` object to a `dtx.DOMNode` / `js.html.Node`.

		Does this by converting the Xml to a HTML String, and then parsing it in the browser.

		If the conversion fails, or `x` is null, an empty DOMCollection is returned.

		Usage: `Xml.parse("<some>Xml</some>").toDetox().addClass("simple")`

		Available on Javascript only.
	**/
	public static function toDetox(x:Xml):DOMCollection
	{
		return ( x!=null ) ? parse( x.toString() ) : new DOMCollection();
	}

	/**
		Cast an EventTarget to a DOMNode.

		If the event handler is of the wrong type, it returns null.

		Usage:

		```
		var buttons = ".btn".find();
		buttons.click(function (e) {
			e.target.toNode().toggleClass('selected');
		});
	**/
	public static function toNode(eventHandler:EventTarget):DOMNode
	{
		return (eventHandler!=null && Std.is(eventHandler,js.html.Node)) ? cast eventHandler : null;
	}

	/**
		Run a function once the DOM is ready.

		See the comments in the code for details on the implementation, but basically this is a highly minimized, fairly safe way to know that the DOM is ready to go, even before `window.load` has fired.

		If the DOM has already loaded when this is called, the function will call immediately.

		Usage: `Detox.ready( function() "p".find().setText("It's READY!") )`

		@param f function to call when DOM is ready.  If null, it will be ignored.
	**/
	public static function ready(f:Void->Void):Void
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

		if ( f!=null ) checkReady(f);
	}

	static function checkReady(f:Void->Void):Void
	{
		/*
		Mini ready() function taken from:
		http://dustindiaz.com/smallest-domready-ever
		*/
		untyped __js__('/in/.test(document.readyState) ? setTimeout(function () { checkReady(f) }, 9) : f()');
	}

	/**
		(NOT SUPPORTED YET)

		Ensure that Sizzle.js is included as a fallback for browsers that don't support querySelectorAll() (IE8 or lower).

		Please make sure you define `-D embed_js` or else include the `sizzle.js` script before your Haxe script loads.

		@todo This currently imports sizzle, but the Traversing.find() functions are not falling back to use it correctly.
	**/
	public static function includeSizzle():Void
	{
		#if (haxe_211 || haxe3)
			#if embed_js
				untyped haxe.macro.Compiler.includeFile("sizzle.js");
			#end
		#else
			#if !noEmbedJS
				haxe.macro.Tools.includeFile("sizzle.js");
			#end
		#end
	}

	/**
		(NOT SUPPORTED YET)

		Ensure that jquery.js is included as a fallback for browsers that don't support querySelectorAll() (IE8 or lower).

		Please make sure you define `-D embed_js` or else include the `jQuery.js` script before your Haxe script loads.

		@todo This currently imports jQuery, but the Traversing.find() functions are not falling back to use it correctly.
	**/
	public static function includeJQuery():Void
	{
		#if (haxe_211 || haxe3)
			#if embed_js
				untyped haxe.macro.Compiler.includeFile("js/jquery-latest.min.js");
			#end
		#else
			#if !noEmbedJS
				haxe.macro.Tools.includeFile("js/jquery-latest.min.js");
			#end
		#end
	}
	#end
}
