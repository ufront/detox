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

/**
	This class provides static helper methods to interact with all nodes and elements in a `dtx.DOMCollection`.

	This class is intended to be used with static extension, by placing `using Detox;` in the imports for your module.
	Each of these methods will then operate on DOMCollections as if they were methods on the DOMCollection object itself.
	Any method which does not retrieve a specific value will return the original collection, allowing method chaining.
	Each method is null-safe, if a collection is empty or null it will have no effect.
**/
class ElementManipulation
{
	/** Run `dtx.single.ElementManipulation.index` for the first node in the collection. **/
	public static function index(c:dtx.DOMCollection):Int
	{
		return (c != null) ? dtx.single.ElementManipulation.index(c.getNode()) : -1;
	}

	/** Run `dtx.single.ElementManipulation.attr` for the first node in the collection. **/
	public static function attr(collection:DOMCollection, attName:String):String
	{
		return (collection != null) ? dtx.single.ElementManipulation.attr(collection.getNode(), attName) : "";
	}

	/** Run `dtx.single.ElementManipulation.setAttr` for each node in the collection. **/
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

	/** Run `dtx.single.ElementManipulation.removeAttr` for each node in the collection. **/
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

	/**
		Checks if every node in the collection is an element and has the specified class or classes.

		@param collection The DOMCollection to check.  Each node in the collection will be checked.
		@param className One of more class names (seperated by whitespace) to check for.
		@return True if every node contains every class name, false otherwise.
	**/
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

	/** Run `dtx.single.ElementManipulation.addClass` for each node in the collection. **/
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

	/** Run `dtx.single.ElementManipulation.removeClass` for each node in the collection. **/
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

	/** Run `dtx.single.ElementManipulation.toggleClass` for each node in the collection. **/
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

	/** Run `dtx.single.ElementManipulation.tagName` for the first node in the collection. **/
	public static inline function tagName(collection:DOMCollection):String
	{
		return (collection != null) ? dtx.single.ElementManipulation.tagName(collection.getNode()) : "";
	}

	/** Run `dtx.single.ElementManipulation.val` for the first node in the collection. **/
	public static function val(collection:DOMCollection):String
	{
		return (collection != null) ? dtx.single.ElementManipulation.val(collection.getNode()) : "";
	}

	/** Run `dtx.single.ElementManipulation.setVal` for each node in the collection. **/
	public static function setVal<T:DOMCollection>(collection:T, value:String):T
	{
		if (collection != null)
		{
			for (node in collection)
			{
				dtx.single.ElementManipulation.setVal(node, value);
			}
		}
		return collection;
	}

	/**
		Use `dtx.single.ElementManipulation.text` to get the text value for each node in the collection.

		@param The collection of nodes to operate on.
		@return A concatenated string containing the combined text value for each node in the collection.
	**/
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

	/**
		Run `dtx.single.ElementManipulation.setText` for each node in the collection.

		If there are multiple nodes in the collection, they will each be set to this text value.
	**/
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

	/**
		Use `dtx.single.ElementManipulation.innerHTML` to get the inner HTML for each node in the collection.

		@param The collection of nodes to operate on.
		@return A concatenated string containing the combined inner HTML value for each node in the collection.
	**/
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

	/**
		Run `dtx.single.ElementManipulation.setText` for each node in the collection.

		If there are multiple nodes in the collection, they will each be set to use this inner HTML.
	**/
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

	/**
		Use `dtx.single.ElementManipulation.html` to get the inner HTML for each node in the collection.

		@param The collection of nodes to operate on.
		@return A concatenated string containing the HTML value for each node in the collection.
	**/
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
