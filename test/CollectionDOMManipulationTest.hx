package;

import massive.munit.Assert;

import Detox;
using Detox;
import dtx.DOMCollection;
import dtx.DOMNode;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class CollectionDOMManipulationTest 
{
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
	
	public var sampleDocument:DOMCollection;
	public var h1:DOMCollection;
	public var h1Node:DOMNode;
	public var lists:DOMCollection;
	public var a:DOMNode;
	public var b:DOMNode;
	public var a2:DOMNode;
	public var pickme:DOMCollection;
	public var nonElements:DOMCollection;
	public var textNode1:DOMNode;
	public var comment:DOMNode;
	public var textNode2:DOMNode;
	public var emptyNode:DOMNode;
	public var nullNode:DOMNode;
	public var nullDOMCollection:DOMCollection;

	public var sampleNode:DOMNode;
	public var sampleListItems:DOMCollection;
	public var sampleListItemNode:DOMNode;
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
				<li id='a2' class='pickme'>2</li>
				<li id='a3'>3</li>
			</ul>
			<ul id='b'>
				<li id='b1'>1</li>
				<li id='b2' class='pickme'>2</li>
				<li id='b3'>3</li>
			</ul>
			<div id='nonelements'>Start<!--Comment-->End</div>
			<div id='empty'></div>
		</myxml>".parse();

		Detox.setDocument(sampleDocument.getNode());

		h1 = "h1".find();
		h1Node = "h1".find().getNode();
		lists = "ul".find();
		a = "#a".find().getNode();
		b = "#b".find().getNode();
		a2 = "#a2".find().getNode();
		pickme = ".pickme".find();
		nonElements = "#nonelements".find();
		textNode1 = nonElements.children(false).getNode(0);
		comment = nonElements.children(false).getNode(1);
		textNode2 = nonElements.children(false).getNode(2);
		emptyNode = "#empty".find().getNode();
		nullNode = null;
		nullDOMCollection = null;

		sampleNode = "<i>Element</i>".parse().getNode();
		sampleListItems = "<li class='sample'>Sample1</li><li class='sample'>Sample2</li>".parse();
		sampleListItemNode = sampleListItems.getNode();
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
	public function append_node()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// append to a collection of <ul>s
		lists.append(sampleListItemNode);

		// There should be two, each at the end
		Assert.areEqual(2, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().last().innerHTML());
		Assert.areEqual("Sample1", b.children().last().innerHTML());
	}

	@Test 
	public function append_collection()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// append to a collection of <ul>s
		lists.append(sampleListItems);

		// There should be four, two in each, both at the end
		Assert.areEqual(4, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(3).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(4).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(3).innerHTML());
		Assert.areEqual("Sample2", b.children().eq(4).innerHTML());
	}

	@Test 
	public function append_onNull()
	{
		nullDOMCollection.append(h1);
		Assert.isTrue(sampleDocument.getNode() == h1Node.parents());
	}

	@Test 
	public function append_null()
	{
		var before = h1.innerHTML();
		h1.append(nullNode);
		h1.append(nullDOMCollection);
		Assert.isTrue(before == h1.innerHTML());
	}

	@Test 
	public function prepend_node()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// append to a collection of <ul>s
		lists.prepend(sampleListItemNode);

		// There should be two, each at the start
		Assert.areEqual(2, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().first().innerHTML());
		Assert.areEqual("Sample1", b.children().first().innerHTML());
	}

	@Test 
	public function prepend_collection()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// append to a collection of <ul>s
		lists.prepend(sampleListItems);

		// There should be four, two in each, both at the start
		Assert.areEqual(4, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(0).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(1).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(0).innerHTML());
		Assert.areEqual("Sample2", b.children().eq(1).innerHTML());
	}

	@Test 
	public function prepend_null()
	{
		var before = h1.innerHTML();
		h1.prepend(nullNode);
		h1.prepend(nullDOMCollection);
		Assert.isTrue(before == h1.innerHTML());
	}

	@Test
	public function prepend_onNull()
	{
		nullDOMCollection.prepend(h1);
		Assert.isTrue(sampleDocument.getNode() == h1Node.parents());
	}

	@Test 
	public function appendTo_node()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// append to a single <ul>
		sampleListItems.appendTo(a);

		// There should be two, each at the end
		Assert.areEqual(2, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(3).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(4).innerHTML());
		Assert.areEqual(0, b.find(".sample").length);
	}

	@Test 
	public function appendTo_query()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// append to a collection of <ul>s
		sampleListItems.appendTo(lists);

		// There should be four, two in each, both at the end
		Assert.areEqual(4, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(3).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(4).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(3).innerHTML());
		Assert.areEqual("Sample2", b.children().eq(4).innerHTML());
	}

	@Test 
	public function appendTo_null()
	{
		h1.appendTo(nullDOMCollection);
		h1.appendTo(nullNode);
		Assert.isTrue(sampleDocument.getNode() == h1Node.parents());
	}

	@Test 
	public function appendTo_onNull()
	{
		var before = h1.innerHTML();
		nullDOMCollection.appendTo(h1);
		nullDOMCollection.appendTo(h1Node);
		Assert.isTrue(before == h1.innerHTML());
	}

	@Test 
	public function prependTo_node()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// append to a single <ul>
		sampleListItems.prependTo(a);

		// There should be two, each at the start
		Assert.areEqual(2, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(0).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(1).innerHTML());
		Assert.areEqual(0, b.find(".sample").length);
	}

	@Test 
	public function prependTo_query()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// append to a collection of <ul>s
		sampleListItems.prependTo(lists);

		// There should be four, two in each, both at the start
		Assert.areEqual(4, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(0).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(1).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(0).innerHTML());
		Assert.areEqual("Sample2", b.children().eq(1).innerHTML());
	}

	@Test 
	public function prependTo_null()
	{
		h1.prependTo(nullDOMCollection);
		h1.prependTo(nullNode);
		Assert.isTrue(sampleDocument.getNode() == h1Node.parents());
	}

	@Test 
	public function prependTo_OnNull()
	{
		var before = h1.innerHTML();
		nullDOMCollection.prependTo(h1);
		nullDOMCollection.prependTo(h1Node);
		Assert.isTrue(before == h1.innerHTML());
	}

	@Test 
	public function insertThisBefore_node()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// insert our sample <li>s before a single <li> node
		var n = a.find(".pickme").getNode();
		sampleListItems.insertThisBefore(n);

		// There should be four, two in each, both placed before our 'pickme'
		Assert.areEqual(2, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(1).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(2).innerHTML());
	}

	@Test 
	public function insertThisBefore_query()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// insert our sample <li>s before a collection of other <li>s
		sampleListItems.insertThisBefore(pickme);

		// There should be four, two in each, both placed before our 'pickme'
		Assert.areEqual(4, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(1).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(2).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(1).innerHTML());
		Assert.areEqual("Sample2", b.children().eq(2).innerHTML());
	}

	@Test 
	public function insertThisBefore_onNull()
	{
		var before = lists.innerHTML();
		nullDOMCollection.insertThisBefore(pickme);
		nullDOMCollection.insertThisBefore(pickme.getNode(0));
		Assert.isTrue(before == lists.innerHTML());
	}

	@Test 
	public function insertThisBefore_null()
	{
		var before = sampleDocument.innerHTML();
		h1.insertThisBefore(nullNode);
		h1.insertThisBefore(nullDOMCollection);
		Assert.isTrue(before == sampleDocument.innerHTML());
	}

	@Test 
	public function insertThisAfter_node()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// insert our sample <li>s after a single <li> node
		var n = a.find(".pickme").getNode();
		sampleListItems.insertThisAfter(n);

		// There should be four, two in each, both placed after our 'pickme'
		Assert.areEqual(2, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(2).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(3).innerHTML());
	}

	@Test 
	public function insertThisAfter_query()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// insert our sample <li>s before a collection of other <li>s
		sampleListItems.insertThisAfter(pickme);

		// There should be four, two in each, both placed before our 'pickme'
		Assert.areEqual(4, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(2).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(3).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(2).innerHTML());
		Assert.areEqual("Sample2", b.children().eq(3).innerHTML());
	}

	@Test 
	public function insertThisAfter_null()
	{
		var before = sampleDocument.innerHTML();
		h1.insertThisAfter(nullNode);
		h1.insertThisAfter(nullDOMCollection);
		Assert.isTrue(before == sampleDocument.innerHTML());
	}

	@Test 
	public function insertThisAfter_onNull()
	{
		var before = lists.innerHTML();
		nullDOMCollection.insertThisAfter(pickme);
		nullDOMCollection.insertThisAfter(pickme.getNode(0));
		Assert.isTrue(before == lists.innerHTML());
	}

	@Test 
	public function beforeThisInsert_node()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// insert our sample <li>s before a collection of other <li>s
		pickme.beforeThisInsert(sampleListItemNode);

		// There should be four, two in each, both placed before our 'pickme'
		Assert.areEqual(2, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(1).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(1).innerHTML());
	}

	@Test 
	public function beforeThisInsert_query()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// insert our sample <li>s before a collection of other <li>s
		pickme.beforeThisInsert(sampleListItems);

		// There should be four, two in each, both placed before our 'pickme'
		Assert.areEqual(4, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(1).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(2).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(1).innerHTML());
		Assert.areEqual("Sample2", b.children().eq(2).innerHTML());
	}

	@Test 
	public function beforeThisInsert_null()
	{
		var before = lists.innerHTML();
		pickme.beforeThisInsert(nullNode);
		pickme.beforeThisInsert(nullDOMCollection);
		Assert.isTrue(before == lists.innerHTML());
	}

	@Test 
	public function beforeThisInsert_onNull()
	{
		var before = sampleDocument.innerHTML();
		nullDOMCollection.beforeThisInsert(h1);
		Assert.isTrue(before == sampleDocument.innerHTML());
	}

	@Test 
	public function afterThisInsert_node()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// insert our sample <li>s before a collection of other <li>s
		pickme.afterThisInsert(sampleListItemNode);

		// There should be four, two in each, both placed before our 'pickme'
		Assert.areEqual(2, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(2).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(2).innerHTML());
	}

	@Test 
	public function afterThisInsert_query()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);

		// insert our sample <li>s before a collection of other <li>s
		pickme.afterThisInsert(sampleListItems);

		// There should be four, two in each, both placed before our 'pickme'
		Assert.areEqual(4, ".sample".find().length);
		Assert.areEqual("Sample1", a.children().eq(2).innerHTML());
		Assert.areEqual("Sample2", a.children().eq(3).innerHTML());
		Assert.areEqual("Sample1", b.children().eq(2).innerHTML());
		Assert.areEqual("Sample2", b.children().eq(3).innerHTML());
	}

	@Test 
	public function afterThisInsert_onNull()
	{
		var before = sampleDocument.innerHTML();
		nullDOMCollection.afterThisInsert(h1);
		Assert.isTrue(before == sampleDocument.innerHTML());
	}

	@Test 
	public function afterThisInsert_null()
	{
		var before = lists.innerHTML();
		pickme.afterThisInsert(nullNode);
		pickme.afterThisInsert(nullDOMCollection);
		Assert.isTrue(before == lists.innerHTML());
	}

	@Test 
	public function remove_onNull()
	{
		var before = sampleDocument.innerHTML();
		nullDOMCollection.remove();
		Assert.isTrue(before == sampleDocument.innerHTML());
	}

	@Test 
	public function remove_crazyCollection()
	{
		// First, check the default state
		Assert.areEqual(7, sampleDocument.children().length);
		Assert.areEqual(6, "li".find().length);
		Assert.areEqual("Start<!--Comment-->End", nonElements.innerHTML());

		// Set up a crazy group of things
		var q = new DOMCollection();

		q.add(comment);
		q.add(textNode2);
		q.addCollection(pickme);
		q.addCollection(h1);

		q.remove();

		// Check if things are as we expect
		Assert.areEqual(6, sampleDocument.children().length);
		Assert.areEqual(4, "li".find().length);
		Assert.areEqual("Start", nonElements.innerHTML());
	}

	@Test 
	public function removeChildren_node()
	{
		Assert.areEqual(3, a.find('li').length);
		Assert.areEqual(3, b.find('li').length);
		Assert.areEqual(1, a.find('li.pickme').length);
		Assert.areEqual(1, b.find('li.pickme').length);

		var n = a.find('li.pickme').getNode();
		lists.removeChildren(n);

		Assert.areEqual(2, a.find('li').length);
		Assert.areEqual(3, b.find('li').length);
		Assert.areEqual(0, a.find('li.pickme').length);
		Assert.areEqual(1, b.find('li.pickme').length);
	}

	@Test 
	public function removeChildren_query()
	{
		Assert.areEqual(3, a.find('li').length);
		Assert.areEqual(3, b.find('li').length);
		Assert.areEqual(1, a.find('li.pickme').length);
		Assert.areEqual(1, b.find('li.pickme').length);

		var n = lists.find('li.pickme');
		lists.removeChildren(n);

		Assert.areEqual(2, a.find('li').length);
		Assert.areEqual(2, b.find('li').length);
		Assert.areEqual(0, a.find('li.pickme').length);
		Assert.areEqual(0, b.find('li.pickme').length);
	}

	@Test 
	public function removeChildren_null()
	{
		var before = h1.innerHTML();
		h1.removeChildren(nullNode);
		h1.removeChildren(nullDOMCollection);
		Assert.isTrue(before == h1.innerHTML());
	}

	@Test 
	public function removeChildren_onNull()
	{
		var before = sampleDocument.innerHTML();
		nullDOMCollection.removeChildren(h1);
		nullDOMCollection.removeChildren(h1Node);
		Assert.isTrue(before == sampleDocument.innerHTML());
		Assert.isTrue(sampleDocument.getNode() == h1Node.parents());
	}

	@Test 
	public function replaceWith_node()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);
		Assert.areEqual(2, ".pickme".find().length);

		// replace the ".pickme" li nodes with our .sample <li>
		".pickme".find().replaceWith(sampleListItemNode);

		// ".pickme" should be gone, and sampleListItemNode has replaced it, twice
		Assert.areEqual('
				<li id="a1">1</li>
				<li class="sample">Sample1</li>
				<li id="a3">3</li>
			', a.innerHTML());
		Assert.areEqual('
				<li id="b1">1</li>
				<li class="sample">Sample1</li>
				<li id="b3">3</li>
			', b.innerHTML());
		Assert.areEqual(0, ".pickme".find().length);
		Assert.areEqual(2, ".sample".find().length);
	}

	@Test 
	public function replaceWith_query()
	{
		// None of sampleListItem to start with
		Assert.areEqual(0, ".sample".find().length);
		Assert.areEqual(2, ".pickme".find().length);

		// replace the ".pickme" li nodes with our .sample <li>s 
		".pickme".find().replaceWith(sampleListItems);

		// There should be four samples, two in each, and the 'pickme' li's should be gone
		Assert.areEqual('
				<li id="a1">1</li>
				<li class="sample">Sample1</li><li class="sample">Sample2</li>
				<li id="a3">3</li>
			', a.innerHTML());
		Assert.areEqual('
				<li id="b1">1</li>
				<li class="sample">Sample1</li><li class="sample">Sample2</li>
				<li id="b3">3</li>
			', b.innerHTML());
		Assert.areEqual(0, ".pickme".find().length);
		Assert.areEqual(4, ".sample".find().length);
	}

	@Test 
	public function replaceWith_null()
	{
		// None of sampleListItem to start with
		Assert.areEqual(2, ".pickme".find().length);

		// replace the ".pickme" li nodes with null, so they should be empty
		".pickme".find().replaceWith(null);
		Assert.areEqual(0, ".pickme".find().length);
	}

	@Test 
	public function replaceWith_onNull()
	{
		var before = lists.innerHTML();

		nullDOMCollection.replaceWith(sampleListItems);

		Assert.isTrue(before == lists.innerHTML());
	}

	@Test 
	public function empty()
	{
		Assert.areEqual(6, "li".find().length);
		lists.empty();
		Assert.areEqual(0, "li".find().length);
		Assert.areEqual(0, a.children().length);
		Assert.areEqual(0, b.children().length);
	}

	@Test 
	public function empty_onNull()
	{
		var before = sampleDocument.innerHTML();
		nullDOMCollection.empty();
		Assert.isTrue(before == sampleDocument.innerHTML());
	}

	@Test 
	public function empty_onNonElements()
	{
		// 3 children, non are elements
		Assert.areEqual(3, nonElements.children(false).length);
		var before = nonElements.innerHTML();

		// run empty on the 3 non-elements
		for (child in nonElements.children())
		{
			child.empty();
		}

		// nothing should have changed
		Assert.areEqual(3, nonElements.children(false).length);
		Assert.isTrue(before == nonElements.innerHTML());

		// now empty the container
		nonElements.empty();

		// now things should have changed
		Assert.areEqual(0, nonElements.children(false).length);
		Assert.areEqual("", nonElements.innerHTML());
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
