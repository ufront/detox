package dtx.widget;

class ChildWidgetLoop<P:Widget, T, W:ChildWidget<P>> extends WidgetLoop<T,W>
{
    public function new(parentWidget:P, widgetClass:Class<W>, ?propName:String = null, ?autoMapData = false)
    {
        super(widgetClass,propName,autoMapData);
        this.constructorArgs.push(parentWidget);
    }
}
