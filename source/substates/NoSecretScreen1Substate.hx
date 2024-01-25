package substates;

import states.MainMenuState;

class NoSecretScreen1Substate extends MusicBeatSubstate
{
    var blackSprite:FlxSprite;
    var velocityBackground:FlxBackdrop;
    var warningText1:FlxText;

    public function new()
    {
        super();

        blackSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        blackSprite.scrollFactor.set();
        blackSprite.screenCenter();
        blackSprite.alpha = 0;
        FlxTween.tween(blackSprite, {alpha: 0.8}, 0.4, {ease: FlxEase.quartInOut});
        add(blackSprite);

        /*velocityBackground = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x11FFFFFF, 0x0));
		velocityBackground.velocity.set(175, 175);
        velocityBackground.screenCenter();
        velocityBackground.alpha = 0;
        FlxTween.tween(velocityBackground, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		add(velocityBackground);*/ // This shit doesnt even works on my new substate!!!

        warningText1 = new FlxText(0, 0, "THERE IS NO DVD SCREEN\nEASTER EGG\nAVAILABLE ON VERSION\n" + MainMenuState.sbEngineVersion + " (PE " + MainMenuState.psychEngineVersion + ")!\nSOME ASSETS AND OTHER STUFF\nFROM OLDEST 0.6.3\nBUGGY BUILD ARE NOT YET\nIMPORTED!!!!!", 23);
        warningText1.setFormat("VCR OSD Mono", 20, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK, false);
        warningText1.screenCenter();
        warningText1.alpha = 0;
        FlxTween.tween(warningText1, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
        add(warningText1);
    }

    override function update(elapsed:Float)
    {
        #if android
		var pressedTheTouchScreen:Bool = false;

		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				pressedTheTouchScreen = true;
			}
		}
		#end

        if (FlxG.keys.justPressed.ESCAPE #if android || pressedTheTouchScreen #end) {
            Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion;
            FlxG.sound.play(Paths.sound('cancelMenu'), 1);
            close();
            FlxG.resetState();
        }
    }
}