package backend;

import states.TitleState;

// Add a variable here and it will get automatically saved
@:structInit class SaveVariables {
	public var downScroll:Bool = false;
	public var middleScroll:Bool = false;
	public var opponentStrums:Bool = true;
	public var showFPS:Bool = true;
	public var totalFPS:Bool = false;
	public var memory:Bool = true;
	public var maxMemory:Bool = false;
	public var engineVersion:Bool = false;
	public var debugInfo:Bool = false;
	public var rainbowFPS:Bool = false;
	public var redText:Bool = true;
	public var fpsResize:Float = 1;
	public var inGameLogs:Bool = false;
	public var watermarkIcon:Bool = true;
	public var iconResize:Float = 1;
	public var flashing:Bool = true;
	public var autoPause:Bool = true;
	public var antialiasing:Bool = true;
	public var noteSkin:String = 'Default';
	public var splashSkin:String = 'Psych';
	public var splashAlpha:Float = 0.6;
	public var lowQuality:Bool = false;
	public var shaders:Bool = true;
	public var cacheOnGPU:Bool = #if !switch false #else true #end; //From Stilic
	public var framerate:Int = 60;
	public var camZooms:Bool = true;
	public var hideHud:Bool = false;
	public var noteOffset:Int = 0;
	public var arrowRGB:Array<Array<FlxColor>> = [
		[0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
		[0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
		[0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
		[0xFFF9393F, 0xFFFFFFFF, 0xFF651038]];
	public var arrowRGBPixel:Array<Array<FlxColor>> = [
		[0xFFE276FF, 0xFFFFF9FF, 0xFF60008D],
		[0xFF3DCAFF, 0xFFF4FFFF, 0xFF003060],
		[0xFF71E300, 0xFFF6FFE6, 0xFF003100],
		[0xFFFF884E, 0xFFFFFAF5, 0xFF6C0000]];

	public var ghostTapping:Bool = true;
	public var timeBarType:String = 'Time Elapsed';

  	//  Mobile Stuff
	public var hitboxMode:String = 'New';
	public var hitboxExtend:Bool = false;
	public var hitboxLocation:String = 'Bottom';
	public var hitboxAlpha:Float = 0.2; //someone request this lol
	public var hitboxHints:Bool = true;
	public var virtualPadAlpha:Float = 0.75;
	public var virtualPadSpace:Array<Float> = [FlxG.width - 44 * 3, FlxG.height - 45 * 3];
	public var dynamicColor:Bool = false;
	public var screenSaver:Bool = true;
	public var vibration:Bool = true;
	public var toastText:Bool = true;

	public var scoreZoom:Bool = true;
	public var noReset:Bool = false;
	public var healthBarAlpha:Float = 1;
	public var hitsoundVolume:Float = 0;
	public var pauseMusic:String = 'Tea Time';
	public var checkForUpdates:Bool = true;
	public var comboStacking:Bool = true;
	public var themes:String = 'SB Engine';
	public var checkerboard:Bool = true;
	public var gameStyle:String = 'SB Engine';
	public var judgementCounter:Bool = true;
	public var judgementCounterStyle:String = 'Original';
	public var judgementZoom:Bool = true;
	public var watermark:Bool = true;
	public var watermarkStyle:String = 'SB Engine';
	public var randomEngineNames:Bool = false;
	public var objects:Bool = true;
	public var timeBar:Bool = true;
	public var iconBounce:Bool = true;
	public var cameraMovement:Bool = true;
	public var arrowGlow:Bool = true;
	public var opponentArrowGlow:Bool = true;
	public var scoreText:Bool = true;
	public var textSineEffect:Bool = true;
	public var shakeObjects:Bool = true;
	public var opponentHealthColor:Bool = false;
	public var autoplayTextOnTimeBar:Bool = true;
	public var guitarHeroSustains:Bool = true;
	public var originalHPBar:Bool = false;
	public var smoothHealth:Bool = true;
	public var smoothScore:Bool = true;
	public var tweenableTimeTxt:Bool = false;
	public var tweenableScoreTxt:Bool = false;
	public var millisecondTxt:Bool = false;
	public var ratingPopup:Bool = true;
	public var ratingComboPopup:Bool = true;
	public var ratingComboNumberPopup:Bool = true;
	public var mainMenuMusic:String = 'SB Engine';
	public var resultsScreen:Bool = false;
	public var loadingScreen:Bool = true;
	public var gameOverScreen:Bool = true;
	public var songPercentage:Bool = false;
	public var fadeTransition:Bool = true;
	public var timeTxt:Bool = true;
	public var accuraryStyle:String = 'Judgement';
	public var leftToRightBar:Bool = true;
	public var betterCutscene:Bool = true;
	public var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'healthDran' => 0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false
	];

	public var comboOffset:Array<Int> = [0, 0, 0, 0];
	public var ratingOffset:Int = 0;
	public var impressiveWindow:Int = 25;
	public var sickWindow:Int = 45;
	public var goodWindow:Int = 90;
	public var badWindow:Int = 135;
	public var safeFrames:Float = 10;
	public var discordRPC:Bool = true;
	// public var betterCrashHandler:Bool = true;
}

class ClientPrefs {
	public static var data:SaveVariables = {};
	public static var defaultData:SaveVariables = {};

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_up'		=> [J],
		'note_left'		=> [D],
		'note_down'		=> [F],
		'note_right'	=> [K],
		
		'ui_up'			=> [W, UP],
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R],
		
		'volume_mute'	=> [ZERO],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN],
		'debug_2'		=> [EIGHT],

		'full_screen'   => [F11],
		'refresh_game'  => [F5],
		'screenshot'    => [F3],
	];
	public static var gamepadBinds:Map<String, Array<FlxGamepadInputID>> = [
		'note_up'		=> [DPAD_UP, Y],
		'note_left'		=> [DPAD_LEFT, X],
		'note_down'		=> [DPAD_DOWN, A],
		'note_right'	=> [DPAD_RIGHT, B],
		
		'ui_up'			=> [DPAD_UP, LEFT_STICK_DIGITAL_UP],
		'ui_left'		=> [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
		'ui_down'		=> [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
		'ui_right'		=> [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
		
		'accept'		=> [A, START],
		'back'			=> [B],
		'pause'			=> [START],
		'reset'			=> [BACK]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;
	public static var defaultButtons:Map<String, Array<FlxGamepadInputID>> = null;

	public static function resetKeys(controller:Null<Bool> = null) //Null = both, False = Keyboard, True = Controller
	{
		if(controller != true)
			for (key in keyBinds.keys())
				if(defaultKeys.exists(key))
					keyBinds.set(key, defaultKeys.get(key).copy());

		if(controller != false)
			for (button in gamepadBinds.keys())
				if(defaultButtons.exists(button))
					gamepadBinds.set(button, defaultButtons.get(button).copy());
	}

	public static function clearInvalidKeys(key:String) {
		var keyBind:Array<FlxKey> = keyBinds.get(key);
		var gamepadBind:Array<FlxGamepadInputID> = gamepadBinds.get(key);
		while(keyBind != null && keyBind.contains(NONE)) keyBind.remove(NONE);
		while(gamepadBind != null && gamepadBind.contains(NONE)) gamepadBind.remove(NONE);
	}

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		defaultButtons = gamepadBinds.copy();
	}

	public static function saveSettings() {
		for (key in Reflect.fields(data)) {
			//TraceText.makeTheTraceText('saved variable: $key');
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));
		}
		FlxG.save.flush();

		//Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		var save:FlxSave = new FlxSave();
		save.bind('dataSaver', CoolUtil.getSavePath());
		save.data.keyboard = keyBinds;
		save.data.gamepad = gamepadBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
		TraceText.makeTheTraceText('Settings saved!');
	}

	public static function loadPrefs() {
		for (key in Reflect.fields(data)) {
			if (key != 'gameplaySettings' && Reflect.hasField(FlxG.save.data, key)) {
				//TraceText.makeTheTraceText('loaded variable: $key');
				Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));
			}
		}
		
		if (Main.fpsVar != null) Main.fpsVar.visible = data.showFPS;
		if (Main.watermark != null) Main.watermark.visible = data.watermarkIcon;

		#if (!html5 && !switch)
		FlxG.autoPause = ClientPrefs.data.autoPause;

		if(FlxG.save.data.framerate == null) {
			final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
			data.framerate = Std.int(FlxMath.bound(refreshRate, 60, 240));
		}
		#end

		if(data.framerate > FlxG.drawFramerate) {
			FlxG.updateFramerate = data.framerate;
			FlxG.drawFramerate = data.framerate;
		} else {
			FlxG.drawFramerate = data.framerate;
			FlxG.updateFramerate = data.framerate;
		}

		if(FlxG.save.data.gameplaySettings != null) {
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
				data.gameplaySettings.set(name, value);
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		#if DISCORD_ALLOWED DiscordClient.check(); #end

		// controls on a separate save file
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		if(save != null)
		{
			if(save.data.keyboard != null) {
				var loadedControls:Map<String, Array<FlxKey>> = save.data.keyboard;
				for (control => keys in loadedControls) {
					if(keyBinds.exists(control)) keyBinds.set(control, keys);
				}
			}
			if(save.data.gamepad != null) {
				var loadedControls:Map<String, Array<FlxGamepadInputID>> = save.data.gamepad;
				for (control => keys in loadedControls) {
					if(gamepadBinds.exists(control)) gamepadBinds.set(control, keys);
				}
			}
			reloadVolumeKeys();
		}
	}


	// what to do before application get closed?
	public static var onExitFunction:Function = function()
	{
		// null
	};

	public static function setExitHandler(func:Function):Void
	{
		trace("exit handler change: " + func);
		#if openfl_legacy
		openfl.Lib.current.stage.onQuit = function()
		{
			func();
			openfl.Lib.close();
		};
		#else
		openfl.Lib.current.stage.application.onExit.add(function(code)
		{
			func();
		});
		#end

		onExitFunction = func;
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic = null, ?customDefaultValue:Bool = false):Dynamic {
		if(!customDefaultValue) defaultValue = defaultData.gameplaySettings.get(name);
		return /*PlayState.isStoryMode ? defaultValue : */ (data.gameplaySettings.exists(name) ? data.gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadVolumeKeys() {
		TitleState.muteKeys = keyBinds.get('volume_mute').copy();
		TitleState.volumeDownKeys = keyBinds.get('volume_down').copy();
		TitleState.volumeUpKeys = keyBinds.get('volume_up').copy();
		toggleVolumeKeys(true);
	}
	public static function toggleVolumeKeys(turnOn:Bool) {
		final emptyArray = [];
		FlxG.sound.muteKeys = turnOn ? TitleState.muteKeys : emptyArray;
		FlxG.sound.volumeDownKeys = turnOn ? TitleState.volumeDownKeys : emptyArray;
		FlxG.sound.volumeUpKeys = turnOn ? TitleState.volumeUpKeys : emptyArray;
	}
}
