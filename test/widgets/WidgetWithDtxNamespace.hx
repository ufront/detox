package widgets;

@template("<doc>
	<header>
		<title>Test Partial</title>
	</header>
	<dtx:_BodyPartial />
</doc>

<_BodyPartial>
	<section>
		<h1>Header</h1>
		<p>Paragraph</p>
	</section>
</_BodyPartial>")
class WidgetWithDtxNamespace extends dtx.widget.Widget { }