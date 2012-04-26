package;

import massive.munit.Assert;

import DOMTools;
import domtools.DOMCollection;
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
		DOMCollection.setDocument(sampleDocument.getNode());
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
	public function create()
	{
		Assert.areEqual("DIV", "div".create().nodeName);
		Assert.areEqual("P", "p".create().nodeName);
		Assert.isNull("non element".create());
		Assert.isNull("".create());
	}

	@Test
	public function parse()
	{
		Assert.areEqual(2, "<p>One</p><div>Two</div>".parse().length);
		var str = "my text node";
		Assert.areEqual(1, str.parse().length);
		Assert.areEqual(0, "".parse().length);
	}

}
