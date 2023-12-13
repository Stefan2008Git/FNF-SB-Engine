package options;

import objects.Note;
import objects.StrumNote;
import objects.Alphabet;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool');
		addOption(option);
		
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.', 'showFPS', 'bool');
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('Total FPS Counter',
			'If checked, shows Total FPS Counter.', 'showTotalFPS', 'bool');
		addOption(option);

		var option:Option = new Option('Memory Counter',
			'If unchecked, hides memory on FPS Counter.', 'memory', 'bool');
		addOption(option);

		var option:Option = new Option('Memory Peak Counter',
			'If checked, shows maximum memory on FPS Counter.', 'totalMemory', 'bool');
		addOption(option);

		var option:Option = new Option('Engine Version Counter',
			'If checked, shows engine version on FPS Counter.', 'engineVersion', 'bool');
		addOption(option);

		var option:Option = new Option('Debug Info Counter',
			'If checked, shows debug info on FPS Counter.', 'debugInfo', 'bool');
		addOption(option);

		var option:Option = new Option('Objects',
			'If unchecked, disable some objects for optimization\nFor example: Girlfriend and logo had an trail added.', 'objects', 'bool');
		addOption(option);

		#if desktop
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord",
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
		    'If unchecked, this option is disabling velocity background for optimization.', 'velocityBackground', 'bool');
		addOption(option);

		var option:Option = new Option('Themes:', 
			'Change theme from different engines. More themes are coming very soon\nThis option is on alpha state, so maybe can be buggy.', 'themes', 'string', ['SB Engine', 'Psych Engine']);
		addOption(option);

		super();
	}

	function onChangeAutoPause()
	{
		FlxG.autoPause = ClientPrefs.data.autoPause;
	}
	
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	
}
