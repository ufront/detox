import utest.Assert;
import utest.Runner;
import utest.ui.Report;
import ToolsTest;

class UTest {
    public static function main() 
    {
        haxe.Log.trace = haxe.Firebug.trace;
        
        js.Lib.window.onload = function (e) {
            var runner = new Runner();
            runner.addCase(new ToolsTest());
            Report.create(runner);
            runner.run();
        }
        
    }
}