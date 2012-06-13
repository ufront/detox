/****
* Copyright (c) 2012 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/

package dtx;

#if js
import js.w3c.level3.Core;
import js.w3c.level3.Events;
import CommonJS; 
import UserAgentContext;
#end
import dtx.DOMCollection;
import dtx.DOMNode;

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
*  - works with native DOMNode or XMLNode, can work without wrapping
*  - works on non-js haxe platforms, hopefully
*/

class Tools 
{
	public static var document(get_document,null):DocumentOrElement;
	#if js public static var window(get_window,null):Window; #end

	function new()
	{
		
	}

	/**
	* A helper function that lets you do this:
	* "#myElm".find().addClass("super");
	*/
	public static function find(selector:String)
	{
		return new DOMCollection(selector);
	} 

	/**
	* A helper function that lets you do this:
	* "div".create().setAttr("id","myElm");
	*/
	public static function create(name:String)
	{
		var elm:DOMNode = null;
		if (name != null)
		{
			#if js
			try {
				elm = untyped __js__("document").createElement(name);
			} catch (e:Dynamic)
			{
				elm = null;
			}
			#elseif !flash8
			// Haxe doesn't validate the name, so we should.
			// I'm going to use a simplified (but not entirely accurate) validation.  See:
			// http://stackoverflow.com/questions/3158274/what-would-be-a-regex-for-valid-xml-names
			
			// If it is valid, create, if it's not, return null
			var valid = ~/^[a-zA-Z_:]([a-zA-Z0-9_:\.])*$/;
			elm = (valid.match(name)) ? Xml.createElement(name) : null;
			#else 
			// Flash 8 can't do Regex, so just try pass the name
			//var valid = ~/^[a-zA-Z_:]([a-zA-Z0-9_:\.])*$/;
			elm = Xml.createElement(name);
			#end
		}
		return elm;
	}

	/**
	* A helper function that lets you do this:
	* "<div>Hello <i>There</i></div>".parse().find('i');
	*/
	public static function parse(html:String)
	{
		var q:DOMCollection;
		if (html != null && html != "")
		{
			var n:DOMNode = create('div');
			//
			// TODO: report this bug to haxe mailing list.
			// this is allowed:
			// n.setInnerHTML("");
			// But this doesn't get swapped out to it's "using" function
			// Presumably because this class is a dependency of the Detox?
			// Either way haxe shouldn't do that...
			dtx.single.ElementManipulation.setInnerHTML(n, html);
			q = dtx.single.Traversing.children(n, false);
		}
		else 
		{
			q = new DOMCollection();
		}
		return q;
	} 

	#if js
	/**
	* A helper function that lets you do this in an event listener:
	* e.target.toNode().toggleClass('selected')
	*/
	public static function toDOMNode(eventHandler:EventTarget)
	{
		var elm:DOMNode;
		try {
			elm = cast eventHandler;
		} catch (e:Dynamic) { elm = null; }

		return elm;
	} 
	#end

	/*public static inline function create(str:String):DOMCollection
	{
		return new DOMCollection(Detox.createElement(str));
	}*/

	#if js
	static inline function get_window():Window
	{
		return untyped __js__("window");
	}
	#end

	static inline function get_document():DocumentOrElement
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

	public static function setDocument(newDocument:DOMNode)
	{
		// Only change the document if it has the right NodeType
		if (newDocument != null)
		{
			if (newDocument.nodeType == dtx.DOMType.DOCUMENT_NODE
				|| newDocument.nodeType == dtx.DOMType.ELEMENT_NODE)
			{
				// Because of the NodeType we can safely use this node as our document
				document = untyped newDocument;
			}
		}
	}
}