package akaifirehx.midi;

@:structInit
class PortConfig {
	public var portName:String;
	public var portNumber:Int;
}

interface IPortOut {
	public function sendCC(bytes2and3:Array<Int>):Void;
	public function sendNRPN(bytes2and3:Array<Int>):Void;
	public function sendSysEx(innerBytes:Array<Int>):Void;
	public function closePort():Void;
}
