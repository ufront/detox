import domtools.Widget;
using StringTools;
using DOMTools;

class ContactView extends Widget 
{
	static var tpl = Widget.loadTemplate("ContactView.tpl");

	public function new(name:String, email:String, age:Int)
	{
		super(tpl);

		this.find('.name').setText(name);
		this.find('.email').setText(email).setAttr('href', 'mailto:' + email);
		this.find('.age').setText("" + age);
		setAvatar(email);
	}

	public function setAvatar(email:String)
	{
		// Gravatar instructions

		// 1 Trim whitespace
		var hash = email.trim();

		// 2 To lower case
		hash = hash.toLowerCase();

		// 3 Make md5
		hash = haxe.Md5.encode(hash);

		var src = "http://www.gravatar.com/avatar/" + hash;

		this.find('img').setAttr('src', src);
	}
}