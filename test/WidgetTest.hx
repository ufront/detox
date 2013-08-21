package;

import massive.munit.Assert;

import dtx.DOMCollection;
import dtx.DOMNode;
import dtx.widget.Widget;
using Detox;
using StringTools;

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
	public function topLevelNamedElements()
	{
		var w = new widgets.WidgetWithNamedElements.TopLevelNamedElements2();

		Assert.areEqual("Paragraph", w.paragraph.text());
		Assert.areEqual("Div", w.div.text());

		w.paragraph.setInnerHTML("1");
		w.div.setInnerHTML("2");

		Assert.areEqual("1", w.paragraph.text());
		Assert.areEqual("2", w.div.text());
	}

	@Test 
	public function namedElementsClash1()
	{
		var div = "div".create();
		var w1 = new widgets.WidgetWithNamedElements.TopLevelNamedElements1();
		var w2 = new widgets.WidgetWithNamedElements.TopLevelNamedElements1();
		div.append(w1).append(w2);

		Assert.areEqual("Paragraph", w1.paragraph.text());
		Assert.areEqual("Paragraph", w1.paragraph.text());

		w1.paragraph.setInnerHTML("1");
		w2.paragraph.setInnerHTML("2");

		Assert.areEqual("1", w1.paragraph.text());
		Assert.areEqual("2", w2.paragraph.text());
	}

	@Test 
	public function namedElementsClash2()
	{
		var div = "div".create();
		var w1 = new widgets.WidgetWithNamedElements.TopLevelNamedElements2();
		var w2 = new widgets.WidgetWithNamedElements.TopLevelNamedElements2();
		div.append(w1).append(w2);

		Assert.areEqual("Paragraph", w1.paragraph.text());
		Assert.areEqual("Div", w1.div.text());
		Assert.areEqual("Paragraph", w2.paragraph.text());
		Assert.areEqual("Div", w2.div.text());

		w1.paragraph.setInnerHTML("1");
		w1.div.setInnerHTML("2");
		w2.paragraph.setInnerHTML("3");
		w2.div.setInnerHTML("4");

		Assert.areEqual("1", w1.paragraph.text());
		Assert.areEqual("2", w1.div.text());
		Assert.areEqual("3", w2.paragraph.text());
		Assert.areEqual("4", w2.div.text());
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
	public function partialSetParameters()
	{
		var w = new widgets.PartialInSameFile5();
		w.name = "Jason";

		Assert.areEqual("login", w.btn1.text());
		Assert.areEqual("logout", w.btn2.text());
		Assert.areEqual("JASON", w.btn3.text());
		Assert.areEqual(true, w.btn1.hasClass("big"));
		Assert.areEqual(true, w.btn2.hasClass("big"));
		Assert.areEqual(false, w.btn3.hasClass("big"));

		w.name = "Anna";
		Assert.areEqual("ANNA", w.btn3.text());

		Assert.areEqual("Jason", w.profile1.find("h2").text());
		Assert.areEqual("0", w.profile1.attr("id"));
		Assert.areEqual("This person is an adult: true", w.profile1.find("p").text());

		w.person = { id:1, name:"David", over18:false }
		
		Assert.areEqual("David", w.profile2.find("h2").text());
		Assert.areEqual("1", w.profile2.attr("id"));
		Assert.areEqual("This person is an adult: false", w.profile2.find("p").text());

		w.person = { id:2, name:"Michael", over18:true }
		
		Assert.areEqual("Michael", w.profile2.find("h2").text());
		Assert.areEqual("2", w.profile2.attr("id"));
		Assert.areEqual("This person is an adult: true", w.profile2.find("p").text());
	}

	@Test 
	public function interpolationNotSetStrings()
	{
		var w = new widgets.Interpolation.InterpolationBasic();
		Assert.areEqual("", w.name);
		Assert.areEqual("", w.age);
		Assert.areEqual("", w.belief);
		Assert.areEqual("My name is , I am  years old and I believe in ", w.text());
	}

	@Test 
	public function interpolationNotSetButWithInitialization()
	{
		var w = new widgets.Interpolation.InterpolationWithInitialisation();
		Assert.areEqual("Jason", w.name);
		Assert.areEqual(26, w.age);
		Assert.areEqual(true, w.isTall);
		Assert.areEqual("My name is Jason, I am 26 years old and it is true that I am tall", w.text());
	}

	@Test 
	public function interpolationNotSetOtherTypes()
	{
		var w = new widgets.Interpolation.InterpolationDifferentTypes();
		Assert.areEqual("", w.name);
		Assert.areEqual(0, w.age);
		Assert.areEqual(null, w.birthday);
		Assert.areEqual(null, w.pets);
		Assert.areEqual(0, w.favouriteNumber);
		Assert.areEqual(false, w.wasTruth);
	}

	@Test 
	public function interpolationSetStrings()
	{
		var w = new widgets.Interpolation.InterpolationBasic();
		w.name = "Jason";
		w.age = "25";
		w.belief = "gravity";
		Assert.areEqual("My name is Jason, I am 25 years old and I believe in gravity", w.text());
	}

	@Test 
	public function interpolationSetOtherTypes()
	{
		var w = new widgets.Interpolation.InterpolationDifferentTypes();
		w.name = "Jason";
		w.age = 25;
		w.birthday = new Date(1987,09,16,0,0,0);
		w.pets = ["Cuddles","Theodore"];
		w.favouriteNumber = 3.14;
		w.wasTruth = true;

		// Slightly different date.toString() output...
		#if js 
			Assert.areEqual("My name is Jason, I am 25 years old, my birthday is Fri Oct 16 1987 00:00:00 GMT+0800 (WST) and I have these pets: [Cuddles,Theodore]. My favourite number is 3.14, and the statement I just made was true", w.text());
		#else 
			Assert.areEqual("My name is Jason, I am 25 years old, my birthday is 1987-10-16 00:00:00 and I have these pets: [Cuddles,Theodore]. My favourite number is 3.14, and the statement I just made was true", w.text());
		#end 
	}

	@Test
	public function interpolationUpdateVariables()
	{
		var w = new widgets.Interpolation.InterpolationBasic();
		w.name = "Jason";
		w.age = "25";
		w.belief = "gravity";
		w.age = "5";
		w.belief = "getting younger";
		Assert.areEqual("My name is Jason, I am 5 years old and I believe in getting younger", w.text());
	}

	@Test 
	public function interpolationNonVariableExpression()
	{
		var w = new widgets.Interpolation.InterpolationNonVarExpr();
		Assert.areEqual("The SHA of 8 is fe5dbbcea5ce7e2988b8c69bcfdfde8904aabc1f", w.text());
	}

	@Test 
	public function interpolationComplexExpression()
	{
		var w = new widgets.Interpolation.InterpolationComplexExpr();
		w.name = "Detox";
		Assert.areEqual("The word Detox is 5 letters long and the first letter is D", w.text());
	}

	@Test
	public function interpolationMemberFunction()
	{
		var w = new widgets.Interpolation.InterpolationMemberFunction();
		w.a = 10;
		w.b = 20;
		Assert.areEqual("Sum = 30", w.text());
		w.a = 1;
		w.b = 2;
		Assert.areEqual("Sum = 3", w.text());
	}

	@Test 
	public function interpolationOutsideFunction()
	{
		var w = new widgets.Interpolation.InterpolationOutsideFunction();
		w.a = 10;
		w.b = 20;
		Assert.areEqual("Max = 20", w.text());
		w.a = 1;
		w.b = 2;
		Assert.areEqual("Max = 2", w.text());
	}

	@Test
	public function interpolationFieldAccess()
	{
		var jason = {
			name: "Jason",
			age: 25
		}
		var w = new widgets.Interpolation.InterpolationFieldAccess();
		w.person = jason;
		Assert.areEqual("My name is Jason (and my name has 5 letters!) and I am 25 years old.", w.text());
	}

	@Test
	public function interpolationFieldMemberFunction()
	{
		var w = new widgets.Interpolation.InterpolationFieldMemberFunction();
		var jason = new widgets.Interpolation.Person("Jason", "O'Neil");
		var nicolas = new widgets.Interpolation.Person("Nicolas", "Cannasse");
		w.person = jason;
		Assert.areEqual("Greet J. O'Neil: Hello Jason", w.text());
		w.person = nicolas;
		Assert.areEqual("Greet N. Cannasse: Hello Nicolas", w.text());
	}

	@Test
	public function interpolationFieldAccessAsFunctionArg()
	{
		var jason = {
			name: "Jason",
			email: "jason.oneil@example.com"
		}
		var w = new widgets.Interpolation.InterpolationFieldAccessAsFunctionArg();
		w.person = jason;
		Assert.areEqual("Your encoded email address is [jason.oneil%40example.com]", w.text());
	}

	@Test 
	public function showHideBoolAttributes()
	{
		var w = new widgets.BoolAttributes.ShowHideBasic();

		// Test the constants
		Assert.isFalse( w.alwaysShow.hasClass("hidden") );
		Assert.isTrue( w.alwaysHide.hasClass("hidden") );
		Assert.isTrue( w.neverShow.hasClass("hidden") );
		Assert.isFalse( w.neverHide.hasClass("hidden") );

		// Test the intial state of the Booleans
		Assert.isFalse( w.showIfSomeFlag.hasClass("hidden") );
		Assert.isTrue( w.hideIfSomeFlag.hasClass("hidden") );
		Assert.isTrue( w.showIfSomeString.hasClass("hidden") );
		Assert.isFalse( w.hideIfSomeString.hasClass("hidden") );

		// Test the changed state of the Booleans
		w.someFlag = false;
		w.someString = "Jason";
		Assert.isTrue( w.showIfSomeFlag.hasClass("hidden") );
		Assert.isFalse( w.hideIfSomeFlag.hasClass("hidden") );
		Assert.isFalse( w.showIfSomeString.hasClass("hidden") );
		Assert.isTrue( w.hideIfSomeString.hasClass("hidden") );
	}

	@Test 
	public function htmlCharacterEncodings()
	{
		var w = new widgets.WidgetWithHtmlEncoding();
		var expected = '<p title="All about apples &amp; bananas">Apples &amp; Bananas, <i title="&laquo;More Info&raquo;">&laquo;&nbsp;Both are fruit&nbsp;&raquo</i></p>';
		Assert.areEqual(expected, untyped w.get_template());
	}

	@Test 
	public function interpolationWithPrintFields()
	{
		var w = new widgets.Interpolation.InterpolationWithPrintFields();
		w.name = "Jason";
		w.age = 26;
		w.amITall = true;
		Assert.areEqual("My name is Jason, I am 26 years old and I am tall", w.text());
		w.name = "Anna";
		w.age = 23;
		w.amITall = false;
		Assert.areEqual("My name is Anna, I am 23 years old and I am not tall", w.text());
	}

	@Test 
	public function interpolationWithPrintFieldsComplex()
	{
		var w = new widgets.Interpolation.InterpolationWithPrintFieldsComplex();
		w.name = "Jason";
		w.age = 26.5;
		w.amITall = true;
		Assert.areEqual('First letter is J, my last birthday was 26<span class=""> and I am definitely tall</span>.', w.innerHTML());
		w.name = "Anna";
		w.age = 23.5;
		w.amITall = false;
		Assert.areEqual('First letter is A, my last birthday was 23<span class="hidden"> and I am not tall</span>.', w.innerHTML());
	}

	@Test 
	public function widgetLoopsDefinedPartial()
	{
		var w = new widgets.LoopsInWidget.LoopInlineArrayWithImportedPartial();
		var items = w.find("li");
		Assert.areEqual(5, items.length);
		Assert.areEqual("Defined 1", items.eq(0).text());
		Assert.areEqual("Defined 2", items.eq(1).text());
		Assert.areEqual("Defined 3", items.eq(2).text());
		Assert.areEqual("Defined 4", items.eq(3).text());
		Assert.areEqual("Defined 5", items.eq(4).text());
	}

	@Test 
	public function widgetLoopsRelativePartial()
	{
		var w = new widgets.LoopsInWidget.LoopInlineArrayWithRelativePartial();
		var items = w.find("li");
		Assert.areEqual(5, items.length);
		Assert.areEqual("Relative 1", items.eq(0).text());
		Assert.areEqual("Relative 2", items.eq(1).text());
		Assert.areEqual("Relative 3", items.eq(2).text());
		Assert.areEqual("Relative 4", items.eq(3).text());
		Assert.areEqual("Relative 5", items.eq(4).text());
	}

	@Test 
	public function widgetLoopsInlinePartial()
	{
		var w = new widgets.LoopsInWidget.LoopInlineArrayWithInlinePartial();
		var items = w.find("li");
		Assert.areEqual(5, items.length);
		Assert.areEqual("Inline 1", items.eq(0).text());
		Assert.areEqual("Inline 2", items.eq(1).text());
		Assert.areEqual("Inline 3", items.eq(2).text());
		Assert.areEqual("Inline 4", items.eq(3).text());
		Assert.areEqual("Inline 5", items.eq(4).text());
	}

	@Test
	public function widgetLoopsInlineNamedPartial()
	{
		var w = new widgets.LoopsInWidget.InlineNamedPartial();
		var items = w.find("li");
		Assert.areEqual(3, items.length);
		Assert.areEqual("Inline Named Jason", items.eq(0).text());
		Assert.areEqual("Inline Named Clare", items.eq(1).text());
		Assert.areEqual("Inline Named Aaron", items.eq(2).text());
		
		w.myLoop.addItem("Michael");
		var items = w.find("li");
		Assert.areEqual(4, items.length);
		Assert.areEqual("Inline Named Michael", items.eq(3).text());
		
		w.myLoop.setList(["Haxe","Detox","Ufront"]);
		var items = w.find("li");
		Assert.areEqual(3, items.length);
		Assert.areEqual("Inline Named Haxe", items.eq(0).text());
		Assert.areEqual("Inline Named Detox", items.eq(1).text());
		Assert.areEqual("Inline Named Ufront", items.eq(2).text());
	}

	@Test 
	public function widgetLoopFromMemberVariable()
	{
		var w = new widgets.LoopsInWidget.LoopFromMemberVariable();
		var items = w.find("li");
		Assert.areEqual(3, items.length);
		Assert.areEqual("Member Iter 0", items.eq(0).text());
		Assert.areEqual("Member Iter 0.1", items.eq(1).text());
		Assert.areEqual("Member Iter 0.2", items.eq(2).text());

		w.memberArray = [0.3,0.4];
		var items = w.find("li");
		Assert.areEqual(2, items.length);
		Assert.areEqual("Member Iter 0.3", items.eq(0).text());
		Assert.areEqual("Member Iter 0.4", items.eq(1).text());
	}

	@Test 
	public function widgetLoopFromComplexExpr()
	{
		var w = new widgets.LoopsInWidget.LoopFromComplexExpr();
		var items = w.find("li");
		Assert.areEqual(6, items.length);
		Assert.areEqual("Complex Iter Expr 0", items.eq(0).text());
		Assert.areEqual("Complex Iter Expr 1", items.eq(1).text());
		Assert.areEqual("Complex Iter Expr 2", items.eq(2).text());
		Assert.areEqual("Complex Iter Expr 4", items.eq(3).text());
		Assert.areEqual("Complex Iter Expr 5", items.eq(4).text());
		Assert.areEqual("Complex Iter Expr 6", items.eq(5).text());

		w.memberArray = [7,8];
		var items = w.find("li");
		Assert.areEqual(5, items.length);
		Assert.areEqual("Complex Iter Expr 0", items.eq(0).text());
		Assert.areEqual("Complex Iter Expr 1", items.eq(1).text());
		Assert.areEqual("Complex Iter Expr 2", items.eq(2).text());
		Assert.areEqual("Complex Iter Expr 7", items.eq(3).text());
		Assert.areEqual("Complex Iter Expr 8", items.eq(4).text());
	}

	@Test 
	public function widgetLoopsUsingIterator()
	{
		var w = new widgets.LoopsInWidget.LoopUsingInlineIterator();
		var items1 = w.find("li");
		Assert.areEqual(3, items1.length);
		Assert.areEqual("IntIter 0", items1.eq(0).text());
		Assert.areEqual("IntIter 1", items1.eq(1).text());
		Assert.areEqual("IntIter 2", items1.eq(2).text());

		var w2 = new widgets.LoopsInWidget.LoopUsingMemberIterator();
		Assert.areEqual(2, w2.find("li").length);
		Assert.areEqual("Map Key Anna", w2.find('li.anna').text());
		Assert.areEqual("Map Key Jason", w2.find('li.jason').text());
	}

	// Test JOINS
	// Test multiple elements in partial
	// Test complex objects (eg models) being looped over and parsed to the child (and defined in the child)
	// Multiple loops together
	// Test loops with explicit typing
	// Test loops with explicit typing + propertyName
	// Test loops with elements like <td>, <tr>, etc that don't embed properly

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