package backend;

import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.mappings.FlxGamepadMapping;
import flixel.input.keyboard.FlxKey;

#if android
import android.AndroidControls.AndroidControls;
import flixel.group.FlxGroup;
import android.FlxHitbox;
import android.FlxNewHitbox;
import android.FlxVirtualPad;
import flixel.ui.FlxButton;
import android.flixel.FlxButton as FlxNewButton;
#end

class Controls
{
	//Keeping same use cases on stuff for it to be easier to understand/use
	//I'd have removed it but this makes it a lot less annoying to use in my opinion

	//You do NOT have to create these variables/getters for adding new keys,
	//but you will instead have to use:
	//   controls.justPressed("ui_up")   instead of   controls.UI_UP

	//Dumb but easily usable code, or Smart but complicated? Your choice.
	//Also idk how to use macros they're weird as fuck lol

	// Pressed buttons (directions)
	public var UI_UP_P(get, never):Bool;
	public var UI_DOWN_P(get, never):Bool;
	public var UI_LEFT_P(get, never):Bool;
	public var UI_RIGHT_P(get, never):Bool;
	public var NOTE_UP_P(get, never):Bool;
	public var NOTE_DOWN_P(get, never):Bool;
	public var NOTE_LEFT_P(get, never):Bool;
	public var NOTE_RIGHT_P(get, never):Bool;
	private function get_UI_UP_P() return justPressed('ui_up');
	private function get_UI_DOWN_P() return justPressed('ui_down');
	private function get_UI_LEFT_P() return justPressed('ui_left');
	private function get_UI_RIGHT_P() return justPressed('ui_right');
	private function get_NOTE_UP_P() return justPressed('note_up');
	private function get_NOTE_DOWN_P() return justPressed('note_down');
	private function get_NOTE_LEFT_P() return justPressed('note_left');
	private function get_NOTE_RIGHT_P() return justPressed('note_right');

	// Held buttons (directions)
	public var UI_UP(get, never):Bool;
	public var UI_DOWN(get, never):Bool;
	public var UI_LEFT(get, never):Bool;
	public var UI_RIGHT(get, never):Bool;
	public var NOTE_UP(get, never):Bool;
	public var NOTE_DOWN(get, never):Bool;
	public var NOTE_LEFT(get, never):Bool;
	public var NOTE_RIGHT(get, never):Bool;
	private function get_UI_UP() return pressed('ui_up');
	private function get_UI_DOWN() return pressed('ui_down');
	private function get_UI_LEFT() return pressed('ui_left');
	private function get_UI_RIGHT() return pressed('ui_right');
	private function get_NOTE_UP() return pressed('note_up');
	private function get_NOTE_DOWN() return pressed('note_down');
	private function get_NOTE_LEFT() return pressed('note_left');
	private function get_NOTE_RIGHT() return pressed('note_right');

	// Released buttons (directions)
	public var UI_UP_R(get, never):Bool;
	public var UI_DOWN_R(get, never):Bool;
	public var UI_LEFT_R(get, never):Bool;
	public var UI_RIGHT_R(get, never):Bool;
	public var NOTE_UP_R(get, never):Bool;
	public var NOTE_DOWN_R(get, never):Bool;
	public var NOTE_LEFT_R(get, never):Bool;
	public var NOTE_RIGHT_R(get, never):Bool;
	private function get_UI_UP_R() return justReleased('ui_up');
	private function get_UI_DOWN_R() return justReleased('ui_down');
	private function get_UI_LEFT_R() return justReleased('ui_left');
	private function get_UI_RIGHT_R() return justReleased('ui_right');
	private function get_NOTE_UP_R() return justReleased('note_up');
	private function get_NOTE_DOWN_R() return justReleased('note_down');
	private function get_NOTE_LEFT_R() return justReleased('note_left');
	private function get_NOTE_RIGHT_R() return justReleased('note_right');


