package akaifirehx.fire;

class OledDisplay {
	public var pixels(default, null):Array<Int>;

	var font:BitmapFont;
	var bitMutate:Array<Array<Int>>;
	static var totalPixels:Int = 1171;

	public function new() {
		font = new BitmapFont('12x16fnt');
		pixels = [];
		clear();

		bitMutate = [
			[13, 0, 1, 2, 3, 4, 5, 6],
			[19, 20, 7, 8, 9, 10, 11, 12],
			[25, 26, 27, 14, 15, 16, 17, 18],
			[31, 32, 33, 34, 21, 22, 23, 24],
			[37, 38, 39, 40, 41, 28, 29, 30],
			[43, 44, 45, 46, 47, 48, 35, 36],
			[49, 50, 51, 52, 53, 54, 55, 42]
		];
	}

	inline function isOutOfBounds(x:Int, y:Int):Bool {
		return x > 127 || y > 63 || x < 0 || y < 0;
	}

	function setPixel(x:Int, y:Int, isPixelLit:Bool) {
		if (isOutOfBounds(x, y)){
			trace('warning ! position out of display bounds');
			return;
		}
		x = x + Std.int(128 * Std.int(y / 8));
		y = Std.int(y % 8);
		var bitMutateCol = Std.int(x % 7);
		var mutatedBit = bitMutate[bitMutateCol][y];
		var pixelIndex = Std.int(Std.int(x / 7) * 8 + Std.int(mutatedBit / 7));
		if(pixelIndex > pixels.length){
			trace('warning ! pixel array index out of bounds');
			return;
		}
		if (isPixelLit) {
			pixels[pixelIndex] |= 1 << Std.int(mutatedBit % 7);
		} else {
			pixels[pixelIndex] &= ~(1 << Std.int(mutatedBit % 7));
		}
	}

	public function clear() {
		for (i in 0...totalPixels) {
			pixels[i] = 0;
		}
	}

	public function plotText(text:String, x:Int, y:Int) {
		font.plotText(text, x, y, setPixel);
	}
}
