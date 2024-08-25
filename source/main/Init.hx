package main;

import debug.Screenshot;
import states.FlashingState;
import states.StoryMenuState;
import states.SBinatorState;

#if linux
import lime.graphics.Image;
#end

class Init extends FlxState 
{
    var background:FlxSprite;
    var mainLogo:FlxSprite;
    var startupSound:FlxSound;

    override function create() 
    {
        FlxTransitionableState.skipNextTransOut = true;
        TraceText.makeTheTraceText("Welcome to modifed Psych Engine with some changes and additions called SB Engine made by Stefan2008. Enjoy <3!");

        #if DISCORD_ALLOWED
	    // Updating Discord Rich Presence
	    DiscordClient.changePresence("Starting SB Engine...", null);
	    #end

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

        background = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BROWN);
        background.alpha = 0;
		FlxTween.tween(background, {alpha: 1}, 1.3, {ease: FlxEase.sineInOut});
        add(background);

        mainLogo = new FlxSprite().loadGraphic(Paths.image("engineStuff/main/sbEngineLogo"));
		mainLogo.screenCenter();
		mainLogo.alpha = 0;
		FlxTween.tween(mainLogo, {alpha: 1}, 2.6, {ease: FlxEase.sineInOut});
		add(mainLogo);

        FlxG.sound.play(Paths.sound('startup'));

        new FlxTimer().start(4.7, function(tmr:FlxTimer) {
			FlxTween.tween(background, {alpha: 0}, 1.2, {
				ease: FlxEase.sineInOut,
				onComplete: function(completition:FlxTween) {
					startLoadingProcess();
				}
			});
		});

        new FlxTimer().start(4.7, function(tmr:FlxTimer) {
			FlxTween.tween(mainLogo, {alpha: 0}, 1.2, {
				ease: FlxEase.sineInOut,
				onComplete: function(completition:FlxTween) {
					startLoadingProcess();
				}
			});
		});

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

        #if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

        #if !(flixel >= "5.4.0")
		FlxG.fixedTimestep = false;
		#end
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

        FlxG.updateFramerate = FlxG.drawFramerate = ClientPrefs.data.framerate;
        
        if (Main.fpsVar != null) 
            Main.fpsVar.visible = ClientPrefs.data.showFPS;
            Main.fpsVar.alpha = 0;
            Main.fpsVar.scaleX = Main.fpsVar.scaleY = ClientPrefs.data.fpsResize;

        if (Main.watermark != null) 
            Main.watermark.visible = ClientPrefs.data.watermarkIcon;
            Main.watermark.alpha = 0;
            Main.watermark.scaleX = Main.watermark.scaleY = ClientPrefs.data.iconResize;

        #if LUA_ALLOWED
        Mods.pushGlobalMods();
		Mods.loadTopMod();
        #end

        #if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call)); #end
        Controls.instance = new Controls();
        ClientPrefs.loadDefaultKeys();
        Highscore.load();
        Screenshot.initialize();

        if (FlxG.save.data.weekCompleted != null) StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
        #if DISCORD_ALLOWED DiscordClient.prepare(); #end

        if(FlxG.save.data != null && FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;

        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;
    }

    function startLoadingProcess()
    {
        if (ClientPrefs.data.loadingScreen) FlxG.switchState(() -> new SBinatorState());
        else FlxG.switchState(Type.createInstance(Main.game.initialState, []));
    }
}
