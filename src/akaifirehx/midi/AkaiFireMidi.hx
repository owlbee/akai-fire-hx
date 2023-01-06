package akaifirehx.midi;

import akaifirehx.fire.display.Canvas;
import akaifirehx.fire.Control;
import akaifirehx.fire.Events;
import akaifirehx.midi.Input;
import akaifirehx.midi.Output;
import akaifirehx.midi.Ports;

class AkaiFireMidi {
	var input(default, null):Input;
	var output(default, null):Output;

	public var events(default, null):InputEvents;

	public function new(inPort:PortConfig, outPort:PortConfig, canvas:PixelCanvas) {
		events = new InputEvents();
		input = new Input(inPort, events);
		output = new Output(outPort, canvas);
		if (isReady()) {
			trace('AkaiFireMidi ready!');
			output.initDisplay();
			output.initIllumination();
		}
	}

	public function sendMessage(event:AkaiFireEventOut) {
		output.sendMessage(event);
	}

	public function isReady():Bool {
		return input.isReady && output.isReady;
	}

	public function isDownPad(padIndex:Int) {
		return input.isDownPad[padIndex];
	}

	public function isDownButton(button:Button) {
		return input.isDownButton[button];
	}

	public function isDownEncoder(encoder:EncoderTouch) {
		return input.isDownEncoder[encoder];
	}

	public function closePorts() {
		input.closePort();
		output.closePort();
	}

	inline function shutDown(){
		output.sendMessage(LedGlobalIllumination(false));
		output.sendMessage(DisplayClear(false));
		output.sendMessage(DisplaySetText("bye!", 0, 0, false));
		output.sendMessage(DisplayShow);
		closePorts();
		Sys.exit(0);
	}

	public function update() {
		var isShutdownSequenceHeld = isDownButton(STEP) && isDownButton(NOTE) && isDownButton(REC);
		if(isShutdownSequenceHeld) shutDown();
	}
}
