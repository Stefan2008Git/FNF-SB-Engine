package;

import openfl.events.KeyboardEvent;
import flixel.graphics.FlxGraphic;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import debug.GameLog;
import debug.FPS;
import main.Init;
import states.TitleState;
#if android
import android.Hardware;
import android.backend.AndroidDialogsExtend;
import android.backend.SUtil;
import lime.system.System;
#end

//crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import haxe.macro.Compiler;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
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
		#if (cpp && !android)
		cpp.NativeGc.enable(true);
		#elseif hl
		hl.Gc.enable(true);
		#end
	}

	public function new()
	{
		super();

		#if android SUtil.doTheCheck(); #end

		#if windows
		@:functionCode("
		#include <windows.h>
		#include <winuser.h>
		setProcessDPIAware() // allows for more crisp visuals
		DisableProcessWindowsGhosting() // lets you move the window and such if it's not responding
		")
		#end

		if (stage != null) init(); else addEventListener(Event.ADDED_TO_STAGE, init);
		#if VIDEOS_ALLOWED
		hxvlc.util.Handle.init();
		#end
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, init);
		initDeviceWindow(FlxG.stage.application.window.width, FlxG.stage.application.window.height);
		setupGame();
	}

	// CDEV Engine fixable resolution for Android target made by CoreCat OFC
	public function initDeviceWindow(width:Int, height:Int):Void {
		#if mobile
		trace("Init: Device Window - Mobile");
		FlxG.fullscreen = true;
		trace("Init: Device Window - Fullscreen");
        var targetAspectRatio:Float = width / height;
        trace("Init: Device Window - Target Aspect Ratio: " + targetAspectRatio);
        var gameAspectRatio:Float = game.width / game.height;
		trace("Init: Device Window - Game Aspect Ratio: " + targetAspectRatio);
        if (targetAspectRatio > gameAspectRatio) {
			trace("Init: Device Window - Target Aspect Ratio is bigger than Game's");
			trace("Init: Device Window - Old GameRes Width: " + game.width);
            game.width = Math.round(game.height * targetAspectRatio);
			trace("Init: Device Window - New GameRes Width: " + game.width);

        } else {
			trace("Init: Device Window - Game Aspect Ratio is bigger than Target's");
			trace("Init: Device Window - Old GameRes Height: " + game.height);
            game.height = Math.round(game.width / targetAspectRatio);
			trace("Init: Device Window - New GameRes Height: " + game.height);
        }
		trace("Init: Device Window - Finished.");
		#end
    }

	private function setupGame():Void
	{
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion;
		#if android AndroidDialogsExtend.openToastBox("Welcome to: FNF': SB Engine v" + MainMenuState.sbEngineVersion, 1); #end// For some wierd reason i cannot make a option to disable toast box when you open the game it crashes immediately...

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

		addChild(new FlxGame(#if android 1280, 720, #else game.width, game.height, #end Init, #if android 60, 60, #else game.framerate, game.framerate, #end game.skipSplash, game.startFullscreen));

		gameLogs = new GameLog();
		GameLog.startInit();
		addChild(gameLogs);

		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		#if CRASH_HANDLER Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash); #end
		#if desktop FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, toggleFullScreen); #end
		#if android System.allowScreenTimeout = ClientPrefs.data.screenSaver; #end

		// shader coords fix
		FlxG.signals.gameResized.add(function (w, h) {
		     if (FlxG.cameras != null) {
			   for (cam in FlxG.cameras.list) {
				@:privateAccess
				if (cam != null && cam.filters != null)
					resetSpriteCache(cam.flashSprite);
			   }
		     }

		     if (FlxG.game != null)
			 resetSpriteCache(FlxG.game);
		});

		#if debug
		FlxG.console.registerClass(openfl.utils.Assets);
		#end
	}

	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
		        sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	function toggleFullScreen(event:KeyboardEvent):Void {
		if(Controls.instance.justReleased('full_screen'))
			FlxG.fullscreen = !FlxG.fullscreen;
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real he is not getting enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errorMessage:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = SUtil.getPath() + "./crash/" + "SB Engine_" + dateNow + ".log";

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

		errorMessage += e.error + "\n\n=====================\nSBinator Crash Report\n=====================\n\nGenerated by: Friday Night Funkin' SB Engine - " + MainMenuState.sbEngineVersion + " (" + MainMenuState.psychEngineVersion + ")" + "\nSystem timestamp: " + Date.now().toString() + "\nDriver info: " + Main.fpsVar.getGLInfo(RENDERER) + "\n" + Main.fpsVar.os + "\nRender method: " + FlxG.renderMethod + "\n\n=====================\n\n" + "Please report this error to the GitHub page: https://github.com/Stefan2008Git/FNF-SB-Engine\n> Crash Handler written by: sqirra-rng";

		if (!FileSystem.exists(SUtil.getPath() + "crash/")) FileSystem.createDirectory(SUtil.getPath() + "crash/");
		File.saveContent(path, errorMessage + "\n");

		Sys.println("Crash dump saved in " + Path.normalize(path));

		#if android
		if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox('Uncaught Error happends!', 1);
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

	static function renderMethod():String
	{
		try
		{
			return switch (FlxG.renderMethod)
			{
				case FlxRenderMethod.DRAW_TILES: 'DRAW_TILES';
				case FlxRenderMethod.BLITTING: 'BLITTING';
				default: 'UNKNOWN';
			}
		  }
		catch (e)
		{
			return 'ERROR ON QUERY RENDER METHOD: ${e}';
		}
	}
}
