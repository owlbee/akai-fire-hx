package akaifirehx.fire;

import akaifirehx.fire.Leds;

enum AkaiFireEventOut {
	PadSingleColor(rgb:Int, x:Int, y:Int);
	PadRegionColor(rgb:Int, x:Int, y:Int, w:Int, h:Int);
	PadAllColor(rgb:Int);
	DisplayWriteText(text:String, x:Int, y:Int);
	LedSingleColor(id:SingleColorLed, state:SingleColorState);
	LedYellowColor(id:YellowColorLed, state:YellowColorState);
	LedMultiColor(id:MultiColorLed, state:MultiColorState);
}