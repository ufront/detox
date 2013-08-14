package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import Detox;
using Detox;



class TraversingTest 
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

	public var sampleDocument:Node;
	public var h1:Node;
	public var a:Node;
	public var b:Node;
	public var emptyNode:Node;
	public var nullNode:Node;
	public var textNode1:Node;
	public var textNode2:Node;
	public var commentNode:Node;
	public var recursive:Node;
	
	@Before
	public function setup():Void
	{
		sampleDocument = "<myxml>
			<h1>Title</h1>
			<ul id='a'>
				<li id='a1'>1</li>
				<li id='a2' class='pickme'>2</li>
				<li id='a3'>3</li>
				<li id='a4'>4</li>
			</ul>
			<ul id='b'>
				<li id='b1'>1</li>
				<li id='b2' class='pickme'>2</li>
				<li id='b3'>3</li>
				<li id='b4'>4</li>
			</ul>
			<div id='empty1' class='empty'></div>
			<div id='empty2' class='empty'></div>
			<div id='nonElements'>Before<!--Comment-->After</div>
			<div id='recursive' class='level1'>
				<div class='level2'>
					<div class='level3'>
						<div class='level4'>
						</div>
					</div>
				</div>
			</div>
		</myxml>".parse().getNode();
		Detox.setDocument(sampleDocument);

		h1 = "h1".find().getNode();
		a = "#a".find().getNode();
		b = "#b".find().getNode();
		emptyNode = "#empty1".find().getNode();
		nullNode = null;
		var nonElements = "#nonElements".find().children;
		textNode1 = nonElements.getNode(0);
		commentNode = nonElements.getNode(1);
		textNode2 = nonElements.getNode(2);
		recursive = "#recursive".find().getNode();
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test
	public function children()
	{
		Assert.areEqual(4, a.elements.length);
		Assert.areEqual(4, b.elements.length);
		Assert.areEqual(7, sampleDocument.elements.length);
	}

	@Test
	public function childrenOnNull()
	{
		Assert.areEqual(0, nullNode.elements.length);
	}

	@Test
	public function childrenOnNonElement()
	{
		Assert.areEqual(0, textNode1.elements.length);
		Assert.areEqual(0, textNode2.elements.length);
		Assert.areEqual(0, commentNode.elements.length);
	}

	@Test
	public function childrenElementsOnly()
	{
		Assert.areEqual(0, h1.elements.length);
		Assert.areEqual(1, h1.children.length);
	}

	@Test
	public function childrenOnEmptyElement()
	{
		Assert.areEqual(0, emptyNode.elements.length);
	}

	@Test
	public function firstChildren()
	{
		Assert.areEqual("a1", a.firstElement.attr('id'));
		Assert.areEqual("b1", b.firstElement.attr('id'));
		var level2 = ".level2".find().getNode();
		Assert.areEqual("level3", level2.firstElement.attr('class'));
	}

	@Test
	public function firstChildrenOnNull()
	{
		Assert.isNull(nullNode.firstElement);
	}

	@Test
	public function firstChildrenOnEmptyElm()
	{
		Assert.isNull(emptyNode.firstElement);
	}

	@Test
	public function firstChildrenOnNonElement()
	{
		Assert.isNull(textNode1.firstElement);
		Assert.isNull(textNode2.firstElement);
		Assert.isNull(commentNode.firstElement);
	}

	@Test
	public function firstChildrenElementsOnly()
	{
		Assert.isNull(h1.firstElement);
		Assert.areEqual("Title", h1.firstChild.text);
	}

	@Test
	public function lastChildren()
	{
		Assert.areEqual("a4", a.lastElement.attr('id'));
		Assert.areEqual("b4", b.lastElement.attr('id'));
		var level2 = ".level2".find().getNode();
		Assert.areEqual("level3", level2.lastElement.attr('class'));
	}

	@Test
	public function lastChildrenOnNull()
	{
		Assert.isNull(nullNode.lastElement);
	}

	@Test
	public function lastChildrenOnEmptyElm()
	{
		Assert.isNull(emptyNode.lastElement);
	}

	@Test
	public function lastChildrenOnNonElement()
	{
		Assert.isNull(textNode1.lastElement);
		Assert.isNull(textNode2.lastElement);
		Assert.isNull(commentNode.lastElement);
	}

	@Test
	public function lastChildrenElementsOnly()
	{
		Assert.isNull(h1.elements.first);
		Assert.areEqual("Title", h1.firstChild.text);
	}

	@Test
	public function parent()
	{
		Assert.isTrue(a == "#a1".find().getNode().parent);
		Assert.isTrue(".level4".find().getNode().parent.hasClass('level3'));
		Assert.areEqual("nonElements", textNode1.parent.attr('id'));
		Assert.areEqual("nonElements", textNode2.parent.attr('id'));
		Assert.areEqual("nonElements", commentNode.parent.attr('id'));
	}

	@Test
	public function parentOnNull()
	{
		// When we use XML, parent is already a method of the object,
		// so our "using Detox" parents() doesn't get called.
		// As a result, we loose null-safety.  The workaround is to 
		// use parents() instead.
		Assert.isNull(nullNode.parent);
	}

	@Test
	public function parentOnParentNull()
	{
		#if js
		var doc:Node = untyped __js__('document');
		#else 
		var doc = Xml.createDocument();
		#end
		Assert.isNull(doc.parent);
		Assert.isNotNull(sampleDocument.parent); // it has a parent: the document it was attached to
	}

	@Test
	public function ancestors()
	{
		var level4 = ".level4".find().getNode();
		var level3 = ".level3".find().getNode();
		var level2 = ".level2".find().getNode();
		var level1 = ".level1".find().getNode();
		var textNode = h1.children.getNode();
		
		Assert.areEqual(5, level4.ancestors.length);
		Assert.areEqual(4, level3.ancestors.length);
		Assert.areEqual(3, level2.ancestors.length);
		Assert.areEqual(2, level1.ancestors.length);
		Assert.areEqual(1, sampleDocument.ancestors.length);
		Assert.areEqual(3, textNode.ancestors.length);
	}

	@Test
	public function ancestorsOnNull()
	{
		Assert.areEqual(0, nullNode.ancestors.length);
	}

	@Test
	public function ancestorsOnParentNull()
	{
		#if js 
		var doc:Node = untyped __js__('document');
		#else
		var doc:Node = Xml.createDocument(); 
		#end 
		Assert.areEqual(0, doc.ancestors.length);
		Assert.areEqual(1, sampleDocument.ancestors.length);
	}

	@Test
	public function descendants()
	{
		Assert.areEqual(4, a.descendantElements.length);
		Assert.areEqual(3, recursive.descendantElements.length);
	}

	@Test
	public function descendantsElementsOnly()
	{
		Assert.areEqual(13, a.descendants.length);
		Assert.areEqual(10, recursive.descendants.length);
	}

	@Test
	public function descendantsOnNull()
	{
		Assert.areEqual(0, nullNode.descendantElements.length);
	}

	@Test
	public function descendantsOnNonElement()
	{
		Assert.areEqual(0, textNode1.descendantElements.length);
		Assert.areEqual(0, textNode2.descendantElements.length);
		Assert.areEqual(0, commentNode.descendantElements.length);
	}

	@Test
	public function descendantsOnNoDescendants()
	{
		Assert.areEqual(0, emptyNode.descendantElements.length);
	}

	@Test
	public function next()
	{
		var node1 = a.find('.pickme').getNode();
		var node2 = b.find('.pickme').getNode();
		Assert.areEqual('a3', node1.nextElement.attr('id'));
		Assert.areEqual('b3', node2.nextElement.attr('id'));
	}

	@Test
	public function nextElementOnly()
	{
		Assert.isNull(commentNode.nextElement);
		Assert.isNotNull(commentNode.next);
		Assert.areEqual(textNode2.val, commentNode.next.val);
	}

	@Test
	public function nextOnNull()
	{
		Assert.isNull(nullNode.nextElement);
	}

	@Test
	public function nextWhenThereIsNoNext()
	{
		var lastLi = a.elements.getNode(3);
		Assert.isNull(lastLi.nextElement);
	}

	@Test
	public function prev()
	{
		var node1 = a.find('.pickme').getNode();
		var node2 = b.find('.pickme').getNode();
		Assert.areEqual('a1', node1.prevElement.attr('id'));
		Assert.areEqual('b1', node2.prevElement.attr('id'));
	}

	@Test
	public function prevElementOnly()
	{
		Assert.isNull(commentNode.prevElement);
		Assert.isNotNull(commentNode.prev);
		Assert.areEqual(textNode1.val, commentNode.prev.val);
	}

	@Test
	public function prevOnNull()
	{
		Assert.isNull(nullNode.prev);
	}

	@Test
	public function prevWhenThereIsNoPrev()
	{
		var lastLi = a.elements.getNode(0);
		Assert.isNull(lastLi.prevElement);
	}

	@Test
	public function find()
	{
		Assert.areNotEqual(0, sampleDocument.find('*').length);
		Assert.areEqual(2, sampleDocument.find('ul').length);
		Assert.areEqual(7, sampleDocument.find('div').length);
		Assert.areEqual(1, sampleDocument.find('#a').length);

		var recursive = "#recursive".find().getNode();
		Assert.areEqual(1, recursive.find('.level4').length);
		Assert.areEqual(1, recursive.find('.level4').length);
		Assert.areEqual(3, recursive.find('div').length);
	}

	@Test
	public function findTwice() 
	{
		var length1 = "#recursive".find().length;
		var length2 = "#recursive".find().length;
		Assert.areEqual(length1, length2);
	}

	@Test
	public function findOnNull()
	{
		Assert.areEqual(0, nullNode.find('*').length);
	}

	@Test
	public function findNoResults()
	{
		Assert.areEqual(0, sampleDocument.find('video').length);
		Assert.areEqual(0, sampleDocument.find('.notfound').length);
		Assert.areEqual(0, sampleDocument.find('[notfound]').length);
		Assert.areEqual(0, sampleDocument.find('#notfound').length);
	}

	@Test
	public function findOnWrongNodeType()
	{
		Assert.areEqual(0, commentNode.find('ul').length);
	}

	@Test
	public function chaining()
	{
	Assert.areEqual('b', a.firstElement.lastChild.parent.parent.nextElement.attr('id'));
	Assert.areEqual('a', b.firstElement.lastChild.parent.parent.prev.prev.attr('id'));
		Assert.areEqual('a1', a.find('li').attr('id'));
		Assert.areEqual('a1', a.elements.attr('id'));
		Assert.areEqual('myxml', a.ancestors.tagName);
	}
}
