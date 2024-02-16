package options.android;

class AndroidOptionsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Hitbox Settings';

		var option:Option = new Option('Space Extend',
			"Allow Extend Space Control --Made by NF|Beihu",
			'hitboxExtend',
			'bool');
		  addOption(option);
		  
		var option:Option = new Option('Space Location:',
			"Choose Space Control Location",
			'hitboxLocation',
			'string',
			['Bottom', 'Middle', 'Top']);
		  addOption(option);  
		  
		var option:Option = new Option('Hitbox Alpha:', //mariomaster was here again
			'Changes Hitbox Alpha',
			'hitboxalpha',
			'float');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('VirtualPad Alpha:', //mariomaster was here again
			'Changes VirtualPad Alpha',
			'VirtualPadAlpha',
			'float');
		option.scrollSpeed = 1.6;
		option.minValue = 0.1;
		option.maxValue = 1;
		option.changeValue = 0.01;
		option.decimals = 2;
		addOption(option);
        option.onChange = onChangePadAlpha;
		super();
	}
	
	var OGpadAlpha:Float = ClientPrefs.data.VirtualPadAlpha;
	function onChangePadAlpha()
	{
		ClientPrefs.saveSettings();
		#if android
		MusicBeatState.virtualPad.alpha = ClientPrefs.data.VirtualPadAlpha / OGpadAlpha;
		#end
	}
}