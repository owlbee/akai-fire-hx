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
		fire.sendMessage(RegionPadColor(0x22ff99, 9, 1, 8, 8));
		fire.sendMessage(RegionPadColor(0x2040ff, 4, 1, 3, 2));
		fire.sendMessage(SinglePadColor(0x934692, 15, 3));
		fire.sendMessage(OledWriteText("hello ^_^", 0, 0));
	}
}
