package backend;

#if android
import android.AndroidControls.AndroidControls;
import android.flixel.FlxHitbox;
import android.flixel.FlxNewHitbox;
import android.flixel.FlxVirtualPad;
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

	inline function get_controls():Controls
		return Controls.instance;
		
    #if android
	public static var virtualPad:FlxVirtualPad;
	public static var androidControls:AndroidControls;
	public static var checkHitbox:Bool = false;
	public static var checkDUO:Bool = false;
	#end
	
	#if android
	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode) {
		virtualPad = new FlxVirtualPad(DPad, Action, 0.75, ClientPrefs.data.antialiasing);
		add(virtualPad);
		Controls.checkTheState = false;
		Controls.checkThePressedControl = true;
	}
	#end

	#if android
	public function removeVirtualPad() {
		remove(virtualPad);
	}
	#end
	
	#if android
	public function noCheckPress() {
		Controls.checkThePressedControl = false;
	}
	#end
	
	#if android
	public function addAndroidControls() {
		androidControls = new AndroidControls();
		
        Controls.checkThePressedControl = true;
        
		switch (androidControls.mode)
		{
			case VIRTUALPAD_RIGHT | VIRTUALPAD_LEFT | VIRTUALPAD_CUSTOM:
				checkHitbox = false;
				checkDUO = false;
				Controls.checkTheKeyboard = false;
			case DUO:
				checkHitbox = false;
				checkDUO = true;
				Controls.checkTheKeyboard = false;
			case HITBOX:
				checkHitbox = true;
				checkDUO = false;
				Controls.checkTheKeyboard = false;
			    
			default:
			    checkHitbox = false;
				checkDUO = false;
			    Controls.checkTheKeyboard = true;
		}

		var cameraController = new FlxCamera();
		FlxG.cameras.add(cameraController, false);
		cameraController.bgColor.alpha = 0;
		androidControls.cameras = [cameraController];

		androidControls.visible = false;

		add(androidControls);
		Controls.checkTheControls = true;
	}
	#end

	#if android
    public function addPadCamera() {
		var cameraController = new FlxCamera();
		cameraController.bgColor.alpha = 0;
		FlxG.cameras.add(cameraController, false);
		virtualPad.cameras = [cameraController];
	}
	#end
	
	override function update(elapsed:Float)
	{
		Main.watermark.x = Lib.application.window.width - 10 - Main.watermark.width;
		Main.watermark.y = Lib.application.window.height - 10 - Main.watermark.height;

		//everyStep();

		if (!persistentUpdate) MusicBeatState.timePassedOnState += elapsed;
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
		// Unknown...
	}
	
	public function sectionHit():Void
	{
		// Unknown...
	}
	
	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
