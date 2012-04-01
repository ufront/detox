package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import js.w3c.level3.Core;

using DOMTools;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class ElementManipulationTest 
{
	var sampleDocument:Node;
	var h1:Node;
	var h2:Node;
	var comment:Node;
	var text:Node;

	var parent:Node;
	var child:Node;
	var classTest:Node;
	
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
		var html = "<myxml>
		<h1 id='title'>My Header</h1>
		<h2>My Sub Header</h2>
		<div class='containscomment'><!-- A comment --></div>
		<div class='containstext'>Text</div>
		<div class='parent'><span class='child'>Child</span></div>
		<div id='classtest' class='first third fourth'></div>
		</myxml>";

		sampleDocument = html.parse().getNode();
		h1 = sampleDocument.find('h1').getNode();
		h2 = sampleDocument.find('h2').getNode();
		comment = sampleDocument.find('.containscomment').getNode().firstChild;
		text = sampleDocument.find('.containstext').getNode().firstChild;
		parent = sampleDocument.find('.parent').getNode();
		child = sampleDocument.find('.child').getNode();
		classTest = sampleDocument.find('#classtest').getNode();
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}
	
	
	@Test
	public function isElement():Void
	{
		Assert.isTrue(sampleDocument.isElement());
		Assert.isTrue(h1.isElement());
		Assert.isFalse(comment.isElement());
		Assert.isFalse(text.isElement());
	}

	@Test
	public function isComment():Void
	{
		Assert.isFalse(h1.isComment());
		Assert.isTrue(comment.isComment());
		Assert.isFalse(text.isComment());
	}


	@Test
	public function isTextNode():Void
	{
		Assert.isFalse(h1.isTextNode());
		Assert.isFalse(comment.isTextNode());
		Assert.isTrue(text.isTextNode());
	}

	@Test
	public function testReadAttr():Void
	{
		Assert.areEqual("title", h1.attr("id"));
	}

	@Test
	public function testSetAttr():Void
	{
		var newID = "test";
		child.setAttr('id', newID);
		Assert.areEqual(newID, child.attr("id"));
	}

	@Test
	public function testRemoveAttr():Void
	{
		h1.removeAttr('id');
		Assert.isFalse(h1.hasAttributes());
	}

	@Test
	public function testHasClass():Void
	{
		Assert.isTrue(classTest.hasClass('first'));
		Assert.isFalse(classTest.hasClass('second'));
		Assert.isTrue(classTest.hasClass('third'));
		Assert.isTrue(classTest.hasClass('fourth'));
	}

	@Test
	public function testHasClassMultiple():Void
	{
		Assert.isTrue(classTest.hasClass('third first'));
		Assert.isFalse(classTest.hasClass('fourth second third'));
	}

	@Test
	public function testAddClass():Void
	{
		h1.addClass('myclass');
		Assert.isTrue(h1.hasClass('myclass'));
	}

	@Test
	public function testAddMultipleClasses():Void
	{
		h1.addClass('myclass myclass2 myclass3');
		Assert.isTrue(h1.hasClass('myclass'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
	}

	@Test
	public function testAddClassThatAlreadyExists():Void
	{
		h1.addClass('myclass');
		h1.addClass('myclass');
		var classVal = h1.attr('class');
		Assert.areEqual(classVal.indexOf('myclass'), classVal.lastIndexOf('myclass'));
	}

	@Test
	public function testRemoveClass():Void
	{
		h1.addClass('myclass1 myclass2 myclass3');

		Assert.isTrue(h1.hasClass('myclass1'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
		Assert.areEqual(h1.attr('class'), 'myclass1 myclass2 myclass3');

		h1.removeClass('myclass1');
		Assert.isFalse(h1.hasClass('myclass1'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
		Assert.areEqual('myclass2 myclass3', h1.attr('class'));

		h1.removeClass('myclass2');
		Assert.isFalse(h1.hasClass('myclass1'));
		Assert.isFalse(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
		Assert.areEqual('myclass3', h1.attr('class'));

		h1.removeClass('myclass3');
		Assert.isFalse(h1.hasClass('myclass1'));
		Assert.isFalse(h1.hasClass('myclass2'));
		Assert.isFalse(h1.hasClass('myclass3'));
		Assert.areEqual('', h1.attr('class'));
	}

	@Test
	public function testRemoveMultipleClasses():Void
	{
		h1.addClass('myclass');
		h1.addClass('myclass2');
		h1.addClass('myclass3');
		h1.addClass('myclass4');
		Assert.isTrue(h1.hasClass('myclass'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
		Assert.isTrue(h1.hasClass('myclass4'));

		h1.removeClass('myclass4 myclass myclass3');
		Assert.isFalse(h1.hasClass('myclass'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isFalse(h1.hasClass('myclass3'));
		Assert.isFalse(h1.hasClass('myclass4'));
	}

	@Test
	public function testToggleClass():Void
	{
		h1.addClass('myclass');
		h1.toggleClass('myclass');
		Assert.isFalse(h1.hasClass('myclass'));

		h1.toggleClass('myclass2');
		Assert.isTrue(h1.hasClass('myclass2'));

		h1.addClass('myclass3 myclass4');
		h1.toggleClass('myclass3');
		Assert.areEqual('myclass2 myclass4', h1.attr('class'));
	}

	@Test
	public function testToggleMultipleClasses():Void
	{
		h1.addClass('myclass1 myclass2 myclass3 myclass4');
		h1.toggleClass('myclass1 myclass3');
		Assert.isFalse(h1.hasClass('myclass1'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isFalse(h1.hasClass('myclass3'));
		Assert.isTrue(h1.hasClass('myclass4'));
	}

	@Test
	public function testTagName():Void 
	{
		Assert.areEqual("h1", h1.tagName());
		Assert.areEqual("h2", h2.tagName());
		Assert.areEqual("myxml", sampleDocument.tagName());
	}

	@Test
	public function testValInput():Void 
	{
		var input = "<input type='text' value='attr' />".parse().getNode();
		Reflect.setField(input, "value", "myvalue");
		Assert.areEqual("myvalue", input.val());
	}

	@Test
	public function testValOnTextArea():Void 
	{
		var ta = "<textarea>test</textarea>".parse().getNode();
		Reflect.setField(ta, "value", "myvalue");
		Assert.areEqual("myvalue", ta.val());
	}

	@Test
	public function testValOnComment():Void 
	{
		Assert.areEqual(" A comment ", comment.val());
	}

	@Test
	public function testValOnTextNode():Void 
	{
		Assert.areEqual("Text", text.val());
	}

	@Test
	public function testValOnAttribute():Void 
	{
		var div = "<div value='attr'></div>".parse().getNode();
		Assert.areEqual("attr", div.val());
	}

	@Test
	public function testSetValInput():Void 
	{
		var input = "<input type='text' value='attr' />".parse().getNode();
		input.setVal("newvalue");
		Assert.areEqual("newvalue", input.val());
	}

	@Test
	public function testSetValComment():Void 
	{
		comment.setVal("mycomment");
		Assert.areEqual("<!--mycomment-->", sampleDocument.find('.containscomment').innerHTML());
	}

	@Test
	public function testSetValTextNode():Void 
	{
		text.setVal("NewText");
		Assert.areEqual("NewText", sampleDocument.find('.containstext').innerHTML());
	}

	@Test
	public function testText():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		Assert.areEqual("Hello World", helloworld.text());
	}

	@Test
	public function testSetText():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		helloworld.setText("Goodbye Planet");
		Assert.areEqual("Goodbye Planet", helloworld.innerHTML());
	}

	@Test
	public function testSetTextComment():Void 
	{
		comment.setText("mycomment");
		Assert.areEqual("<!--mycomment-->", sampleDocument.find('.containscomment').innerHTML());
	}

	@Test
	public function testSetTextTextNode():Void 
	{
		text.setText("NewText");
		Assert.areEqual("NewText", sampleDocument.find('.containstext').innerHTML());
	}

	@Test
	public function testInnerHTML():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		Assert.areEqual("Hello <i>World</i>", helloworld.innerHTML());
		Assert.areEqual("World", helloworld.find("i").innerHTML());
	}

	@Test
	public function testInnerHTMLOnNonElements():Void 
	{
		Assert.areEqual(" A comment ", comment.innerHTML());
		Assert.areEqual("Text", text.innerHTML());
	}

	@Test
	public function testSetInnerHTML():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		helloworld.setInnerHTML("Goodbye <i>Cruel</i> Planet");
		Assert.areEqual("Goodbye <i>Cruel</i> Planet", helloworld.innerHTML());
	}

	@Test
	public function testSetInnerHTMLComment():Void 
	{
		comment.setInnerHTML("mycomment");
		Assert.areEqual("<!--mycomment-->", sampleDocument.find('.containscomment').innerHTML());
	}

	@Test
	public function testSetInnerHTMLTextNode():Void 
	{
		text.setInnerHTML("NewText");
		Assert.areEqual("NewText", sampleDocument.find('.containstext').innerHTML());
	}

	@Test
	public function testCloneTextNode():Void 
	{
		var newText = text.clone();
		Assert.areEqual(text.nodeValue, newText.nodeValue);
		newText.setText("Different");
		Assert.areNotEqual(text.nodeValue, newText.nodeValue);
	}

	@Test
	public function testCloneComment():Void 
	{
		var newComment = comment.clone();
		Assert.areEqual(comment.nodeValue, newComment.nodeValue);
		newComment.setText("Different");
		Assert.areNotEqual(comment.nodeValue, newComment.nodeValue);
	}

	@Test
	public function testCloneElement():Void 
	{
		var newH1 = h1.clone();
		Assert.areEqual(h1.text(), newH1.text());
		Assert.areEqual(h1.attr('id'), newH1.attr('id'));

		newH1.setText("Different");
		newH1.setAttr("id", "differentid");
		Assert.areNotEqual(h1.text(), newH1.text());
		Assert.areNotEqual(h1.attr('id'), newH1.attr('id'));
	}

	@Test
	public function testCloneElementRecursive():Void 
	{
		var newSampleDoc = sampleDocument.clone();
		var newH1 = newSampleDoc.find('h1').getNode();
		var newH2 = newSampleDoc.find('h2').getNode();
		newH1.setText("Different");
		newH1.setAttr("id", "differentid");

		Assert.areNotEqual(h1.text(), newH1.text());
		Assert.areNotEqual(h1.attr('id'), newH1.attr('id'));
		Assert.areNotEqual(sampleDocument.innerHTML(), newSampleDoc.innerHTML());
		Assert.areEqual(h2.text(), newH2.text());
	}

}