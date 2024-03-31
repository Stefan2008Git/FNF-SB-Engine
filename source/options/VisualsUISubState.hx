package options;

import openfl.display.StageQuality;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu (In Visuals & UI Settings Menu)";

		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence
		
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.', 'showFPS', 'bool');
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('Total FPS',
			'If checked, shows Total FPS Counter.', 'showTotalFPS', 'bool');
		addOption(option);

		var option:Option = new Option('Memory Counter',
			'If unchecked, hides memory on FPS Counter.', 'memory', 'bool');
		addOption(option);

		var option:Option = new Option('Memory Peak',
			'If checked, shows maximum memory on FPS Counter.', 'totalMemory', 'bool');
		addOption(option);

		var option:Option = new Option('Engine Version',
			'If checked, shows engine version on FPS Counter.', 'engineVersion', 'bool');
		addOption(option);

		#if debug
		var option:Option = new Option('Debug Info',
			'If checked, shows debug info on FPS Counter.', 'debugInfo', 'bool');
		addOption(option);
		#end

		var option:Option = new Option('Rainbow FPS',
			'If checked, enables rainbow FPS.', 'rainbowFPS', 'bool');
		addOption(option);

		var option:Option = new Option('Red text on lowest framerate',
			'If unchecked, disables red color when you had an lowest frame rate.', 'redText', 'bool');
		addOption(option);

		var option:Option = new Option('In-game logs',
			"If unchecked, disables in-game logs",
			"inGameLogs",
			"bool");
		addOption(option);

		var option:Option = new Option('Watermark on right down corner',
			"Uncheck this if you dont want to see watermark icon",
			'watermarkIcon',
			'bool');
		addOption(option);
		option.onChange = onWatermarkIcon;

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
		option.onChange = onChangeDiscordRichPresence;
		#end

		var option:Option = new Option('Auto Pause',
			"If checked, the game automatically pauses if the screen isn't on focus.",
			'autoPause',
			'bool');
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Velocity background', 
		    'If unchecked, this option is disabling velocity background for optimization.', 'velocityBackground', 'bool');
		addOption(option);
		option.onChange = onChangeChecker;

		#if PSYCH_WATERMARKS
		var option:Option = new Option('0.7.3 Loading screen', 
		    'If checked, enables the loading screen from 0.7.3 experimental build, but it breaks the entire GPU caching.', 'loadingScreen', 'bool');
		addOption(option);
		#end

		var option:Option = new Option('Custom fade Transition', 
		    'If unchecked, makes transition between states faster.', 'fadeTransition', 'bool');
		addOption(option);

		var option:Option = new Option('Themes:', 
			'Change theme from different engines. More themes are coming very soon', 'themes', 'string', ['SB Engine', 'Psych Engine']);
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
		if(Main.fpsVar != null) Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}

	function onWatermarkIcon()
	{
		if(Main.watermark != null) Main.watermark.visible = ClientPrefs.data.watermarkIcon;
	}

	var changedMainMusic:Bool = false;
	function onChangeMainMenuMusic()
	{
		if (ClientPrefs.data.mainMenuMusic != 'FNF') FlxG.sound.playMusic(Paths.music('freakyMenu-' + ClientPrefs.data.mainMenuMusic));
		if (ClientPrefs.data.mainMenuMusic == 'FNF') FlxG.sound.playMusic(Paths.music('freakyMenu'));
		if(ClientPrefs.data.mainMenuMusic == 'None') FlxG.sound.music.volume = 0;
		changedMainMusic = true;
	}

	function onChangeChecker() {
		if (ClientPrefs.data.velocityBackground == true) BaseOptionsMenu.velocityBackground.visible = true;
		else if (ClientPrefs.data.velocityBackground == false) BaseOptionsMenu.velocityBackground.visible = false;
	}

	function onChangeEngineType() 
	{
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				BaseOptionsMenu.descText.setFormat(Paths.font("bahnschrift.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				Main.fpsVar.defaultTextFormat = new TextFormat('Bahnschrift', 14, 0xFFFFFF);
			
			case 'Dave and Bambi':
				BaseOptionsMenu.descText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				Main.fpsVar.defaultTextFormat = new TextFormat('Comic Sans MS Bold', 14, 0xFFFFFF);
			
			case 'Kade Engine':
				Main.fpsVar.defaultTextFormat = new TextFormat('VCR OSD Mono', 14, 0xFFFFFF);
			
			case 'TGT Engine':
				BaseOptionsMenu.descText.setFormat(Paths.font("calibri.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				Main.fpsVar.defaultTextFormat = new TextFormat('Calibri', 14, 0xFFFFFF);
			
			default:
				BaseOptionsMenu.descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				Main.fpsVar.defaultTextFormat = new TextFormat('_sans', 14, 0xFFFFFF);
		}
	}

	function onChangeThemes()
	{
		switch (ClientPrefs.data.themes) {
			case 'SB Engine':
				BaseOptionsMenu.background.color = FlxColor.BROWN;
			
			case 'Psych Engine':
				BaseOptionsMenu.background.color = 0xFFea71fd;
		}
	}

	function onChangeDiscordRichPresence() 
	{
		#if DISCORD_ALLOWED
		if (ClientPrefs.data.discordRPC == true) DiscordClient.initialize();
		else if (ClientPrefs.data.discordRPC == false) DiscordClient.shutdown();
		#end
	}
}
