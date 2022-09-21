package akaifirehx.util;

import haxe.io.Bytes;
import akaifirehx.midi.AkaiFireMidi;

class TransmitPng{
	static function readPixels(pngFilePath:String):{data:Bytes, width:Int, height:Int} {
		var file = sys.io.File.read(pngFilePath, true);
		var pngData = new format.png.Reader(file).read();
		var pngHeader = format.png.Tools.getHeader(pngData);
		var pixels = {
			data: format.png.Tools.extract32(pngData),
			width: pngHeader.width,
			height: pngHeader.height
		};
		file.close();
		return pixels;
	}

	public static function sendImageToPads(fire:AkaiFireMidi, pngFilePath:String) {
		var pixels = readPixels(pngFilePath);

		var isSizeOfPadGrid = pixels.width == 16 && pixels.height == 4;
		if(!isSizeOfPadGrid){
			trace('requested png needs to be 16 x 4 but was ${pixels.width} x ${pixels.height}');
			return;
		};

		var colors = new Grid<Int>(0x000000, pixels.width, pixels.height);
		for (y in 0...pixels.height) {
			for (x in 0...pixels.width) {
				var p = pixels.data.getInt32(4 * (x + y * pixels.width));
				var a:Int = p >>> 24;
				var r:Int = (p >>> 16) & 0xff;
				var g:Int = (p >>> 8) & 0xff;
				var b:Int = (p) & 0xff;
				var hex:String = StringTools.hex(p, 8);
				trace('${x},${y}: ${a},${r},${g},${b} - $hex');
				colors.set(x, y, p);
			}
		}

		fire.sendMessage(PadColorArray(colors.cells));
	}
}