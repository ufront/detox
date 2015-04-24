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

import dtx.DOMNode;
import haxe.macro.Expr;
import haxe.macro.Format;
import haxe.macro.Type;
import haxe.macro.Printer;
import haxe.ds.StringMap;
import tink.core.Error;
using haxe.macro.Context;
using tink.MacroApi;
using StringTools;
using Lambda;
using Detox;
using dtx.widget.BuildTools;
import tink.core.Ref in TinkRef;

class WidgetTools
{
    static var templates:StringMap<String>;
    static var indent = "";

    /**
    * This macro is called on ANY subclass of detox.widget.Widget
    *
    * It's purpose is to get the template for each Widget Class
    * It looks for:
    *  - Metadata in the form: @:template("<div></div>") class MyWidget ...
    *  - Metadata in the form: @:loadTemplate("MyWidgetTemplate.html") class MyWidget ...
    *  - Take a guess at a filename... use current filename, but replace ".hx" with ".html"
    * Once it finds it, it overrides the get_template() method, and makes it return
    * the correct template as a String constant.  So each widget gets its own template
    */
    macro public static function buildWidget():Array<Field>
    {
        if (templates==null) templates = new StringMap();

        var localClass = Context.getLocalClass();    // Class that is being declared
        var widgetPos = localClass.get().pos;                   // Position where the original Widget class is declared
        var fields = BuildTools.getFields();
        var returnBuildFuilds = false;
        #if detox_widget_debug
            trace( '$indent Start: '+localClass.toString() );
        #end
        indent+="  ";

        // If get_template() already exists, don't recreate it
        var skipTemplating = BuildTools.hasClassMetadata(":skipTemplating");
        if (!skipTemplating && fields.exists(function (f) return f.name == "get_template") == false)
        {
            // Load the template
            var template = loadTemplate(localClass);

            if (template != null)
            {
                // Process the template looking for partials, variables etc
                // This function processes the template, and returns any binding statements
                // that may be needed for bindings / variables etc.

                var result = processTemplate(template);

                // Push the extra class properties that came during our processing
                for (f in result.fields)
                {
                    fields.push(f);
                }

                // Create and add the get_template() field.
                fields.push(createField_get_template(result.template, template, widgetPos));

                // Keep track of the template in case we need it later...
                templates.set( localClass.toString(), result.template );

                // If @:dtxdebug metadata is found, print the class
                if ( BuildTools.hasClassMetadata(":dtxDebug") )
                {
                    // Add a callback for this class
                    BuildTools.printFields();
                }

                returnBuildFuilds = true;
            }
        }


        indent = indent.substr( 2 );
        #if detox_widget_debug
            trace( '$indent Finish: '+localClass.toString() );
        #end

        // Leave the fields as is
        return returnBuildFuilds ? fields : null;
    }

    /**
      * Helper functions
      */

    #if macro

    static function error(msg:String, p:Position):Dynamic
    {
        #if (haxe_ver >= 3.100)
            return Context.fatalError( msg, p );
        #else
            return Context.error( msg, p );
        #end
    }

    static function loadTemplate(localClass:Null<haxe.macro.Type.Ref<haxe.macro.Type.ClassType>>):String
    {
        var p = localClass.get().pos;                           // Position where the original Widget class is declared
        var className = localClass.toString();                  // Name of the class eg "my.pack.MyType"

        var templateFile:String = "";                           // If we are loading template from a file, this is the filename
        var template:String = "";                               // If the template is directly in metadata, use that.

        // Get the template content if declared in metadata
        var template = BuildTools.getClassMetadata_String(":template", false);
        if (template == null)
        {
            // Check if we are loading a partial from in another template
            var partialInside = BuildTools.getClassMetadata_ArrayOfStrings(":partialInside", false);
            if (partialInside != null && partialInside.length > 0)
            {
                if (partialInside.length == 2)
                {
                    var templateFile = partialInside[0];
                    var partialName = partialInside[1];
                    template = loadPartialFromInTemplate(templateFile, partialName);
                }
                else error('@:partialInside() metadata should be 2 strings: @:partialInside("MyView.html", "_NameOfPartial")', p);
            }

            // Check if a template file is declared in metadata
            if (template == null)
            {
                var templateFile = BuildTools.getClassMetadata_String(":loadTemplate", true);
                if (templateFile == null)
                {
                    // If there is no metadata for the template, look for a file in the same
                    // spot but with ".html" instead of ".hx" at the end.
                    templateFile = className.replace(".", "/") + ".html";
                }

                // Attempt to load the file
                template = BuildTools.loadFileFromLocalContext(templateFile);

                // If still no template, check if @:noTemplate() was declared, if not, throw error.
                if (template == null)
                {
                    var noTemplate = BuildTools.hasClassMetadata(":noTemplate",false);
                    var parentHasTemplate = BuildTools.hasClassMetadata(":template",true);
                    var parentHasTemplateFile = BuildTools.hasClassMetadata(":templateFile",true);
                    var parentHasTemplatePartial = BuildTools.hasClassMetadata(":partialInside",true);
                    if ( false==(noTemplate||parentHasTemplate||parentHasTemplateFile||parentHasTemplatePartial) )
                    {
                        Context.warning('Could not load the widget template: $templateFile', p);
                    }

                }
            }
        }
        return template;
    }

    static function loadPartialFromInTemplate(templateFile:String, partialName:String)
    {
        var p = Context.getLocalClass().get().pos;                       // Position where the original Widget class is declared
        var partialTemplate:String = null;

        var fullTemplate = BuildTools.loadFileFromLocalContext(templateFile);
        if (fullTemplate != null)
        {
            var tpl =
                try parseXml( fullTemplate )
                catch ( e:Dynamic ) error( 'Failed to parse partial template for ${Context.getLocalClass()}: $e', p );

            var allNodes = Lambda.concat(tpl, tpl.descendants());
            var partialMatches = allNodes.filter(function (n) { return n.nodeType == Xml.Element && n.nodeName == partialName; });

            if (partialMatches.length == 1)
                partialTemplate = getInnerHtmlPreservingTagNameCase( partialMatches.first() );
            else if (partialMatches.length > 1)
                error('The partial $partialName was found more than once in the template $templateFile... confusing!', p);
            else
                error('The partial $partialName was not found in the template $templateFile', p);
        }
        else error('Could not load the file $templateFile that $partialName is supposedly in.', p);

        return partialTemplate;
    }

    static function createField_get_template(template:String, original:String, widgetPos:Position):Field
    {
        // Clear whitespace from the start and end of the widget
        var whitespaceStartOrEnd = ~/^\s+|\s+$/g;
        template = whitespaceStartOrEnd.replace(template, "");

        return {
            name : "get_template",
            doc : "__Template__:\n\n```\n" + original + "\n```",
            meta : [],
            access : [APublic,AOverride],
            kind : FFun({
                args: [],
                expr: macro { return $v{template}; },
                params: [],
                ret: null
            }),
            pos: widgetPos
        }
    }

