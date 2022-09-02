package akaifirehx.fire;

@:enum
abstract Action(Int) from Int to Int {
	var PRESS = 144;
	var RELEASE = 128;
	var MOVE = 176;
}

@:enum
abstract Encoder(Int) from Int to Int {
	var VOLUME = 16;
	var PAN = 17;
	var FILTER = 18;
	var RESONANCE = 19;
	var SELECT = 118;
}

@:enum
abstract Button(Int) from Int to Int {
	var VOLUME = 16;
	var PAN = 17;
	var FILTER = 18;
	var RESONANCE = 19;
	var SELECT = 25;

    var BROWSER = 0x21;
	var PATUP = 0x1f;
	var PATDOWN = 0x20;
	var GRIDLEFT = 0x22;
	var GRIDRIGHT = 0x23;
	var ALT = 0x31;
	var STOP = 0x34;
	var SOLO1 = 0x24;
	var SOLO2 = 0x25;
	var SOLO3 = 0x26;
	var SOLO4 = 0x27;

    var STEP = 0x2c;
	var NOTE = 0x2d;
	var DRUM = 0x2e;
	var PERFORM = 0x2f;
	var SHIFT = 0x30;
	var REC = 0x35;
	var PATTERN = 0x32;
	var PLAY = 0x33;

    var ENCODERMODE = 0x1A;
}
