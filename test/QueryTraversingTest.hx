package;

import massive.munit.Assert;

import DOMTools;
using DOMTools;
import domtools.Query;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class QueryTraversingTest 
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

	var sampleDocument:Query;
	
	@Before
	public function setup():Void
	{
		var sampleDocument = "<myxml>
			<h1>Title</h1>
			<ul id='a'>
				<li id='a1'>1</li>
				<li id='a2'>2</li>
				<li id='a3'>3</li>
				<li id='a4'>4</li>
			</ul>
			<ul id='b'>
				<li id='b1'>1</li>
				<li id='b2'>2</li>
				<li id='b3'>3</li>
				<li id='b4'>4</li>
			</ul>
			<div id='empty1'></div>
			<div id='empty2'></div>
			<div id='nonElements'>Text<!--Comment-->Text</div>
			<div id='recursive' class='level1'>
				<div class='level2'>
					<div class='level3'>
						<div class='level4'>
						</div>
					</div>
				</div>
			</div>
		</myxml>".parse();
		Query.setDocument(sampleDocument.getNode());
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function children_normal()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function children_elementsOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function children_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function children_onEmptyParent()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function children_onEmptyCollection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildren()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildren_elementsOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildren_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildren_onEmptyParent()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function firstChildren_onEmptyCollection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildren()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildren_elementsOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildren_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildren_onEmptyCollection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function lastChildren_onEmptyParent()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function parent()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function parent_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function parent_onEmptyCollection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function parent_onElementWithNoParent()
	{
		// eg Document
		Assert.areEqual(0, 1);
	}

	@Test 
	public function ancestors()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function ancestors_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function ancestors_onEmptyCollection()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function ancestors_onElementWithNoParents()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function next()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function next_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function next_onEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function next_onLast()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function next_elementsOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prev()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prev_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prev_onEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prev_onFirst()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function prev_elementsOnly()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function find()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function find_onNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function find_onEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function find_onNothingFound()
	{
		Assert.areEqual(0, 1);
	}

}
