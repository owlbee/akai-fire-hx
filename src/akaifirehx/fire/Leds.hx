package akaifirehx.fire;

class Leds {
	var singleColorLeds:Map<SingleColorLed, Led<SingleColorState>>;
	var yellowColorLeds:Map<YellowColorLed, Led<YellowColorState>>;
	var multiColorLeds:Map<MultiColorLed, MultiColorState>;
	public function new() {
		singleColorLeds = [
			BROWSER => {
				state: OFF,
				color: RED
			},
			PATUP => {
				state: OFF,
				color: RED
			},
			PATDOWN => {
				state: OFF,
				color: RED
			},
			GRIDLEFT => {
				state: OFF,
				color: RED
			},
			GRIDRIGHT => {
				state: OFF,
				color: RED
			},
			ALT => {
				state: OFF,
				color: YELLOW
			},
			STOP => {
				state: OFF,
				color: YELLOW
			},
			SOLO1 => {
				state: OFF,
				color: GREEN
			},
			SOLO2 => {
				state: OFF,
				color: GREEN
			},
			SOLO3 => {
				state: OFF,
				color: GREEN
			},
			SOLO4 => {
				state: OFF,
				color: GREEN
			}
		];

		yellowColorLeds = [
			STEP => {
				state: OFF,
				color: RED
			},
			NOTE => {
				state: OFF,
				color: RED
			},
			DRUM => {
				state: OFF,
				color: RED
			},
			PERFORM => {
				state: OFF,
				color: RED
			},
			SHIFT => {
				state: OFF,
				color: RED
			},
			REC => {
				state: OFF,
				color: RED
			},
			PATTERN => {
				state: OFF,
				color: GREEN
			},
			PLAY => {
				state: OFF,
				color: GREEN
			}
		];

		multiColorLeds = [
			TRACK1 => OFF,
			TRACK2 => OFF,
			TRACK3 => OFF,
			TRACK4 => OFF,
		];
	}

	public function setSingle(id:SingleColorLed, state:SingleColorState) {
		singleColorLeds[id].state = state;
	}

	public function getSingleColorCcBytes(id:SingleColorLed):Array<Int> {
		return [
			id,
			singleColorLeds[id].state
		];
	}

	public function setYellow(id:YellowColorLed, state:YellowColorState) {
		yellowColorLeds[id].state = state;
	}

	public function getYellowColorCcBytes(id:YellowColorLed):Array<Int> {
		return [
			id,
			yellowColorLeds[id].state
		];
	}

	public function setMulti(id:MultiColorLed, state:MultiColorState) {
		multiColorLeds[id] = state;
	}

	public function getMultiColorCcBytes(id:MultiColorLed):Array<Int> {
		return [
			id,
			multiColorLeds[id]
		];
	}
}

@:structInit
class Led<ColorState> {
	public var color:LedColor;
	public var state:ColorState;
}

@:enum
abstract SingleColorLed(Int) from Int to Int {
	// red
	var BROWSER = 0x21;
	var PATUP = 0x1f;
	var PATDOWN = 0x20;
	var GRIDLEFT = 0x22;
	var GRIDRIGHT = 0x23;
	// yellow
	var ALT = 0x31;
	var STOP = 0x34;
	// green
	var SOLO1 = 0x24;
	var SOLO2 = 0x25;
	var SOLO3 = 0x26;
	var SOLO4 = 0x27;
}

@:enum
abstract YellowColorLed(Int) from Int to Int {
	// red
	var STEP = 0x2c;
	var NOTE = 0x2d;
	var DRUM = 0x2e;
	var PERFORM = 0x2f;
	var SHIFT = 0x30;
	var REC = 0x35;
	// green
	var PATTERN = 0x32;
	var PLAY = 0x33;
}


@:enum
abstract MultiColorLed(Int) from Int to Int {
	var TRACK1 = 0x28; 
	var TRACK2 = 0x29; 
	var TRACK3 = 0x2A; 
	var TRACK4 = 0x2B; 
}

enum LedColor {
	RED;
	YELLOW;
	GREEN;
}

@:enum
abstract SingleColorState(Int) from Int to Int{
	var OFF = 0;
	var LOW = 1;
	var HIGH = 2;
}

@:enum
abstract YellowColorState(Int) from Int to Int{
	var OFF = 0;
	var COLOR_LOW = 1;
	var YELLOW_LOW = 2;
	var COLOR_HIGH = 3;
	var YELLOW_HIGH = 4;
}

@:enum
abstract MultiColorState(Int) from Int to Int{
	var OFF = 0;
	var RED_LOW = 1;
	var GREEN_LOW = 2;
	var RED_HIGH = 3;
	var GREEN_HIGH = 4;
}