    static function parseXml(xml:String):DOMCollection {
        var c = new DOMCollection();
        if ( xml==null )
            throw 'Unable to parse null value as Xml';
        var xml =  haxe.xml.Parser.parse(xml);
        if ( xml.isDocument() ) {
            for ( child in xml ) {
                c.add( child );
            }
        }
        else {
            c.add( xml );
        }
        return c;
    }

    static function processTemplate(template:String):{ template:String, fields:Array<Field> }
    {
        // Get every node (including descendants)
        var localClass = Context.getLocalClass();
        var p = Context.getLocalClass().get().pos;

        var xml =
            try parseXml(template)
            catch (e:Dynamic) error( 'Failed to parse template for $localClass: $e', p );

        var fieldsToAdd = new Array<Field>();

        // Process partial declarations on the top level first (and then remove them from the collection/template)
        for ( node in xml ) {
            if (node.isElement() && node.tagName().startsWith('_')) {
                // This is a partial declaration <_MyPartial>template</_MyPartial>
                processPartialDeclarations( node.nodeName, node );
                xml.removeFromCollection( node );
            }
        }

        var partialNumber:TinkRef<Int> = 0; // Used to create name if none given, eg partial_4:DOMCollection
        var loopNumber:TinkRef<Int> = 0; // Used to create name if none given, eg loop_4:Loop

        // Process the remaining template nodes
        for ( node in xml ) {
            processNode( node, partialNumber, loopNumber, Some(xml) );
        }

        return { template: xml.html(), fields: fieldsToAdd };
    }

    static function processNode( node:DOMNode, partialNumber:TinkRef<Int>, loopNumber:TinkRef<Int>, topLevel:Option<DOMCollection> ) {
        if (node.tagName() == "dtx:loop")
        {
            // It's a loop element... either:
            //    <dtx:loop><dt>$name</dt><dd>$age</dd></dtx:loop> OR
            //    <dtx:loop partial="Something" />
            loopNumber.value = loopNumber.value+1;
            processLoop(node, loopNumber);
        }
        else if (node.tagName().startsWith('dtx:'))
        {
            // This is a partial call.  <dtx:_MyPartial /> or <dtx:SomePartial /> etc
            partialNumber.value = partialNumber.value+1;
            processPartialCalls(node, partialNumber.value, topLevel);
        }
        else if ( node.isElement() || node.isDocument() )
        {
            // process attributes on elements
            if ( node.isElement() ) processAttributes(node);

            // recurse documents and elements
            for ( child in node.children(false) ) processNode( child, partialNumber, loopNumber, None );
        }
        else if (node.isCData())
        {
            if (node.text().indexOf('$') > -1)
            {
                interpolateTextNodes(node);
            }
        }
        else if (node.isTextNode())
        {
            // look for variable interpolation eg "Welcome back, $name..."
            if (node.text().indexOf('$') > -1)
            {
                interpolateTextNodes(node);
            }
            // Get rid of HTML encoding.  Haxe3 does this automatically, but we want it to remain unencoded.
            // (I think?  While it might be nice to have it do the encoding for you, it is not expected, so violates principal of least surprise.  Also, how does '&nbsp;' get entered?)
            // And it appears to only affect the top level element, not any descendants.  Weird...
            node.setText(node.text().htmlUnescape());
            clearWhitespaceFromTextnode(node);
        }
    }

    static function clearWhitespaceFromTextnode(node:dtx.DOMNode)
    {
        var text = node.text();
        if (node.prev() == null)
        {
            // if it's the first, get rid of stuff at the start
            var re = ~/^\s+/g;
            text = re.replace(text, "");
        }
        if (node.next() == null)
        {
            // if it's the last node, get rid of stuff at the end
            var re = ~/\s+$/g;
            text = re.replace(text, "");
        }

        if (text == "" || ~/^\s+$/.match(text))
            node.removeFromDOM();
        else
            node.setText(text);
    }

    static function processPartialDeclarations(name:String, node:dtx.DOMNode, ?fields:Array<Field>)
    {
        var localClass = Context.getLocalClass();
        var p = localClass.get().pos;
        var pack = localClass.get().pack;

        // Before getting the partial TPL, let's clear out any whitespace
        for (d in node.descendants(false))
        {
            if (d.isTextNode())
            {
                clearWhitespaceFromTextnode(d);
            }
        }

        var partialTpl = getInnerHtmlPreservingTagNameCase( node );

        var className = localClass.get().name + name;
        var classMeta = [{
            pos: p,
            params: [Context.makeExpr(partialTpl, p)],
            name: ":template"
        }];
        for ( meta in localClass.get().meta.get() )
            classMeta.push(meta);

        // Find out if the type has already been defined
        var existingClass:Null<haxe.macro.Type>;
        try { existingClass = Context.getType(className); }
        catch (e:Dynamic) { existingClass = null; }

        if (existingClass != null)
        {
            switch (existingClass)
            {
                case TInst(t, _):
                    var classType = t.get();
                    var metaAccess = classType.meta;
                    if (metaAccess.has(":template") == false && metaAccess.has(":loadTemplate") == false)
                    {
                        // No template has been defined, use ours
                        metaAccess.add(":template", [Context.makeExpr(partialTpl, p)], p);
                    }
                default:
            }
        }
        else
        {
            var parentClass = Context.toComplexType( Context.getLocalType() );
            var classKind = TypeDefKind.TDClass({
                sub: null,
                params: [TPType(parentClass)],
                pack: ['dtx','widget'],
                name: "ChildWidget"
            });
            if (fields==null) fields = [];

            var partialDefinition = {
                pos: p,
                params: [],
                pack: pack,
                name: className,
                meta: classMeta,
                kind: classKind,
                isExtern: false,
                fields: fields
            };
            Context.defineType(partialDefinition);
        }
    }

    @:access(dtx.single.Traversing)
    @:access(dtx.single.ElementManipulation)
    static function getInnerHtmlPreservingTagNameCase(elm:DOMNode):String
    {
        var ret="";
        if (elm != null)
        {
            switch (elm.nodeType)
            {
                case dtx.DOMType.ELEMENT_NODE:
                    var sb = new StringBuf();
                    for ( child in dtx.single.Traversing.unsafeGetChildren(elm,false) )
                    {
                        dtx.single.ElementManipulation.printHtml( child, sb, true );
                    }
                    ret = sb.toString();
                default:
                    ret = elm.textContent;

            }
        }
        return ret;
    }

