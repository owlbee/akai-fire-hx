import akaifirehx.fire.EventsOut;
import akaifirehx.grig.Hardware;

/**
	test akai fire abstraction
**/
class FireTest {
	static function main() {
		var portName = 'FL STUDIO FIRE Jack 1';
		var portNumber = 1;
		var fire = new Hardware(portName, portNumber);
		fire.sendMessage(PadRegionColor(0x22ff99, 9, 1, 8, 8));
		fire.sendMessage(PadRegionColor(0x2040ff, 4, 1, 3, 2));
		fire.sendMessage(PadSingleColor(0x934692, 15, 3));

		fire.sendMessage(DisplayWriteText("hello ^_^", 0, 0));
		
		// red
		fire.sendMessage(LedSingleColor(PATUP, LOW));
		fire.sendMessage(LedSingleColor(PATDOWN, HIGH));
		
		// yellow
		fire.sendMessage(LedSingleColor(ALT, LOW));
		fire.sendMessage(LedSingleColor(STOP, LOW));

		// green
		fire.sendMessage(LedSingleColor(SOLO1, LOW));
		fire.sendMessage(LedSingleColor(SOLO2, HIGH));

		// red / yellow
		fire.sendMessage(LedMultiColor(STEP, COLOR_LOW));
		fire.sendMessage(LedMultiColor(NOTE, COLOR_HIGH));
		fire.sendMessage(LedMultiColor(DRUM, YELLOW_LOW));
		fire.sendMessage(LedMultiColor(PERFORM, YELLOW_HIGH));

		// green / yellow
		fire.sendMessage(LedMultiColor(PATTERN, COLOR_LOW));
		fire.sendMessage(LedMultiColor(PLAY, COLOR_HIGH));
	}
}
