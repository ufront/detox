package widgets;

import dtx.widget.Widget;

class PartialInSameFile5 extends Widget 
{
	public var name:String;
	public var person:{ id:Int, name:String, over18:Bool };
}

@:partialInside("PartialInSameFile5.html", "_Button")
class PartialInSameFile5_Button extends Widget 
{
	public var big:Bool;
}

@:partialInside("PartialInSameFile5.html", "_Profile")
class PartialInSameFile5_Profile extends Widget 
{
	public var profile:{ id:Int, name:String, over18:Bool };
}