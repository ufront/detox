package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import DOMTools;
using DOMTools;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class TraversingTest 
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
	public function children()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function childrenOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function childrenOnNonElement()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function childrenElementsOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function childrenOnEmptyElement()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildren()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildrenOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildrenOnEmptyElm()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildrenOnNonElement()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildrenElementsOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildren()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildrenOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildrenOnEmptyElm()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildrenOnNonElement()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildrenElementsOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function parent()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function parentOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function parentOnParentNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function ancestors()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function ancestorsOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function ancestorsOnParentNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function next()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function nextElementOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function nextOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function nextWhenThereIsNoNext()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prev()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prevElementOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prevOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prevWhenThereIsNoPrev()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function find()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function findOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function findNoResults()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function findOnWrongNodeType()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function chaining()
	{
		Assert.areEqual(0, 1);
	}

}
