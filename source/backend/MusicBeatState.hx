package backend;

#if android
import android.AndroidControls.AndroidControls;
import android.flixel.FlxHitbox;
import android.flixel.FlxNewHitbox;
import android.flixel.FlxVirtualPad;
import android.flixel.FlxButton as FlxNewButton;
#end

class MusicBeatState extends FlxUIState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	public var controls(get, never):Controls;
	
	public static var checkHitbox:Bool = false;
	public static var checkDUO:Bool = false;
	
	private function get_controls()
	{
		return Controls.instance;
	}
	
	#if android
	public static var virtualPad:FlxVirtualPad;
	public static var androidControls:AndroidControls;
	//var trackedinputsUI:Array<FlxActionInput> = [];
	//var trackedinputsNOTES:Array<FlxActionInput> = [];
	#end
	
	#if android
	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode) {
		virtualPad = new FlxVirtualPad(DPad, Action, 0.75, ClientPrefs.data.antialiasing);
		add(virtualPad);
		Controls.checkTheState = true;
		Controls.checkThePressedControl = true;
		//controls.setVirtualPadUI(virtualPad, DPad, Action);
		//trackedinputsUI = controls.trackedinputsUI;
		//controls.trackedinputsUI = [];
	}
	#end

	#if android
	public function removeVirtualPad() {
		//controls.removeFlxInput(trackedinputsUI);
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
				//controls.setVirtualPadNOTES(androidControls.virtualPads, FULL, NONE);
				checkHitbox = false;
				checkDUO = false;
				Controls.checkTheKeyboard = false;
			case DUO:
				//controls.setVirtualPadNOTES(androidControls.virtualPads, DUO, NONE);
				checkHitbox = false;
				checkDUO = true;
				Controls.checkTheKeyboard = false;
			case HITBOX:
				//controls.setNewHitBox(androidControls.newHitbox);
				checkHitbox = true;
				checkDUO = false;
				Controls.checkTheKeyboard = false;
			//case KEYBOARD:	
			    
			default:
			    checkHitbox = false;
				checkDUO = false;
			    Controls.checkTheKeyboard = true;
		}

		var camcontrol = new flixel.FlxCamera();
		FlxG.cameras.add(camcontrol, false);
		camcontrol.bgColor.alpha = 0;
		androidControls.cameras = [camcontrol];

		androidControls.visible = false;

		add(androidControls);
		Controls.checkTheControls = true;
	}
	#end

	#if android
    public function addPadCamera() {
		var camcontrol = new flixel.FlxCamera();
		camcontrol.bgColor.alpha = 0;
		FlxG.cameras.add(camcontrol, false);
		virtualPad.cameras = [camcontrol];
	}
	#end

	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	inline public static function getVariables()
		return getState().variables;

	public static var camBeat:FlxCamera;
	override function create() {
		camBeat = FlxG.camera;
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		#if MODS_ALLOWED Mods.updatedOnState = false; #end

		super.create();

		if(!skip) {
			openSubState(new CustomFadeTransition(0.7, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
		timePassedOnState = 0;
	}

	public static var timePassedOnState:Float = 0;
	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;
		timePassedOnState += elapsed;

		Main.watermark.x = Lib.application.window.width - 10 - Main.watermark.width;
		Main.watermark.y = Lib.application.window.height - 10 - Main.watermark.height;

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

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;
		
		stagesFunc(function(stage:BaseStage) {
			stage.update(elapsed);
		});

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

	public static function getState():MusicBeatState {
		return cast (FlxG.state, MusicBeatState);
	}

	public function stepHit():Void
	{
		stagesFunc(function(stage:BaseStage) {
			stage.curStep = curStep;
			stage.curDecStep = curDecStep;
			stage.stepHit();
		});

		if (curStep % 4 == 0)
			beatHit();
	}

	override function startOutro(onOutroComplete:()-> Void):Void
	{
		if (!FlxTransitionableState.skipNextTransIn || !ClientPrefs.data.fadeTransition)
		{
			FlxG.state.openSubState(new CustomFadeTransition(0.6, false));

			CustomFadeTransition.finishCallback = onOutroComplete;

			return;
		}

		FlxTransitionableState.skipNextTransIn = false;

		onOutroComplete();
	}

	public var stages:Array<BaseStage> = [];
	public function beatHit():Void
	{
		//TraceText.makeTheTraceText('Beat: ' + curBeat);
		stagesFunc(function(stage:BaseStage) {
			stage.curBeat = curBeat;
			stage.curDecBeat = curDecBeat;
			stage.beatHit();
		});
	}

	public function sectionHit():Void
	{
		//TraceText.makeTheTraceText('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
		stagesFunc(function(stage:BaseStage) {
			stage.curSection = curSection;
			stage.sectionHit();
		});
	}

	function stagesFunc(func:BaseStage->Void)
	{
		for (stage in stages)
			if(stage != null && stage.exists && stage.active)
				func(stage);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
