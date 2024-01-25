package backend;

import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.mappings.FlxGamepadMapping;
import flixel.input.keyboard.FlxKey;

#if android
//import flixel.input.actions.FlxActionInput;
import android.AndroidControls.AndroidControls;
//import android.FlxVirtualPad;

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
	
	/*
	android control make by NF|beihu ,logic is very shit but its easy to understand
    */
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
	public var SPACE_P(get, never):Bool;
	public var FULL_SCREEN_P(get, never):Bool;
	private function get_UI_UP_P() return justPressed('ui_up');
	private function get_UI_DOWN_P() return justPressed('ui_down');
	private function get_UI_LEFT_P() return justPressed('ui_left');
	private function get_UI_RIGHT_P() return justPressed('ui_right');
	private function get_NOTE_UP_P() return justPressed('note_up');
	private function get_NOTE_DOWN_P() return justPressed('note_down');
	private function get_NOTE_LEFT_P() return justPressed('note_left');
	private function get_NOTE_RIGHT_P() return justPressed('note_right');
    private function get_SPACE_P() return justPressed('space');
	private function get_FULL_SCREEN_P() return justPressed('full_screen');
    
	// Held buttons (directions)
	public var UI_UP(get, never):Bool;
	public var UI_DOWN(get, never):Bool;
	public var UI_LEFT(get, never):Bool;
	public var UI_RIGHT(get, never):Bool;
	public var NOTE_UP(get, never):Bool;
	public var NOTE_DOWN(get, never):Bool;
	public var NOTE_LEFT(get, never):Bool;
	public var NOTE_RIGHT(get, never):Bool;
	public var SPACE(get, never):Bool;
	public var FULL_SCREEN(get, never):Bool;
	private function get_UI_UP() return pressed('ui_up');
	private function get_UI_DOWN() return pressed('ui_down');
	private function get_UI_LEFT() return pressed('ui_left');
	private function get_UI_RIGHT() return pressed('ui_right');
	private function get_NOTE_UP() return pressed('note_up');
	private function get_NOTE_DOWN() return pressed('note_down');
	private function get_NOTE_LEFT() return pressed('note_left');
	private function get_NOTE_RIGHT() return pressed('note_right');
    private function get_SPACE() return pressed('space');
	private function get_FULL_SCREEN() return pressed('full_screen');
    
	// Released buttons (directions)
	public var UI_UP_R(get, never):Bool;
	public var UI_DOWN_R(get, never):Bool;
	public var UI_LEFT_R(get, never):Bool;
	public var UI_RIGHT_R(get, never):Bool;
	public var NOTE_UP_R(get, never):Bool;
	public var NOTE_DOWN_R(get, never):Bool;
	public var NOTE_LEFT_R(get, never):Bool;
	public var NOTE_RIGHT_R(get, never):Bool;
	public var SPACE_R(get, never):Bool;
	public var FULL_SCREEN_R(get, never):Bool;
	private function get_UI_UP_R() return justReleased('ui_up');
	private function get_UI_DOWN_R() return justReleased('ui_down');
	private function get_UI_LEFT_R() return justReleased('ui_left');
	private function get_UI_RIGHT_R() return justReleased('ui_right');
	private function get_NOTE_UP_R() return justReleased('note_up');
	private function get_NOTE_DOWN_R() return justReleased('note_down');
	private function get_NOTE_LEFT_R() return justReleased('note_left');
	private function get_NOTE_RIGHT_R() return justReleased('note_right');
	private function get_SPACE_R() return justReleased('space');
	private function get_FULL_SCREEN_R() return justReleased('full_screen');

	// Pressed buttons (others)
	public var ACCEPT(get, never):Bool;
	public var BACK(get, never):Bool;
	public var PAUSE(get, never):Bool;
	public var RESET(get, never):Bool;
	private function get_ACCEPT() return justPressed('accept');
	private function get_BACK() return justPressed('back');
	private function get_PAUSE() return justPressed('pause');
	private function get_RESET() return justPressed('reset');
	
	public static var checkTheState:Bool = true;
	public static var checkThePressedControl:Bool = true;
    public static var checkTheControls:Bool = true;
    public static var checkTheKeyboard:Bool = false;
	//Gamepad & Keyboard stuff
	public var keyboardBinds:Map<String, Array<FlxKey>>;
	public var gamepadBinds:Map<String, Array<FlxGamepadInputID>>;
	public function justPressed(key:String)
	{
		
		var result:Bool = false;		
		
		if (FlxG.keys.anyJustPressed(keyboardBinds[key])){
		result = true;
		controllerMode = false;
		}				

		return result || _myGamepadJustPressed(gamepadBinds[key]) == true #if android || checkAndroidControl_justPressed(key) == true #end;
	}

	public function pressed(key:String)
	{		
		
		var result:Bool = false;
		
		
		
		if (FlxG.keys.anyPressed(keyboardBinds[key])){
		result = true;
		controllerMode = false;
		}

		return result || _myGamepadPressed(gamepadBinds[key]) == true #if android || checkAndroidControl_pressed(key) == true #end;
	}

	public function justReleased(key:String)
	{
		
		var result:Bool = false;
		
		
		
		if (FlxG.keys.anyJustReleased(keyboardBinds[key])){
		result = true;
		controllerMode = false;
		}

		return result || _myGamepadJustReleased(gamepadBinds[key]) == true #if android || checkAndroidControl_justReleased(key) == true #end;
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
	
	#if android
	private function checkAndroidControl_justPressed(key:String):Bool
	{
	    var result:Bool = false;
	    if (checkThePressedControl){
		    if (checkTheState) {
    		    if (key == 'accept'){
    		    	result = (MusicBeatState.virtualPad.buttonA.justPressed == true);
    		    	if(result) {
						controllerMode = true; return true;
					}
    		    }
    		    if (key == 'back'){
    		    	result = (MusicBeatState.virtualPad.buttonB.justPressed == true);
        			if(result) {
						controllerMode = true; return true;
					}
        		}
        		if (key == 'ui_up') {
        			result = (MusicBeatState.virtualPad.buttonUp.justPressed == true);
        			if(result) {
						controllerMode = true; return true;
					}
        		}
        		if (key == 'ui_down') {
        			result = (MusicBeatState.virtualPad.buttonDown.justPressed == true);
           			if(result) {
						controllerMode = true; return true;
					}
        		}
        		if (key == 'ui_left') {
        			result = (MusicBeatState.virtualPad.buttonLeft.justPressed == true);
        			if(result) {
						controllerMode = true; return true;
					}
        		}
        		if (key == 'ui_right') {
        			result = (MusicBeatState.virtualPad.buttonRight.justPressed == true);
    		    	if(result) {
						controllerMode = true; return true;
					}
    		    }
		    } else {
    		    if (key == 'accept'){
    		    	result = (MusicBeatSubstate.virtualPad.buttonA.justPressed == true);
    		    	if(result) {
						controllerMode = true; return true;
					}
    		    }
    		    if (key == 'back') {
    		    	result = (MusicBeatSubstate.virtualPad.buttonB.justPressed == true);
    		    	if(result) {
						controllerMode = true; return true;
					}
    		    }
    		    if (key == 'ui_up') {
    		    	result = (MusicBeatSubstate.virtualPad.buttonUp.justPressed == true);
    		    	if(result) {controllerMode = true; return true;
					}
    		    }
    		    if (key == 'ui_down') {
    		    	result = (MusicBeatSubstate.virtualPad.buttonDown.justPressed == true);
    		   		if(result) {controllerMode = true; return true;
					}
    		    }
    		    if (key == 'ui_left') {
    		    	result = (MusicBeatSubstate.virtualPad.buttonLeft.justPressed == true);
    		    	if(result) {controllerMode = true; return true;
					}
    		    }
    		    if (key == 'ui_right') {
    		    	result = (MusicBeatSubstate.virtualPad.buttonRight.justPressed == true);
    		    	if(result) {
						controllerMode = true; return true;
					}
    		    }						
		    }
		}

		if (!checkTheKeyboard) {
		if (checkTheControls) {
    		if (MusicBeatState.checkHitbox) {
    		    if (key == 'note_up') {
        			result = (MusicBeatState.androidControls.newHitbox.buttonUp.justPressed == true);
        			if(result) {
						controllerMode = true; return true;
					}
        		}
        		if (key == 'note_down') {
        			result = (MusicBeatState.androidControls.newHitbox.buttonDown.justPressed == true);
        			if(result) {
						controllerMode = true; return true;
					}
        		}
        		if (key == 'note_left') {
        			result = (MusicBeatState.androidControls.newHitbox.buttonLeft.justPressed == true);
        			if(result) {
						controllerMode = true; return true;
					}
        		}
        		if (key == 'note_right') {
        			result = (MusicBeatState.androidControls.newHitbox.buttonRight.justPressed == true);
        			if(result) {
						controllerMode = true; return true;
					}
    		    }
    		    if (key == 'space' && ClientPrefs.data.hitboxExtend) {
    		    	result = (MusicBeatState.androidControls.newHitbox.buttonSpace.justPressed == true);
        			if(result) {
						controllerMode = true; return true;
					}
    		    }
    		} else{
    		    if (MusicBeatState.checkDUO) {
        		    if (key == 'note_up') {
            		result = ((MusicBeatState.androidControls.virtualPad.buttonUp.justPressed || MusicBeatState.androidControls.virtualPad.buttonUp2.justPressed) == true);
            			if(result) {
							controllerMode = true; return true;
						}
            		}
            		if (key == 'note_down') {
            			result = ((MusicBeatState.androidControls.virtualPad.buttonDown.justPressed || MusicBeatState.androidControls.virtualPad.buttonDown2.justPressed) == true);
            		if(result) {
						controllerMode = true; return true;
						}
            		}
            		if (key == 'note_left') {
            		result = ((MusicBeatState.androidControls.virtualPad.buttonLeft.justPressed || MusicBeatState.androidControls.virtualPad.buttonLeft2.justPressed) == true);
            		if(result) {
						controllerMode = true; return true;
						}
            		}
            		if (key == 'note_right') {
            		result = ((MusicBeatState.androidControls.virtualPad.buttonRight.justPressed || MusicBeatState.androidControls.virtualPad.buttonRight2.justPressed) == true);
            		if(result) {
						controllerMode = true; return true;
						}
            		}		    
        		} else {
            		if (key == 'note_up') {
            			result = (MusicBeatState.androidControls.virtualPad.buttonUp.justPressed == true);
            		if(result) {
						controllerMode = true; return true;
						}
            		}
            		if (key == 'note_down') {
            		result = (MusicBeatState.androidControls.virtualPad.buttonDown.justPressed == true);
            		if (result) {
						controllerMode = true; return true;
						}
            		}
            		if (key == 'note_left')	{
            			result = (MusicBeatState.androidControls.virtualPad.buttonLeft.justPressed == true);
            		if(result) {
						controllerMode = true; return true;
						}
            		}
            		if (key == 'note_right') {
            			result = (MusicBeatState.androidControls.virtualPad.buttonRight.justPressed == true);
            		if(result) {
						controllerMode = true; return true;
						}
        		    }
    		    }
    	    }
	    } else {
	    if (MusicBeatSubstate.checkHitbox) {
    		    if (key == 'note_up') {
        			result = (MusicBeatState.androidControls.newHitbox.buttonUp.justPressed == true);
        		if(result) {
					controllerMode = true; return true;
					}
        		}
        		if (key == 'note_down') {
        			result = (MusicBeatState.androidControls.newHitbox.buttonDown.justPressed == true);
        		if (result) {
					controllerMode = true; return true;
					}
        		}
        		if (key == 'note_left') {
        			result = (MusicBeatState.androidControls.newHitbox.buttonLeft.justPressed == true);
        		if(result) {
					controllerMode = true; return true;
					}
        		}
        		if (key == 'note_right') {
        			result = (MusicBeatState.androidControls.newHitbox.buttonRight.justPressed == true);
        		if(result) {
					controllerMode = true; return true;
					}
    		    }
    		    if (key == 'space' && ClientPrefs.data.hitboxExtend) {
    		    	result = (MusicBeatState.androidControls.newHitbox.buttonSpace.justPressed == true);
        		if(result) {
					controllerMode = true; return true;
					}
    		    }
    		} else {
    		    if (MusicBeatSubstate.checkDUO) {
        		    if (key == 'note_up') {
            			result = ((MusicBeatState.androidControls.virtualPad.buttonUp.justPressed || MusicBeatState.androidControls.virtualPad.buttonUp2.justPressed) == true);
            		if(result) {
						controllerMode = true; return true;
						}
            		}
            		if (key == 'note_down') {
            			result = ((MusicBeatState.androidControls.virtualPad.buttonDown.justPressed || MusicBeatState.androidControls.virtualPad.buttonDown2.justPressed) == true);
            		if(result) {
						controllerMode = true; return true;
						}
            		}
            		if (key == 'note_left') {
            			result = ((MusicBeatState.androidControls.virtualPad.buttonLeft.justPressed || MusicBeatState.androidControls.virtualPad.buttonLeft2.justPressed) == true);
            		if(result) {
						controllerMode = true; return true;
						}
            		}
            		if (key == 'note_right') {
            		result = ((MusicBeatState.androidControls.virtualPad.buttonRight.justPressed || MusicBeatState.androidControls.virtualPad.buttonRight2.justPressed) == true);
            		if(result) {controllerMode = true; return true;}
            		    }		    
        		    }
    		    else{
            		if (key == 'note_up'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonUp.justPressed == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_down'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonDown.justPressed == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_left'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonLeft.justPressed == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_right'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonRight.justPressed == true);
            		if(result) {controllerMode = true; return true;}
        		    }
    		    }
    	    }
	    }
	    }
	    return false;
    }
    
    
    
    private function checkAndroidControl_pressed(key:String):Bool
    {
    
    var result:Bool = false;
    
        //------------------ui
	    if (checkThePressedControl){
		    if (checkTheState){
    		    if (key == 'accept'){
    		    result = (MusicBeatState.virtualPad.buttonA.pressed == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'back'){
    		    result = (MusicBeatState.virtualPad.buttonB.pressed == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'ui_up'){
        		result = (MusicBeatState.virtualPad.buttonUp.pressed == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'ui_down'){
        		result = (MusicBeatState.virtualPad.buttonDown.pressed == true);
           		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'ui_left'){
        		result = (MusicBeatState.virtualPad.buttonLeft.pressed == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'ui_right'){
        		result = (MusicBeatState.virtualPad.buttonRight.pressed == true);
    		    if(result) {controllerMode = true; return true;}
    		        }
		        }//checkTheState
		    else{
    		    if (key == 'accept'){
    		    result = (MusicBeatSubstate.virtualPad.buttonA.pressed == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'back'){
    		    result = (MusicBeatSubstate.virtualPad.buttonB.pressed == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'ui_up'){
    		    result = (MusicBeatSubstate.virtualPad.buttonUp.pressed == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'ui_down'){
    		    result = (MusicBeatSubstate.virtualPad.buttonDown.pressed == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'ui_left'){
    		    result = (MusicBeatSubstate.virtualPad.buttonLeft.pressed == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'ui_right'){
    		    result = (MusicBeatSubstate.virtualPad.buttonRight.pressed == true);
    		    if(result) {controllerMode = true; return true;}
    		    }						
		    }
		}

		if(!checkTheKeyboard){
		if (checkTheControls){
    		if (MusicBeatState.checkHitbox){
    		    if (key == 'note_up'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonUp.pressed == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_down'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonDown.pressed == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_left'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonLeft.pressed == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_right'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonRight.pressed == true);
        		if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'space' && ClientPrefs.data.hitboxExtend){
    		    result = (MusicBeatState.androidControls.newHitbox.buttonSpace.pressed == true);
        		if(result) {controllerMode = true; return true;}
    		    }
    		}//MusicBeatState.checkHitbox
    		else{
    		    if (MusicBeatState.checkDUO){
        		    if (key == 'note_up'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonUp.pressed || MusicBeatState.androidControls.virtualPad.buttonUp2.pressed) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_down'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonDown.pressed || MusicBeatState.androidControls.virtualPad.buttonDown2.pressed) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_left'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonLeft.pressed || MusicBeatState.androidControls.virtualPad.buttonLeft2.pressed) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_right'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonRight.pressed || MusicBeatState.androidControls.virtualPad.buttonRight2.pressed) == true);
            		if(result) {controllerMode = true; return true;}
            		    }		    
        		    }//MusicBeatState.checkDUO
    		    else{
            		if (key == 'note_up'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonUp.pressed == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_down'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonDown.pressed == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_left'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonLeft.pressed == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_right'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonRight.pressed == true);
            		if(result) {controllerMode = true; return true;}
        		    }
    		    }//!MusicBeatState.checkDUO
    	    }//!MusicBeatState.checkHitbox
	    }//checkTheControls
	    else{
	    if (MusicBeatSubstate.checkHitbox){
    		    if (key == 'note_up'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonUp.pressed == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_down'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonDown.pressed == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_left'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonLeft.pressed == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_right'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonRight.pressed == true);
        		if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'space' && ClientPrefs.data.hitboxExtend){
    		    result = (MusicBeatState.androidControls.newHitbox.buttonSpace.pressed == true);
        		if(result) {controllerMode = true; return true;}
    		    }
    		}//MusicBeatSubstate.checkHitbox
    		else{
    		    if (MusicBeatSubstate.checkDUO){
        		    if (key == 'note_up'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonUp.pressed || MusicBeatState.androidControls.virtualPad.buttonUp2.pressed) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_down'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonDown.pressed || MusicBeatState.androidControls.virtualPad.buttonDown2.pressed) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_left'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonLeft.pressed || MusicBeatState.androidControls.virtualPad.buttonLeft2.pressed) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_right'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonRight.pressed || MusicBeatState.androidControls.virtualPad.buttonRight2.pressed) == true);
            		if(result) {controllerMode = true; return true;}
            		    }		    
        		    }//MusicBeatSubstate.checkDUO
    		    else{
            		if (key == 'note_up'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonUp.pressed == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_down'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonDown.pressed == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_left'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonLeft.pressed == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_right'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonRight.pressed == true);
            		if(result) {controllerMode = true; return true;}
        		    }
    		    }//!MusicBeatSubstate.checkDUO
    	    }//!MusicBeatSubstate.checkHitbox
	    }//!checkTheControls
	    }//!checkTheKeyboard
        return false;
	   // if (result) return true;
    
    }
    
    private function checkAndroidControl_justReleased(key:String):Bool
    {
    
    var result:Bool = false;
    
        //------------------ui
	    if (checkThePressedControl){
		    if (checkTheState){
    		    if (key == 'accept'){
    		    result = (MusicBeatState.virtualPad.buttonA.justReleased == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'back'){
    		    result = (MusicBeatState.virtualPad.buttonB.justReleased == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'ui_up'){
        		result = (MusicBeatState.virtualPad.buttonUp.justReleased == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'ui_down'){
        		result = (MusicBeatState.virtualPad.buttonDown.justReleased == true);
           		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'ui_left'){
        		result = (MusicBeatState.virtualPad.buttonLeft.justReleased == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'ui_right'){
        		result = (MusicBeatState.virtualPad.buttonRight.justReleased == true);
    		    if(result) {controllerMode = true; return true;}
    		        }
		        }//checkTheState
		    else{
    		    if (key == 'accept'){
    		    result = (MusicBeatSubstate.virtualPad.buttonA.justReleased == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'back'){
    		    result = (MusicBeatSubstate.virtualPad.buttonB.justReleased == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'ui_up'){
    		    result = (MusicBeatSubstate.virtualPad.buttonUp.justReleased == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'ui_down'){
    		    result = (MusicBeatSubstate.virtualPad.buttonDown.justReleased == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'ui_left'){
    		    result = (MusicBeatSubstate.virtualPad.buttonLeft.justReleased == true);
    		    if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'ui_right'){
    		    result = (MusicBeatSubstate.virtualPad.buttonRight.justReleased == true);
    		    if(result) {controllerMode = true; return true;}
    		    }						
		    }//!checkTheState
		}//checkThePressedControl
		
		//------------------note
		if (!checkTheKeyboard){
		if (checkTheControls){
    		if (MusicBeatState.checkHitbox){
    		    if (key == 'note_up'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonUp.justReleased == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_down'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonDown.justReleased == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_left'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonLeft.justReleased == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_right'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonRight.justReleased == true);
        		if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'space' && ClientPrefs.data.hitboxExtend){
    		    result = (MusicBeatState.androidControls.newHitbox.buttonSpace.justReleased == true);
        		if(result) {controllerMode = true; return true;}
    		    }
    		}//MusicBeatState.checkHitbox
    		else{
    		    if (MusicBeatState.checkDUO){
        		    if (key == 'note_up'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonUp.justReleased || MusicBeatState.androidControls.virtualPad.buttonUp2.justReleased) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_down'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonDown.justReleased || MusicBeatState.androidControls.virtualPad.buttonDown2.justReleased) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_left'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonLeft.justReleased || MusicBeatState.androidControls.virtualPad.buttonLeft2.justReleased) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_right'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonRight.justReleased || MusicBeatState.androidControls.virtualPad.buttonRight2.justReleased) == true);
            		if(result) {controllerMode = true; return true;}
            		    }		    
        		    }//MusicBeatState.checkDUO
    		    else{
            		if (key == 'note_up'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonUp.justReleased == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_down'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonDown.justReleased == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_left'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonLeft.justReleased == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_right'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonRight.justReleased == true);
            		if(result) {controllerMode = true; return true;}
        		    }
    		    }//!MusicBeatState.checkDUO
    	    }//!MusicBeatState.checkHitbox
	    }//checkTheControls
	    else{
	    if (MusicBeatSubstate.checkHitbox){
    		    if (key == 'note_up'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonUp.justReleased == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_down'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonDown.justReleased == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_left'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonLeft.justReleased == true);
        		if(result) {controllerMode = true; return true;}
        		}
        		if (key == 'note_right'){
        		result = (MusicBeatState.androidControls.newHitbox.buttonRight.justReleased == true);
        		if(result) {controllerMode = true; return true;}
    		    }
    		    if (key == 'space' && ClientPrefs.data.hitboxExtend){
    		    result = (MusicBeatState.androidControls.newHitbox.buttonSpace.justReleased == true);
        		if(result) {controllerMode = true; return true;}
    		    }
    		}//MusicBeatSubstate.checkHitbox
    		else{
    		    if (MusicBeatSubstate.checkDUO){
        		    if (key == 'note_up'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonUp.justReleased || MusicBeatState.androidControls.virtualPad.buttonUp2.justReleased) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_down'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonDown.justReleased || MusicBeatState.androidControls.virtualPad.buttonDown2.justReleased) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_left'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonLeft.justReleased || MusicBeatState.androidControls.virtualPad.buttonLeft2.justReleased) == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_right'){
            		result = ((MusicBeatState.androidControls.virtualPad.buttonRight.justReleased || MusicBeatState.androidControls.virtualPad.buttonRight2.justReleased) == true);
            		if(result) {controllerMode = true; return true;}
            		    }		    
        		    }//MusicBeatSubstate.checkDUO
    		    else{
            		if (key == 'note_up'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonUp.justReleased == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_down'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonDown.justReleased == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_left'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonLeft.justReleased == true);
            		if(result) {controllerMode = true; return true;}
            		}
            		if (key == 'note_right'){
            		result = (MusicBeatState.androidControls.virtualPad.buttonRight.justReleased == true);
            		if(result) {controllerMode = true; return true;}
        		    }
    		    }
    	    }
	    }
	    }
	    return false;
    }
    
    #end
    
	// IGNORE THESE
	public static var instance:Controls;
	public function new()
	{
		keyboardBinds = ClientPrefs.keyBinds;
		gamepadBinds = ClientPrefs.gamepadBinds;
	}
}