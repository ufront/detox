
package test;

import domtools.Query;
import domtools.AbstractCustomElement;
using domtools.ElementManipulation;
using domtools.Traversing;
using domtools.DOMManipulation;

class Main
{
	public static function main()
	{
		// Make our traces go to the firebug console
		haxe.Log.trace = haxe.Firebug.trace;
		
		// When the window is loaded, run our test.
		js.Lib.window.onload = run;
	}

	public static function run(e)
	{
		var h1Node = new Query("h1");
		var hiddenField = new Query("#hiddenfield");
		var textContentTest = new Query("#textcontenttest");
		var innerHTMLTest = new Query("#innerhtmltest");
		
		h1Node.setAttr("id","bigtitle");
		trace (h1Node.attr("id")); //bigtitle
		trace(h1Node.setText("New Title").text()); // "New Title"
		trace(textContentTest.text()); // "This is MY test..."
		trace(textContentTest.setText("Simplified").text()); // "Simplified"


		h1Node.addClass("big");
		h1Node.addClass("ass");
		h1Node.addClass("title");
		trace (h1Node.attr("class")); // "big title"

		trace (h1Node.hasClass("big")); // true
		trace (h1Node.hasClass("massive")); // false
		
		h1Node.removeAttr("class");
		trace (h1Node.hasClass("big")); // false
		h1Node.addClass("no-duplicate").addClass("no-duplicate");
		trace (h1Node.attr("class")); // "no-duplicate"

		h1Node.removeAttr("class");
		h1Node.addClass("one").addClass("two").addClass("three").addClass("four").addClass("five");
		trace (h1Node.attr("class")); // "one two three four five"
		h1Node.removeClass("one").removeClass("three").removeClass("five");
		trace (h1Node.attr("class")); // "two four"
		h1Node.removeClass("fake-class");

		h1Node.removeClass("two").removeClass("four");
		trace (h1Node.attr("class")); // ""

		h1Node.toggleClass("toggle-on");
		trace (h1Node.attr("class")); // "toggle-on"
		h1Node.toggleClass("toggle-on");
		trace (h1Node.attr("class")); // ""

		trace (hiddenField.val()); // "dinosaur"

		trace (innerHTMLTest.innerHTML()); // "<!--Hidden Comment-->My <em>second</em> paragraph"
		trace (innerHTMLTest.firstChild().innerHTML()); // "Hidden Comment"
		trace (innerHTMLTest.setInnerHTML("Welcome to the <strong>WORLD</strong> of tomorrow").firstChild().getNode().nodeType); // 3
		trace (innerHTMLTest.firstChild().innerHTML()); // "WORLD"

		var clonedNode = h1Node.clone().setAttr("id","secondTitle");
		CommonJS.getHtmlDocument().body.append(clonedNode);
		clonedNode.setText("Second Title");
		trace (new Query("#secondTitle") != null); // True
		trace(h1Node.clone().text()); // "New Title"

		var allListItems = new Query("li");
		trace (allListItems.first().text()); // "First"
		trace (allListItems.length);
		var i = 0;
		for (n in allListItems) { i = i + 1; }
		trace (i == allListItems.length); // True
		trace (allListItems.last().getNode().text()); // "C"

		var secondListItems = new Query("li.second");
		secondListItems.each(function (n:Node) {
			if (n.hasClass("second"))
			{
				n.setText("This is the 2nd");
			}
		});
		var secondListItemInSecondList = new Query("ul.second li.second");
		trace (secondListItemInSecondList.text()); // "This is the 2nd"

		var listItemsWithLetterI = allListItems.filter(function (n) {
			return n.text().indexOf("i") > -1;
		});
		trace (listItemsWithLetterI.length); // 5

		for (node in secondListItemInSecondList.ancestors())
		{
			trace (node.nodeName); // "UL", "BODY"
		} 
		trace(secondListItemInSecondList.ancestors().length); // 2

		trace(new Query("ul").find("li.first").addClass("first-list-item").text()); // FirstA

		var table = new test.Table();
		trace (table.text()); // "SampleTable!PrettyGreat"
		CommonJS.getHtmlDocument().body.appendChild(table.getNode(0));
		table.find("td").setAttr("style","border:1px solid black");
	}
}