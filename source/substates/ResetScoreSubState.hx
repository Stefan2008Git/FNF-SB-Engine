package substates;

class ResetScoreSubState extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var alphabetArray:Array<Alphabet> = [];
	var text1:Alphabet;
	var text2:Alphabet;
	var icon:HealthIcon;
	var onYes:Bool = false;
	var controlsActive:Bool = true;
	var yesText:Alphabet;
	var noText:Alphabet;

	var song:String;
	var difficulty:Int;
	var week:Int;

	// Week -1 = Freeplay
	public function new(song:String, difficulty:Int, character:String, week:Int = -1)
	{
		this.song = song;
		this.difficulty = difficulty;
		this.week = week;

		super();

		FlxTween.tween(FlxG.sound.music, {volume: 0.4}, 0.8);

		var name:String = song;
		if(week > -1) {
			name = WeekData.weeksLoaded.get(WeekData.weeksList[week]).weekName;
		}
		name += ' (' + Difficulty.getString(difficulty) + ')?';

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var tooLong:Float = (name.length > 18) ? 0.8 : 1; //Fucking Winter Horrorland
		text1 = new Alphabet(0, 180, "Reset the score of", true);
		text1.screenCenter(X);
		alphabetArray.push(text1);
		text1.alpha = 0;
		add(text1);

		text2 = new Alphabet(0, text1.y + 90, name, true);
		text2.scaleX = tooLong;
		text2.screenCenter(X);
		if(week == -1) text1.x += 60 * tooLong;
		alphabetArray.push(text2);
		text2.alpha = 0;
		add(text2);
		if(week == -1) {
			icon = new HealthIcon(character);
			icon.setGraphicSize(Std.int(icon.width * tooLong));
			icon.updateHitbox();
			icon.setPosition(text2.x - icon.width + (10 * tooLong), text2.y - 30);
			icon.alpha = 0;
			add(icon);
		}

		yesText = new Alphabet(0, text2.y + 150, 'Yes', true);
		yesText.screenCenter(X);
		yesText.x -= 200;
		yesText.color = FlxColor.RED;
		add(yesText);

		noText = new Alphabet(0, text2.y + 150, 'No', true);
		noText.screenCenter(X);
		noText.x += 200;
		noText.color = FlxColor.LIME;
		add(noText);
		updateOptions();

    	#if mobile
    	addVirtualPad(LEFT_RIGHT, A);
    	#end
	}

	override function update(elapsed:Float)
	{
		bg.alpha += elapsed * 1.5;
		if(bg.alpha > 0.6) bg.alpha = 0.6;

		for (i in 0...alphabetArray.length) {
			var spr = alphabetArray[i];
			spr.alpha += elapsed * 2.5;
		}
		if(week == -1) icon.alpha += elapsed * 2.5;

		if(controls.UI_LEFT_P || controls.UI_RIGHT_P && controlsActive) {
			FlxG.sound.play(Paths.sound('scrollMenu'), 1);
			onYes = !onYes;
			updateOptions();
		}
		if(controls.ACCEPT && controlsActive) {
			if(onYes) {
				if (ClientPrefs.data.flashing) {
					FlxFlicker.flicker(text2, 2, 0.15, false);
					text1.visible = false;
					text2.set_text("Reseting the score...");
					controlsActive = false;
					FlxTween.tween(FlxG.sound.music, {pitch: 0, volume: 0}, 1.5, {ease: FlxEase.sineInOut});
					FlxG.sound.play(Paths.sound('confirmMenu'), 1);
					TraceText.makeTheTraceText("Reseting the score...");
					new FlxTimer().start(2, function(tmr:FlxTimer) {
						if(week == -1) {
							Highscore.resetSong(song, difficulty);
						} else {
							Highscore.resetWeek(WeekData.weeksList[week], difficulty);
						}
						FlxTween.tween(FlxG.sound.music, {pitch: 1.5, volume: 1}, {ease: FlxEase.sineInOut});
						FlxG.resetState();
					});
				} else {
					if(week == -1) {
						Highscore.resetSong(song, difficulty);
					} else {
						Highscore.resetWeek(WeekData.weeksList[week], difficulty);
					}
					FlxG.resetState();
					FlxG.sound.play(Paths.sound('cancelMenu'), 1);
				}
			} else {
				close();
			}
		}
		super.update(elapsed);
	}

	function updateOptions() {
		var scales:Array<Float> = [0.75, 1];
		var alphas:Array<Float> = [0.6, 1.25];
		var confirmInt:Int = onYes ? 1 : 0;

		yesText.alpha = alphas[confirmInt];
		yesText.scale.set(scales[confirmInt], scales[confirmInt]);
		noText.alpha = alphas[1 - confirmInt];
		noText.scale.set(scales[1 - confirmInt], scales[1 - confirmInt]);
		if(week == -1) icon.animation.curAnim.curFrame = confirmInt;
	}
}