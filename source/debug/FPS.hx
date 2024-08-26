package debug;

import debug.Memory;
import lime.system.System as LimeSystem;

#if cpp
#if windows
@:cppFileCode('#include <windows.h>')
#elseif mac
@:cppFileCode('#include <mach-o/arch.h>')
#else
@:headerInclude('sys/utsname.h')
#end
#end

class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	public var totalFPS(default, null):Int;

	public var currentMemory:Float;
	public var maxMemory:Float;
	public var color:Int = FlxColor.WHITE;

	@:noCompletion private var times:Array<Float>;

	public var os:String = '';

	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		if (LimeSystem.platformName == LimeSystem.platformVersion || LimeSystem.platformVersion == null)
			os = '\nPlatform: ${LimeSystem.platformName}' #if cpp + ' ${getArch() != 'Unknown' ? getArch() : ''}' #end;
		else
			os = '\nPlatform: ${LimeSystem.platformName} ${LimeSystem.platformVersion}' #if cpp + ' - ${getArch() != 'Unknown' ? getArch() : ''}' #end;

		positionCounter(x, y);

		currentFPS = 0;
		totalFPS = 0;
		selectable = false;
		mouseEnabled = false;
	 	defaultTextFormat = new TextFormat(null, #if android 14 #else 12 #end, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		// prevents the overlay from updating every frame, why would you need to anyways
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;

		totalFPS = Math.round(currentFPS + times.length / 8); 
		if (currentFPS >= totalFPS) totalFPS = currentFPS;

		currentMemory = Memory.obtainMemory();
		if (currentMemory >= maxMemory) maxMemory = currentMemory;

		updateText();
		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void
	{
		text = "FPS: " + Math.round(currentFPS) + (ClientPrefs.data.totalFPS ? " / " + Math.round(totalFPS) : "");

		if (ClientPrefs.data.memory) text += "\nMemory: " + FlxStringUtil.formatBytes(currentMemory) + (ClientPrefs.data.maxMemory ? " / " + FlxStringUtil.formatBytes(maxMemory) : "");

		if (ClientPrefs.data.engineVersion) text += "\nEngine version: " + MainMenuState.sbEngineVersion;

		if (ClientPrefs.data.debugInfo) {
			text += '\nState: ${Type.getClassName(Type.getClass(FlxG.state))}';
			if (FlxG.state.subState != null) text += '\nSubstate: ${Type.getClassName(Type.getClass(FlxG.state.subState))}';
			text += "\nGL Render: " + '${getGLInfo(RENDERER)}';
			text += "\nGL Shading version: " + '${getGLInfo(SHADING_LANGUAGE_VERSION)}';
			text += os;
			text += "\nHaxe: " + Compiler.getDefine("haxe");
			text += "\n" + FlxG.VERSION;
			text += "\nOpenFL " + Compiler.getDefine("openfl");
			text += "\nLime: " + Compiler.getDefine("lime");
		}

		if (ClientPrefs.data.inGameLogs) #if android text += '\n${Main.gameLogs.logData.length} traced lines. Release BACK to view.'; #else text += '\n${Main.gameLogs.logData.length} traced lines. Press F3 to view.'; #end

		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': Main.fpsVar.defaultTextFormat = new TextFormat('Bahnschrift', #if android 14 #else 12 #end, color);
			case 'Kade Engine': Main.fpsVar.defaultTextFormat = new TextFormat('VCR OSD Mono', #if android 14 #else 12 #end, color);
			case 'Dave and Bambi': Main.fpsVar.defaultTextFormat = new TextFormat('Comic Sans MS Bold', #if android 14 #else 12 #end, color);
			case 'TGT Engine': Main.fpsVar.defaultTextFormat = new TextFormat('Calibri', #if android 14 #else 12 #end, color);
			default: Main.fpsVar.defaultTextFormat = new TextFormat('_sans', #if android 14 #else 12 #end, color);
		}

		if (ClientPrefs.data.redText) {
			if (currentFPS <= FlxG.drawFramerate / 2 && currentFPS >= FlxG.drawFramerate / 3) textColor = FlxColor.YELLOW;
			else if (currentFPS <= FlxG.drawFramerate / 3 && currentFPS >= FlxG.drawFramerate / 4) textColor = FlxColor.ORANGE;
			else if (currentFPS < FlxG.drawFramerate * 0.5) textColor = FlxColor.RED;
	    }
	}

	public inline function positionCounter(X:Float, Y:Float, ?scale:Float = 1)
	{
		scaleX = scaleY = #if android (scale > 1 ? scale : 1) #else (scale < 1 ? scale : 1) #end;
		x = FlxG.game.x + X;
		y = FlxG.game.y + Y;
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
}

enum GLInfo {
	RENDERER;
	SHADING_LANGUAGE_VERSION;
}
