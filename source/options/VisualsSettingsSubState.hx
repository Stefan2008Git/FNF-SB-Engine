package options;

import objects.Alphabet;

class VisualsSettingsSubState extends BaseOptionsMenu
{
	public static var pauseMusics:Array<String> = ['None', 'Tea Time', 'Breakfast', 'Breakfast (Pico)'];
	public static var judgementStyle:Array<String> = ['Default', 'With Misses', 'Better Judge'];
	public static var timeBarType:Array<String> = ['Time Left', 'Time Elapsed', 'Song Name', 'Song Name + Time Left', 'Song Name + Time Elapsed', 'Song Name + Difficulty', 'Modern Time', 'Modern Time Elapsed', 'Disabled'];
	public function new()
	{
		title = Language.getPhrase('visuals_menu', 'Visuals Settings');
		rpcTitle = 'Visuals Settings Menu'; //for Discord Rich Presence

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
			'If checked, shows your OS on FPS Counter.', 'osInfo', BOOL);
		addOption(option);

		#if sys
		var option:Option = new Option('VSync',
			'If checked, Enables VSync fixing any screen tearing at the cost of capping the FPS to screen refresh rate.\n(Must restart the game to have an effect)',
			'vsync',
			BOOL);
		option.onChange = onChangeVSync;
		addOption(option);
		#end
		
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
			"If unchecked, hides score text",
			'scoreText',
			BOOL);
		addOption(option);

		var option:Option = new Option('Watermark',
			"If unchecked, hides watermark",
			'watermark',
			BOOL);
		addOption(option);

		var option:Option = new Option('Judgement counter',
			"If unchecked, hides judgement counter",
			'judgementCounter',
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

		var option:Option = new Option('Text since',
			"If unchecked, disables text alpha sine",
			'textSine',
			BOOL);
		addOption(option);

		var option:Option = new Option('Startup screen',
			"Tf unchecked, disables the startup splash when you open the game",
			'lessCpuFramerateDrop',
			BOOL);
		addOption(option);

		super();
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
}