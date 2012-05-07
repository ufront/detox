package;

import massive.munit.Assert;

import DOMTools;
import domtools.DOMCollection;
import domtools.DOMNode;
using DOMTools;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class ToolsTest 
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
		DOMTools.setDocument(sampleDocument.getNode());
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	//
	// These are just a basic wrapper on some DOMCollection functions (new, create, parse)
	// There are unit tests there, so just test that they work from a string.
	// 

	@Test 
	public function find()
	{
		Assert.areEqual(1, "h1".find().length);
		Assert.areEqual(2, "p".find().length);
	}

	@Test 
	public function create_via_using()
	{
		Assert.areEqual(#if js "DIV" #else "div" #end, "div".create().nodeName);
		Assert.areEqual(#if js "P" #else "p" #end, "p".create().nodeName);
		Assert.isNull("non element".create());
		Assert.isNull("".create());
	}

	@Test
	public function parse_via_using()
	{
		Assert.areEqual(2, "<p>One</p><div>Two</div>".parse().length);
		Assert.areEqual(1, "my text node".parse().length);
		Assert.areEqual(0, "".parse().length);
	}

	@Test 
	public function create() 
	{
		var div:DOMNode = DOMTools.create("div");
		Assert.areEqual("div", div.tagName());
		Assert.areEqual("", div.innerHTML());
	}

	@Test 
	public function createBadInput() 
	{
		var elm:DOMNode = DOMTools.create("actual_element");
		Assert.areEqual("actual_element", elm.tagName());
		Assert.areEqual("", elm.innerHTML());

		var bad = DOMTools.create("non existent element");
		Assert.isNull(bad);
	}

	@Test 
	public function createNullInput() 
	{
		var bad = DOMTools.create(null);
		Assert.isNull(bad);
	}

	@Test 
	public function createEmptyString() 
	{
		var bad = DOMTools.create("");
		Assert.isNull(bad);
	}

	@Test 
	public function parse() 
	{
		var q = DOMTools.parse("<div id='test'>Hello</div>");

		Assert.areEqual('div', q.tagName());
		Assert.areEqual('test', q.attr('id'));
		Assert.areEqual('Hello', q.innerHTML());
	}

	@Test 
	public function parseMultiple() 
	{
		var q = DOMTools.parse("<div id='test1'>Hello</div><div id='test2'>World</div>");

		Assert.areEqual(2, q.length);
		Assert.areEqual("div", q.eq(0).tagName());
		Assert.areEqual("div", q.eq(1).tagName());
	}

	@Test 
	public function parseTextOnly() 
	{
		var q3 = DOMTools.parse("text only");

		Assert.areEqual(domtools.DOMType.TEXT_NODE, q3.getNode().nodeType);
		Assert.areEqual("text only", q3.getNode().nodeValue);
	}

	@Test 
	public function parseNull() 
	{
		var q = DOMTools.parse(null);
		Assert.areEqual(0, q.length);
	}

	@Test 
	public function parseEmptyString() 
	{
		var q = DOMTools.parse("");
		Assert.areEqual(0, q.length);
	}

	@Test 
	public function parseBrokenHTML() 
	{
		// This passes in most browsers, but it's not entirely consistent
		// in it's behaviour.  However, I don't think it's a common enough
		// (or dangerous enough) use case for us to think about correcting
		// these inconsistencies.
		// This test merely checks that it doesn't throw an error.
		var q = DOMTools.parse("<p>My <b>Broken Paragraph</p>");
	}

	@Test 
	public function setDocument()
	{
		var node = "<p>This is <b>My Element</b>.</p>".parse().getNode();
		DOMTools.setDocument(node);
		Assert.areEqual("My Element", "b".find().innerHTML());
	}

	@Test 
	public function setDocument_null()
	{
		var node = "<p>This is <b>My Element</b>.</p>".parse().getNode();
		DOMTools.setDocument(node);
		DOMTools.setDocument(null);

		// The document should still be 'node', because null is rejected.
		Assert.areEqual("My Element", "b".find().innerHTML());
	}

}
