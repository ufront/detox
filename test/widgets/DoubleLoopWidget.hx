package widgets;

import dtx.widget.Widget;

@:template("
	<table>
		<dtx:loop for='row in 0...10'>
			<tr>
				<dtx:loop for='col in 0...5'>
					<td>${parent.row} $col</td>
				</dtx:loop>
			</tr>
		</dtx:loop>
	</table>
	<div>
	</div>
")
class DoubleLoopWidget extends Widget {
	
}