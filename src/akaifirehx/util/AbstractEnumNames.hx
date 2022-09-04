package akaifirehx.util;

import akaifirehx.fire.Control;

class AbstractEnumExtensions {
	public static function buttonName(i:Button) {
		return switch i {
			case ALT: "ALT";
			case BROWSER: "BROWSER";
			case DRUM: "DRUM | TAP";
			case ENCODERMODE: "ENCODER MODE";
			case GRIDLEFT: "GRID LEFT";
			case GRIDRIGHT: "GRID RIGHT";
			case NOTE: "NOTE | SNAP";
			case PATDOWN: "PATTERN DOWN";
			case PATTERN: "PATTERN/SONG | METRONOME";
			case PATUP: "PATTERN UP";
			case PERFORM: "PERFORM | OVERVIEW";
			case PLAY: "PLAY | WAIT";
			case REC: "REC | LOOP REC";
			case SHIFT: "SHIFT";
			case STEP: "STEP | ACCENT";
			case STOP: "STOP | COUNTDOWN";
			case TRACK1: "TRACK 1";
			case TRACK2: "TRACK 2";
			case TRACK3: "TRACK 3";
			case TRACK4: "TRACK 4";
		};
	}

	public static function encoderTouchName(i:EncoderTouch) {
		return switch i {
			case FILTER: "FILTER | LOW EQ";
			case PAN: "PAN";
			case RESONANCE: "RESONANCE | HIGH EQ";
			case SELECT: "SELECT";
			case VOLUME: "VOLUME";
		}
	}

	public static function encoderMoveName(i:EncoderMove) {
		return switch i {
			case FILTER: "FILTER | LOW EQ";
			case PAN: "PAN";
			case RESONANCE: "RESONANCE | HIGH EQ";
			case SELECT: "SELECT";
			case VOLUME: "VOLUME";
		}
	}
}
