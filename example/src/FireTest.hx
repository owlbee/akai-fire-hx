import akaifirehx.fire.display.Canvas.OledCanvas;
import akaifirehx.midi.AkaiFireMidi;
import akaifirehx.midi.Ports;

using akaifirehx.util.AbstractEnumNames;
using akaifirehx.util.TransmitPng;

/**
	test akai fire abstraction
**/
class FireTest {
	static function main() {
		var portName = 'FL STUDIO FIRE Jack 1';
		var portNumber = 1;
		var outPort:PortConfig = {
			portNumber: portNumber,
			portName: portName
		}

		var inPort:PortConfig = {
			portNumber: portNumber,
			portName: portName
		}

		var fire = new AkaiFireMidi(inPort, outPort, new OledCanvas());

		fire.sendMessage(PadRegionColor(0x22ff99, 9, 1, 8, 8));
		fire.sendMessage(PadRegionColor(0x2040ff, 4, 1, 3, 2));
		fire.sendMessage(PadSingleColor(0x934692, 15, 3));

		fire.sendMessage(DisplayClear(false));
		var isInverted = false;
		fire.sendMessage(DisplaySetText("       hello ^_^", 0, 0, isInverted));
		isInverted = true;
		fire.sendMessage(DisplaySetText("^o^ hi!", 0, 8, isInverted));
		fire.sendMessage(DisplayShow);

		// red
		fire.sendMessage(LedSingleColor(PATUP, LOW));
		fire.sendMessage(LedSingleColor(PATDOWN, HIGH));

		// yellow
		fire.sendMessage(LedSingleColor(ALT, LOW));
		fire.sendMessage(LedSingleColor(STOP, LOW));

		// green
		fire.sendMessage(LedSingleColor(TRACK1, LOW));
		fire.sendMessage(LedSingleColor(TRACK2, HIGH));

		// red / yellow
		fire.sendMessage(LedYellowColor(STEP, COLOR_LOW));
		fire.sendMessage(LedYellowColor(NOTE, COLOR_HIGH));
		fire.sendMessage(LedYellowColor(DRUM, YELLOW_LOW));
		fire.sendMessage(LedYellowColor(PERFORM, YELLOW_HIGH));

		// green / yellow
		fire.sendMessage(LedYellowColor(PATTERN, COLOR_LOW));
		fire.sendMessage(LedYellowColor(PLAY, COLOR_HIGH));

		// rectangle red
		fire.sendMessage(LedMultiColor(TRACK1, RED_LOW));
		fire.sendMessage(LedMultiColor(TRACK2, RED_HIGH));

		// rectangle green
		fire.sendMessage(LedMultiColor(TRACK3, GREEN_LOW));
		fire.sendMessage(LedMultiColor(TRACK4, GREEN_HIGH));

		fire.sendMessage(LedEncoderMode(ALL_ON));

		// fire.sendMessage(LedGlobalIllumination(true));

		fire.events.onButtonPress.add(button -> trace('button press $button ${button.buttonName()}'));
		fire.events.onButtonRelease.add(button -> trace('button release $button ${button.buttonName()}'));

		fire.events.onEncoderPress.add(touch -> trace('encoder press $touch ${touch.encoderTouchName()}'));
		fire.events.onEncoderRelease.add(touch -> trace('encoder release $touch ${touch.encoderTouchName()}'));

		fire.events.onEncoderDecrement.add(move -> trace('encoder decrease $move ${move.encoderMoveName()}'));
		fire.events.onEncoderIncrement.add(move -> trace('encoder increase $move ${move.encoderMoveName()}'));

		fire.events.onPadPress.add(i -> trace('pad press index $i'));
		fire.events.onPadRelease.add(i -> trace('pad release index $i'));

		if (fire.isReady()) {
			mainLoop(fire);
		}
	}

	static function mainLoop(fire:AkaiFireMidi) {
		var stdout = Sys.stdout();
		var stdin = Sys.stdin();

		stdout.writeString('quit[enter] to quit\n');

		while (true) {
			var command = stdin.readLine();
			if (command.toLowerCase() == 'quit') {
				fire.closePorts();
				return;
			}
			if (command.toLowerCase() == 'p') {
				fire.sendImageToPads('pad-colors.png');
			}
		}
	}
}
