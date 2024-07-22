package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var notesTween:Array<FlxTween> = [];
	var noteY:Float = 90;

	public function new()
	{
		if (options.OptionsState.onPlayState) 
			Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu - Paused (In Gameplay Settings Menu)"; 
		else 
			Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu (In Gameplay Settings Menu)";

		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		// for note skins
		notes = new FlxTypedGroup<StrumNote>();
		for (i in 0...Note.colArray.length)
		{
			var note:StrumNote = new StrumNote(370 + (560 / Note.colArray.length) * i, -200, i, 0);
			note.centerOffsets();
			note.centerOrigin();
			note.playAnim('static');
			notes.add(note);
		}

		// options

		var noteSkins:Array<String> = [];
		if(Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared').length > 0)
			noteSkins = Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared');
		else
			noteSkins = CoolUtil.coolTextFile(Paths.getPreloadPath('shared/images/noteSkins/list.txt'));

		if(noteSkins.length > 0)
		{
			if(!noteSkins.contains(ClientPrefs.data.noteSkin))
				ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin; //Reset to default if saved noteskin couldnt be found

			noteSkins.insert(0, ClientPrefs.defaultData.noteSkin); //Default skin always comes first
			var option:Option = new Option('Note Skins:',
				"Select your prefered Note skin.",
				'noteSkin',
				'string',
				noteSkins);
			addOption(option);
			option.onChange = onChangeNoteSkin;
			noteOptionID = optionsArray.length - 1;
		}

		var noteSplashes:Array<String> = [];
		if(Mods.mergeAllTextsNamed('images/noteSplashes/list.txt', 'shared').length > 0)
			noteSplashes = Mods.mergeAllTextsNamed('images/noteSplashes/list.txt', 'shared');
		else
			noteSplashes = CoolUtil.coolTextFile(Paths.getPreloadPath('shared/images/noteSplashes/list.txt'));

		if(noteSplashes.length > 0)
		{
			if(!noteSplashes.contains(ClientPrefs.data.splashSkin))
				ClientPrefs.data.splashSkin = ClientPrefs.defaultData.splashSkin; //Reset to default if saved splashskin couldnt be found

			noteSplashes.insert(0, ClientPrefs.defaultData.splashSkin); //Default skin always comes first
			var option:Option = new Option('Note Splashes:',
				"Select your prefered Note Splash variation or turn it off.",
				'splashSkin',
				'string',
				noteSplashes);
			addOption(option);
		}

		var option:Option = new Option('Note Splash Opacity',
			'How much transparent should the Note Splashes be.',
			'splashAlpha',
			'percent');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool');
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool');
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			'bool'); //Variable type
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			'bool');
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'If unchecked, opponent notes get hidden.',
			'opponentStrums',
			'bool');
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping',
			'bool');
		addOption(option);

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'noReset',
			'bool');
		addOption(option);

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			'bool');
		addOption(option);

		var option:Option = new Option('Watermark',
			"If unchecked, hides watermark.", 'watermark', 'bool');
		addOption(option);

		var option:Option = new Option('Watermark style: ',
			"What style of watermark do you like?", 'watermarkStyle', 'string',
			['SB Engine', 'Kade Engine']);
		addOption(option);

		var option:Option = new Option('Random Watermark Engine Names',
			"If checked, makes to show random username on watermark instead to show SB only.", 'randomEngineNames', 'bool');
		addOption(option);

		var option:Option = new Option('Score text',
			"If unchecked, hides score text.", 'scoreText', 'bool');
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool');
		addOption(option);

		var option:Option = new Option('Judgement Counter',
			"If unchecked, hides judgementCounter.", 'judgementCounter', 'bool');
		addOption(option);

		var option:Option = new Option('Judgement Zoom on Hit',
			"If unchecked, disables the Judgement Counter text zooming\neverytime you hit a note.",
			'judgementZoom',
			'bool');
		addOption(option);

		var option:Option = new Option('Judgement style: ',
			"What style of judgement counter do you like?", 'judgementCounterStyle', 'string',
			['Original', 'With Misses', 'Better Judge']);
		addOption(option);

		var option:Option = new Option('Time bar',
			"If unchecked, hides time bar.", 'timeBar', 'bool');
		addOption(option);

		var option:Option = new Option('Time txt',
			"If unchecked, hides time txt.", 'timeTxt', 'bool');
		addOption(option);

		var option:Option = new Option('Icon bounce',
			"If unchecked, disables 5 HUD icon bounce instead for Psych Engine HUD.", 'iconBounce', 'bool');
		addOption(option);

		var option:Option = new Option('Camera movement on note hit',
			"If checked, enables to move camera on note hit.", 'cameraMovement', 'bool');
		addOption(option);

		var option:Option = new Option('Boyfriend Note glow',
			"If unchecked, disables note glow for boyfriend side.", 'arrowGlow', 'bool');
		addOption(option);

		var option:Option = new Option('Opponent Note glow',
			"If unchecked, disables note glow for boyfriend side.", 'opponentArrowGlow', 'bool');
		addOption(option);

		var option:Option = new Option('Text Sine Effect',
			"If unchecked, disables text sine effect.", 'textSineEffect', 'bool');
		addOption(option);

		var option:Option = new Option('Shake objects',
			"If checked, shakes some objects.", 'shakeObjects', 'bool');
		addOption(option);

		var option:Option = new Option('Time bar opponent color',
			"If checked, enables color from opponent health instead of purple.", 'opponentHealthColor', 'bool');
		addOption(option);

		var option:Option = new Option('Autoplay text on time bar',
			"If checked, enables autoplay text to show on time bar.", 'autoplayTextOnTimeBar', 'bool');
		addOption(option);

		var option:Option = new Option('Guitar Hero Sustain style',
			"If checked, Hold Notes can't be pressed if you miss,\nand count as a single Hit/Miss.\nUncheck this if you prefer the old Input System.", 'guitarHeroSustains', 'bool');
		addOption(option);
	
		var option:Option = new Option('Original FNF HP Bar',
			"If checked, it should show the original game HP bar color: red and lime.\nUncheck this if you prefer the old current custom RGB color.", 'originalHPBar', 'bool');
		addOption(option);

		var option:Option = new Option('Smooth health',
			"If unchecked, disables smooth health.", 'smoothHealth', 'bool');
		addOption(option);

		var option:Option = new Option('Smooth score',
			"If unchecked, disables smooth score.", 'smoothScore', 'bool');
		addOption(option);

		var option:Option = new Option('Tweenable timer text',
			"If checked, enables tween text for timer text.", 'tweenableTimeTxt', 'bool');
		addOption(option);

		var option:Option = new Option('Tweenable score text',
			"If checked, enables tween text for score text.", 'tweenableScoreTxt', 'bool');
		addOption(option);

		var option:Option = new Option('Millisecond popup',
			"If checked, enables MS text popup.", 'millisecondTxt', 'bool');
		addOption(option);

		var option:Option = new Option('Rating popup',
			"If unchecked, hides rating popup.", 'ratingPopup', 'bool');
		addOption(option);

		var option:Option = new Option('Combo popup',
			"If unchecked, hides combo popup.", 'ratingComboPopup', 'bool');
		addOption(option);

		var option:Option = new Option('Combo number popup',
			"If unchecked, hides combo number popup.", 'ratingComboNumberPopup', 'bool');
		addOption(option);

		var option:Option = new Option('Results screen',
			"If checked, shows results screen.", 'resultsScreen', 'bool');
		addOption(option);

		var option:Option = new Option('Game over screen',
			"If unchecked, disables the original FNF game over screen and switch to modes immediately.", 'gameOverScreen', 'bool');
		addOption(option);

		var option:Option = new Option('Song percentage',
			"If checked, shows the song percent.", 'songPercentage', 'bool');
		addOption(option);

		var option:Option = new Option('Time bar left to right method',
			"If unchecked, makes your bar goes right to left instead goes left to right.\nThis option can help for time left option for better experience", 'leftToRightBar', 'bool');
		addOption(option);

		var option:Option = new Option('Better cutscenes',
			"If unchecked, enables video instead of coded one.\nThis option can be helpful for perfomance if you disable this option!", 'betterCutscene', 'bool');
		addOption(option);

		var option:Option = new Option('Pause Screen Song: ',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			['None', 'Breakfast', 'Tea Time', 'Flixel']);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		var option:Option = new Option('Time Bar: ',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			['Time Left', 'Time Elapsed', 'Song Name', 'Song Name + Time Left', 'Song Name + Time Elapsed', 'Song Name + Difficulty', 'Modern Time', 'Modern Time Elapsed', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Accuracy type: ',
		"The way accuracy is calculated. \nNote = Depending on if a note is hit or not.\nJudgement = Depending on Judgement.\nMillisecond = Depending on milliseconds.",
			'accuraryStyle',
			'string',
			['Note', 'Judgement', 'Millisecond']);
		addOption(option);

		var option:Option = new Option('Health Bar Opacity',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'Arrows does \"Tick!\" when you hit them."',
			'hitsoundVolume',
			'percent');
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
			'ratingOffset',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Sick! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.',
			'sickWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.',
			'goodWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.',
			'badWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for\nhitting a note earlier or late.',
			'safeFrames',
			'float');
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
		add(notes);
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		
		if(noteOptionID < 0) return;

		for (i in 0...Note.colArray.length)
		{
			var note:StrumNote = notes.members[i];
			if(notesTween[i] != null) notesTween[i].cancel();
			if(currentlySelected == noteOptionID)
				notesTween[i] = FlxTween.tween(note, {y: noteY}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
			else
				notesTween[i] = FlxTween.tween(note, {y: -200}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
		}
	}

	function onChangeNoteSkin()
	{
		notes.forEachAlive(function(note:StrumNote) {
			changeNoteSkin(note);
			note.centerOffsets();
			note.centerOrigin();
		});
	}

	function changeNoteSkin(note:StrumNote)
	{
		var skin:String = Note.defaultNoteSkin;
		var customSkin:String = skin + Note.getNoteSkinPostfix();
		if(Paths.fileExists('images/$customSkin.png', IMAGE)) skin = customSkin;

		note.texture = skin; //Load texture and anims
		note.reloadNote();
		note.playAnim('static');
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic && !OptionsState.onPlayState) FlxG.sound.playMusic(Paths.music('freakyMenu-' + ClientPrefs.data.mainMenuMusic), 1, true);
		super.destroy();
	}

	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);
	}
}
