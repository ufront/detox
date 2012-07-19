package dtx.widget;

@template("<div></div>") 
class DataWidget<T> extends Widget
{
	public function new(data:T)
	{
		super(get_template());
	}
}