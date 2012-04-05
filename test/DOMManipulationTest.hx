package;

import massive.munit.Assert;

import DOMTools;
using DOMTools;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class DOMManipulationTest 
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
			<ul id='a'>
				<li>A1</li>
				<li>A2</li>
				<li>A3</li>
			</ul>
		</myxml>".parse();
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function appendNode()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendCollection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependNode()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependCollection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendTo_Node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendTo_Collection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendTo_OnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function appendTo_Null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependTo_Node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependTo_Collection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependTo_OnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prependTo_Null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisBefore_Node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisBefore_Collection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisBefore_OnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisBefore_Null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisAfter_Node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisAfter_Collection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisAfter_OnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function insertThisAfter_Null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function beforeThisInsert_Node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function beforeThisInsert_Collection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function beforeThisInsert_OnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function beforeThisInsert_Null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function afterThisInsert_Node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function afterThisInsert_Collection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function afterThisInsert_OnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function afterThisInsert_Null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function remove()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function remove_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeChildren_Node()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeChildren_Collection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeChildren_Null()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeChildren_OnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeChildren_ThatAreNotActuallyChildren()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function empty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function emptyOnNull()
	{
		Assert.areEqual(0, 1);
	}

}
