package akaifirehx.midi;

import akaifirehx.midi.Input;
import akaifirehx.midi.Output;
import akaifirehx.midi.Ports;
import akaifirehx.fire.Events;

class AkaiFireMidi {
	public var input(default, null):Input;
	public var output(default, null):Output;
	public var events(default, null):InputEvents;

	public function new(inPort:PortConfig, outPort:PortConfig) {
		events = new InputEvents();
		input = new Input(inPort, events);
		output = new Output(outPort);
		if(isReady()){
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

	public function closePorts() {
		input.closePort();
		output.closePort();
	}
}
