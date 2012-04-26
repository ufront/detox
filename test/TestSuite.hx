import massive.munit.TestSuite;

import AnimationTest;
import DOMManipulationTest;
import CollectionTraversingTest;
import CollectionTest;
import StyleTest;
import ToolsTest;
import CollectionDOMManipulationTest;
import CollectionStyleTest;
import TraversingTest;
import EventManagementTest;
import CollectionAnimationTest;
import CollectionElementManipulationTest;
import CollectionEventManagementTest;
import ElementManipulationTest;

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
		add(DOMManipulationTest);
		add(CollectionTraversingTest);
		add(CollectionTest);
		add(StyleTest);
		add(ToolsTest);
		add(CollectionDOMManipulationTest);
		add(CollectionStyleTest);
		add(TraversingTest);
		add(EventManagementTest);
		add(CollectionAnimationTest);
		add(CollectionElementManipulationTest);
		add(CollectionEventManagementTest);
		add(ElementManipulationTest);
	}
}
