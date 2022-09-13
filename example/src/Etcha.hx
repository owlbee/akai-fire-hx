import akaifirehx.fire.display.Canvas.OledCanvas;
import akaifirehx.midi.AkaiFireMidi;
import akaifirehx.midi.Ports;
import akaifirehx.fire.Control;

class Etcha {
	static function main() {
		var portName = 'FL STUDIO FIRE Jack 1';
		var portNumber = 1;

		var portConfig:PortConfig = {
			portNumber: portNumber,
			portName: portName
		}
		
		fire = new AkaiFireMidi(portConfig, portConfig,  new OledCanvas());
		fire.events.onEncoderIncrement.add(move -> handleIncrement(move));
		fire.events.onEncoderDecrement.add(move -> handleDecrement(move));
		fire.events.onButtonPress.add(button -> handleButtonPress(button));
		penX = 64;
		penY = 32;

		if (fire.isReady()) {
			fire.sendMessage(DisplayClear(false));
			drawPixel();
			mainLoop(fire);
		}
	}

	static var fire:AkaiFireMidi;
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
		// trace('draw pixel $penX $penY');
		fire.sendMessage(DisplaySetPixel(true, penX, penY));
		fire.sendMessage(DisplayShow);
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
		}
	}
}
