package dtx.layout;

import dtx.Tools;

class DetoxLayoutTools 
{
	public static function addScript(layout:IDetoxLayout, url:String)
	{
		// dtx.collection.DOMManipulation.appendTo( Tools.parse('<script type="text/javascript" src="$url"></script>'), layout.body );
	}

	public static function addInlineScript(layout:IDetoxLayout, script:String)
	{
		// dtx.collection.DOMManipulation.appendTo( Tools.parse(script), layout.body );
	}

	public static function addStylesheet(layout:IDetoxLayout, url:String, ?media:String = "all")
	{
		// var code = '<link rel="stylesheet" type="text/css" href="$url" media="$media" />';
		// dtx.collection.DOMManipulation.appendTo( Tools.parse(code), layout.head );
	}

	public static function doesThisWork(s:String) {
		// return s.toUpperCase();
	}
}