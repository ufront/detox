package;

import massive.munit.Assert;

import DOMTools;
using DOMTools;
import domtools.DOMCollection;
import domtools.DOMNode;

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

	public var sampleDocument:DOMNode;
	public var h1:DOMNode;
	public var lists:DOMCollection;
	public var a:DOMNode;
	public var b:DOMNode;
	public var a2:DOMNode;
	public var nonElements:DOMNode;
	public var textNode1:DOMNode;
	public var comment:DOMNode;
	public var textNode2:DOMNode;
	public var emptyNode:DOMNode;
	public var nullNode:DOMNode;

	public var sampleNode:DOMNode;
	public var sampleListItem:DOMNode;
	public var sampleDOMCollection:DOMCollection;
	public var insertSiblingContentNode:DOMNode;
	public var insertSiblingContentDOMCollection:DOMCollection;
	public var insertSiblingTargetNode:DOMNode;
	public var insertSiblingTargetDOMCollection:DOMCollection;
	
	@Before
	public function setup():Void
	{
		sampleDocument = "<myxml>
			<h1>Title</h1>
			<ul id='a'>
				<li id='a1'>1</li>
				<li id='a2'>2</li>
				<li id='a3'>3</li>
			</ul>
			<ul id='b'>
				<li id='b1'>1</li>
				<li id='b2'>2</li>
				<li id='b3'>3</li>
			</ul>
			<div id='nonelements'>Start<!--Comment-->End</div>
			<div id='empty'></div>
		</myxml>".parse().getNode();

		DOMCollection.setDocument(sampleDocument);

		h1 = "h1".find().getNode();
		lists = "ul".find();
		a = "#a".find().getNode();
		b = "#b".find().getNode();
		a2 = "#a2".find().getNode();
		nonElements = "#nonelements".find().getNode();
		textNode1 = nonElements.children(false).getNode(0);
		comment = nonElements.children(false).getNode(1);
		textNode2 = nonElements.children(false).getNode(2);
		emptyNode = "#empty".find().getNode();
		nullNode = null;

		sampleNode = "<i>Element</i>".parse().getNode();
		sampleListItem = "<li class='sample'>Sample</li>".parse().getNode();
		sampleDOMCollection = "<div class='1'><i class='target'></i></div><div class='2'><i class='target'></i></div>".parse();
		sampleDocument.append(sampleDOMCollection);

		insertSiblingTargetDOMCollection = sampleDOMCollection.find('i.target');
		insertSiblingTargetNode = sampleDOMCollection.first().find('i.target').getNode();
		insertSiblingContentDOMCollection = "<b class='content'>1</b><b class='content'>2</b>".parse();
		insertSiblingContentNode = insertSiblingContentDOMCollection.getNode(0);
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function appendNode()
	{
		// To start with, there is no .sample
		Assert.areEqual(0, a.find(".sample").length);
		a.append(sampleListItem);

		// Now it should exist, and it should be the fourth child of it's parent
		Assert.areEqual(1, a.find(".sample").length);
		Assert.areEqual(sampleListItem, a.children().getNode(3));
	}

	@Test 
	public function appendCollection()
	{
		emptyNode.append(sampleNode);
		Assert.areEqual(1, emptyNode.children().length);
		Assert.areEqual(0, emptyNode.find("div").length);

		emptyNode.append(sampleDOMCollection);

		Assert.areEqual(3, emptyNode.children().length);
		Assert.areEqual(2, emptyNode.find("div").length);
		Assert.areEqual(sampleDOMCollection.getNode(0), emptyNode.children().getNode(1));
		Assert.areEqual(sampleDOMCollection.getNode(1), emptyNode.children().getNode(2));
	}

	@Test 
	public function appendOnNull()
	{
		nullNode.append(sampleNode);
		Assert.isNotNull(sampleNode.parent());
	}

	@Test 
	public function appendNull()
	{
		Assert.areEqual("", emptyNode.innerHTML());
		emptyNode.append(null);
		Assert.areEqual("", emptyNode.innerHTML());
	}

	@Test 
	public function prependNode()
	{
		// To start with, there is no .sample
		Assert.areEqual(0, a.find(".sample").length);
		a.prepend(sampleListItem);

		// Now it should exist, and it should be the first child of it's parent
		Assert.areEqual(1, a.find(".sample").length);
		Assert.areEqual(sampleListItem, a.children().getNode(0));
	}

	@Test 
	public function prependCollection()
	{
		emptyNode.append(sampleNode);
		Assert.areEqual(1, emptyNode.children().length);
		Assert.areEqual(0, emptyNode.find("div").length);

		emptyNode.prepend(sampleDOMCollection);

		Assert.areEqual(3, emptyNode.children().length);
		Assert.areEqual(2, emptyNode.find("div").length);
		Assert.areEqual(sampleDOMCollection.getNode(0), emptyNode.children().getNode(0));
		Assert.areEqual(sampleDOMCollection.getNode(1), emptyNode.children().getNode(1));
	}

	@Test 
	public function prependOnNull()
	{
		nullNode.prepend(sampleNode);
		Assert.isNotNull(sampleNode.parent());
	}

	@Test 
	public function prependOnEmpty()
	{
		emptyNode.prepend(sampleNode);
		Assert.areEqual(1, emptyNode.children().length);
	}

	@Test 
	public function prependNull()
	{
		Assert.areEqual("", emptyNode.innerHTML());
		emptyNode.prepend(null);
		Assert.areEqual("", emptyNode.innerHTML());
	}

	@Test 
	public function appendTo_Node()
	{
		// To start with, there is no .sample
		Assert.areEqual(0, a.find(".sample").length);
		sampleListItem.appendTo(a);

		// Now it should exist, and it should be the fourth child of it's parent
		Assert.areEqual(1, a.find(".sample").length);
		Assert.areEqual(sampleListItem, a.children().getNode(3));
	}

	@Test 
	public function appendTo_Collection()
	{
		Assert.areEqual(3, a.children().length);
		Assert.areEqual(0, a.find(".sample").length);
		Assert.areEqual(3, b.children().length);
		Assert.areEqual(0, b.find(".sample").length);

		sampleListItem.appendTo(lists);

		Assert.areEqual(4, a.children().length);
		Assert.areEqual(4, b.children().length);
		Assert.areEqual(1, a.find(".sample").length);
		Assert.areEqual(1, b.find(".sample").length);
		Assert.isTrue(a.children().getNode(3).hasClass('sample'));
		Assert.isTrue(a.children().getNode(3).hasClass('sample'));
	}

	@Test 
	public function appendTo_OnNull()
	{
		Assert.areEqual("", emptyNode.innerHTML());
		nullNode.appendTo(emptyNode);
		Assert.areEqual("", emptyNode.innerHTML());
	}

	@Test 
	public function appendTo_Null()
	{
		emptyNode.appendTo(null);
		Assert.isNotNull(emptyNode.parent());
	}

	@Test 
	public function prependTo_Node()
	{
		// To start with, there is no .sample
		Assert.areEqual(0, a.find(".sample").length);
		sampleListItem.prependTo(a);

		// Now it should exist, and it should be the first child of it's parent
		Assert.areEqual(1, a.find(".sample").length);
		Assert.areEqual(sampleListItem, a.children().getNode(0));
	}

	@Test 
	public function prependTo_OnEmpty()
	{
		sampleNode.prependTo(emptyNode);
		Assert.areEqual(1, emptyNode.children().length);
	}

	@Test 
	public function prependTo_Collection()
	{
		Assert.areEqual(3, a.children().length);
		Assert.areEqual(0, a.find(".sample").length);
		Assert.areEqual(3, b.children().length);
		Assert.areEqual(0, b.find(".sample").length);

		sampleListItem.prependTo(lists);

		Assert.areEqual(4, a.children().length);
		Assert.areEqual(4, b.children().length);
		Assert.areEqual(1, a.find(".sample").length);
		Assert.areEqual(1, b.find(".sample").length);
		Assert.isTrue(a.children().getNode(0).hasClass('sample'));
		Assert.isTrue(a.children().getNode(0).hasClass('sample'));
	}

	@Test 
	public function prependTo_OnNull()
	{
		Assert.areEqual("", emptyNode.innerHTML());
		nullNode.prependTo(emptyNode);
		Assert.areEqual("", emptyNode.innerHTML());
	}

	@Test 
	public function prependTo_Null()
	{
		emptyNode.prependTo(null);
		Assert.isNotNull(emptyNode.parent());
	}

	@Test 
	public function insertThisBefore_Node()
	{
		insertSiblingContentNode.insertThisBefore(insertSiblingTargetNode);

		// content should be first child, target second
		Assert.areEqual(insertSiblingContentNode, sampleDOMCollection.eq(0).children().getNode(0));
		Assert.areEqual(insertSiblingTargetNode, sampleDOMCollection.eq(0).children().getNode(1));
	}

	@Test 
	public function insertThisBefore_Collection()
	{
		var div1 = sampleDOMCollection.eq(0);
		var div2 = sampleDOMCollection.eq(1);

		// they should start with 1 child each
		Assert.areEqual(1, div1.children().length);
		Assert.areEqual(1, div2.children().length);
		
		insertSiblingContentNode.insertThisBefore(insertSiblingTargetDOMCollection);

		// they should end with 2 children each
		Assert.areEqual(2, div1.children().length);
		Assert.areEqual(2, div2.children().length);

		// the innerHTML should be the same
		Assert.areEqual(div1.innerHTML(), div2.innerHTML());

		// check the order: should be content first, then target
		Assert.areEqual(insertSiblingContentNode, div1.children().getNode(0));
		Assert.areEqual(insertSiblingTargetDOMCollection.getNode(0), div1.children().getNode(1));
		
		Assert.areEqual(insertSiblingTargetDOMCollection.getNode(1), div2.children().getNode(1));
		// This final one is a clone, so it won't be exactly equal, but it should be identical
		Assert.areEqual(insertSiblingContentNode.innerHTML(), div2.children().getNode(0).innerHTML());
		Assert.areEqual(insertSiblingContentNode.attr('class'), div2.children().getNode(0).attr('class'));
	}

	@Test 
	public function insertThisBefore_OnNull()
	{
		nullNode.insertThisBefore(a2);
		Assert.areEqual(0, a.find('.sample').length);
	}

	@Test 
	public function insertThisBefore_Null()
	{
		a2.insertThisBefore(nullNode);
		Assert.areEqual(a, a2.parentNode);
	}

	@Test 
	public function insertThisAfter_Node()
	{
		insertSiblingContentNode.insertThisAfter(insertSiblingTargetNode);

		// First node should be target, second should be content
		Assert.areEqual(insertSiblingTargetNode, sampleDOMCollection.eq(0).children().getNode(0));
		Assert.areEqual(insertSiblingContentNode, sampleDOMCollection.eq(0).children().getNode(1));
	}

	@Test 
	public function insertThisAfter_Collection()
	{
		var div1 = sampleDOMCollection.eq(0);
		var div2 = sampleDOMCollection.eq(1);

		// they should start with 1 child each
		Assert.areEqual(1, div1.children().length);
		Assert.areEqual(1, div2.children().length);

		insertSiblingContentNode.insertThisAfter(insertSiblingTargetDOMCollection);

		// they should end with 2 children each
		Assert.areEqual(2, div1.children().length);
		Assert.areEqual(2, div2.children().length);

		// the innerHTML should be the same
		Assert.areEqual(div1.innerHTML(), div2.innerHTML());

		// check the order: should be target first, then content
		Assert.areEqual(insertSiblingTargetDOMCollection.getNode(0), div1.children().getNode(0));
		Assert.areEqual(insertSiblingContentNode, div1.children().getNode(1));
		Assert.areEqual(insertSiblingTargetDOMCollection.getNode(1), div2.children().getNode(0));
		// This final one is a clone, so it won't be exactly equal, but it should be identical
		Assert.areEqual(insertSiblingContentNode.innerHTML(), div2.children().getNode(1).innerHTML());
		Assert.areEqual(insertSiblingContentNode.attr('class'), div2.children().getNode(1).attr('class'));
	}

	@Test 
	public function insertThisAfter_OnNull()
	{
		var before = a.innerHTML();
		nullNode.insertThisAfter(a2);
		Assert.areEqual(before, a.innerHTML());
	}

	@Test 
	public function insertThisAfter_Null()
	{
		a2.insertThisAfter(nullNode);
		Assert.areEqual(a, a2.parentNode);
	}

	@Test 
	public function beforeThisInsert_Node()
	{
		insertSiblingTargetNode.beforeThisInsert(insertSiblingContentNode);

		// First node should be content, second should be target
		Assert.areEqual(insertSiblingContentNode, sampleDOMCollection.eq(0).children().getNode(0));
		Assert.areEqual(insertSiblingTargetNode, sampleDOMCollection.eq(0).children().getNode(1));
	}

	@Test 
	public function beforeThisInsert_Collection()
	{
		insertSiblingTargetNode.beforeThisInsert(insertSiblingContentDOMCollection);

		// first and second should be content, third should be target
		Assert.areEqual(3, sampleDOMCollection.eq().children().length);
		Assert.areEqual(insertSiblingContentDOMCollection.getNode(0), sampleDOMCollection.eq(0).children().getNode(0));
		Assert.areEqual(insertSiblingContentDOMCollection.getNode(1), sampleDOMCollection.eq(0).children().getNode(1));
		Assert.areEqual(insertSiblingTargetNode, sampleDOMCollection.eq(0).children().getNode(2));
	}

	@Test 
	public function beforeThisInsert_OnNull()
	{
		nullNode.beforeThisInsert(a2);
		Assert.areEqual(a, a2.parentNode);
	}

	@Test 
	public function beforeThisInsert_Null()
	{
		a2.beforeThisInsert(nullNode);
		Assert.isNull(nullNode.parent());
	}

	@Test 
	public function afterThisInsert_Node()
	{
		insertSiblingTargetNode.afterThisInsert(insertSiblingContentNode);

		// First node should be target, second should be content
		Assert.areEqual(insertSiblingTargetNode, sampleDOMCollection.eq(0).children().getNode(0));
		Assert.areEqual(insertSiblingContentNode, sampleDOMCollection.eq(0).children().getNode(1));
	}

	@Test 
	public function afterThisInsert_Collection()
	{
		insertSiblingTargetNode.afterThisInsert(insertSiblingContentDOMCollection);

		// first should be target, second and third content
		Assert.areEqual(3, sampleDOMCollection.eq().children().length);
		Assert.areEqual(insertSiblingTargetNode, sampleDOMCollection.eq(0).children().getNode(0));
		Assert.areEqual(insertSiblingContentDOMCollection.getNode(0), sampleDOMCollection.eq(0).children().getNode(1));
		Assert.areEqual(insertSiblingContentDOMCollection.getNode(1), sampleDOMCollection.eq(0).children().getNode(2));
	}

	@Test 
	public function afterThisInsert_OnNull()
	{
		nullNode.afterThisInsert(a2);
		Assert.areEqual(a, a2.parentNode);
	}

	@Test 
	public function afterThisInsert_Null()
	{
		var before = a.innerHTML();
		a2.afterThisInsert(null);
		Assert.areEqual(before, a.innerHTML());
	}

	@Test 
	public function remove()
	{
		Assert.areEqual(3, a.children().length);
		"#a1".find().getNode().remove();

		Assert.areEqual(2, a.children().length);
		"#a2".find().getNode().remove();

		Assert.areEqual(1, a.children().length);
		"#a3".find().getNode().remove();

		Assert.areEqual(0, a.children().length);
	}

	@Test 
	public function remove_onNull()
	{
		Assert.areEqual(null, nullNode.remove());
	}

	@Test 
	public function removeChildren_Node()
	{
		Assert.areEqual(3, a.children().length);
		a.removeChildren("#a1".find().getNode());

		Assert.areEqual(2, a.children().length);
		a.removeChildren("#a2".find().getNode());

		Assert.areEqual(1, a.children().length);
		a.removeChildren("#a3".find().getNode());

		Assert.areEqual(0, a.children().length);
	}

	@Test 
	public function removeChildren_Collection()
	{
		Assert.areEqual(3, a.children().length);
		a.removeChildren("#a li".find());

		Assert.areEqual(0, a.children().length);
	}

	@Test 
	public function removeChildren_Null()
	{
		var original = a.innerHTML();
		a.removeChildren(null);

		// check nothing changed
		Assert.areEqual(original, a.innerHTML());
	}

	@Test 
	public function removeChildren_OnNull()
	{
		nullNode.removeChildren(emptyNode);
		Assert.isNull(nullNode);
	}

	@Test 
	public function removeChildren_ThatAreNotActuallyChildren()
	{
		var original = a.innerHTML();
		a.removeChildren(h1);

		// check nothing changed
		Assert.areEqual(original, a.innerHTML());
	}

	@Test 
	public function empty()
	{
		Assert.areEqual(3, a.children().length);
		a.empty();
		Assert.areEqual(0, a.children().length);
	}

	@Test 
	public function emptyOnNull()
	{
		nullNode.empty();
		Assert.isNull(nullNode);
	}

	@Test 
	public function chaining()
	{
		sampleDocument.append().prepend()
			.appendTo().prependTo()
			.insertThisBefore().insertThisAfter()
			.beforeThisInsert().afterThisInsert()
			.remove().removeChildren().empty();

	}

}