    /**
        @param node The DOMNode of the partial call eg `<dtx:MyPartial name="test"></dtx:MyPartial>`
        @param t The count of the number of partials, used to generate a default name `${partial}_t`
        @param topLevel Some(collection) if this is a top level node in the widget.
        @param topLevel None if this node has a parent element.
    **/
    static function processPartialCalls(node:dtx.DOMNode, t:Int, topLevel:Option<DOMCollection>)
    {
        // Elements beginning with <dtx:SomeTypeName /> or <dtx:my.package.SomeTypeName />
        // May have attributes <dtx:Button text="Click Me" />

        // Generate a name for the partial.  Either take it from the <dtx:MyPartial dtx-name="this" /> attribute,
        // or autogenerate one (partial_$t, t++)
        var widgetClass = Context.getLocalClass();
        var nameAttr = node.attr('dtx-name');
        var name = (nameAttr != "") ? nameAttr : "partial_" + t;
        var p = widgetClass.get().pos;

        // Resolve the type for the partial.  If it begins with dtx:_, then it is local to this file.
        // Otherwise, just resolve it as a class name.
        var typeName = node.nodeName.substring(4);
        if (typeName.startsWith("_"))
        {
            // partial inside this file
            typeName = widgetClass.get().name + typeName;
        }
        // If we ever allow importing partials by fully qualified name, the macro parser does not support
        // having a '.' in the Xml Element Name.  So replace them with a ":", and we'll substitute them
        // back here.  For now though, I couldn't get it to work so I'll leave this disabled.
        //typeName = (typeName.indexOf(':') > -1) ? typeName.replace(':', '.') : typeName;

        var pack = [];
        var type = try {
            Context.getType(typeName);
        } catch (e:String) {
            if ( e=="Type not found '" + typeName + "'" )
                error('Unable to find Widget/Partial "$typeName" in widget template $widgetClass', widgetClass.get().pos);
            else throw e;
        }

        var isChildWidget = type.isSubTypeOf(Context.getType("dtx.widget.ChildWidget")).match(Success(_));

        // Alternatively use: type = Context.typeof(macro new $typeName()), see what works
        var classType:Ref<ClassType>;
        switch (type)
        {
            case TInst(t,_):
                // get the type
                classType = t;
                pack = classType.get().pack;
            default:
                throw "Asked for partial " + typeName + " but that doesn't appear to be a class";
        }

        // Replace the call with <div data-dtx-partial="$name"></div>
        var partialDOM = templates.get( classType.toString() ).parse();
        var partialFirstElement = partialDOM.filter( function (n) return n.isElement() ).getNode(0);
        var placeholderName = (partialFirstElement!=null) ? partialFirstElement.tagName() : "span";
        var placeholder = placeholderName.create().setAttr("data-dtx-partial", name);
        switch topLevel {
            case Some(widgetCollection):
                var placeholderIndex = widgetCollection.collection.indexOf( node );
                widgetCollection.collection[placeholderIndex] = placeholder;
            case _:
                var parent = node.parent();
                node.replaceWith( placeholder );
        }

        // Set up a public field in the widget, public var $name(default,set_$name):$type
        var typePath = {
            sub: null,
            params: [],
            pack: pack,
            name: typeName
        };
        var propType = TPath( typePath );
        var prop = BuildTools.getOrCreateProperty(name, propType, false, true);
        var variableRef = name.resolve();
        var typeRef = typeName.resolve();

        // If we have a partial declaration on the top level of a widget (it does not have a parent element),
        // then we also need to add it to the Widget collection.  Otherwise, if the widget is *not* inserted into a DOM
        // yet, then `replaceWith()` will insert it into the containing <div> of the widget, but not in the collection,
        // and when you finally insert the collection into a DOM, it will not include the new partial.
        switch topLevel {
            case Some(widgetCollection):
                var linesToAdd = macro {
                    var placeholder = this.filter(function(node) return dtx.single.ElementManipulation.attr(node, 'data-dtx-partial')==$v{name} ).getNode(0);
                    var index = -1;
                    if ( placeholder!=null ) {
                        index = this.collection.indexOf( placeholder );
                        this.removeFromCollection( placeholder );
                    }
                    else if ( v!=null ) {
                        this.removeFromCollection( $variableRef );
                        trace(this.get_template());
                        trace(this.collection.join(", "));
                        index = this.collection.indexOf( v.getNode(0) );
                        trace( 'v not null, and index is '+index+" "+v.getNode(0) );
                    }
                    for ( node in v ) {
                        this.add( node, index++ );
                    }
                }
                BuildTools.addLinesToFunction(prop.setter, linesToAdd, 0);
            case _:
        }

        // Add the partial to the DOM when the setter is called, replacing either the placeholder or an existing partial.
        var selector = ("[data-dtx-partial='" + name + "']").toExpr();
        var linesToAdd = macro {
            // Either replace the existing partial, or if none set, replace the <div data-dtx-partial='name'/> placeholder
            var toReplace = ($variableRef != null) ? $variableRef : dtx.collection.Traversing.find(this, $selector);
            dtx.collection.DOMManipulation.replaceWith(toReplace, v);
        }
        BuildTools.addLinesToFunction(prop.setter, linesToAdd, 0);

        // Now that we can set it via the property setter, we do so in our init function.
        // With something like:
        //
        // $name = new $type()
        // this.find("[data-dtx-partial=$name]").replaceWith($name)
        //
        // So that'll end up looking like:
        //
        // public function new() {
        //   var btn = new Button();
        //   partial_1 = btn;
        // }

        // Get the init function, instantiate our partial
        var initFn = BuildTools.getOrCreateField(getInitFnTemplate());
        linesToAdd =
            if (isChildWidget) macro { $variableRef = new $typePath(this); }
            else macro { $variableRef = new $typePath(); };
        BuildTools.addLinesToFunction(initFn, linesToAdd, 0);

        // Any attributes on the partial are variables to be passed.  Every time a setter on the parent widget is called, it should trigger the relevent setter on the child widget
        for (attName in (node:Xml).attributes())
        {
            if (attName.startsWith("dtx")==false)
            {
                var propertyRef = '$name.$attName'.resolve();
                var valueExprStr = node.attr(attName);
                var valueExpr:Expr;

                // We use a similar syntax to text interpolation, but we unwrap the resulting expression so that it is not cast to a string.
                // Still, this allows for attr="constantVal" attr="$variable" and attr="${'_'+someVar}", so it is fairly powerful.
                var formattedExpr = Format.format( macro $v{valueExprStr} );
                switch formattedExpr.expr {
                    case ECheckType( { expr:EConst(CString(constantString)), pos:pos }, type):
                        valueExpr = formattedExpr;
                    case ECheckType( { expr:EBinop(OpAdd,macro "",expr2), pos:pos }, type):
                        // `""+someValue`: the "" is to cast to a String, we are interested in the value only.
                        valueExpr = expr2;
                    case ECheckType( { expr:EBinop(OpAdd,_,_), pos:pos }, type):
                        // adding some expression, going to assume string?
                        valueExpr = formattedExpr;
                    case other:
                        Context.error( 'Failed to extract understand expression from from <${node.tagName()} $attName="$valueExprStr">, please use a simpler attribute or file a feature request.', p );
                }

                var nothingNull = valueExpr.generateNullCheckForExpression();
                var setterExpr = macro if ($nothingNull) $propertyRef = $valueExpr;
                var idents =  valueExpr.extractIdents();
                if ( idents.length>0 ) {
                    // If it has variables, set it in all setters
                    addExprToAllSetters(setterExpr,idents, true);
                }
                else {
                    // If it doesn't, set it in init
                    BuildTools.addLinesToFunction(initFn, setterExpr);
                }

                addExprInitialisationToConstructor(idents);
            }
        }
    }

