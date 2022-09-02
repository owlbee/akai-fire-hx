package akaifirehx.fire;

class PadSysExMessages {
	static var totalPads:Int = 64;
	static var padColorMessageLength:Int = 4;
	static var gridWidth:Int = 16;

	static inline function clamp(num:Int, minimum:Int, maximum:Int):Int {
		if (num > maximum) return maximum;
		if (num < minimum) return minimum;
		return num;
	}

	static inline function appendPadColorMessage(bytes:Array<Int>, index:Int, r:Int, g:Int, b:Int) {
		bytes.push(index);
		bytes.push(r & 0x7f);
		bytes.push(g & 0x7f);
		bytes.push(b & 0x7f);
	}

	static inline function calculateGridIndex(col:Int, row:Int):Int {
		return Std.int(row * gridWidth + col);
	}

	public static function singleColor(rgb:Int, x:Int, y:Int):Dynamic {
		var innerBytes = start_message(MessageConstants.WRITE_PADS, padColorMessageLength);
		var i = calculateGridIndex(x, y);
		var r = sysex_red(rgb);
		var g = sysex_green(rgb);
		var b = sysex_blue(rgb);
		appendPadColorMessage(innerBytes, i, r, g, b);
		return innerBytes;
	}

	public static function regionColor(rgb:Int, x:Int, y:Int, width:Int, height:Int):Dynamic {
		var edge_right = clamp(x + width, 0, 16);
		var edge_bottom = clamp(y + height, 0, 4);
		var padCount = (edge_right - x) * (edge_bottom - y);
		var payloadLength:Int = Std.int(padCount * padColorMessageLength);
		var innerBytes = start_message(MessageConstants.WRITE_PADS, payloadLength);
		var r = sysex_red(rgb);
		var g = sysex_green(rgb);
		var b = sysex_blue(rgb);
		for (col in x...edge_right)
			for (row in y...edge_bottom) {
				var i = calculateGridIndex(col, row);
				appendPadColorMessage(innerBytes, i, r, g, b);
			}
		return innerBytes;
	}

	public static function allColor(rgb:Int):Array<Int> {
		final payloadLength:Int = Std.int(totalPads * padColorMessageLength);
		var innerBytes = start_message(MessageConstants.WRITE_PADS, payloadLength);
		var r = sysex_red(rgb);
		var g = sysex_green(rgb);
		var b = sysex_blue(rgb);
		for (i in 0...totalPads) {
			appendPadColorMessage(innerBytes, i, r, g, b);
		}
		return innerBytes;
	}
}

class OledSysExMessages{
	
	static var startBand:Int = 0;
	static var endBand:Int = 0x7;
	static var startColumn:Int = 0;
	static var endColumn:Int = 0x7f;

	public static function allOledPixels(pixels:Array<Int>):Array<Int>{
		var messageLength = pixels.length + 4;
		var innerBytes = start_message(MessageConstants.WRITE_OLed, messageLength);
		innerBytes.push(startBand);
		innerBytes.push(endBand);
		innerBytes.push(startColumn);
		innerBytes.push(endColumn);

		for(p in pixels){
			innerBytes.push(p);
		}
		
		return innerBytes;
	}
}

class MessageConstants {
	public static var VENDOR = 0x47; // akai
	public static var DEVICE = 0x43; // fire
	public static var WRITE_PADS = 0x65;
	public static var WRITE_OLed = 0x0e;
}

inline function sysex_red(rgb:Int):Int {
	return rgb >> 17;
}

inline function sysex_green(rgb:Int):Int {
	return rgb >> 9;
}

inline function sysex_blue(rgb:Int):Int {
	return rgb >> 1;
}

inline function toUpper(num:Int):Int {
	return num >> 0x7;
}

inline function toLower(num:Int):Int {
	return num & 0x7f;
}

inline function start_message(messageType:Int, messageLength:Int):Array<Int> {
	return [
		MessageConstants.VENDOR,
		0x7f,
		MessageConstants.DEVICE,
		messageType,
		toUpper(messageLength),
		toLower(messageLength),
	];
}
