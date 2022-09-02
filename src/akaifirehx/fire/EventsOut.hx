package akaifirehx.fire;

enum AkaiFireEventOut {
	SinglePadColor(rgb:Int, x:Int, y:Int);
	RegionPadColor(rgb:Int, x:Int, y:Int, w:Int, h:Int);
	AllPadColor(rgb:Int);
	OledWriteText(text:String, x:Int, y:Int);
}