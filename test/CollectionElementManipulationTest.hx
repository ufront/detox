package;

import massive.munit.Assert;

import dtx.DOMCollection;
import Detox;
using Detox;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class CollectionElementManipulationTest 
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

	public var sampleDocument:DOMCollection;
	public var h1:DOMCollection;
	public var lists:DOMCollection;
	public var listItems:DOMCollection;
	public var pickme:DOMCollection;
	public var emptyNode:DOMCollection;
	public var nonElements:DOMCollection;
	public var textNodes:DOMCollection;
	public var commentNodes:DOMCollection;
	public var emptyCollection:DOMCollection;
	public var nullDOMCollection:DOMCollection;
	public var a:DOMCollection;
	public var b:DOMCollection;
	public var b2:DOMCollection;
	
	@Before
	public function setup():Void
	{
		sampleDocument = "<myxml>
			<h1>Title</h1>
			<ul id='a' title='first'>
				<li id='a1'>1</li>
				<li id='a2' class='pickme'>2</li>
				<li id='a3'>3</li>
			</ul>
			<ul id='b' title='second'>
				<li id='b1'>1</li>
				<li id='b2' class='pickme'>2</li>
				<li id='b3'>3</li>
			</ul>
			<div class='empty'></div>
			<div class='nonelements'>Start<!--Comment1-->End<!--Comment2--></div>
		</myxml>".parse();

		Detox.setDocument(sampleDocument.getNode());

		h1 = "h1".find();
		lists = "ul".find();
		listItems = "li".find();
		pickme = "li.pickme".find();
		emptyNode = ".empty".find();
		nonElements = ".nonelements".find().children(false);
		textNodes = nonElements.filter(function (node) {
			return node.isTextNode();
		});

		commentNodes = nonElements.filter(function (node) {
			return node.isComment();
		});
		emptyCollection = new DOMCollection();
		nullDOMCollection = null;
		a = "#a".find();
		b = "#b".find();
		b2 = "#b2".find();
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function attr()
	{
		Assert.areEqual("first", a.attr('title'));
		Assert.areEqual("second", b.attr('title'));
		Assert.areEqual("pickme", b2.attr('class'));
	}

	@Test 
	public function attrOnNull()
	{
		Assert.areEqual("", nullDOMCollection.attr('id'));
	}

	@Test 
	public function attrOnEmpty()
	{
		Assert.areEqual("", emptyCollection.attr('id'));
	}

	@Test 
	public function attrDoesNotExist()
	{
		Assert.areEqual("", a.attr('doesnotexist'));
		Assert.areEqual("", a.attr('bad attribute name'));
	}

	@Test 
	public function attrOnMultiple()
	{
		Assert.areEqual("first", lists.attr('title'));
		Assert.areEqual("a2", pickme.attr('id'));
	}

	@Test 
	public function setAttr()
	{
		a.setAttr('title', '1st');
		b2.setAttr('class', 'dontpickme');
		Assert.areEqual("1st", a.attr('title'));
		Assert.areEqual("second", b.attr('title'));
		Assert.areEqual("dontpickme", b2.attr('class'));
	}

	@Test 
	public function setAttrMultiple()
	{
		lists.setAttr('title', 'thesame');
		Assert.areEqual('thesame', a.attr('title'));
		Assert.areEqual('thesame', b.attr('title'));
	}

	@Test 
	public function setAttrOnNull()
	{
		nullDOMCollection.setAttr('id', 'myID');
		Assert.areEqual("", nullDOMCollection.attr('id'));
	}

	@Test 
	public function setAttrOnEmpty()
	{
		emptyCollection.setAttr('id', 'myID');
		Assert.areEqual("", emptyCollection.attr('id'));
	}

	@Test 
	public function removeAttr()
	{
		lists.removeAttr('title');
		Assert.areEqual('', a.attr('title'));
		Assert.areEqual('', b.attr('title'));
	}

	@Test 
	public function removeAttrOnNull()
	{
		nullDOMCollection.removeAttr('id');
		Assert.areEqual("", nullDOMCollection.attr('id'));
	}

	@Test 
	public function removeAttrOnEmpty()
	{
		emptyCollection.removeAttr('id');
		Assert.areEqual("", emptyCollection.attr('id'));
	}

	@Test 
	public function removeAttrThatDoesNotExist()
	{
		lists.removeAttr('attrdoesnotexist');
		lists.removeAttr('attr bad input');
		Assert.areEqual('', a.attr('attrdoesnotexist'));
		Assert.areEqual('', b.attr('attrdoesnotexist'));
		Assert.areEqual('', a.attr('attr bad input'));
		Assert.areEqual('', b.attr('attr bad input'));
	}

	@Test 
	public function hasClass()
	{
		Assert.isFalse("#a1".find().hasClass('pickme'));
		Assert.isTrue("#a2".find().hasClass('pickme'));
	}

	@Test 
	public function hasClassOnNull()
	{
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));
	}

	@Test 
	public function hasClassOnEmpty()
	{
		Assert.isFalse(emptyCollection.hasClass('myclass'));
	}

	@Test 
	public function hasClassMultiple()
	{
		Assert.isFalse(lists.hasClass('pickme'));
		Assert.isTrue(pickme.hasClass('pickme'));

		// Try a collection with some of each... 
		// It should only return true if all things are true
		var q = new DOMCollection();
		q.addCollection(lists);
		q.addCollection(pickme);
		Assert.isFalse(q.hasClass('pickme'));
	}

	@Test public function hasClassMultipleClassNames()
	{
		var q = "<p>My Paragraph</p>".parse();

		q.addClass('first');
		q.addClass('second');
		q.addClass('fourth');

		// single tests
		Assert.isTrue(q.hasClass('first'));
		Assert.isTrue(q.hasClass('second'));
		Assert.isFalse(q.hasClass('third'));
		Assert.isTrue(q.hasClass('fourth'));

		// multiple true
		Assert.isTrue(q.hasClass('first second'));
		Assert.isTrue(q.hasClass('second first'));
		Assert.isTrue(q.hasClass('second  first'));
		Assert.isTrue(q.hasClass('second fourth first'));

		// multiple false
		Assert.isFalse(q.hasClass('third fifth'));

		// multiple mixed
		Assert.isFalse(q.hasClass('first second third'));
		Assert.isFalse(q.hasClass('third fourth'));
	}

	@Test 
	public function addClass()
	{
		Assert.isFalse(h1.hasClass("first"));
		h1.addClass('first');
		Assert.isTrue(h1.hasClass("first"));
		
		Assert.isFalse(h1.hasClass("second"));
		h1.addClass('second');
		Assert.isTrue(h1.hasClass("second"));

		Assert.areEqual("first second", h1.attr('class'));
	}

	@Test 
	public function addClassMultipleClasses()
	{
		Assert.isFalse(h1.hasClass("first"));
		Assert.isFalse(h1.hasClass("second"));
		h1.addClass('first second');
		Assert.isTrue(h1.hasClass("first"));
		Assert.isTrue(h1.hasClass("second"));

		Assert.areEqual("first second", h1.attr('class'));
	}

	@Test 
	public function addClassThatAlreadyExists()
	{
		Assert.isFalse(h1.hasClass("test"));
		h1.addClass('test');
		Assert.areEqual("test", h1.attr('class'));

		// now add it again and check it doesn't double up
		h1.addClass('test');
		Assert.areEqual("test", h1.attr('class'));
	}

	@Test 
	public function addClassOnNull()
	{
		nullDOMCollection.addClass('myclass');
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));
	}

	@Test 
	public function addClassOnEmpty()
	{
		emptyCollection.addClass('myclass');
		Assert.isFalse(emptyCollection.hasClass('myclass'));
	}

	@Test 
	public function removeClass()
	{
		Assert.isFalse(h1.hasClass("first"));
		h1.addClass('first');
		Assert.areEqual("first", h1.attr('class'));
		
		Assert.isFalse(h1.hasClass("second"));
		h1.addClass('second');
		Assert.areEqual("first second", h1.attr('class'));
	}

	@Test public function removeClassMultipleClassNames()
	{
		h1.addClass('first');
		h1.addClass('second');
		h1.addClass('fourth');
		h1.addClass('fifth');
		Assert.isTrue(h1.hasClass("first"));
		Assert.isTrue(h1.hasClass("second"));
		Assert.isFalse(h1.hasClass("third"));
		Assert.isTrue(h1.hasClass("fourth"));

		h1.removeClass('fourth fifth first');

		Assert.areEqual("second", h1.attr('class'));
	}

	@Test 
	public function removeClassWhereSomeDoNotExist()
	{
		Assert.isFalse(h1.hasClass("third"));
		h1.removeClass('third');
		Assert.isFalse(h1.hasClass("third"));


		h1.addClass('first');
		h1.addClass('second');
		h1.addClass('fourth');
		h1.addClass('fifth');
		Assert.isTrue(h1.hasClass("first"));
		Assert.isTrue(h1.hasClass("second"));
		Assert.isFalse(h1.hasClass("third"));
		Assert.isTrue(h1.hasClass("fourth"));

		h1.removeClass('fourth fifth third first');

		Assert.areEqual("second", h1.attr('class'));
	}

	@Test 
	public function removeClassOnNull()
	{
		nullDOMCollection.removeClass('myclass');
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));
	}

	@Test 
	public function removeClassOnEmpty()
	{
		emptyCollection.removeClass('myclass');
		Assert.isFalse(emptyCollection.hasClass('myclass'));
	}

	@Test 
	public function toggleClass()
	{
		// It doesn't exist, toggle it on
		Assert.isFalse(h1.hasClass('first'));
		h1.toggleClass('first');
		Assert.isTrue(h1.hasClass('first'));

		// it does exist, toggle it off
		Assert.isTrue(h1.hasClass('first'));
		h1.toggleClass('first');
		Assert.isFalse(h1.hasClass('first'));

		Assert.areEqual("", h1.attr('class'));
	}

	@Test public function toggleClassMultipleClassNames()
	{
		h1.toggleClass('first second fourth fifth');
		Assert.isTrue(h1.hasClass('first second fourth fifth'));
		Assert.isFalse(h1.hasClass('third'));

		h1.toggleClass('second third fourth');
		Assert.isTrue(h1.hasClass('first third fifth'));
		Assert.isFalse(h1.hasClass('second fourth'));

		Assert.areEqual('first fifth third', h1.attr('class'));
	}

	@Test 
	public function toggleClassOnNull()
	{
		nullDOMCollection.toggleClass('myclass');
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));

		// no matter which side of the toggle this should return false
		nullDOMCollection.toggleClass('myclass');
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));
	}

	@Test 
	public function toggleClassOnEmpty()
	{
		emptyCollection.toggleClass('myclass');
		Assert.isFalse(emptyCollection.hasClass('myclass'));

		// no matter which side of the toggle this should return false
		emptyCollection.toggleClass('myclass');
		Assert.isFalse(emptyCollection.hasClass('myclass'));
	}

	@Test 
	public function tagName()
	{
		Assert.areEqual("h1", h1.tagName());
		Assert.areEqual("ul", a.tagName());
		Assert.areEqual("div", emptyNode.tagName());
	}

	@Test 
	public function tagNameOnNull()
	{
		Assert.areEqual("", nullDOMCollection.tagName());
	}

	@Test 
	public function tagNameOnEmpty()
	{
		Assert.areEqual("", emptyCollection.tagName());
	}

	@Test 
	public function tagNameOnMultiple()
	{
		var q = new DOMCollection();
		q.addCollection(lists);
		q.addCollection(listItems);

		Assert.areEqual("ul", q.tagName());
	}

	@Test 
	public function val()
	{
		// The actual reading of "val" is done in single.ElementManipulation
		// and we already have unit tests for that.
		// Keep this simple:
		// Make sure it reads the first Node in the set.

		var input1 = "<input type='text' value='attr' />".parse().getNode();
		var input2 = "<input type='text' value='attr' />".parse().getNode();
		#if js 
		Reflect.setField(input1, "value", "value1");
		Reflect.setField(input2, "value", "value2");
		#else 
		input1.setVal("value1");
		input2.setVal("value2");
		#end

		var q = new DOMCollection().add(input1).add(input2);

		Assert.areEqual("value1", q.val());
	}

	@Test 
	public function valOnEmpty()
	{
		Assert.areEqual("", emptyCollection.val());
	}

	@Test 
	public function valOnNull()
	{
		Assert.areEqual("", nullDOMCollection.val());
	}

	@Test 
	public function setVal()
	{
		// The actual setting of "val" is done in single.ElementManipulation
		// and we already have unit tests for that.
		// Keep this simple:
		// Make sure it sets for every element


		var input1 = "<input type='text' value='attr' />".parse().getNode();
		var input2 = "<input type='text' value='attr' />".parse().getNode();
		#if js
		// On Javascript this behaviour works with the javascript field "value"
		Reflect.setField(input1, "value", "value1");
		Reflect.setField(input2, "value", "value2");
		#else 
		// On other platforms, we use attributes
		input1.setAttr("value", "value1");
		input2.setAttr("value", "value2");
		#end

		var q = new DOMCollection().add(input1).add(input2);
		q.setVal("newValue");

		Assert.areEqual("newValue", q.val());
		Assert.areEqual("newValue", q.getNode(0).val());
		Assert.areEqual("newValue", q.getNode(1).val());
	}

	@Test 
	public function setValOnNull()
	{
		nullDOMCollection.setVal("newvalue");
		Assert.areEqual("", nullDOMCollection.val());
	}

	@Test 
	public function setValOnEmpty()
	{
		emptyCollection.setVal("newvalue");
		Assert.areEqual("", emptyCollection.val());
	}

	@Test
	public function textOnSingle()
	{
		Assert.areEqual("Title", h1.text());
		Assert.areEqual("StartEnd", ".nonelements".find().text());
	}

	@Test 
	public function textOnMultiple()
	{
		Assert.areEqual("22", pickme.text());
		Assert.areEqual("123123", listItems.text());
		Assert.areEqual("StartEnd", textNodes.text());
		Assert.areEqual("Comment1Comment2", commentNodes.text());
		Assert.areEqual("StartComment1EndComment2", ".nonelements".find().children(false).text());
	}

	@Test 
	public function textOnNull()
	{
		Assert.areEqual("", nullDOMCollection.text());
	}

	@Test 
	public function textOnEmpty()
	{
		Assert.areEqual("", emptyCollection.text());
	}

	@Test 
	public function setText()
	{
		Assert.areEqual("123123", listItems.text());
		listItems.setText('a');
		Assert.areEqual("aaaaaa", listItems.text());
	}

	@Test 
	public function setTextOnNull()
	{
		nullDOMCollection.setText("My New Text");
		Assert.areEqual("", nullDOMCollection.text());
	}

	@Test 
	public function setTextOnEmpty()
	{
		emptyCollection.setText("My New Text");
		Assert.areEqual("", emptyCollection.text());
	}

	@Test 
	public function innerHTML() 
	{
		Assert.areEqual("123123", listItems.innerHTML());

		var html = ".nonelements".find().innerHTML();
		Assert.areEqual("Start<!--Comment1-->End<!--Comment2-->", html);

		Assert.isTrue(a.innerHTML().indexOf('</li>') > -1);
	}

	@Test 
	public function innerHTMLOnNull()
	{
		Assert.areEqual("", nullDOMCollection.innerHTML());
	}

	@Test 
	public function innerHTMLOnEmpty()
	{
		Assert.areEqual("", emptyCollection.innerHTML());
	}

	@Test 
	public function setInnerHTML()
	{
		Assert.areEqual("123123", listItems.innerHTML());
		listItems.setInnerHTML('a');
		Assert.areEqual("aaaaaa", listItems.innerHTML());

		// Check this is actually creating elements
		listItems.setInnerHTML('<a href="#">Link</a>');
		Assert.areEqual(listItems.length, listItems.find("a").length);
	}

	@Test 
	public function setInnerHTMLOnNull()
	{
		nullDOMCollection.setInnerHTML("My Inner HTML");
		Assert.areEqual("", nullDOMCollection.innerHTML());
	}

	@Test 
	public function setInnerHTMLOnEmpty()
	{
		emptyCollection.setInnerHTML("My Inner HTML");
		Assert.areEqual("", emptyCollection.innerHTML());
	}

	@Test 
	public function html() 
	{
		// slight differences in toString() rendering between JS and Xml platforms
		var expected = "<li id='a1'>1</li><li id='a2' class='pickme'>2</li><li id='a3'>3</li><li id='b1'>1</li><li id='b2' class='pickme'>2</li><li id='b3'>3</li>";
		Assert.areEqual(expected.length, listItems.html().length);

		var html = ".nonelements".find().html();
		Assert.areEqual('<div class="nonelements">Start<!--Comment1-->End<!--Comment2--></div>', html);

		Assert.isTrue(a.html().indexOf('</li>') > -1);
	}

	@Test 
	public function htmlWithDifferentNodeTypes() 
	{
		// slight differences in toString() rendering between JS and Xml platforms
		// toString() seems to ignore empty text nodes...
		var expected = "<p>Text Node</p>  <p>  Text Node with Spaces  </p> <!-- Comment -->";
		var xml = expected.parse();
		var result = xml.html();
		Assert.areEqual(5, xml.length);
		Assert.areEqual(expected, result);
	}

	@Test 
	public function htmlOnNull()
	{
		Assert.areEqual("", nullDOMCollection.html());
	}

	@Test 
	public function htmlOnEmpty()
	{
		Assert.areEqual("", emptyCollection.html());
	}

	@Test 
	public function chaining()
	{
		// Run every possible chaining command
		var returnValue = lists.setAttr("title", "hey").removeAttr("title")
			.addClass("mylist").removeClass("mylist").toggleClass("mylist")
			.setVal("value").setText("text").setInnerHTML("html");
		
		// Check that we're still looking at the same thing
		Assert.areEqual(2, returnValue.length);
		Assert.areEqual("a", returnValue.eq(0).attr('id'));
		Assert.areEqual("b", returnValue.eq(1).attr('id'));
	}
}