	// Pressed buttons (others)
	public var ACCEPT(get, never):Bool;
	public var BACK(get, never):Bool;
	public var PAUSE(get, never):Bool;
	public var RESET(get, never):Bool;
	private function get_ACCEPT() return justPressed('accept');
	private function get_BACK() return justPressed('back');
	private function get_PAUSE() return justPressed('pause');
	private function get_RESET() return justPressed('reset');

	public static var checkState:Bool = true;
	public static var CheckPress:Bool = true;

	//Gamepad & Keyboard stuff
	public var keyboardBinds:Map<String, Array<FlxKey>>;
	public var gamepadBinds:Map<String, Array<FlxGamepadInputID>>;
	public function justPressed(key:String)
	{
	 #if desktop
		var result:Bool = (FlxG.keys.anyJustPressed(keyboardBinds[key]) == true);
		if(result) controllerMode = false;
		#else
		var result:Bool = false;
		#end
		#if android
		if (CheckPress){
		    if (checkState){
    		    if (key == 'accept'){
    		    result = (MusicBeatState._virtualpad.buttonA.justPressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'back'){
    		    result= (MusicBeatState._virtualpad.buttonB.justPressed == true);
        		if(result) controllerMode = true;
        		}
		
        		if (key == 'ui_up'){
        		result = (MusicBeatState._virtualpad.buttonUp.justPressed == true);
        		if(result) controllerMode = true;
        		}
        		if (key == 'ui_down'){
        		result= (MusicBeatState._virtualpad.buttonDown.justPressed == true);
           		if(result) controllerMode = true;
        		}
        		if (key == 'ui_left'){
        		result = (MusicBeatState._virtualpad.buttonLeft.justPressed == true);
        		if(result) controllerMode = true;
        		}
        		if (key == 'ui_right'){
        		result= (MusicBeatState._virtualpad.buttonRight.justPressed == true);
    		    if(result) controllerMode = true;
    		        }
		        }		
		    else{
    		    if (key == 'accept'){
    		    result = (MusicBeatSubstate._virtualpad.buttonA.justPressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'back'){
    		    result= (MusicBeatSubstate._virtualpad.buttonB.justPressed == true);
    		    if(result) controllerMode = true;
    		    }
		
    		    if (key == 'ui_up'){
    		    result = (MusicBeatSubstate._virtualpad.buttonUp.justPressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'ui_down'){
    		    result= (MusicBeatSubstate._virtualpad.buttonDown.justPressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'ui_left'){
    		    result = (MusicBeatSubstate._virtualpad.buttonLeft.justPressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'ui_right'){
    		    result= (MusicBeatSubstate._virtualpad.buttonRight.justPressed == true);
    		    if(result) controllerMode = true;
    		    }						
		    }
		}
		if (MusicBeatState.checkHitbox){
		    if (key == 'note_up'){
    		result = (MusicBeatState.androidc.newhbox.buttonUp.justPressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_down'){
    		result= (MusicBeatState.androidc.newhbox.buttonDown.justPressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_left'){
    		result = (MusicBeatState.androidc.newhbox.buttonLeft.justPressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_right'){
    		result= (MusicBeatState.androidc.newhbox.buttonRight.justPressed == true);
    		if(result) controllerMode = true;
		    }
		    if (key == 'space' && ClientPrefs.data.hitboxExtend){
		    result= (MusicBeatState.androidc.newhbox.buttonSpace.justPressed == true);
    		if(result) controllerMode = true;
		    }
		}
		else{		
    		if (key == 'note_up'){
    		result = (MusicBeatState.androidc.vpad.buttonUp.justPressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_down'){
    		result= (MusicBeatState.androidc.vpad.buttonDown.justPressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_left'){
    		result = (MusicBeatState.androidc.vpad.buttonLeft.justPressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_right'){
    		result= (MusicBeatState.androidc.vpad.buttonRight.justPressed == true);
    		if(result) controllerMode = true;
		    }
		}
		#end

		if (FlxG.keys.anyJustPressed(keyboardBinds[key])){
		result = true;
		controllerMode = false;
		}

		return result || _myGamepadJustPressed(gamepadBinds[key]) == true;
	}

	public function pressed(key:String)
	{
	  #if desktop
		var result:Bool = (FlxG.keys.anyPressed(keyboardBinds[key]) == true);
		if(result) controllerMode = false;
		#else
		var result:Bool = false;
		#end

		#if android
		if (CheckPress){
		    if (checkState){
    		    if (key == 'accept'){
    		    result = (MusicBeatState._virtualpad.buttonA.pressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'back'){
    		    result= (MusicBeatState._virtualpad.buttonB.pressed == true);
        		if(result) controllerMode = true;
        		}
		
        		if (key == 'ui_up'){
        		result = (MusicBeatState._virtualpad.buttonUp.pressed == true);
        		if(result) controllerMode = true;
        		}
        		if (key == 'ui_down'){
        		result= (MusicBeatState._virtualpad.buttonDown.pressed == true);
           		if(result) controllerMode = true;
        		}
        		if (key == 'ui_left'){
        		result = (MusicBeatState._virtualpad.buttonLeft.pressed == true);
        		if(result) controllerMode = true;
        		}
        		if (key == 'ui_right'){
        		result= (MusicBeatState._virtualpad.buttonRight.pressed == true);
    		    if(result) controllerMode = true;
    		        }
		        }		
		    else{
    		    if (key == 'accept'){
    		    result = (MusicBeatSubstate._virtualpad.buttonA.pressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'back'){
    		    result= (MusicBeatSubstate._virtualpad.buttonB.pressed == true);
    		    if(result) controllerMode = true;
    		    }
		
    		    if (key == 'ui_up'){
    		    result = (MusicBeatSubstate._virtualpad.buttonUp.pressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'ui_down'){
    		    result= (MusicBeatSubstate._virtualpad.buttonDown.pressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'ui_left'){
    		    result = (MusicBeatSubstate._virtualpad.buttonLeft.pressed == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'ui_right'){
    		    result= (MusicBeatSubstate._virtualpad.buttonRight.pressed == true);
    		    if(result) controllerMode = true;
    		    }						
		    }
		}
		if (MusicBeatState.checkHitbox){
		    if (key == 'note_up'){
    		result = (MusicBeatState.androidc.newhbox.buttonUp.pressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_down'){
    		result= (MusicBeatState.androidc.newhbox.buttonDown.pressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_left'){
    		result = (MusicBeatState.androidc.newhbox.buttonLeft.pressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_right'){
    		result= (MusicBeatState.androidc.newhbox.buttonRight.pressed == true);
    		if(result) controllerMode = true;
		    }		    		    
		    if (key == 'space' && ClientPrefs.data.hitboxExtend){
		    result= (MusicBeatState.androidc.newhbox.buttonSpace.pressed == true);
    		if(result) controllerMode = true;
		    }
		}
		else{		
    		if (key == 'note_up'){
    		result = (MusicBeatState.androidc.vpad.buttonUp.pressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_down'){
    		result= (MusicBeatState.androidc.vpad.buttonDown.pressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_left'){
    		result = (MusicBeatState.androidc.vpad.buttonLeft.pressed == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_right'){
    		result= (MusicBeatState.androidc.vpad.buttonRight.pressed == true);
    		if(result) controllerMode = true;
		    }
		}
		#end

		if (FlxG.keys.anyPressed(keyboardBinds[key])){
		result = true;
		controllerMode = false;
		}

		return result || _myGamepadPressed(gamepadBinds[key]) == true;
	}

	public function justReleased(key:String)
	{
	  #if desktop
		var result:Bool = (FlxG.keys.anyJustReleased(keyboardBinds[key]) == true);
		if(result) controllerMode = false;
		#else
		var result:Bool = false;
		#end

		#if android
		if (CheckPress){
		    if (checkState){
    		    if (key == 'accept'){
    		    result = (MusicBeatState._virtualpad.buttonA.justReleased == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'back'){
    		    result= (MusicBeatState._virtualpad.buttonB.justReleased == true);
        		if(result) controllerMode = true;
        		}
		
        		if (key == 'ui_up'){
        		result = (MusicBeatState._virtualpad.buttonUp.justReleased == true);
        		if(result) controllerMode = true;
        		}
        		if (key == 'ui_down'){
        		result= (MusicBeatState._virtualpad.buttonDown.justReleased == true);
           		if(result) controllerMode = true;
        		}
        		if (key == 'ui_left'){
        		result = (MusicBeatState._virtualpad.buttonLeft.justReleased == true);
        		if(result) controllerMode = true;
        		}
        		if (key == 'ui_right'){
        		result= (MusicBeatState._virtualpad.buttonRight.justReleased == true);
    		    if(result) controllerMode = true;
    		        }
		        }		
		    else{
    		    if (key == 'accept'){
    		    result = (MusicBeatSubstate._virtualpad.buttonA.justReleased == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'back'){
    		    result= (MusicBeatSubstate._virtualpad.buttonB.justReleased == true);
    		    if(result) controllerMode = true;
    		    }
		
    		    if (key == 'ui_up'){
    		    result = (MusicBeatSubstate._virtualpad.buttonUp.justReleased == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'ui_down'){
    		    result= (MusicBeatSubstate._virtualpad.buttonDown.justReleased == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'ui_left'){
    		    result = (MusicBeatSubstate._virtualpad.buttonLeft.justReleased == true);
    		    if(result) controllerMode = true;
    		    }
    		    if (key == 'ui_right'){
    		    result= (MusicBeatSubstate._virtualpad.buttonRight.justReleased == true);
    		    if(result) controllerMode = true;
    		    }						
		    }
		}
		if (MusicBeatState.checkHitbox){
		    if (key == 'note_up'){
    		result = (MusicBeatState.androidc.newhbox.buttonUp.justReleased == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_down'){
    		result= (MusicBeatState.androidc.newhbox.buttonDown.justReleased == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_left'){
    		result = (MusicBeatState.androidc.newhbox.buttonLeft.justReleased == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_right'){
    		result= (MusicBeatState.androidc.newhbox.buttonRight.justReleased == true);
    		if(result) controllerMode = true;
		    }		    		    
		    if (key == 'space' && ClientPrefs.data.hitboxExtend){
		    result= (MusicBeatState.androidc.newhbox.buttonSpace.justReleased == true);
    		if(result) controllerMode = true;
		    }
		}
		else{		
    		if (key == 'note_up'){
    		result = (MusicBeatState.androidc.vpad.buttonUp.justReleased == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_down'){
    		result= (MusicBeatState.androidc.vpad.buttonDown.justReleased == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_left'){
    		result = (MusicBeatState.androidc.vpad.buttonLeft.justReleased == true);
    		if(result) controllerMode = true;
    		}
    		if (key == 'note_right'){
    		result= (MusicBeatState.androidc.vpad.buttonRight.justReleased == true);
    		if(result) controllerMode = true;
		    }
		}
		#end
		
		if (FlxG.keys.anyJustReleased(keyboardBinds[key])){
		result = true;
		controllerMode = false;
		}

		return result || _myGamepadJustReleased(gamepadBinds[key]) == true;
	}

	public var controllerMode:Bool = false;
	private function _myGamepadJustPressed(keys:Array<FlxGamepadInputID>):Bool
	{
		if(keys != null)
		{
			for (key in keys)
			{
				if (FlxG.gamepads.anyJustPressed(key) == true)
				{
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadPressed(keys:Array<FlxGamepadInputID>):Bool
	{
		if(keys != null)
		{
			for (key in keys)
			{
				if (FlxG.gamepads.anyPressed(key) == true)
				{
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadJustReleased(keys:Array<FlxGamepadInputID>):Bool
	{
		if(keys != null)
		{
			for (key in keys)
			{
				if (FlxG.gamepads.anyJustReleased(key) == true)
				{
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}

	// IGNORE THESE
	public static var instance:Controls;
	public function new()
	{
		keyboardBinds = ClientPrefs.keyBinds;
		gamepadBinds = ClientPrefs.gamepadBinds;
	}
}