    static function processLoop(node:dtx.DOMNode, t:Int)
    {
        // Generate a name for the partial.  Either take it from the <dtx:MyPartial dtx-name="this" /> attribute,
        // or autogenerate one (partial_$t, t++)
        var widgetClass = Context.getLocalClass();
        var nameAttr = node.attr('dtx-name');
        var name = (nameAttr != "") ? nameAttr : "loop_" + t;
        var p = widgetClass.get().pos;

        // Get the `for="name in names"` attribute
        var propName:Null<String> = null;
        var loopInputCT:ComplexType;
        var typingFailure:Error = null;
        var iterableExpr:Null<Expr> = null;
        var forAttr = node.attr( "for" );
        var typeAttr = node.attr( "type" );
        if ( forAttr!="" ) {
            var forCode = 'for ($forAttr) {}';
            try {
                var forExpr = Context.parse( forCode, p );
                switch (forExpr.expr) {
                    case EFor( { expr: EIn(e1,e2), pos: _ }, _ ):
                        switch (e1.expr) {
                            case EConst(CIdent(n)):
                                propName = n;
                            case _:
                                throw 'Was expecting EConst(CIdent(propName)), but got $e1';
                        }
                        // For "typeof" to work, it needs us to mock member variables and static variables so it knows what type they are.
                        var variablesInContext = BuildTools.fakeVariablesContextForLocalClass();
                        switch e2.typeof(variablesInContext) {
                            case Success(itType):
                                var result;
                                if ( Context.unify(itType, Context.getType("Iterable")) ) {
                                    result = (macro $e2.iterator().next()).typeof(variablesInContext);
                                }
                                else if ( Context.unify(itType, Context.getType("Iterator")) ) {
                                    result = (macro $e2.next()).typeof(variablesInContext);
                                }
                                else throw "$e2 Was not an iterable or an iterator";

                                switch (result) {
                                    case Success(t): loopInputCT = t.toComplexType();
                                    case Failure(err): typingFailure = err;
                                }
                            case Failure(err): typingFailure = err;
                        }

                        iterableExpr = e2;
                    case _:
                        throw "Was expecting EFor, got something else";
                }
            }
            catch (e:Dynamic)
                error('Error parsing for="$forAttr" in loop ($widgetClass template). \nError: $e \nNode: ${node.html()}', p);
        }
        if ( loopInputCT==null && typeAttr!="" ) {
            var typeName = "";
            if ( typeAttr.indexOf(":") > -1 ) {
                var parts = typeAttr.split(":");
                propName = parts[0].trim();
                typeName = parts[1].trim();
            }
            else {
                typeName = typeAttr.trim();
            }
            var type = Context.getType( typeName );
            if (type==null)
                error('Error finding type type="$typeAttr" in loop ($widgetClass template). \nType $typeName was not found.  \nNode: ${node.html()}', p);
            loopInputCT = type.toComplexType();
        }
        if ( loopInputCT==null ) {
            Context.warning( 'Unable to type dtx:loop:\n$node', p );
            if (typingFailure!=null) typingFailure.throwSelf();
            error( "Exiting", p );
        }
        else {
            // Check if a partial is specified, if not, use InnerHTML to define a new partial
            var partialTypeName = node.attr("partial");
            if ( partialTypeName=="" ) {
                var partialHtml = node.innerHTML();
                if ( partialHtml.length==0 )
                    error( 'You must define either a partial="" attribute, or have child elements for the dtx:loop in widget $widgetClass', p );

                // Process the template as a partial declaration
                partialTypeName = "_" + name.charAt(0).toUpperCase() + name.substr(1);

                if ( propName!=null ) {
                    var propertyToAdd:Field = {
                        pos: p,
                        name: propName,
                        meta: [],
                        kind: FVar(loopInputCT,null),
                        doc: null,
                        access: [APublic]
                    };
                    processPartialDeclarations( partialTypeName, node, [ propertyToAdd ] );
                }
            }

            // Set up the full name for relative partials
            if (partialTypeName.startsWith("_"))
            {
                partialTypeName = widgetClass.get().name + partialTypeName;
            }


            // Extract the ClassType for the chosen type
            var partialClassType:Ref<ClassType>;
            var widgetType:Type;
            try {
                widgetType = Context.getType(partialTypeName);
                switch ( widgetType )
                {
                    case TInst(t,_):
                        // get the widgetType
                        partialClassType = t;
                    default:
                        throw "Asked for loop partial " + partialTypeName + " but that doesn't appear to be a class";
                }
            } catch (e:String) {
                if ( e=="Type not found '" + partialTypeName + "'" )
                    error('Unable to find Loop Widget/Partial "$partialTypeName" in widget template $widgetClass', p);
                else throw e;
            }
            var isChildWidget = widgetType.isSubTypeOf(Context.getType("dtx.widget.ChildWidget")).match(Success(_));

            // Replace the call with <div data-dtx-loop="$name"></div>
            var partialFirstElement = node.firstChildren( true );
            var placeholderName = switch( node.parentNode.tagName() ) {
                case "tbody", "table", "thead", "tfoot": "tr";
                case "colgroup": "col";
                case "tr": "td";
                default: "span";
            };
            node.replaceWith( placeholderName.create().setAttr("data-dtx-loop", name) );

            // Set up a public field in the widget, public var $loopName(default,set_$name):WidgetLoop<$inputCT,$widgetCT>
            var widgetTypePath = TPath({
                sub: null,
                params: [],
                pack: partialClassType.get().pack,
                name: partialTypeName
            });
            var localComplexType = Context.toComplexType(Context.getLocalType());
            var inputTypeParam = TPType( loopInputCT );
            var widgetTypeParam = TPType( widgetTypePath );
            var parentTypeParam = isChildWidget ? TPType( localComplexType ) : null;
            var loopPropType = TPath( {
                sub: null,
                params: isChildWidget ? [parentTypeParam,inputTypeParam,widgetTypeParam] : [inputTypeParam,widgetTypeParam],
                pack: ["dtx","widget"],
                name: isChildWidget ? "ChildWidgetLoop" : "WidgetLoop"
            });
            var prop = BuildTools.getOrCreateProperty(name, loopPropType, false, true);

            // Add some lines to the setter
            var variableRef = name.resolve();
            var partialTypeRef = partialTypeName.resolve();
            var selector = ("[data-dtx-loop='" + name + "']").toExpr();
            var linesToAdd = macro {
                // Either replace the existing partial, or if none set, replace the <div data-dtx-partial='name'/> placeholder
                var toReplace = ($variableRef != null) ? $variableRef : dtx.collection.Traversing.find(this, $selector);
                dtx.collection.DOMManipulation.replaceWith(toReplace, v);
            }
            BuildTools.addLinesToFunction(prop.setter, linesToAdd, 0);

            // Get the join information
            var join = node.attr("join");
            var finalJoin = node.attr("finaljoin");
            var afterJoin = node.attr("after");
            var joinExpr = Context.makeExpr( (join!="") ? join : null, p );
            var finalJoinExpr = Context.makeExpr( (finalJoin!="") ? finalJoin : null, p );
            var afterJoinExpr = Context.makeExpr( (afterJoin!="") ? afterJoin : null, p );

            // Get the init function, instantiate our loop object
            var initFn = BuildTools.getOrCreateField(getInitFnTemplate());
            var propNameExpr = Context.makeExpr( propName, p );
            var useAutoMap = false; // Later we might add an attribute to enable this...

            linesToAdd =
                if (isChildWidget) macro {
                    // new ChildWidgetLoop(this, $Partial, $varName, propmap=null, automap=true)
                    $variableRef = new dtx.widget.ChildWidgetLoop(this, $partialTypeRef, $propNameExpr, $v{useAutoMap});
                    $variableRef.setJoins($joinExpr, $finalJoinExpr, $afterJoinExpr);
                }
                else macro {
                    // new WidgetLoop($Partial, $varName, propmap=null, automap=true)
                    $variableRef = new dtx.widget.WidgetLoop($partialTypeRef, $propNameExpr, $v{useAutoMap});
                    $variableRef.setJoins($joinExpr, $finalJoinExpr, $afterJoinExpr);
                };
            BuildTools.addLinesToFunction(initFn, linesToAdd);

            // Find any variables mentioned in the iterable / for loop, and add to our setter
            if ( iterableExpr!=null ) {
                var idents = iterableExpr.extractIdents();
                var iterableNullCheck = BuildTools.generateNullCheckForExpression( iterableExpr );
                var setListLine = macro
                    if ( $variableRef!=null && $iterableNullCheck ) {
                        try
                            $variableRef.setList( $iterableExpr )
                        catch (e:Dynamic) {
                            var stack = haxe.CallStack.toString( haxe.CallStack.exceptionStack() );
                            trace( 'Failed to update loop: '+e );
                            trace( 'Stack trace: '+stack );
                            $variableRef.empty();
                        }
                    }

                if ( idents.length>0 )
                    // If it has variables, set it in all setters
                    addExprToAllSetters(setListLine,idents, true);
                else
                    // If it doesn't, set it in init
                    BuildTools.addLinesToFunction(initFn, setListLine);
            }
        }

    }

