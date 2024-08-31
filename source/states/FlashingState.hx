package states;

import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;
import objects.Alphabet;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var bg:FlxSprite;
	var checkeboard:FlxBackdrop;
	var titleText:Alphabet;
	var warnText:FlxText;
	override function create()
	{
		super.create();

		bg= new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		bg.color = 0xFF353535;
		add(bg);

		checkeboard = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		checkeboard.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		checkeboard.screenCenter();
		add(checkeboard);

		final silly:String = controls.mobileC ? 'A' : 'ENTER';
		final baka:String = controls.mobileC ? 'B' : 'ESCAPE';
		var warning:String = 'FNF: SB Engine contains bugs, issues and flashing lights.\n\nFNF: SB Engine is a modified Psych Engine with some changes and additions made by Stefan2008 and it wasnt meant to be an attack on ShadowMario\nor any other mod makers out there. Im am not aiming for replacing what Friday Night Funkin: Psych Engine was, is and will be.\nIts made for fun and from the love for the game itself. All of the comparisons between this and other mods are purely coincidental, unless stated otherwise.\n\nNow with that out of the way, I hope you will enjoy to this modified Psych Engine fork.\nFunk all the way.\nPress $silly to proced.\nPress $baka to ignore this message.\nCurrent running SB Engine version is ${MainMenuState.sbEngineVersion}';

		titleText = new Alphabet(200, 45, "WARNING:", true);
		titleText.setScale(0.6);
		titleText.alpha = 0.4;
		titleText.color = FlxColor.RED;
		titleText.screenCenter(X);
		add(titleText);

		controls.isInSubstate = false; // qhar I hate it
		warnText = new FlxText(0, 0, FlxG.width, warning, 32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

		addTouchPad('NONE', 'A_B');
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.data.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
