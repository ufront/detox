package widgets;

import dtx.widget.Widget;

@:template("<p>My name is $name, I am $age years old and I believe in $belief</p>")
class InterpolationBasic extends Widget {}

@:template("<p>My name is $name, I am $age years old and it is $isTall that I am tall</p>")
class InterpolationWithInitialisation extends Widget 
{
	public var name = "Jason";
	public var age = 26;
	public var isTall = true;
}

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

@:template("<p>The SHA of ${3+5} is ${haxe.crypto.Sha1.encode('8')}</p>")
class InterpolationNonVarExpr extends Widget {}

@:template("<p>The word $name is ${name.length} letters long and the first letter is ${name.substr(0,1)}</p>")
class InterpolationComplexExpr extends Widget {
	public var name:String;
}

@:template("<p>Sum = <span>${sum(a,b)}</span></p>")
class InterpolationMemberFunction extends Widget {
	public var a:Int;
	public var b:Int;
	public function sum(x:Int,y:Int) {
		return (x+y);
	}
}

@:template("<p>Max = <span>${Math.max(a,b)}</span></p>")
class InterpolationOutsideFunction extends Widget {
	public var a:Int;
	public var b:Int;
}

@:template("<p>My name is ${person.name} (and my name has ${person.name.length} letters!) and I am ${this.person.age} years old.</p>")
class InterpolationFieldAccess extends Widget {
	public var person:{ name:String, age:Int };
}

@:template("<p>Greet ${person.shortName}: <span>${person.greet('Hello')}</span></p>")
class InterpolationFieldMemberFunction extends Widget {
	public var person:Person;
}

@:template("<p>Your encoded email address is [${StringTools.urlEncode(this.person.email)}]</p>")
class InterpolationFieldAccessAsFunctionArg extends Widget {
	public var person:{ name:String, email:String };
}

@:template("<p>$name, $age and $amITall</p>")
class InterpolationWithPrintFields extends Widget 
{
	public var name:String;
	public var age:Int;
	public var amITall:Bool;

	function print_name() return 'My name is $name';
	function print_age() return 'I am $age years old';
	function print_amITall() return amITall ? "I am tall" : "I am not tall";
}

@:template("<p>First letter is ${name.charAt(0)}, my last birthday was ${Math.floor(age)}<span dtx-show='amITall'> and I am $amITall tall</span>.</p>")
class InterpolationWithPrintFieldsComplex extends Widget 
{
	public var name:String;
	public var age:Float;
	public var amITall:Bool;

	function print_name() return 'DoNotPrint';
	function print_age() return 'DoNotPrint';
	function print_amITall() return amITall ? "definitely" : "not";
}

class Person {

	public var firstName:String;
	public var lastName:String;
	public var shortName(get,null):String;

	public function new(f,l) {
		firstName = f;
		lastName = l;
	}

	public function get_shortName() {
		return firstName.substr(0,1) + ". " + lastName;
	}

	public function greet(salutation:String) {
		return '$salutation $firstName';
	}
}