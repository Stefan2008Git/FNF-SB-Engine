package main;

class InitGoodbye extends FlxState
{
    var background:FlxSprite;
    var mainLogo:FlxSprite;

    override function create()
    {
        Main.tweenFPS(false);
		Main.tweenWatermark(false);
        Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Goodbye...";

        if (FlxG.sound.music != null) FlxTween.tween(FlxG.sound.music, {pitch: 0, volume: 0}, 2.5, {ease: FlxEase.sineInOut});
        TraceText.makeTheTraceText("Closing the entire engine.");

        new FlxTimer().start(0.5, function(tmr:FlxTimer) {
            TraceText.makeTheTraceText("Please wait..");
        });

        new FlxTimer().start(0.8, function(tmr:FlxTimer) {
            TraceText.makeTheTraceText("Please wait...");
        });

        new FlxTimer().start(1.3, function(tmr:FlxTimer) {
            TraceText.makeTheTraceText("Please wait....");
        });

        new FlxTimer().start(1.6, function(tmr:FlxTimer) {
            TraceText.makeTheTraceText("Please wait.....");
        });

        new FlxTimer().start(1.9, function(tmr:FlxTimer) {
            TraceText.makeTheTraceText("Please wait......");
        });

        new FlxTimer().start(2.5, function(tmr:FlxTimer) {
            TraceText.makeTheTraceText("Wait until bg and logo disappears...");
        });

        background = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BROWN);
        new FlxTimer().start(4.5, function(tmr:FlxTimer) {
		    FlxTween.tween(background, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
        });
        add(background);

        mainLogo = new FlxSprite().loadGraphic(Paths.image("engineStuff/main/sbEngineLogo"));
		mainLogo.screenCenter();
        new FlxTimer().start(5.3, function(tmr:FlxTimer) {
		    FlxTween.tween(mainLogo, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
            TraceText.makeTheTraceText("Thank you for using modified Psych Engine fork with some changes and additions made by Stefan2008 <3! Goodbye...");
        });
		add(mainLogo);

        FlxG.sound.play(Paths.sound('shutdown'));

        new FlxTimer().start(6.5, function(tmr:FlxTimer) {
			closeTheGame();
		});
    }

    function closeTheGame()
    {
        openfl.system.System.exit(1);
    }
}