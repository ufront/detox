package;

import massive.munit.Assert;

import Detox;
import dtx.DOMCollection;
import dtx.DOMNode;
using Detox;

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
		Detox.setDocument(sampleDocument.getNode());
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
		var div:DOMNode = Detox.create("div");
		Assert.areEqual("div", div.tagName());
		Assert.areEqual("", div.innerHTML());
	}

	@Test 
	public function createBadInput() 
	{
		var elm:DOMNode = Detox.create("actual_element");
		Assert.areEqual("actual_element", elm.tagName());
		Assert.areEqual("", elm.innerHTML());

		var bad = Detox.create("non existent element");
		Assert.isNull(bad);
	}

	@Test 
	public function createNullInput() 
	{
		var bad = Detox.create(null);
		Assert.isNull(bad);
	}

	@Test 
	public function createEmptyString() 
	{
		var bad = Detox.create("");
		Assert.isNull(bad);
	}

	@Test 
	public function parse() 
	{
		var q = Detox.parse("<div id='test'>Hello</div>");

		Assert.areEqual('div', q.tagName());
		Assert.areEqual('test', q.attr('id'));
		Assert.areEqual('Hello', q.innerHTML());
	}

	@Test 
	public function parseMultiple() 
	{
		var q = Detox.parse("<div id='test1'>Hello</div><p id='test2'>World</p><!--comment-->");

		Assert.areEqual(3, q.length);
		Assert.areEqual("div", q.eq(0).tagName());
		Assert.areEqual("p", q.eq(1).tagName());
		Assert.areEqual("comment", q.eq(2).val());
	}

	@Test 
	public function parseTextOnly() 
	{
		var q3 = Detox.parse("text only");

		Assert.areEqual(dtx.DOMType.TEXT_NODE, q3.getNode().nodeType);
		Assert.areEqual("text only", q3.getNode().nodeValue);
		Assert.areEqual(1, q3.length);
	}

	@Test 
	public function parseComment() 
	{
		var q1 = Detox.parse("<!-- Just 1 comment -->");

		Assert.isTrue(q1.getNode().isComment());
		Assert.areEqual(" Just 1 comment ", q1.getNode().nodeValue);
		Assert.areEqual(1, q1.length);

		var q2 = Detox.parse("<!-- Comment --> Text Node");

		Assert.isTrue(q2.getNode().isComment());
		Assert.areEqual(" Comment ", q2.getNode().nodeValue);
		Assert.areEqual(2, q2.length);

		var q3 = Detox.parse("<!-- Comment1 --><!-- Comment2 -->");

		Assert.isTrue(q3.getNode().isComment());
		Assert.areEqual(" Comment1 ", q3.getNode(0).nodeValue);
		Assert.areEqual(" Comment2 ", q3.getNode(1).nodeValue);
		Assert.areEqual(2, q3.length);
	}

	@Test 
	public function parseNull() 
	{
		var q = Detox.parse(null);
		Assert.areEqual(0, q.length);
	}

	@Test 
	public function parseEmptyString() 
	{
		var q = Detox.parse("");
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
		var q = Detox.parse("<p>My <b>Broken Paragraph</p>");
	}

	@Test 
	public function setDocument()
	{
		var node = "<p>This is <b>My Element</b>.</p>".parse().getNode();
		Detox.setDocument(node);
		Assert.areEqual("My Element", "b".find().innerHTML());
	}

	@Test 
	public function setDocument_null()
	{
		var node = "<p>This is <b>My Element</b>.</p>".parse().getNode();
		Detox.setDocument(node);
		Detox.setDocument(null);

		// The document should still be 'node', because null is rejected.
		Assert.areEqual("My Element", "b".find().innerHTML());
	}

}
