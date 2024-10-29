package main;

import backend.Discord;
import backend.Highscore;
import flixel.FlxState;
import debug.FPSCounter;
import debug.Screenshot;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import states.FlashingState;
import states.StoryMenuState;
import states.SBinatorState;
import states.TitleState;

#if mobile
import mobile.backend.MobileScaleMode;
import mobile.objects.MobileControls;
#end

#if linux
import lime.graphics.Image;
#end

class Init extends FlxState 
{
    override function create():Void
    {
		super.create();

        FlxTransitionableState.skipNextTransOut = true;

        #if DISCORD_ALLOWED
	    // Updating Discord Rich Presence
	    DiscordClient.changePresence("Starting SB Engine...", null);
	    #end

        Paths.clearStoredMemory();

        if (Main.fpsVar == null) {
            Main.fpsVar = new FPSCounter(10, 3);
            Lib.current.stage.addChild(Main.fpsVar);
        }

        #if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

        FlxG.mouse.visible = false;

		#if html5
		FlxG.autoPause = false;
		#end

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = #if mobile 30 #else 60 #end;
		#if web
		FlxG.keys.preventDefaultKeys.push(TAB);
		#else
		FlxG.keys.preventDefaultKeys = [TAB];
		#end

		#if DISCORD_ALLOWED
		DiscordClient.prepare();
		#end
		MobileControls.initSave();

		#if android FlxG.android.preventDefaultKeys = [BACK]; #end
        
        if (Main.fpsVar != null) 
            Main.fpsVar.visible = ClientPrefs.data.showFPS;
            Main.fpsVar.alpha = 0;
            Main.fpsVar.scaleX = Main.fpsVar.scaleY = ClientPrefs.data.fpsResize;

        #if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		Highscore.load();

        if (ClientPrefs.data.screenshot) Screenshot.initialize();

		#if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call)); #end
		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end

        if (FlxG.save.data.weekCompleted != null) StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;

        if(FlxG.save.data != null && FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;

        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;

        final stateClass:Class<FlxState> = (ClientPrefs.defaultData.startupScreen) ? states.SBinatorState : states.TitleState;
        FlxG.switchState(Type.createInstance(stateClass, []));
    }
}
