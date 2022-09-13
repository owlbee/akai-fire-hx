package akaifirehx.midi;

import akaifirehx.midi.Ports;
import akaifirehx.midi.grig.GrigOut;
import akaifirehx.fire.display.Glyphs;
import akaifirehx.fire.display.Canvas;
import akaifirehx.fire.Leds;
import akaifirehx.fire.SysEx;
import akaifirehx.fire.Events;

class Output {
	var midiOut:GrigOut;
	var canvas:PixelCanvas;
	var leds:Leds;
	var glyphs:Glyphs;
	
	public var isReady(default, null):Bool;

	public function new(config:PortConfig, canvas:PixelCanvas) {
		midiOut = new GrigOut(config, device -> onPortOpened(config, device));
		this.canvas = canvas;
		this.glyphs = new Glyphs(new Font(), canvas.plotPixel);
	}

	inline function onPortOpened(config:PortConfig, device:GrigOut){
		trace('OUT -> Akai Fire Connected to ${config.portNumber} - ${config.portName}');
			leds = new Leds();
			isReady = true;
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
				case PadAllColors(rgb):
					midiOut.sendSysEx(PadSysExMessages.allColors(rgb));
				case PadColorArray(rgbArray):
					midiOut.sendSysEx(PadSysExMessages.colorsArray(rgbArray));
				case DisplaySetText(text, x, y, isInverted):
					glyphs.write(text, x, y, isInverted);
				case DisplaySetPixel(isLit, x, y):
					canvas.plotPixel(x, y, isLit);
				case DisplayShow:
					midiOut.sendSysEx(OledSysExMessages.allOled(canvas.getPixels()));
					trace('display show');
				case DisplayClear(sendToDevice):
					canvas.clear();
					if (sendToDevice) {
						midiOut.sendSysEx(OledSysExMessages.allOled(canvas.getPixels()));
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
		final isInverted = false;
		sendMessage(DisplaySetText("ready!", 0, 0, isInverted));
		sendMessage(DisplayShow);
	}
}
