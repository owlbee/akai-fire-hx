package akaifirehx.midi;

import akaifirehx.midi.Ports;
import akaifirehx.midi.grig.GrigOut;
import akaifirehx.fire.Leds;
import akaifirehx.fire.Display;
import akaifirehx.fire.SysEx;
import akaifirehx.fire.Events;

class Output {
	var midiOut:GrigOut;
	var oled:Display;
	var leds:Leds;

	public var isReady(default, null):Bool;

	public function new(config:PortConfig) {
		midiOut = new GrigOut(config, device -> onPortOpened(config, device));
	}

	inline function onPortOpened(config:PortConfig, device:GrigOut){
		trace('OUT -> Akai Fire Connected to ${config.portNumber} - ${config.portName}');
			oled = new Display();
			leds = new Leds();
			isReady = true;
			// initIllumination();
			// initDisplay();
	}

	public function closePort() {
		midiOut.closePort();
	}

	public function sendMessage(event:AkaiFireEventOut) {
		if (isReady) {
			switch event {
				case PadSingleColor(rgb, x, y):
					midiOut.sendSysEx(PadSysExMessages.singleColor(rgb, x, y));
				case PadRegionColor(rgb, x, y, w, h):
					midiOut.sendSysEx(PadSysExMessages.regionColor(rgb, x, y, w, h));
				case PadAllColorSame(rgb):
					midiOut.sendSysEx(PadSysExMessages.allColorSame(rgb));
				case PadAllColors(rgbArray):
					midiOut.sendSysEx(PadSysExMessages.allColors(rgbArray));
				case DisplayWriteText(text, x, y):
					// oled.clear();
					oled.plotText(text, x, y);
					midiOut.sendSysEx(OledSysExMessages.allOledPixels(oled.pixels));
				case DisplaySetPixel(isLit, x, y):
					oled.plotPixel(isLit, x, y);
					midiOut.sendSysEx(OledSysExMessages.allOledPixels(oled.pixels));
				case DisplayClear(sendToDevice):
					oled.clear();
					if (sendToDevice) {
						midiOut.sendSysEx(OledSysExMessages.allOledPixels(oled.pixels));
					}
				case LedSingleColor(id, state):
					leds.setSingle(id, state);
					midiOut.sendCC(leds.getSingleColorCcBytes(id));
				case LedYellowColor(id, state):
					leds.setYellow(id, state);
					midiOut.sendCC(leds.getYellowColorCcBytes(id));
				case LedMultiColor(id, state):
					leds.setMulti(id, state);
					midiOut.sendCC(leds.getMultiColorCcBytes(id));
				case LedEncoderMode(state):
					leds.setEncoderMode(state);
					midiOut.sendCC(leds.getEncodeModeCcBytes());
				case LedGlobalIllumination(isOn):
					midiOut.sendCC(leds.getGlobalIllumuniationCcBytes(isOn));
			}
		} else {
			trace('Device is not ready');
		}
	}

	public function initIllumination() {
		// set all leds off (including pads)
		midiOut.sendCC(leds.getGlobalIllumuniationCcBytes(false));
	}

	public function initDisplay() {
		sendMessage(DisplayWriteText("ready!", 0, 0));
	}
}
