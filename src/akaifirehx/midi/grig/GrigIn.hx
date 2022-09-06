package akaifirehx.midi.grig;

import akaifirehx.midi.Ports;
import grig.midi.MidiMessage;
import grig.midi.MidiIn;

class GrigIn {
	var midiIn:MidiIn;
	public var isReady:Bool;

	public function new(config:PortConfig, onConnected:(device:GrigIn) -> Void, onMidiMessage:(midiMessage:MidiMessage, delta:Float) -> Void) {
		midiIn = new MidiIn(grig.midi.Api.Unspecified);
		midiIn.setCallback(onMidiMessage);
		midiIn.getPorts().handle(function(outcome) {
			switch outcome {
				case Success(ports):
					midiIn.openPort(config.portNumber, config.portName).handle(function(midiIncome) {
						switch midiIncome {
							case Success(_):
								isReady = true;
								onConnected(this);
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
		midiIn.closePort();
	}
}
