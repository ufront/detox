package;

import massive.munit.Assert;
using Detox;
import dtx.widget.Loop;

class LoopTest 
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
		// trace ("Setup");
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function createEmptyLoop():Void
	{
		var l = new Loop();
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);
		Assert.areEqual("<!-- Detox Loop -->", l.html());
	}

	@Test 
	public function numItems():Void
	{
	}

	@Test 
	public function preventDuplicatesTrue():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;

		l.setList('A,B,C,D,B,C,E'.split(','));
		Assert.areEqual(5, l.numItems);

		l.addList('A,B,E,F'.split(','));
		Assert.areEqual(6, l.numItems);
		Assert.areEqual(" Detox Loop ABCDEF", l.text());
	}

	@Test 
	public function preventDuplicatesFalse():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = false;
		l.setList('A,B,C,D,B,C,E'.split(','));
		Assert.areEqual(7, l.numItems);

		l.addList('A,B,E,F'.split(','));
		Assert.areEqual(11, l.numItems);

		Assert.areEqual(" Detox Loop ABCDBCEABEF", l.text());
	}

	@Test 
	public function preventDuplicatesNull():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = null;
		Assert.areEqual(false, l.preventDuplicates);
	}

	@Test 
	public function preventDuplicatesDefault():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D,B,C,E'.split(','));
		Assert.areEqual(7, l.numItems);

		l.addList('A,B,E,F'.split(','));
		Assert.areEqual(11, l.numItems);

		Assert.areEqual(" Detox Loop ABCDBCEABEF", l.text());
		Assert.areEqual(false, l.preventDuplicates);
	}

	@Test 
	public function preventDuplicatesChangeToTrueWithExistingItems():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D,B,C,E'.split(','));
		l.addList('A,B,E,F'.split(','));

		Assert.areEqual(false, l.preventDuplicates);
		Assert.areEqual(11, l.numItems);
		Assert.areEqual(" Detox Loop ABCDBCEABEF", l.text());

		l.preventDuplicates = true;

		Assert.areEqual(true, l.preventDuplicates);
		Assert.areEqual(" Detox Loop ABCDEF", l.text());
		Assert.areEqual(6, l.numItems);
	}

	@Test
	public function addItem():Void
	{
	}

	@Test 
	public function addItemNull():Void
	{
	}

	@Test 
	public function generateItem():Void
	{
	}

	@Test 
	public function generateItemNull():Void
	{
	}

	@Test 
	public function insertItemAtDefault():Void
	{
	}

	@Test 
	public function insertItemAtStart():Void
	{
	}

	@Test 
	public function insertItemAtMiddle():Void
	{
	}

	@Test 
	public function insertItemAtEnd():Void
	{
	}

	@Test 
	public function empty():Void
	{
	}

	@Test 
	public function emptyWhenAlreadyEmpty():Void
	{
	}

	@Test 
	public function emptyWhenRandomStuffInserted():Void
	{
	}

	@Test 
	public function setList():Void
	{
	}

	@Test 
	public function setListEmpty():Void
	{
	}

	@Test 
	public function setListNull():Void
	{
	}

	@Test 
	public function addList():Void
	{
	}

	@Test 
	public function addListEmpty():Void
	{
	}

	@Test 
	public function addListNull():Void
	{
	}

	@Test 
	public function removeItem():Void
	{
	}

	@Test 
	public function removeItemNull():Void
	{
	}

	@Test 
	public function removeItemNotInList():Void
	{
	}

	@Test 
	public function removeItemInListButNotInDOM():Void
	{
	}

	@Test 
	public function changeItem():Void
	{
	}

	@Test 
	public function changeItemNullItem():Void
	{
	}

	@Test 
	public function changeItemNullInput():Void
	{
	}

	@Test 
	public function changeItemNotFound():Void
	{
	}

	@Test 
	public function changeItemDuplicateExists():Void
	{
	}

	@Test 
	public function moveItemForward():Void
	{
	}

	@Test 
	public function moveItemBackward():Void
	{
	}

	@Test 
	public function moveItemSameLocation():Void
	{
	}

	@Test 
	public function moveItemNullPos():Void
	{
	}

	@Test 
	public function moveItemNullItem():Void
	{
	}

	@Test 
	public function moveItemItemNotFound():Void
	{
	}

	@Test 
	public function moveItemPositionOutOfRange():Void
	{
	}

	@Test 
	public function moveItemWasAlreadyMovedOnDOM():Void
	{
	}

	@Test 
	public function moveItemItemWasRemovedOnDOM():Void
	{
	}

	@Test 
	public function getItemPos():Void
	{
	}

	@Test 
	public function getItemPosNull():Void
	{
	}

	@Test 
	public function getItemPosNotInList():Void
	{
	}

	@Test 
	public function getItemPosItemMovedInDOM():Void
	{
	}

	@Test 
	public function findItemValue():Void
	{
	}

	@Test 
	public function findItemDom():Void
	{
	}

	@Test 
	public function findItemNull():Void
	{
	}

	@Test 
	public function findItemBoth():Void
	{
	}

	@Test 
	public function findItemNotInList():Void
	{
	}

	@Test 
	public function insertLoopIntoDOM():Void
	{
	}

	@Test 
	public function removeLoopFromDOM():Void
	{
	}

	@Test 
	public function removeLoopAndReattach():Void
	{
	}
}
