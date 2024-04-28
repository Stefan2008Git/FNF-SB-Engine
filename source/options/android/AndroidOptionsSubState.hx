package options.android;

import lime.system.System;
#if android
import android.Hardware;
import android.backend.AndroidDialogsExtend;
#end

class AndroidOptionsSubState extends BaseOptionsMenu
{
	private static var vibrationInt:Int = 500;
	public function new()
	{
		title = 'Android Customization';

		#if android
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
			"If unchecked, disables the hitbox hint", // Credits for mcgabe19's and KarimAkra's FNF Psych Engine 0.7+ Android and iOS port!
			'hitboxHints',
			'bool');
		addOption(option);

		var option:Option = new Option('Dynamic Controls Color',
			'If checked, the mobile controls color will be set to the notes color in your settings.\n(have effect during gameplay only)', 'dynamicColor', // Credits for mcgabe19's and KarimAkra's FNF Psych Engine 0.7+ Android and iOS port!
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
			MusicBeatState.virtualPad.alpha = curOption.getValue();
		};

		var option:Option = new Option('Allow Phone Screensaver', 'If checked, the phone will sleep after going inactive from sleep system settings.', 'screenSaver', // Credits for mcgabe19's and KarimAkra's FNF Psych Engine 0.7+ Android and iOS port!
			'bool');
		option.onChange = () ->
		{
			System.allowScreenTimeout = curOption.getValue();
		};
		addOption(option);

		var option:Option = new Option('Toast Message box', 'If checked, the phone will show the toast core box.', 'toastText', // Credits for mcgabe19's and KarimAkra's FNF Psych Engine 0.7+ Android and iOS port!
			'bool');
		option.onChange = () ->
		{
			if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Enabled.", 1);
			else AndroidDialogsExtend.openToastBox("Disabled", 1);
		};
		addOption(option);

		var option:Option = new Option('Vibration', 'If unchecked, the phone will stop the vibration', 'vibration',
			'bool');
		option.onChange = onChangeVibration;
		addOption(option);
		#end

		super();
	}

	#if android
	function onChangeVibration()
	{
		if (ClientPrefs.data.vibration) Hardware.vibrate(vibrationInt);
	}
	#end
}