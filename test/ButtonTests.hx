package test;

import akaifirehx.fire.Leds;
import utest.Assert;
import utest.Test;

class LedTests extends Test {
	function test_countDefined_SingleColorLeds() {
		var buttons = new Leds();
		var totalDefined = 0;
		
		@:privateAccess
		for(k in buttons.singleColorLeds.keys()){
			totalDefined++;
		}
		
		var expected = 11;
		Assert.same(expected, totalDefined);
	}

	function test_countDefined_MultiColorLeds() {
		var buttons = new Leds();
		var totalDefined = 0;
		
		@:privateAccess
		for(k in buttons.multiColorLeds.keys()){
			totalDefined++;
		}
		
		var expected = 8;
		Assert.same(expected, totalDefined);
	}
}
