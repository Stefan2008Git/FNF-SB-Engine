package debug;

import openfl.text.TextField;
import openfl.text.TextFormat;
#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end

import haxe.macro.Compiler;
import lime.system.System as LimeSystem;

import states.MainMenuState;

#if cpp
#if windows
@:cppFileCode('#include <windows.h>')
#elseif mac
@:cppFileCode('#include <mach-o/arch.h>')
#else
@:headerInclude('sys/utsname.h')
#end
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/

class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentlyFPS(default, null):Int;
	public var totalFPS(default, null):Int;

	public var currentlyMemory:Float;
	public var maximumMemory:Float;
	public var color:Int = 0xFF000000;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public var rainbowEnabled(default, set):Bool = false;
	public function set_rainbowEnabled(v:Bool):Bool {
		if (!v) textColor = 0xffffffff;
		return rainbowEnabled = v;
	}
	public var os:String = '';

	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;

		currentlyFPS = 0;
		totalFPS = 0;
		selectable = false;
		mouseEnabled = false;
	 	defaultTextFormat = new TextFormat(null, #if android 14 #else 12 #end, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);
		if (rainbowEnabled) doRainbowThing();

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentlyFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentlyFPS > ClientPrefs.data.framerate) currentlyFPS = ClientPrefs.data.framerate;

		totalFPS = Math.round(currentlyFPS + currentCount / 8);
		if (currentlyFPS > ClientPrefs.data.framerate)
			currentlyFPS = ClientPrefs.data.framerate;
		if (totalFPS < 10)
			totalFPS = 0;

		if (LimeSystem.platformName == LimeSystem.platformVersion || LimeSystem.platformVersion == null)
			os = 'Platform: ${LimeSystem.platformName}' #if cpp + ' ${getArch()}' #end;
		else
			os = 'Platform: ${LimeSystem.platformName}' #if cpp + ' ${getArch()}' #end + ' - ${LimeSystem.platformVersion}';

		if (currentCount != cacheCount) {
			text =  currentlyFPS + " / " + totalFPS + " FPS";

			currentlyMemory = obtainMemory();
			if (currentlyMemory >= maximumMemory)
				maximumMemory = currentlyMemory;

			if (ClientPrefs.data.memory) {
				text += "\n" + CoolUtil.formatMemory(Std.int(currentlyMemory)) + " / " + CoolUtil.formatMemory(Std.int(maximumMemory));
			}

			if (ClientPrefs.data.engineVersion) {
				text += "\nEngine version: " + MainMenuState.sbEngineVersion + " (Modified Psych Engine " + MainMenuState.psychEngineVersion + ")";
			}

			if (ClientPrefs.data.debugInfo) {
				text += '\nState: ${Type.getClassName(Type.getClass(FlxG.state))}';
				if (FlxG.state.subState != null)
					text += '\nSubstate: ${Type.getClassName(Type.getClass(FlxG.state.subState))}';
				text += "\nGL Render: " + '${getGLInfo(RENDERER)}';
				text += "\nGL Shading version: " + '${getGLInfo(SHADING_LANGUAGE_VERSION)}';
				text += "\n" + os;
				text += "\nHaxe: " + Compiler.getDefine("haxe");
				text += "\n" + FlxG.VERSION;
				text += "\nOpenFL " + Compiler.getDefine("openfl");
				text += "\nLime: " + Compiler.getDefine("lime");
			}

			#if android
			if (ClientPrefs.data.debugInfo) text += "\nGo to options to enable/disable in-game logs";
			#else
			if (ClientPrefs.data.debugInfo) text += "\nPress F5 to see in-game logs";
			#end

			switch (ClientPrefs.data.gameStyle) {
				case 'SB Engine':
					Main.fpsVar.defaultTextFormat = new TextFormat('Bahnschrift', 14, color);
				
				case 'Kade Engine':
					Main.fpsVar.defaultTextFormat = new TextFormat('VCR OSD Mono', 14, color);
				
				case 'Dave and Bambi':
					Main.fpsVar.defaultTextFormat = new TextFormat('Comic Sans MS Bold', 14, color);
				
				case 'TGT Engine':
					Main.fpsVar.defaultTextFormat = new TextFormat('Calibri', 14, color);
				
				default:
					Main.fpsVar.defaultTextFormat = new TextFormat('_sans', 14, color);
			}

		if (ClientPrefs.data.redText) {
			if (currentlyFPS <= ClientPrefs.data.framerate / 2) {
				textColor = FlxColor.RED;
			}
		}

			text += "\n";
		}

		cacheCount = currentCount;
		set_rainbowEnabled(ClientPrefs.data.rainbowFPS);
	}

	function obtainMemory():Dynamic {
		return System.totalMemory;
	}

	public function getGLInfo(info:GLInfo):String {
		@:privateAccess
		var gl:Dynamic = Lib.current.stage.context3D.gl;

		switch (info) {
			case RENDERER:
				return Std.string(gl.getParameter(gl.RENDERER));
			case SHADING_LANGUAGE_VERSION:
				return Std.string(gl.getParameter(gl.SHADING_LANGUAGE_VERSION));
		}
		return '';
	}

	private var hue:Float = 0;
	private function doRainbowThing():Void {
		textColor = fromHSL({hue = (hue + (FlxG.elapsed * 100)) % 360; hue;}, 1, 0.8);
	}

	// function named fromHSL which takes a hue, saturation, and lightness value and returns a color (0xffRRGGBB)
	private static inline function fromHSL(h:Float, s:Float, l:Float) {
		h /= 360;
		var r:Float, g:Float, b:Float;
		if (s == 0.0) {
			r = g = b = l;
		} else {
			var q:Float = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
			var p:Float = 2.0 * l - q;
			r = hueToRGB(p, q, h + 1.0 / 3.0);
			g = hueToRGB(p, q, h);
			b = hueToRGB(p, q, h - 1.0 / 3.0);
		}
		return (Math.round(r * 255) << 16) + (Math.round(g * 255) << 8) + Math.round(b * 255);
	}

	// hueToRGB function
	private static inline function hueToRGB(p:Float, q:Float, h:Float) {
		if (h < 0.0) h += 1.0;
		if (h > 1.0) h -= 1.0;
		if (6.0 * h < 1.0) return p + (q - p) * 6.0 * h;
		if (2.0 * h < 1.0) return q;
		if (3.0 * h < 2.0) return p + (q - p) * ((2.0 / 3.0) - h) * 6.0;
		return p;
	}

	#if cpp
	#if windows
	@:functionCode('
		SYSTEM_INFO osInfo;

		GetSystemInfo(&osInfo);

		switch(osInfo.wProcessorArchitecture)
		{
			case 9:
				return ::String("x86_64");
			case 5:
				return ::String("ARM");
			case 12:
				return ::String("ARM64");
			case 6:
				return ::String("IA-64");
			case 0:
				return ::String("x86");
			default:
				return ::String("Unknown");
		}
	')
	#elseif mac
	@:functionCode('
		const NXArchInfo *archInfo = NXGetLocalArchInfo();
    	return ::String(archInfo == NULL ? "Unknown" : archInfo->name);
	')
	#else
	@:functionCode('
		struct utsname osInfo{};
		uname(&osInfo);
		return ::String(osInfo.machine);
	')
	#end

	@:noCompletion
	private function getArch():String
	{
		return null;
	}
	#end
}

enum GLInfo {
	RENDERER;
	SHADING_LANGUAGE_VERSION;
}
