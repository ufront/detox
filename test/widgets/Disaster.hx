package widgets;

using DateTools;
using Detox;

@template(
"<doc>
	<h1 id='user_$id' class='$userType'>We've been expecting you, $firstName $lastName</h1>
	<p title='$firstName has their birthday on $birthday'>Hover over this paragraph to see $firstName's birthday</p>

	<p>This paragraph <em>purely</em> exists to try show that we can substitute in names like $firstName <em>or</em> $lastName into anywhere and our text nodes won't get messed up.  Also, works with birthdays like <span class='date'>$birthday</span></p>

	<dtx:_Button label='Click Me!' type='success' />

	<p dtx-show='showBirthday'>Your birthday is $birthday</p>
	<p dtx-hide='showBirthday'>Your birthday is a complete secret!</p>
	<form dtx-class-birthday-form='showBirthday'>
		<label><input type='checkbox' dtx-checked='showBirthday' />This one is checked if showBirthday is true</label>
		<label><input type='checkbox' dtx-unchecked='showBirthday' />This one is checked if showBirthday is false</label>
		<button dtx-enabled='showBirthday'>This button is enabled if showBirthday is true</button>
		<button dtx-disabled='showBirthday'>This button is disabled if showBirthday is true</button>
	</form>
	<p>Showbirthday is $showBirthday</p>
</doc>

<_Button>
<a href='#' class='btn btn-$type'>$label</a>
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
