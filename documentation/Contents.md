dom.hx - A Haxe Library for manipulating Xml and the DOM across platforms.
==========================================================================

^^ - means functionality is not finished yet.

General Usage

 * "using dom.HX"
 * traversing
 * element manipulation
 * dom manipulation
 * ^^ events
 * ^^ style
 * ^^ animation

Cross Platform

 * JS specific
 * Haxe Xml targets
 	* Neko
 	* ^^ Flash
 	* ^^ PHP
 	* ^^ CPP
 	* ^^ Java
 	* ^^ C#
 * ^^ NodeJS - ? what do we do here?
 * Macro runtime

Concepts

 * Collections and Nodes
 * Widgets / DataWidgets

Widgets

 * Introduction (what, why?)
 * Setting up a widget manually
 * Extending a widget class
 * Examples
 * Empty text nodes, comment nodes get deleted.  (uh oh! - what about script nodes? css? etc)
 * Setting up a widget using templates
 * ^^ Partials
 	* ^^ Reference by fully qualified classname, or class in the same package
 	* ^^ Partial further down the page in the same template file
 	* ^^ <$MyWidget /> -> could be a class (or template which will turn into a class) with the same package path
 	     <$some.package.MyWidget> -> a widget / class with a different path
 	     <$SomePartial /> -> a partial taken from further down the same page (takes precedence over files)
 	     <partial name="MyWidget">Some Code</partial>

 	     QUESTIONS:
 	     * do these partial widgets get passed any constructor values?
 	       eg. <$MyButton args="(name, 'save()', Colour.Green)" />
 	     * do these partial widgets get associated with a class property (from data widgets)
 	       eg. <$MyButton inject="obj.property" />
 	       if (obj.property != null) -> widget.insert-at-location(obj.property);
 	       ... Or is that completely normal?
 	       <div>$myButton</div>
 	       (where $myButton is a widget instance to be imported?)
    
    // Straight forward usage.  Make this just work:

    <dtx:MyContactCard name="Jason" email="jason@gmail.com" /> 
    <dtx:MyContactCard name="$myName" email="$myEmail" /> 

    <dtx:partial name="MyContactCard">
    	<h1>$name</h1>
    	<a href="mailto:$email">$email</a>
    </dtx:partial>

        * The macro detects any partials, and creates a class
          * After class is created, delete the partial declaration from the template 
        * All standard widgets (including partials) should:
          * Scan for variables
            * If found, create a property.  For the example above:
                public var name(default,set_name):String;
                public var email(default,set_email):String;
            * The macro adds the "set_email" method which updates the DOM state.
            * So you could do: 
                var c = new MyContactCard();
                c.name = "jason";
                c.email = "jason@gmail.com"
              and the DOM would update accordingly.
          * Scan for partial calls:
	        * Match in this order
	          * dtx:ClassName                  // partial in this file (generate class automatically)
	          * dtx:ClassName                  // class defined in the same package
	          * dtx:my.pack.ClassName          // fully qualified class name / package
	        * instantiate:
	            var widget = new MyPartial();
	        * set variables:
	            for (varName in MyPartial.allVariables) { Reflect.setField(this, varName, includeXml.attr(varName)) }
	        * add in the right spot:
	            widget.insertThisBefore(includeXml);
	            includeXml.removeThisChild();

	Generated class:

	class MyContactCard
	{
		public var name(default,set_name):String;
		public var email(default,set_email):String;

		function set_name(name)
		{
			this.getNode(0).setText(name);
		}

		function set_email(email)
		{
			this.getNode(2).setText(email);
			this.getNode(2).setAttr("mailto:" + email);
		}

		override function get_template()
		{
			return "<h1></h1>
    				<a href='mailto:'></a>";
		}
	}

	// Any partial call inside a normal widget must be targeting a normal widget.  A 
	//  normal widget cannot contain an include of a datawidget.
	// As a result of these things being added, you will be able to do
	//     w = new MyContactCard(); w.name = "Johnny"; 
	//  It will automatically add the field "name" and "email" to the MyContactCard class,
	//  and they will be strings.  If you want to do something custom, don't define the $variable
	//  in the template, and none of those setters will be generated.  You can then set up your
	//  own interactions and tweak them perfectly as you would like.
	// The way the variables work here is meant for relatively static initialisation, using just 
	//  a few strings etc.  The "DataWidget" works differently - the way they integrate is different.






