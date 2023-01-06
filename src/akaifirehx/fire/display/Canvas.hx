package akaifirehx.fire.display;

import akaifirehx.util.Grid;
import haxe.io.BytesOutput;

/**
	Abstract surface for interacting with OLED pixels;
**/
abstract class PixelCanvas {
	var width:Int = 128;
	var height:Int = 64;

	abstract public function clear():Void;

	abstract public function getPixels():Array<Int>;

	inline function isOutOfBounds(x:Int, y:Int):Bool {
		return x >= width || y > height || x < 0 || y < 0;
	}

	abstract public function setPixel(x:Int, y:Int, isLit:Bool):Void;

	public function plotPixel(x:Int, y:Int, isLit:Bool) {
		if (isOutOfBounds(x, y))
			return;
		setPixel(x, y, isLit);
	}
}

/**
	Concrete class representing the physical OLED display
**/
class OledCanvas extends PixelCanvas {
	public var pixels(default, null):Array<Int>;

	var bitMutate:Array<Array<Int>>;

	static var totalPixels:Int = 1171;

	public function new() {
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

	public function setPixel(x:Int, y:Int, isLit:Bool) {
		x = x + Std.int(128 * Std.int(y / 8));
		y = Std.int(y % 8);
		var bitMutateCol = Std.int(x % 7);
		var mutatedBit = bitMutate[bitMutateCol][y];
		var pixelIndex = Std.int(Std.int(x / 7) * 8 + Std.int(mutatedBit / 7));
		if (pixelIndex > pixels.length) {
			trace('warning ! pixel array index out of bounds');
			return;
		}
		if (isLit) {
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

	public function getPixels():Array<Int> {
		return pixels;
	}
}

/**
	Concrete class representing a virtual OLED display, for testing when devie is not connected.
**/
class ImageCanvas extends PixelCanvas {
	var pixels:Grid<Int>;

	static var white:Int = 0xffffffff;
	static var black:Int = 0x000000ff;

	public function new(width:Int, height:Int) {
		pixels = new Grid(black, width, height);
		this.width = width;
		this.height = height;
	}

	public function setPixel(x:Int, y:Int, isLit:Bool) {
		if(isLit) pixels.set(x, y, isLit ? white : black);
	}

	public function write(path:String):Void {
		var bytes = new BytesOutput();
		for (pixel in pixels.cells) {
			bytes.writeInt32(pixel);
		}
		var data = format.png.Tools.build32ARGB(width, height, bytes.getBytes());
		var out = sys.io.File.write(path, true);
		new format.png.Writer(out).write(data);
	}

	public function getPixels():Array<Int> {
		return pixels.cells;
	}

	public function clear() {
		for(i in 0...pixels.cells.length){
			pixels.cells[i] = black;
		}
	}
}



class OledCanvasImageSync extends PixelCanvas{
	var image:ImageCanvas;
	var oled:OledCanvas;

	public function new(width:Int, height:Int) {
		image = new ImageCanvas(width, height);
		oled = new OledCanvas();
	}

	public function clear() {
		oled.clear();
		image.clear();
	}

	public function getPixels():Array<Int> {
		return oled.getPixels();
	}

	public function setPixel(x:Int, y:Int, isLit:Bool) {
		oled.setPixel(x, y, isLit);
		image.setPixel(x, y, isLit);
	}
}