package options;

import objects.Note;
import objects.StrumNote;

class VisualsSettingsSubState extends BaseOptionsMenu
{
	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var notesTween:Array<FlxTween> = [];
	var noteY:Float = 90;

	public static var pauseMusics:Array<String> = ['None', 'Tea Time', 'Breakfast', 'Breakfast (Pico)'];
	public static var judgementStyle:Array<String> = ['Default', 'With Misses', 'Better Judge', 'Disabled'];
	public static var timeBarType:Array<String> = ['Time Left', 'Time Elapsed', 'Song Name', 'Song Name + Time Left', 'Song Name + Time Elapsed', 'Song Name + Difficulty', 'Modern Time', 'Modern Time Elapsed', 'Disabled'];
	public static var introType:Array<String> = ['Default', 'Doido Engine'];

	public function new()
	{
		title = Language.getPhrase('visuals_menu', 'Visuals Settings');
		rpcTitle = 'Visuals Settings Menu'; //for Discord Rich Presence

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

		var noteSkins:Array<String> = Mods.mergeAllTextsNamed('images/noteSkins/list.txt');
		if(noteSkins.length > 0)
		{
			if(!noteSkins.contains(ClientPrefs.data.noteSkin))
				ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin; //Reset to default if saved noteskin couldnt be found

			noteSkins.insert(0, ClientPrefs.defaultData.noteSkin); //Default skin always comes first
			var option:Option = new Option('Note Skins:',
				"Select your prefered Note skin.",
				'noteSkin',
				STRING,
				noteSkins);
			addOption(option);
			option.onChange = onChangeNoteSkin;
			noteOptionID = optionsArray.length - 1;
		}

		var noteSplashes:Array<String> = Mods.mergeAllTextsNamed('images/noteSplashes/list.txt');
		if(noteSplashes.length > 0)
		{
			if(!noteSplashes.contains(ClientPrefs.data.splashSkin))
				ClientPrefs.data.splashSkin = ClientPrefs.defaultData.splashSkin; //Reset to default if saved splashskin couldnt be found

			noteSplashes.insert(0, ClientPrefs.defaultData.splashSkin); //Default skin always comes first
			var option:Option = new Option('Note Splashes:',
				"Select your prefered Note Splash variation or turn it off.",
				'splashSkin',
				STRING,
				noteSplashes);
			addOption(option);
		}

		var option:Option = new Option('Note Splash Opacity',
			'How much transparent should the Note Splashes be.',
			'splashAlpha',
			PERCENT);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			BOOL);
		addOption(option);
		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			STRING,
			timeBarType);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			BOOL);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			BOOL);
		addOption(option);

		var option:Option = new Option('Score Text Grow on Hit',
			"If unchecked, disables the Score text growing\neverytime you hit a note.",
			'scoreZoom',
			BOOL);
		addOption(option);

		var option:Option = new Option('Health Bar Opacity',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			PERCENT);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			BOOL);
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('FPS Counter size:',
			'How much FPS Counter size should be?',
			'fpsResize',
			FLOAT);
		option.scrollSpeed = 2;
		option.minValue = 0.3;
		option.maxValue = 3;
		option.changeValue = 0.1;
		addOption(option);
		option.onChange = onChangeFPSCounterSize;

		var option:Option = new Option('Total FPS text',
			'If checked, shows your max FPS on FPS Counter.', 'totalFPS', BOOL);
		addOption(option);

		var option:Option = new Option('Memory text',
			'If unchecked, hides memory on FPS Counter.', 'memory', BOOL);
		addOption(option);

		var option:Option = new Option('Max memory text',
			'If checked, shows max memory on FPS Counter.', 'maxMemory', BOOL);
		addOption(option);

		var option:Option = new Option('Engine Version',
			'If checked, shows engine version on FPS Counter.', 'engineVersion', BOOL);
		addOption(option);

		var option:Option = new Option('Platform target info',
			'If checked, shows your OS name and architecture number on FPS Counter.', 'osInfo', BOOL);
		addOption(option);

		#if sys
		var option:Option = new Option('VSync',
			'If checked, Enables VSync fixing any screen tearing at the cost of capping the FPS to screen refresh rate.\n(Must restart the game to have an effect)',
			'vsync',
			BOOL);
		option.onChange = onChangeVSync;
		addOption(option);
		#end

		var option:Option = new Option('FPS Counter framerate color',
			'If unchecked, disables colors on FPS counter framerate\nYellow = 50 FPS / Orange = 30 FPS / RED = 20 FPS.',  // Just note for Jordan since he thinks this options is useless as fuck: "I don't give a fucking shit if you don't have any colors when you are getting fow framerate! Understand it right now?"
			'framerateColor',
			BOOL);
		addOption(option);
		
		var option:Option = new Option('Pause Music:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			STRING,
			pauseMusics);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			BOOL);
		addOption(option);
		#end

		#if DISCORD_ALLOWED
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord",
			'discordRPC',
			BOOL);
		addOption(option);
		#end

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			BOOL);
		addOption(option);

		var option:Option = new Option('Score text',
			"If unchecked, hides score text", // Maybe is useless, i am really not sure..
			'scoreText',
			BOOL);
		addOption(option);

		var option:Option = new Option('Watermark',
			"If unchecked, hides watermark",
			'watermark',
			BOOL);
		addOption(option);

		var option:Option = new Option('Judgement counter:',
			"What judgement counter style you prefered?",
			'judgementCounterStyle',
			STRING,
			judgementStyle);
		addOption(option);

		var option:Option = new Option('Smooth health',
			"If unchecked, disables smooth health",
			'smoothHealth',
			BOOL);
		addOption(option);

		var option:Option = new Option('Text sine',
			"If unchecked, disables text alpha sine",
			'textSine',
			BOOL);
		addOption(option);

		var option:Option = new Option('Intro card',
			"If checked, enables intro card when countdown is finished on song start", // Recreated from some lua script to source for fun because i love it
			'introCard',
			BOOL);
		addOption(option);

		var option:Option = new Option('Startup screen',
			"If unchecked, disables the startup splash when you open the game\nNOTE: Currently we saw that the startup screen is always forced on for some unexpected reason, so that means you are gonna be switched to startup screen instead on title screen when you turn off this options!!!",
			'startupScreen',
			BOOL);
		addOption(option);

		var option:Option = new Option('Intro:',
			"What gameplay intro do you prefer?", // To understand more, this is when strum notes are genereated in game countdown, so different type of game intro will be "different"
			'introType',
			STRING,
			introType);
		addOption(option);

		#if desktop
		var option:Option = new Option('Screenshot',
			"If unchecked, disables screenshot support",
			'screenshot',
			BOOL);
		addOption(option);
		#end

		var option:Option = new Option('Opponent color',
			"If checked, shows color from opponent health on some text and elements. Uncheck if you prefer the default color from text",
			'opponentColor',
			BOOL);
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
			if(curSelected == noteOptionID)
				notesTween[i] = FlxTween.tween(note, {y: noteY}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
			else
				notesTween[i] = FlxTween.tween(note, {y: -200}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
		}
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
		if(changedMusic && !OptionsState.onPlayState) FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
		super.destroy();
	}

	function onChangeFPSCounter()
	{
		if (Main.fpsVar != null) Main.fpsVar.visible = ClientPrefs.data.showFPS;
		if (Main.fpsVar.alpha == 0) Main.tweenFPS();
	}

	function onChangeFPSCounterSize()
	{
		if (Main.fpsVar != null) Main.fpsVar.scaleX = Main.fpsVar.scaleY = ClientPrefs.data.fpsResize;
	}

	#if sys
	function onChangeVSync()
	{
		var file:String = StorageUtil.rootDir + "vsync.txt";
		if(FileSystem.exists(file))
			FileSystem.deleteFile(file);
		File.saveContent(file, Std.string(ClientPrefs.data.vsync));
	}
	#end


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
}
