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