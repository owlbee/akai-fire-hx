package test;

import utest.ui.Report;
import utest.Runner;

import test.SysExTests;
import test.OledCanvasTests;

class RunTests {
	public static function main() {
		var runner = new Runner();
		runner.addCase(new SysExColorTests());
		runner.addCase(new SysExSetPadStateTests());
		runner.addCase(new SysExSetOledStateTests());
		
		runner.addCase(new OledCanvasTests());
		Report.create(runner);
		runner.run();
	}
}
