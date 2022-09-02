package akaifirehx.grig;

import akaifirehx.fire.OledDisplay;
import akaifirehx.fire.SysEx;
import grig.midi.MidiMessage;
import akaifirehx.fire.EventsOut;
import grig.midi.MidiOut;

class Hardware {
	var midiOut:MidiOut;
	var oled:OledDisplay;
	var isReady:Bool;

	public function new(portName:String, portNumber:Int) {
		midiOut = new MidiOut(grig.midi.Api.Unspecified);

		midiOut.getPorts().handle(function(outcome) {
			switch outcome {
				case Success(ports):
					midiOut.openPort(portNumber, portName).handle(function(midiOutcome) {
						switch midiOutcome {
							case Success(_):
								trace('Akai Fire Connected to $portNumber - $portName');
								oled = new OledDisplay();
								isReady = true;
								sendMessage(AllPadColor(0x000000));
								sendMessage(OledWriteText("hello", 0, 0));
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
				case SinglePadColor(rgb, x, y):
					midiOut.sendMessage(MidiMessage.ofMessageType(SysEx, PadSysExMessages.singlePadColor(rgb, x, y)));
				case RegionPadColor(rgb, x, y, w, h):
					midiOut.sendMessage(MidiMessage.ofMessageType(SysEx, PadSysExMessages.regionPadColor(rgb, x, y, w, h)));
				case AllPadColor(rgb):
					midiOut.sendMessage(MidiMessage.ofMessageType(SysEx, PadSysExMessages.allPadColor(rgb)));
				case OledWriteText(text, x, y):
					oled.plotText(text, x, y);
					midiOut.sendMessage(MidiMessage.ofMessageType(SysEx, OledSysExMessages.allOledPixels(oled.pixels)));
			}
		} else {
			trace('Device is not ready');
		}
	}
}