    static function getInitFnTemplate()
    {
        var body = macro {};
        return {
            pos: BuildTools.currentPos(),
            name: "init",
            meta: [],
            kind: FieldType.FFun({
                    ret: null,
                    params: [],
                    expr: body,
                    args: []
                }),
            doc: "",
            access: [APrivate,AOverride]
        }
    }

    static function getSetterTemplateForSuperProperty( setterName:String, ct:ComplexType ) {
        return (macro class OurField{
            override function $setterName( val:$ct ):$ct {
                // First time to set.
                super.$setterName(val);
                // Second time for return value.
                return super.$setterName(val);
            }
        }).fields[0];
    }

    static function processAttributes(node:dtx.DOMNode)
    {
        for (attName in (node:Xml).attributes())
        {
            if (attName.startsWith('dtx-on-'))
            {
                addEventTriggerForElement(node,attName);
            }
            else if (attName=='dtx-bind-value' || attName=='dtx-bind-int-value' || attName=='dtx-bind-float-value') {
                addValueBindForElement(node, attName);
            }
            else if (attName == 'dtx-content') {
                addContentSetForElement(node);
            }
            else if (attName == 'dtx-name')
            {
                var name = node.attr(attName);
                node.removeAttr(attName);
                createNamedPropertyForElement(node, name);
            }
            else if (attName.startsWith('dtx-'))
            {
                // look for special attributes eg <ul dtx-show="hasItems" />
                var wasDtxAttr = processDtxBoolAttributes(node, attName);
            }
            else
            {
                // look for variable interpolation eg <div id="person_$name">...</div>
                if (node.getAttribute(attName).indexOf('$') > -1)
                {
                    interpolateAttributes(node, attName);
                }
            }
        }
    }

    static function createNamedPropertyForElement(node:dtx.DOMNode, name:String)
    {
        if (name != "")
        {
            var selector = getUniqueSelectorForNode(node); // Returns for example: dtx.collection.Traversing.find(this, $selectorTextAsExpr)

            // Set up a public field in the widget, public var $name(default,set_$name):$type
            var propType = TPath({
                sub: null,
                params: [],
                pack: ['dtx'],
                name: "DOMNode"
            });
            var prop = BuildTools.getOrCreateProperty(name, propType, true, false);

            // Change the setter to null
            switch (prop.property.kind)
            {
                case FieldType.FProp(get, _, t, e):
                    prop.property.kind = FieldType.FProp(get, "null", t, e);
                default:
            }

            // Change the getter body
            switch( prop.getter.kind )
            {
                case FFun(f):
                    f.expr = macro return $selector;
                    prop.getter.access.push( AInline );
                default:
            }
        }
    }

    static function addEventTriggerForElement(node:dtx.DOMNode, attName:String)
    {
        var eventName = attName.substr(7);
        var eventBody = node.attr( attName );
        node.removeAttr(attName);

        if ( Context.defined("js") )
        {
            if ( eventName!="" && eventBody!="" )
            {
                eventBody = eventBody.trim();
                if ( eventBody.endsWith(";")==false ) eventBody = eventBody+";";

                var className = Context.getLocalClass().toString();
                var eventBodyExpr =
                    try
                        Context.parse( '{$eventBody}', BuildTools.currentPos() )
                    catch (e:Dynamic)
                        error('Error parsing $attName="$eventBody" in $className template. \nError: $e \nNode: ${node.html()}', BuildTools.currentPos());
                eventBodyExpr.substitute({ "_": macro e.currentTarget });

                var selector = getUniqueSelectorForNode(node); // Returns for example: dtx.collection.Traversing.find(this, $selectorTextAsExpr)
                var lineToAdd = macro dtx.single.EventManagement.on( $selector, $v{eventName}, function (e:js.html.Event) { $eventBodyExpr; } );

                var initFn = BuildTools.getOrCreateField(getInitFnTemplate());
                BuildTools.addLinesToFunction(initFn, lineToAdd);
            }
        }
    }

