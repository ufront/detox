import massive.munit.TestSuite;

import AnimationTest;
import CollectionAnimationTest;
import ElementManipulationTest;
import StyleTest;
import CollectionStyleTest;
import TraversingTest;
import DOMManipulationTest;
import CollectionEventManagementTest;
import LoopTest;
import EventManagementTest;
import CollectionElementManipulationTest;
import CollectionTraversingTest;
import ToolsTest;
import CollectionTest;
import CollectionDOMManipulationTest;
import WidgetTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(AnimationTest);
		add(CollectionAnimationTest);
		add(ElementManipulationTest);
		add(StyleTest);
		add(CollectionStyleTest);
		add(TraversingTest);
		add(DOMManipulationTest);
		add(CollectionEventManagementTest);
		add(LoopTest);
		add(EventManagementTest);
		add(CollectionElementManipulationTest);
		add(CollectionTraversingTest);
		add(ToolsTest);
		add(CollectionTest);
		add(CollectionDOMManipulationTest);
		add(WidgetTest);
	}
}
