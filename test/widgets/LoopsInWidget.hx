package widgets;

import dtx.widget.KeepWidget;
import dtx.widget.Widget;
using Detox;

@:template("
	<h3>Names:</h3>
	<ul>
		<dtx:loop partial='NumberLI' for='number in [1,2,3,4,5]'></dtx:loop>
	</ul>
")
class LoopInlineArrayWithImportedPartial extends Widget {}

@:template("
	<h3>Names:</h3>
	<ul>
		<dtx:loop partial='_Item' for='number in [1,2,3,4,5]'></dtx:loop>
	</ul>
	<_Item keep='true'>
		<li>Relative $number</li>
	</_Item>
")
class LoopInlineArrayWithRelativePartial extends Widget {}

@:template("
	<h3>Names:</h3>
	<ul>
		<dtx:loop for='number in [1,2,3,4,5]'>
			<li>Inline $number</li>
		</dtx:loop>
	</ul>
")
class LoopInlineArrayWithInlinePartial extends Widget {}

@:template("
	<h3>Names:</h3>
	<ul>
		<dtx:loop for='number in 0...3'>
			<li>IntIter $number</li>
		</dtx:loop>
	</ul>
")
class LoopUsingInlineIterator extends Widget {}

@:template("
	<h3>Names:</h3>
	<ul>
		<dtx:loop for='name in people.keys()'>
			<li class='${name.toLowerCase()}'>Map Key $name</li>
		</dtx:loop>
	</ul>
")
class LoopUsingMemberIterator extends Widget 
{
	public var people:haxe.ds.StringMap<Int>;
	public function new()
	{
		super();
		people = [
			"Jason" => 1,
			"Anna" => 2
		];
	}
}

@:template("
	<h3>Names:</h3>
	<ul>
		<dtx:loop for='number in [1,2,3,4,5]'>
			<li>Inline $number</li>
		</dtx:loop>
	</ul>
")
class LoopMemberArray extends Widget {}

@:template("
	<h3>Names:</h3>
	<ul>
		<dtx:loop for='name in [\"Jason\", \"Clare\", \"Aaron\"]' dtx-name='myLoop'>
			<li>Inline Named $name</li>
		</dtx:loop>
	</ul>
")
class InlineNamedPartial extends Widget {}



@:template("
	<h3>Names:</h3>
	<ul>
		<dtx:loop for='number in memberArray'>
			<li>Member Iter $number</li>
		</dtx:loop>
	</ul>
")
class LoopFromMemberVariable extends Widget 
{
	public var memberArray:Array<Float>;
	public function new() {
		super();
		memberArray = [0.0, 0.1, 0.2];
	}
}

@:template("
	<h3>Names:</h3>
	<ul>
		<dtx:loop for='number in Lambda.concat([0,1,2], memberArray)'>
			<li>Complex Iter Expr $number</li>
		</dtx:loop>
	</ul>
")
class LoopFromComplexExpr extends Widget
{
	public var memberArray:Array<Int>;
	public function new() {
		super();
		memberArray = [4,5,6];
	}
}

@:template("<li>Defined $number</li>")
class NumberLI extends KeepWidget {}

@:template("<p>My name is $name, I am $age years old and it is $isTall that I am tall</p>")
class LoopsInWidget extends Widget 
{
	public var name = "Jason";
	public var age = 26;
	public var isTall = true;
}