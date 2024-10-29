package states;

import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var bg:FlxSprite;
	var checkeboard:FlxBackdrop;
	var warnTitle:FlxText;
	var warnText:FlxText;
	var youCanText:FlxText;
	var acceptAllow:Bool = false;
	override function create()
	{
		super.create();

		if (!ClientPrefs.data.flashing)
		{
			MusicBeatState.switchState(new TitleState());
			leftState = true;
			return;
		}

		FlxG.sound.playMusic(Paths.music('engineStuff/freakyMenu-scary'));

		bg= new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		bg.color = FlxColor.GREEN;
		add(bg);

		checkeboard = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, FlxColor.BLACK, 0x0));
		checkeboard.velocity.set(40, 40);
		checkeboard.screenCenter();
		checkeboard.alpha = 0.6;
		add(checkeboard);

		final silly:String = controls.mobileC ? 'A' : 'ENTER';
		final baka:String = controls.mobileC ? 'B' : 'ESCAPE';

		warnTitle = new FlxText(200, 0, "WARNING", 15);
		warnTitle.setFormat("VCR OSD Mono", 100, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnTitle.screenCenter(X);
		FlxTween.tween(warnTitle, {y: 47}, 1, {ease: FlxEase.sineInOut});
		add(warnTitle);

		var red = new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF0000), "*");
		var green = new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF148f00), "<");
		var littlePurple = new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFd97eff), ">");
		var yellow = new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFf3ca00), "#");
		if (controls.mobileC) controls.isInSubstate = false; // qhar I hate it
		warnText = new FlxText(0, 0, FlxG.width, 15);
		warnText.applyMarkup('FNF SB Engine is officially \n*discontinued/cancelled* and \nyou are not gonna get any new updates #anymore#..\nI am so sorry everyone for what i did something *bad* to people. \nIt was my *fault* after all time for what i did\nYou can use a different PE fork \nsuch as >NovaFlare Engine > and <JS Engine <.\nBoth forks deserved to be popular and played.\nFunk all the way and *leave me alone PLEASE*!!!\nCurrent running SB Engine version is ${MainMenuState.sbEngineVersion}', [red, green, littlePurple, yellow]);
		warnText.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnText.screenCenter(Y);
		FlxTween.tween(warnText, {y: 220}, 1, {ease: FlxEase.sineInOut});
		add(warnText);

		youCanText = new FlxText(400, 630, 'You can now press $silly to proced or press $baka to ignore this message!');
		youCanText.alpha = 0;
		youCanText.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		new FlxTimer().start(12, function(tmr:FlxTimer) {
			FlxTween.tween(youCanText, {alpha: 1}, 1.5, {
				ease: FlxEase.sineInOut,
				onComplete: function(completition:FlxTween) {
					acceptAllow = true;
				}
			});
		});
		youCanText.screenCenter(X);
		add(youCanText);

		if (controls.mobileC) addTouchPad('NONE', 'A_B');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back && acceptAllow)
			{
				leftState = true;
				acceptAllow = false;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if (!back)
				{
					ClientPrefs.data.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('engineStuff/confirmMenu-scary'));
					youCanText.destroy();
					FlxTween.tween(FlxG.sound.music, {pitch: 0, volume: 0}, 2, {ease: FlxEase.sineInOut});
					FlxTween.tween(warnText, {y: 1200}, 2, {ease: FlxEase.sineInOut});
					FlxTween.tween(warnTitle, {y: -750}, 2, {ease: FlxEase.sineInOut});
					FlxTween.tween(bg, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
					FlxTween.tween(checkeboard, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
					FlxG.camera.flash(FlxColor.WHITE, 2.5, function()
					{
						FlxG.camera.fade(FlxColor.BLACK, 3, false, goToTitle);
					});
				} else
				{
					acceptAllow = false;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					youCanText.destroy();
					FlxTween.tween(warnText, {y: -750}, 2, {ease: FlxEase.sineInOut});
					FlxTween.tween(warnTitle, {y: 1200}, 2, {ease: FlxEase.sineInOut});
					FlxTween.tween(bg, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
					FlxTween.tween(checkeboard, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
					FlxG.camera.flash(FlxColor.WHITE, 2.5, function()
					{
						FlxG.camera.fade(FlxColor.BLACK, 3, false, goToTitle);
					});
				}
			}
		}
	}

	function goToTitle()
	{
		MusicBeatState.switchState(new TitleState());
	}
}
