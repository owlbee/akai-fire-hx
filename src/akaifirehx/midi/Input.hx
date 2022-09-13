package akaifirehx.midi;

import akaifirehx.midi.grig.GrigIn;
import akaifirehx.midi.Ports;
import akaifirehx.fire.Events;
import akaifirehx.fire.Control;
import akaifirehx.fire.Leds;

class Input {
	var midiIn:GrigIn;
	var events:InputEvents;
	
	public var isReady(default, null):Bool;
	public var isDownPad(default, null):Map<Int, Bool>;
	public var isDownButton(default, null):Map<Int, Bool>;
	public var isDownEncoder(default, null):Map<Int, Bool>;

	public function new(config:PortConfig, events:InputEvents) {
		this.events = events;
		isDownPad = [];
		isDownButton = [];
		isDownEncoder = [];

		midiIn = new GrigIn(config, 
			device -> onPortOpened(config, device),
			(midiMessage, delta) -> {
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
	}

	inline function onPortOpened(config:PortConfig, device:GrigIn){
		isReady = true;
		trace('IN -> Akai Fire Connected to ${config.portNumber} - ${config.portName}');
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

	inline function toPadIndex(byte2:Int):Int{
		return byte2 - 0x36;
	}

	inline function handlePadPress(byte2:Int) {
		var padIndex = toPadIndex(byte2);
		isDownPad[padIndex] = true;
		events.onPadPress.dispatch(padIndex);
	}

	inline function handlePadRelease(byte2:Int) {
		var padIndex = toPadIndex(byte2);
		isDownPad[padIndex] = false;
		events.onPadRelease.dispatch(padIndex);
	}

	inline function handleEncoderPress(id:EncoderTouch) {
		isDownEncoder[id] = true;
		events.onEncoderPress.dispatch(id);
	}

	inline function handleEncoderRelease(id:EncoderTouch) {
		isDownEncoder[id] = false;
		events.onEncoderRelease.dispatch(id);
	}

	inline function handleButtonPress(id:Button) {
		isDownButton[id] = true;
		events.onButtonPress.dispatch(id);
	}

	inline function handleButtonRelease(id:Button) {
		isDownButton[id] = false;
		events.onButtonRelease.dispatch(id);
	}
}
