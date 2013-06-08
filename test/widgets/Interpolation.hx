package widgets;

import dtx.widget.Widget;

@:template("<p>My name is $name, I am $age years old and I believe in $belief</p>")
class InterpolationBasic extends Widget {}

@:template("<p>My name is $name, I am $age years old, my birthday is $birthday and I have these pets: $pets. My favourite number is $favouriteNumber, and the statement I just made was $wasTruth</p>")
class InterpolationDifferentTypes extends Widget
{
	public var name:String;
	public var birthday:Date;
	public var age:Int;
	public var pets:Array<String>;
	public var favouriteNumber:Float;
	public var wasTruth:Bool;
}

@:template("<p>The SHA of ${3+5} is ${haxe.crypto.Sha1.encode(3 + 5)}</p>")
class InterpolationComplexExpr extends Widget {}