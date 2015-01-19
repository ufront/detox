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

import haxe.io.Path;
import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Format;
import haxe.macro.Printer;
import haxe.macro.Type;
import sys.io.File;
import sys.FileSystem;
using haxe.macro.ExprTools;
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
    and finally use it as the return value of the build macro.

    We also apply the `makeComplexTypeAbsolute` transformation to any ComplexTypes in the field signiature.
    This makes it easier to reference the ComplexType from outside (for example, in a new TypeDefinition) and not have it break because the new definition doesn't share the same local imports.
    */
    public static function getFields():Array<Field> {
        var className = haxe.macro.Context.getLocalClass().toString();
        if (fieldsForClass.exists(className) == false)
        {
            var fields = [];
            for ( field in Context.getBuildFields() ) {
                var kind:FieldType = switch field.kind {
                    case FVar(ct,e): FVar(makeComplexTypeAbsolute(ct),e);
                    case FProp(get,set,ct,e): FProp(get,set,makeComplexTypeAbsolute(ct),e);
                    case FFun(f): FFun({
                        ret: makeComplexTypeAbsolute(f.ret),
                        params: f.params,
                        expr: f.expr,
                        args: [
                            for (arg in f.args) {
                                value: arg.value,
                                type: makeComplexTypeAbsolute(arg.type),
                                opt: arg.opt,
                                name: arg.name
                            }
                        ],
                    });
                }
                field.kind = kind;
                fields.push( field );
            }
            fieldsForClass.set(className, fields);
        }
        return fieldsForClass.get(className);
    }

    /**
        Attempt to transform a ComplexType to use an absolute TypePath, so local imports are included in the CT.
        This works by transforming the ComplexType into a Type, and then converting it back again.
        If the operation fails, the original ComplexType is returned.
    **/
    public static function makeComplexTypeAbsolute( ct:ComplexType ):ComplexType
    {
        if (ct==null) return null;
        switch ct.toType() {
            case Success(type): return type.toComplex();
            case Failure(err): return ct;
        }
    }

    /**
        While a class is being built, it's ClassType has an empty fields array.
        This returns an Iterable (read-only) on any fields which may (or may not be) cached from calling `BuildTools.getFields()`.
        This allows you to retrieve a copy of the fields that are half way through building.
    **/
    public static function getFieldsForClass( className:String ):Iterable<Field> {
        return fieldsForClass.exists(className) ? fieldsForClass.get(className) : [];
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

    /** Return a field, assuming it already exists */
    public static function getFieldFromSuperClass(name:String):Option<ClassField>
    {
        var superClass = Context.getLocalClass().get().superClass;
        while ( superClass!=null ) {
            var cls = superClass.t.get();
            for ( f in cls.fields.get() ) {
                if ( f.name==name ) return Some( f );
            }
            superClass = cls.superClass;
        }
        return None;
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

    If it is a FFun it will return null.
    */
    public static function getSetter(field:Field)
    {
        switch (field.kind)
        {
            case FieldType.FProp(_, _, t, _) | FieldType.FVar(t,_):
                return getOrCreateProperty(field.name, t, false, true).setter;
            case FieldType.FFun(_):
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

    /** Takes a field declaration, and if it doesn't exist, adds it.  If it does exist, it returns the existing one. */
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
                if (get != "get") getterString = get;
                if (set != "set") setterString = set;
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
        var exprs = [ for (i in idents) i.resolve() ];
        var checks = [];
        addNullCheckForMultipleExprs( exprs, checks );
        return
            if ( checks.length==0 ) macro true;
            else combineExpressionsWithANDBinop( checks );
    }

    /**
        Check if the current compilation target is one of our static platforms: cpp, flash, java or cs.
    **/
    public static function isStaticPlatform():Bool {
        return Context.defined("cpp") || Context.defined("flash") || Context.defined("java") || Context.defined("cs");
    }

    /**
        Convert an expression into an ECheckType which casts it to Null<T>.

        On static platforms basic types (Int,Float,Bool) cannot be compared to null.
        This method wraps expressions in an ECheckType which casts them from `T` to `Null<T>`, so we can perform a comparison.

        On dynamic platforms this has no effect as every value is nullable.

        It would be better to avoid adding the null check for these types.
        If someone can think of an implementation that would work here, please let me know!
    **/
    public static function nullableCast<T>(expr:ExprOf<T>):ExprOf<Null<T>> {
        if ( isStaticPlatform() ) {
            expr = macro ($expr:Null<Dynamic>);
        }
        return expr;
    }

    /**
        Given an expression, null check all idents / field access.

        For example, the expression `result.name.first` will generate `result!=null && result.name!=null && result.name.first!=null`
    **/
    public static function generateNullCheckForExpression( expr:Expr ):ExprOf<Bool> {


        var checks:Array<ExprOf<Bool>> = [];
        addNullCheckForExpr( expr, checks );

        // We have to be careful with the order, when checking "some.field.access", we want to generate `some!=null && some.field!=null && some.field.access!=null )`.
        // This will prevent invalid field access if "some.field" is null but we accidentally checked "some.field.access" first.
        // When we add field accesses, we added them in deepest->shallowest order, so here, we should reverse that order before combining them.
        checks.reverse();

        return
            if ( checks.length==0 ) macro true;
            else combineExpressionsWithANDBinop( checks );
    }

    /**
        For an array of expressions, create null checks for each part of each expression.
    **/
    static function addNullCheckForMultipleExprs( exprs:Array<Expr>, allChecks:Array<Expr> ):Void {
        for ( e in exprs ) {
            addNullCheckForExpr( e, allChecks );
        }
    }

    /**
        For an expression, create null checks for each part of the expression recursively.
    **/
    static function addNullCheckForExpr( expr:Expr, allChecks:Array<Expr> ):Void {
        switch expr.expr {
            case EConst(CIdent(name)):
                if (name!="null" && name!="false" && name!="true") {
                    var nullableExpr = nullableCast(expr);
                    allChecks.push( macro $nullableExpr!=null );
                }
            case EConst(_):
                // Don't need to add any checks.
            case EField(e,field):
                var nullableExpr = nullableCast(expr);
                allChecks.push( macro $nullableExpr!=null );
                addNullCheckForExpr( e, allChecks );
            case ECheckType(e,type):
                addNullCheckForExpr( e, allChecks );
            case EBinop(_,expr1,expr2):
                addNullCheckForExpr( expr1, allChecks );
                addNullCheckForExpr( expr2, allChecks );
            case EUnop(_,_,e):
                addNullCheckForExpr( e, allChecks );
            case ECall({ expr: EField(objExpr,fnName), pos: _ },params):
                addNullCheckForExpr( objExpr, allChecks );
                addNullCheckForMultipleExprs( params, allChecks );
            case ECall({ expr: EConst(CIdent(name)), pos: _ }, params):
                allChecks.push( macro $i{name}!=null );
                addNullCheckForMultipleExprs( params, allChecks );
            case EArrayDecl( exprs ):
                addNullCheckForMultipleExprs( exprs, allChecks );
            case EObjectDecl( fields ):
                var exprs = [ for (f in fields) f.expr ];
                addNullCheckForMultipleExprs( exprs, allChecks );
            case EArray( arr, index ):
                addNullCheckForExpr( arr, allChecks );
                addNullCheckForExpr( index, allChecks );
            case ETernary( cond, ifExpr, elseExpr ):
                // Often this is used for an (a!=null ? a : "fallback"), so null checking really isn't practical here
            case unsupportedType:
                var typeName = std.Type.enumConstructor( unsupportedType );
                Context.fatalError( 'Unable to generate null check for `${expr.toString()}`, field access from "$typeName" is currently not supported.', Context.getLocalClass().get().pos );
        }
    }

    /**
        Combine many expressions with the `&&` binop.

        Example: [expr1,expr2,expr3] becomes `expr1 && expr2 && expr3`.

        This will filter any duplicate expressions so they are only included once.
    **/
    static function combineExpressionsWithANDBinop( exprs:Array<Expr> ):ExprOf<Bool> {
        var completeCheck:ExprOf<Bool> = null;

        var filteredExprs:Array<ExprOf<Bool>> = [];
        var filteredExprStrings:Array<String> = [];

        for ( e1 in exprs ) {
            var e1Str = e1.toString();
            var alreadyExisted = false;
            if ( filteredExprStrings.indexOf(e1Str)==-1 ) {
                filteredExprs.push( e1 );
                filteredExprStrings.push( e1Str );
            }
        }

        while ( filteredExprs.length>0 ) {
            var check = filteredExprs.shift();
            completeCheck = (completeCheck==null) ? check : macro $completeCheck && $check;
        }
        return completeCheck;
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

    /**
        Fake the local variable context for a class.
        This is useful when use in combination with `tink.MacroApi.typeOf()` which tries to infer the type of an expression and allows you to mock the context.
        Please note methods from super classes are not included, only variables and properties.
    **/
    public static function fakeVariablesContextForLocalClass():Array<{ name:String, type:ComplexType, expr:Expr }>
    {
        var variablesInContext = [];
        for ( field in BuildTools.getFields() ) {
            switch (field.kind) {
                case FVar(ct,_), FProp(_,_,ct,_):
                    variablesInContext.push({ name: field.name, type: ct, expr: null });
                case _:
            }
        }
        // Also fetch member variables from super classes, up until (but not including) the Widget class...
        /*This code using tink_macros feels much shorter than what we used below, but doesn't substitute type parameters...
        for ( field in Context.getLocalType().getFields().sure() ) {
            if ( variablesInContext.exists(function(obj) return obj.name==field.name)==false ) {
                var ct = field.type.toComplex();
                variablesInContext.push({ name: field.name, type: ct, expr: null });
            }
        }*/
        var cls = Context.getLocalClass().get();
        var clsName = Context.getLocalClass().toString();
        var typeParamSubstitutions:Array<Type> = [];
        while (cls!=null) {
            function subtituteParam( type:Type ):Type {
                for (i in 0...typeParamSubstitutions.length) {
                    if ( Context.unify(cls.params[i].t,type) ) {
                        return typeParamSubstitutions[i];
                    }
                }
                // TODO: Do we need to recurse here, for example into Array<T> or Void<T>?
                return type;
            }
            for ( field in cls.fields.get() ) {
                if ( field.kind.match(FMethod(_)) )
                    continue;
                var fieldType = subtituteParam( field.type );
                // We need to check if the type of this variable is currently being built, and mock the fields if so.
                fieldType = mockTypeIfItIsMidBuild( fieldType );
                var fieldCT = Context.toComplexType( fieldType );
                // Only add fields that weren't already in our context from a child class.
                if ( variablesInContext.filter(function(v) return v.name==field.name).length==0 )
                    variablesInContext.push({ name: field.name, type: fieldCT, expr:null });
            }
            if ( cls.superClass!=null && cls.superClass.t.toString()!="dtx.widget.Widget" ) {
                typeParamSubstitutions = cls.superClass.params;
                clsName = cls.superClass.t.toString();
                cls = cls.superClass.t.get();
            }
            else cls = null;
        }
        return variablesInContext;
    }

    /**
        Substitute a type that is being built (and has no fields) for an object with similar looking fields.
        While a type is being built, it's fields are inaccessible so if you try to force typing you will get `Type X has no field Y` errors.
        This is a workaround.
        This will only work if the class being built has called getFields() at some point.
        Only works for classes (TInst) at the moment.
        If no substitute is needed (the type had fields already, or no fields were found cached) then the original type is returned unchanged.
    **/
    public static function mockTypeIfItIsMidBuild( type:Type ):Type {
        switch type {
            case TInst( ref, params ):
                var classType = ref.get();
                if ( classType.fields.get().length==0 ) {
                    var buildFields = getFieldsForClass(ref.toString());
                    if ( Lambda.count(buildFields)>0 ) {
                        var newName = classType.name+"__BuildMock";
                        var fields = [];
                        for ( origField in buildFields ) {
                            if ( origField.name=="new" || origField.access.has(AStatic) || origField.access.has(APrivate) || origField.access.has(AMacro) )
                                continue;

                            // When we copy these fields, we used buildFields, so they should have signiatures with absolute type paths already.
                            // However, any expressions in those fields might not, so let's create a copy of the field with no expressions.
                            var newKind:FieldType = switch origField.kind {
                                case FVar(t,_), FProp(_,_,t,_):
                                    FVar(t,null);
                                case FFun(f):
                                    FFun({
                                        ret: f.ret,
                                        params: f.params,
                                        expr: null,
                                        args: f.args
                                    });
                            }
                            var newField = {
                                pos: origField.pos,
                                name: origField.name,
                                meta: origField.meta,
                                kind: newKind,
                                doc: origField.doc,
                                access: [APublic],
                            }
                            fields.push( newField );
                        }
                        Context.defineType({
                            pos: classType.pos,
                            params: [],
                            pack: classType.pack,
                            name: newName,
                            meta: [],
                            kind: TDStructure,
                            isExtern: true,
                            fields: fields
                        });
                        return Context.getType( newName );
                    }
                }
            default:
        }
        return type;
    }

    /**
        If the given type is a type parameter on a super class, replace it with the chosen parameter from the child class.
    **/
    public static function replaceSuperTypeParamsWithImplementation(type:Type):Type {
        var localClass = Context.getLocalClass().get();
        var superClass = localClass.superClass;
        while ( superClass!=null ) {
            var cls = superClass.t.get();
            var superClassTypeParams = cls.params;
            var subClassImplementationTypes = superClass.params;
            var i = 0;
            for ( typeParam in superClassTypeParams ) {
                if ( ""+typeParam.t == ""+type ) {
                    return subClassImplementationTypes[i];
                }
                i++;
            }
            superClass = cls.superClass;
        }
        return type;
    }

    /** Reads a file, relative either to the project class paths, or relative to a specific class.  It will try an absolute path
    first (testing against each of the class paths), and then a relative path, looking for files in the same package as the file the local class is declared in. */
    public static function loadFileFromLocalContext(filename:String):String
    {
        var fileContents:String = null;
        var path:String;
        try
        {
            path = Context.resolvePath(filename);
            fileContents = File.getContent(path);
        }
        catch (e:Dynamic)
        {
            try
            {
                var modulePath = Context.getPosInfos(Context.getLocalClass().get().pos).file;
                var moduleDir = Path.directory(modulePath);
                path = Context.resolvePath(Path.addTrailingSlash(moduleDir)+filename);
                fileContents = FileSystem.exists(path) ? File.getContent(path) : null;
            }
            catch (e : String)
            {
                if ( e.indexOf("File not found")==1 )
                    trace( e );
                path = null;
            }
        }
        // Commented out the `registerModuleDependency` as it was causing stack overflows in one project. WTF?
//        if ( path!=null )
//            Context.registerModuleDependency(Context.getLocalModule(),path);
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
