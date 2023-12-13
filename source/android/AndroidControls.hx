package android;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSave;
import flixel.math.FlxPoint;

import android.FlxVirtualPad;
import android.FlxHitbox;

class Config {
	var save:FlxSave;

	public function new() {
		save = new FlxSave();
		save.bind("saved-controls");
	}

	public function getcontrolmode():Int {
		if (save.data.buttonsmode != null) 
			return save.data.buttonsmode[0];
		return 0;
	}

	public function setcontrolmode(mode:Int = 0):Int {
		if (save.data.buttonsmode == null) save.data.buttonsmode = new Array();
		save.data.buttonsmode[0] = mode;
		save.flush();
		return save.data.buttonsmode[0];
	}

	public function savecustom(_pad:FlxVirtualPad) {
		if (save.data.buttons == null)
		{
			save.data.buttons = new Array();
			for (buttons in _pad){
				save.data.buttons.push(FlxPoint.get(buttons.x, buttons.y));
			}
		}else{
			var tempCount:Int = 0;
			for (buttons in _pad){
				save.data.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				tempCount++;
			}
		}
		save.flush();
	}

	public function loadcustom(_pad:FlxVirtualPad):FlxVirtualPad {
		if (save.data.buttons == null) 
			return _pad;
		var tempCount:Int = 0;
		for(buttons in _pad){
			buttons.x = save.data.buttons[tempCount].x;
			buttons.y = save.data.buttons[tempCount].y;
			tempCount++;
		}	
		return _pad;
	}
}

class AndroidControls extends FlxSpriteGroup {
	public var mode:ControlsGroup = HITBOX;

	public var hbox:FlxHitbox;
	public var newhbox:FlxNewHitbox;
	public var virtualPads:FlxVirtualPad;

	var config:Config;

	public function new() {
		super();

		config = new Config();

		mode = getModeFromNumber(config.getcontrolmode());

		switch (mode){
			case VIRTUALPAD_RIGHT:
				initControler(0);
			case VIRTUALPAD_LEFT:
				initControler(1);
			case VIRTUALPAD_CUSTOM:
				initControler(2);
			case DUO:
				initControler(3);
			case HITBOX:
		    if(ClientPrefs.data.hitboxmode != 'New'){
				initControler(4);
		    }else{
		    initControler(5);
		    }
			case KEYBOARD:// nothing
		}
	}

	function initControler(virtualPadsMode:Int) {
		switch (virtualPadsMode){
			case 0:
				virtualPads = new FlxVirtualPad(RIGHT_FULL, NONE, 0.75, ClientPrefs.data.antialiasing);	
				add(virtualPads);						
			case 1:
				virtualPads = new FlxVirtualPad(FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
				add(virtualPads);			
			case 2:
				virtualPads = new FlxVirtualPad(FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
				virtualPads = config.loadcustom(virtualPads);
				add(virtualPads);	
			case 3:
				virtualPads = new FlxVirtualPad(DUO, NONE, 0.75, ClientPrefs.data.antialiasing);
				add(virtualPads);		
			case 4:
				hbox = new FlxHitbox(0.75, ClientPrefs.data.antialiasing);
				add(hbox);
			case 5:
			  newhbox = new FlxNewHitbox();
			  add(newhbox);
			default:
				virtualPads = new FlxVirtualPad(RIGHT_FULL, NONE, 0.75, ClientPrefs.data.antialiasing);	
				add(virtualPads);					
		}
	}

	public static function getModeFromNumber(modeNum:Int):ControlsGroup {
		return switch (modeNum){
			case 0: 
				VIRTUALPAD_RIGHT;
			case 1: 
				VIRTUALPAD_LEFT;
			case 2: 
				VIRTUALPAD_CUSTOM;
			case 3: 
				DUO;
			case 4:	
				HITBOX;
			case 5: 
				KEYBOARD;
			default: 
				VIRTUALPAD_RIGHT;
		}
	}
}

enum ControlsGroup {
	VIRTUALPAD_RIGHT;
	VIRTUALPAD_LEFT;
	VIRTUALPAD_CUSTOM;
	DUO;
	HITBOX;
	KEYBOARD;
}
