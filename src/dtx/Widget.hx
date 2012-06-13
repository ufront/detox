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
import js.w3c.level3.Core.Document;
import CommonJS;
import dtx.DOMCollection;

class Widget extends DOMCollection
#else 
import haxe.macro.Expr;
import haxe.macro.Context;
using StringTools;

class Widget
#end
{
	#if js
	/** Create a new widget by parsing some "template" html, and use that as our collection.
	When your class extends this, it will automatically work with the dtx API (through using).  
	Therefore your class can have very tight integration between haxe features and the DOM. */
	public function new(template:String)
	{
		super();

		var q = Detox.parse(template);
		this.collection = q.collection;
	}
	#end

	/**
	* Load a file at compile time to use as a template.  Filename should be relative to the classpath.
	*/
	#if (js || macro)
	@:macro public static function loadTemplate( ?fileName : Expr )
	{
		var p = Context.currentPos();

		// Get the name of the file passed to the macro
		var templateFile = switch( fileName.expr ) 
		{
			case EConst(c):
				switch( c ) 
				{
					case CString(str): str;
					default: 
						null;
				}
			default: null;
		} 

		// If no file was passed, look for a file in the same spot but with ".tpl"
		// instead of ".hx" at the end.
		if( templateFile == null ) {
			var currentFile = Context.getPosInfos(p).file;
			templateFile = ~/\.hx$/.replace(currentFile, ".tpl");
		}

		var f:String;

		try 
		{
			// Try to read the specified file
			f = neko.io.File.getContent(Context.resolvePath(templateFile));
		} 
		catch( e : Dynamic ) 
		{
			// If it fails, give an error message at compile time
			var errorMessage = "Could not load template: " + templateFile;
			Context.error(errorMessage, p);
		}

		return { expr : EConst(CString(f)), pos : p };
	}
	#end
}