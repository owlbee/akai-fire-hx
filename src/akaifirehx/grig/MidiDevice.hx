package akaifirehx.grig;

import akaifirehx.fire.Events;

@:structInit
class PortConfig {
	public var portName:String;
	public var portNumber:Int;
}

class MidiDevice {
	public var input(default, null):Input;
	public var output(default, null):Output;
	public var events(default, null):InputEvents;
	
	public function new(inPort:PortConfig, outPort:PortConfig) {
		events = new InputEvents();
		input = new Input(inPort.portName, inPort.portNumber, events);
		output = new Output(outPort.portName, outPort.portNumber);
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
