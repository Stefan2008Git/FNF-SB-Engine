package states;

import states.MainMenuState;
import flixel.addons.transition.FlxTransitionableState;

class FlashingState extends MusicBeatState {
	public static var leftState:Bool = false;

	var background:FlxSprite;
	var boyfriend:FlxSprite;
	var velocityBackground:FlxBackdrop;
	var titleText:Alphabet;
	var warningText:FlxText;
	var warningTextTween:FlxTween;
	var creditsMusic:FlxText;

	override function create() {
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Warning Menu";
		FlxG.sound.playMusic(Paths.music('titleMenu/titleMusic'), 1); // Credits: Metroid (Nintedo game)
		Paths.clearStoredMemory();

		super.create();

		#if desktop
	    // Updating Discord Rich Presence
	    DiscordClient.changePresence("Warning Menu", null);
	    #end

		background = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		background.scrollFactor.set();
		background.updateHitbox();
		background.screenCenter();
		background.color = 0xFF353535;
		add(background);

		boyfriend = new FlxSprite().loadGraphic(Paths.image('boyfriend'));
		boyfriend.scrollFactor.set(1, 1);
		boyfriend.screenCenter();
		boyfriend.alpha = 0.7;
		boyfriend.y = 195;
		FlxTween.tween(boyfriend, {y: 45}, 1.5, {ease: FlxEase.sineInOut, type: PINGPONG, startDelay: 0.1});
		add(boyfriend);

		velocityBackground = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		velocityBackground.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		add(velocityBackground);

		titleText = new Alphabet(200, 45, "WARNING:", true);
		titleText.setScale(0.6);
		titleText.alpha = 0.4;
		titleText.color = FlxColor.RED;
		titleText.screenCenter(X);
		add(titleText);

		warningText = new FlxText(0, 0, FlxG.width,"FNF': SB Engine contains bugs, issues and flashing lights.\n\n" + "FNF': SB Engine is a modified Psych Engine with some changes and additions made by Stefan2008 and it wasn't meant to be an attack on ShadowMario" + "\nor any other mod makers out there. I'm am not aiming for replacing what Friday Night Funkin': Psych Engine was, is and will be." + "\nIt's made for fun and from the love for the game itself. All of the comparisons between this and other mods are purely coincidental, unless stated otherwise.\n\n" + "Now with that out of the way, I hope you'll will enjoy to this modified Psych Engine fork.\nFunk all the way.\nPress ENTER keybind to proceed.\nPress ESCAPE keybind to ignore this message.\nCurrent running SB Engine version is: " + MainMenuState.sbEngineVersion + "", 32);
		#if android warningText.text = "FNF': SB Engine contains bugs, issues and flashing lights.\n\n" + "FNF': SB Engine is a modified Psych Engine with some changes and additions made by Stefan2008 and it wasn't meant to be an attack on ShadowMario" + "\nor any other mod makers out there. I'm am not aiming for replacing what Friday Night Funkin': Psych Engine was, is and will be." + "\nIt's made for fun and from the love for the game itself. All of the comparisons between this and other mods are purely coincidental, unless stated otherwise.\n\n" + "Now with that out of the way, I hope you'll will will enjoy to this modified Psych Engine fork.\nFunk all the way.\nTap on A button to proceed.\nTap on B button to ignore this message.\nCurrent running SB Engine version is: " + MainMenuState.sbEngineVersion + ""; #end
		warningText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warningText.borderSize = 2.4;
		warningText.screenCenter(Y);
		warningText.alpha = 0;
		warningText.scale.x = 0;
		warningText.scale.y = 0;
		add(warningText);

		creditsMusic = new FlxText(11, FlxG.height - 40, 0, "Credits to Metroid™ team for title screen music.", 25);
		creditsMusic.setFormat("Bahnschrift", 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		creditsMusic.borderSize = 2.8;
		add(creditsMusic);

		Paths.clearUnusedMemory();

		#if android
		addVirtualPad(NONE, A_B);
		#end

		FlxTween.tween(warningText, {alpha: 1}, 0.75, {ease: FlxEase.sineInOut});
		warningTextTween = FlxTween.tween(warningText.scale, {x: 1, y: 1}, 0.75, {ease: FlxEase.sineInOut});
	}

	override function update(elapsed:Float) {
		if (!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if (!back) {
					ClientPrefs.data.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					#if android
					FlxTween.tween(MusicBeatState.virtualPad, {alpha: 0}, 1);
					#end
					FlxTween.tween(background, {alpha: 0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(boyfriend, {alpha: 0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(titleText, {alpha: 0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(warningText, {alpha: 0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(creditsMusic, {alpha: 0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(warningText.scale, {x: 1.5, y: 1.5}, .5,
						{ease: FlxEase.sineInOut, onComplete: (_) -> new FlxTimer().start(0.5, (t) -> MusicBeatState.switchState(new TitleState()))});
					FlxTween.tween(velocityBackground, {alpha: 0}, 0.25, {startDelay: 0.25});
					if (FlxG.sound.music != null)
				  		FlxTween.tween(FlxG.sound.music, {pitch: 0, volume: 0}, 1.5, {ease: FlxEase.sineInOut});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					#if android
					FlxTween.tween(MusicBeatState.virtualPad, {alpha: 0}, 1);
					#end
					FlxTween.tween(background, {alpha: 0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(boyfriend, {alpha: 0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(warningText, {alpha: 0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(creditsMusic, {alpha: 0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(warningText.scale, {x: 0, y: 0}, .5,
						{ease: FlxEase.sineInOut, onComplete: (_) -> new FlxTimer().start(0.5, (t) -> MusicBeatState.switchState(new TitleState()))});
					FlxTween.tween(velocityBackground, {alpha: 0}, 0.25, {startDelay: 0.25});
					if (FlxG.sound.music != null)
						FlxTween.tween(FlxG.sound.music, {pitch: 0, volume: 0}, 2.5, {ease: FlxEase.sineInOut});
				}
			}
		}
		super.update(elapsed);
	}
}