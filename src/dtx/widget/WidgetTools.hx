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
import haxe.macro.Type;
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

                // Add the extra lines to the constructor

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
    static function loadTemplate(localClass:Null<Ref<ClassType>>):String
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

    static function setupBindingVariables(c:ClassType):Array<Expr>
    {
        var p = Context.currentPos();
        var bindings = new Array();

        for (f in c.fields.get())
        {
            var varValue = ("o." + f.name).resolve();
            var expr = f.name.define(varValue);
            bindings.push(expr);
        }

        return bindings;
    }

    static function processTemplate(template:String):{ template:String, bindings:Array<Expr>, fields:Array<Field> }
    {
        // Get every node (including descendants)
        var p = haxe.macro.Context.currentPos();
        var xml = template.parse();
        var allNodes = new dtx.DOMCollection();
        allNodes.addCollection(xml);
        allNodes.addCollection(xml.descendants(false));

        var fieldsToAdd = new Array<Field>();
        var t=0; // Used to create name if none given, eg partial_4:DOMCollection

        for (node in allNodes)
        {
            if (node.isElement() && node.tagName().startsWith('_'))
            {
                // This is a partial declaration <_MyPartial>template</_MyPartial>
                processPartialDeclarations(node, xml);
            }
            else if (node.isElement() && node.tagName().startsWith('dtx:'))
            {
                // This is a partial call.  <dtx:_MyPartial /> or <dtx:widgets.SomePartial /> etc
                t++;
                processPartialCalls(node, xml, t);
            }
        }

        /*
        - for each loop
          - if not set, set attr(data-loop-id, t); t++;
          - take HTML, and create a new subwidget (as a class? or use a factory? eg PersonWidget.newLoop(1))
          - get the type parameter (T) of the Iterable.  eg String in Array<String>
          - create a class for the subwidget, take html
          - recurse on this macro for the subwidget.
        */

        /*
        - for each attribute, text node
          - search for "$" (but not "$$")
          - if found
              - if not set, set attr(data-bind, i); i++;
              - do string interpolation using modified Std.format(), get ("mailto:" + email)
              - add binding to bind(), using find([data-bind=i]) and setAttr() or setText()
        */

        var bindingExpressions = new Array<Expr>();
        var toAddToConstructor = new Array<Expr>();

        var t = 0;
        for (node in allNodes)
        {
            t++;
            switch (node.nodeType)
            {
                case Xml.Element:
                    // // Set up bindings for each attribute value
                    // for (att in node.attributes())
                    // {
                    //     var str = node.attr(att);
                    //     if (str.indexOf('$') > -1)
                    //     {
                    //         node.setAttr('data-binding',Std.string(t));
                    //         var stringAsExpr = Context.makeExpr(str, Context.currentPos());
                    //         var nameAsExpr = Context.makeExpr(att, Context.currentPos());
                    //         var identifierAsExpr = Context.makeExpr(Std.string(t), Context.currentPos());
                    //         var interpolationExpr = Format.format(stringAsExpr);
                    //         var bindingExpr = macro this.find('[data-binding="' + $identifierAsExpr + '"]').setAttr($nameAsExpr, $interpolationExpr);
                    //         bindingExpressions.push(bindingExpr);
                    //     }
                    // }
                default:
                    // // Set up bindings for the text content...
                    // var str = node.text();
                    // if (str.indexOf('$') > -1)
                    // {
                    //     // Will need to get nearest element + index, so we can do:
                    //     // "nearestElm".find().children(false).get(index).setText();
                    //     var parent = node.parent;
                    //     if (parent.exists('data-binding') == false)
                    //     {
                    //         parent.setAttr('data-binding', Std.string(t));
                    //     }
                    //     var indexOfTextNode = Lambda.indexOf(parent.children(false), node);

                    //     var stringAsExpr = Context.makeExpr(str, Context.currentPos());
                    //     var identifierAsExpr = Context.makeExpr(parent.attr('data-binding'), Context.currentPos());
                    //     var indexAsExpr = Context.makeExpr(indexOfTextNode, Context.currentPos());
                    //     var interpolationExpr = Format.format(stringAsExpr);
                    //     var bindingExpr = macro this.find('[data-binding="' + $identifierAsExpr + '"]').getNode($indexAsExpr).setText($interpolationExpr);
                    //     bindingExpressions.push(bindingExpr);
                    // }
            }
        }

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
        
        // Replace the call with <div data-partial="$name"> </div>, the extra space ensures the output passes correctly in browsers
        node.replaceWith("div".create().setAttr("data-partial", name).setText(' '));

        // Set up a public field in the widget, public var $name:$type
        var propType = TPath({
            sub: null,
            params: [],
            pack: ["dtx"],
            name: "DOMCollection"
        });

        // propertyName, propertyType, useGetter, useSetter
        var prop = BuildTools.getOrCreateProperty(name, propType, false, true);
        var variableRef = name.resolve();
        var typeRef = typeName.resolve();

        // Add some lines to the setter
        var selector = ("[data-partial='" + name + "']").toExpr();
        var linesToAdd = macro {
            // Either replace the existing partial, or if none set, replace the <div data-partial='name'/> placeholder
            var toReplace = ($variableRef != null) ? $variableRef : dtx.collection.Traversing.find(this, $selector);
            dtx.collection.DOMManipulation.replaceWith(toReplace, v);
        }
        BuildTools.addLinesToFunction(prop.setter, linesToAdd, true);


        // Get the constructor, add lines to it
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

        // $name = new $type()
        // $name.var1 = var1
        // $name.var2 = var2
        // this.find("[data-partial=$name]").replaceWith($name)
        //
        // So that'll end up looking like
        //
        // public function new() {
        //   var btn = new Button();
        //   btn.text = "Click Me!";
        //   this.find("[data-partial=btn]").replaceWith(btn);
        // }

        // Replace with <div data-partial="partial_XX" /> (or custom partial name)
        // Find parent widget
            // add property var partial_XX(default,get_partial_XX):DOMCollection;
            // add private method get_partial_XX(p)
            // {
            //     partial_XX.replaceWith(p); // if length is greater than 1, may have to do something custom here
            //     partial_XX = p;
            // }
            // Find initiatePartials() method of the parent Widget
                // add the line
                // partial_XX = new Button();
                // partial_XX.text = "Click Me"
    }

    static function processTemplateVariables()
    {
        // Go through every node
            // For each attribute
                // If has variable
                // processVariableInterpolation()
                // 
            // For each text node
                // If has variable
                // processVariableInterpolation()
    }

    static function processVariableInterpolation(string:String, callToChangeText:Expr)
    {
        // string is the attribute text or textnode text
        // callToChangeText is an expr, eg. this.find("something").setAttr("value", "CHANGETHIS");
            // We will take this expr, change the last argument to interpolate the variables

        // Run Std.format() on the string
        // Check which variables are in the resulting expression
        // For each variable
            // If the Widget has a property for it already
                // Append a new line to set_myproperty():
                // callToChangeText(), but with the expr returned by Std.format

        // This means, 
        // Every time any relevant property is set, the rule will be updated
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