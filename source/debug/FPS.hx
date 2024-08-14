package debug;


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

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/

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

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public var os:String = '';

	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
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

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;

		totalFPS = Math.round(currentFPS + currentCount / 8);
		if (totalFPS < 10) totalFPS = 0;

		if (LimeSystem.platformName == LimeSystem.platformVersion || LimeSystem.platformVersion == null) os = 'Platform: ${LimeSystem.platformName}' #if cpp + ' ${getArch()}' #end; else os = 'Platform: ${LimeSystem.platformName} ${LimeSystem.platformVersion}' #if cpp + ' - ${getArch()}' #end;

		if (currentCount != cacheCount) {
			text = '$currentFPS / $totalFPS FPS';

			currentMemory = obtainMemory();
			if (currentMemory >= maxMemory) maxMemory = currentMemory;

			if (ClientPrefs.data.memory) text += "\n" + CoolUtil.formatMemory(Std.int(currentMemory)) + " / " + CoolUtil.formatMemory(Std.int(maxMemory));

			if (ClientPrefs.data.engineVersion) text += "\nEngine version: " + MainMenuState.sbEngineVersion + " (Modified Psych Engine " + MainMenuState.psychEngineVersion + ")";

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

			if (ClientPrefs.data.inGameLogs) #if android text += '\n${Main.gameLogs.logData.length} traced lines. Release BACK to view.'; #else text += '\n${Main.gameLogs.logData.length} traced lines. Press F3 to view.'; #end

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
			if (currentFPS <= ClientPrefs.data.framerate / 2) {
				textColor = FlxColor.RED;
			}
		}

		text += "\n";
		}

		cacheCount = currentCount;
	}

	function obtainMemory():Dynamic {
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
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
