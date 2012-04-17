package domtools;

import haxe.macro.Expr;
import haxe.macro.Context;
using StringTools;

class Macros 
{
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