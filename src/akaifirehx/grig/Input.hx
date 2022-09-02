package akaifirehx.grig;

import akaifirehx.fire.Input;
import akaifirehx.fire.Leds;
import akaifirehx.fire.Display;
import grig.midi.MidiMessage;
import grig.midi.MidiIn;

class Input {
	var midiIn:MidiIn;
	var oled:Display;
	var leds:Leds;
	var isReady:Bool;

	public function new(portName:String, portNumber:Int) {
		midiIn = new MidiIn(grig.midi.Api.Unspecified);
		midiIn.setCallback(function(midiMessage:MidiMessage, delta:Float) {
			// trace('midiMessage.byte1 ${midiMessage.byte1}');
			// trace('midiMessage.byte2 ${midiMessage.byte2}');
			// trace('midiMessage.byte3 ${midiMessage.byte3}');
			var action:Action = midiMessage.byte1;
			switch action{
				case MOVE:
					handleEncoder(midiMessage.byte2, midiMessage.byte3);
				case PRESS:
					handleButtonPress(midiMessage.byte2, midiMessage.byte3);
				case RELEASE:
					handleButtonRelease(midiMessage.byte2, midiMessage.byte3);
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
								mainLoop(midiIn);
							case Failure(error):
								trace(error);
						}
					});
				case Failure(error):
					trace(error);
			}
		});
	}

	function handleEncoder(encoder:Encoder, value:Int) {
		var direction = value >= 64 ? "inc" : "dec";
		trace('encoder $encoder $direction');
	}

	function handleButtonPress(button:Button, value:Int) {
		trace('press $button');
	}

	function handleButtonRelease(button:Button, value:Int) {
		trace('release $button');
	}

	function mainLoop(midiIn:MidiIn) {
		#if (sys && !nodejs)
        var stdout = Sys.stdout();
        var stdin = Sys.stdin();
        // Using Sys.getChar() unfortunately fucks up the output
        stdout.writeString('quit[enter] to quit\n');
        while (true) {
            var command = stdin.readLine();
            if (command.toLowerCase() == 'quit') {
                midiIn.closePort();
                return;
            }
        }
        #end
	}
}