Data Widgets

 * Introduction (what, why?)
 * Templating / variable interpolation
 	* Basic setup (defining classes, templates, setting variables etc)
 	* Text Nodes
 		* Variables
 		* Properties
 		* Methods
 		* Haxe Expressions
 	* Attributes
 		* Variables, properties etc
 		* ^^ Boolean attributes
 		* Expressions (<p class="${isRed?'red':'blue'}">)
 	* ^^ "if" Blocks
 		* ^^ Purpose, example
 		* ^^ Setting up
 			* ^^ <div if="showContent">Inline Content</div>
 			* ^^ <div if="showContent" partial="SomePartial"></div>
 		* ^^ Else <div if="showContent" partial="TruePartial" else="FalsePartial"></div>
 	* "^^ for" Blocks
 		* ^^ Purpose, example
 		* ^^ How to set it up, pass variables
 			* ^^ Using inline template
 			* ^^ Using partial
 		* ^^ Else <div for="item in list" partial="ListItemPartial" else="NoItemsPartial">
 * Data Objects
 	* What is supported (basic class objects, properties)
 	* Supporting more complex property types
 		* toString()
 		* ^^ Using partials for custom templates

    //
    // DataWidgets must be defined explicitly (a class, no in-file partials)
    // From a view, they should be called like this:

    <dtx:MyContactCard value="$jason" /> 
    <dtx:SomeEmailView value="${inbox.message(id)}" /> 

    // From a class, like this:

    var jason = new Contact();
    var dw = new MyContactCard(jason);

    // There is no ability for the declaration to pass other "static" 
    //   variables (name, email etc in the examples above) through
    //   like with normal widgets - you can only pass a "value" variable,
    //   that matches the data type of the DataWidget.
    // The way this is implemented currently should be close enough, with one addition:
    //
    // When passing the template:
        * Search for <dtx:MyContactCard value="$jason" />
          * Determine if it is a normal widget or a data widget.  
              If normal, do as above.
              If data:
                var dw = new MyContactCard(jason);
	            widget.insertThisBefore(includeXml);
	            includeXml.removeThisChild();

	//
	// Get these working, and then go on to do if blocks and for blocks
	//

	WIDGET TESTS:
	* generatePartialWithinFile 
		// does it create a class?  
		// does it get left out of the template?
	* includePartialInSameFile
		// does it get included
	* includePartialInSamePackage
		// does it get included
	* includePartialFromFullyQualifiedName
		// does it get included
	* includePartialMultipleTimes
		// does it work?
	* callInlinePartialFromCode
		// does it exist?  If it can be done, we should document that.
	* variablesNotSet
		// there are variables, but we don't set them.  They should be blank.
	* variablesSet
		// does it work?
	* variableUpdate
		// does it stay in a good state?  Does the DOM stay the same (changed attributes, event handlers etc)
	* noVariables
		// if there are no $variables in the template, does it generate a standard template?  
		// can we add that stuff ourselves, custom setters etc.  

	DATA WIDGET TESTS:
	* baseTemplate
		// no $signs left in it?  Good 'blank state'
	* parsedNull
		// stays in blank state
	* setObject
		// does it work
	* updateObject
		// does it break DOM at all? (event handlers, etc)


	* various tests for complex item types
		* date
		* int/float
		* class types
	  each of these could call a separate partial
	  		<dtx:DateAsClockWidget date=$myDate>
	  		<dtx:CounterWidget value=$someFloat>
	  or for complex types
	  		<dtx:ContactCard value=${my.person}>
	* various tests for arrays/lists/hash etc
		again, could be NormalWidget or DataWidget partials.





