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

package dtx.widget;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Format;
import haxe.macro.Printer;
import haxe.macro.Type;
using tink.MacroApi;
using StringTools;
using Lambda;
using Detox;

#if macro 
class BuildTools 
{
	static var fieldsForClass:Map<String, Array<Field>> = new Map();

    /** Return the pos of the class that this build macro is operating on **/
    public static function currentPos():Position return Context.getLocalClass().get().pos;

	/** Allow us to get a list of fields, but will keep a local copy, in case we make changes.  This way 
	in an autobuild macro you can use BuildTools.getFields() over and over, and modify the array each time,
	and finally use it as the return value of the build macro.  */
	public static function getFields():Array<Field>
	{
        var className = haxe.macro.Context.getLocalClass().toString();
        if (fieldsForClass.exists(className) == false)
        {
        	fieldsForClass.set(className, Context.getBuildFields());
        }
        return fieldsForClass.get(className);
	}

    /** See if a field with the given name exists */
    public static function fieldExists(name:String)
    {
        return getFields().exists(function (f) { return f.name == name; });
    }

    /** Return a field, assuming it already exists */
    public static function getField(name:String)
    {
        return getFields().filter(function (f) { return f.name == name; })[0];
    }

    /** Get the fully qualified name for a type, or null if not found */
    public static function getFullTypeName(t:haxe.macro.Type):Null<String>
    {
        switch (t) {
            case TMono(ref):
                return ref.toString();
            case TEnum(ref,_):
                return ref.toString();
            case TInst(ref,_):
                return ref.toString();
            case TType(ref,_):
                return ref.toString();
            case TAnonymous(ref):
                return ref.toString();
            case TAbstract(ref,_):
                return ref.toString();
            case _:
                return null;
        }
    }

    /** Print a single specific field */
    public static function printField( f:Field )
    {
        return printFields( [f] );
    }

    /** Print the source code for the given fields (or for all fields in the current build) */
    public static function printFields( ?fields:Array<Field> )
    {
        var className = getFullTypeName( Context.getLocalType() );
        if ( fields==null ) fields = getFields();

        Sys.println("----------------------------------");
        Sys.println('Fields in $className: ');

        for ( f in fields ) {
            var typeSource = new Printer( "  " ).printField( f );
            typeSource = typeSource.split("\n").map(function(s) return '  $s').join("\n");
            Sys.println( '$typeSource' );
            Sys.println( '' );
        }

        Sys.println("----------------------------------");
    }

    /** Return a setter from a field.  

    If it is a FProp, it returns the existing setter, or creates one if it did not have a setter already.

    If it is a FVar, it will transform it into FProp(default,set) to create the setter and return it.

    If it is a FFun
    */
    public static function getSetter(field:Field)
    {
        switch (field.kind)
        {
            case FieldType.FProp(_, _, t, _) | FieldType.FVar(t,_): 
                return getOrCreateProperty(field.name, t, false, true).setter;
            case FieldType.FFun(_): 
                throw "Was expecting " + field.name + " to be a var or property, but it was a function.";
                return null;
        }
    }

    public static function hasClassMetadata(dataName:String, recursive=false, ?cl:Ref<ClassType>):Bool 
    {
        var p = currentPos();                           // Position where the original Widget class is declared
        var localClass = (cl == null) ? haxe.macro.Context.getLocalClass() : cl;    // Class that is being declared, or class that is passed in
        var meta = localClass.get().meta;                       // Metadata of the this class
        
        if (meta.has(dataName)) 
            return true;
        else if (recursive)
        {
            // Check if there is a super class, and check recursively for metadata
            if (localClass.get().superClass != null)
            {
                var superClass = localClass.get().superClass.t;
                if (hasClassMetadata(dataName, true, superClass)) return true;
            }
        }
        return false;
    }

