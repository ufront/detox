package domtools;

import js.w3c.level3.Core;
import js.w3c.level3.Core.Document;
import CommonJS;
import domtools.Query;

class AbstractCustomElement extends Query
{
	/** Create a new element of type "name", and add it to the collection.  When your class extends this, it will automatically have access to the entire Query API.  */
	public function new(name:String)
	{
		super();

		var elm = Query.createElement(name);
		
		this.add(elm);
	}
}