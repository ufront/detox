package;

import massive.munit.Assert;

using Detox;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class CollectionTraversingTest 
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

	var sampleDocument:Nodes;
	var nullDOMCollection:Nodes;
	var emptyDOMCollection:Nodes;
	
	@Before
	public function setup():Void
	{
		var sampleDocument = "<myxml>
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
		</myxml>".parse();
		nullDOMCollection = null;
		emptyDOMCollection = [];

		Detox.setDocument(sampleDocument.getNode());

	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function children_normal()
	{
		var q1 = 'ul'.find().elements;
		Assert.areEqual(8, q1.length);
	}

	@Test 
	public function children_elementsOnly()
	{
		var q1 = '#nonElements'.find().elements;
		var q2 = '#nonElements'.find().children;
		Assert.areEqual(0, q1.length);
		Assert.areEqual(3, q2.length);
	}

	@Test 
	public function children_onNull()
	{
		Assert.areEqual(0, nullDOMCollection.elements.length);
	}

	@Test 
	public function children_onEmptyParent()
	{
		var q1 = ".empty".find();
		Assert.areEqual(2, q1.length);
		Assert.areEqual(0, q1.elements.length);
	}

	@Test 
	public function children_onEmptyCollection()
	{
		Assert.areEqual(0, emptyDOMCollection.elements.length);
	}

	@Test 
	public function firstChild()
	{
		var q1 = '#nonElements'.find().firstChild;
		var q2 = '#nonElements'.find().firstElement;
		Assert.areEqual(1, q1.length);
		Assert.areEqual(0, q2.length);
	}

	@Test 
	public function firstElement()
	{
		var q1 = "ul".find().firstElement;
		Assert.areEqual(2, q1.length);
		Assert.areEqual("a1", q1[0].attr('id'));
		Assert.areEqual("b1", q1[1].attr('id'));
	}

	@Test 
	public function firstChild_onNull()
	{
		Assert.areEqual(0, nullDOMCollection.firstChild.length);
	}

	@Test 
	public function firstChild_onEmptyParent()
	{
		var q1 = ".empty".find();
		Assert.areEqual(2, q1.length);
		Assert.areEqual(0, q1.firstChild.length);
	}

	@Test 
	public function firstChildren_onEmptyCollection()
	{
		Assert.areEqual(0, emptyDOMCollection.firstChild.length);
	}

	@Test 
	public function lastElement()
	{
		var q1 = "ul".find().lastElement;
		Assert.areEqual(2, q1.length);
		Assert.areEqual("a4", q1[0].attr('id'));
		Assert.areEqual("b4", q1[1].attr('id'));
	}

	@Test 
	public function lastChild()
	{
		var q1 = '#nonElements'.find().lastElement;
		var q2 = '#nonElements'.find().lastChild;
		Assert.areEqual(0, q1.length);
		Assert.areEqual(1, q2.length);
	}

	@Test 
	public function lastChild_onNull()
	{
		Assert.areEqual(0, nullDOMCollection.lastChild.length);
	}

	@Test 
	public function lastChild_onEmptyCollection()
	{
		Assert.areEqual(0, emptyDOMCollection.lastChild.length);
	}

	@Test 
	public function lastChild_onEmptyParent()
	{
		var q1 = ".empty".find();
		Assert.areEqual(2, q1.length);
		Assert.areEqual(0, q1.lastChild.length);
	}

	@Test 
	public function parent()
	{
		var l4 = ".level4".find();
		Assert.isTrue(l4.parent.hasClass('level3'));
	}

	@Test 
	public function parent_onNull()
	{
		Assert.areEqual(0, nullDOMCollection.parent.length);
	}

	@Test 
	public function parent_onEmptyCollection()
	{
		Assert.areEqual(0, emptyDOMCollection.parent.length);
	}

	@Test 
	public function parent_onElementWithNoParent()
	{
		// eg Document
		#if js 
		var doc:Node = untyped __js__('document');
		#else 
		var doc = Xml.createDocument();
		#end
		var q:Nodes = [doc];
		Assert.areEqual(0, q.parent.length);
	}

	@Test 
	public function ancestors()
	{
		var l4 = ".level4".find();
		var a = l4.ancestors;
		Assert.areEqual(4, a.length);
		Assert.isTrue(a[0].hasClass('level3'));
		Assert.isTrue(a[1].hasClass('level2'));
		Assert.isTrue(a[2].hasClass('level1'));
		Assert.areEqual("myxml", a[3].tagName);
	}

	@Test 
	public function ancestors_onNull()
	{
		Assert.areEqual(0, nullDOMCollection.ancestors.length);
	}

	@Test 
	public function ancestors_onEmptyCollection()
	{
		Assert.areEqual(0, emptyDOMCollection.ancestors.length);
	}

	@Test 
	public function ancestors_onElementWithNoParents()
	{
		// eg Document
		#if js
		var doc:Node = untyped __js__('document');
		#else 
		var doc = Xml.createDocument();
		#end
		var q:Nodes = [doc];
		var a = q.ancestors;
		Assert.areEqual(0, a.length);
	}

	@Test 
	public function descendants()
	{
		Assert.areEqual(8, "ul".find().descendantElements.length);
		Assert.areEqual(3, "div".find().descendantElements.length);
		Assert.areEqual(3, "#recursive".find().descendantElements.length);
	}

	@Test 
	public function descendantsElementsOnly()
	{
		Assert.areEqual(26, "ul".find().descendants.length);
		Assert.areEqual(10, "#recursive".find().descendants.length);
	}

	@Test 
	public function descendantsOnNull()
	{
		Assert.areEqual(0, nullDOMCollection.descendantElements.length);
	}

	@Test 
	public function descendantsOnNonElement()
	{
		Assert.areEqual(0, "#nonElements".find().elements.descendants.length);
	}

	@Test 
	public function descendantsOnNoDescendants()
	{
		Assert.areEqual(0, ".empty".find().descendants.length);
	}

	@Test 
	public function nextElement()
	{
		for (li in ".pickme".find())
		{
			Assert.areEqual("3", li.toNodes().nextElement.text);
		}
	}

	@Test 
	public function next_onNull()
	{
		Assert.areEqual(0, nullDOMCollection.next.length);
	}

	@Test 
	public function next_onEmpty()
	{
		Assert.areEqual(0, emptyDOMCollection.next.length);
	}

	@Test 
	public function nextElement_onLast()
	{
		var q:Nodes = [];
		q.addCollection('#a4'.find()); // no next()
		q.addCollection('#b4'.find()); // no next()
		q.addCollection('#b3'.find()); // next() = '#b4'
		Assert.areEqual(1, q.nextElement.length);
		Assert.areEqual("b4", q.nextElement.first.attr('id'));
	}

	@Test 
	public function next()
	{
		var children = "#nonElements".find().children;
		var comment:Nodes = [children[1]];

		Assert.areEqual("Comment", comment.val);
		Assert.areEqual("After", comment.next.val);
		Assert.areEqual(0, comment.nextElement.length);
	}

	@Test 
	public function prevElement()
	{
		for (li in ".pickme".find()) {
			Assert.areEqual("1", li.toNodes().prevElement.text);
		}
	}

	@Test 
	public function prev_onNull()
	{
		Assert.areEqual(0, nullDOMCollection.prev.length);
	}

	@Test 
	public function prev_onEmpty()
	{
		Assert.areEqual(0, emptyDOMCollection.prev.length);
	}

	@Test 
	public function prevElement_onFirst()
	{
		var q:Nodes = [];
		q.addCollection('#a1'.find()); // no prev()
		q.addCollection('#b1'.find()); // no prev()
		q.addCollection('#b2'.find()); // prev() = '#b1'
		Assert.areEqual(1, q.prevElement.length);
		Assert.areEqual("b1", q.prevElement[0].attr('id'));
	}

	@Test 
	public function prev_elementsOnly()
	{
		var children = "#nonElements".find().children;
		var comment:Nodes = [children[1]];

		Assert.areEqual("Comment", comment.val);
		Assert.areEqual("Before", comment.prev.val);
		Assert.areEqual(0, comment.prevElement.length);
	}

	@Test 
	public function find()
	{
		var q = "ul".find();
		Assert.areEqual(8, q.find('li').length);
		Assert.areEqual(2, q.find('.pickme').length);
		Assert.areEqual(1, q.find('#a1').length);
	}

	@Test 
	public function find_onNull()
	{
		Assert.areEqual(0, nullDOMCollection.find('li').length);
	}

	@Test 
	public function find_onEmpty()
	{
		Assert.areEqual(0, emptyDOMCollection.find('li').length);
	}

	@Test 
	public function find_nullInput()
	{
		var q = "ul".find();
		Assert.areEqual(0, q.find(null).length);
	}

	@Test 
	public function find_blankInput()
	{
		var q = "ul".find();
		Assert.areEqual(0, q.find('').length);
	}

	@Test 
	public function find_onNothingFound()
	{
		var q = "ul".find();
		Assert.areEqual(0, q.find('video').length);
	}
}
