package main;

import debug.Screenshot;
import states.FlashingState;
import states.StoryMenuState;
import states.SBinatorState;

#if android
import android.Hardware;
#end

#if linux
import lime.graphics.Image;
#end

class Init extends FlxState 
{
    var mainBackground:FlxSprite;
    var mainIcon:FlxSprite;
    var background2:FlxSprite;
    var mainLogo:FlxSprite;
    var vibrationInt:Int = 500;
    var mainEngineText:FlxText;
    var poweredBy:String = '';

    override function create() 
    {
        FlxTransitionableState.skipNextTransOut = true;
        TraceText.makeTheTraceText("Welcome to modifed Psych Engine with some changes and additions called SB Engine made by Stefan2008. Enjoy <3!");

        #if DISCORD_ALLOWED
	    // Updating Discord Rich Presence
	    DiscordClient.changePresence("Starting SB Engine...", null);
	    #end

        #if android
        poweredBy = 'Android';
        #elseif linux
        poweredBy = 'Linux';
        #elseif macos
        poweredBy = 'MacOS';
        #elseif windows
        poweredBy = 'Windows';
        #else
        poweredBy = 'Unknown';
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

        mainBackground = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        mainBackground.visible = false;
        add(mainBackground);

        mainIcon = new FlxSprite().loadGraphic(Paths.image("engineStuff/main/sbinator"));
        mainIcon.visible = false;
        mainIcon.scale.x = 1.2;
        mainIcon.scale.y = 1.2;
        mainIcon.screenCenter();
        add(mainIcon);

        mainEngineText = new FlxText(20, FlxG.height - 80, 1000, "Powered by:\n" + poweredBy, 10);
		mainEngineText.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		mainEngineText.visible = false;
		mainEngineText.screenCenter(X);
		add(mainEngineText);

        background2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BROWN);
        background2.alpha = 0;
        add(background2);

        mainLogo = new FlxSprite().loadGraphic(Paths.image("engineStuff/main/sbEngineLogo"));
		mainLogo.screenCenter();
		mainLogo.alpha = 0;
		add(mainLogo);

        new FlxTimer().start(1.5, function(tmr:FlxTimer) {
			#if android
            Hardware.vibrate(vibrationInt);
            #end
		});

        new FlxTimer().start(2.5, function(tmr:FlxTimer) {
			mainBackground.visible = true;
            mainIcon.visible = true;
            mainEngineText.visible = true;
		});

        new FlxTimer().start(13.5, function(tmr:FlxTimer) {
			mainBackground.visible = false;
            mainIcon.visible = false;
            mainEngineText.visible = false;
            FlxTween.tween(background2, {alpha: 1}, 1.3, {ease: FlxEase.sineInOut});
            FlxG.sound.play(Paths.sound('startup'));
		});

        new FlxTimer().start(14.5, function(tmr:FlxTimer) {
			FlxTween.tween(mainLogo, {alpha: 1}, 1.3, {ease: FlxEase.sineInOut});
		});

        new FlxTimer().start(17.5, function(tmr:FlxTimer) {
			FlxTween.tween(background2, {alpha: 0}, 1.2, {
				ease: FlxEase.sineInOut,
				onComplete: function(completition:FlxTween) {
					startLoadingProcess();
				}
			});
		});

        new FlxTimer().start(17.5, function(tmr:FlxTimer) {
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
