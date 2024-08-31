package mobile.input;

import flixel.system.macros.FlxMacroUtil;

/**
 * A high-level list of unique values for mobile input buttons.
 * Maps enum values and strings to unique integer codes
 * @author Karim Akra
 */
@:runtimeValue
enum abstract MobileInputID(Int) from Int to Int {
	public static var fromStringMap(default, null):Map<String, MobileInputID> = FlxMacroUtil.buildMap("mobile.input.MobileInputID");
	public static var toStringMap(default, null):Map<MobileInputID, String> = FlxMacroUtil.buildMap("mobile.input.MobileInputID", true);
	// Nothing & Anything
	var ANY = -2;
	var NONE = -1;
	// Buttons
	var A = 1;
	var B = 2;
	var C = 3;
	var D = 4;
	var E = 5;
	var F = 6;
	var G = 7;
	var H = 8;
	var I = 9;
	var J = 10;
	var K = 11;
	var L = 12;
	var M = 13;
	var N = 14;
	var O = 15;
	var P = 16;
	var Q = 17;
	var R = 18;
	var S = 19;
	var T = 20;
	var U = 21;
	var V = 22;
	var W = 23;
	var X = 24;
	var Y = 25;
	var Z = 26;
	// VPAD Buttons
	var UP = 27;
	var UP2 = 28;
	var DOWN = 29;
	var DOWN2 = 30;
	var LEFT = 31;
	var LEFT2 = 32;
	var RIGHT = 33;
	var RIGHT2 = 34;
	// HITBOX
	var hitboxUP = 35;
	var hitboxDOWN = 36;
	var hitboxLEFT = 37;
	var hitboxRIGHT = 38;
	// PlayState Releated
	var noteUP = 39;
	var noteDOWN = 40;
	var noteLEFT = 41;
	var noteRIGHT = 42;

	@:from
	public static inline function fromString(s:String) {
		s = s.toUpperCase();
		return fromStringMap.exists(s) ? fromStringMap.get(s) : NONE;
	}

	@:to
	public inline function toString():String {
		return toStringMap.get(this);
	}
}
