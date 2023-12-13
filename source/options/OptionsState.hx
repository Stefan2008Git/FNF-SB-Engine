package options;

import states.MainMenuState;
import backend.StageData;
import flixel.addons.transition.FlxTransitionableState;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', #if desktop 'Controls', #end 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var currentlySelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	var tipText:FlxText;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
				Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu - (In Note Color Menu)";
			  	#if android
				removeVirtualPad();
				#end
			case 'Controls':
				Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu (In Controls Menu)";
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu (In Graphics Option Menu)";
				openSubState(new options.GraphicsSettingsSubState());
			  	#if android
				removeVirtualPad();
				#end
			case 'Visuals and UI':
				Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu (In Visuals UI Options Menu)";
				openSubState(new options.VisualsUISubState());
		    	#if android
				removeVirtualPad();
				#end
			case 'Gameplay':
				Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu (In Gameplay Menu Option)";
				#if android
				removeVirtualPad();
				#end
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Options Menu (Loading Adjust Delay Combo Menu)";
				MusicBeatState.switchState(new options.NoteOffsetState());
			  	#if android
				removeVirtualPad();
				#end
		}
	}

	var background:FlxSprite;
	var velocityBackground:FlxBackdrop;
	var androidControlsStyleTipText:FlxText;
	var customizeAndroidControlsTipText:FlxText;
	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("In the Options Menu", null);
		#end

		if (ClientPrefs.data.cacheOnGPU) Paths.clearStoredMemory();

		background = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		switch (ClientPrefs.data.themes) {
			case 'SB Engine':
				background.color = 0xFF800080;
			
			case 'Psych Engine':
				background.color = 0xFFea71fd;
		}
		background.scrollFactor.set();
		background.screenCenter();
		background.antialiasing = ClientPrefs.data.antialiasing;
		background.updateHitbox();
		add(background);

		velocityBackground = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		velocityBackground.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		velocityBackground.visible = ClientPrefs.data.velocityBackground;
		add(velocityBackground);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		if (ClientPrefs.data.cacheOnGPU) Paths.clearUnusedMemory();

		changeSelection();
		ClientPrefs.saveSettings();

		#if android
		addVirtualPad(UP_DOWN, A_B_X_Y);
		androidControlsStyleTipText = new FlxText(10, FlxG.height - 44, 0, "Press Y to open the Android controls style!", 16);
		customizeAndroidControlsTipText = new FlxText(10, FlxG.height - 24, 0, "Press X to customize the Android controls!", 16);
		androidControlsStyleTipText.setFormat("VCR OSD Mono", 17, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		customizeAndroidControlsTipText.setFormat("VCR OSD Mono", 17, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		androidControlsStyleTipText.borderSize = 1.25;
		androidControlsStyleTipText.scrollFactor.set();
		customizeAndroidControlsTipText.borderSize = 1.25;
		customizeAndroidControlsTipText.scrollFactor.set();
		add(androidControlsStyleTipText);
		add(customizeAndroidControlsTipText);
	  	#end

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		#if android
		if (MusicBeatState.virtualPad.buttonX.justPressed) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new android.AndroidControlsMenu());
		}
		if (MusicBeatState.virtualPad.buttonY.justPressed) {
			removeVirtualPad();
			openSubState(new android.HitboxSettingsSubState());
		}
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
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else MusicBeatState.switchState(new MainMenuState());
			Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion;
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[currentlySelected]);
	}
	
	function changeSelection(change:Int = 0) {
		currentlySelected += change;
		if (currentlySelected < 0)
			currentlySelected = options.length - 1;
		if (currentlySelected >= options.length)
			currentlySelected = 0;

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