package;

import debug.FPSCounter;
import main.Init;
import backend.Highscore;
import flixel.FlxGame;
import haxe.io.Path;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import states.TitleState;
import openfl.events.KeyboardEvent;
import lime.system.System as LimeSystem;
#if mobile
import mobile.states.CopyState;
#end

#if linux
import lime.graphics.Image;

@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends Sprite
{
	public static var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var fpsVar:FPSCounter;

	public static final platform:String = #if mobile "Phones" #else "PCs" #end;

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
		#if mobile
		#if android
		StorageUtil.requestPermissions();
		#end
		Sys.setCwd(StorageUtil.getStorageDirectory());
		#end
		backend.CrashHandler.init();

		#if desktop Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " (Psych Engine v" + MainMenuState.psychEngineVersion + ")"; #end
		#if android 
		if (AndroidTools.isRooted())
		{
			AndroidToast.makeText("Welcome to FNF': SB Engine v" + MainMenuState.sbEngineVersion + "\nRoot is detected on your " + AndroidBuild.BUILD + " device!", 1, -1, 0, 0);
		} else {
			AndroidToast.makeText("Welcome to FNF': SB Engine v" + MainMenuState.sbEngineVersion, 1, -1, 0, 0); 
		} 
		#end

		#if windows
		@:functionCode("
			#include <windows.h>
			#include <winuser.h>
			setProcessDPIAware() // allows for more crisp visuals
			DisableProcessWindowsGhosting() // lets you move the window and such if it's not responding
		")
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		#if VIDEOS_ALLOWED
		hxvlc.util.Handle.init(#if (hxvlc >= "1.8.0")  ['--no-lua'] #end);
		#end
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		#if (openfl <= "9.2.0")
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
		#else
		if (game.zoom == -1.0)
			game.zoom = 1.0;
		#end

		var game:FlxGame = new FlxGame(game.width, game.height, #if (mobile && MODS_ALLOWED) CopyState.checkExistingFiles() ? Init : CopyState #else Init #end, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.skipSplash, game.startFullscreen);
		@:privateAccess
		game._customSoundTray = backend.FunkinSoundTray;
		addChild(game);

		#if desktop FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, toggleFullScreen); #end

		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		// shader coords fix
		FlxG.signals.gameResized.add(function (w, h) {
			if(fpsVar != null)
				fpsVar.positionFPS(10, 3, Math.min(w / FlxG.width, h / FlxG.height));
		     if (FlxG.cameras != null) {
			   for (cam in FlxG.cameras.list) {
				if (cam != null && cam.filters != null)
					resetSpriteCache(cam.flashSprite);
			   }
			}

			if (FlxG.game != null)
			resetSpriteCache(FlxG.game);
		});

		#if desktop
		if (ClientPrefs.data.autoPause) {
			Application.current.window.onFocusOut.add(onWindowFocusOut);
			Application.current.window.onFocusIn.add(onWindowFocusIn);
		}
		#end
	}

	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
		        sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	function toggleFullScreen(event:KeyboardEvent) {
		if(Controls.instance.justReleased('fullscreen'))
			FlxG.fullscreen = !FlxG.fullscreen;
	}

	// Similar from Sanic's Psych Engine 0.3.2h fork...
	public static function tweenFPS(visible:Bool = true, duration:Float = 1.5)
	{
		if (ClientPrefs.data.showFPS && fpsVar != null) if (visible) FlxTween.tween(fpsVar, {alpha: 1}, duration); else FlxTween.tween(fpsVar, {alpha: 0}, duration);
	}

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