    /**
        Will bind a node's to a property.

        Every time a "change" event is fired on the node, the given "bindTo" property will be set.
        Please note that only JS supports events, so other targets will not have 2 way binding.

        Example:

        ```
        <form>
            <input type="text" dtx-name="nameInput" dtx-bind-value="student.name" />
        </form>
        ```

        Will generate something like the following code:

        ```
        function init() {
            this.nameInput.change( function(e:Event) { student.name = this.nameInput.val(); } );
        }
        function set_student(s:Student) {
            this.nameInput.setVal( student.name );
            return this.student = s;
        }
        ```

        As you can see, the bind is tied to the setter of the left-most property: when "this.student" is set, the input will update.
        If you set "this.student.name" without updating "this.student", the input will not be updated.
        A workaround can be to call `s.name = 'new name'; myWidget.student = s;`, so that the setter will run again after the property has changed.
    **/
    static function addValueBindForElement(node:DOMNode, attName:String)
    {
        var bindTo = node.attr( attName );
        node.removeAttr( attName );

        if ( bindTo!="" )
        {
            var className = Context.getLocalClass().toString();
            var initFn = BuildTools.getOrCreateField(getInitFnTemplate());
            var selector = getUniqueSelectorForNode(node);

            var bindToExpr =
                try
                    Context.parse( bindTo, BuildTools.currentPos() )
                catch (e:Dynamic)
                    error('Error parsing $attName="$bindTo" in $className template. \nError: $e \nNode: ${node.html()}', BuildTools.currentPos());

            var fieldName = getLeftMostVariable( bindToExpr );
            var setValueExpr = switch attName {
                case "dtx-bind-int-value":
                    var nullCheck = bindToExpr.generateNullCheckForExpression();
                    macro ($nullCheck) ? ''+$bindToExpr : '';
                case "dtx-bind-float-value":
                    var nanCheck = macro Math.isNaN($bindToExpr)==false;
                    var nullCheck = bindToExpr.generateNullCheckForExpression();
                    nullCheck = macro $nullCheck && $nanCheck;
                    macro ($nullCheck) ? ''+$bindToExpr : "";
                default:
                    var nullCheck = bindToExpr.generateNullCheckForExpression();
                    macro ($nullCheck) ? ''+$bindToExpr : '';
            }
            var setValLine = macro dtx.single.ElementManipulation.setVal( $selector, $setValueExpr );
            addExprToAllSetters( setValLine, [fieldName] );

            if ( Context.defined("js") )
            {
                // Add a "change" event listener to the init function.  On each change, set the "bindTo" property.
                var getVal = macro dtx.single.ElementManipulation.val($selector);
                var parseVal = switch attName {
                    case "dtx-bind-int-value": macro Std.parseInt( $getVal );
                    case "dtx-bind-float-value": macro Std.parseFloat( $getVal );
                    default: getVal;
                }
                var onChangeLine = macro dtx.single.EventManagement.change( $selector, function (e:js.html.Event) { $bindToExpr = $parseVal; } );
                BuildTools.addLinesToFunction(initFn, onChangeLine);
            }
        }
    }

    /**
        Bind the content (innerHTML) of this element to a variable / property.

        What is the difference between `<div>$pageContent</div>` as opposed to `<div dtx-content="pageContent" />`?
        Good question!  The regular text interpolation uses `setText()` and this escapes HTML, so it is innappropriate for adding HTML code into your widget.
        The `dtx-content` attribute calls `setInnerHTML()` on the node, so that you can insert HTML content into your widget.

        Example usage:

        ```
        Main.hx:
        class Main {
            static function main() {
                var layout = new MyLayout();
                layout.content = "<h1>Hello</h1><p>Welcome to my site</p>";
            }
        }

        MyLayout.hx:

        @:template("<div class='container' dtx-content='pageContent' />")
        class MyLayout extends Widget { }
        ```

        Note:

        Currently only basic properties and variables are supported, not method calls etc.
        The property must already exist, it will not be created.
    **/
    static function addContentSetForElement(node:DOMNode)
    {
        var attName = 'dtx-content';
        var content = node.attr( attName );
        node.removeAttr( attName );

        if ( content!="" ) {
            var className = Context.getLocalClass().toString();
            var selector = getUniqueSelectorForNode(node);

            var contentExpr =
                try
                    Context.parse( content, BuildTools.currentPos() )
                catch (e:Dynamic)
                    error('Error parsing $attName="$content" in $className template. \nError: $e \nNode: ${node.html()}', BuildTools.currentPos());

            // TODO: check if we need to be more thorough in which variables we put setters on.
            // With text interpolation, we check for arguments in function calls also.
            // Here we just check for the left-most, which should suffice MOST of the time...
            var fieldName = getLeftMostVariable( contentExpr );
            var setInnerHtmlLine = macro $selector.setInnerHTML( ''+$contentExpr );
            addExprToAllSetters( setInnerHtmlLine, [fieldName] );
        }
    }

    static var uniqueDtxID:Int = 0;

    /** Get a unique selector for the node, creating a data attribute if necessary */
    static function getUniqueSelectorForNode(node:dtx.DOMNode):Expr
    {
        // Get an existing data-dtx-id, or set a new one
        var id:Int;
        var attValue = node.attr("data-dtx-id");
        if (attValue=="")
        {
            id = uniqueDtxID++;
            node.setAttr("data-dtx-id", '$id');
        }
        else
        {
            id = Std.parseInt(attValue);
        }

        var idExpr = id.toExpr();
        return macro _dtxWidgetNodeIndex[$idExpr];
    }

    static function interpolateAttributes(node:dtx.DOMNode, attName:String)
    {
        var selectorExpr = getUniqueSelectorForNode(node);

        var nameAsExpr = Context.makeExpr(attName, BuildTools.currentPos());

        var result = processVariableInterpolation(node.attr(attName));
        var interpolationExpr = result.expr;
        var variablesInside = result.variablesInside;

        // Set up bindingExpr
        //var bindingExpr = macro this.find($selectorAsExpr).setAttr($nameAsExpr, $interpolationExpr);
        var bindingExpr = macro dtx.single.ElementManipulation.setAttr($selectorExpr, $nameAsExpr, $interpolationExpr);

        // Go through array of all variables again
        addExprToAllSetters(bindingExpr, variablesInside, true);

        // Initialise variables
        addExprInitialisationToConstructor(variablesInside);
    }

    static function interpolateTextNodes(node:dtx.DOMNode)
    {
        // Get (or set) ID on parent, get selector
        var selectorAsExpr = getUniqueSelectorForNode(node.parentNode);
        var index = node.index();
        var indexAsExpr = index.toExpr();

        var result = processVariableInterpolation(node.text());
        var interpolationExpr = result.expr;
        var variablesInside = result.variablesInside;

        // Set up bindingExpr
        //var bindingExpr = macro this.children(false).getNode($indexAsExpr).setText($interpolationExpr);
        var bindingExpr = macro dtx.single.ElementManipulation.setText(dtx.single.Traversing.children($selectorAsExpr, false).getNode($indexAsExpr), $interpolationExpr);

        // Add binding expression to all setters.
        addExprToAllSetters(bindingExpr, variablesInside, true);

        // Initialise variables
        addExprInitialisationToConstructor(variablesInside);
    }

