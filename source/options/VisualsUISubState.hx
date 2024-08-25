package options;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		if (options.OptionsState.onPlayState) 
			Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu - Paused (In Visuals & UI Settings Menu)"; 
		else 
			Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu (In Visuals & UI Settings Menu)";

		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence
		
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.', 'showFPS', 'bool');
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('FPS Counter size:', 
			'Resize the FPS Counter for better experience.\nNOTE: This can be helpful for phone screen resoultion problem with OpenFL.',
			'fpsResize',
			'float');
		option.scrollSpeed = 2;
		option.minValue = 0.3;
		option.maxValue = 3;
		option.changeValue = 0.1;
		addOption(option);
		option.onChange = onChangeFPSCounterSize;

		var option:Option = new Option('Total FPS text',
			'If checked, shows your max FPS on FPS Counter.', 'totalFPS', 'bool');
		addOption(option);

		var option:Option = new Option('Memory text',
			'If unchecked, hides memory on FPS Counter.', 'memory', 'bool');
		addOption(option);

		var option:Option = new Option('Max memory text',
			'If checked, shows max memory on FPS Counter.', 'maxMemory', 'bool');
		addOption(option);

		var option:Option = new Option('Engine Version',
			'If checked, shows engine version on FPS Counter.', 'engineVersion', 'bool');
		addOption(option);

		var option:Option = new Option('Debug Info',
			'If checked, shows debug info on FPS Counter.', 'debugInfo', 'bool');
		addOption(option);

		var option:Option = new Option('Red text on lowest framerate',
			'If unchecked, disables red color when you had an lowest frame rate.', 'redText', 'bool');
		addOption(option);

		var option:Option = new Option('In-game logs',
			"If checked, disables in-game logs",
			"inGameLogs",
			"bool");
		addOption(option);

		var option:Option = new Option('Watermark on right down corner',
			"Uncheck this if you dont want to see watermark icon",
			'watermarkIcon',
			'bool');
		addOption(option);
		option.onChange = onWatermarkIcon;

		var option:Option = new Option('Watermark size:', 
			'Resize the watermark icon for better experience.\nNOTE: This can be helpful for phone screen resoultion problem with OpenFL.',
			'iconResize',
			'float');
		option.scrollSpeed = 2;
		option.minValue = 0.3;
		option.maxValue = 3;
		option.changeValue = 0.1;
		addOption(option);
		option.onChange = onChangeIconSize;

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool');
		addOption(option);

		var option:Option = new Option('Objects',
			'If unchecked, disable some objects for optimization\nFor example: Girlfriend and logo had an trail added.', 'objects', 'bool');
		addOption(option);

		#if DISCORD_ALLOWED
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord\nNOTE: Required the game restart to apply changes!",
			'discordRPC',
			'bool');
		addOption(option);
		#end

		var option:Option = new Option('Auto Pause',
			"If checked, the game automatically pauses if the screen isn't on focus.",
			'autoPause',
			'bool');
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Velocity background', 
		    'If unchecked, this option is disabling velocity background for optimization.', 'checkerboard', 'bool');
		addOption(option);
		option.onChange = onChangeChecker;

		#if SHOW_LOADING_SCREEN
		var option:Option = new Option('Loading screen', 
		    'If unchecked, disables the loading screen and switch to title menu instead.\nNOTE: Enabling / disabling this options requires the game restart!', 'loadingScreen', 'bool');
		addOption(option);
		#end

		var option:Option = new Option('Custom fade Transition', 
		    'If unchecked, makes transition between states faster.', 'fadeTransition', 'bool');
		addOption(option);

		var option:Option = new Option('Themes:', 
			'Change theme from different engines. More themes are coming very soon', 'themes', 'string', ['SB Engine', 'Psych Engine', 'Vanilla', 'Dark', 'Light']);
		addOption(option);
		option.onChange = onChangeThemes;

		var option:Option = new Option('FNF Engine type:', 
			'Change FNF engine type style and font plus', 'gameStyle', 'string', ['SB Engine', 'Psych Engine', 'Kade Engine', 'TGT Engine', 'Dave and Bambi', 'Cheeky']);
		addOption(option);
		option.onChange = onChangeEngineType;

		var option:Option = new Option('Main Menu Song:',
			"What song do you prefer for the main menu?",
			'mainMenuMusic',
			'string',
			['SB Engine', 'FNF', 'Kade Engine', 'Checky', 'Flixel']);
		addOption(option);
		option.onChange = onChangeMainMenuMusic;

		super();
	}

	function onChangeAutoPause()
	{
		FlxG.autoPause = ClientPrefs.data.autoPause;
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

	function onWatermarkIcon()
	{
		if (Main.watermark != null) Main.watermark.visible = ClientPrefs.data.watermarkIcon;
		if (Main.watermark.alpha == 0) Main.tweenWatermark();
	}

	function onChangeIconSize()
	{
		if (Main.watermark != null) Main.watermark.scaleX = Main.watermark.scaleY = ClientPrefs.data.iconResize;
	}

	var changedMainMusic:Bool = false;
	function onChangeMainMenuMusic()
	{
		if (ClientPrefs.data.mainMenuMusic != 'FNF') FlxG.sound.playMusic(Paths.music('freakyMenu-' + ClientPrefs.data.mainMenuMusic));
		if (ClientPrefs.data.mainMenuMusic == 'FNF') FlxG.sound.playMusic(Paths.music('freakyMenu'));
		if (ClientPrefs.data.mainMenuMusic == 'None') FlxG.sound.music.volume = 0;
		changedMainMusic = true;
	}

	function onChangeChecker() {
		if (ClientPrefs.data.checkerboard == true) BaseOptionsMenu.checkerboard.visible = true;
		else if (ClientPrefs.data.checkerboard == false) BaseOptionsMenu.checkerboard.visible = false;
	}

	function onChangeEngineType() 
	{
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				BaseOptionsMenu.descText.setFormat(Paths.font("bahnschrift.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				Main.fpsVar.defaultTextFormat = new TextFormat('Bahnschrift', #if android 14 #else 12 #end, 0xFFFFFF);
			
			case 'Dave and Bambi':
				BaseOptionsMenu.descText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				Main.fpsVar.defaultTextFormat = new TextFormat('Comic Sans MS Bold', #if android 14 #else 12 #end, 0xFFFFFF);
			
			case 'Kade Engine':
				Main.fpsVar.defaultTextFormat = new TextFormat('VCR OSD Mono', #if android 14 #else 12 #end, 0xFFFFFF);
			
			case 'TGT Engine':
				BaseOptionsMenu.descText.setFormat(Paths.font("calibri.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				Main.fpsVar.defaultTextFormat = new TextFormat('Calibri', #if android 14 #else 12 #end, 0xFFFFFF);
			
			default:
				BaseOptionsMenu.descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				Main.fpsVar.defaultTextFormat = new TextFormat('_sans', #if android 14 #else 12 #end, 0xFFFFFF);
		}
	}

	function onChangeThemes()
	{
		switch (ClientPrefs.data.themes) {
			case 'SB Engine': BaseOptionsMenu.background.color = FlxColor.BROWN;
			case 'Psych Engine': BaseOptionsMenu.background.color = 0xFFea71fd;
			case 'Vanilla': BaseOptionsMenu.background.color = 0xFFfc719a;
			case 'Dark': BaseOptionsMenu.background.color = 0xFF353535;
			case 'Light': BaseOptionsMenu.background.color = 0xFFCECDCD;
		}
	}
}
