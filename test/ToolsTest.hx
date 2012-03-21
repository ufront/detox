package ;
import utest.Assert;
import domtools.Query;
using domtools.Tools;

/**
* Auto generated MassiveUnit Test Class 
*/
class ToolsTest 
{
	var body:Node;
	
	public function new() 
	{
	}
	
	
	public function setup():Void
	{
		body = Query.create("div");
		var str = 
"
<h1>Simple H1</h1>
<h2>Simple H2</h2>
<h3>Simple H3</h3>
<p class='type1'>Type 1</p>
<p class='type2'>Type 2</p>
<p class='type3'>Type 3</p>

";
		body.setInnerHTML(str);
		trace ("Setup");
	}
	
	public function teardown():Void
	{
		body = null;
	}
	
	public function findByElementSingle()
	{
		trace ("Setup");
		var text = body.find("H1").text();
		Assert.equals(text, "Simple H1");
	}
	
	public function findByElementMultiple()
	{
		var length = body.find("p").length;
		Assert.equals(length, 3);
	}
	
	public function readAttribute():Void
	{
		Assert.isTrue(false);
	}

	public function writeAttribute():Void
	{
		Assert.isTrue(true);
	}
}