    /** Searches the metadata for the current class - expects to find a single string @dataName("my string"), returns null in none found.  Generates an error if one was found but it was the wrong type. Can search recursively up the super-classes if 'recursive' is true */
    public static function getClassMetadata_String(dataName:String, recursive=false, ?cl:Ref<ClassType>):String
    {
        var array = getClassMetadata_ArrayOfStrings(dataName, recursive, cl);
        return (array != null && array.length > 0) ? array[0] : null;
    }
    
    /** Searches the metadata for the current class - expects to find one or more strings @dataName("my string", "2nd string"), returns empty array in none found.  Generates an error if one was found but it was the wrong type. Can search recursively up the super-classes if 'recursive' is true */
    public static function getClassMetadata_ArrayOfStrings(dataName:String, recursive=false, ?cl:Ref<ClassType>):Array<String>
    {
        var p = currentPos();                           // Position where the original Widget class is declared
        var localClass = (cl == null) ? haxe.macro.Context.getLocalClass() : cl;    // Class that is being declared, or class that is passed in
        var meta = localClass.get().meta;                       // Metadata of the this class
        var result = [];
        if (meta.has(dataName))
        {
            for (metadataItem in meta.get())
            {
                if (metadataItem.name == dataName)
                {
                    if (metadataItem.params.length == 0) Context.error("Metadata " + dataName + "() exists, but was empty.", p);
                    for (targetMetaData in metadataItem.params)
                    {
                        switch( targetMetaData.expr ) 
                        {
                            case EConst(c):
                                switch(c) 
                                {
                                    case CString(str): 
                                        result.push(str);
                                    default: 
                                        Context.error("Metadata for " + dataName + "() existed, but was not a constant String.", p);
                                }
                            default: 
                                Context.error("Metadata for " + dataName + "() existed, but was not a constant String.", p);
                        } 
                    }
                }
            }
        }
        else if (recursive)
        {
            // Check if there is a super class, and check recursively for metadata
            if (localClass.get().superClass != null)
            {
                var superClass = localClass.get().superClass.t;
                result = getClassMetadata_ArrayOfStrings(dataName, true, superClass);
            }
        }
        return result;
    }

	/** Takes a field declaration, and if it doesn't exist, adds it.  If it does exist, it returns the 
	existing one. */
    public static function getOrCreateField(fieldToAdd:Field)
    {
        var p = currentPos();                           // Position where the original Widget class is declared
        var localClass = haxe.macro.Context.getLocalClass();    // Class that is being declared
        var fields = getFields();

        if (fieldExists(fieldToAdd.name))
        {
            // If it does exist, get it
            return getField(fieldToAdd.name);
        }
        else
        {
            // If it doesn't exist, create it
            fields.push(fieldToAdd);
            return fieldToAdd;
        }
    }

