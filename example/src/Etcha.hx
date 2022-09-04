import akaifirehx.fire.Control;
import akaifirehx.grig.MidiDevice;

class Etcha {
	static function main() {
		var portName = 'FL STUDIO FIRE Jack 1';
		var portNumber = 1;

		var portConfig:PortConfig = {
			portNumber: portNumber,
			portName: portName
		}

		fire = new MidiDevice(portConfig, portConfig);
		fire.events.onEncoderIncrement.add(move -> handleIncrement(move));
		fire.events.onEncoderDecrement.add(move -> handleDecrement(move));
		fire.events.onButtonPress.add(button -> handleButtonPress(button));
		penX = 64;
		penY = 32;

		fire.sendMessage(DisplayClear(false));
		drawPixel();

		if (fire.isReady()) {
			mainLoop(fire);
		}
	}

	static var fire:MidiDevice;
	static var penX:Int;
	static var penY:Int;

	static function handleIncrement(move:EncoderMove) {
		if (move == VOLUME) {
			sketchX(1);
		}
		if (move == PAN) {
			sketchY(-1);
		}
	}

	static function handleDecrement(move:EncoderMove) {
		if (move == VOLUME) {
			sketchX(-1);
		}
		if (move == PAN) {
			sketchY(1);
		}
	}

	static function handleButtonPress(button:Button) {
		if (button == BROWSER) {
			fire.sendMessage(DisplayClear(true));
		}
	}

	static function sketchX(direction:Int) {
		penX += direction;
		drawPixel();
	}

	static function sketchY(direction:Int) {
		penY += direction;
		drawPixel();
	}

	static function drawPixel() {
		fire.sendMessage(DisplaySetPixel(true, penX, penY));
	}

	static function mainLoop(fire:MidiDevice) {
		var stdout = Sys.stdout();
		var stdin = Sys.stdin();

		stdout.writeString('quit[enter] to quit\n');
		while (true) {
			var command = stdin.readLine();
			if (command.toLowerCase() == 'quit') {
				fire.closePorts();
				return;
			}
		}
	}
}
