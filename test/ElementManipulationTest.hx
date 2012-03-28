package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import domtools.Query;
import domtools.Tools;
import js.w3c.level3.Core;
using domtools.Tools;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class ElementManipulationTest 
{
	private var sampleDocument:Node;
	
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
		// trace ("Setup");
		var html = "<myxml>
		<h1>My Header</h1>
		<div class='containscomment'><!-- A comment --></div>
		<div class='containstext'>Text</div>
		</myxml>";
		sampleDocument = Query.parse(html).getNode();
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}
	
	
	@Test
	public function isElement():Void
	{
		Assert.isTrue(true);
	}

	@Test
	public function testExampleThatFailes():Void
	{
		Assert.isTrue(true);
	}

}
