package;

import massive.munit.Assert;

import dtx.DOMCollection;
import dtx.DOMNode;
import dtx.widget.Widget;
using Detox;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class WidgetTest 
{
	
	public function new() 
	{
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		// trace ("BeforeClass");
	}
	
	@AfterClass
	public function afterClass():Void
	{
		// trace ("AfterClass");
	}
	
	@Before
	public function setup():Void
	{
		var sampleDocument = "<myxml>
			<h1>Title</h1>
			<p>One</p>
			<p>Two</p>
			<div></div>
		</myxml>".parse();
		Detox.setDocument(sampleDocument.getNode());
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function createWidgetNonElement()
	{
		var w1 = new SimpleTestWidget("<!--comment-->");
		var w2 = new SimpleTestWidget("text node");
		Assert.isTrue(w1.getNode().isComment());
		Assert.areEqual("comment", w1.innerHTML());
		Assert.areEqual(1, w1.length);
		Assert.isTrue(w2.getNode().isTextNode());
		Assert.areEqual("text node", w2.innerHTML());
		Assert.areEqual(1, w2.length);
	}

	@Test 
	public function createWidgetMultipleElements()
	{
		var w = new SimpleTestWidget("<h1>Title</h1> <p>Paragraph</p>");
		Assert.areEqual(3, w.length);
		Assert.isTrue(w.getNode(0).isElement());
		Assert.areEqual("h1", w.getNode(0).tagName());
		Assert.areEqual("Title", w.getNode(0).innerHTML());
		Assert.isTrue(w.getNode(1).isTextNode());
		Assert.areEqual(" ", w.getNode(1).innerHTML());
		Assert.isTrue(w.getNode(2).isElement());
		Assert.areEqual("p", w.getNode(2).tagName());
		Assert.areEqual("Paragraph", w.getNode(2).innerHTML());
		Assert.areEqual("<h1>Title</h1> <p>Paragraph</p>", w.html());
		Assert.areEqual(3, w.length);
	}

	@Test 
	public function createWidgetFromSubClass()
	{
		var w = new widgets.WidgetSetBySubclass();
		Assert.areEqual("h1", w.tagName());
		Assert.areEqual(1, w.length);
		Assert.areEqual("<h1>Widget set by subclass</h1>", w.html());
	}

	@Test 
	public function createWidgetFromMetadata()
	{
		var w = new widgets.WidgetSetByMetadata();
		Assert.areEqual("h1", w.tagName());
		Assert.areEqual(1, w.length);
		Assert.areEqual("<h1>Widget set by metadata</h1>", w.html());
	}

	@Test 
	public function createWidgetFromMetadataFile()
	{
		var w = new widgets.WidgetSetByMetadataFile();
		Assert.areEqual("h1", w.tagName());
		Assert.areEqual(1, w.length);
		Assert.areEqual("<h1>Some Template File</h1>", w.html());
	}

	@Test 
	public function createWidgetFromMetadataFileRelative()
	{
		var w = new widgets.WidgetSetByMetadataFileRelative();
		Assert.areEqual("h1", w.tagName());
		Assert.areEqual(1, w.length);
		Assert.areEqual("<h1>some other file</h1>", w.html());
	}

	@Test 
	public function createWidgetFromDefaultFile()
	{
		var w = new widgets.WidgetSetByDefaultFile();
		Assert.areEqual("h1", w.tagName());
		Assert.areEqual(1, w.length);
		Assert.areEqual("<h1>Widget Set by Default File</h1>", w.html());
	}

	@Test 
	public function parseTagWithDtxNamespace()
	{
		// Only allow these features (partials) through the use of macros
		// So they only work on templates included by metadata template('') or loadTemplate('')
		// No need to test it for templates passed through super();

		// Test that the macro XML parser won't spew on a "<dtx:SomeThing />"
		var w2 = new widgets.WidgetWithDtxNamespace();
		Assert.areEqual("doc", w2.getNode().nodeName.toLowerCase());
		Assert.areEqual(1, w2.length);
		Assert.areEqual("<doc><header><title>Test Partial</title></header><section><h1>Header</h1><p>Paragraph</p></section></doc>", w2.html());
	}

	@Test 
	public function parseTagWithUnderscore()
	{
		// Test that the macro XML parser won't spew on a "<_SomeThing />"
		var w2 = new widgets.WidgetWithUnderscore();
		// The actual `_Underscore` element will be removed (it's treated as a partial), but
		// as long as no errors are thrown...
		Assert.areEqual(1, w2.length);
		Assert.areEqual("<p>This is the underscore widget</p>", w2.html());
	}

	@Test 
	public function generatePartialWithinFile()
	{
		var w = new widgets.PartialInSameFile1();

		// Check that the template doesn't contain the partial code anymore
		Assert.areEqual("doc", w.getNode().tagName());
		Assert.areEqual("header", w.getNode().children().getNode().tagName());
		Assert.areEqual("title", w.getNode().children().getNode().children().getNode().tagName());
		Assert.areEqual(1, w.length); // children of widget
		Assert.areEqual(1, w.getNode().children().length); // children of <doc>

		// Check that the class is generated
		var p = new widgets.PartialInSameFile1_BodyPartial();
		Assert.areEqual("<section><h1>Header</h1><p>Paragraph</p></section>", p.html());
	}

	@Test 
	public function includePartialInSameFile()
	{
		var w = new widgets.PartialInSameFile2();

		// Check that it is included correctly
		Assert.areEqual("doc", w.getNode(0).tagName());
		Assert.areEqual("header", w.getNode(0).children().getNode(0).tagName());
		Assert.areEqual("title", w.getNode(0).children().getNode(0).children().getNode(0).tagName());
		Assert.areEqual(1, w.length); // children of widget
		Assert.areEqual(2, w.getNode().children().length); // children of <doc>
		Assert.areEqual("<doc><header><title>Test Partial</title></header><section><h1>Header</h1><p>Paragraph</p></section></doc>", w.html());
		Assert.areEqual("section", w.getNode(0).children().getNode(1).tagName());
		Assert.areEqual("h1", w.getNode(0).children().getNode(1).children().getNode(0).tagName());
		Assert.areEqual("p", w.getNode(0).children().getNode(1).children().getNode(1).tagName());
	}

	@Test 
	public function includePartialInSamePackage()
	{
		var w = new widgets.PartialInSamePackageLayout();
		// Check that it is included correctly
		Assert.areEqual("<doc><header><title>Test Partial</title></header><section><h1>Header</h1><p>Paragraph</p></section></doc>", w.html());
	}

	@Test 
	public function includePartialThatIsIncluded()
	{
		var w = new widgets.PartialThatIsIncludedLayout();

		// Check that it is included correctly
		Assert.areEqual("<doc><header><title>Test Partial</title></header><section><h1>Header</h1><p>Paragraph</p><p>In <code>testpackage</code> package</p></section></doc>", w.html());
	}

	/* 
	* For now I'm leaving this as unsupported.
	* To use a partial from another package, you must run "include" on the class.
	*/
	// @Test 
	// public function includePartialFromFullyQualifiedName()
	// {
	// 	var w = new widgets.PartialFromQualifiedName();

	// 	// Check that it is included correctly
	// 	Assert.areEqual("...", w.html());
	// }

	@Test 
	public function includePartialMultipleTimes()
	{
		var w = new widgets.PartialInSameFile3();

		// Check that it has come through twice
		Assert.areEqual('<doc><header><title>Test Partial</title></header><section><h1>Header</h1><p>Paragraph</p><a href="#" class="btn">Button</a><a href="#" class="btn">Button</a></section></doc>', w.html());
	}

	@Test 
	public function callInlinePartialFromCode()
	{
		var w = new widgets.PartialInSameFile3_Button();

		// See if it matches _Button from that class...
		Assert.areEqual('<a href="#" class="btn">Button</a>', w.html());
	}

	@Test 
	public function includePartialThenReplaceViaWidgetProperty()
	{
		var w = new widgets.PartialInSameFile2();
		var p = new widgets.PartialInSameFile2_BodyPartial();
		p.find("h1").setText("New Partial");
		w.partial_1 = p;

		// Check that it is included correctly
		Assert.areEqual("<doc><header><title>Test Partial</title></header><section><h1>New Partial</h1><p>Paragraph</p></section></doc>", w.html());
	}

	@Test 
	public function namedElements()
	{
		var w = new widgets.WidgetWithNamedElements();

		Assert.areEqual("This is the head", w.head.text());
		Assert.areEqual("This is the body", w.body.text());

		w.head.setInnerHTML("The <b>Head!</b>");
		w.body.setInnerHTML("The <b>Body!</b>");

		Assert.areEqual("The <b>Head!</b>", w.head.innerHTML());
		Assert.areEqual("The <b>Body!</b>", w.body.innerHTML());
	}

	@Test 
	public function initTest()
	{
		var w = new widgets.Init();

		Assert.areNotEqual(-1, w.html().indexOf("Init Test"));
		Assert.areNotEqual(-1, w.html().indexOf("My Partial"));
		Assert.areNotEqual(-1, w.html().indexOf("Some Content"));
	}

	@Test 
	public function noTplTest()
	{
		var w = new widgets.NoTplWidget();
		Assert.areEqual("", untyped w.get_template());
		Assert.areEqual("", w.html());
		Assert.areEqual(0, w.length);
	}

	@Test 
	public function includeNamedPartial()
	{
		var w = new widgets.PartialInSameFile4();
		w.btn1.btnName = "btn1";
		w.btn2.btnName = "btn2";
		Assert.areEqual("btn1btn2", w.find("a").text());
	}

	@Test 
	public function interpolationNotSetStrings()
	{
		var w = new widgets.InterpolationBasic();
		Assert.areEqual("", w.name);
		Assert.areEqual("", w.age);
		Assert.areEqual("", w.belief);
		Assert.areEqual("My name is , I am  years old and I believe in ", w.text());
	}

	@Test 
	public function interpolationNotSetOtherTypes()
	{
		var w = new widgets.InterpolationDifferentTypes();
		Assert.areEqual("", w.name);
		Assert.areEqual(0, w.age);
		Assert.areEqual(null, w.birthday);
		Assert.areEqual(null, w.pets);
		Assert.areEqual(0, w.favouriteNumber);
		Assert.areEqual("My name is , I am 0 years old, my birthday is null and I have these pets: null. My favourite number is 0", w.text());
	}

	@Test 
	public function interpolationSetStrings()
	{
		var w = new widgets.InterpolationBasic();
		w.name = "Jason";
		w.age = "25";
		w.belief = "gravity";
		Assert.areEqual("My name is Jason, I am 25 years old and I believe in gravity", w.text());
	}

	@Test 
	public function interpolationSetOtherTypes()
	{
		var w = new widgets.InterpolationDifferentTypes();
		w.name = "Jason";
		w.age = 25;
		w.birthday = new Date(1987,09,16,0,0,0);
		w.pets = ["Cuddles","Theodore"];
		w.favouriteNumber = 3.14;

		// Slightly different date.toString() output...
		#if js 
			Assert.areEqual("My name is Jason, I am 25 years old, my birthday is Fri Oct 16 1987 00:00:00 GMT+0800 (WST) and I have these pets: [Cuddles,Theodore]. My favourite number is 3.14", w.text());
		#else 
			Assert.areEqual("My name is Jason, I am 25 years old, my birthday is 1987-10-16 00:00:00 and I have these pets: [Cuddles,Theodore]. My favourite number is 3.14", w.text());
		#end 
	}

	@Test 
	public function interpolationUpdateVariables()
	{
		var w = new widgets.InterpolationBasic();
		w.name = "Jason";
		w.age = "25";
		w.belief = "gravity";
		w.age = "5";
		w.belief = "getting younger";
		Assert.areEqual("My name is Jason, I am 5 years old and I believe in getting younger", w.text());
	}

	// @Test
	// public function disaster()
	// {
	// 	var w = new widgets.Disaster();
	// 	w.userType = "student";
	// 	w.firstName = "Jason";
	// 	w.lastName = "O'Neil";
	// 	w.birthday = new Date(1987,9,16,0,0,0);
	// 	w.id = "joneil";
	// 	w.showBirthday = false;

	// 	var expected = "<doc><h1 class='student' data-dtx-id='0' id='user_joneil'>We've been expecting you, Jason O'Neil</h1><p data-dtx-id='1' title='Jason has their birthday on 16/10/87'>Hover over this paragraph to see Jason's birthday</p><p data-dtx-id='2'>This paragraph <em>purely</em> exists to try show that we can substitute in names like Jason <em>or</em> O'Neil into anywhere and our text nodes won't get messed up.  Also, works with birthdays like <span class='date' data-dtx-id='3'>16/10/87</span></p></doc>";
	// 	Assert.areEqual("", w.html());
	// }
}


class SimpleTestWidget extends dtx.widget.Widget
{
	var _tpl:String;
	public function new(tpl:String)
	{
		_tpl = tpl;
		super();
	}

	override function get_template()
	{
		return _tpl;
	}
}