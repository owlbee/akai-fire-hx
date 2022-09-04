package akaifirehx.grig;

import akaifirehx.fire.Events;
import akaifirehx.fire.Control;
import akaifirehx.fire.Leds;
import akaifirehx.fire.Display;
import grig.midi.MidiMessage;
import grig.midi.MidiIn;

class Input {
	var midiIn:MidiIn;
	var oled:Display;
	var leds:Leds;
	var events:InputEvents;

	public var isReady(default, null):Bool;

	public function new(portName:String, portNumber:Int, events:InputEvents) {
		this.events = events;
		midiIn = new MidiIn(grig.midi.Api.Unspecified);
		midiIn.setCallback(function(midiMessage:MidiMessage, delta:Float) {
			// trace(midiMessage.toString());
			var action:Action = midiMessage.byte1;
			switch action {
				case MOVE:
					handleEncoderMove(midiMessage.byte2, midiMessage.byte3);
				case PRESS:
					if (midiMessage.byte2 <= 0x19) {
						handleEncoderPress(midiMessage.byte2);
					} else {
						if (midiMessage.byte2 < 0x36) {
							handleButtonPress(midiMessage.byte2);
						} else {
							handlePadPress(midiMessage.byte2);
						}
					}
				case RELEASE:
					if (midiMessage.byte2 <= 0x19) {
						handleEncoderRelease(midiMessage.byte2);
					} else {
						if (midiMessage.byte2 < 0x36) {
							handleButtonRelease(midiMessage.byte2);
						} else {
							handlePadRelease(midiMessage.byte2);
						}
					}
			}
		});
		midiIn.getPorts().handle(function(outcome) {
			switch outcome {
				case Success(ports):
					midiIn.openPort(portNumber, portName).handle(function(midiOutcome) {
						switch midiOutcome {
							case Success(_):
								isReady = true;
								trace('IN -> Akai Fire Connected to $portNumber - $portName');
							case Failure(error):
								trace(error);
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

	inline function handleEncoderMove(encoder:EncoderMove, value:Int) {
		if (value >= 64) {
			events.onEncoderDecrement.dispatch(encoder);
		} else {
			events.onEncoderIncrement.dispatch(encoder);
		}
	}

	inline function handlePadPress(byte2:Int) {
		events.onPadPress.dispatch(byte2 - 0x36);
	}

	inline function handlePadRelease(byte2:Int) {
		events.onPadRelease.dispatch(byte2 - 0x36);
	}

	inline function handleEncoderPress(id:EncoderTouch) {
		events.onEncoderPress.dispatch(id);
	}

	inline function handleEncoderRelease(id:EncoderTouch) {
		events.onEncoderRelease.dispatch(id);
	}

	inline function handleButtonPress(id:Button) {
		events.onButtonPress.dispatch(id);
	}

	inline function handleButtonRelease(id:Button) {
		events.onButtonRelease.dispatch(id);
	}
}
