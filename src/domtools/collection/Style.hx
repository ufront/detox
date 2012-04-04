/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools.collection;

class Style
{
	
	public static function setCSS(collection:Query, property:String, value:String)
	{
		for (node in collection)
		{
			domtools.single.Style.setCSS(node, property, value);
		}
	}
}