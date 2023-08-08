package backend;

import flixel.FlxSubState;


#if android
//import flixel.input.actions.FlxActionInput;
import android.AndroidControls.AndroidControls;
import android.FlxVirtualPad;

import flixel.group.FlxGroup;
import android.FlxHitbox;
import android.FlxNewHitbox;
import android.FlxVirtualPad;
import flixel.ui.FlxButton;
import android.flixel.FlxButton as FlxNewButton;
#end

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;
	
	public static var checkHitbox:Bool = false;
	public static var checkDUO:Bool = false;
	

	inline function get_controls():Controls
		return Controls.instance;
		
    	#if android
	public static var _virtualpad:FlxVirtualPad;
	public static var androidc:AndroidControls;
	//var trackedinputsUI:Array<FlxActionInput> = [];
	//var trackedinputsNOTES:Array<FlxActionInput> = [];
	#end
	
	#if android
	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode) {
		_virtualpad = new FlxVirtualPad(DPad, Action, 0.75, ClientPrefs.data.antialiasing);
		add(_virtualpad);
		Controls.checkState = false;
		Controls.CheckPress = true;
		//controls.setVirtualPadUI(_virtualpad, DPad, Action);
		//trackedinputsUI = controls.trackedinputsUI;
		//controls.trackedinputsUI = [];
	}
	#end
	


	#if android
	public function removeVirtualPad() {
		//controls.removeFlxInput(trackedinputsUI);
		remove(_virtualpad);
	}
	#end
	
	#if android
	public function noCheckPress() {
		Controls.CheckPress = false;
	}
	#end
	
	#if android
	public function addAndroidControls() {
		androidc = new AndroidControls();
		
        Controls.CheckPress = true;
        
		switch (androidc.mode)
		{
			case VIRTUALPAD_RIGHT | VIRTUALPAD_LEFT | VIRTUALPAD_CUSTOM:
				//controls.setVirtualPadNOTES(androidc.vpad, FULL, NONE);
				checkHitbox = false;
				checkDUO = false;
				Controls.CheckKeyboard = false;
			case DUO:
				//controls.setVirtualPadNOTES(androidc.vpad, DUO, NONE);
				checkHitbox = false;
				checkDUO = true;
				Controls.CheckKeyboard = false;
			case HITBOX:
				//controls.setNewHitBox(androidc.newhbox);
				checkHitbox = true;
				checkDUO = false;
				Controls.CheckKeyboard = false;
			//case KEYBOARD:				    
			default:
			    checkHitbox = false;
			    checkDUO = false;
			    Controls.CheckKeyboard = true;
		}

		var camcontrol = new flixel.FlxCamera();
		FlxG.cameras.add(camcontrol, false);
		camcontrol.bgColor.alpha = 0;
		androidc.cameras = [camcontrol];

		androidc.visible = false;
		

		add(androidc);
		Controls.CheckControl = false;
	}
	#end

	#if android
    public function addPadCamera() {
		var camcontrol = new flixel.FlxCamera();
		camcontrol.bgColor.alpha = 0;
		FlxG.cameras.add(camcontrol, false);
		_virtualpad.cameras = [camcontrol];
	}
	#end
	
	override function update(elapsed:Float)
	{
		//everyStep();
		if(!persistentUpdate) MusicBeatState.timePassedOnState += elapsed;
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		super.update(elapsed);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.data.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
	
	public function sectionHit():Void
	{
		//yep, you guessed it, nothing again, dumbass
	}
	
	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