    static function addExprToAllSetters(expr:Expr, variables:Array<String>, ?prepend)
    {
        for (varName in variables)
        {
            // Add bindingExpr to every setter.  Add at position `1`, so after the first line, which should be 'this.field = v;'
            if (varName.fieldExists())
            {
                var setter = varName.getField().getSetter();
                if (setter!=null)
                    setter.addLinesToFunction(expr, 1);
            }
            else
            {
                switch varName.getFieldFromSuperClass() {
                    case Some(field):
                        if (field.kind.match(FVar(_,AccCall))) {
                            var setterName = 'set_$varName';
                            var type = BuildTools.replaceSuperTypeParamsWithImplementation( field.type );
                            var ct = type.toComplex();
                            var setterTemplate = getSetterTemplateForSuperProperty( setterName,ct );
                            var setterFn = BuildTools.getOrCreateField(setterTemplate);
                            BuildTools.addLinesToFunction(setterFn, expr, 1);
                        }
                        else
                            error('Field $varName on superclass must be a property with a setter.', BuildTools.currentPos() );
                    case None:
                        // It might be an identifier from the local context, or from an import, or a type name etc.
                        // Remove it from the list, so that if no other setters are found it will set during `init()`.
                        /*variables.remove(varName);*/
                }
            }
        }
        if (variables.length==0)
        {
            // Add it to the init() function instead
            var initFn = BuildTools.getOrCreateField(getInitFnTemplate());
            BuildTools.addLinesToFunction(initFn, expr);
        }
    }

    static var initialisationExpressions:Map<String,Array<String>> = new Map();

    static function addExprInitialisationToConstructor(variables:Array<String>)
    {
        var clsName = Context.getLocalClass().toString();
        if (initialisationExpressions[clsName]==null) initialisationExpressions[clsName] = [];
        var varsAlreadyInitialized = initialisationExpressions[clsName];

        for (varName in variables)
        {
            var field = varName.getField();
            if ( field==null )
                continue;
            switch (field.kind)
            {
                case FProp(get,set,type,e):
                    var initValueExpr:Expr = null;
                    var initFn = BuildTools.getOrCreateField(getInitFnTemplate());
                    if ( e!=null )
                        initValueExpr = e;
                    else
                    {
                        if ( type == null ) throw 'Unknown type when trying to initialize $varName on class ${Context.getLocalClass()}';
                        switch (type)
                        {
                            case TPath(path):
                                var name = path.name;
                                if ( name=="StdTypes" ) name = path.sub;
                                switch (name) {
                                    case "Bool":
                                        initValueExpr = macro false;
                                    case "String":
                                        initValueExpr = macro "";
                                    case "Int":
                                        initValueExpr = macro 0;
                                    case "Float":
                                        initValueExpr = macro 0;
                                    default:
                                        initValueExpr = macro null;
                                }
                            default:
                        }
                    }
                    if ( initValueExpr!=null )
                    {
                        if ( varsAlreadyInitialized.has(varName)==false ) {
                            // Update the init expression, and add to the init function
                            // We want both, the init function so that setters fire, and the init expression
                            // so that all values are initialized by the time the first setter fires also...
                            field.kind = FProp(get,set,type,initValueExpr);
                            var varRef = varName.resolve();
                            var setExpr = macro $varRef = $initValueExpr;
                            BuildTools.addLinesToFunction(initFn, setExpr);
                            varsAlreadyInitialized.push( varName );
                        }
                    }
                default:
            }
        }
    }

