package domtools;

import haxe.macro.Expr;
import haxe.macro.Context;

class Macros 
{
	/**
	* Load a file at compile time to use as a template.  Filename should be relative to the classpath.
	*/
	#if (js || macro)
	@:macro public static function loadTemplate( ?fileName : Expr )
	{
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

		if( templateFile == null ) {
			// classFile = path/to/Class.hx
			// templateFile = classFile.replace('.hx', '.tpl')
			//
			templateFile = "default.tpl";
		}

		var f = try neko.io.File.getContent(Context.resolvePath(templateFile)) catch( e : Dynamic ) Context.error(Std.string(e), fileName.pos);
		var p = Context.currentPos();
		return { expr : EConst(CString(f)), pos : p };
	}
	#end
}