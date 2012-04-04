import massive.munit.TestSuite;

import AnimationTest;
import DOMManipulationTest;
import StyleTest;
import QueryStyleTest;
import ToolsTest;
import QueryTraversingTest;
import TraversingTest;
import EventManagementTest;
import QueryEventManagementTest;
import QueryAnimationTest;
import QueryDOMManipulationTest;
import QueryElementManipulationTest;
import ElementManipulationTest;
import QueryTest;

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
		add(StyleTest);
		add(QueryStyleTest);
		add(ToolsTest);
		add(QueryTraversingTest);
		add(TraversingTest);
		add(EventManagementTest);
		add(QueryEventManagementTest);
		add(QueryAnimationTest);
		add(QueryDOMManipulationTest);
		add(QueryElementManipulationTest);
		add(ElementManipulationTest);
		add(QueryTest);
	}
}
