package widgets;

import dtx.widget.Widget;

@:template("<doc>
	<header dtx-name='head'>This is the head</header>
	<section dtx-name='body'>This is the body</section>
</doc>")
class WidgetWithNamedElements extends Widget { }

@:template("<p dtx-name='paragraph'>Paragraph</p>")
class TopLevelNamedElements1 extends Widget { }

@:template("
<p dtx-name='paragraph'>Paragraph</p>
<div dtx-name='div'>Div</div>
")
class TopLevelNamedElements2 extends Widget { }