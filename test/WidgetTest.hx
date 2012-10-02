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
	public function createWidgetFromString()
	{
		var w = new Widget("<div>My Widget</div>");
		Assert.areEqual("div", w.tagName());
		Assert.areEqual(1, w.length);
		Assert.areEqual("My Widget", w.innerHTML());
	}

	@Test 
	public function createWidgetNull()
	{
		var w = new Widget(null);
		Assert.areEqual("div", w.tagName());
		Assert.areEqual(1, w.length);
		Assert.areEqual("", w.innerHTML());
	}

	@Test 
	public function createWidgetEmpty()
	{
		var w = new Widget("");
		Assert.areEqual(0, w.length);
		Assert.areEqual("", w.html());
	}

	@Test 
	public function createWidgetNonElement()
	{
		var w1 = new Widget("<!--comment-->");
		var w2 = new Widget("text node");
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
		var w = new Widget("<h1>Title</h1> <p>Paragraph</p>");
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
		w.partial_1 = new widgets.PartialInSameFile2_BodyPartial();

		// Check that it is included correctly
		Assert.areEqual("<doc><header><title>Test Partial</title></header><p>New Data</p></doc>", w.html());
	}

	@Test 
	public function includeNamedPartial()
	{
		Assert.isTrue(false);
	}

	@Test 
	public function variablesNotSet()
	{
		
	}

	@Test 
	public function variablesSet()
	{
		
	}

	@Test 
	public function variableUpdate()
	{
		
	}

	@Test 
	public function noVariables()
	{
		
	}

	@Test @TestDebug
	public function disaster()
	{
		var w = new widgets.Disaster();
		w.userType = "student";
		w.firstName = "Jason";
		w.lastName = "O'Neil";
		w.birthday = new Date(1987,9,16,0,0,0);
		w.id = "joneil";

		var expected = "<doc><h1 class='student' data-dtx-id='0' id='user_joneil'>We've been expecting you, Jason O'Neil</h1><p data-dtx-id='1' title='Jason has their birthday on 16/10/87'>Hover over this paragraph to see Jason's birthday</p><p data-dtx-id='2'>This paragraph <em>purely</em> exists to try show that we can substitute in names like Jason <em>or</em> O'Neil into anywhere and our text nodes won't get messed up.  Also, works with birthdays like <span class='date' data-dtx-id='3'>16/10/87</span></p></doc>";
		Assert.areEqual("", w.html());
	}
}