    /** Gets an existing (or creates a new) property on the class, with the given name and type.  Optionally can set a setter or 
    a getter.  

    If the property already exists and was explicitly typed, it will not be changed. 

    If the property already exists and is a FVar, it will be transformed into a FProp

    If the property already exists and is a FProp, the existing setter and getter will be used.

    Returns a simple object containing the fields for the property, the setter and the getter.  */
    public static function getOrCreateProperty(propertyName:String, propertyType:ComplexType, useGetter:Bool, useSetter:Bool):{ property:Field, getter:Field, setter:Field }
    {
        var p = currentPos();                           // Position where the original Widget class is declared
        
        var getterString = (useGetter) ? "get_" + propertyName : "default";
        var setterString = (useSetter) ? "set_" + propertyName : "default";
        var variableRef = propertyName.resolve();

        // Set up the property
        var property = getOrCreateField({
            pos: p,
            name: propertyName,
            meta: [],
            kind: FieldType.FProp(getterString, setterString, propertyType),
            doc: "Field referencing the " + propertyName + " partial in this widget.",
            access: [APublic]
        });

        switch (property.kind)
        {
            case FieldType.FProp(get, set, t, _):
                // Read the getter / setter string, in case it already exists and was different
                getterString = get;
                setterString = set;
                propertyType = t;
            case FieldType.FVar(type,expr):
                // This was originally a function or a var, change it to a property
                // For now we will respect the type found in the class, not the one asked for by this function
                // If there's demand I might change my mind on this...
                property.kind = FieldType.FProp(getterString, setterString, type, expr);
                propertyType = type;
            case FieldType.FFun(_):
                var className = Context.getLocalClass().toString();
                var msg = "Trying to create a property called " + propertyName + " on class " + className + " but a function with the same name already exists.";
                Context.error(msg, currentPos());
        }

        // Set up the getter
        var getter = null;
        if (useGetter)
        {
            var getterBody = macro {
                // Just return the current value... If they want to add lines to this function later then they can.
                return $variableRef; 
            };
            getter = getOrCreateField({
                pos: p,
                name: getterString,
                meta: [],
                kind: FieldType.FFun({
                        ret: propertyType,
                        params: [],
                        expr: getterBody,
                        args: []
                    }),
                doc: "",
                access: []
            });
        }

        // set up the setter
        var setter = null;
        if (useSetter)
        {
            var setterBody = macro {
                $variableRef = v; 
                return v; 
            };
            setter = getOrCreateField({
                pos: p,
                name: setterString,
                meta: [],
                kind: FieldType.FFun({
                        ret: propertyType,
                        params: [],
                        expr: setterBody,
                        args: [{
                            value: null,
                            type: propertyType,
                            opt: false,
                            name: "v"
                        }]
                    }),
                doc: "",
                access: []
            });
        }

        return {
            property: property,
            getter: getter,
            setter: setter
        }
    }

    /** Add some lines of code to the function body.  It takes a field (that is a function) as
    the first argument, and an expression as the second.  For now, Haxe expects a block to be passed, and then it will
    go over each line in the block and add them to the function.  Finally you can choose where to add the lines in the
    function body.  To add them at the start, use `0`, at the end, `-1` (default) or to place them somewhere in the
    middle, use an index - 0 being before the 1st expression, 1 being before the 2nd expression etc.

    Sample usage:
    var myFn = BuildTools.getOrCreateField(...);
    var linesToAdd = macro {
		for (i in 0...10)
		{
			trace (i);
		}
    };
    BuildTools.addLinesToFunction(myFn, linesToAdd);
    */
    public static function addLinesToFunction(field:Field, lines:Expr, ?whereToAdd = -1)
    {
        // Get the function from the field, or throw an error
        var fn = null;
        switch( field.kind )
        {
            case FFun(f):
                fn = f;
            default: 
                Context.error("addLinesToFunction was sent a field that is not a function.", currentPos());
        }

        // Get the "block" of the function body
        var body = null;
        switch ( fn.expr.expr )
        {
            case EBlock(b):
                body = b;
            default:
                Context.error("addLinesToFunction was expecting an EBlock as the function body, but got something else.", currentPos());
        }
        
        addLinesToBlock(body, lines, whereToAdd);
    }

    /** Same as addLinesToFunction, but works on an arbitrary EBlock array.  */
    public static function addLinesToBlock(block:Array<Expr>, lines:Expr, ?whereToAdd = -1)
    {
        // Get an array of the lines we want to add...
        var linesArray:Array<Expr> = [];
        switch ( lines.expr )
        {
            case EBlock(b):
                // If it's a block, use each statement in the block
                for (line in b)
                {
                    linesArray.push(line);
                }
            default:
                // Otherwise, include it as a single item
                linesArray.push(lines);
        }

        // Add the lines, put them at the end by default
        if (whereToAdd == -1) whereToAdd = block.length;
    	linesArray.reverse();
        for (line in linesArray)
        {
        	block.insert(whereToAdd, line);
        }
    }

