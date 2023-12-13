package states;

import backend.WeekData;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import states.editors.MasterEditorMenu;
import options.OptionsState;

class MainMenuState extends MusicBeatState
{
	public static var sbEngineVersion:String = '3.0.0';
	public static var psychEngineVersion:String = '0.7.1h';
	public static var fnfEngineVersion:String = '0.2.8';
	public static var currentlySelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;

	var menuBackground:FlxSprite;
	var background:FlxSprite;
	var velocityBackground:FlxBackdrop;
	var sbEngineLogo:FlxSprite;
	var mainSide:FlxSprite;
	var versionSb:FlxText;
	var versionPsych:FlxText;
	var versionFnf:FlxText;
	
	var optionSelect:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		if (ClientPrefs.data.cacheOnGPU) Paths.clearStoredMemory();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();

		FlxG.cameras.reset(camGame);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionSelect.length - 4)), 0.1);
		menuBackground = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		menuBackground.scrollFactor.set(0, yScroll);
		menuBackground.setGraphicSize(Std.int(menuBackground.width * 1.175));
		menuBackground.updateHitbox();
		menuBackground.screenCenter();
		menuBackground.antialiasing = ClientPrefs.data.antialiasing;
		add(menuBackground);

		velocityBackground = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		velocityBackground.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		velocityBackground.visible = ClientPrefs.data.velocityBackground;
		add(velocityBackground);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		background = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		background.scrollFactor.set(0, yScroll);
		background.setGraphicSize(Std.int(background.width * 1.175));
		background.updateHitbox();
		background.screenCenter();
		background.visible = false;
		background.antialiasing = ClientPrefs.data.antialiasing;
		switch (ClientPrefs.data.themes) {
			case 'SB Engine':
				background.color = 0xFF800080;
			
			case 'Psych Engine':
				background.color = 0xFFea71fd;
		}
		add(background);

		mainSide = new FlxSprite(0).loadGraphic(Paths.image('mainSide'));
		mainSide.scrollFactor.x = 0;
		mainSide.scrollFactor.y = 0;
		mainSide.setGraphicSize(Std.int(mainSide.width * 0.75));
		mainSide.updateHitbox();
		mainSide.screenCenter();
		mainSide.antialiasing = ClientPrefs.data.antialiasing;
		mainSide.x = -500;
		mainSide.y = -90;
		add(mainSide);

		sbEngineLogo = new FlxSprite(0).loadGraphic(Paths.image('sbEngineLogo'));
		sbEngineLogo.scrollFactor.x = 0;
		sbEngineLogo.scrollFactor.y = 0;
		sbEngineLogo.antialiasing = ClientPrefs.data.antialiasing;
		sbEngineLogo.setGraphicSize(Std.int(menuBackground.width * 0.32));
		sbEngineLogo.updateHitbox();
		sbEngineLogo.screenCenter();
		sbEngineLogo.x = 1000;
		sbEngineLogo.y = 90;
		sbEngineLogo.scale.x = 1;
		sbEngineLogo.scale.y = 1;
		add(sbEngineLogo);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionSelect.length > 6) {
			scale = 6 / optionSelect.length;
		}*/

		for (i in 0...optionSelect.length)
		{
			var offset:Float = 108 - (Math.max(optionSelect.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionSelect[i]);
			menuItem.animation.addByPrefix('idle', optionSelect[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionSelect[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			FlxTween.tween(menuItem, {x: menuItem.width / 4 + (i * 60) - 75}, 1.3, {ease: FlxEase.expoInOut});
			menuItems.add(menuItem);
			var scr:Float = (optionSelect.length - 4) * 0.135;
			if (optionSelect.length < 6)
				scr = 0;
			menuItem.scale.set(0.8, 0.8);
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollow, null, 0);

		FlxTween.tween(camGame, {zoom: 1}, 1.1, {ease: FlxEase.expoInOut});
		FlxTween.tween(background, {angle: 0}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(mainSide, {x: -80}, 0.9, {ease: FlxEase.quartInOut});
		FlxTween.tween(sbEngineLogo, {x: 725}, 0.9, {ease: FlxEase.quartInOut});
		FlxTween.angle(sbEngineLogo, sbEngineLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		new FlxTimer().start(2, function(tmr:FlxTimer) {
			if (sbEngineLogo.angle == -10)
				FlxTween.angle(sbEngineLogo, sbEngineLogo.angle, 10, 2, {ease: FlxEase.quartInOut});
			else
				FlxTween.angle(sbEngineLogo, sbEngineLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		}, 0);

		versionSb = new FlxText(12, FlxG.height - 64, 0, "SB Engine v" + sbEngineVersion + " (Modified Psych Engine)", 16);
		versionPsych = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 16);
		versionFnf = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + fnfEngineVersion, 16);
		versionSb.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionPsych.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionFnf.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionSb.scrollFactor.set();
		versionPsych.scrollFactor.set();
		versionFnf.scrollFactor.set();
		add(versionSb);
		add(versionPsych);
		add(versionFnf);

		if (ClientPrefs.data.cacheOnGPU) Paths.clearUnusedMemory();

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

   	 	#if mobile
    	addVirtualPad(UP_DOWN, A_B_C);
   		#end

		super.create();
	}

	var selectedSomething:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (!selectedSomething)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomething = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				selectedSomething = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				if (ClientPrefs.data.flashing)
					FlxFlicker.flicker(background, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (currentlySelected != spr.ID)
						{
							FlxTween.tween(camGame, {zoom: 10}, 1.6, {ease: FlxEase.expoIn});
						    FlxTween.tween(menuBackground, {angle: 90}, 1.6, {ease: FlxEase.expoIn});
						    FlxTween.tween(spr, {x: -600}, 0.6, {
							ease: FlxEase.backIn,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
						FlxTween.tween(mainSide, {x: -500}, 1.2, {ease: FlxEase.quartInOut});
						FlxTween.tween(sbEngineLogo, {x: 1500}, 1.2, {ease: FlxEase.quartInOut});
						FlxTween.angle(sbEngineLogo, sbEngineLogo.angle, 0, 0, {ease: FlxEase.quartInOut});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionSelect[currentlySelected];

						switch (daChoice) {
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
								Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Story Mode";
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());
								Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Freeplay Menu";
							#if MODS_ALLOWED
							case 'mods':
								MusicBeatState.switchState(new ModsMenuState());
								Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Mods Menu";
							#end
							case 'credits':
								MusicBeatState.switchState(new CreditsState());
								Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Credits Menu";
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu";
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
								}
							}
						});
					}
				});
			}
			#if (desktop || android)
			else if (controls.justPressed('debug_1') #if android || MusicBeatState.virtualPad.buttonC.justPressed #end)
			{
				selectedSomething = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			// spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		currentlySelected += huh;

		if (currentlySelected >= menuItems.length)
			currentlySelected = 0;
		if (currentlySelected < 0)
			currentlySelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == currentlySelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
