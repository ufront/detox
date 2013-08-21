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
		var l = new Loop();
		Assert.areEqual(0, l.numItems);

		l.setList('A,B,C,D'.split(','));
		Assert.areEqual(4, l.numItems);

		l.addList('E,F'.split(','));
		Assert.areEqual(6, l.numItems);

		l.setList('A,B'.split(','));
		Assert.areEqual(2, l.numItems);

		l.addItem('C');
		Assert.areEqual(3, l.numItems);

		l.removeItem('B');
		Assert.areEqual(2, l.numItems);

		l.empty();
		Assert.areEqual(0, l.numItems);
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
		#if (js || neko || php )
			var l = new Loop<String>();
			l.preventDuplicates = null;
			Assert.areEqual(false, l.preventDuplicates);
		#end 
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
		var l = new Loop<String>();
		
		l.addItem("1");
		Assert.areEqual(1, l.numItems);
		Assert.areEqual(2, l.length);
		Assert.areEqual("<!-- Detox Loop -->1", l.html());

		l.addItem("2");
		Assert.areEqual(2, l.numItems);
		Assert.areEqual(3, l.length);
		Assert.areEqual("<!-- Detox Loop -->12", l.html());
	}

	@Test 
	public function addItemNull():Void
	{
		var l = new Loop<String>();
		l.addItem(null);
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);
		Assert.areEqual("<!-- Detox Loop -->", l.html());
	}

	@Test 
	public function generateItem():Void
	{
		var l = new Loop<String>();
		var i1 = l.generateItem("123");
		var i2 = l.generateItem("Hello <em>Kind</em> World...");

		Assert.areEqual("123", i1.input);
		Assert.areEqual("123", i1.dom.html());
		Assert.isTrue(i1.dom.getNode().isTextNode());

		Assert.areEqual("Hello <em>Kind</em> World...", i2.input);
		Assert.areEqual("Hello <em>Kind</em> World...", i2.dom.html());
		Assert.areEqual("Hello Kind World...", i2.dom.text());
		Assert.isTrue(i2.dom.getNode(0).isTextNode());
		Assert.isTrue(i2.dom.getNode(1).isElement());
		Assert.areEqual("em", i2.dom.getNode(1).tagName());
		Assert.isTrue(i2.dom.getNode(2).isTextNode());
	}

	@Test 
	public function generateItemNull():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem(null);

		Assert.areEqual(null, i.input);
		// As long as this doesn't throw an error, we should be okay.
	}

	@Test 
	public function insertItemDefault():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i = l.generateItem("1");
		l.insertItem(i);

		Assert.areEqual(" Detox Loop ABCD1", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function insertItemStart():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i = l.generateItem("1");
		l.insertItem(i, 0);

		Assert.areEqual(" Detox Loop 1ABCD", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function insertItemMiddle():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i = l.generateItem("1");
		l.insertItem(i, 3);

		Assert.areEqual(" Detox Loop ABC1D", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function insertItemEnd():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i = l.generateItem("1");
		l.insertItem(i, 4);

		Assert.areEqual(" Detox Loop ABCD1", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function insertItemOutOfRange():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i1 = l.generateItem("1");
		var i2 = l.generateItem("2");
		l.insertItem(i1, -99);
		l.insertItem(i2, 99);

		Assert.areEqual(" Detox Loop ABCD12", l.text());
		Assert.areEqual(6, l.numItems);
	}

	@Test 
	public function empty():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
		Assert.areEqual(5, l.length);
		
		l.empty();

		Assert.areEqual(" Detox Loop ", l.text());
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);
	}

	@Test 
	public function emptyWhenAlreadyEmpty():Void
	{
		var l = new Loop<String>();
		l.empty();

		Assert.areEqual(" Detox Loop ", l.text());
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);
	}

	@Test 
	public function emptyWhenRandomStuffInserted():Void
	{
		var l = new Loop<String>();
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);

		l.addList('A,B,C,D'.split(','));
		Assert.areEqual(4, l.numItems);
		Assert.areEqual(5, l.length);

		var n = "<!-- New Comment -->".parse().getNode();
		l.add(n);
		Assert.areEqual(4, l.numItems);
		Assert.areEqual(6, l.length);
		
		l.empty();

		Assert.areEqual("<!-- Detox Loop --><!-- New Comment -->", l.html());
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(2, l.length);
	}

	@Test 
	public function setList():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.setList('E,F'.split(','));

		Assert.areEqual(2, l.numItems);
		Assert.areEqual(" Detox Loop EF", l.text());
	}

	@Test 
	public function setListEmpty():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.setList([]);

		Assert.areEqual(0, l.numItems);
		Assert.areEqual(" Detox Loop ", l.text());
	}

	@Test 
	public function setListNull():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.setList(null);

		Assert.areEqual(0, l.numItems);
		Assert.areEqual(" Detox Loop ", l.text());
	}

	@Test
	public function addList():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.addList('E,F'.split(','));

		Assert.areEqual(6, l.numItems);
		Assert.areEqual(" Detox Loop ABCDEF", l.text());
	}

	@Test 
	public function addListEmpty():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.addList([]);

		Assert.areEqual(4, l.numItems);
		Assert.areEqual(" Detox Loop ABCD", l.text());
	}

	@Test 
	public function addListNull():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.addList(null);

		Assert.areEqual(4, l.numItems);
		Assert.areEqual(" Detox Loop ABCD", l.text());
	}

	@Test 
	public function removeItem():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));
		l.insertItem(i, 4);
		l.addList('F,G,H'.split(','));

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);

		l.removeItem(i);

		Assert.areEqual(" Detox Loop ABCDFGH", l.text());
		Assert.areEqual(7, l.numItems);
	}

	@Test 
	public function removeItemByValue():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		l.removeItem('C');

		Assert.areEqual(" Detox Loop ABD", l.text());
		Assert.areEqual(3, l.numItems);
	}

	@Test 
	public function removeItemNull():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		l.removeItem(null);

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function removeItemNotInList():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));

		l.removeItem(i);

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function removeItemInListButNotInDOMOrCollection():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D,E,F'.split(','));

		var e = l.getNode(5);
		var f = l.getNode(6);

		e.removeFromDOM();
		l.collection.remove(f);

		l.removeItem('E');
		l.removeItem('F');

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function changeItem():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));
		l.insertItem(i, 4);
		l.addList('F,G,H'.split(','));

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);

		l.changeItem(i, "z");

		Assert.areEqual(" Detox Loop ABCDzFGH", l.text());
		Assert.areEqual(8, l.numItems);
	}

	@Test 
	public function changeItemNullItem():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));
		l.insertItem(i, 4);
		l.addList('F,G,H'.split(','));

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);

		l.changeItem(null, "z");

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);
	}

	@Test 
	public function changeItemNullInput():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));
		l.insertItem(i, 4);
		l.addList('F,G,H'.split(','));

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);

		l.changeItem(i, null);

		Assert.areEqual(" Detox Loop ABCDFGH", l.text());
		Assert.areEqual(7, l.numItems);
	}

	@Test 
	public function changeItemNotFound():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);

		l.changeItem(i, "z");

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function changeItemDuplicateExists():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,C,D'.split(','));
		var i = l.findItem("C");

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);

		l.changeItem(i, "A");

		Assert.areEqual(" Detox Loop ABD", l.text());
		Assert.areEqual(3, l.numItems);
	}

	@Test 
	public function moveItemForward():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,1,B,C,D'.split(','));

		// Place '1' after 'C'
		var i = l.findItem("1");
		l.moveItem(i, 4);

		Assert.areEqual(" Detox Loop ABC1D", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemBackward():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,C,1,D'.split(','));

		// Place '1' after 'A'
		var i = l.findItem("1");
		l.moveItem(i, 1);

		Assert.areEqual(" Detox Loop A1BCD", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemSameLocation():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,1,C,D'.split(','));

		// Move '1' to after 'B', where it already was
		var i = l.findItem("1");
		l.moveItem(i, 2);

		Assert.areEqual(" Detox Loop AB1CD", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemNullPos():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,1,C,D'.split(','));

		// Move '1' to a position of null, should move it to the end
		var i = l.findItem("1");
		l.moveItem(i);

		Assert.areEqual(" Detox Loop ABCD1", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemNullItem():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,1,C,D'.split(','));

		// Attempt to move item 'null', nothing should change
		var i = l.findItem("1");
		l.moveItem(null, 0);

		Assert.areEqual(" Detox Loop AB1CD", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemItemNotFound():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,C,D'.split(','));

		// Attempt to move item that is not in list, it should be inserted
		var i = l.generateItem("1");
		l.moveItem(i, 3);

		Assert.areEqual(" Detox Loop ABC1D", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemPositionOutOfRange():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,C,D'.split(','));

		// Move '1' to a position of null, should move it to the end
		var a = l.findItem("A");
		var b = l.findItem("B");
		l.moveItem(a, -100);
		l.moveItem(b, 100);

		Assert.areEqual(" Detox Loop CDAB", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function moveItemWasAlreadyMovedOnDOM():Void
	{
		var div = "div".create();

		var l = new Loop<String>();
		l.appendTo(div);
		l.preventDuplicates = true;
		l.addList('A,1,B,C,D'.split(','));
		Assert.areEqual("<!-- Detox Loop -->A1BCD", div.innerHTML());

		// On the DOM, move the 1 to the end
		var i = l.findItem("1");
		i.dom.insertThisAfter(l.last());
		Assert.areEqual("<!-- Detox Loop -->ABCD1", div.innerHTML());

		// In the Loop, place '1' at the beginning
		l.moveItem(i, 0);
		Assert.areEqual("<!-- Detox Loop -->1ABCD", div.innerHTML());
	}

	@Test 
	public function moveItemItemWasRemovedOnDOM():Void
	{
		var div = "div".create();

		var l = new Loop<String>();
		l.appendTo(div);
		l.preventDuplicates = true;
		l.addList('A,1,B,C,D'.split(','));
		Assert.areEqual("<!-- Detox Loop -->A1BCD", div.innerHTML());

		// On the DOM, remove the one
		var i = l.findItem("1");
		i.dom.removeFromDOM();
		Assert.areEqual("<!-- Detox Loop -->ABCD", div.innerHTML());

		// In the Loop, place '1' at the beginning
		l.moveItem(i, 0);
		Assert.areEqual("<!-- Detox Loop -->1ABCD", div.innerHTML());
	}

	@Test 
	public function getItemPos():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		
		var i = l.generateItem('1');
		l.insertItem(i, 2);
		Assert.areEqual(" Detox Loop AB1CD", l.text());
		Assert.areEqual(2, l.getItemPos(i));

		l.moveItem(i);
		Assert.areEqual(" Detox Loop ABCD1", l.text());
		Assert.areEqual(4, l.getItemPos(i));
	}

	@Test 
	public function getItemPosNull():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		Assert.areEqual(-1, l.getItemPos(null));
	}

	@Test 
	public function getItemPosNotInList():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem('1');
		l.addList('A,B,C,D'.split(','));
		Assert.areEqual(-1, l.getItemPos(i));
	}

	@Test
	public function getItemPosItemMovedInDOM():Void
	{
		var div = "body".create();
		var l = new Loop<String>();
		l.appendTo(div);

		l.addList('A,1,B,C,D'.split(','));
		var i = l.findItem("1");


		// Test starting position
		Assert.areEqual("<!-- Detox Loop -->A1BCD", div.innerHTML());
		Assert.areEqual(1, l.getItemPos(i));

		// On the DOM, move the 1 to the end
		i.dom.insertThisAfter(l.last());
		Assert.areEqual("<!-- Detox Loop -->ABCD1", div.innerHTML());
		Assert.areEqual(1, l.getItemPos(i));

		// In the Loop, place '1' at the beginning
		l.moveItem(i, 0);
		Assert.areEqual("<!-- Detox Loop -->1ABCD", div.innerHTML());
		Assert.areEqual(0, l.getItemPos(i));
	}

	@Test 
	public function findItemValue():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		var i1 = l.findItem('B');
		var i2 = l.findItem('D');

		Assert.areEqual('B', i1.dom.text());
		Assert.areEqual(1, l.getItemPos(i1));
		Assert.areEqual('D', i2.dom.text());
		Assert.areEqual(3, l.getItemPos(i2));
	}

	@Test 
	public function findItemDomNode():Void
	{
		var l = new Loop<String>();
		l.addList('A,B<b>B</b>,C,D,I<i>I</i>'.split(','));

		var node1 = l.getNode(3); // <b>B</b>
		var node2 = node1.next(false); // C

		var i1 = l.findItem(node1);
		var i2 = l.findItem(node2);

		Assert.areEqual('BB', i1.dom.text());
		Assert.areEqual('C', i2.dom.text());
	}

	@Test 
	public function findItemDomCollection():Void
	{
		var div = "div".create();
		div.setInnerHTML("<p><b>Something</b></p> goes in <b>here</b>");

		var l = new Loop<String>();
		l.appendTo(div);
		l.addList('A,B<b>B</b>,C,D,I<i>I</i>'.split(','));

		var collection = div.find("b");

		var i1 = l.findItem(collection);

		Assert.areEqual('BB', i1.dom.text());
	}

	@Test 
	public function findItemCorrectOrder():Void
	{
		// Return first match in this order: value, node, collection

		var l = new Loop<String>();
		var a = l.addItem('A');
		var b = l.addItem('B');
		var z = l.generateItem("Z");

		l.addList('C,D,E,F'.split(','));

		// Should match the value 1st, not test the 2nd and 3rd
		var i1 = l.findItem(a.input, b.dom.getNode(), b.dom);

		// Will fail on the 1st, match the 2nd, and not test the 3rd
		var i2 = l.findItem(z.input, a.dom.getNode(), b.dom);

		// Will fail on 1st and 2nd, match the 3rd
		var i3 = l.findItem(z.input, z.dom.getNode(), a.dom);

		Assert.areEqual("A", i1.dom.text());
		Assert.areEqual("A", i2.dom.text());
		Assert.areEqual("A", i3.dom.text());
	}

	@Test 
	public function findItemNull():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C'.split(','));

		var i1 = l.findItem(null, null, null);
		var i2 = l.findItem();

		Assert.isNull(i1);
		Assert.isNull(i2);
	}

	@Test 
	public function findItemNotInList():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem('F');
		var node = i.dom.getNode();

		l.addList('A,B,C,D'.split(','));

		var i1 = l.findItem('E');
		var i2 = l.findItem(i.dom);
		var i3 = l.findItem(node);

		Assert.isNull(i1);
		Assert.isNull(i2);
		Assert.isNull(i3);
	}

	@Test 
	public function insertLoopIntoDOM():Void
	{
		var div = "<div><p>Paragraph</p><span>Span</span></div>".parse();
		var l = new Loop<String>();
		l.appendTo(div.find("p"));
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual("<div><p>Paragraph<!-- Detox Loop -->ABCD</p><span>Span</span></div>", div.html());
		Assert.areEqual(6, div.find("p").children(false).length);

		l.addItem('E');

		Assert.areEqual("<div><p>Paragraph<!-- Detox Loop -->ABCDE</p><span>Span</span></div>", div.html());
		Assert.areEqual(7, div.find("p").children(false).length);
	}

	@Test
	public function insertLoopThenAddList():Void
	{
		var div = "div".create();
		var l = new Loop<String>();
		l.appendTo(div);

		l.addList('A,B,C,D'.split(','));

		// Test starting position
		Assert.areEqual("<!-- Detox Loop -->ABCD", div.innerHTML());
	}

	@Test 
	public function removeLoopFromDOM():Void
	{
		var div = "<div><p>Paragraph</p><span>Span</span></div>".parse();
		var l = new Loop<String>();
		l.appendTo(div.find("p"));
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual("<div><p>Paragraph<!-- Detox Loop -->ABCD</p><span>Span</span></div>", div.html());
		Assert.areEqual(6, div.find("p").children(false).length);

		l.removeFromDOM();

		Assert.areEqual("<div><p>Paragraph</p><span>Span</span></div>", div.html());
		Assert.areEqual(1, div.find("p").children(false).length);
	}

	@Test 
	public function removeLoopAndReattach():Void
	{
		var div = "<div><p>Paragraph</p><span>Span</span></div>".parse();
		var l = new Loop<String>();
		l.appendTo(div.find("p"));
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual("<div><p>Paragraph<!-- Detox Loop -->ABCD</p><span>Span</span></div>", div.html());
		Assert.areEqual(6, div.find("p").children(false).length);

		l.removeFromDOM();
		l.addItem('E');

		Assert.areEqual("<div><p>Paragraph</p><span>Span</span></div>", div.html());
		Assert.areEqual(1, div.find("p").children(false).length);

		l.appendTo(div.find("p"));

		Assert.areEqual("<div><p>Paragraph<!-- Detox Loop -->ABCDE</p><span>Span</span></div>", div.html());
		Assert.areEqual(7, div.find("p").children(false).length);
	}

	@Test
	public function setJoin():Void
	{
		// Normal
		var l1 = new Loop<String>();
		l1.setJoins(", ", " and ", ". ");
		l1.addList('A,B,C,D'.split(','));
		Assert.areEqual(" Detox Loop A, B, C and D. ", l1.text());

		// Add afterwards
		var l2 = new Loop<String>();
		l2.addList('A,B,C,D'.split(','));
		Assert.areEqual(" Detox Loop ABCD", l2.text());
		l2.setJoins(", ", " and ", ". ");
		Assert.areEqual(" Detox Loop A, B, C and D. ", l2.text());

		// Add after attached
		var div = "div".create();
		var l3 = new Loop<String>();
		div.append( l3 );
		l3.addList('A,B,C,D'.split(','));
		Assert.areEqual("ABCD", div.text());
		l3.setJoins(", ", " and ", ". ");
		Assert.areEqual("A, B, C and D. ", div.text());

		// Add before attached
		var div2 = "div".create();
		var l4 = new Loop<String>();
		l4.addList('A,B,C,D'.split(','));
		l4.setJoins(", ", " and ", ". ");
		div2.append( l4 );
		Assert.areEqual("A, B, C and D. ", div2.text());

		// Change joins
		var l5 = new Loop<String>();
		var div3 = "div".create().append( l5 );
		l5.addList('A,B,C,D'.split(','));
		l5.setJoins(", ", " and ", ". ");
		Assert.areEqual("A, B, C and D. ", div3.text());
		l5.setJoins(" and then ", " and finally ", "!!");
		Assert.areEqual("A and then B and then C and finally D!!", div3.text());

		// null values
		l5.setJoins(",");
		Assert.areEqual("A,B,C,D", div3.text());
		l5.setJoins(",",null,".");
		Assert.areEqual("A,B,C,D.", div3.text());
		l5.setJoins(null," and ",null);
		Assert.areEqual("ABC and D", div3.text());
		l5.setJoins(null,null,".");
		Assert.areEqual("ABCD.", div3.text());

		// Empty
		l5.empty();
		Assert.areEqual("", div3.text());

		// HTML joins
		var l6 = new Loop<String>();
		var div4 = "div".create().append( l6 );
		l6.addList('A,B,C,D'.split(','));
		l6.setJoins("<hr />","<hr class='final' />","<footer />");
		Assert.areEqual(9, div4.children(false).length);
		Assert.areEqual(3, div4.find("hr").length);
		Assert.areEqual(1, div4.find("hr.final").length);
		Assert.areEqual(1, div4.find("footer").length);

		// InsertItem

		var l6 = new Loop<String>();
		var div4 = "div".create().append( l6 );
		l6.addList('A,B,C,D'.split(','));
		l6.setJoins(", ", " and ", ". ");
		Assert.areEqual("A, B, C and D. ", div4.text());
		// last changes
			l6.addItem("E");
			Assert.areEqual("A, B, C, D and E. ", div4.text());
		// second last changes
			l6.addItem("F",4);
			Assert.areEqual("A, B, C, D, F and E. ", div4.text());
		// does not affect last or second last
			l6.addItem("G",1);
			Assert.areEqual("A, G, B, C, D, F and E. ", div4.text());


		// RemoveItem

		var l7 = new Loop<String>();
		var div5 = "div".create().append( l7 );
		l7.addList('A,B,C,D,E,F,G'.split(','));

		l7.setJoins(", ", " and ", ". ");
		Assert.areEqual("A, B, C, D, E, F and G. ", div5.text());
		// last changes
			l7.removeItem("G");
			Assert.areEqual("A, B, C, D, E and F. ", div5.text());
		// second last changes
			l7.removeItem("E");
			Assert.areEqual("A, B, C, D and F. ", div5.text());
		// does not affect last or second last
			l7.removeItem("B");
			Assert.areEqual("A, C, D and F. ", div5.text());

		// MoveItem

		var l8 = new Loop<String>();
		var div6 = "div".create().append( l8 );
		l8.addList('A,B,C,D,E,F,G'.split(','));

		var b = l8.findItem( "B" );
		var e = l8.findItem( "E" );
		var g = l8.findItem( "G" );

		l8.setJoins(", ", " and ", ". ");
		Assert.areEqual("A, B, C, D, E, F and G. ", div6.text());
		// last changes
			l8.moveItem(g, 1);
			Assert.areEqual("A, G, B, C, D, E and F. ", div6.text());
		// second last changes
			l8.moveItem(e, 1);
			Assert.areEqual("A, E, G, B, C, D and F. ", div6.text());
		// does not affect last or second last
			l8.moveItem(b, 1);
			Assert.areEqual("A, B, E, G, C, D and F. ", div6.text());
	}
}
