package akaifirehx.midi.grig;

import akaifirehx.midi.Ports;
import grig.midi.MidiMessage;
import grig.midi.MidiOut;

class GrigOut implements IPortOut {
	var midiOut:MidiOut;
	var isReady:Bool;

	public function new(config:PortConfig, onConnected:(device:GrigOut) -> Void) {
		midiOut = new MidiOut(grig.midi.Api.Unspecified);
		midiOut.getPorts().handle(function(outcome) {
			switch outcome {
				case Success(ports):
					trace('... \n ports');
					trace(ports);
					midiOut.openPort(config.portNumber, config.portName).handle(function(midiOutcome) {
						switch midiOutcome {
							case Success(_):
								onConnected(this);
								isReady = true;
							case Failure(error):
								trace('error $error');
						}
					});
				case Failure(error):
					trace(error);
			}
		});
	}

	public function closePort() {
		midiOut.closePort();
	}

	public function sendCC(bytes2and3:Array<Int>) {
		if (midiOut == null) {
			trace('whattafuck');
			return;
		}
		// trace(bytes2and3);
		midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, bytes2and3));
	}

	static var nrpn_msb = 99;
	static var nrpn_lsb = 98;
	public function sendNRPN(bytes2and3:Array<Int>) {
		var id_msb:Int = Std.int(bytes2and3[0] / 128);
		var id_lsb:Int = bytes2and3[0] % 128;
		var id = bytes2and3[0];
		var value = bytes2and3[1];
		midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, [nrpn_msb, id_msb]));
		midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, [nrpn_lsb, id_lsb]));
		midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, [6, value]));
		// midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, [38, value]));
	}

	public function sendSysEx(innerBytes:Array<Int>) {
		midiOut.sendMessage(MidiMessage.ofMessageType(SysEx, innerBytes));
	}
}
