package dtx.layout;

using Detox;

interface IDetoxLayout
{
	#if !macro
		/** Updating the title will update the `<title>` element on the page **/
		public var title(default,set):String;

		/** This is a contentContainer that you can empty and fill with new content **/
		public var contentContainer(get,null):DOMNode;

		/** This is the `<html>` element or the document node.  Used as a workaround until we have a toHtml() method... that we can have in the interface **/
		public var document(get,null):DOMNode;

		/** This is the `<head>` element on the page.  We append stylesheets to this. **/
		public var head(get,null):DOMNode;

		/** This is the `<body>` element on the page.  We insert our scripts _after_ this element. **/
		public var body(get,null):DOMNode;
	#end
}

@:template("<html dtx-name='document'>
	<head dtx-name='head'>
		<title>$title</title>
	</head>
	<body dtx-name='body'>
		<h1>$title</h1>
		<div dtx-name='contentContainer'></div>
	</body>
</html>")
class DefaultDetoxLayout extends dtx.widget.Widget implements IDetoxLayout {}