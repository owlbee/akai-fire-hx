package akaifirehx.grig;

import akaifirehx.fire.EventsOut;

@:structInit
class PortConfig{
	public var portName:String;
	public var portNumber:Int;
}

class MidiDevice {
	var input:Input;
	var output:Output;

	public function new(inPort:PortConfig, outPort:PortConfig) {
		input = new Input(inPort.portName, inPort.portNumber);
		output = new Output(outPort.portName, outPort.portNumber);
	}

	public function sendMessage(event:AkaiFireEventOut) {
		output.sendMessage(event);
	}
}
