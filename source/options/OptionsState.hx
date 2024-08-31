package options;

import states.MainMenuState;
import backend.StageData;
import mobile.substates.MobileControlSelectSubState;
#if (target.threaded)
import sys.thread.Thread;
import sys.thread.Mutex;
#end

class OptionsState extends MusicBeatState
{
	var options:Array<String> = [
		'Note Colors',
		'Controls',
		'Adjust Delay and Combo',
		'Graphics',
		'Visuals',
		'Gameplay'
		#if TRANSLATIONS_ALLOWED , 'Language' #end
		,'Mobile Options'
	];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	#if (target.threaded) var mutex:Mutex = new Mutex(); #end

	function openSelectedSubstate(label:String) {
		if (label != "Adjust Delay and Combo"){
			removeTouchPad();
			persistentUpdate = false;
		}
		switch(label)
		{
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				switch (controls.mobileC)
				{
					case true:
						persistentUpdate = false;
						openSubState(new MobileControlSelectSubState());
					default: openSubState(new options.ControlsSubState());
				}
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals':
				openSubState(new options.VisualsSettingsSubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				MusicBeatState.switchState(new options.NoteOffsetState());
			case 'Mobile Options':
				openSubState(new mobile.options.MobileOptionsSubState());
			#if TRANSLATIONS_ALLOWED
			case 'Language':
				openSubState(new options.LanguageSubState());
			#end
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create()
	{
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (num => option in options)
		{
			var optionText:Alphabet = new Alphabet(0, 0, Language.getPhrase('options_$option', option), true);
			optionText.screenCenter();
			optionText.y += (92 * (num - (options.length / 2))) + 45;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		addTouchPad('UP_DOWN', 'A_B');

		#if (target.threaded)
		Thread.create(()->{
			mutex.acquire();

			for (music in VisualsSettingsSubState.pauseMusics)
			{
				if (music.toLowerCase() != "none")
					Paths.music(Paths.formatToSongPath(music));
			}

			mutex.release();
		});
		#end

		super.create();
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end
		controls.isInSubstate = false;
        removeTouchPad();
		addTouchPad('UP_DOWN', 'A_B');
		persistentUpdate = true;
	}

	var exiting = false;
	override function update(elapsed:Float) {
		super.update(elapsed);

		if(!exiting) {
			if (controls.UI_UP_P)
				changeSelection(-1);
			if (controls.UI_DOWN_P)
				changeSelection(1);

			if (controls.BACK)
			{
				exiting = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				if(onPlayState)
				{
					StageData.loadDirectory(PlayState.SONG);
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
				}
				else MusicBeatState.switchState(new MainMenuState());
			}
			else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);

		for (num => item in grpOptions.members)
		{
			item.targetY = num - curSelected;
			item.alpha = 0.6;
			if (item.targetY == 0)
			{
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