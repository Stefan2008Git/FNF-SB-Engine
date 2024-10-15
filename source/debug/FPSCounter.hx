package debug;

import debug.Memory;
import haxe.macro.Compiler;
import flixel.util.FlxStringUtil;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import lime.system.System;

enum GLInfo {
	RENDERER;
	SHADING_LANGUAGE_VERSION;
}

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if cpp
#if windows
@:cppFileCode('#include <windows.h>')
#elseif (ios || mac)
@:cppFileCode('#include <mach-o/arch.h>')
#else
@:headerInclude('sys/utsname.h')
#end
#end
class FPSCounter extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	public var totalFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var currentMemory:Float;
	public var maxMemory:Float;

	@:noCompletion private var times:Array<Float>;

	public var os:String = '';

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		os = 'OS: ${System.platformLabel} ${System.platformVersion} - ' #if cpp + '${getArch() != 'Unknown' ? getArch() : ''}' #end;

		positionFPS(x, y);

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
		width = FlxG.width;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		// prevents the overlay from updating every frame, why would you need to anyways
		if (deltaTimeout < 10) {
			deltaTimeout += deltaTime;
			return;
		}

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
		
		totalFPS = Math.round(currentFPS + times.length / 8); 
		if (currentFPS >= totalFPS) totalFPS = currentFPS;

		currentMemory = Memory.obtainMemory();
		if (currentMemory >= maxMemory) maxMemory = currentMemory;

		updateText();
		deltaTimeout = 0.0;
	}

	public dynamic function updateText():Void // so people can override it in hscript
	{
		text = Math.round(currentFPS) + (ClientPrefs.data.totalFPS ? " / " + Math.round(totalFPS) : "") + " FPS" + " [" + Std.int((1 / currentFPS) * 1000) + "ms]";

		if (ClientPrefs.data.memory) text += "\n" + FlxStringUtil.formatBytes(currentMemory) + (ClientPrefs.data.maxMemory ? " / " + FlxStringUtil.formatBytes(maxMemory) : "");

		if (ClientPrefs.data.engineVersion) text += "\nv" + MainMenuState.sbEngineVersion;

		if (ClientPrefs.data.osInfo) text += "\n" + os;

		textColor = 0xFFFFFFFF;
		if (ClientPrefs.data.framerateColor) {
			if (currentFPS <= FlxG.drawFramerate / 2 && currentFPS >= FlxG.drawFramerate / 3) textColor = FlxColor.YELLOW;
			else if (currentFPS <= FlxG.drawFramerate / 3 && currentFPS >= FlxG.drawFramerate / 4) textColor = FlxColor.ORANGE;
			else if (currentFPS < FlxG.drawFramerate * 0.5) textColor = FlxColor.RED;
		}
	}

	public function getGLInfo(info:GLInfo):String 
	{
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

	public inline function positionFPS(X:Float, Y:Float, ?scale:Float = 1){
		scaleX = scaleY = (scale > 1 ? scale : 1);
		x = FlxG.game.x + X;
		y = FlxG.game.y + Y;
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
	#elseif (ios || mac)
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
		return "Unknown";
	}
	#end

	/*
	text += '\nState: ${Type.getClassName(Type.getClass(FlxG.state))}';
	if (FlxG.state.subState != null) text += '\nSubstate: ${Type.getClassName(Type.getClass(FlxG.state.subState))}';
	text += "\nGL Render: " + '${getGLInfo(RENDERER)}';
	text += "\nGL Shading version: " + '${getGLInfo(SHADING_LANGUAGE_VERSION)}';
	text += "\nHaxe: " + Compiler.getDefine("haxe");
	text += "\n" + FlxG.VERSION;
	text += "\nOpenFL " + Compiler.getDefine("openfl");
	text += "\nLime: " + Compiler.getDefine("lime"); I will see for this until now i have to make it blank*/
}
