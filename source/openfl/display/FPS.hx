package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end

import states.MainMenuState;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
enum GLInfo {
	RENDERER;
	SHADING_LANGUAGE_VERSION;
}
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentlyFPS(default, null):Int;
	public var totalFPS(default, null):Int;

	public var currentlyMemory:Float;
	public var maximumMemory:Float;
	public var realAlpha:Float = 1;
	public var redText:Bool = false;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentlyFPS = 0;
		totalFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
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

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var minAlpha:Float = 0.5;
		var aggressor:Float = 1;

		if (!redText)
			realAlpha = CoolUtil.boundTo(realAlpha - (deltaTime / 1000) * aggressor, minAlpha, 1);
		else
			realAlpha = CoolUtil.boundTo(realAlpha + (deltaTime / 1000), 0.3, 1);

		var currentCount = times.length;
		currentlyFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentlyFPS > ClientPrefs.data.framerate) currentlyFPS = ClientPrefs.data.framerate;

		totalFPS = Math.round(currentlyFPS + currentCount / 8);
		if (currentlyFPS > ClientPrefs.data.framerate)
			currentlyFPS = ClientPrefs.data.framerate;
		if (totalFPS < 10)
			totalFPS = 0;

		if (currentCount != cacheCount) {
			text = "FPS: " + currentlyFPS;

			currentlyMemory = obtainMemory();
			if (currentlyMemory >= maximumMemory)
				maximumMemory = currentlyMemory;

			if (ClientPrefs.data.showTotalFPS) {
				text += "\nTotal FPS: " + totalFPS;
			}

			if (ClientPrefs.data.memory) {
				text += "\nMemory: " + CoolUtil.formatMemory(Std.int(currentlyMemory));
			}

			if (ClientPrefs.data.totalMemory) {
				text += "\nMemory peak: " + CoolUtil.formatMemory(Std.int(maximumMemory));
			}

			if (ClientPrefs.data.engineVersion) {
				text += "\nEngine version: " + MainMenuState.sbEngineVersion + " (PE " + MainMenuState.psychEngineVersion + ")";
			}

			if (ClientPrefs.data.debugInfo) {
				text += '\nState: ${Type.getClassName(Type.getClass(FlxG.state))}';
				if (FlxG.state.subState != null)
					text += '\nSubstate: ${Type.getClassName(Type.getClass(FlxG.state.subState))}';
				text += "\nSystem: " + '${lime.system.System.platformLabel} ${lime.system.System.platformVersion}';
				text += "\nGL Render: " + '${getGLInfo(RENDERER)}';
				text += "\nGL Shading version: " + '${getGLInfo(SHADING_LANGUAGE_VERSION)})';
			}

			textColor = FlxColor.fromRGBFloat(255, 255, 255, realAlpha);
			if (currentlyFPS <= ClientPrefs.data.framerate / 2) {
				textColor = FlxColor.fromRGBFloat(255, 0, 0, realAlpha);
				redText = true;
			}

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end

			text += "\n";
		}

		cacheCount = currentCount;
	}

	function obtainMemory():Dynamic {
		return System.totalMemory;
	}

	private function getGLInfo(info:GLInfo):String {
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
}
