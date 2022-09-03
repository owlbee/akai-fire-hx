package akaifirehx.fire;

class Leds {
	var singleColorLeds:Map<SingleColorLed, SingleColorState>;
	var yellowColorLeds:Map<YellowColorLed, YellowColorState>;
	var multiColorLeds:Map<MultiColorLed, MultiColorState>;
	var encodeModeLed:EncoderModeState;

	public function new() {
		singleColorLeds = [
			BROWSER => OFF,
			PATUP => OFF,
			PATDOWN => OFF,
			GRIDLEFT => OFF,
			GRIDRIGHT => OFF,
			ALT => OFF,
			STOP => OFF,
			TRACK1 => OFF,
			TRACK2 => OFF,
			TRACK3 => OFF,
			TRACK4 => OFF
		];

		yellowColorLeds = [
			STEP => OFF,
			NOTE => OFF,
			DRUM => OFF,
			PERFORM => OFF,
			SHIFT => OFF,
			REC => OFF,
			PATTERN => OFF,
			PLAY => OFF
		];

		multiColorLeds = [
			TRACK1 => OFF,
			TRACK2 => OFF,
			TRACK3 => OFF,
			TRACK4 => OFF,
		];

		encodeModeLed = ALL_OFF;
	}

	public function setSingle(id:SingleColorLed, state:SingleColorState) {
		singleColorLeds[id] = state;
	}

	public function getSingleColorCcBytes(id:SingleColorLed):Array<Int> {
		return [
			id,
			singleColorLeds[id]
		];
	}

	public function setYellow(id:YellowColorLed, state:YellowColorState) {
		yellowColorLeds[id] = state;
	}

	public function getYellowColorCcBytes(id:YellowColorLed):Array<Int> {
		return [
			id,
			yellowColorLeds[id]
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

	public function setEncoderMode(state:EncoderModeState) {
		encodeModeLed = state;
	}

	public function getEncodeModeCcBytes():Array<Int> {
		return [
			0x1b,
			encodeModeLed
		];
	}

	public function getGlobalIllumuniationCcBytes(isOn:Bool){
		return [
			127,
			isOn ? 1 : 0
		];
	}
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
	var TRACK1 = 0x24;
	var TRACK2 = 0x25;
	var TRACK3 = 0x26;
	var TRACK4 = 0x27;
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

@:enum
abstract EncoderModeState(Int) from Int to Int{
	var ALL_OFF = 0x10;
	var ALL_ON = 0x1F;
	var CHANNEL_ONLY = 0x11;
	var MIXER_ONLY = 0x12;
	var CHANNEL_AND_MIXER = 0x13;
	var USER_1_ONLY = 0x03;
	var USER_2_ONLY = 0x04;
}