package options.android;

import lime.system.System;

class AndroidOptionsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Android Customization';

		var option:Option = new Option('Space Extend',
			"Allow Extend Space Control --Made by NF|Beihu",
			'hitboxExtend',
			'bool');
		addOption(option);
		  
		var option:Option = new Option('Space Location: ',
			"Choose the Space Control Location",
			'hitboxLocation',
			'string',
			['Bottom', 'Middle', 'Top']);
		addOption(option);

		var option:Option = new Option('Hitbox hint',
			"If unchecked, disables the hitbox hint",
			'hitboxHints',
			'bool');
		addOption(option);

		var option:Option = new Option('Dynamic Controls Color',
			'If checked, the mobile controls color will be set to the notes color in your settings.\n(have effect during gameplay only)', 'dynamicColor',
			'bool');
		addOption(option);
		  
		var option:Option = new Option('Hitbox Alpha: ', //mariomaster was here again
			'Changes the Hitbox Alpha',
			'hitboxAlpha',
			'float');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('Virtual Pad Alpha: ', //mariomaster was here again
			'Changes the Virtual Pad Alpha',
			'virtualPadAlpha',
			'float');
		option.scrollSpeed = 1.6;
		option.minValue = 0.1;
		option.maxValue = 1;
		option.changeValue = 0.01;
		option.decimals = 2;
		addOption(option);
        option.onChange = () ->
		{
			#if android
			MusicBeatState.virtualPad.alpha = curOption.getValue();
			#end
		};

		#if android
		var option:Option = new Option('Allow Phone Screensaver', 'If checked, the phone will sleep after going inactive for few seconds.', 'screenSaver',
			'bool');
		option.onChange = () ->
		{
			System.allowScreenTimeout = curOption.getValue();
		};
		addOption(option);
		#end

		super();
	}
}