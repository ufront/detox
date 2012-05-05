/****
* Copyright 2012 Jason O'Neil. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE "AS IS" AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Jason O'Neil.
* 
****/

package domtools;

#if js
import js.w3c.level3.Core;
import js.w3c.level3.Events;
import CommonJS; 
import UserAgentContext;
#end
import domtools.DOMCollection;
import domtools.DOMNode;

/** 
* Designed to be used with "using domtools.Tools;" this gives you access
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
			#else 
			// Haxe doesn't validate the name, so we should.
			// I'm going to use a simplified (but not entirely accurate) validation.  See:
			// http://stackoverflow.com/questions/3158274/what-would-be-a-regex-for-valid-xml-names
			var valid = ~/^[a-zA-Z_:]([a-zA-Z0-9_:\.])*$/;

			// If it is valid, create, if it's not, return null
			elm = (valid.match(name)) ? Xml.createElement(name) : null;
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
		var q:DOMCollection ;
		if (html != null && html != "")
		{
			var n:DOMNode = DOMTools.create('div');
			//
			// TODO: report this bug to haxe mailing list.
			// this is allowed:
			// n.setInnerHTML("");
			// But this doesn't get swapped out to it's "using" function
			// Presumably because this class is a dependency of the DOMTools?
			// Either way haxe shouldn't do that...
			domtools.single.ElementManipulation.setInnerHTML(n, html);
			q = domtools.single.Traversing.children(n, false);
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
		return new DOMCollection(DOMTools.createElement(str));
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
			if (newDocument.nodeType == domtools.DOMType.DOCUMENT_NODE
				|| newDocument.nodeType == domtools.DOMType.ELEMENT_NODE)
			{
				// Because of the NodeType we can safely use this node as our document
				document = untyped newDocument;
			}
		}
	}
}