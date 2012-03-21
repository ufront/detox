/****
* Created by Jason O'Neil in 2012 
* 
* Released into the public domain, as an act of generosity and / or practicality.
****/

package domtools;

import js.w3c.level3.Core;
import js.w3c.level3.Core.Document;
import CommonJS;
import domtools.Query;

class AbstractCustomElement extends Query
{
	/** Create a new element of type "name", and add it to the collection.  
	When your class extends this, it will automatically work with the domtools API (through using).  
	Therefore your class can have very tight integration between haxe features and the DOM. */
	public function new(name:String)
	{
		super();

		var elm = Query.create(name);
		
		this.add(elm);
	}
}