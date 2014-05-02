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

package dtx.collection;

class ElementManipulation
{
	/** Find the index of the node relevent to it's siblings.  First child of parent has an index of 0.  When operating on a collection, this returns the index of the first element. */
	public static function index(q:dtx.DOMCollection):Int 
	{
		return (q != null) ? dtx.single.ElementManipulation.index(q.getNode()) : -1;
	}

	/** Assume we're operating on the first element. */
	public static function attr(collection:DOMCollection, attName:String):String
	{
		return (collection != null && collection.length > 0) ? dtx.single.ElementManipulation.attr(collection.getNode(), attName) : "";
	}

	public static function setAttr<T:DOMCollection>(collection:T, attName:String, attValue:String):T
	{
		if (collection != null)
		{
			for (node in collection)
			{
				dtx.single.ElementManipulation.setAttr(node, attName, attValue);
			}
		}
		return collection;
	}

	public static function removeAttr<T:DOMCollection>(collection:T, attName:String):T
	{
		if (collection != null)
		{
			for (node in collection)
			{
				dtx.single.ElementManipulation.removeAttr(node,attName);
			}
		}
		return collection;
	}

	/** Checks if every element in the collection has the given class */
	public static function hasClass(collection:DOMCollection, className:String):Bool
	{
		var result = false;

		if (collection != null && collection.length > 0)
		{
			// If there's at least one result, we'll begin with "true"
			// and loop around and see if it gets switched to "false"
			result = true;

			for (node in collection)
			{
				if (dtx.single.ElementManipulation.hasClass(node, className) == false)
				{
					result = false;
					break;
				}
			}
		}

		return result;
	}

	public static function addClass<T:DOMCollection>(collection:T, className:String):T
	{
		if (collection != null)
		{
			for (node in collection)
			{
				dtx.single.ElementManipulation.addClass(node,className);
			}
		}
		return collection;
	}

	public static function removeClass<T:DOMCollection>(collection:T, className:String):T
	{
		if (collection != null)
		{
			for (node in collection)
			{
				dtx.single.ElementManipulation.removeClass(node,className);
			}
		}
		return collection;
	}

	public static function toggleClass<T:DOMCollection>(collection:T, className:String):T
	{
		if (collection != null)
		{
			for (node in collection)
			{
				dtx.single.ElementManipulation.toggleClass(node,className);
			}
		}
		return collection;
	}

	public static inline function tagName(collection:DOMCollection):String
	{
		return (collection != null && collection.length > 0) ? dtx.single.ElementManipulation.tagName(collection.getNode()) : "";
	}

	public static function val(collection:DOMCollection):String
	{
		return (collection != null && collection.length > 0) ? dtx.single.ElementManipulation.val(collection.getNode()) : "";
	}

	public static function setVal<T:DOMCollection>(collection:T, val:Dynamic):T
	{
		var value = Std.string(val);
		if (collection != null)
		{
			for (node in collection)
			{
				dtx.single.ElementManipulation.setVal(node, value);
			}
		}
		return collection;
	}
	
	public static function text(collection:DOMCollection):String
	{
		var text = "";
		if (collection != null)
		{
			for (node in collection)
			{
				text = text + dtx.single.ElementManipulation.text(node);
			}
		}
		return text;
	}
	
	public static function setText<T:DOMCollection>(collection:T, text:String):T
	{
		if (collection != null)
		{
			for (node in collection)
			{
				dtx.single.ElementManipulation.setText(node,text);
			}
		}
		return collection;
	}

	public static function innerHTML(collection:DOMCollection):String
	{
		var sb = new StringBuf();
		if (collection != null)
		{
			for (node in collection)
			{
				sb.add( dtx.single.ElementManipulation.innerHTML(node) );
			}
		}
		return sb.toString();
	}

	public static function setInnerHTML<T:DOMCollection>(collection:T, html:String):T
	{
		if (collection != null)
		{
			for (node in collection)
			{
				dtx.single.ElementManipulation.setInnerHTML(node,html);
			}
		}
		return collection;
	}

	public static inline function html(collection:DOMCollection):String
	{
		var sb = new StringBuf();
		if (collection != null)
		{
			for (node in collection)
			{
				sb.add( dtx.single.ElementManipulation.html(node) );
			}
		}
		return sb.toString();
	}

}
