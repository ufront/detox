package dtx.widget;

import haxe.macro.Expr;
import haxe.macro.Context;
using StringTools;

class WidgetTools 
{
    /**
    * This macro is called on ANY subclass of detox.widget.Widget
    * 
    * It's purpose is to get the template for each Widget Class
    * It looks for: 
    *  - Metadata in the form: @template("<div></div>") class MyWidget ...
    *  - Metadata in the form: @loadTemplate("MyWidgetTemplate.html") class MyWidget ...
    *  - Take a guess at a filename... use current filename, but replace ".hx" with ".html"
    *  - 
    */
    @:macro public static function buildWidget():Array<Field>
    {
        //
        // SET UP
        //
        var widgetPos = Context.currentPos();                   // Position where the original Widget class is declared
        var localClass = haxe.macro.Context.getLocalClass();    // Class that is being declared
        var p = localClass.get().pos;                           // Position where the original Widget class is declared
        var className = localClass.toString();                  // Name of the class eg "my.pack.MyType"
        var meta = localClass.get().meta;                       // Metadata of the this class
        
        var templateFile:String;                                // If we are loading template from a file, this is the filename
        var template:String = "";                               // If the template is directly in metadata, use that.
        
        //
        // IF TEMPLATE IS DECLARED IN METADATA
        //
        if (meta.has("template"))
        {
            for (metadataItem in meta.get())
            {
                if (metadataItem.name == "template")
                {
                    if (metadataItem.params.length == 0) Context.error("Metadata template() exists, but was empty.", p);
                    for (templateMetadata in metadataItem.params)
                    {
                        switch( templateMetadata.expr ) 
                        {
                            case EConst(c):
                                switch(c) 
                                {
                                    case CString(str): 
                                        template = str;
                                    default: 
                                        Context.error("Metadata for template() existed, but was not a constant String.", p);
                                }
                            default: 
                                Context.error("Metadata for template() existed, but was not a constant value.", p);
                        } 
                    }
                }
            }
        }
        else 
        {
            // 
            // IF TEMPLATE FILE IS DECLARED IN METADATA
            //
            if (meta.has("loadTemplate")) 
            {
                for (metadataItem in meta.get())
                {
                    if (metadataItem.name == "loadTemplate")
                    {
                        if (metadataItem.params.length == 0) Context.error("Metadata loadTemplate() exists, but was empty.", p);

                        for (templateMetadata in metadataItem.params)
                        {
                            switch( templateMetadata.expr ) 
                            {
                                case EConst(c):
                                    switch(c) 
                                    {
                                        case CString(str): 
                                            templateFile = str;
                                        default: 
                                            Context.error("Metadata for loadTemplate() existed, but was not a constant String.", p);
                                    }
                                default: 
                                    Context.error("Metadata for loadTemplate() existed, but was not a constant value.", p);
                            } 
                        }
                    }
                }
            }
            //
            // IF NO TEMPLATE OR FILE IS DECLARED IN METADATA
            //
            else 
            {
                // If there is no metadata for the template, look for a file in the same 
                // spot but with ".tpl" instead of ".hx" at the end.
                templateFile = className.replace(".", "/") + ".html";
            }

            //
            // Attempt to load the file
            //
            try 
            {
                // Try to read the specified file
                template = neko.io.File.getContent(Context.resolvePath(templateFile));
            } 
            catch( e : Dynamic ) 
            {
                // If it fails, give an error message at compile time
                var errorMessage = "Could not load the widget template: " + templateFile;
                errorMessage += "\n  Using empty <div></div> template for now.";
                Context.warning(errorMessage, p);
                template = null;
            }
        }

        //
        // SANE FALLBACK IN CASE SOMETHING BROKE
        //
        if (template == null) template = "<div></div>";

        
        // If we wanted to manipulate fields, this is where to do it!
        var fields = haxe.macro.Context.getBuildFields();

        // add a new public class field named "hello" with type "Int"
        //var tint = TPath({ pack : [], name : "Int", params : [], sub : null });
        var position = haxe.macro.Context.currentPos();
        fields.push({ 
            name : "get_template", 
            doc : null, 
            meta : [], 
            access : [AOverride], 
            kind : FFun({ 
                args: [], 
                expr: { 
                    expr: EBlock(
                        [
                        { 
                            expr: EReturn(
                                { 
                                    expr: EConst(
                                        CString(template)
                                    ), 
                                    pos: position
                                }
                            ), 
                            pos: position
                        }
                        ]
                    ), 
                    pos: position
                }, 
                params: [], 
                ret: null 
            }), 
            pos: position
        });

            

        return fields; 
    }

    /**
    * Load a file at compile time to use as a template.  Filename should be relative to the classpath.
    */
    @:macro public static function loadTemplate( ?fileName : Expr ):Expr
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

        return macro "$f";
    }
}