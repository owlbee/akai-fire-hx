import akaifirehx.fire.SysEx;
import utest.Assert;
import utest.Test;

class SysExColorTests extends Test {
	function test_extractRed() {
		var rgb = 0xff0000;
		Assert.same(0x7f, sysex_red(rgb));
	}

	function test_extractGreen() {
		var rgb = 0x00ff00;
		Assert.same(0x7f, sysex_green(rgb));
	}

	function test_extractBlue() {
		var rgb = 0x0000ff;
		Assert.same(0x7f, sysex_blue(rgb));
	}
}

class SysExSetPadStateTests extends Test {
    function test_innerBytes_SinglePadColor(){
        var expected =  [71, 127, 67, 101, 0, 4, 
            34, 0, 0, 127
        ];

        var rgb = 0x0000ff;
        var x = 2;
        var y = 2;
        
        Assert.same(expected, PadSysExMessages.singlePadColor(rgb, x, y));
    }

    function test_innerBytes_RegionPadColor(){
        // testing for 8 x 8 region of pads from 10th column, 2nd row to 0x22ff99
        // note that from this position the region can actually only be 7 x 3 in size, the expected message bytes reflect that
        
        var expected = [71, 127, 67, 101, 0, 84, 
            25, 17, 127, 76, 
            41, 17, 127, 76, 
            57, 17, 127, 76, 
            26, 17, 127, 76, 
            42, 17, 127, 76, 
            58, 17, 127, 76, 
            27, 17, 127, 76, 
            43, 17, 127, 76, 
            59, 17, 127, 76, 
            28, 17, 127, 76, 
            44, 17, 127, 76, 
            60, 17, 127, 76, 
            29, 17, 127, 76, 
            45, 17, 127, 76, 
            61, 17, 127, 76, 
            30, 17, 127, 76, 
            46, 17, 127, 76, 
            62, 17, 127, 76, 
            31, 17, 127, 76, 
            47, 17, 127, 76, 
            63, 17, 127, 76
        ];

        var rgb = 0x22ff99;
        var x = 9;
        var y = 1;
        var width = 8;
        var height = 8;
        
        Assert.same(expected, PadSysExMessages.regionPadColor(rgb, x, y, width, height));
    }

    function test_innerBytes_AllPadColor(){
        var expected = [71, 127, 67, 101, 2, 0, 
            0, 118, 34, 119, 
            1, 118, 34, 119, 
            2, 118, 34, 119, 
            3, 118, 34, 119, 
            4, 118, 34, 119, 
            5, 118, 34, 119, 
            6, 118, 34, 119, 
            7, 118, 34, 119, 
            8, 118, 34, 119, 
            9, 118, 34, 119, 
            10, 118, 34, 119, 
            11, 118, 34, 119, 
            12, 118, 34, 119, 
            13, 118, 34, 119, 
            14, 118, 34, 119, 
            15, 118, 34, 119, 
            16, 118, 34, 119, 
            17, 118, 34, 119, 
            18, 118, 34, 119, 
            19, 118, 34, 119, 
            20, 118, 34, 119, 
            21, 118, 34, 119, 
            22, 118, 34, 119, 
            23, 118, 34, 119, 
            24, 118, 34, 119, 
            25, 118, 34, 119, 
            26, 118, 34, 119, 
            27, 118, 34, 119, 
            28, 118, 34, 119, 
            29, 118, 34, 119, 
            30, 118, 34, 119, 
            31, 118, 34, 119, 
            32, 118, 34, 119, 
            33, 118, 34, 119, 
            34, 118, 34, 119, 
            35, 118, 34, 119, 
            36, 118, 34, 119, 
            37, 118, 34, 119, 
            38, 118, 34, 119, 
            39, 118, 34, 119, 
            40, 118, 34, 119, 
            41, 118, 34, 119, 
            42, 118, 34, 119, 
            43, 118, 34, 119, 
            44, 118, 34, 119, 
            45, 118, 34, 119, 
            46, 118, 34, 119, 
            47, 118, 34, 119, 
            48, 118, 34, 119, 
            49, 118, 34, 119, 
            50, 118, 34, 119, 
            51, 118, 34, 119, 
            52, 118, 34, 119, 
            53, 118, 34, 119, 
            54, 118, 34, 119, 
            55, 118, 34, 119, 
            56, 118, 34, 119, 
            57, 118, 34, 119, 
            58, 118, 34, 119, 
            59, 118, 34, 119, 
            60, 118, 34, 119, 
            61, 118, 34, 119, 
            62, 118, 34, 119, 
            63, 118, 34, 119
        ];

        var rgb = 0xec45ee;

        Assert.same(expected, PadSysExMessages.allPadColor(rgb));
    }
}