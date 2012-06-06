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

		var q = DTX.parse(template);
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