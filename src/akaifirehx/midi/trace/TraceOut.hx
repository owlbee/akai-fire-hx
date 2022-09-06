package akaifirehx.midi.trace;

import akaifirehx.midi.Ports;

class TraceOut implements IPortOut{
	public function new(config:PortConfig, onConnected:(device:TraceOut) -> Void) {}

	public function sendCC(bytes2and3:Array<Int>):Void {
		trace('sendCC $bytes2and3');
	}
	
	public function sendNRPN(bytes2and3:Array<Int>):Void {
		trace('sendNRPN $bytes2and3');
	}
	
	public function sendSysEx(innerBytes:Array<Int>):Void {
		trace('sendSysEx $innerBytes');
	}

	public function closePort():Void {
		trace('closePort');
	}
}