    /** Extract all the idents in an expression */
    public static function extractIdents(expr:Expr):Array<String>
    {
        var parts = [];
        var getIdent:Expr->Void = null;
        getIdent = function (e) { 
            switch(e.expr) { 
                case EConst(CIdent(s)): 
                    // If first letter is capital, it's a Type. If not, it's an ident. Only add idents
                    if ( s.charAt(0) != s.charAt(0).toUpperCase() ) 
                        if ( s!="null" && s!="true" && s!="false" ) 
                            parts.push(s);
                case _: 
                    e.iter(getIdent); 
            }
        }
        getIdent(expr);
        return parts;
    }

    /** 
        Given a list of idents, generate a `(ident1!=null && ident2!=null)` type expression.  
        If there are no idents, it will return `true` as an expression so you can still safely use it.
    **/
    public static function generateNullCheckForIdents( idents:Array<String> ) {
        if ( idents.length>0 ) {
            var nullChecks = [ for (name in idents) macro $i{name}!=null ];
            var nothingNull = nullChecks.shift();
            while ( nullChecks.length>0 ) {
                var nextCheck = nullChecks.shift();
                nothingNull = macro $nothingNull && $nextCheck;
            }
            return nothingNull;
        }
        else return macro true;
    }

    /** Takes a bunch of Binop functions `x + " the " + y + 10` and returns an array of each part. */
    public static function getAllPartsOfBinOp(binop:Expr):Array<Expr>
    {
        var parts:Array<Expr> = [];

        // Try get the binop out of this expression
        switch (binop.getBinop())
        {
            case Success(data):

                // Add part 2
                parts.unshift(data.e2);

                // Add part 1, recursively checking for more Binops
                switch (data.e1.expr)
                {
                    case EBinop(_,_,_):
                        // It's another Binop, get all the parts and add them each...
                        for (p in getAllPartsOfBinOp(data.e1))
                        {
                            parts.unshift(p);
                        }
                    default:
                        // Just add this expression to our array
                        parts.unshift(data.e1);
                }

            case Failure(failure):
                throw failure;
        }
        return parts;
    }

    /** Reads a file, relative either to the project class paths, or relative to a specific class.  It will try an absolute path 
    first (testing against each of the class paths), and then a relative path, testing against each of the class paths in the directory
    specified by "currentPath".  If currentPath is not given, it will be set to Context.getLocalClass(); */
    public static function loadFileFromLocalContext(filename:String, ?currentPath:String):String
    {
        if (currentPath == null) currentPath = Context.getLocalClass().toString();
        var fileContents = null;
        try 
        {
            fileContents = sys.io.File.getContent(Context.resolvePath(filename));
        }
        catch (e:Dynamic)
        {
            try 
            {
                // That was searching by fully qualified classpath, but try just the same folder....
                currentPath;                        // eg. my.pack.Widget
                var arr = currentPath.split(".");   // eg. [my,pack,Widget]
                arr.pop();                          // eg. [my,pack]
                var path = arr.join("/");           // eg. my/pack

                path = (path.length > 0) ? path + "/" : "./"; // add a trailing slash, unless we're on the current directory
                fileContents = sys.io.File.getContent(Context.resolvePath(path + filename));
            }
            catch (e : Dynamic)
            {
                fileContents = null;
            }
        }
        return fileContents;
    }

    /**

    **/
    public static function getFieldsFromAnonymousCT(ct:ComplexType):Array<Field> {
        switch (ct) {
            case TAnonymous(fields): 
                return fields;
            case _:
                throw 'Was Expecting TAnonymous, but got something else: $ct';
                return null;
        }
    }

    /** 
    * Generate a function call
    * Only tested with functions that are part of the same class so far... 
    */
    public static function writeSimpleFunctionCall(fn:Field, arguments:Array<Expr>)
    {

    }
}

enum ExtractedVarType
{
    Ident(name:String);
    Field(name:String);
    Call(name:String);
}
#end