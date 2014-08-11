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

using Detox;

#if !macro @:autoBuild(dtx.widget.WidgetTools.buildWidget()) #end
class Widget extends DOMCollection
{
	/**
		When creating widgets, we can cache the created widget when we parse it, and then clone it for each new widget.

		This should be significantly faster than parsing it each time.  You can disable this if your use case involves many widgets only used a single time, in which case this may not be worth the performance.
	**/
	public static var useCache = true;
	static var cache:Map<String,Array<DOMNode>> = new Map();

	var _dtxWidgetNodeIndex:Array<DOMNode>;

	/** Create a new widget by parsing some "template" html, and use that as our collection.
	When your class extends this, it will automatically work with the dtx API (through using).
	Therefore your class can have very tight integration between haxe features and the DOM. */
	public function new() {
		super();

		// Parse the template (or clone a cached copy)
		var name = Type.getClassName( Type.getClass(this) );
		if ( useCache && cache.exists(name) ) {
			for ( n in cache[name] ) this.collection.push( n.clone() );
		}
		else {
			var c = Detox.parse( get_template() );
			this.collection = c.collection;
			if ( useCache ) cache[name] = [ for (n in c.collection) n.clone() ];
		}


		// Initialize the widget/node index of nodes that need to be referenced
		_dtxWidgetNodeIndex = [];
		for ( n in this.collection.concat(this.descendants().collection) ) {
			if ( n.isElement() ) {
				var att = n.attr("data-dtx-id");
				if ( att!="" ) {
					_dtxWidgetNodeIndex[Std.parseInt(att)] = n;
					n.removeAttr("data-dtx-id");
				}
			}
		}

		// Run init(), which will create all of our partials etc
		init();
	}

	/** Override this method in your subclass to get template some other way.  Using detox
	templating will automatically override this method. */
	function get_template() {
		return "";
	}

	/** When using widgets, the macros will use init() to initialize any variables or partials.

	This runs at the end of dtx.widget.Widget's constructor, and so after you call "super()" on your
	widget it will be safe to use any of your partials, named nodes etc.  You can do your own initialisation
	logic in here if you wish, but be warned the nodes will be present but only half ready.  */
	function init() {}

	/** You can either map an Input, and we'll try to match each field on the input with a field on the
	widget.  Or you can do a propMap, like propMap = { templateVarA = myValue, templateVarB = getBValue() }*/
	public function mapData( input:Dynamic ) {
		if (input != null) {
			var fieldNames:Array<String>;
			switch (Type.typeof(input)) {
				case TObject:
					// Anonymous object, use Reflect.fields()
					fieldNames = Reflect.fields(input);
				case TClass(c):
					// Class instance, use Type.getInstanceFields()
					fieldNames = Type.getInstanceFields(c);
				default:
					// This is not an object, so don't do property mapping
					fieldNames = [];
			}

			for (fieldName in fieldNames) {
				var modelValue = Reflect.getProperty(input, fieldName);
				if ( !Reflect.isFunction(modelValue) )
					Reflect.setProperty(this, fieldName, modelValue);
			}
		}
	}
}
