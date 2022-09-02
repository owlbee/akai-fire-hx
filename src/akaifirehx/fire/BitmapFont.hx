package akaifirehx.fire;

import haxe.Resource;

class BitmapFont {
	var fontData:Array<Int>;
	var charCodeWidths:Map<Int, Int>;
	var charWidth:Int;
	var charHeight:Int;
	var wb:Int;

	static var CHARCODE_SPACE:Int = 32;

	public function new(resourceIdentifier:String) {
		try {
			var resourceBytes = Resource.getBytes(resourceIdentifier);
			wb = resourceBytes.get(0);
			charWidth = resourceBytes.get(1);
			charHeight = resourceBytes.get(2);
			// var skip = file.get(3);
			charCodeWidths = [];
			for (i in 0...256) {
				charCodeWidths[i] = resourceBytes.get(i + 4);
			}

			fontData = [];
			var position = 256 + 4;
			for(i in position...resourceBytes.length){
				fontData.push(resourceBytes.get(i));
			}
			trace('bytes read from font ${fontData.length + position} out of ${resourceBytes.length}');
		} catch (e) {
			trace(e.message);
		}
	}

	public function plotText(text:String, x:Int, y:Int, setPixel:(x:Int, y:Int, isPixelLit:Bool) -> Void) {
		for (charIndex in 0...text.length) {
			var charCode = text.charCodeAt(charIndex);
			for (charRow in 0...charHeight) {
				var bit = 0x80;
				var fontBit = 0;
				var cnt = 0;
				var charCol = x;
				for (_ in 0...charWidth) {
					if (bit == 0x80) {
						var byteIndex = charCode * charHeight * wb + charRow * wb + cnt;
						fontBit = fontData[byteIndex];
						cnt += 1;
					}
					if (fontBit & bit > 0) {
						setPixel(charCol, y + charRow, true);
					}
					charCol += 1;
					bit >>= 1;
					if (bit == 0) {
						bit = 0x80;
					}
				}
			}
			if (charCode == CHARCODE_SPACE) {
				x += Std.int(charWidth / 2);
			} else {
				x += charCodeWidths[charCode];
			}
		}
	}
}
