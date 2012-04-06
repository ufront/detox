package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import DOMTools;
using DOMTools;
import domtools.Query;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class QueryDOMManipulationTest 
{
	private var timer:Timer;
	
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
		var sampleDocument = "".parse();

		Query.setDocument(sampleDocument.getNode());
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function append_node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function append_collection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function append_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function append_null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prepend_node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prepend_collection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prepend_null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prepend_toNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendTo_node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendTo_query()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendTo_null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendTo_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependTo_node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependTo_query()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependTo_null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependTo_OnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisBefore_node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisBefore_query()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisBefore_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisBefore_null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisAfter_node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisAfter_query()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisAfter_null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisAfter_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function beforeThisInsert_node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function beforeThisInsert_query()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function beforeThisInsert_null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function beforeThisInsert_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function afterThisInsert_node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function afterThisInsert_query()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function afterThisInsert_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function afterThisInsert_null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function remove_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function remove_crazyCollection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeChildren_node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeChildren_query()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeChildren_null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeChildren_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function empty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function empty_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function empty_onNonElements()
	{
		Assert.areEqual(0, 1);
	}
	
}