    static function processVariableInterpolation(string:String):{ expr:Expr, variablesInside:Array<String> }
    {
        var stringAsExpr = Context.makeExpr(string, BuildTools.currentPos());
        var interpolationExpr = Format.format(stringAsExpr);

        // Get an array of all the variables in interpolationExpr
        var variables:Array<ExtractedVarType> = extractVariablesUsedInInterpolation(interpolationExpr);
        var variableNames:Array<String> = BuildTools.extractIdents(interpolationExpr);

        for (extractedVar in variables)
        {
            switch (extractedVar)
            {
                case Ident(varName):
                    var propType = TPath({
                        sub: null,
                        params: [],
                        pack: [],
                        name: "String"
                    });
                    var prop = BuildTools.getOrCreateProperty(varName, propType, false, true);

                    var functionName = "print_" + varName;
                    if (BuildTools.fieldExists(functionName)) {
                        // If "print_*" exists, in our interpolationExpr replace calls to $name with print_$name($name)
                        var replacements = {};
                        Reflect.setField( replacements, varName, macro $i{functionName}() );
                        interpolationExpr = interpolationExpr.substitute( replacements );
                    }
                    if ( variableNames.indexOf(varName)==-1 )
                        variableNames.push(varName);
                case Call(varName), Field(varName):
                    if ( variableNames.indexOf(varName)==-1 )
                        variableNames.push(varName);
            }
        }
        if ( variableNames.length>0 ) {
            var nullCheck = BuildTools.generateNullCheckForExpression( interpolationExpr );
            interpolationExpr = macro ($nullCheck ? $interpolationExpr : "");
        }

        return {
            expr: interpolationExpr,
            variablesInside: variableNames
        };
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
                        var parts = BuildTools.getAllPartsOfBinOp(e);
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
                                        if ( leftMostVarName.fieldExists() )
                                            variablesInside.push( ExtractedVarType.Field(leftMostVarName) );
                                        else {
                                            switch leftMostVarName.getFieldFromSuperClass() {
                                                case Some(field):
                                                    variablesInside.push( ExtractedVarType.Field(leftMostVarName) );
                                                case None:
                                                    var localClass = Context.getLocalClass();
                                                    var printer = new Printer("  ");
                                                    var partString = printer.printExpr(part);
                                                    error('In the Detox template for $localClass, in the expression `$partString`, variable "$leftMostVarName" could not be found.  Variables used in complex expressions inside the template must be explicitly declared.', localClass.get().pos);
                                            }
                                        }
                                    }
                                case ECall(e, params):
                                    // Look for variables to add in the paramaters
                                    for (param in params) {
                                        var varName = getLeftMostVariable(param);
                                        if (varName != null) {
                                            if ( varName.fieldExists() ) {
                                                switch varName.getField().kind {
                                                    case FVar(_,_), FProp(_,_,_,_):
                                                        variablesInside.push( ExtractedVarType.Call(varName) );
                                                    case FFun(_):
                                                }
                                            }
                                            else {
                                                var localClass = Context.getLocalClass();
                                                var printer = new Printer("  ");
                                                var callString = printer.printExpr(part);
                                                error('In the Detox template for $localClass, in function call `$callString`, variable "$varName" could not be found.  Variables used in complex expressions inside the template must be explicitly declared.', localClass.get().pos);
                                            }
                                        }
                                    }
                                    // See if the function itself is on a variable we need to add
                                    var leftMostVarName = getLeftMostVariable(e);
                                    if ( leftMostVarName.fieldExists() ) {
                                        switch ( leftMostVarName.getField().kind ) {
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
                        error("extractVariablesUsedInInterpolation() only works when the expression inside ECheckType is EBinOp, as with the output of Format.format()", BuildTools.currentPos());
                }
            default:
                error("extractVariablesUsedInInterpolation() only works on ECheckType, the output of Format.format()", BuildTools.currentPos());
        }
        return variablesInside;
    }

    /**
        Takes an expression and tries to find the left-most plain variable.  For example "student" in `student.name`, "age" in `person.age`, "name" in `name.length`.

        It will try to ignore "this", for example it will match "person" in `this.person.age`.

        Note it will also match packages: "haxe" in "haxe.crypto.Sha1.encode"
    **/
    public static function getLeftMostVariable(expr:Expr):Null<String>
    {
        var leftMostVarName = null;
        var err = false;

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
                            leftMostVarName = getLeftMostVariable( currentExpr );
                            break;
                    }
                }
            case ECall(e,params):
                // TODO: Here we only return the left-most variable of the function being called, which is useful
                // if we are calling a method on a variable.  For example, `student.name.substr(1)` will return `student`
                // so we can listen to set_student for changes.  But what if we have have `StringTools.replace(text, student.firstName, "")`?
                // In that case we might want this to return `[text, student]`, as we will want setters on both of those
                return getLeftMostVariable(e);
            case EMeta(_,e):
                return getLeftMostVariable(e);
            case EArray(e,index):
                return getLeftMostVariable(e);
            case EConst(_): // A constant.  Leave it null
            case _: err = true;
        }
        if (err)
        {
            var localClass = Context.getLocalClass();
            var printer = new Printer("  ");
            var exprString = printer.printExpr( expr );
            error('In the Detox template for $localClass, the expression `$exprString`, was too complicated for the poor Detox macro to understand.', localClass.get().pos);
        }

        return leftMostVarName;
    }

    static function processDtxBoolAttributes(node:dtx.DOMNode, attName:String)
    {
        var wasDtxAttr = false;
        var trueStatement:Expr = null;
        var falseStatement:Expr = null;

        if (attName.startsWith('dtx-'))
        {
            wasDtxAttr = true; // probably true
            var selector = getUniqueSelectorForNode(node);
            switch (attName)
            {
                case "dtx-show":
                    var className = "hidden".toExpr();
                    trueStatement = macro dtx.single.Style.show($selector);
                    falseStatement = macro dtx.single.Style.hide($selector);
                case "dtx-hide":
                    var className = "hidden".toExpr();
                    trueStatement = macro dtx.single.Style.hide($selector);
                    falseStatement = macro dtx.single.Style.show($selector);
                case "dtx-enabled":
                    trueStatement = macro dtx.single.ElementManipulation.removeAttr($selector, "disabled");
                    falseStatement = macro dtx.single.ElementManipulation.setAttr($selector, "disabled", "disabled");
                case "dtx-disabled":
                    trueStatement = macro dtx.single.ElementManipulation.setAttr($selector, "disabled", "disabled");
                    falseStatement = macro dtx.single.ElementManipulation.removeAttr($selector, "disabled");
                case "dtx-checked":
                    trueStatement = macro dtx.single.ElementManipulation.setAttr($selector, "checked", "checked");
                    falseStatement = macro dtx.single.ElementManipulation.removeAttr($selector, "checked");
                case "dtx-unchecked":
                    trueStatement = macro dtx.single.ElementManipulation.removeAttr($selector, "checked");
                    falseStatement = macro dtx.single.ElementManipulation.setAttr($selector, "checked", "checked");
                case "dtx-selected":
                    trueStatement = macro dtx.single.ElementManipulation.setAttr($selector, "selected", "selected");
                    falseStatement = macro dtx.single.ElementManipulation.removeAttr($selector, "selected");
                case "dtx-deselected":
                    trueStatement = macro dtx.single.ElementManipulation.removeAttr($selector, "selected");
                    falseStatement = macro dtx.single.ElementManipulation.setAttr($selector, "selected", "selected");
                default:
                    if (attName.startsWith('dtx-class-'))
                    {
                        // add a class
                        var className = attName.substring(10);
                        var classNameAsExpr = className.toExpr();
                        trueStatement = macro dtx.single.ElementManipulation.addClass($selector, $classNameAsExpr);
                        falseStatement = macro dtx.single.ElementManipulation.removeClass($selector, $classNameAsExpr);
                    }
                    else
                    {
                        wasDtxAttr = false; // didn't match, set back to false
                    }
            }
        }

        if (wasDtxAttr)
        {
            var className = Context.getLocalClass().toString();
            var classPos = Context.getLocalClass().get().pos;

            // Turn the attribute into an expression, and check it is a Bool, so we can use it in an if statement
            var testExprStr = node.attr(attName);
            #if (haxe_ver >= 3.200)
                // From Haxe 3.2, the XML parser turns "a && b" into "a &&&& b". Weird, but we can work with that. It isn't valid XML anyway.
                testExprStr = testExprStr.replace( "&&&&", "&&" );
            #end
            var testExpr =
                try
                    Context.parse( testExprStr, classPos )
                catch (e:Dynamic)
                    error('Error parsing $attName="$testExprStr" in $className template. \nError: $e \nNode: ${node.html()}', classPos);

            // Extract all the variables used, create the `if(test) ... else ...` expr, add to setters, initialize variables
            var idents =  testExpr.extractIdents();
            var nothingNull = testExpr.generateNullCheckForExpression();
            var bindingExpr = macro if ($nothingNull && $testExpr) $trueStatement else $falseStatement;
            addExprToAllSetters(bindingExpr,idents, true);
            addExprInitialisationToConstructor(idents);

            // Remove the attribute now that we've processed it
            node.removeAttr(attName);
        }

        return wasDtxAttr;
    }

    static var booleanSetters:Map<String,Map<String, { trueBlock:Array<Expr>, falseBlock:Array<Expr> }>> = null;
    static function getBooleanSetterParts(booleanName:String)
    {
        // If a list of boolean setters for this class doesn't exist yet, set one up
        var className = Context.getLocalClass().toString();
        if (booleanSetters == null) booleanSetters = new Map();
        if (booleanSetters.exists(className) ==  false) booleanSetters.set(className, new Map());

        // If this boolean setter doesn't exist yet, create it.
        if (booleanSetters.get(className).exists(booleanName) == false)
        {
            // get or create property
            var propType = TPath({
                sub: null,
                params: [],
                pack: [],
                name: "Bool"
            });
            var prop = BuildTools.getOrCreateProperty(booleanName, propType, false, true);

            // add if() else() to setter, at position 1 (so after the this.x = x; statement)
            var booleanExpr = booleanName.resolve();
            var ifStatement = macro if ($booleanExpr) {} else {};
            BuildTools.addLinesToFunction(prop.setter, ifStatement, 1);

            // get the trueBlock and falseBlock
            var trueBlock:Array<Expr>;
            var falseBlock:Array<Expr>;
            switch (ifStatement.expr)
            {
                case EIf(_,eif,eelse):
                    switch (eif.expr)
                    {
                        case EBlock(b):
                            trueBlock = b;
                        default:
                            throw "Error in WidgetTools: this should definitely have been an EBlock";
                    }
                    switch (eelse.expr)
                    {
                        case EBlock(b):
                            falseBlock = b;
                        default:
                            throw "Error in WidgetTools: this should definitely have been an EBlock";
                    }
                default:
                    throw "Error in WidgetTools: this should definitely have been an EIf";
            }

            // Keep track of them so we can use them later
            booleanSetters.get(className).set(booleanName, {
                trueBlock: trueBlock,
                falseBlock: falseBlock
            });
        }

        // get the if block and else block and return them
        return booleanSetters.get(className).get(booleanName);
    }

    #end
}

// for the glory of God
