package substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;

import flixel.util.FlxStringUtil;

import states.StoryMenuState;
import states.FreeplayState;
import options.OptionsState;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var bg:FlxSprite;
	var bgGrid:FlxBackdrop;
	var levelInfo:FlxText;
	var levelDifficulty:FlxText;
	var blueballedTxt:FlxText;
	var fadeOutSpr:FlxSprite;
	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Chart Editor', 'Options', 'Exit to menu'];
	var difficultyChoices = [];
	var currentlySelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);

	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	var settings = {
		bgColour: 'default',
	
		backdropSpeedX: 50,
		backdropSpeedY: 50,
		
		optionTweenTime: 0.1,
		selectTweenTime: 0.25,
		
		openMenuTweenTime: 0.25
	};
	
	var colours = [
		'default' => 0xFF000000,
		'pink' => 0xFFFA86C4,
		'crimson' => 0xFF870007,
		'turquoise' => 0xFF30D5C8,
		'red' => 0xFFBB0000,
		'green' => 0xFF00AA00,
		'blue' => 0xFF0000BB,
		'purple' => 0xFF592693,
		'yellow' => 0xFFC8B003,
		'brown' => 0xFF664229,
		'orange' => 0xFFFFA500,
	
		'custom' => 0xFF000000
	];

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		super();
		if(Difficulty.list.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!

		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(2, 'Leave Charting Mode');
			
			var num:Int = 0;
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(3, 'Skip Time');
			}
			menuItemsOG.insert(3 + num, 'End Song');
			menuItemsOG.insert(4 + num, 'Toggle Practice Mode');
			menuItemsOG.insert(5 + num, 'Toggle Botplay');
		}
		menuItems = menuItemsOG;

		for (i in 0...Difficulty.list.length) {
			var diff:String = Difficulty.getString(i);
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');


		pauseMusic = new FlxSound();
		if(songName != null) {
			pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		} else if (songName != 'None') {
			pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), true, true);
		}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, colours[settings.bgColour.toLowerCase()]);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		bgGrid = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x11FFFFFF, 0x0));
		bgGrid.alpha = 0;
		bgGrid.velocity.set(175, 175);
		add(bgGrid);

		levelInfo = new FlxText(20, 15, 0, "Song: " + PlayState.SONG.song, 32);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		levelDifficulty = new FlxText(20, 15 + 32, 0, "Difficulty: " + Difficulty.getString().toUpperCase(), 32);
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		blueballedTxt = new FlxText(20, 15 + 64, 0, "Blueballed: " + PlayState.deathCounter, 32);
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		fadeOutSpr = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		fadeOutSpr.alpha = 0;
		add(fadeOutSpr);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(bgGrid, {alpha: 1}, settings.openMenuTweenTime, {ease: FlxEase.quadOut});
		FlxTween.tween(bgGrid.velocity, {x: settings.backdropSpeedX, y: settings.backdropSpeedY}, settings.openMenuTweenTime + 0.25, {ease: FlxEase.quadOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		#if mobile
		PlayState.chartingMode ? addVirtualPad(FULL, A) : addVirtualPad(UP_DOWN, A);
		addPadCamera();
		#end

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		var daSelected:String = menuItems[currentlySelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (accepted && (cantUnpause <= 0 || !controls.controllerMode))
		{
			if (menuItems == difficultyChoices)
			{
				try{
					if(menuItems.length - 1 != currentlySelected && difficultyChoices.contains(daSelected)) {

						var name:String = PlayState.SONG.song;
						var poop = Highscore.formatSong(name, currentlySelected);
						PlayState.SONG = Song.loadFromJson(poop, name);
						PlayState.storyDifficulty = currentlySelected;
						FlxG.resetState();
						FlxG.sound.music.volume = 0;
						PlayState.changedDifficulty = true;
						PlayState.chartingMode = false;
						return;
					}					
				}catch(e:Dynamic){
					trace('ERROR! $e');

					var errorStr:String = e.toString();
					if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length-1); //Missing chart
					missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
					missingText.screenCenter(Y);
					missingText.visible = true;
					missingTextBG.visible = true;
					FlxG.sound.play(Paths.sound('cancelMenu'));

					super.update(elapsed);
					return;
				}


				menuItems = menuItemsOG;
				regenMenu();
			}

			switch (daSelected)
			{
				case "Resume":
					close();
					FlxTween.tween(bgGrid.velocity, {x: 175, y: 175}, 0.05, {ease: FlxEase.quadIn});
					FlxTween.tween(levelInfo, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(levelDifficulty, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(blueballedTxt, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(bgGrid, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(fadeOutSpr, {alpha: 1}, 0.25, {ease: FlxEase.quadOut});
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					deleteSkipTimeText();
					regenMenu();
				case 'Chart Editor':
					MusicBeatState.switchState(new states.editors.ChartingState());
					PlayState.chartingMode = true;
					FlxTween.tween(bgGrid.velocity, {x: 175, y: 175}, 0.05, {ease: FlxEase.quadIn});
					FlxTween.tween(levelInfo, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(levelDifficulty, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(blueballedTxt, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(bgGrid, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(fadeOutSpr, {alpha: 1}, 0.25, {ease: FlxEase.quadOut});
				case 'Toggle Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case "Restart Song":
					restartSong();
					FlxTween.tween(bgGrid.velocity, {x: 175, y: 175}, 0.05, {ease: FlxEase.quadIn});
					FlxTween.tween(levelInfo, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(levelDifficulty, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(blueballedTxt, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(bgGrid, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(fadeOutSpr, {alpha: 1}, 0.25, {ease: FlxEase.quadOut});
				case "Leave Charting Mode":
					restartSong();
					PlayState.chartingMode = false;
					FlxTween.tween(bgGrid.velocity, {x: 175, y: 175}, 0.05, {ease: FlxEase.quadIn});
					FlxTween.tween(levelInfo, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(levelDifficulty, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(blueballedTxt, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(bgGrid, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(fadeOutSpr, {alpha: 1}, 0.25, {ease: FlxEase.quadOut});
				case 'Skip Time':
					if(curTime < Conductor.songPosition)
					{
						PlayState.startOnTime = curTime;
						restartSong(true);
					}
					else
					{
						if (curTime != Conductor.songPosition)
						{
							PlayState.instance.clearNotesBefore(curTime);
							PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case 'End Song':
					close();
					PlayState.instance.notes.clear();
					PlayState.instance.unspawnNotes = [];
					PlayState.instance.finishSong(true);
					FlxTween.tween(bgGrid.velocity, {x: 175, y: 175}, 0.05, {ease: FlxEase.quadIn});
					FlxTween.tween(levelInfo, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(levelDifficulty, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(blueballedTxt, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(bgGrid, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(fadeOutSpr, {alpha: 1}, 0.25, {ease: FlxEase.quadOut});
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case 'Options':
					PlayState.instance.paused = true; // For lua
					PlayState.instance.vocals.volume = 0;
					MusicBeatState.switchState(new OptionsState());
					if(ClientPrefs.data.pauseMusic != 'None')
					{
						FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), pauseMusic.volume);
						FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
						FlxG.sound.music.time = pauseMusic.time;
					}
					OptionsState.onPlayState = true;
					FlxTween.tween(bgGrid.velocity, {x: 175, y: 175}, 0.05, {ease: FlxEase.quadIn});
					FlxTween.tween(levelInfo, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(levelDifficulty, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(blueballedTxt, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(bgGrid, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(fadeOutSpr, {alpha: 1}, 0.25, {ease: FlxEase.quadOut});
				case "Exit to menu":
					#if desktop DiscordClient.resetClientID(); #end
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;

					Mods.loadTopMod();
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.music('freakyMenu-' + ClientPrefs.data.mainMenuMusic));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
					FlxG.camera.followLerp = 0;
					FlxTween.tween(bg, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(bgGrid.velocity, {x: 175, y: 175}, 0.05, {ease: FlxEase.quadIn});
					FlxTween.tween(levelInfo, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(levelDifficulty, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
					FlxTween.tween(blueballedTxt, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
				FlxTween.tween(bgGrid, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
			FlxTween.tween(fadeOutSpr, {alpha: 1}, 0.25, {ease: FlxEase.quadOut});
			}
		}
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		FlxG.resetState();
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		currentlySelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (currentlySelected < 0)
			currentlySelected = menuItems.length - 1;
		if (currentlySelected >= menuItems.length)
			currentlySelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - currentlySelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));

				if(item == skipTimeTracker)
				{
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
		missingText.visible = false;
		missingTextBG.visible = false;
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(90, 320, menuItems[i], true);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		currentlySelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
}
