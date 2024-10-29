package states;

#if mobile
import lime.ui.Haptic;
#end

import states.TitleState;

class SBinatorState extends MusicBeatState
{
	var mainBackground:FlxSprite;
    var mainIcon:FlxSprite;
    var background2:FlxSprite;
    var mainLogo:FlxSprite;
    var mainEngineText:FlxText;
	var loadingText:FlxText;
	var timePassed:Float;

    override function create()
    {
        super.create();

		mainBackground = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        mainBackground.visible = false;
        add(mainBackground);

        mainIcon = new FlxSprite().loadGraphic(Paths.image("engineStuff/main/sbinator"));
        mainIcon.visible = false;
        mainIcon.scale.x = 1.5;
        mainIcon.scale.y = 1.5;
        mainIcon.screenCenter();
        add(mainIcon);

        mainEngineText = new FlxText(20, FlxG.height - 80, 1000, "Powered by:\n" + Sys.systemName(), 10);
		mainEngineText.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		mainEngineText.visible = false;
		mainEngineText.screenCenter(X);
		add(mainEngineText);

        background2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF009E00);
        background2.alpha = 0;
        add(background2);

        mainLogo = new FlxSprite().loadGraphic(Paths.image("engineStuff/main/sbEngineLogo"));
		mainLogo.screenCenter();
		mainLogo.alpha = 0;
		mainLogo.scale.x = 0.7;
        mainLogo.scale.y = 0.7;
		add(mainLogo);

		loadingText = new FlxText(12, FlxG.height - 26, 0, Language.getPhrase('now_loading', 'Now Loading', ['...']), 32);
		loadingText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		loadingText.borderSize = 2;
		loadingText.visible = false;
		add(loadingText);

        new FlxTimer().start(1.5, function(tmr:FlxTimer) {
            #if mobile
			Haptic.vibrate(0, 500);
            #end
		});

        new FlxTimer().start(2.5, function(tmr:FlxTimer) {
			mainBackground.visible = true;
            mainIcon.visible = true;
            mainEngineText.visible = true;
			loadingText.visible = true;
		});

        new FlxTimer().start(10.5, function(tmr:FlxTimer) {
			Main.tweenFPS();
			mainBackground.visible = false;
            mainIcon.visible = false;
            mainEngineText.visible = false;
            FlxTween.tween(background2, {alpha: 1}, 1.3, {ease: FlxEase.sineInOut});
            FlxG.sound.play(Paths.sound('engineStuff/startup'));
		});

        new FlxTimer().start(11.5, function(tmr:FlxTimer) {
			FlxTween.tween(mainLogo, {alpha: 1}, 1.3, {ease: FlxEase.sineInOut});
		});

        new FlxTimer().start(17.5, function(tmr:FlxTimer) {
			FlxTween.tween(background2, {alpha: 0}, 1.2, {
				ease: FlxEase.sineInOut,
				onComplete: function(completition:FlxTween) {
					loadingText.visible = false;
					switchToTitleMenu();
				}
			});
		});

        new FlxTimer().start(17.5, function(tmr:FlxTimer) {
			FlxTween.tween(mainLogo, {alpha: 0}, 1.2, {
				ease: FlxEase.sineInOut,
				onComplete: function(completition:FlxTween) {
					loadingText.visible = false;
					switchToTitleMenu();
				}
			});
		});
	}

	var dots:String = '';
	override function update(elapsed:Float)
	{
		timePassed += elapsed;
		switch(Math.floor(timePassed % 1 * 3))
		{
			case 0:
				dots = '.';
			case 1:
				dots = '..';
			case 2:
				dots = '...';
		}
		loadingText.text = Language.getPhrase('now_loading', 'Now Loading{1}', [dots]);
	}

	function switchToTitleMenu()
    {
        FlxG.switchState(() -> new TitleState());
    }
}
        
