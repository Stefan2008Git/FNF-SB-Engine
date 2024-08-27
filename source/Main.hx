package;

import debug.FPS;
import debug.GameLog;
import main.Init;
import objects.VolumeTray;
import states.TitleState;
#if android
import android.Hardware;
import android.backend.AndroidDialogsExtend;
import android.backend.StorageUtil;
#end

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('#define GAMEMODE_AUTO')
#end

class Main extends Sprite
{
	public static var game = {
		width: 1280,
		height: 720,
		initialState: TitleState,
		zoom: -1.0,
		framerate: 60,
		skipSplash: true,
		startFullscreen: false
	};

	public static var gameLogs:GameLog;
	public static var fpsVar:FPS;
	public static var watermark:Sprite;
	public static var toastText:String = '';
	public static var checkingToastMessage:Bool = false;
	public static var vibrationInt:Int = 500;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
		#if cpp
		cpp.NativeGc.enable(true);
		#elseif hl
		hl.Gc.enable(true);
		#end
	}

	public function new()
	{
		super();

		#if android StorageUtil.doTheCheck(); #end

		#if windows
		@:functionCode("
		#include <windows.h>
		#include <winuser.h>
		setProcessDPIAware() // allows for more crisp visuals
		DisableProcessWindowsGhosting() // lets you move the window and such if it's not responding
		")
		#end

		if (stage != null) init(); else addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, init);
		setupGame();
	}

	private function setupGame():Void
	{
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion;
		#if android AndroidDialogsExtend.openToastBox("Welcome to: FNF': SB Engine v" + MainMenuState.sbEngineVersion, 1); #end// For some reason i cannot make a option to disable toast box when you open the game it crashes immediately...

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		Application.current.onExit.add(function(exitCode)
		{
			ClientPrefs.onExitFunction();
			#if DISCORD_ALLOWED DiscordClient.shutdown(); #end
			ClientPrefs.saveSettings();
		});

		var mainGame:FlxGame = new FlxGame(#if android 1280, 720, #else game.width, game.height, #end Init, #if android 60, 60, #else game.framerate, game.framerate, #end game.skipSplash, game.startFullscreen);
		#if desktop @:privateAccess mainGame._customSoundTray = VolumeTray; #end
		addChild(mainGame);

		gameLogs = new GameLog();
		GameLog.startInit();
		addChild(gameLogs);

		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		#if CRASH_HANDLER Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash); #end
		#if desktop FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, toggleFullScreen); #end
		#if desktop FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, refreshTheGame); #end
		#if android lime.system.System.allowScreenTimeout = ClientPrefs.data.screenSaver; #end // It cannot recognize which class file is using becase Lime and OpenFL have the same class directory and name, so i have to add back the import!!! --Stefan2008

		// shader coords fix
		FlxG.signals.gameResized.add(function (w, h) 
		{
			if(fpsVar != null) fpsVar.positionCounter(10, 3, Math.min(w / FlxG.width, h / FlxG.height));

		    if (FlxG.cameras != null)
			{
				for (cam in FlxG.cameras.list) 
				{
			    	@:privateAccess if (cam != null && cam.filters != null) resetSpriteCache(cam.flashSprite);
			    }
		    }

		    if (FlxG.game != null) resetSpriteCache(FlxG.game);
		});

		#if desktop
		if (ClientPrefs.data.autoPause) {
			Application.current.window.onFocusOut.add(onWindowFocusOut);
		Application.current.window.onFocusIn.add(onWindowFocusIn);
		}
		#end
	}

	static function resetSpriteCache(sprite:Sprite):Void 
	{
		@:privateAccess {
		        sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	function toggleFullScreen(event:KeyboardEvent):Void 
	{
		if(Controls.instance.justReleased('full_screen')) FlxG.fullscreen = !FlxG.fullscreen;
	}

	function refreshTheGame(event:KeyboardEvent):Void 
	{
		if(Controls.instance.justReleased('refresh_game')) FlxG.resetState();
	}

	// Similar from Sanic's Psych Engine 0.3.2h fork...
	public static function tweenFPS(visible:Bool = true, duration:Float = 1.5)
	{
		if (ClientPrefs.data.showFPS && fpsVar != null) if (visible) FlxTween.tween(fpsVar, {alpha: 1}, duration); else FlxTween.tween(fpsVar, {alpha: 0}, duration);
	}

	public static function tweenWatermark(visible:Bool = true, duration:Float = 1.5)
	{
		if (ClientPrefs.data.watermarkIcon && watermark != null) if (visible) FlxTween.tween(watermark, {alpha: 0.4}, duration); else FlxTween.tween(watermark, {alpha: 0}, duration);
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real he is not getting enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errorMessage:String = "";
		var extraErrorMessage:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = StorageUtil.getPath() + "./crash/" + "SB Engine_" + dateNow + ".log";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errorMessage += file + " (Line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errorMessage += e.error + "\nPlease report this error to the GitHub page: https://github.com/Stefan2008Git/FNF-SB-Engine\n\n> Crash Handler written by: sqirra-rng";
		extraErrorMessage += e.error + "\n\n=====================\nSBinator Crash Report\n=====================\n\nGenerated by: Friday Night Funkin' SB Engine - " + MainMenuState.sbEngineVersion + " (" + MainMenuState.psychEngineVersion + ")" + "\nSystem timestamp: " + Date.now().toString() + "\nDriver info: " + Main.fpsVar.getGLInfo(RENDERER) + "\n" + Main.fpsVar.os + "\nRender method: " + FlxG.renderMethod + "\n\n=====================\n";

		if (!FileSystem.exists(StorageUtil.getPath() + "crash/")) FileSystem.createDirectory(StorageUtil.getPath() + "crash/");
		File.saveContent(path, extraErrorMessage + "\n");

		Sys.println("Crash dump saved in " + Path.normalize(path));

		#if android
		if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox('Fatal Uncaugth Expection happened!', 1);
		if (ClientPrefs.data.vibration) Hardware.vibrate(vibrationInt);
		#end

		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound('error'));
		// if (ClientPrefs.data.betterCrashHandler) openSubState(new substates.system.CrashHandlerSubstate()); else UNFINISHED!!!!!
		Application.current.window.alert(errorMessage, "Fatal Uncaugth Expection! SB Engine v" + MainMenuState.sbEngineVersion);

		#if DISCORD_ALLOWED
		DiscordClient.shutdown();
		#end
		Sys.exit(1);
	}
	#end

	var focusMusicTween:FlxTween;
	var lowFramerate:Int = 20;
	function onWindowFocusOut() 
	{
		if(focusMusicTween != null) focusMusicTween.cancel();
		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: 0.3}, 0.5);

		FlxG.drawFramerate = lowFramerate;
	}

	function onWindowFocusIn() 
	{
		if(focusMusicTween != null) focusMusicTween.cancel();
		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: 1.0}, 0.5);
	
		FlxG.drawFramerate = ClientPrefs.data.framerate;
	}
}
