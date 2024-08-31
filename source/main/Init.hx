package main;

import backend.Discord;
import backend.Highscore;
import flixel.FlxState;
import debug.WatermarkCounter;
import debug.FPSCounter;
import debug.Screenshot;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import states.FlashingState;
import states.StoryMenuState;
import states.SBinatorState;

#if mobile
import mobile.backend.MobileScaleMode;
import mobile.objects.MobileControls;
import mobile.states.CopyState;
import lime.ui.Haptic;
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
        trace("Welcome to modifed Psych Engine with some changes and additions called SB Engine made by Stefan2008. Enjoy <3!");

        #if DISCORD_ALLOWED
	    // Updating Discord Rich Presence
	    DiscordClient.changePresence("Starting SB Engine...", null);
	    #end

        #if android
        poweredBy = 'Android';
        #elseif linux
        poweredBy = 'Linux';
        #elseif ios
        poweredBy = 'iOS';
        #elseif macos
        poweredBy = 'MacOS';
        #elseif windows
        poweredBy = 'Windows';
        #else
        poweredBy = 'Unknown';
        #end

        Paths.clearStoredMemory();

        if (Main.fpsVar == null) {
            Main.fpsVar = new FPSCounter(10, 3);
            Lib.current.stage.addChild(Main.fpsVar);
        }

        mainBackground = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        mainBackground.visible = false;
        add(mainBackground);

        mainIcon = new FlxSprite().loadGraphic(Paths.image("engineStuff/main/sbinator"));
        mainIcon.visible = false;
        mainIcon.scale.x = 1.5;
        mainIcon.scale.y = 1.5;
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
            #if mobile
			Haptic.vibrate(0, 500);
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
            FlxG.sound.play(Paths.sound('engineStuff/startup'));
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

        Screenshot.initialize();

		#if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call)); #end
		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end

        if (FlxG.save.data.weekCompleted != null) StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;

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