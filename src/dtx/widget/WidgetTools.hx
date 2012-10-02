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

package dtx.widget;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Format;
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
    *  - Metadata in the form: @template("<div></div>") class MyWidget ...
    *  - Metadata in the form: @loadTemplate("MyWidgetTemplate.html") class MyWidget ...
    *  - Take a guess at a filename... use current filename, but replace ".hx" with ".html"
    * Once it finds it, it overrides the get_template() method, and makes it return
    * the correct template as a String constant.  So each widget gets its own template
    */
    @:macro public static function buildWidget():Array<Field>
    {
        var widgetPos = Context.currentPos();                   // Position where the original Widget class is declared
        var localClass = haxe.macro.Context.getLocalClass();    // Class that is being declared
        var fields = BuildTools.getFields();
        
        // If get_template() already exists, don't recreate it
        if (fields.exists(function (f) { return f.name == "get_template"; }) == false)
        {
            // Load the template
            var template = loadTemplate(localClass);

            if (template != null)
            {
                // Process the template looking for partials, variables etc
                // This function processes the template, and returns any binding statements
                // that may be needed for bindings / variables etc.
                var fnBody = new Array<Expr>();
                var result = processTemplate(template);
                for (expr in result.bindings)
                {
                    fnBody.push(expr);
                }
                fields.push(createField_refresh(fnBody, false));

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
    * This build macro runs on every subclass of DataWidget.
    * It trsfd
    */
    // @:macro public static function buildDataWidget():Array<Field>
    // {
    //     var p = Context.currentPos();                           // Position where the original Widget class is declared
    //     var localClass = haxe.macro.Context.getLocalClass();    // Class that is being declared
    //     var fields = haxe.macro.Context.getBuildFields();

    //     var dataType = localClass.get().superClass.params[0];

    //     // If get_template() already exists, don't recreate it
    //     if (fields.exists(function (f) { return f.name == "get_template"; }) == false)
    //     {
    //         // Load the template
    //         var template = loadTemplate(localClass);
    //         var fnBody = new Array<Expr>();

    //         // Collect all the statements we use
    //         switch (dataType)
    //         {
    //             case TInst(t,params):
    //                 var dataClass = t.get();
    //                 for (expr in setupBindingVariables(dataClass))
    //                 {
    //                     fnBody.push(expr);
    //                 }
    //             default:
    //                 haxe.macro.Context.error("DataWidget can only have a class instance as a type parameter", p);

    //         }
    //         var result = processTemplate(template);
    //         for (expr in result.bindings)
    //         {
    //             fnBody.push(expr);
    //         }
            
    //         // Create the get_template() field and the refresh() field
    //         fields.push(createField_refresh(fnBody, true));
    //         fields.push(createField_get_template(result.template, p));
    //     }


    //     return fields;
    // }

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
        var template = BuildTools.getClassMetadata_String("template");
        if (template == null)
        {
            // Get the template file if declared in metadata
            var templateFile = BuildTools.getClassMetadata_String("loadTemplate");
            if (templateFile == null)
            {
                // If there is no metadata for the template, look for a file in the same 
                // spot but with ".html" instead of ".hx" at the end.
                templateFile = className.replace(".", "/") + ".html";
            }

            // Attempt to load the file
            try 
            {
                template = neko.io.File.getContent(Context.resolvePath(templateFile));
            } 
            catch( e : Dynamic ) 
            {
                try 
                {
                    // That was searching by fully qualified classpath, but try just the same folder....
                    var file = Std.string(localClass);  // eg. my.pack.Widget
                    var arr = file.split(".");          // eg. [my,pack,Widget]
                    arr.pop();                          // eg. [my,pack]
                    var path = arr.join("/");           // eg. my/pack

                    path = (path.length > 0) ? path + "/" : "./"; // add a trailing slash, unless we're on the current directory
                    template = neko.io.File.getContent(Context.resolvePath(path + templateFile));
                }
                catch (e : Dynamic)
                {
                    // If it fails, give an error message at compile time
                    var errorMessage = "Could not load the widget template: " + templateFile;
                    Context.warning(errorMessage, p);
                    template = null;
                }
            }
        }
        return template;
    }
    
    static function createField_get_template(template:String, widgetPos:Position):Field
    {
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

    // static function setupBindingVariables(c:ClassType):Array<Expr>
    // {
    //     var p = Context.currentPos();
    //     var bindings = new Array();

    //     for (f in c.fields.get())
    //     {
    //         var varValue = ("o." + f.name).resolve();
    //         var expr = f.name.define(varValue);
    //         bindings.push(expr);
    //     }

    //     return bindings;
    // }

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

    static function processTemplate(template:String):{ template:String, bindings:Array<Expr>, fields:Array<Field> }
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
                // A regular element

                for (attName in node.attributes())
                {
                    // look for special attributes eg <ul dtx-show="hasItems" />
                    processDtxAttributes();

                    // look for variable interpolation eg <div id="person_$name">...</div>
                    if (node.get(attName).indexOf('$') > -1)
                    {
                        interpolateAttributes(node, attName);
                    }
                }

            }
            else if (node.isTextNode())
            {
                // look for variable interpolation eg "Welcome back, $name..."
                if (node.text().indexOf('$') > -1)
                {
                    interpolateTextNodes(node);
                }
            }
        }

        var bindingExpressions = new Array<Expr>();
        var toAddToConstructor = new Array<Expr>();

        return { template: xml.html(), bindings: bindingExpressions, fields: fieldsToAdd };
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

        var localClass = haxe.macro.Context.getLocalClass();
        var name = node.nodeName;
        var partialTpl = node.innerHTML();
        var pack = localClass.get().pack;
        var p = Context.currentPos();

        var className = localClass.get().name + name;
        var classKind = TypeDefKind.TDClass({
            sub: null,
            params: [],
            pack: ['dtx','widget'],
            name: "Widget"
        });
        var classMeta = [{
            pos: p,
            params: [Context.makeExpr(partialTpl, p)],
            name: "template"
        }];
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

    static function processPartialCalls(node:dtx.DOMNode, wholeTemplate:dtx.DOMCollection, t:Int)
    {
        // Elements beginning with <dtx:SomeTypeName /> or <dtx:my.package.SomeTypeName />
        // May have attributes <dtx:Button text="Click Me" />

        // Generate a name for the partial.  Either take it from the <dtx:MyPartial name="this" /> attribute,
        // or autogenerate one (partial_$t, t++)
        var widgetClass = haxe.macro.Context.getLocalClass();
        var nameAttr = node.attr('name');
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
        var type = Context.getType(typeName);
        // Alternatively use: type = Context.typeof(macro new $typeName()), see what works
        switch (type)
        {
            case TInst(t,params):
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
        var constructorBody = macro { super(); }
        var constructor = BuildTools.getOrCreateField({
            pos: p,
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
        });
        linesToAdd = macro {
            $variableRef = new $typeName();
        };
        BuildTools.addLinesToFunction(constructor, linesToAdd);

        // Set any variables for the partial
        for (attName in node.attributes())
        {
            var propertyRef = (name + "." + attName).resolve();
            var valueExpr = node.attr(attName).toExpr();
            linesToAdd = macro {
                $propertyRef = $valueExpr;
            };
            BuildTools.addLinesToFunction(constructor, linesToAdd);
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
        var selectorExpr = isTopLevelElement(node) ? macro this : macro dtx.collection.Traversing.find(this, $selectorTextAsExpr);
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
        
        // Go through array of all variables again
        addExprToAllSetters(bindingExpr, variablesInside, true);
    }

    static function addExprToAllSetters(expr:Expr, variables:Array<String>, ?prepend)
    {
        for (varName in variables)
        {
            // Add bindingExpr to every setter.  Add at position `1`, so after the first line, which should be 'this.field = v;'
            var prop = BuildTools.getField(varName);
            var setter = BuildTools.getSetterFromField(prop);
            BuildTools.addLinesToFunction(setter, expr, 1);
        }
    }

    static function processVariableInterpolation(string:String):{ expr:Expr, variablesInside:Array<String> }
    {
        var stringAsExpr = Context.makeExpr(string, Context.currentPos());
        var interpolationExpr = Format.format(stringAsExpr);
        
        // Get an array of all the variables in interpolationExpr
        var variables:Array<String> = BuildTools.extractVariablesUsedInInterpolation(interpolationExpr);

        for (varName in variables)
        {
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
                interpolationExpr = interpolationExpr.transform(function (oldExpr) {
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
        }

        return {
            expr: interpolationExpr,
            variablesInside: variables
        };
    }

    static function processDtxAttributes()
    {
        // dtx-value
        // dtx-show
        // dtx-hide
        // dtx-enabled
        // dtx-disabled
        // dtx-checked
        // dtx-unchecked
        // dtx-on-$event 
        // dtx-foreach
    }

    static function createField_refresh(fnBody:Array<Expr>, isOverride:Bool):Field
    {
        var pos = Context.currentPos();
        return { 
            name : "refresh", 
            doc : null, 
            meta : [], 
            access : (isOverride) ? [AOverride, APublic] : [APublic], 
            kind : FFun({ 
                args: [], 
                expr: fnBody.toBlock(), 
                params: [], 
                ret: null 
            }), 
            pos: pos
        }
    }
    #end
}

// for the glory of God