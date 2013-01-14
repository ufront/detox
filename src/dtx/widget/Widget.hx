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

import dtx.DOMCollection;
import dtx.widget.WidgetTools;

@:autoBuild(dtx.widget.WidgetTools.buildWidget()) class Widget extends DOMCollection
{
	/** Create a new widget by parsing some "template" html, and use that as our collection.
	When your class extends this, it will automatically work with the dtx API (through using).  
	Therefore your class can have very tight integration between haxe features and the DOM. */
	public function new()
	{
		super();

		// If get_template() hasn't been overridden by a subclass (or a macro) then
		// this allows us to set the template by passing one in.
		var q = Detox.parse(get_template());
		this.collection = q.collection;
	}
	
	/** Override this method in your subclass to get template some other way.  Using detox 
	templating will automatically override this method. */
	function get_template()
	{
		return "";
	}

	/** When using widgets, this runs immediately after all partials and variables have been initialised.

	When using Widget templates, the partials are initialised at the end of the
	constructor, so you can't do anything with them in the constructor, they're still
	null at that point.  Override this function to work with your partials immediately
	after they are initialised. */
	function init()
	{

	}
}