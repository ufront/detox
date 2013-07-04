package;

import massive.munit.Assert;



using Detox;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class CollectionTest 
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
	var h1:Nodes;
	var lists:Nodes;
	var list1:Nodes;
	var list2:Nodes;
	var listItems:Nodes;
	
	@Before
	public function setup():Void
	{
		// trace ("Setup");
		sampleDocument = "<myxml>
		<div>
			<h1>Title</h1>
			<ul id='a'>
				<li id='a1'>One A</li>
				<li id='a2'>Two A</li>
				<li id='a3'>Three A</li>
			</ul>
			<ul id='b'>
				<li id='b1'>One B</li>
				<li id='b2'>Two B</li>
				<li id='b3'>Three B</li>
			</ul>
		</div>
		<table>
			<thead>
				<tr>
					<th></th>
					<th>One</th>
					<th>Two</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>A</th>
					<td>One - A</td>
					<td>Two - A</td>
				</tr>
				<tr>
					<th>B</th>
					<td>One - B</td>
					<td>Two - B</td>
				</tr>
			</tbody>
		</table>
		</myxml>".parse();

		Detox.setDocument(sampleDocument.getNode());

		h1 = "h1".find();
		lists = "ul".find();
		list1 = "#a".find();
		list2 = "#b".find();
		listItems = "li".find();
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function createEmptyQuery()
	{
		var q:Nodes = [];
		Assert.areEqual(0, q.length);
	}

	@Test 
	public function createQueryFromNode()
	{
		var q1:Nodes = [ h1.getNode() ];
		var q2:Nodes = [ list1.getNode() ];
		Assert.areEqual(1, q1.length);
		Assert.areEqual(1, q2.length);
	}

	@Test 
	public function createQueryFromIterable()
	{
		var arr = ["#a1".find().getNode(), "#b2".find().getNode(), "#a3".find().getNode()];
		var query = lists;

		var q1:Nodes = arr;
		var q2:Nodes = query;
		Assert.areEqual(3, q1.length);
		Assert.areEqual(2, q2.length);
	}

	@Test 
	public function iterator()
	{
		var total = 0;
		for (i in listItems)
		{
			total++;
		}
		Assert.areEqual(6, total);
	}

	@Test 
	public function iteratorOnEmpty()
	{
		var total = 0;
		var nodes:Nodes = [];
		for (i in nodes)
		{
			total++;
		}
		Assert.areEqual(0, total);
	}

	@Test 
	public function getNodeFirst()
	{
		// if we can access the nodeType property, then we know we're on a Node 
		Assert.areEqual(dtx.DOMType.ELEMENT_NODE, h1.getNode().nodeType);
	}

	@Test 
	public function getNodeN()
	{
		Assert.areEqual('a3', listItems.getNode(2).attr('id'));
	}

	@Test 
	public function getNodeFromEmpty()
	{
		var q:Nodes = [];
		Assert.isNull(q.getNode());
	}

	@Test 
	public function getNodeOutOfBounds()
	{
		Assert.isNull(listItems.getNode(100));
	}

	@Test 
	public function first()
	{
		Assert.areNotEqual(null, listItems.first);
		Assert.areEqual("a1", listItems.first.attr("id"));
	}

	@Test 
	public function firstOnEmpty()
	{
		var q:Nodes = [];
		Assert.areEqual(null, q.first);
		Assert.areEqual("", q.first.attr("id"));
	}

	@Test 
	public function last()
	{
		Assert.areNotEqual(null, listItems.last);
		Assert.areEqual("b3", listItems.last.attr("id"));
	}

	@Test 
	public function lastOnEmpty()
	{
		var q:Nodes = [];
		Assert.areEqual(null, q.last);
		Assert.areEqual("", q.last.attr("id"));
	}

	@Test 
	public function add()
	{
		var q:Nodes = [];
		Assert.areEqual(0, q.length);
		
		q.add(h1.getNode());
		Assert.areEqual(1, q.length);
		
		q.add("h2".create());
		Assert.areEqual(2, q.length);
	}

	@Test 
	public function addNull()
	{
		var q:Nodes = [];
		q.add(null);
		Assert.areEqual(0, q.length);
	}

	@Test 
	public function addAlreadyInCollection()
	{
		var q:Nodes = [];
		Assert.areEqual(0, q.length);
		
		q.add(h1.getNode());
		Assert.areEqual(1, q.length);
		
		// Even if we add it again we should only have a 1 length
		q.add(h1.getNode());
		Assert.areEqual(1, q.length);
	}

	@Test 
	public function addCollection()
	{
		var q:Nodes = [];
		var arr = ["h1".create(), "h2".create(), "h3".create()];
		q.addCollection(arr);

		Assert.areEqual(3, q.length);
	}

	@Test 
	public function addCollectionNull()
	{
		var q:Nodes = [];
		var arr:Array<Node> = null;
		q.addCollection(arr);
		
		Assert.areEqual(0, q.length);
	}

	@Test 
	public function addCollectionWithNull()
	{
		var q:Nodes = [];
		var arr = ["h1".create(), null, "h3".create()];
		q.addCollection(arr);
		
		Assert.areEqual(2, q.length);
	}

	@Test 
	public function addCollectionElementsOnly()
	{
		var q1:Nodes = [];
		var q2:Nodes = [];
		var q3:Nodes = [];
		#if js
		var nodeList = "table".find().getNode().toDom().childNodes;
		#else 
		var nodeList = "table".find().getNode();
		#end
		var collection:Nodes = nodeList;
		
		// The default should be false
		q1.addCollection(collection.children);
		q2.addCollection(collection.children, true);
		q3.addCollection(collection.children, false);

		Assert.areEqual(5, q1.length);
		Assert.areEqual(2, q2.length);
		Assert.areEqual(5, q3.length);
	}

	@Test 
	public function addNodeList()
	{
		var q:Nodes;
		#if js 
			q = Detox.document.toElement().querySelectorAll("li");
		#else
			q = Detox.document.find("li");
		#end 
		Assert.areEqual(6, q.length);
	}

	@Test 
	public function removeFromCollection()
	{
		var string = "";
		listItems.removeFromCollection("#b1".find().getNode());
		listItems.removeFromCollection("#b3".find().getNode());

		Assert.areEqual(4, listItems.length);
		for (item in listItems)
		{
			string += item.attr('id');
		}
		Assert.areEqual("a1a2a3b2", string);
	}

	@Test 
	public function removeQueryFromCollection()
	{
		var string = "";
		listItems.removeFromCollection("li".find());
		Assert.areEqual(0, listItems.length);
	}

	@Test 
	public function removeQueryFromCollection2()
	{
		var string = "";
		listItems.removeFromCollection("#b1".find());
		listItems.removeFromCollection("#b3".find());
		
		Assert.areEqual(4, listItems.length);
		for (item in listItems)
		{
			string += item.attr('id');
		}
		Assert.areEqual("a1a2a3b2", string);
	}

	@Test 
	public function removeFromCollectionNull()
	{
		listItems.removeFromCollection();
		listItems.removeFromCollection(null, null);
		Assert.areEqual(6, listItems.length);
	}

	@Test 
	public function removeFromCollectionNotInCollection()
	{
		var t = "table".find();
		listItems.removeFromCollection(t);
		listItems.removeFromCollection(t.getNode());

		Assert.areEqual(6, listItems.length);
	}

	@Test 
	public function each()
	{
		var total = 0;
		listItems.each(function (li) {
			// Check each element exists and is functional
			Assert.isTrue(li.attr('id') != "");
			// Count the total number of times this function is called
			total++;
		});

		Assert.areEqual(6, total);
	}

	@Test 
	public function eachOnEmpty()
	{
		var q:Nodes = [];
		var total = 0;
		q.each(function (li) {
			// Count the total number of times this function is called
			total++;
		});

		Assert.areEqual(0, total);
	}

	@Test 
	public function eachNullCallback()
	{
		// Just check it doesn't throw an error...
		listItems.each(null);
	}

	@Test 
	public function filter()
	{
		var filteredList = listItems.filter(function (li) {
			var id = li.attr('id');
			return id.indexOf('a') > -1;
		});
		var filteredList2 = listItems.filter(function (li) {
			var id = li.attr('id');
			return id.indexOf('3') > -1;
		});
		Assert.areEqual(6, listItems.length);
		Assert.areEqual(3, filteredList.length);
		Assert.areEqual(2, filteredList2.length);
	}

	@Test 
	public function filterOnEmpty()
	{
		var q:Nodes = [];
		var total = 0;

		var filteredList = q.filter(function (li) {
			total++;
			return true;
		});

		Assert.areEqual(0, filteredList.length);
		Assert.areEqual(0, total);
	}

	@Test 
	public function filterNullCallback()
	{
		var filteredList = listItems.filter(null);

		Assert.areEqual(6, filteredList.length);
	}

	@Test 
	public function filterCallbackReturnsNull()
	{
		var filteredList = listItems.filter(function (li) {
			#if (flash9 || cpp)
			var returnValue = false;
			#else
			var returnValue:Bool = null;
			#end
			return returnValue;
		});

		Assert.areEqual(6, listItems.length);
		Assert.areEqual(0, filteredList.length);
	}

	@Test 
	public function clone()
	{
		// Create a clone of list items and modify every element
		var listItemsClone = listItems.clone();
		listItemsClone.addClass("newlistitem");

		// Check none of the original elements have changed
		for (li in listItems)
		{
			Assert.isFalse(li.hasClass('newlistitem'));
		}

		// Check all of the new elements have changed
		for (li in listItemsClone)
		{
			Assert.isTrue(li.hasClass('newlistitem'));
		}
	}
}