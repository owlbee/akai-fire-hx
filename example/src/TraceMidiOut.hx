import grig.midi.MidiOut;


/**
	trace available midi ports
**/
class TraceMidiOut {
	static function main() {
		trace(MidiOut.getApis());
		var midiOut = new MidiOut(grig.midi.Api.Unspecified);
		midiOut.getPorts().handle(function(outcome) {
			switch outcome {
				case Success(ports):
					trace(ports);
				case Failure(error):
					trace(error);
			}
		});
	}
}
