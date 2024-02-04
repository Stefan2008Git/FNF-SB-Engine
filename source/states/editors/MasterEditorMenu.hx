package states.editors;

import backend.WeekData;

#if MODS_ALLOWED
import sys.FileSystem;
#end

import objects.Character;

import states.MainMenuState;
import states.FreeplayState;

class MasterEditorMenu extends MusicBeatState
{
	var options:Array<String> = [
		'Chart Editor',
		'Character Editor',
		'Dialogue Editor',
		'Dialogue Portrait Editor',
		'Menu Character Editor',
		'Note Splash Debug',
		'Week Editor'
	];
	private var background:FlxSprite;
	private var velocityBackground:FlxBackdrop;
	private var testSprite:FlxSprite;
	private var tipText:FlxText;
	private var testSpriteText:FlxSprite;
	private var characterEditor:FlxSprite;
	private var chartEditor:FlxSprite;
	private var dialogueEditor:FlxSprite;
	private var dialoguePortraitEditor:FlxSprite;
	private var menuCharacterEditor:FlxSprite;
	private var weekEditor:FlxSprite;
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var directories:Array<String> = [null];

	private var currentlySelected = 0;
	private var curDirectory = 0;
	private var directoryTxt:FlxText;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.BLACK;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Editors Main Menu", null);
		#end
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Mod Editors menu";

		background = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		switch (ClientPrefs.data.themes) {
			case 'SB Engine':
				background.color = 0xFF800080;
			
			case 'Psych Engine':
				background.color = 0xFF353535;
		}
		background.scrollFactor.set();
		background.screenCenter();
		background.antialiasing = ClientPrefs.data.antialiasing;
		background.updateHitbox();
		add(background);

