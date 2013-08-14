package;

import massive.munit.Assert;

import Detox;
using Detox;



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

	public var sampleDocument:Node;
	public var h1:Node;
	public var lists:Nodes;
	public var a:Node;
	public var b:Node;
	public var a2:Node;
	public var nonElements:Node;
	public var textNode1:Node;
	public var comment:Node;
	public var textNode2:Node;
	public var emptyNode:Node;
	public var nullNode:Node;

	public var sampleNode:Node;
	public var sampleListItem:Node;
	public var sampleDOMCollection:Nodes;
	public var insertSiblingContentNode:Node;
	public var insertSiblingContentDOMCollection:Nodes;
	public var insertSiblingTargetNode:Node;
	public var insertSiblingTargetDOMCollection:Nodes;
	
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

		Detox.setDocument(sampleDocument);

		h1 = "h1".find().getNode();
		lists = "ul".find();
		a = "#a".find().getNode();
		b = "#b".find().getNode();
		a2 = "#a2".find().getNode();
		nonElements = "#nonelements".find().getNode();
		textNode1 = nonElements.children.getNode(0);
		comment = nonElements.children.getNode(1);
		textNode2 = nonElements.children.getNode(2);
		emptyNode = "#empty".find().getNode();
		nullNode = null;

		sampleNode = "<i>Element</i>".parse().getNode();
		sampleListItem = "<li class='sample'>Sample</li>".parse().getNode();
		sampleDOMCollection = "<p class='p1'><i class='target'>i</i></p><p class='p2'><i class='target'>i</i></p>".parse();
		sampleDocument.append(sampleDOMCollection);

		insertSiblingTargetDOMCollection = sampleDOMCollection.find('i.target');
		insertSiblingTargetNode = sampleDOMCollection.find('.p1 i.target').getNode();
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
		Assert.isTrue(sampleListItem == a.elements.getNode(3));
	}

	@Test
	public function appendNodeThatIsAlreadyAttached()
	{
		Assert.areEqual(a.html, a2.parent.html);
		Assert.areEqual(0, b.find('#a2').length);
		Assert.areEqual(3, a.elements.length);
		Assert.areEqual(3, b.elements.length);

		b.append(a2);

		Assert.areEqual(b.html, a2.parent.html);
		Assert.areEqual(0, a2.find('#a2').length);
		Assert.areEqual(2, a.elements.length);
		Assert.areEqual(4, b.elements.length);
	}

	@Test 
	public function appendCollection()
	{
		emptyNode.append(sampleNode);
		Assert.areEqual(1, emptyNode.elements.length);
		Assert.areEqual(1, emptyNode.find("i").length);

		emptyNode.append(sampleDOMCollection);

		Assert.areEqual(3, emptyNode.elements.length);
		Assert.areEqual(2, emptyNode.find("p").length);
		Assert.isTrue(sampleDOMCollection.getNode(0) == emptyNode.elements.getNode(1));
		Assert.isTrue(sampleDOMCollection.getNode(1) == emptyNode.elements.getNode(2));
	}

	@Test 
	public function appendOnNull()
	{
		nullNode.append(sampleNode);
		Assert.isNotNull(sampleNode.parent);
	}

	@Test 
	public function appendNull()
	{
		Assert.areEqual("", emptyNode.innerHTML);
		emptyNode.append(null);
		Assert.areEqual("", emptyNode.innerHTML);
	}

	@Test @TestDebug
	public function prependNode()
	{
		// To start with, there is no .sample
		Assert.areEqual(0, a.find(".sample").length);
		a.prepend(sampleListItem);
		
		// Now it should exist, and it should be the first child of it's parent
		Assert.areEqual(1, a.find(".sample").length);
		Assert.isTrue(sampleListItem == a.elements.getNode(0));
	}

	@Test 
	public function prependCollection()
	{
		emptyNode.append(sampleNode);
		Assert.areEqual(1, emptyNode.elements.length);
		Assert.areEqual(1, emptyNode.find("i").length);

		emptyNode.prepend(sampleDOMCollection);

		Assert.areEqual(3, emptyNode.elements.length);
		Assert.areEqual(2, emptyNode.find("p").length);
		Assert.isTrue(sampleDOMCollection.getNode(0) == emptyNode.elements.getNode(0));
		Assert.isTrue(sampleDOMCollection.getNode(1) == emptyNode.elements.getNode(1));
	}

	@Test 
	public function prependOnNull()
	{
		nullNode.prepend(sampleNode);
		Assert.isNotNull(sampleNode.parent);
	}

	@Test 
	public function prependOnEmpty()
	{
		emptyNode.prepend(sampleNode);
		Assert.areEqual(1, emptyNode.elements.length);
	}

	@Test 
	public function prependNull()
	{
		Assert.areEqual("", emptyNode.innerHTML);
		emptyNode.prepend(null);
		Assert.areEqual("", emptyNode.innerHTML);
	}

	@Test 
	public function appendTo_Node()
	{
		// To start with, there is no .sample
		Assert.areEqual(0, a.find(".sample").length);
		sampleListItem.appendTo(a);

		// Now it should exist, and it should be the fourth child of it's parent
		Assert.areEqual(1, a.find(".sample").length);
		Assert.isTrue(sampleListItem == a.elements.getNode(3));
	}

	@Test 
	public function appendTo_Collection()
	{
		Assert.areEqual(3, a.elements.length);
		Assert.areEqual(0, a.find(".sample").length);
		Assert.areEqual(3, b.elements.length);
		Assert.areEqual(0, b.find(".sample").length);

		sampleListItem.appendTo(lists);

		Assert.areEqual(4, a.elements.length);
		Assert.areEqual(4, b.elements.length);
		Assert.areEqual(1, a.find(".sample").length);
		Assert.areEqual(1, b.find(".sample").length);
		Assert.isTrue(a.elements.getNode(3).hasClass('sample'));
		Assert.isTrue(a.elements.getNode(3).hasClass('sample'));
	}

	@Test 
	public function appendTo_OnNull()
	{
		Assert.areEqual("", emptyNode.innerHTML);
		nullNode.appendTo(emptyNode);
		Assert.areEqual("", emptyNode.innerHTML);
	}

	@Test 
	public function appendTo_Null()
	{
		emptyNode.appendTo(null);
		Assert.isNotNull(emptyNode.parent);
	}

	@Test 
	public function prependTo_Node()
	{
		// To start with, there is no .sample
		Assert.areEqual(0, a.find(".sample").length);
		sampleListItem.prependTo(a);

		// Now it should exist, and it should be the first child of it's parent
		Assert.areEqual(1, a.find(".sample").length);
		Assert.isTrue(sampleListItem == a.elements.getNode(0));
	}

	@Test 
	public function prependTo_OnEmpty()
	{
		sampleNode.prependTo(emptyNode);
		Assert.areEqual(1, emptyNode.elements.length);
	}

	@Test 
	public function prependTo_Collection()
	{
		Assert.areEqual(3, a.elements.length);
		Assert.areEqual(0, a.find(".sample").length);
		Assert.areEqual(3, b.elements.length);
		Assert.areEqual(0, b.find(".sample").length);

		sampleListItem.prependTo(lists);

		Assert.areEqual(4, a.elements.length);
		Assert.areEqual(4, b.elements.length);
		Assert.areEqual(1, a.find(".sample").length);
		Assert.areEqual(1, b.find(".sample").length);
		Assert.isTrue(a.elements.getNode(0).hasClass('sample'));
		Assert.isTrue(a.elements.getNode(0).hasClass('sample'));
	}

	@Test 
	public function prependTo_OnNull()
	{
		Assert.areEqual("", emptyNode.innerHTML);
		nullNode.prependTo(emptyNode);
		Assert.areEqual("", emptyNode.innerHTML);
	}

	@Test 
	public function prependTo_Null()
	{
		emptyNode.prependTo(null);
		Assert.isNotNull(emptyNode.parent);
	}

	@Test 
	public function insertThisBefore_Node()
	{
		insertSiblingContentNode.insertThisBefore(insertSiblingTargetNode);

		// content should be first child, target second
		Assert.isTrue(insertSiblingContentNode == sampleDOMCollection[0].elements.getNode(0));
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection[0].elements.getNode(1));
	}

	@Test 
	public function insertThisBefore_Collection()
	{
		var div1 = sampleDOMCollection[0];
		var div2 = sampleDOMCollection[1];

		// they should start with 1 child each
		Assert.areEqual(1, div1.elements.length);
		Assert.areEqual(1, div2.elements.length);
		
		insertSiblingContentNode.insertThisBefore(insertSiblingTargetDOMCollection);

		// they should end with 2 children each
		Assert.areEqual(2, div1.elements.length);
		Assert.areEqual(2, div2.elements.length);

		// the innerHTML should be the same
		Assert.areEqual(div1.innerHTML, div2.innerHTML);

		// check the order: should be content first, then target
		Assert.isTrue(insertSiblingContentNode == div1.elements.getNode(0));
		Assert.isTrue(insertSiblingTargetDOMCollection.getNode(0) == div1.elements.getNode(1));
		
		Assert.isTrue(insertSiblingTargetDOMCollection.getNode(1) == div2.elements.getNode(1));
		// This final one is a clone, so it won't be exactly equal, but it should be identical
		Assert.areEqual(insertSiblingContentNode.innerHTML, div2.elements.getNode(0).innerHTML);
		Assert.areEqual(insertSiblingContentNode.attr('class'), div2.elements.getNode(0).attr('class'));
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
		Assert.isTrue(a == a2.parent);
	}

	@Test 
	public function insertThisAfter_Node()
	{
		insertSiblingContentNode.insertThisAfter(insertSiblingTargetNode);

		// First node should be target, second should be content
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection[0].elements.getNode(0));
		Assert.isTrue(insertSiblingContentNode == sampleDOMCollection[0].elements.getNode(1));
	}

	@Test 
	public function insertThisAfter_Collection()
	{
		var div1 = sampleDOMCollection[0];
		var div2 = sampleDOMCollection[1];

		// they should start with 1 child each
		Assert.areEqual(1, div1.elements.length);
		Assert.areEqual(1, div2.elements.length);

		insertSiblingContentNode.insertThisAfter(insertSiblingTargetDOMCollection);

		// they should end with 2 children each
		Assert.areEqual(2, div1.elements.length);
		Assert.areEqual(2, div2.elements.length);

		// the innerHTML should be the same
		Assert.areEqual(div1.innerHTML, div2.innerHTML);

		// check the order: should be target first, then content
		Assert.isTrue(insertSiblingTargetDOMCollection.getNode(0) == div1.elements.getNode(0));
		Assert.isTrue(insertSiblingContentNode == div1.elements.getNode(1));
		Assert.isTrue(insertSiblingTargetDOMCollection.getNode(1) == div2.elements.getNode(0));
		// This final one is a clone, so it won't be exactly equal, but it should be identical
		Assert.areEqual(insertSiblingContentNode.innerHTML, div2.elements.getNode(1).innerHTML);
		Assert.areEqual(insertSiblingContentNode.attr('class'), div2.elements.getNode(1).attr('class'));
	}

	@Test 
	public function insertThisAfter_OnNull()
	{
		var before = a.innerHTML;
		nullNode.insertThisAfter(a2);
		Assert.isTrue(before == a.innerHTML);
	}

	@Test 
	public function insertThisAfter_Null()
	{
		a2.insertThisAfter(nullNode);
		Assert.isTrue(a == a2.parent);
	}

	@Test 
	public function beforeThisInsert_Node()
	{
		insertSiblingTargetNode.beforeThisInsert(insertSiblingContentNode);

		// First node should be content, second should be target
		Assert.isTrue(insertSiblingContentNode == sampleDOMCollection[0].elements.getNode(0));
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection[0].elements.getNode(1));
	}

	@Test 
	public function beforeThisInsert_Collection()
	{
		insertSiblingTargetNode.beforeThisInsert(insertSiblingContentDOMCollection);

		// first and second should be content, third should be target
		Assert.areEqual(3, sampleDOMCollection.first.elements.length);
		Assert.isTrue(insertSiblingContentDOMCollection.getNode(0) == sampleDOMCollection[0].elements.getNode(0));
		Assert.isTrue(insertSiblingContentDOMCollection.getNode(1) == sampleDOMCollection[0].elements.getNode(1));
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection[0].elements.getNode(2));
	}

	@Test 
	public function beforeThisInsert_OnNull()
	{
		nullNode.beforeThisInsert(a2);
		Assert.isTrue(a == a2.parent);
	}

	@Test 
	public function beforeThisInsert_Null()
	{
		a2.beforeThisInsert(nullNode);
		Assert.isNull(nullNode.parent);
	}

	@Test 
	public function afterThisInsert_Node()
	{
		insertSiblingTargetNode.afterThisInsert(insertSiblingContentNode);

		// First node should be target, second should be content
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection[0].elements.getNode(0));
		Assert.isTrue(insertSiblingContentNode == sampleDOMCollection[0].elements.getNode(1));
	}

	@Test 
	public function afterThisInsert_Collection()
	{
		insertSiblingTargetNode.afterThisInsert(insertSiblingContentDOMCollection);
		
		// first should be target, second and third content
		Assert.areEqual(3, sampleDOMCollection.first.elements.length);
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection[0].elements.getNode(0));
		Assert.isTrue(insertSiblingContentDOMCollection.getNode(0) == sampleDOMCollection[0].elements.getNode(1));
		Assert.isTrue(insertSiblingContentDOMCollection.getNode(1) == sampleDOMCollection[0].elements.getNode(2));
	}

	@Test 
	public function afterThisInsert_OnNull()
	{
		nullNode.afterThisInsert(a2);
		Assert.isTrue(a == a2.parent);
	}

	@Test 
	public function afterThisInsert_Null()
	{
		var before = a.innerHTML;
		a2.afterThisInsert(null);
		Assert.isTrue(before == a.innerHTML);
	}

	@Test
	public function afterThisInsert_CheckReference()
	{
		Assert.areEqual("Start<!--Comment-->End", nonElements.innerHTML);
		Assert.areEqual(3, nonElements.children.length);
		Assert.areEqual(7, a.children.length);

		// Move it to a different location
		a2.afterThisInsert(comment);

		Assert.areEqual("StartEnd", nonElements.innerHTML);
		Assert.areEqual(2, nonElements.children.length);
		Assert.areEqual(8, a.children.length);

		// Update the inner text, and check the new location updates
		comment.setInnerHTML("Two");

		Assert.areEqual("<!--Two-->", a.find("#a2").next.html);
	}

	@Test
	public function afterThisInsert_CheckReferenceDOM()
	{
		// Start with a collection, things labelled "before"
		insertSiblingTargetDOMCollection.setInnerHTML("BEFORE");
		Assert.areEqual(7, a.children.length);

		// Move it to a different location
		a2.afterThisInsert(insertSiblingTargetDOMCollection);
		Assert.areEqual(9, a.children.length);
		Assert.areEqual("BEFOREBEFORE", a.find("i.target").text);

		// Update the inner text, and check the new location updates
		insertSiblingTargetDOMCollection.setInnerHTML("AFTER");
		Assert.areEqual(9, a.children.length);
		Assert.areEqual("AFTERAFTER", a.find("i.target").text);
	}

	@Test 
	public function removeFromDOM()
	{
		Assert.areEqual(3, a.elements.length);
		"#a1".find().getNode().removeFromDOM();

		Assert.areEqual(2, a.elements.length);
		"#a2".find().getNode().removeFromDOM();

		Assert.areEqual(1, a.elements.length);
		"#a3".find().getNode().removeFromDOM();

		Assert.areEqual(0, a.elements.length);
	}

	@Test 
	public function remove_onNull()
	{
		Assert.areEqual(null, nullNode.removeFromDOM());
	}

	@Test 
	public function removeChildren_Node()
	{
		Assert.areEqual(3, a.elements.length);
		a.removeChildren("#a1".find().getNode());

		Assert.areEqual(2, a.elements.length);
		a.removeChildren("#a2".find().getNode());

		Assert.areEqual(1, a.elements.length);
		a.removeChildren("#a3".find().getNode());

		Assert.areEqual(0, a.elements.length);
	}

	@Test 
	public function removeChildren_Collection()
	{
		Assert.areEqual(3, a.elements.length);
		a.removeChildren("#a li".find());

		Assert.areEqual(0, a.elements.length);
	}

	@Test 
	public function removeChildren_Null()
	{
		var original = a.innerHTML;
		a.removeChildren(null);

		// check nothing changed
		Assert.isTrue(original == a.innerHTML);
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
		var original = a.innerHTML;
		a.removeChildren(h1);

		// check nothing changed
		Assert.isTrue(original == a.innerHTML);
	}

	@Test 
	public function replaceWith_Node()
	{
		insertSiblingTargetNode.replaceWith(insertSiblingContentNode);

		// target should be removed, have no parent. Content should be in place, with correct html
		Assert.isNull(insertSiblingTargetNode.parent);		
		Assert.areEqual('<p class="p1"><b class="content">1</b></p><p class="p2"><i class="target">i</i></p>', sampleDOMCollection.html);
	}

	@Test 
	public function replaceWith_Collection()
	{
		insertSiblingTargetNode.replaceWith(insertSiblingContentDOMCollection);

		// target should be removed, have no parent. All content should be in place, correct HTML
		Assert.isNull(insertSiblingTargetNode.parent);		
		Assert.areEqual('<p class="p1"><b class="content">1</b><b class="content">2</b></p><p class="p2"><i class="target">i</i></p>', sampleDOMCollection.html);
	}

	@Test 
	public function replaceWith_OnNull()
	{
		var before = a.innerHTML;
		nullNode.replaceWith(a2);

		// Nothing has changed
		Assert.isTrue(before == a.innerHTML);
	}

	@Test 
	public function replaceWith_Null()
	{
		var before = a.innerHTML;
		a2.replaceWith(null);

		// a2 should be gone
		Assert.areEqual(2, a.elements.length);
		Assert.areEqual("a1", a.elements[0].attr("id"));
		Assert.areEqual("a3", a.elements[1].attr("id"));
	}

	@Test 
	public function empty()
	{
		Assert.areEqual(3, a.elements.length);
		a.empty();
		Assert.areEqual(0, a.elements.length);
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
			.removeFromDOM().removeChildren().empty();
	}

}
