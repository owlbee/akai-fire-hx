package akaifirehx.grig;

import akaifirehx.fire.Leds;
import akaifirehx.fire.Display;
import akaifirehx.fire.SysEx;
import grig.midi.MidiMessage;
import akaifirehx.fire.EventsOut;
import grig.midi.MidiOut;

class Output {
	var midiOut:MidiOut;
	var oled:Display;
	var leds:Leds;
	var isReady:Bool;

	public function new(portName:String, portNumber:Int) {
		midiOut = new MidiOut(grig.midi.Api.Unspecified);
		midiOut.getPorts().handle(function(outcome) {
			switch outcome {
				case Success(ports):
					midiOut.openPort(portNumber, portName).handle(function(midiOutcome) {
						switch midiOutcome {
							case Success(_):
								trace('OUT -> Akai Fire Connected to $portNumber - $portName');
								oled = new Display();
								leds = new Leds();
								isReady = true;
								initIllumination();
								initDisplay();
							case Failure(error):
								trace('error $error');
						}
					});
				case Failure(error):
					trace(error);
			}
		});
	}

	public function sendMessage(event:AkaiFireEventOut) {
		if (isReady) {
			switch event {
				case PadSingleColor(rgb, x, y):
					midiOut.sendMessage(MidiMessage.ofMessageType(SysEx, PadSysExMessages.singleColor(rgb, x, y)));
				case PadRegionColor(rgb, x, y, w, h):
					midiOut.sendMessage(MidiMessage.ofMessageType(SysEx, PadSysExMessages.regionColor(rgb, x, y, w, h)));
				case PadAllColor(rgb):
					midiOut.sendMessage(MidiMessage.ofMessageType(SysEx, PadSysExMessages.allColor(rgb)));
				case DisplayWriteText(text, x, y):
					oled.clear();
					oled.plotText(text, x, y);
					midiOut.sendMessage(MidiMessage.ofMessageType(SysEx, OledSysExMessages.allOledPixels(oled.pixels)));
				case LedSingleColor(id, state):
					leds.setSingle(id, state);
					midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, leds.getSingleColorCcBytes(id)));
				case LedYellowColor(id, state):
					leds.setYellow(id, state);
					midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, leds.getYellowColorCcBytes(id)));
				case LedMultiColor(id, state):
					leds.setMulti(id, state);
					midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, leds.getMultiColorCcBytes(id)));
				case LedEncoderMode(state):
					leds.setEncoderMode(state);
					midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, leds.getEncodeModeCcBytes()));
				case LedGlobalIllumination(isOn):
					midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, leds.getGlobalIllumuniationCcBytes(isOn)));
			}
		} else {
			trace('Device is not ready');
		}
	}

	function initIllumination() {
		// set all leds off (including pads)
		midiOut.sendMessage(MidiMessage.ofMessageType(ControlChange, leds.getGlobalIllumuniationCcBytes(false)));
	}

	function initDisplay() {
		sendMessage(DisplayWriteText("ready!", 0, 0));
	}
}
