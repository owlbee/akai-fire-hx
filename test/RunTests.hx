package test;

import SysExTests;
import utest.ui.Report;
import utest.Runner;

class RunTests {
    public static function main() {
        var runner = new Runner();
        runner.addCase(new SysExColorTests());
        runner.addCase(new SysExSetPadStateTests());
        runner.addCase(new SysExSetOledStateTests());
        runner.addCase(new OledDisplayTests());
        Report.create(runner);
        runner.run();
      }
}
