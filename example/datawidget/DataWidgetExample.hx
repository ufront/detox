import dtx.widget.DataWidget;
import dtx.widget.WidgetTools;

using Detox;
using DateTools;

class DataWidgetExample 
{
	static var pw:PersonWidget;

	static public function main()
	{
		js.Lib.window.onload = function (e) {
			var person = generateRandomPerson();
			pw = new PersonWidget(person);
			var doc = CommonJS.getHtmlDocument();
			doc.body.append(pw);
			changePerson();
		};
	}

	static public function changePerson()
	{
		var person = generateRandomPerson();
		pw.bind(person);
	}

	static function generateRandomPerson()
	{
		// Some data to choose from
		var firstNames = ["Jason", "Barrack", "Julia", "Nelson"];
		var lastNames = ["O'Neil", "Obama", "Gillard", "Mandela"];
		var domains = ["gmail.com", "whitehouse.gov", "primeminister.gov.au", "thepresidency.gov.za"];
		var dates = [
			new Date(1987,9,16,0,0,0),
			new Date(1961,7,4,0,0,0),
			new Date(1961,8,29,0,0,0),
			new Date(1918,6,18,0,0,0)
		];

		// Pick some random details and create a new person
		var p = new Person();
		p.name = Random.fromArray(firstNames) + " " + Random.fromArray(lastNames);
		p.email = ~/[^a-z0-9]/g.replace(p.name.toLowerCase(), "") + "@" + Random.fromArray(domains);
		p.dob = Random.fromArray(dates);

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
		return "https://en.gravatar.com/userimage/1620077/b344f5051e6f18d521f2e7c58a2f42fa.jpeg";
	}
	public function getAge():Int {
		var ageInSeconds = Date.now().getTime() - dob.getTime();
		return Math.floor(ageInSeconds / 86400 / 365.25 / 1000);
	}

}

class PersonWidget extends DataWidget<Person> 
{
	public static function new(data:Person)
	{
		super(data);
	}
}