/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools;

import js.w3c.level3.Core;
import CommonJS; 
import domtools.Query;

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
	function new()
	{
		
	}

	/**
	* A helper function that lets you do this:
	* "#myElm".find().addClass("super");
	*/
	public static function find(selector:String)
	{
		return new Query(selector);
	} 

	/**
	* A helper function that lets you do this:
	* "div".create().setAttr("id","myElm");
	*/
	public static function create(elmName:String)
	{
		return Query.create(elmName);
	}

	/**
	* A helper function that lets you do this:
	* "<div>Hello <i>There</i></div>".parse().find('i');
	*/
	public static function parse(html:String)
	{
		return Query.parse(html);
	} 
}