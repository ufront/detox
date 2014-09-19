package dtx.widget;

/**
    A widget that is designed to always sit inside a parent.

    It requires a `parent` widget to be specified in the constructor, and this is then available as the `parent` property.

    This is useful if you need to access parent properties or variables from a child widget.

    Please note this extends `KeepWidget`, so ChildWidget classes will not be elimnated by DCE.
**/
@:skipTemplating
class ChildWidget<T:Widget> extends KeepWidget {

    /**
        The parent widget which this belongs to.
        Please note that the setter for this does not move the widget's position in the DOM.
        The only effect of setting `parent` to a different value is that this field changes, and any variables / interpolation in a sub-widget that references the parent will be triggered.
    **/
    public var parent(default,set):T;

    public function new(parent:T) {
        super();
        this.parent = parent;
    }

    function set_parent(p:T):T {
        return this.parent = p;
    }
}
