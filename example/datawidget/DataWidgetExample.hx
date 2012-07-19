import dtx.widget.DataWidget;
import dtx.widget.WidgetTools;

using Detox;

class DataWidgetExample 
{
	static public function main()
	{
		var person = generateRandomPerson();
		var pw = new PersonWidget(person);
		trace (pw.html());
	}

	static function generateRandomPerson()
	{
		var a = Math.floor(Math.random() * 4);
		var b = Math.floor(Math.random() * 4);
		var c = Math.floor(Math.random() * 4);
		var d = Math.floor(Math.random() * 4);

		var firstNames = ["Jason", "Barrack", "Julia", "Nelson"];
		var lastNames = ["O'Neil", "Obama", "Gillard", "Mandela"];
		var domains = ["gmail.com", "whitehouse.gov", "primeminister.gov.au", "thepresidency.gov.za"];
		var dates = [
			new Date(1987,9,16,0,0,0),
			new Date(1961,7,4,0,0,0),
			new Date(1961,8,29,0,0,0),
			new Date(1918,6,18,0,0,0)
		];

		var p = new Person();
		p.name = firstNames[a] + " " + lastNames[b];
		p.email = ~/[^a-z0-9]/g.replace(p.name.toLowerCase(), "") + "@" + domains[c];
		p.dob = dates[d];

		return p;
	}
}

class Person 
{
	public var name:String;
	public var email:String;
	public var dob:Date;

	public function new() {}

	public function getGravatar():String {
		return "";
	}
	public function getAge():Int {
		return 3;
	}

}

class PersonWidget extends DataWidget<Person> 
{
	public static function new(data:Person)
	{
		super(data);
	}
}