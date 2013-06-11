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
import tink.macro.tools.MacroTools;
using tink.macro.tools.MacroTools;
using StringTools;
using Lambda;
using Detox;

#if macro 
class BuildTools 
{
	static var fieldsForClass:Map<String, Array<Field>> = new Map();

	/** Allow us to get a list of fields, but will keep a local copy, in case we make changes.  This way 
	in an autobuild macro you can use BuildTools.getFields() over and over, and modify the array each time,
	and finally use it as the return value of the build macro.  */
	public static function getFields():Array<Field>
	{
        var className = haxe.macro.Context.getLocalClass().toString();
        if (fieldsForClass.exists(className) == false)
        {
        	fieldsForClass.set(className, haxe.macro.Context.getBuildFields());
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

    /** Return a setter from a field.  

    If it is a FProp, it returns the existing setter, or creates one if it did not have a setter already.

    If it is a FVar, it will transform it into FProp(default,set) to create the setter and return it.

    If it is a FFun
    */
    public static function getSetterFromField(field:Field)
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
        var p = Context.currentPos();                           // Position where the original Widget class is declared
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
        var p = Context.currentPos();                           // Position where the original Widget class is declared
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
        var p = Context.currentPos();                           // Position where the original Widget class is declared
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
        var p = Context.currentPos();                           // Position where the original Widget class is declared
        
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
                Context.error(msg, Context.currentPos());
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
                Context.error("addLinesToFunction was sent a field that is not a function.", Context.currentPos());
        }

        // Get the "block" of the function body
        var body = null;
        switch ( fn.expr.expr )
        {
            case EBlock(b):
                body = b;
            default:
                Context.error("addLinesToFunction was expecting an EBlock as the function body, but got something else.", Context.currentPos());
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

    /** Takes the output of an expression such as Std.format(), and searches for variables used... 
    Basic implementation so far, only looks for basic EConst(CIdent(myvar)) */
    public static function extractVariablesUsedInInterpolation(expr:Expr)  
    {
        var variablesInside:Array<ExtractedVarType> = [];
        switch(expr.expr)
        {
            case ECheckType(e,_):
                switch (e.expr)
                {
                    case EBinop(_,_,_):
                        var parts = getAllPartsOfBinOp(e);
                        for (part in parts)
                        {
                            switch (part.expr)
                            {
                                case EConst(CIdent(varName)):
                                    variablesInside.push( ExtractedVarType.Ident(varName) );
                                case EField(e, field):
                                    // Get the left-most field, add it to the array
                                    var leftMostVarName = getLeftMostVariable(part);
                                    if (leftMostVarName != null) {
                                        if ( fieldExists(leftMostVarName) )
                                            variablesInside.push( ExtractedVarType.Field(leftMostVarName) );
                                        else {
                                            var localClass = Context.getLocalClass();
                                            var printer = new Printer("  ");
                                            var partString = printer.printExpr(part);
                                            Context.error('In the Detox template for $localClass, in the expression `$partString`, variable "$leftMostVarName" could not be found.  Variables used in complex expressions inside the template must be explicitly declared.', localClass.get().pos);
                                        }
                                    }
                                case ECall(e, params):
                                    // Look for variables to add in the paramaters
                                    for (param in params) {
                                        var varName = getLeftMostVariable(param);
                                        if (varName != null) {
                                            if ( fieldExists(varName) )
                                                variablesInside.push( ExtractedVarType.Call(varName) );
                                            else {
                                                var localClass = Context.getLocalClass();
                                                var printer = new Printer("  ");
                                                var callString = printer.printExpr(part);
                                                Context.error('In the Detox template for $localClass, in function call `$callString`, variable "$varName" could not be found.  Variables used in complex expressions inside the template must be explicitly declared.', localClass.get().pos);
                                            }
                                        }
                                    }
                                    // See if the function itself is on a variable we need to add
                                    var leftMostVarName = getLeftMostVariable(e);
                                    if ( fieldExists(leftMostVarName) ) {
                                        switch ( getField(leftMostVarName).kind ) {
                                            case FVar(_,_) | FProp(_,_,_,_):
                                                variablesInside.push( ExtractedVarType.Field(leftMostVarName) );
                                            case _:
                                        }
                                    }
                                    // else: don't throw error.  They might be doing "haxe.crypto.Sha1.encode()" or "Math.max(a,b)" etc. If they do something invalid the compiler will catch it, the error message just won't be as obvious
                                default:
                                    // do nothing
                            }
                        }
                    default:
                        haxe.macro.Context.error("extractVariablesUsedInInterpolation() only works when the expression inside ECheckType is EBinOp, as with the output of Format.format()", Context.currentPos());
                }
            default:
                haxe.macro.Context.error("extractVariablesUsedInInterpolation() only works on ECheckType, the output of Format.format()", Context.currentPos());
        }

        return variablesInside;
    }

    /** Takes an expression and tries to find the left-most plain variable.  For example "student" in `student.name`, "age" in `person.age`, "name" in `name.length`.
    
    It will try to ignore "this", for example it will match "person" in `this.person.age`.

    Note it will also match packages: "haxe" in "haxe.crypto.Sha1.encode"
    */
    public static function getLeftMostVariable(expr:Expr):Null<String>
    {
        var leftMostVarName = null;
        var error = false;

        switch (expr.expr)
        {
            case EConst(CIdent(varName)):
                leftMostVarName = varName;
            case EField(e, field):
                // Recurse until we find it.
                var currentExpr = e;
                var currentName:String;
                while ( leftMostVarName==null ) {
                    switch ( currentExpr.expr ) {
                        case EConst(CIdent(varName)): 
                            if (varName == "this") 
                                leftMostVarName = currentName;
                            else 
                                leftMostVarName = varName;
                        case EField(e, field): 
                            currentName = field;
                            currentExpr = e;
                        case _: 
                            error = true;
                            break;
                    }
                }
            case EConst(_): // A constant.  Leave it null
            case _: error = true;
        }
        if (error)
        {
            var localClass = Context.getLocalClass();
            var printer = new Printer("  ");
            var exprString = printer.printExpr( expr );
            Context.error('In the Detox template for $localClass, the expression `$exprString`, was too complicated for the poor Detox macro to understand.', localClass.get().pos);
        }

        return leftMostVarName;
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