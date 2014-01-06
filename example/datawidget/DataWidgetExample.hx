import dtx.widget.Widget;
import haxe.crypto.Md5;
using Detox;
using DateTools;

class DataWidgetExample 
{
	static var widget:PersonWidget;

	static public function main()
	{
		Detox.ready( function() {
			var person = generateRandomPerson();
			widget = new PersonWidget();
			widget.p = person;

			var doc = js.Browser.document;
			widget.appendTo( ".container".find() );

			".btn".find().click(function(e) {
				changePerson();
			});
		});
	}

	static public function changePerson()
	{
		var person = generateRandomPerson();
		widget.p = person;
	}

	static function generateRandomPerson()
	{
		var p = new Person();
		switch Random.int( 1, 4 ) {
			case 1:
				p.name = "Jason O'Neil";
				p.email = "jason.oneil@gmail.com";
				p.dob = new Date(1987,9,16,0,0,0);
			case 2:
				p.name = "Barrack Obama";
				p.email = "barrack.obama@whitehouse.gov";
				p.dob = new Date(1961,7,4,0,0,0);
			case 3:
				p.name = "Julia Gillard";
				p.email = "julia.gillard@primeminister.gov.au";
				p.dob = new Date(1961,8,29,0,0,0);
			default:
				p.name = "Jacob Zuma";
				p.email = "jacob.zuma@thepresidency.gov.za";
				p.dob = new Date(1942,3,12,0,0,0);
		}
		return p;
	}
}

class Person 
{
	public var name:String;
	public var email:String;
	public var dob:Date;

	public function new() {}

	public function getAge():Int {
		var ageInSeconds = Date.now().getTime() - dob.getTime();
		return Math.floor(ageInSeconds / 86400 / 365.25 / 1000); // Close enough for a demo ;)
	}

}

class PersonWidget extends Widget
{
	public var p:Person;
}