		velocityBackground = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		velocityBackground.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		velocityBackground.visible = ClientPrefs.data.velocityBackground;
		FlxTween.tween(velocityBackground, {alpha: 0.7}, 1, {ease: FlxEase.sineInOut});
		add(velocityBackground);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var leText:Alphabet = new Alphabet(90, 320, options[i], true);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);
			leText.snapToPosition();
		}

		tipText = new FlxText(FlxG.width - 345, 35, 0, "", 32);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': tipText.setFormat(Paths.font("bahnschrift.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': tipText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'TGT Engine': tipText.setFormat(Paths.font("calibri.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Dave and Bambi': tipText.setFormat(Paths.font("comic.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}

		testSprite = FlxSpriteUtil.drawRoundRect(new FlxSprite(930, 10).makeGraphic(340, 440, FlxColor.TRANSPARENT), 0, 0, 340, 440, 55, 55, FlxColor.BLACK);
		testSprite.alpha = 0.5;
		add(testSprite);
		add(tipText);

		characterEditor = new FlxSprite(845, 30).loadGraphic(Paths.image('engineStuff/masterMenu/characterEditor'));
		characterEditor.scrollFactor.set();
		characterEditor.visible = false;
		characterEditor.antialiasing = ClientPrefs.data.antialiasing;
		characterEditor.scale.set(0.6, 0.6);
		add(characterEditor);

		chartEditor = new FlxSprite(1025, 205).loadGraphic(Paths.image('engineStuff/masterMenu/chartEditor'));
		chartEditor.scrollFactor.set();
		chartEditor.visible = false;
		chartEditor.antialiasing = ClientPrefs.data.antialiasing;
		chartEditor.scale.set(1.7, 1.7);
		add(chartEditor);

		dialogueEditor = new FlxSprite(845, 30).loadGraphic(Paths.image('engineStuff/masterMenu/dialogueEditor'));
		dialogueEditor.scrollFactor.set();
		dialogueEditor.visible = false;
		dialogueEditor.antialiasing = ClientPrefs.data.antialiasing;
		dialogueEditor.scale.set(0.6, 0.6);
		add(dialogueEditor);

		dialoguePortraitEditor = new FlxSprite(845, 30).loadGraphic(Paths.image('engineStuff/masterMenu/dialoguePortraitEditor'));
		dialoguePortraitEditor.scrollFactor.set();
		dialoguePortraitEditor.visible = false;
		dialoguePortraitEditor.antialiasing = ClientPrefs.data.antialiasing;
		dialoguePortraitEditor.scale.set(0.6, 0.6);
		add(dialoguePortraitEditor);

		menuCharacterEditor = new FlxSprite(840, 30).loadGraphic(Paths.image('engineStuff/masterMenu/menuCharacterEditor'));
		menuCharacterEditor.scrollFactor.set();
		menuCharacterEditor.visible = false;
		menuCharacterEditor.antialiasing = ClientPrefs.data.antialiasing;
		menuCharacterEditor.scale.set(0.6, 0.6);
		add(menuCharacterEditor);

		weekEditor = new FlxSprite(645, -50).loadGraphic(Paths.image('engineStuff/masterMenu/weekEditor'));
		weekEditor.scrollFactor.set();
		weekEditor.visible = false;
		weekEditor.antialiasing = ClientPrefs.data.antialiasing;
		weekEditor.scale.set(0.4, 0.4);
		add(weekEditor);
		
		#if MODS_ALLOWED
		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 42).makeGraphic(FlxG.width, 42, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		directoryTxt = new FlxText(textBG.x, textBG.y + 4, FlxG.width, '', 32);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': directoryTxt.setFormat(Paths.font("bahnschrift.ttf"), 32, FlxColor.WHITE, CENTER);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': directoryTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
			case 'TGT Engine': directoryTxt.setFormat(Paths.font("calibri.ttf"), 32, FlxColor.WHITE, CENTER);
			case 'Dave and Bambi': directoryTxt.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER);
		}
		directoryTxt.scrollFactor.set();
		add(directoryTxt);
		
		for (folder in Mods.getModDirectories())
		{
			directories.push(folder);
		}

		var found:Int = directories.indexOf(Mods.currentModDirectory);
		if(found > -1) curDirectory = found;
		changeDirectory();
		#end
		changeSelection();

		FlxG.mouse.visible = false;
		
		#if android
		addVirtualPad(FULL, A_B);
		#end
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}
		#if MODS_ALLOWED
		if(controls.UI_LEFT_P)
		{
			changeDirectory(-1);
		}
		if(controls.UI_RIGHT_P)
		{
			changeDirectory(1);
		}
		#end

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch(options[currentlySelected]) {
				case 'Chart Editor'://felt it would be cool maybe
					LoadingState.loadAndSwitchState(new ChartingState(), false);
				case 'Character Editor':
					LoadingState.loadAndSwitchState(new CharacterEditorState(Character.DEFAULT_CHARACTER, false));
				case 'Week Editor':
					MusicBeatState.switchState(new WeekEditorState());
				case 'Menu Character Editor':
					MusicBeatState.switchState(new MenuCharacterEditorState());
				case 'Dialogue Editor':
					LoadingState.loadAndSwitchState(new DialogueEditorState(), false);
				case 'Dialogue Portrait Editor':
					LoadingState.loadAndSwitchState(new DialogueCharacterEditorState(), false);
				case 'Note Splash Debug':
					LoadingState.loadAndSwitchState(new NoteSplashDebugState());
			}
			FlxG.sound.music.volume = 0;
			#if PRELOAD_ALL
			FreeplayState.destroyFreeplayVocals();
			#end
		}
		
		var bullShit:Int = 0;
		for (item in grpTexts.members)
		{
			item.targetY = bullShit - currentlySelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		super.update(elapsed);
	}

	/* private var moveCharacterEditorTween:FlxTween = null;
	private var moveChartEditorTween:FlxTween = null;
	private var moveDialogueEditorTween:FlxTween = null;
	private var moveDialoguePortraitEditorTween:FlxTween = null;
	private var moveMenuCharacterEditorTween:FlxTween = null;
	private var moveWeekEditorTween:FlxTween = null; */
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		currentlySelected += change;

		if (currentlySelected < 0)
			currentlySelected = options.length - 1;
		if (currentlySelected >= options.length)
			currentlySelected = 0;

		switch(options[currentlySelected]) {
			case 'Chart Editor':
				tipText.text = "Make a new chart";
				characterEditor.visible = false;
	            chartEditor.visible = true;
	            dialogueEditor.visible = false;
	            dialoguePortraitEditor.visible = false;
				menuCharacterEditor.visible = false;
	            weekEditor.visible = false;
				// FlxTween.color(testSprite, 1.3, FlxColor.PURPLE, FlxColor.BLACK, {ease: FlxEase.sineInOut});
			case 'Character Editor':
				tipText.text = "Make a new character";
				characterEditor.visible = true;
	            chartEditor.visible = false;
	            dialogueEditor.visible = false;
	            dialoguePortraitEditor.visible = false;
				menuCharacterEditor.visible = false;
	            weekEditor.visible = false;
				// FlxTween.color(testSprite, 1.3, FlxColor.GREEN, FlxColor.BLACK, {ease: FlxEase.sineInOut});
			case 'Week Editor':
				tipText.text = "Make a new week";
				characterEditor.visible = false;
	            chartEditor.visible = false;
	            dialogueEditor.visible = false;
	            dialoguePortraitEditor.visible = false;
				menuCharacterEditor.visible = false;
	            weekEditor.visible = true;
				// FlxTween.color(testSprite, 1.3, FlxColor.CYAN, FlxColor.BLACK, {ease: FlxEase.sineInOut});
			case 'Menu Character Editor':
				tipText.text = "Make a new story mode character";
				characterEditor.visible = false;
	            chartEditor.visible = false;
	            dialogueEditor.visible = false;
	            dialoguePortraitEditor.visible = false;
				menuCharacterEditor.visible = true;
	            weekEditor.visible = false;
				// FlxTween.color(testSprite, 1.3, FlxColor.YELLOW, FlxColor.BLACK, {ease: FlxEase.sineInOut});
			case 'Dialogue Editor':
				tipText.text = "Make a new dialogue";
				characterEditor.visible = false;
	            chartEditor.visible = false;
	            dialogueEditor.visible = true;
	            dialoguePortraitEditor.visible = false;
				menuCharacterEditor.visible = false;
	            weekEditor.visible = false;
				// FlxTween.color(testSprite, 1.3, FlxColor.GREEN, FlxColor.BLACK, {ease: FlxEase.sineInOut});
			case 'Dialogue Portrait Editor':
				tipText.text = "Make a new dialogue character";
				characterEditor.visible = false;
	            chartEditor.visible = false;
	            dialogueEditor.visible = false;
	            dialoguePortraitEditor.visible = true;
				menuCharacterEditor.visible = false;
	            weekEditor.visible = false;
				// FlxTween.color(testSprite, 1.3, FlxColor.YELLOW, FlxColor.BLACK, {ease: FlxEase.sineInOut});
			case 'Note Splash Debug':
				tipText.text = "Edit the note slpash position\nERROR: Image doesn't exist";
				characterEditor.visible = false;
	            chartEditor.visible = false;
	            dialogueEditor.visible = false;
	            dialoguePortraitEditor.visible = false;
				menuCharacterEditor.visible = false;
	            weekEditor.visible = false;
				// FlxTween.color(testSprite, 1.3, FlxColor.RED, FlxColor.BLACK, {ease: FlxEase.sineInOut});
		}
		/* if(moveCharacterEditorTween != null) moveCharacterEditorTween.cancel();
		moveCharacterEditorTween = FlxTween.tween(characterEditor, {y : characterEditor.y + 20}, 0.25, {ease: FlxEase.sineOut});

		if(moveChartEditorTween != null) moveChartEditorTween.cancel();
		moveChartEditorTween = FlxTween.tween(chartEditor, {y : chartEditor.y + 20}, 0.25, {ease: FlxEase.sineOut});

		if(moveDialogueEditorTween != null) moveDialogueEditorTween.cancel();
		moveDialogueEditorTween = FlxTween.tween(dialogueEditor, {y : dialogueEditor.y + 20}, 0.25, {ease: FlxEase.sineOut});
	
		if(moveDialoguePortraitEditorTween != null) moveDialoguePortraitEditorTween.cancel();
		moveDialoguePortraitEditorTween = FlxTween.tween(dialoguePortraitEditor, {y : dialoguePortraitEditor.y + 20}, 0.25, {ease: FlxEase.sineOut});

		if(moveMenuCharacterEditorTween != null) moveMenuCharacterEditorTween.cancel();
		moveMenuCharacterEditorTween = FlxTween.tween(menuCharacterEditor, {y : menuCharacterEditor.y + 20}, 0.25, {ease: FlxEase.sineOut});

		if(moveWeekEditorTween != null) moveWeekEditorTween.cancel();
		moveWeekEditorTween = FlxTween.tween(weekEditor, {y : weekEditor.y + 20}, 0.25, {ease: FlxEase.sineOut});*/ // Nope, we are not adding this shit on game
	}

	#if MODS_ALLOWED
	function changeDirectory(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curDirectory += change;

		if(curDirectory < 0)
			curDirectory = directories.length - 1;
		if(curDirectory >= directories.length)
			curDirectory = 0;
	
		WeekData.setDirectoryFromWeek();
		if(directories[curDirectory] == null || directories[curDirectory].length < 1)
			directoryTxt.text = '< No Mod Directory Loaded >';
		else
		{
			Mods.currentModDirectory = directories[curDirectory];
			directoryTxt.text = '< Loaded Mod Directory: ' + Mods.currentModDirectory + ' >';
		}
		directoryTxt.text = directoryTxt.text.toUpperCase();
	}
	#end

	/* private function makeTipTextLong() {
		tipText.x = FlxG.width - tipText.width - 6;

		testSprite.scale.x = FlxG.width - tipText.x + 6;
		testSprite.x = FlxG.width - (testSprite.scale.x / 2);
	} */ // Broken shit because of FlxSpriteUtil
}