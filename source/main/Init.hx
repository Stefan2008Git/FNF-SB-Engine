package main;

import flixel.FlxState;
import debug.FPS;
import openfl.Assets;
import states.FlashingState;
import states.LoadingMenuState;
import states.StoryMenuState;

#if linux
import lime.graphics.Image;
#end

class Init extends FlxState 
{
    override function create() 
    {
        FlxTransitionableState.skipNextTransOut = true;
        Paths.clearStoredMemory();

        if (Main.fpsVar == null) {
            Main.fpsVar = new FPS(10, 3);
            Lib.current.stage.addChild(Main.fpsVar);
        }

        // Mic'd Up SC code :D
        var bitmapData = Assets.getBitmapData("assets/images/sbinator.png");
		if (Main.watermark == null) {
            Main.watermark = new Sprite();
		    Main.watermark.addChild(new Bitmap(bitmapData)); // Sets the graphic of the sprite to a Bitmap object, which uses our embedded BitmapData class.
		    Main.watermark.alpha = 0.4;
		    Main.watermark.x = Lib.application.window.width - 10 - Main.watermark.width;
		    Main.watermark.y = Lib.application.window.height - 10 - Main.watermark.height;
            Lib.current.stage.addChild(Main.watermark);
        }

        #if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

        #if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

        FlxG.save.bind('sbFunkin', CoolUtil.getSavePath());

        ClientPrefs.loadPrefs();
        ClientPrefs.keybindSaveLoad();

        #if android
		FlxG.android.preventDefaultKeys = [BACK];
		removeVirtualPad();
		noCheckPress();
		#end

        #if !(flixel >= "5.4.0")
		FlxG.fixedTimestep = false;
		#end
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

        FlxG.updateFramerate = FlxG.drawFramerate = ClientPrefs.data.framerate;
        
        if (Main.fpsVar != null) Main.fpsVar.visible = ClientPrefs.data.showFPS;
        if (Main.watermark != null) Main.watermark.visible = ClientPrefs.data.watermarkIcon;

        #if LUA_ALLOWED
        Mods.pushGlobalMods();
		Mods.loadTopMod();
        #end

        #if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call)); #end
        Controls.instance = new Controls();
        ClientPrefs.loadDefaultKeys();
        Highscore.load();

        if (FlxG.save.data.weekCompleted != null) StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
        #if DISCORD_ALLOWED DiscordClient.prepare(); #end

        if(FlxG.save.data != null && FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;

        if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(() -> new FlashingState());
		} else {
            FlxTransitionableState.skipNextTransIn = true;
            FlxTransitionableState.skipNextTransOut = true;
			if (ClientPrefs.data.loadingScreen) FlxG.switchState(() -> new LoadingMenuState());
			else FlxG.switchState(Type.createInstance(Main.game.initialState, []));
		}
    }
}
