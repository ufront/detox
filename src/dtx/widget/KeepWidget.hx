package dtx.widget;

/**
	A special kind of widget that is marked with @:keepSub, so that DCE is not applied.

	This is especially useful if your widget is created through reflection, that is, you don't explicitly call `new MyWidget()`.

	An example is with WidgetLoops - your loop item may get DCE'd because it is only ever called through reflection, which can break things at runtime.

	The workaround is to use `extend KeepWidget` instead of `extend Widget`.

	Other than adding `@:keep`, this is identical to Widget.
**/
@:keepSub @:skipTemplating
class KeepWidget extends Widget {}