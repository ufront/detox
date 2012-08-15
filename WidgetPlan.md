### Initial HTML

    "<div data-as='p'>
        <h3>$p.name</h3>
        <span>$p.phone</span>
        <span><a href="$p.url">$p.url</a></span>
        <span><a href="mailto:$p.email">$p.email</a></span>
        <span>${DateTools.format(p.dob,"some format")}</span>
        <ul data-loop="$item in $p.items">
            <li>$item.name: $item.detail</li>
        </ul>
    </div>"; 

    OR

    ### Follow Angular JS Example
    ### http://angularjs.org/

    "<div data-as='p'>
        <h3>$p.name</h3>
        <span>$p.phone</span>
        <span><a href="$p.url">$p.url</a></span>
        <span><a href="mailto:$p.email">$p.email</a></span>
        <span>${DateTools.format(p.dob,"some format")}</span>
        <ul>
            <dtx-partial data-loop="item in items">
              <li>$item.name: $item.detail</li>
            </dtx-partial>
        </ul>
        <ul>
            <dtx-partial data-loop="item in items">
              <li>$name: $detail</li>
            </dtx-partial>
        </ul>
        <dtx-partial data-object="person">
          $name, $email
        </dtx-partial>
        <dtx-partial data-object="person as p">
          $name, $email
        </dtx-partial>
    </div>"; 

### MACRO PSEUDOCODE
    
    - create the "override function bind()"
    - load HTML
    - parse as XML
      - extract "data-as" to set up local variable
    - for each loop
      - if not set, set attr(data-loop-id, t); t++;
      - take HTML, and create a new subwidget (as a class? or use a factory? eg PersonWidget.newLoop(1))
      - get the type parameter (T) of the Iterable.  eg String in Array<String>
      - create a class for the subwidget, take html
      - recurse on this macro for the subwidget.
    - for each attribute, text node
      - search for "$" (but not "$$")
      - if found
          - if not set, set attr(data-bind, i); i++;
          - do string interpolation using modified Std.format(), get ("mailto:" + email)
          - add binding to bind(), using find([data-bind=i]) and setAttr() or setText()
    - add in the static HTML for the widget

### CLASS should look like

class PersonWidget extends DataWidget
{   
    html = '<div>
        <h3 data-bind="1">$p.name</h3>
        <span data-bind="2">$p.phone</span>
        <span><a href="$p.url" data-bind="3">$p.url</a></span>
        <span><a href="mailto:$p.email" data-bind="4">$p.email</a></span>
        <span data-bind="5">${DateTools.format(p.dob,"some format")}</span>
        <ul data-loop-id="1">
        </ul>
    </div>';

    override function bind(data:T)
    {
        // Set up local variables
        var p = data;
        var loopContainer = new Array<Node>();

        // Bindings by macro
        this.find("[data-bind=1]").setText(p.name);
        this.find("[data-bind=2]").setText(p.phone);
        this.find("[data-bind=3]").setText(p.url);
        this.find("[data-bind=3]").setAttr(p.url);
        this.find("[data-bind=4]").setText("mailto:" + p.email);
        this.find("[data-bind=4]").setAttr("mailto:" + p.email);
        this.find("[data-bind=5]").setText(DateTools.format(p.dob);

        // For each loop in the template, find the container
        var loopContainer[1] = this.find([data-loop-id=1]);
        for (item in p.items)
        {
            // Create a sub widget for each item, add to the container
            loopContainer[1].append(new PersonWidget_loop1(item));
        }
    }
}

### And also a class for any loops

class PersonWidget_loop1<{name, detail}> extends DataWidget<T>
{
    html = "<li data-bind="1">$item.name: $item.detail</li>";

    override function bind(data:T)
    {
        // Set up local variables
        var item = data;

        // Bindings by macro
        this.find("[data-bind=1]").setText(item.name + ": " + item.detail);
    }
}

### Usage

    @template("PersonWidget.html") class PersonWidget extends DataWidget<Person> {}
    @template("ItemWidget.html") class ItemWidget extends DataWidget<Item> {}

    var p = new PersonWidget(myPerson);

### Still to consider

 * Partial support, to import another widget/template (both once off and in loops)
 * Event bindings (bind click to action etc).  These could be done purely through the class:

       @template("ItemWidget.html") class ItemWidget extends DataWidget<Item> 
       {
           override public function setupInteraction()
           {
               this.find('.btn-primary').click(function () {
                   this.reload();
               })
           }
       }

   Or you could use some code in the template:

       <a class="btn" data-action="reload()">Button</a>
       <a class="btn" data-action="Client.loadPage('http://google.com/')">Button</a>