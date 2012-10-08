package dtx.widget;

class WidgetLoop<T> extends dtx.widget.Loop<T>
{
	var widgetClass:Class<dtx.widget.Widget>;
	var propName:String;

	public function new(widgetClass:Class<dtx.widget.Widget>, propName:String)
	{
		super();
		this.widgetClass = widgetClass;
		this.propName = propName;
	}

	override function generateItem(input:T):DOMCollection
	{
		var w = Type.createInstance(widgetClass, []);
		w.setProperty(w, propName, input);
		return w;
	}
}