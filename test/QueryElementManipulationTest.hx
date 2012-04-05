package;

import massive.munit.Assert;

import domtools.Tools;
using domtools.Tools;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class QueryElementManipulationTest 
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
				<li id='a1'>1</li>
				<li id='a2'>2</li>
				<li id='a3'>3</li>
			</ul>
		</myxml>".parse();
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function attr()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function attrOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function attrOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function attrDoesNotExist()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function attrOnMultiple()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setAttr()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setAttrMultiple()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setAttrOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setAttrOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeAttr()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeAttrOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeAttrOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeAttrThatDoesNotExist()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function hasClass()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function hasClassOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function hasClassOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function addClass()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function addClassThatAlreadyExists()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function addClassOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function addClassOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeClass()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeClassWhereSomeDoNotExist()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeClassOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function removeClassOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function toggleClass()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function toggleClassOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function toggleClassOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function tagName()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function tagNameOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function tagNameOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function tagNameOnMultiple()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function tagNames()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function tagNamesOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function tagNamesOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function val()
	{
		// The actual reading of "val" is done in single.ElementManipulation
		// and we already have unit tests for that.

		// Make sure it reads the first Node in the set.
		Assert.areEqual(0, 1);
	}

	@Test 
	public function valOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function valOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setVal()
	{
		// The actual setting of "val" is done in single.ElementManipulation
		// and we already have unit tests for that.

		// Make sure it sets for every element
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setValOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setValOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function textOnSingle()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function textOnMultiple()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function textOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function textOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setText()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setTextOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setTextOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function innerHTML()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function innerHTMLOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function innerHTMLOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setInnerHTML()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setInnerHTMLOnNull()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function setInnerHTMLOnEmpty()
	{
		Assert.areEqual(0, 1);
	}

	@Test 
	public function chaining()
	{
		Assert.areEqual(0, 1);
	}

}
