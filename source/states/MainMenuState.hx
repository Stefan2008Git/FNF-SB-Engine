package states;

import states.editors.MasterEditorMenu;
import options.OptionsState;

enum MainMenuColumn {
	LEFT;
	RIGHT;
}

class MainMenuState extends MusicBeatState
{
	public static var sbEngineVersion:String = '3.1.0'; // This is also used for Discord RPC
	public static var psychEngineVersion:String = '0.7.1h'; // This is also used for Discord RPC
	public static var fnfEngineVersion:String = '0.4';
	public var versionSb:FlxText;
	public var versionPsych:FlxText;
	public var versionFnf:FlxText;
	public static var currentlySelected:Int = 0;
	public static var curSelected:Int = 0;
	public static var curColumn:MainMenuColumn = LEFT;
	var allowMouse:Bool = #if android false; #else true; #end //Turn this off to block mouse movement in menus

	var menuItems:FlxTypedGroup<FlxSprite>;
	var menuBG:FlxSprite;
	var brown:FlxSprite;
	var checkerboard:FlxBackdrop;
	var sbEngineLogo:FlxSprite;
	var rightItem:FlxSprite;

	//Centered/Text options
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		'credits'
	];

	var rightOption:String = 'options';
	var camFollow:FlxObject;

	override function create()
	{
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + sbEngineVersion;
		if (ClientPrefs.data.cacheOnGPU) Paths.clearStoredMemory();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		menuBG = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		menuBG.scrollFactor.set(0, yScroll);
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.175));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.data.antialiasing;
		menuBG.color = 0xfffde871;
		add(menuBG);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		brown = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		brown.setGraphicSize(Std.int(brown.width * 1.175));
		brown.scrollFactor.x = 0;
		brown.scrollFactor.y = 0;
		brown.updateHitbox();
		brown.screenCenter();
		brown.visible = false;
		brown.antialiasing = ClientPrefs.data.antialiasing;
		switch (ClientPrefs.data.themes) {
			case 'SB Engine':
				brown.color = FlxColor.BROWN;
			
			case 'Psych Engine':
				brown.color = 0xFFea71fd;
		}
		add(brown);

		checkerboard = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		checkerboard.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		checkerboard.visible = ClientPrefs.data.checkerboard;
		checkerboard.scrollFactor.x = 0;
		checkerboard.scrollFactor.y = 0;
		add(checkerboard);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (num => option in optionShit)
		{
			var item:FlxSprite = createMenuItem(option, 35, (num * 140) + 90);
			item.y += (4 - optionShit.length) * 70; // Offsets for when you have anything other than 4 items
			// item.screenCenter(X);
			item.scale.x = 0.85;
			item.scale.y = 0.85;
		}

		if (rightOption != null)
		{
			rightItem = createMenuItem(rightOption, FlxG.width - 30, 490);
			rightItem.x -= rightItem.width;
		}

		sbEngineLogo = new FlxSprite(580, -50).loadGraphic(Paths.image("engineStuff/main/sbEngineLogo"));
		sbEngineLogo.antialiasing = ClientPrefs.data.antialiasing;
		sbEngineLogo.scale.x = 0.75;
		sbEngineLogo.scale.y = 0.75;
		sbEngineLogo.scrollFactor.x = 0;
		sbEngineLogo.scrollFactor.y = 0;
		add(sbEngineLogo);

		versionSb = new FlxText(420, FlxG.height - 24, 0, "SB Engine v" + sbEngineVersion, 16);
		versionPsych = new FlxText(740, FlxG.height - 24, 0, "Psych Engine v" + psychEngineVersion, 16);
		versionFnf = new FlxText(400, FlxG.height - 24, 0, "Friday Night Funkin' v" + fnfEngineVersion, 16);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				versionSb.setFormat("Bahnschrift", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionPsych.setFormat("Bahnschrift", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionFnf.setFormat("Bahnschrift", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			case 'Dave and Bambi':
				versionSb.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionPsych.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionFnf.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			case 'TGT Engine':
				versionSb.setFormat("Calibri", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionPsych.setFormat("Calibri", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionFnf.setFormat("Calibri", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			default:
				versionSb.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionPsych.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionFnf.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		versionSb.scrollFactor.set();
		versionPsych.scrollFactor.set();
		versionFnf.scrollFactor.set();
		versionFnf.screenCenter(X);
		add(versionSb);
		add(versionPsych);
		add(versionFnf);
		changeItem();

		FlxTween.tween(sbEngineLogo, {y: 20}, 2.4, {ease: FlxEase.sineInOut, type: PINGPONG, startDelay: 0.1});

		if (ClientPrefs.data.cacheOnGPU) Paths.clearUnusedMemory();

		super.create();

		#if mobile addVirtualPad(FULL, A_B); #end

		FlxG.camera.follow(camFollow, null, 0.15);
	}

	function createMenuItem(name:String, x:Float, y:Float):FlxSprite
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_$name');
		menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
		menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
		menuItem.animation.play('idle');
		menuItem.updateHitbox();
		
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
		menuItems.add(menuItem);
		return menuItem;
	}

	var selectedSomethin:Bool = false;

	var timeNotMoving:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (allowMouse && FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) //more accurate than FlxG.mouse.justMoved
			{
				FlxG.mouse.visible = true;
				timeNotMoving = 0;

				var selectedItem:FlxSprite;
				switch(curColumn)
				{
					case LEFT:
						selectedItem = menuItems.members[curSelected];
					case RIGHT:
						selectedItem = rightItem;
				}

				if(rightItem != null && FlxG.mouse.overlaps(rightItem))
				{
					if(selectedItem != rightItem)
					{
						curColumn = RIGHT;
						changeItem();
					}
				}
				else
				{
					var dist:Float = -1;
					var distItem:Int = -1;
					for (i in 0...optionShit.length)
					{
						var memb:FlxSprite = menuItems.members[i];
						if(FlxG.mouse.overlaps(memb))
						{
							var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - FlxG.mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - FlxG.mouse.screenY, 2));
							if (dist < 0 || distance < dist)
							{
								dist = distance;
								distItem = i;
							}
						}
					}

					if(distItem != -1 && curSelected != distItem)
					{
						curColumn = LEFT;
						curSelected = distItem;
						changeItem();
					}
				}
			}
			else
			{
				timeNotMoving += elapsed;
				if(timeNotMoving > 1) FlxG.mouse.visible = false;
			}

			switch(curColumn)
			{
				case LEFT:
					if(controls.UI_RIGHT_P && rightOption != null)
					{
						curColumn = RIGHT;
						changeItem();
					}

				case RIGHT:
					if(controls.UI_LEFT_P)
					{
						curColumn = LEFT;
						changeItem();
					}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(() -> new TitleState());
			}

			if (controls.ACCEPT || (FlxG.mouse.justReleased && allowMouse))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
					selectedSomethin = true;
					FlxG.mouse.visible = false;

					if (ClientPrefs.data.flashing)
						FlxFlicker.flicker(brown, 1.1, 0.15, false);

					var item:FlxSprite;
					var option:String;
					switch(curColumn)
					{
						case LEFT:
							option = optionShit[curSelected];
							item = menuItems.members[curSelected];

						case RIGHT:
							option = rightOption;
							item = rightItem;
					}

					FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (option) {
							case 'story_mode':
								FlxG.mouse.visible = false;
								FlxG.switchState(() -> new StoryMenuState());
							case 'freeplay':
								FlxG.mouse.visible = false;
								FlxG.switchState(() -> new FreeplayState());
							#if MODS_ALLOWED
							case 'mods':
								FlxG.mouse.visible = false;
								FlxG.switchState(() -> new ModsMenuState());
							#end
							case 'credits':
								FlxG.mouse.visible = false;
								FlxG.switchState(() -> new CreditsState());
							case 'options':
								FlxG.mouse.visible = false;
								FlxG.switchState(() -> new options.OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
								}
							}
						});
					
					for (memb in menuItems)
					{
						if(memb == item)
							continue;

						FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.sineInOut});
						FlxTween.tween(sbEngineLogo, {alpha: 0}, 0.4, {ease: FlxEase.sineInOut});
					}
				}
			}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		if(change != 0) curColumn = LEFT;
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (item in menuItems)
		{
			item.animation.play('idle');
			item.centerOffsets();
		}

		var selectedItem:FlxSprite;
		switch(curColumn)
		{
			case LEFT:
				selectedItem = menuItems.members[curSelected];
			case RIGHT:
				selectedItem = rightItem;
		}
		selectedItem.animation.play('selected');
		selectedItem.centerOffsets();
		camFollow.y = selectedItem.getGraphicMidpoint().y;
	}
}
