package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import Detox;
using Detox;
import dtx.DOMCollection;
import dtx.DOMNode;

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

	public var sampleDocument:DOMNode;
	public var h1:DOMNode;
	public var a:DOMNode;
	public var b:DOMNode;
	public var emptyNode:DOMNode;
	public var nullNode:DOMNode;
	public var textNode1:DOMNode;
	public var textNode2:DOMNode;
	public var commentNode:DOMNode;
	
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
		var nonElements = "#nonElements".find().children(false);
		textNode1 = nonElements.getNode(0);
		commentNode = nonElements.getNode(1);
		textNode2 = nonElements.getNode(2);
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function children()
	{
		Assert.areEqual(4, a.children().length);
		Assert.areEqual(4, b.children().length);
		Assert.areEqual(7, sampleDocument.children().length);
	}

	@Test 
	public function childrenOnNull()
	{
		Assert.areEqual(0, nullNode.children().length);
	}

	@Test 
	public function childrenOnNonElement()
	{
		Assert.areEqual(0, textNode1.children().length);
		Assert.areEqual(0, textNode2.children().length);
		Assert.areEqual(0, commentNode.children().length);
	}

	@Test 
	public function childrenElementsOnly()
	{
		Assert.areEqual(0, h1.children().length);
		Assert.areEqual(1, h1.children(false).length);
	}

	@Test 
	public function childrenOnEmptyElement()
	{
		Assert.areEqual(0, emptyNode.children().length);
	}

	@Test 
	public function firstChildren()
	{
		Assert.areEqual("a1", a.firstChildren().attr('id'));
		Assert.areEqual("b1", b.firstChildren().attr('id'));
		var level2 = ".level2".find().getNode();
		Assert.areEqual("level3", level2.firstChildren().attr('class'));
	}

	@Test 
	public function firstChildrenOnNull()
	{
		Assert.isNull(nullNode.firstChildren());
	}

	@Test 
	public function firstChildrenOnEmptyElm()
	{
		Assert.isNull(emptyNode.firstChildren());
	}

	@Test 
	public function firstChildrenOnNonElement()
	{
		Assert.isNull(textNode1.firstChildren());
		Assert.isNull(textNode2.firstChildren());
		Assert.isNull(commentNode.firstChildren());
	}

	@Test 
	public function firstChildrenElementsOnly()
	{
		Assert.isNull(h1.firstChildren());
		Assert.areEqual("Title", h1.firstChildren(false).text());
	}

	@Test 
	public function lastChildren()
	{
		Assert.areEqual("a4", a.lastChildren().attr('id'));
		Assert.areEqual("b4", b.lastChildren().attr('id'));
		var level2 = ".level2".find().getNode();
		Assert.areEqual("level3", level2.lastChildren().attr('class'));
	}

	@Test 
	public function lastChildrenOnNull()
	{
		Assert.isNull(nullNode.lastChildren());
	}

	@Test 
	public function lastChildrenOnEmptyElm()
	{
		Assert.isNull(emptyNode.lastChildren());
	}

	@Test 
	public function lastChildrenOnNonElement()
	{
		Assert.isNull(textNode1.lastChildren());
		Assert.isNull(textNode2.lastChildren());
		Assert.isNull(commentNode.lastChildren());
	}

	@Test 
	public function lastChildrenElementsOnly()
	{
		Assert.isNull(h1.firstChildren());
		Assert.areEqual("Title", h1.firstChildren(false).text());
	}

	@Test 
	public function parent()
	{
		Assert.isTrue(a == "#a1".find().getNode().parents());
		Assert.isTrue(".level4".find().getNode().parents().hasClass('level3'));
		Assert.areEqual("nonElements", textNode1.parents().attr('id'));
		Assert.areEqual("nonElements", textNode2.parents().attr('id'));
		Assert.areEqual("nonElements", commentNode.parents().attr('id'));
	}

	@Test 
	public function parentOnNull()
	{
		// When we use XML, parent is already a method of the object,
		// so our "using Detox" parents() doesn't get called.
		// As a result, we loose null-safety.  The workaround is to 
		// use parents() instead.
		Assert.isNull(nullNode.parents());
	}

	@Test 
	public function parentOnParentNull()
	{
		#if js
		var doc:DOMNode = untyped __js__('document');
		#else 
		var doc = Xml.createDocument();
		#end
		Assert.isNull(doc.parents());
		Assert.isNull(sampleDocument.parents());
	}

	@Test 
	public function ancestors()
	{
		var level4 = ".level4".find().getNode();
		var level3 = ".level3".find().getNode();
		var level2 = ".level2".find().getNode();
		var level1 = ".level1".find().getNode();
		var textNode = h1.children(false).getNode();
		Assert.areEqual(4, level4.ancestors().length);
		Assert.areEqual(3, level3.ancestors().length);
		Assert.areEqual(2, level2.ancestors().length);
		Assert.areEqual(1, level1.ancestors().length);
		Assert.areEqual(2, textNode.ancestors().length);
	}

	@Test 
	public function ancestorsOnNull()
	{
		Assert.areEqual(0, nullNode.ancestors().length);
	}

	@Test 
	public function ancestorsOnParentNull()
	{
		#if js 
		var doc:DOMNode = untyped __js__('document');
		#else
		var doc = Xml.createDocument(); 
		#end 
		Assert.areEqual(0, doc.ancestors().length);
		Assert.areEqual(0, sampleDocument.ancestors().length);
	}

	@Test 
	public function next()
	{
		var node1 = a.find('.pickme').getNode();
		var node2 = b.find('.pickme').getNode();
		Assert.areEqual('a3', node1.next().attr('id'));
		Assert.areEqual('b3', node2.next().attr('id'));
	}

	@Test
	public function nextElementOnly()
	{
		Assert.isNull(commentNode.next());
		Assert.isNotNull(commentNode.next(false));
		Assert.areEqual(textNode2.val(), commentNode.next(false).val());
	}

	@Test 
	public function nextOnNull()
	{
		Assert.isNull(nullNode.next());
	}

	@Test 
	public function nextWhenThereIsNoNext()
	{
		var lastLi = a.children().getNode(3);
		Assert.isNull(lastLi.next());
	}

	@Test 
	public function prev()
	{
		var node1 = a.find('.pickme').getNode();
		var node2 = b.find('.pickme').getNode();
		Assert.areEqual('a1', node1.prev().attr('id'));
		Assert.areEqual('b1', node2.prev().attr('id'));
	}

	@Test 
	public function prevElementOnly()
	{
		Assert.isNull(commentNode.prev());
		Assert.isNotNull(commentNode.prev(false));
		Assert.areEqual(textNode1.val(), commentNode.prev(false).val());
	}

	@Test 
	public function prevOnNull()
	{
		Assert.isNull(nullNode.prev());
	}

	@Test 
	public function prevWhenThereIsNoPrev()
	{
		var lastLi = a.children().getNode(0);
		Assert.isNull(lastLi.prev());
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
	}

	@Test 
	public function findOnWrongNodeType()
	{
		Assert.areEqual(0, commentNode.find('ul').length);
	}

	@Test 
	public function chaining()
	{
		Assert.areEqual('b', a.firstChildren().lastChildren(false).parents().parents().next().attr('id'));
		Assert.areEqual('a', b.firstChildren().lastChildren(false).parents().parents().prev().attr('id'));
		Assert.areEqual('a1', a.find('li').attr('id'));
		Assert.areEqual('a1', a.children().attr('id'));
		Assert.areEqual('myxml', a.ancestors().tagName());
	}
}
