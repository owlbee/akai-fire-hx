import grig.midi.MidiMessage;
import grig.midi.MidiIn;
import grig.midi.MidiOut;

import tink.core.Future;


/**
	trace available midi ports
**/
class TraceMidi {
    private static function mainLoop(midiIn:MidiIn)
    {
        #if (sys && !nodejs)
        var stdout = Sys.stdout();
        var stdin = Sys.stdin();
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

	static function main() {
		trace(MidiOut.getApis());
        var portName = 'FL STUDIO FIRE Jack 1';
        var portNumber = 1;
		var midiOut = new MidiOut(grig.midi.Api.Unspecified);
		midiOut.getPorts().handle(function(outcome) {
			switch outcome {
				case Success(ports):
					trace('OUT ports');
					trace(ports);
				case Failure(error):
					trace(error);
			}
		});

		var midiIn = new MidiIn(grig.midi.Api.Unspecified);
        midiIn.setCallback(function (midiMessage:MidiMessage, delta:Float) {
            trace('midiMessage.messageType ${midiMessage.messageType}');
            trace('midiMessage.byte1 ${midiMessage.byte1}');
            trace('midiMessage.byte2 ${midiMessage.byte2}');
            trace('midiMessage.byte3 ${midiMessage.byte3}');
            // trace(delta);
        });

        midiIn.getPorts().handle(function(outcome) {
            switch outcome {
                case Success(ports):
					trace('IN ports');
                    trace(ports);
                    midiIn.openPort(portNumber, portName).handle(function(midiOutcome) {
                        switch midiOutcome {
                            case Success(_):
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
}
