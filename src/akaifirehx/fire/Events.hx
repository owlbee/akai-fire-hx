package akaifirehx.fire;

import akaifirehx.fire.Control;
import akaifirehx.fire.Leds;

enum AkaiFireEventOut {
	PadSingleColor(rgb:Int, x:Int, y:Int);
	PadRegionColor(rgb:Int, x:Int, y:Int, w:Int, h:Int);
	PadAllColors(rgb:Int);
	PadColorArray(rgbArray:Array<Int>);
	DisplaySetText(text:String, x:Int, y:Int, isInverted:Bool);
	DisplaySetPixel(isLit:Bool, x:Int, y:Int);
	DisplayClear(sendToDevice:Bool);
	DisplayShow;
	LedSingleColor(id:SingleColorLed, state:SingleColorState);
	LedYellowColor(id:YellowColorLed, state:YellowColorState);
	LedMultiColor(id:MultiColorLed, state:MultiColorState);
	LedEncoderMode(state:EncoderModeState);
	LedGlobalIllumination(isOn:Bool);
}

class InputEvents {
	public var onPadPress:Event<Int>;
	public var onPadRelease:Event<Int>;
	public var onButtonPress:Event<Button>;
	public var onButtonRelease:Event<Button>;
	public var onEncoderPress:Event<EncoderTouch>;
	public var onEncoderRelease:Event<EncoderTouch>;
	public var onEncoderIncrement:Event<EncoderMove>;
	public var onEncoderDecrement:Event<EncoderMove>;

	public function new() {
		onPadPress = new Event<Int>();
		onPadRelease = new Event<Int>();
		onButtonPress = new Event<Button>();
		onButtonRelease = new Event<Button>();
		onEncoderPress = new Event<EncoderTouch>();
		onEncoderRelease = new Event<EncoderTouch>();
		onEncoderIncrement = new Event<EncoderMove>();
		onEncoderDecrement = new Event<EncoderMove>();
	}
}

class Event<T> {
	public var listeners:Array<T->Void>;

	public function new() {
		listeners = [];
	}

	public function add(listener:T->Void):Void {
		listeners.push(listener);
	}

	public function dispatch(event:T):Void {
		// trace('dispatch $event to ${listeners.length} listeners');
		for (listener in listeners) {
			listener(event);
		}
	}

	public function remove(listener:T->Void):Void {
		var i = listeners.length;

		while (--i >= 0) {
			if (Reflect.compareMethods(listeners[i], listener)) {
				listeners.splice(i, 1);
			}
		}
	}

	public function removeAll():Void {
		var len = listeners.length;

		listeners.splice(0, len);
	}
}
