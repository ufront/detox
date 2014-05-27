package;

import massive.munit.Assert;

import dtx.DOMNode;
using Detox;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class ElementManipulationTest 
{
	var sampleDocument:DOMNode;
	var h1:DOMNode;
	var h2:DOMNode;
	var comment:DOMNode;
	var text:DOMNode;

	var parent:DOMNode;
	var child:DOMNode;
	var classTest:DOMNode;
	var nullnode:DOMNode;
	
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
		nullnode = null;
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
	public function typeCheckOnNull():Void
	{
		Assert.isFalse(nullnode.isElement());
		Assert.isFalse(nullnode.isTextNode());
		Assert.isFalse(nullnode.isComment());
		Assert.isFalse(nullnode.isDocument());
	}

	@Test
	public function testReadAttr():Void
	{
		Assert.areEqual("title", h1.attr("id"));
	}

	@Test
	public function testNullReadAttr():Void
	{
		Assert.areEqual("", nullnode.attr("id"));
	}

	@Test
	public function testSetAttr():Void
	{
		var newID = "test";
		child.setAttr('id', newID);
		Assert.areEqual(newID, child.attr("id"));
	}

	@Test
	public function testNullSetAttr():Void
	{
		var result = nullnode.setAttr('id', "test");
		Assert.areEqual(null, result);
	}

	@Test
	public function testRemoveAttr():Void
	{
		h1.removeAttr('id');
		#if js
		Assert.isFalse(h1.hasAttributes());
		#else 
		var i = 0;
		for (attr in h1.attributes) i++;
		Assert.areEqual(0, i);
		#end
	}

	@Test
	public function testNullRemoveAttr():Void
	{
		var result = nullnode.removeAttr('id');
		Assert.areEqual(null, result);
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
	public function testNullHasClass():Void
	{
		Assert.isFalse(nullnode.hasClass('second'));
	}

	@Test
	public function testHasClassMultiple():Void
	{
		Assert.isTrue(classTest.hasClass('third first'));
		Assert.isTrue(classTest.hasClass('third   first'));
		Assert.isFalse(classTest.hasClass('fourth second third'));
	}

	@Test
	public function testAddClass():Void
	{
		h1.addClass('myclass');
		Assert.isTrue(h1.hasClass('myclass'));
	}

	@Test
	public function testNullAddClass():Void
	{
		var result = nullnode.addClass('myclass');
		Assert.areEqual(null, result);
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
	public function testNullRemoveClass():Void
	{
		var result = nullnode.removeClass('myclass');
		Assert.areEqual(null, result);
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
	public function testNullToggleClass():Void
	{
		var result = nullnode.toggleClass('myclass');
		Assert.areEqual(null, result);
	}

	@Test
	public function testTagName():Void 
	{
		Assert.areEqual("h1", h1.tagName());
		Assert.areEqual("h2", h2.tagName());
		Assert.areEqual("myxml", sampleDocument.tagName());
	}

	@Test
	public function testTagNameOfNonElement():Void 
	{
		Assert.areEqual("#text", text.tagName());
		Assert.areEqual("#comment", comment.tagName());
		Assert.areEqual("", nullnode.tagName());
	}

	@Test
	public function testUpperCaseTagName():Void 
	{
		var elm = "MyElement".create();
		Assert.areEqual( "myelement", elm.tagName() );
		Assert.areEqual( "<myelement></myelement>", elm.html() );
	}

	@Test
	public function testValInput():Void 
	{
		var input = "<input type='text' value='attr' />".parse().getNode();
		#if js 
		Reflect.setField(input, "value", "myvalue");
		#else 
		input.setAttr("value", "myvalue"); 
		#end
		Assert.areEqual("myvalue", input.val());
	}

	@Test
	public function testValOnTextArea():Void 
	{
		var ta = "<textarea>test</textarea>".parse().getNode();
		#if js 
		Reflect.setField(ta, "value", "myvalue");
		#else 
		ta.setAttr("value", "myvalue");
		#end
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
	public function testNullVal():Void
	{
		Assert.areEqual("", nullnode.val());
	}

	@Test
	public function testSetValInput():Void 
	{
		var input = "<input type='text' value='attr' />".parse().getNode();
		input.setVal("newvalue");
		Assert.areEqual("newvalue", input.val());
	}

	@Test
	public function testNullSetVal():Void
	{
		var result = nullnode.setVal("value");
		Assert.areEqual(null, result);
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
	public function testNullText():Void 
	{
		Assert.areEqual("", nullnode.text());
	}

	@Test
	public function testSetText():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		helloworld.setText("Goodbye Planet");
		Assert.areEqual("Goodbye Planet", helloworld.innerHTML());
	}

	@Test
	public function testNullSetText():Void 
	{
		Assert.areEqual(null, nullnode.setText("text"));
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
	public function testNullInnerHTML():Void 
	{
		Assert.areEqual("", nullnode.innerHTML());
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
	public function testNullSetInnerHTML():Void 
	{
		Assert.areEqual(null, nullnode.setInnerHTML("innerhtml"));
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
	public function testHtml():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		Assert.areEqual("<div>Hello <i>World</i></div>", helloworld.html());
		Assert.areEqual("<i>World</i>", helloworld.find("i").html());
	}

	@Test
	public function testHtmlSelfClosing():Void 
	{
		var div = "<div id='1'>Test</div>".parse().getNode();
		var emptyDiv = "<div id='1' />".parse().getNode();
		var emptyImg = "<img id='1' />".parse().getNode();

		Assert.areEqual('<div id="1">Test</div>', div.html());
		Assert.areEqual('<div id="1"></div>', emptyDiv.html());
		Assert.isTrue(emptyImg.html().indexOf(">") > -1);
		Assert.isTrue(emptyImg.html().indexOf("</img>") == -1);
	}

	@Test 
	public function htmlWithDifferentNodeTypes() 
	{
		// slight differences in toString() rendering between JS and Xml platforms
		// toString() seems to ignore empty text nodes...
		var expected = "<p>Text <i>Node</i> </p>  <p>  Text Node with Spaces  </p> <!-- Comment -->";
		var xml = expected.parse();
		Assert.areEqual(5, xml.length);
		Assert.areEqual("<p>Text <i>Node</i> </p>", xml.getNode(0).html());
		Assert.areEqual("  ", xml.getNode(1).html());
		Assert.areEqual("<p>  Text Node with Spaces  </p>", xml.getNode(2).html());
		Assert.areEqual(" ", xml.getNode(3).html());
		Assert.areEqual("<!-- Comment -->", xml.getNode(4).html());
	}

	@Test
	public function testNullHtml():Void 
	{
		Assert.areEqual("", nullnode.html());
	}

	@Test
	public function testHtmlOnNonElements():Void 
	{
		Assert.areEqual("<!-- A comment -->", comment.html());
		Assert.areEqual("Text", text.html());
	}

	@Test
	public function testHtmlEntityEscaping() {
		var div = 'div'.create();

		// Test basic escaping from `setText`

		div.setText( 'Please no <b>Bold</b>' );
		Assert.areEqual( "Please no <b>Bold</b>", div.text() );
		Assert.areEqual( "<div>Please no &lt;b&gt;Bold&lt;/b&gt;</div>", div.html() );
		var newDiv = div.html().parse();
		Assert.areEqual( 0, newDiv.find("b").length );

		div.setText( 'This & That' );
		var newDiv = div.html().parse();
		Assert.areEqual( "<div>This &amp; That</div>", div.html() );

		// Test escapting quotes in `setAttr` to prevent maliciousness
		
		var link = '<a href="">Link</a>'.parse();

		var attemptEscapeAttr = 'fakelink" onclick="HAHA!';
		link.setAttr( "href", attemptEscapeAttr );
		Assert.areEqual( attemptEscapeAttr, link.attr('href') );
		Assert.areEqual( '', link.attr('onclick') );
		Assert.isTrue( link.html().indexOf(StringTools.htmlEscape(attemptEscapeAttr,true))>-1 );

		var newLink = link.html().parse();
		Assert.areEqual( attemptEscapeAttr, newLink.attr('href') );
		Assert.areEqual( '', newLink.attr('onclick') );
		
		// Test escaping from `setAttr`

		var div = "div".create();
		var content = "Hello <\'Friends\' & \"Family\">";
		var encodedContent = StringTools.htmlEscape( content, true );
		
		div.setAttr("title",content);

		Assert.areEqual('<div title="$encodedContent"></div>', div.html());
		var newDiv = div.html().parse();
		Assert.isTrue( div.html().indexOf(encodedContent)>-1 );
		Assert.areEqual(content, newDiv.attr('title'));

		// Test escaping from innerHTML

		var content = "<p>Here is some code: <code>var arr:Array&lt;String&gt;</code> - nice hey!</p>";
		var div = "div".create();
		div.setInnerHTML( content );
		Assert.areEqual( '$content', div.innerHTML() );
		Assert.areEqual( '<div>$content</div>', div.html() );

		// Test escaping of non-standard entities
		var content = "<div>&laquo;Haxe&raquo;</div>";
		var div = content.parse();
		#if js
			// This difference is frustrating but I can't yet find a workaround.
			// On JS, when parsing the string into the DOM, those entities are converted to the unicode characters.
			// When we go to output, they are unicode, not the entities.
			// Ideally, I would like text() to contain the unencoded unicode, and html() to use the entities.
			// If anyone can think of an implementation please let me know.
			Assert.areEqual( 6, div.text().length ); // "«Haxe»"
			Assert.areEqual( 17, div.html().length ); // "<div>«Haxe»</div>"
		#else
			Assert.areEqual( "&laquo;Haxe&raquo;", div.text() );
			Assert.areEqual( "<div>&laquo;Haxe&raquo;</div>", div.html() );
		#end

		// Test escaping of non-standard entities
		var content = "<p>Furthermore, Cauê Waneck's</p>";
		var div = content.parse();
		Assert.areEqual( "Furthermore, Cauê Waneck's", div.text() );
		Assert.areEqual( "<p>Furthermore, Cauê Waneck's</p>", div.html() );
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
	public function testCloneNullNode():Void 
	{
		Assert.areEqual(null, nullnode.clone());
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

	@Test 
	function testIndexNormal():Void 
	{
		Assert.areEqual(1, h1.index());
		Assert.areEqual(3, h2.index());
		Assert.areEqual(0, text.index());
		Assert.areEqual(9, parent.index());
		Assert.areEqual(0, child.index());
	}

	@Test 
	function testIndexNull():Void 
	{
		Assert.areEqual(-1, nullnode.index());
	}

	@Test 
	function testChaining():Void 
	{
		var originalElement:DOMNode = "div".create().setAttr("id", "original");
		var returnedElement:DOMNode;

		returnedElement = originalElement
			.setAttr("title", "")
			.removeAttr("title")
			.addClass("class")
			.toggleClass("class")
			.removeClass("class")
			.setVal("test")
			.setText("mytext")
			.setInnerHTML("myinnerHTML")
		;

		returnedElement.setAttr("id", "updatedID");
		Assert.areEqual(originalElement.attr('id'), returnedElement.attr('id'));
	}
}
