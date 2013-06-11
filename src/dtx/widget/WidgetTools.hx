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
import tink.macro.tools.MacroTools;
using tink.macro.tools.MacroTools;
using StringTools;
using Lambda;
using Detox;
using dtx.widget.BuildTools;

class WidgetTools 
{
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
        var widgetPos = Context.currentPos();                   // Position where the original Widget class is declared
        var localClass = haxe.macro.Context.getLocalClass();    // Class that is being declared
        var fields = BuildTools.getFields();

        // If get_template() already exists, don't recreate it
        var useParentTemplate = BuildTools.hasClassMetadata(":useParentTemplate");
        if (!useParentTemplate && fields.exists(function (f) return f.name == "get_template") == false)
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
                template = result.template;
                fields.push(createField_get_template(template, widgetPos));
            }
            return fields;
        }
        else
        {
            // Leave the fields as is
            return null;
        }
    }

    /**
      * Helper functions
      */

    #if macro
    static function loadTemplate(localClass:Null<haxe.macro.Type.Ref<haxe.macro.Type.ClassType>>):String
    {
        var p = localClass.get().pos;                           // Position where the original Widget class is declared
        var className = localClass.toString();                  // Name of the class eg "my.pack.MyType"
        
        var templateFile:String = "";                           // If we are loading template from a file, this is the filename
        var template:String = "";                               // If the template is directly in metadata, use that.

        // Get the template content if declared in metadata
        var template = BuildTools.getClassMetadata_String(":template", true);
        if (template == null)
        {
            // Check if we are loading a partial from in another template
            var partialInside = BuildTools.getClassMetadata_ArrayOfStrings(":partialInside", true);
            if (partialInside != null && partialInside.length > 0)
            {
                if (partialInside.length == 2)
                {
                    var templateFile = partialInside[0];
                    var partialName = partialInside[1];
                    template = loadPartialFromInTemplate(templateFile, partialName);
                }
                else Context.error('@:partialInside() metadata should be 2 strings: @:partialInside("MyView.html", "_NameOfPartial")', p);
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
                
                // If still no template, check if @:noTpl() was declared, if not, throw error.
                if (template == null) 
                {
                    var metadata = localClass.get().meta.get();
                    if (!metadata.exists(function(metaItem) return metaItem.name == ":noTpl"))
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
            var tpl = fullTemplate.parse();
            var allNodes = Lambda.concat(tpl, tpl.descendants());
            var partialMatches = allNodes.filter(function (n) { return n.nodeType == Xml.Element && n.nodeName == partialName; });
            if (partialMatches.length == 1)
            {
                partialTemplate = partialMatches.first().innerHTML();
            }
            else if (partialMatches.length > 1) Context.warning('The partial $partialName was found more than once in the template $templateFile... confusing!', p);
            else Context.warning('The partial $partialName was not found in the template $templateFile', p);
        }
        else Context.warning('Could not load the file $templateFile that $partialName is supposedly in.', p);

        return partialTemplate;
    }
    
    static function createField_get_template(template:String, widgetPos:Position):Field
    {
        // Clear whitespace from the start and end of the widget
        var whitespaceStartOrEnd = ~/^\s+|\s+$/g;
        template = whitespaceStartOrEnd.replace(template, "");

        return { 
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
                                    pos: widgetPos
                                }
                            ), 
                            pos: widgetPos
                        }
                        ]
                    ), 
                    pos: widgetPos
                }, 
                params: [], 
                ret: null 
            }), 
            pos: widgetPos
        }
    }

    static var topLevelElements:Array<dtx.DOMNode>;
    static function trackTopLevelElements(xml:DOMCollection)
    {
        if (topLevelElements == null) topLevelElements = [];
        for (node in xml)
        {
            topLevelElements.push(node);
        }
    }

    static function isTopLevelElement(n:dtx.DOMNode)
    {
        return (topLevelElements != null) ? topLevelElements.has(n) : false;
    }

    static function processTemplate(template:String):{ template:String, fields:Array<Field> }
    {
        // Get every node (including descendants)
        var p = haxe.macro.Context.currentPos();
        var xml = template.parse();
        trackTopLevelElements(xml);

        var allNodes = new dtx.DOMCollection();
        allNodes.addCollection(xml);
        allNodes.addCollection(xml.descendants(false));

        var fieldsToAdd = new Array<Field>();
        var t=0; // Used to create name if none given, eg partial_4:DOMCollection

        // Look for special things (variables, loops, partials etc)

        for (node in allNodes)
        {
            if (node.isElement() && node.tagName().startsWith('_'))
            {
                // This is a partial declaration <_MyPartial>template</_MyPartial>
                processPartialDeclarations(node, xml);
            }
            else if (node.isElement() && node.tagName() == "dtx:loop")
            {
                // It's a loop element... either: 
                //    <dtx:loop><dt>$name</dt><dd>$age</dd></dtx:loop> OR
                //    <dtx:loop partial="Something" />

            }
            else if (node.isElement() && node.tagName().startsWith('dtx:'))
            {
                // This is a partial call.  <dtx:_MyPartial /> or <dtx:SomePartial /> etc
                t++;
                processPartialCalls(node, xml, t);
            }
            else if (node.isElement())
            {
                processAttributes(node);
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

        // All our variable definitions are added to the end of the constructor.
        // So if the developer wants to work with the partials in the constructor, they find out that
        // the partials are still null.  (D'OH!)  Call init(), which the developer can then use
        // instead of putting their code in the constructor.
        if ("new".fieldExists())
        {
            var constructor = "new".getField();
            var expr = macro init();
            BuildTools.addLinesToFunction(constructor, expr);
        }

        // var bindingExpressions = new Array<Expr>();
        // var toAddToConstructor = new Array<Expr>();

        // More escaping hoop-jumping.  Basically, xml.html() will encode the text nodes, but not the attributes. Gaarrrh
        // So if we go through the attributes on each of our top level nodes, and escape them, then we can unescape the whole thing.
        for (node in xml)
        {
            if (node.isElement())
            {
                for (att in node.attributes())
                {
                    node.setAttr(att, node.attr(att).htmlEscape());
                }
            }
        }
        var html = xml.html().htmlUnescape();

        return { template: html, fields: fieldsToAdd };
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
    
    static function processPartialDeclarations(node:dtx.DOMNode, wholeTemplate:dtx.DOMCollection)
    {
        // Remove the partial from the template

        // Due to the way template.parse() works, if the partial's parent is on the top level
        // (ie. a sibling to your <html>) then node.removeFromDOM() won't remove it from wholeTemplate,
        // because wholeTemplate is a collection that includes all top level elements.  Weird, I know!
        // Anyway, the workaround is to remove it from the collection as well.
        if (node.parent == wholeTemplate.getNode(0).parent)
        {
            wholeTemplate.removeFromCollection(node);
        }
        node.removeFromDOM();

        // Create a class for this partial

        var p = Context.currentPos();
        var localClass = haxe.macro.Context.getLocalClass();
        var name = node.nodeName;
        var pack = localClass.get().pack;
        // Before getting the partial TPL, let's clear out any whitespace
        for (d in node.descendants(false))
        {
            if (d.isTextNode())
            {
                clearWhitespaceFromTextnode(d);
            }
        }
        var partialTpl = node.innerHTML();

        var className = localClass.get().name + name;
        var classMeta = [{
            pos: p,
            params: [Context.makeExpr(partialTpl, p)],
            name: ":template"
        }];

        // Find out if the type has already been defined
        var existingClass:Null<haxe.macro.Type>;
        try { existingClass = Context.getType(className); }
        catch (e:Dynamic) { existingClass = null; }

        if (existingClass != null)
        {
            switch (existingClass)
            {
                case TInst(t, _):
                    var metaAccess = t.get().meta;
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
            var classKind = TypeDefKind.TDClass({
                sub: null,
                params: [],
                pack: ['dtx','widget'],
                name: "Widget"
            });
            var fields:Array<Field> = [];

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

            haxe.macro.Context.defineType(partialDefinition);
        }
    }

    static function processPartialCalls(node:dtx.DOMNode, wholeTemplate:dtx.DOMCollection, t:Int)
    {
        // Elements beginning with <dtx:SomeTypeName /> or <dtx:my.package.SomeTypeName />
        // May have attributes <dtx:Button text="Click Me" />

        // Generate a name for the partial.  Either take it from the <dtx:MyPartial name="this" /> attribute,
        // or autogenerate one (partial_$t, t++)
        var widgetClass = haxe.macro.Context.getLocalClass();
        var nameAttr = node.attr('dtx-name');
        var name = (nameAttr != "") ? nameAttr : "partial_" + t;
        var p = Context.currentPos();

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
        
        // Replace the call with <div data-dtx-partial="$name"> </div>, the extra space ensures the output passes correctly in browsers
        node.replaceWith("div".create().setAttr("data-dtx-partial", name).setText(' '));

        var pack = [];
        var type = try {
            Context.getType(typeName);
        } catch (e:String) {
            if ( e=="Type not found '" + typeName + "'" ) 
                Context.error('Unable to find Widget/Partial "$typeName" in Widget Template $widgetClass', widgetClass.get().pos);
            else throw e;
        }

        // Alternatively use: type = Context.typeof(macro new $typeName()), see what works
        switch (type)
        {
            case TInst(t,_):
                // get the type
                var classType = t.get();
                pack = classType.pack;
            default: 
                throw "Asked for partial " + typeName + " but that doesn't appear to be a class";
        }

        // Set up a public field in the widget, public var $name(default,set_$name):$type
        var propType = TPath({
            sub: null,
            params: [],
            pack: pack,
            name: typeName
        });
        var prop = BuildTools.getOrCreateProperty(name, propType, false, true);
        var variableRef = name.resolve();
        var typeRef = typeName.resolve();

        // Add some lines to the setter
        var selector = ("[data-dtx-partial='" + name + "']").toExpr();
        var linesToAdd = macro {
            // Either replace the existing partial, or if none set, replace the <div data-dtx-partial='name'/> placeholder
            var toReplace = ($variableRef != null) ? $variableRef : dtx.collection.Traversing.find(this, $selector);
            dtx.collection.DOMManipulation.replaceWith(toReplace, v);
        }
        BuildTools.addLinesToFunction(prop.setter, linesToAdd, 0);

        // Now that we can set it via the property setter, we do so in our constructor.
        // With something like:
        // 
        // $name = new $type()
        // $name.var1 = var1
        // $name.var2 = var2
        // this.find("[data-dtx-partial=$name]").replaceWith($name)
        //
        // So that'll end up looking like:
        //
        // public function new() {
        //   var btn = new Button();
        //   btn.text = "Click Me!";
        //   partial_1 = btn;
        // }

        // Get the constructor, instantiate our partial
        var constructor = BuildTools.getOrCreateField(getConstructorTemplate());
        linesToAdd = macro {
            $variableRef = new $typeName();
        };
        BuildTools.addLinesToFunction(constructor, linesToAdd);

        // Set any variables for the partial
        for (attName in node.attributes())
        {
            if (attName != "dtx-name")
            {
                var propertyRef = (name + "." + attName).resolve();
                var valueExpr = node.attr(attName).toExpr();
                linesToAdd = macro {
                    $propertyRef = $valueExpr;
                };
                BuildTools.addLinesToFunction(constructor, linesToAdd);
            }
        }
    }

    static function getConstructorTemplate()
    {
        var constructorBody = macro { super(); }
        return {
            pos: Context.currentPos(),
            name: "new",
            meta: [],
            kind: FieldType.FFun({
                    ret: null,
                    params: [],
                    expr: constructorBody,
                    args: []
                }),
            doc: "",
            access: [APublic]
        }
    }

    static function processAttributes(node:dtx.DOMNode)
    {
        // A regular element
        for (attName in node.attributes())
        {
            if (attName.startsWith('dtx-on-'))
            {
                // this is not a boolean, does it need to be processed separately?
            }
            else if (attName == 'dtx-loop')
            {
                // loop this element...
            }
            else if (attName == 'dtx-value')
            {
                // Every time the value changes, change this.
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
                if (node.get(attName).indexOf('$') > -1)
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
                name: "DOMCollection"
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
                default: 
            }
        }
    }

    static var uniqueDtxID:Int = 0;
    
    /** Get a unique selector for the node, creating a data attribute if necessary */
    static function getUniqueSelectorForNode(node:dtx.DOMNode):Expr
    {
        var selector:String;

        if (node.attr("data-dtx-id") != "") 
        {
            // If the element has data-dtx-id, use that
            selector = "[data-dtx-id=\'" + node.attr("data-dtx-id") + "\']";
        }
        else
        {
            // If not, create data-dtx-id=ID, use that
            node.setAttr("data-dtx-id", Std.string(uniqueDtxID));
            selector = "[data-dtx-id=\'" + node.attr("data-dtx-id") + "\']";
            uniqueDtxID++;
        } 

        var selectorTextAsExpr = Context.makeExpr(selector, Context.currentPos());
        var selectorExpr:Expr;
        if (isTopLevelElement(node))
        {
            var indexInCollection = node.parent.indexOf(node).toExpr();
            selectorExpr = (node.parent.count() == 1) ? macro this : macro dtx.collection.Traversing.find(dtx.collection.Traversing.parent(this), $selectorTextAsExpr);
        }
        else 
        {
            selectorExpr = macro dtx.collection.Traversing.find(this, $selectorTextAsExpr);
        }

        return selectorExpr;
    }

    static function interpolateAttributes(node:dtx.DOMNode, attName:String)
    {
        var selectorExpr = getUniqueSelectorForNode(node);

        var nameAsExpr = Context.makeExpr(attName, Context.currentPos());

        var result = processVariableInterpolation(node.attr(attName));
        var interpolationExpr = result.expr;
        var variablesInside = result.variablesInside;

        // Set up bindingExpr
        //var bindingExpr = macro this.find($selectorAsExpr).setAttr($nameAsExpr, $interpolationExpr);
        var bindingExpr = macro dtx.collection.ElementManipulation.setAttr($selectorExpr, $nameAsExpr, $interpolationExpr);
        
        // Go through array of all variables again
        addExprToAllSetters(bindingExpr, variablesInside, true);
    }

    static function interpolateTextNodes(node:dtx.DOMNode)
    {
        // Get (or set) ID on parent, get selector
        var selectorAsExpr = getUniqueSelectorForNode(node.parent);
        var index = node.index();
        var indexAsExpr = index.toExpr();
        
        var result = processVariableInterpolation(node.text());
        var interpolationExpr = result.expr;
        var variablesInside = result.variablesInside;

        // Set up bindingExpr
        //var bindingExpr = macro this.children(false).getNode($indexAsExpr).setText($interpolationExpr);
        var bindingExpr = macro dtx.single.ElementManipulation.setText(dtx.collection.Traversing.children($selectorAsExpr, false).getNode($indexAsExpr), $interpolationExpr);
        
        // Add binding expression to all setters.  
        addExprToAllSetters(bindingExpr, variablesInside, true);

        // Initialise variables
        addExprInitialisationToConstructor(variablesInside);
    }

    static function addExprToAllSetters(expr:Expr, variables:Array<String>, ?prepend)
    {
        if (variables.length == 0)
        {
            // Add it to the constructor instead
            var constructor = BuildTools.getOrCreateField(getConstructorTemplate());
            BuildTools.addLinesToFunction(constructor, expr);
        }

        for (varName in variables)
        {
            // Add bindingExpr to every setter.  Add at position `1`, so after the first line, which should be 'this.field = v;'
            var prop = BuildTools.getField(varName);
            var setter = BuildTools.getSetterFromField(prop);
            BuildTools.addLinesToFunction(setter, expr, 1);
        }
    }

    static function addExprInitialisationToConstructor(variables:Array<String>)
    {
        for (varName in variables)
        {
            // Initialise strings as empty, everything else as null.
            var field = varName.getField();
            switch (field.kind)
            {
                case FProp(get,set,type,e):
                    switch (type)
                    {
                        case TPath(path):
                            var typeName = path.name;
                            var constructor = BuildTools.getOrCreateField(getConstructorTemplate());
                            var varRef = varName.resolve();
                            var expr:Expr;
                            switch (typeName) {
                                case "Bool": 
                                    expr = macro false;
                                case "String": 
                                    expr = macro "";
                                case "Int": 
                                    expr = macro 0;
                                case "Float": 
                                    expr = macro 0;
                                default: 
                                    expr = macro null;
                            }
                            var setExpr = macro $varRef = $expr;
                            BuildTools.addLinesToFunction(constructor, setExpr);
                            if (e == null) {
                                // If the init expression was null, use a a different one
                                field.kind = FProp(get,set,type,expr);
                            }
                        default:
                    }
                default:
            }
        }
    }

    static function processVariableInterpolation(string:String):{ expr:Expr, variablesInside:Array<String> }
    {
        var stringAsExpr = Context.makeExpr(string, Context.currentPos());
        var interpolationExpr = Format.format(stringAsExpr);
        
        // Get an array of all the variables in interpolationExpr
        var variables:Array<ExtractedVarType> = extractVariablesUsedInInterpolation(interpolationExpr);
        var variableNames:Array<String> = [];

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

                    if (BuildTools.fieldExists("print_" + varName))
                    {
                        // If yes, in interpolationExpr replace calls to $name with print_$name($name)
                        var fn = BuildTools.getField("print_" + varName);

                        var exprToLookFor = EConst(CIdent(varName));
                        var functionName = "print_" + varName;
                        var functionNameExpr = functionName.resolve();
                        var exprToReplaceWith = macro $functionNameExpr();

                        // Use tink_macros' transform() to look for the old expression and replace it
                        interpolationExpr.transform(function (oldExpr) {
                            if (Type.enumEq(oldExpr.expr, exprToLookFor))
                            {
                                return {
                                    expr: exprToReplaceWith.expr,
                                    pos: oldExpr.pos
                                };
                            }
                            else 
                            {
                                return oldExpr;
                            }
                        });
                    }
                    variableNames.push(varName);
                case Call(varName):
                    variableNames.push(varName);
                case Field(varName):
                    interpolationExpr = macro (($i{varName} != null) ? $interpolationExpr : "");
                    variableNames.push(varName);
            }
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
                                            if ( varName.fieldExists() )
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
                    trueStatement = macro dtx.collection.ElementManipulation.removeClass($selector, $className);
                    falseStatement = macro dtx.collection.ElementManipulation.addClass($selector, $className);
                case "dtx-hide":
                    var className = "hidden".toExpr();
                    trueStatement = macro dtx.collection.ElementManipulation.addClass($selector, $className);
                    falseStatement = macro dtx.collection.ElementManipulation.removeClass($selector, $className);
                case "dtx-enabled":
                    trueStatement = macro dtx.collection.ElementManipulation.removeAttr($selector, "disabled");
                    falseStatement = macro dtx.collection.ElementManipulation.setAttr($selector, "disabled", "disabled");
                case "dtx-disabled":
                    trueStatement = macro dtx.collection.ElementManipulation.setAttr($selector, "disabled", "disabled");
                    falseStatement = macro dtx.collection.ElementManipulation.removeAttr($selector, "disabled");
                case "dtx-checked":
                    trueStatement = macro dtx.collection.ElementManipulation.setAttr($selector, "checked", "checked");
                    falseStatement = macro dtx.collection.ElementManipulation.removeAttr($selector, "checked");
                case "dtx-unchecked":
                    trueStatement = macro dtx.collection.ElementManipulation.removeAttr($selector, "checked");
                    falseStatement = macro dtx.collection.ElementManipulation.setAttr($selector, "checked", "checked");
                default:
                    if (attName.startsWith('dtx-class-'))
                    {
                        // add a class
                        var className = attName.substring(10);
                        var classNameAsExpr = className.toExpr();
                        trueStatement = macro dtx.collection.ElementManipulation.addClass($selector, $classNameAsExpr);
                        falseStatement = macro dtx.collection.ElementManipulation.removeClass($selector, $classNameAsExpr);
                    }
                    else
                    {
                        wasDtxAttr = false; // didn't match, set back to false
                    }
            }
        }

        if (wasDtxAttr)
        {
            // Get setter parts, add statements, remove our dtx-* attribute
            var booleanName = node.attr(attName);
            var setterParts = getBooleanSetterParts(booleanName);
            BuildTools.addLinesToBlock(setterParts.trueBlock, trueStatement);
            BuildTools.addLinesToBlock(setterParts.falseBlock, falseStatement);
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