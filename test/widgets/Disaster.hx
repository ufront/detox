package widgets;

using DateTools;
using Detox;

@template(
"<doc>
	<h1 id='user_$id' class='$userType'>We've been expecting you, $firstName $lastName</h1>
	<p title='$firstName has their birthday on $birthday'>Hover over this paragraph to see $firstName's birthday</p>

	<p>This paragraph <em>purely</em> exists to try show that we can substitute in names like $firstName <em>or</em> $lastName into anywhere and our text nodes won't get messed up.  Also, works with birthdays like <span class='date'>$birthday</span></p>

	<dtx:_Button label='Click Me!' />
</doc>

<_Button>
<a href='#' class='btn'>$label</a>
</_Button>
"
)
class Disaster extends dtx.widget.Widget {

	public var birthday:Date;

	function print_birthday()
	{
		return if (birthday != null) birthday.format("%d/%m/%y") else "";
	}

}
