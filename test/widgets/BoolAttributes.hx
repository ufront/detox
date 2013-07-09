package widgets;

import dtx.widget.Widget;

// dtx-enabled
// dtx-disabled
// dtx-checked
// dtx-unchecked
// dtx-class-*

@:template("<div>
	<p dtx-name='alwaysShow' dtx-show='true'>Always Show</p>
	<p dtx-name='alwaysHide' dtx-hide='true'>Always Hide</p>
	<p dtx-name='neverShow' dtx-show='false'>Never Show</p>
	<p dtx-name='neverHide' dtx-hide='false'>Never Hide</p>
	<p dtx-name='showIfSomeFlag' dtx-show='someFlag'>Show if 'someFlag==true'</p>
	<p dtx-name='hideIfSomeFlag' dtx-hide='someFlag'>Hide if 'someFlag==true'</p>
	<p dtx-name='showIfSomeString' dtx-show='someString.length>0'>Show if 'someString.length>0'</p>
	<p dtx-name='hideIfSomeString' dtx-hide='someString.length>0'>Hide if 'someString.length>0'</p>
</div>")
class ShowHideBasic extends Widget {
	public var someFlag:Bool = true;
	public var someString:String = "";
}
