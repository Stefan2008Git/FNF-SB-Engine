package options;

import states.MainMenuState;
import backend.StageData;
import flixel.addons.transition.FlxTransitionableState;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', #if desktop 'Controls', #end 'Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', #if android 'Android Options' #end];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var currentlySelected:Int = 0;
	public static var onPlayState:Bool = false;
	var tipText:FlxText;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			  	#if android
				removeVirtualPad();
				#end
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			  	#if android
				removeVirtualPad();
				#end
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
		    	#if android
				removeVirtualPad();
				#end
			case 'Gameplay':
				#if android
				removeVirtualPad();
				#end
				openSubState(new options.GameplaySettingsSubState());
			case 'Delay and Combo':
				Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu (Loading Adjust Delay Combo Menu)";
				FlxG.switchState(() -> new options.NoteOffsetState());
				FlxG.sound.music.pause();
			  	#if android
				removeVirtualPad();
				#end
			case 'Android Options':
				#if android
				removeVirtualPad();
				openSubState(new options.android.AndroidOptionsSubState());
				#end
		}
	}

	var background:FlxSprite;
	var checkerboard:FlxBackdrop;
	var androidControlsStyleTipText:FlxText;
	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;
	var gearIcon:FlxSprite;
	var optionsMenu:FlxSprite;
	var optionsTipTxt:FlxText;
	var optionsTipTxtBG:FlxSprite;

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Options Menu", null);
		#end

		if (onPlayState) 
			Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu - Paused"; 
		else 
			Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu";

		if (ClientPrefs.data.cacheOnGPU) Paths.clearStoredMemory();

		background = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		switch (ClientPrefs.data.themes) {
			case 'SB Engine':
				background.color = FlxColor.BROWN;
			
			case 'Psych Engine':
				background.color = 0xFFea71fd;
		}
		background.scrollFactor.set();
		background.screenCenter();
		background.antialiasing = ClientPrefs.data.antialiasing;
		background.updateHitbox();
		add(background);

		checkerboard = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		checkerboard.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		checkerboard.visible = ClientPrefs.data.checkerboard;
		add(checkerboard);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (85 * (i - (options.length / 2))) + 100;
			optionText.x = 135;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		gearIcon = new FlxSprite(110, 26).loadGraphic(Paths.image('engineStuff/options/main/gearIcon'));
		gearIcon.scale.x = 0.7;
		gearIcon.scale.y = 0.7;
		gearIcon.antialiasing = ClientPrefs.data.antialiasing;
		add(gearIcon);

		optionsMenu = new FlxSprite(130, 26).loadGraphic(Paths.image('engineStuff/options/main/optionsMenu'));
		optionsMenu.scale.x = 0.6;
		optionsMenu.scale.y = 0.6;
		optionsMenu.antialiasing = ClientPrefs.data.antialiasing;
		add(optionsMenu);

		optionsTipTxt = new FlxText(FlxG.width - 345, 35, 0, "", 32);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': optionsTipTxt.setFormat(Paths.font("bahnschrift.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'TGT Engine': optionsTipTxt.setFormat(Paths.font("calibri.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Dave and Bambi': optionsTipTxt.setFormat(Paths.font("comic.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			default: optionsTipTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}

		optionsTipTxtBG = FlxSpriteUtil.drawRoundRect(new FlxSprite(930, 10).makeGraphic(340, 440, FlxColor.TRANSPARENT), 0, 0, 340, 440, 55, 55, FlxColor.BLACK);
		optionsTipTxtBG.alpha = 0.5;
		add(optionsTipTxtBG);
		add(optionsTipTxt);

		#if android
		androidControlsStyleTipText = new FlxText(150, FlxG.height - 24, 0, "Press C to open the Android controls style!", 16);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': 
				androidControlsStyleTipText.setFormat(Paths.font("bahnschrift.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

			case 'TGT Engine': 
				androidControlsStyleTipText.setFormat(Paths.font("calibri.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Dave and Bambi': 
				androidControlsStyleTipText.setFormat(Paths.font("comic.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

			default:
				androidControlsStyleTipText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		androidControlsStyleTipText.borderSize = 1.25;
		androidControlsStyleTipText.scrollFactor.set();
		add(androidControlsStyleTipText);
		#end

		if (ClientPrefs.data.cacheOnGPU) Paths.clearUnusedMemory();

		changeSelection();
		ClientPrefs.saveSettings();

		#if android addVirtualPad(UP_DOWN, A_B_C); #end

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		#if android
		if (MusicBeatState.virtualPad.buttonC.justReleased) // Just in case to see if will open the substate
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(() -> new options.android.AndroidControlsMenuState());

		/*if (MusicBeatState.virtualPad.buttonY.justReleased) // Archived
			removeVirtualPad();
			openSubState(new options.android.AndroidOptionsSubState());*/
		#end

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(() -> new PlayState());
				
				FlxG.sound.music.volume = 0;
			}
			else FlxG.switchState(() -> new MainMenuState());
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[currentlySelected]);
	}
	
	function changeSelection(change:Int = 0) {
		currentlySelected += change;
		if (currentlySelected < 0)
			currentlySelected = options.length - 1;
		if (currentlySelected >= options.length)
			currentlySelected = 0;

		switch(options[currentlySelected]) {
			case 'Note Colors':
				optionsTipTxt.text = "Change the note colors";

			case 'Controls':
				optionsTipTxt.text = "Change the keybinds";

			case 'Graphics':
				optionsTipTxt.text = "Edit graphic settings";

			case 'Visuals and UI':
				optionsTipTxt.text = "Edit engine gui settings";

			case 'Gameplay':
				optionsTipTxt.text = "Edit in-game settings";

			case 'Delay and Combo':
				optionsTipTxt.text = "Edit a combo note offset";

			default:
				optionsTipTxt.text = null;
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - currentlySelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}
