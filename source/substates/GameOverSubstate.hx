package substates;

import backend.WeekData;

import objects.Character;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;

import states.StoryMenuState;
import states.FreeplayState;

class GameOverSubstate extends MusicBeatSubstate
{
	var bgWoof:FlxSprite;
	public var boyfriend:Character;
	public var girlfriend:Character;
	var textTitle:FlxText = null;
	var camFollow:FlxObject;
	var updateCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var characterName2:String = 'gf';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName = 'bf-dead';
		characterName2 = 'gf';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';

		var _song = PlayState.SONG;
		if(_song != null)
		{
			if(_song.gameOverChar != null && _song.gameOverChar.trim().length > 0) characterName = _song.gameOverChar;
			if(_song.gameOverChar2 != null && _song.gameOverChar2.trim().length > 0) characterName2 = _song.gameOverChar2;
			if(_song.gameOverSound != null && _song.gameOverSound.trim().length > 0) deathSoundName = _song.gameOverSound;
			if(_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0) loopSoundName = _song.gameOverLoop;
			if(_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0) endSoundName = _song.gameOverEnd;
		}
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnScripts('onGameOverStart', []);

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		PlayState.instance.setOnScripts('inGameOver', true);

		Conductor.songPosition = 0;

		bgWoof = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.BLACK, FlxColor.BLUE], 1, 90, true);
		bgWoof.antialiasing = ClientPrefs.data.antialiasing;
		bgWoof.scale.set(1, 1);
		bgWoof.alpha = 0.0001;
		bgWoof.scrollFactor.set();
		add(bgWoof);

		girlfriend = new Character(x, y, characterName2, false);
		girlfriend.playAnim("scared", true);
		add(girlfriend);

		boyfriend = new Character(x, y, characterName, true);
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		add(boyfriend);

		FlxG.sound.play(Paths.sound(deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		girlfriend.playAnim('sad');
		boyfriend.playAnim('firstDeath');

		textTitle = new FlxText(0, 0, -1,  "", 30);
		textTitle.setFormat("VCR OSD Mono", 22, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(textTitle);
		textTitle.scrollFactor.set();

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);
		FlxG.camera.focusOn(new FlxPoint(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2)));
		add(camFollow);

    #if mobile
    addVirtualPad(NONE, A_B);
    addPadCamera();
    #end
	}

	public var startedDeath:Bool = false;
	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.camera.zoom = FlxMath.lerp(PlayState.defaultCamZoom, FlxG.camera.zoom, 1 - (elapsed * 6));

		PlayState.instance.callOnScripts('onUpdate', [elapsed]);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			#if desktop DiscordClient.resetClientID(); #end
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			PlayState.chartingMode = false;

			Mods.loadTopMod();
			if (PlayState.isStoryMode)
				MusicBeatState.switchState(new StoryMenuState());
			else
				MusicBeatState.switchState(new FreeplayState());

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
		}
		
		if (boyfriend.animation.curAnim != null)
		{
			if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath)
				boyfriend.playAnim('deathLoop');

			if(boyfriend.animation.curAnim.name == 'firstDeath')
			{
				if(boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
				{
					girlfriend.playAnim("sad", true);
					textTitle.text = "You just died, Try again?";
					textTitle.screenCenter(FlxAxes.XY);
					textTitle.y += 200;
					FlxG.camera.follow(camFollow, LOCKON, 0);
					updateCamera = true;
					isFollowingAlready = true;
				}

				if (boyfriend.animation.curAnim.finished && !playingDeathSound)
				{
					startedDeath = true;
					if (PlayState.SONG.stage == 'tank')
					{
						playingDeathSound = true;
						coolStartDeath(0.2);
						
						var exclude:Array<Int> = [];
						//if(!ClientPrefs.cursing) exclude = [1, 3, 8, 13, 17, 21];

						FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function() {
							if(!isEnding)
							{
								FlxG.sound.music.fadeIn(0.2, 1, 4);
							}
						});

						if (bgWoof.scale.x != PlayState.defaultCamZoom) bgWoof.scale.set(1 / PlayState.defaultCamZoom, 1 / PlayState.defaultCamZoom);
					}
					else coolStartDeath();
				}
			}
		}
		
		if(updateCamera) FlxG.camera.followLerp = FlxMath.bound(elapsed * 0.6 / (FlxG.updateFramerate / 60), 0, 1);
		else FlxG.camera.followLerp = 0;

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
	}

	var ea:FlxTween;
	override function beatHit()
	{
		girlfriend.playAnim("sad", true);
		boyfriend.playAnim("deathLoop", true);
	
		if (ea != null){
			ea.cancel();
		}
		bgWoof.alpha += 0.3;
		ea = FlxTween.tween(bgWoof, {alpha: 0.0001}, 0.5, {ease:FlxEase.circInOut, onComplete:function(e){
			ea = null;
		}});
	
		FlxG.camera.zoom += 0.010;
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			if (textTitle != null) textTitle.text = "Restarting...";
			girlfriend.playAnim('cheer', true);
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			if (ea != null){
				ea.cancel();
			}
			bgWoof.alpha += 0.5;
			ea = FlxTween.tween(bgWoof, {alpha: 0.0001}, 2, {ease:FlxEase.circInOut, onComplete:function(e){
				ea = null;
			}});
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxTween.tween(PlayState, {defaultCamZoom: PlayState.defaultCamZoom - 0.1}, 5, {ease:FlxEase.sineInOut});
				FlxTween.tween(camFollow, {y: camFollow.y - 1000}, 3, {ease:FlxEase.sineInOut});
				FlxTween.tween(FlxG.camera, {angle: -50}, 5, {ease:FlxEase.sineInOut});
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
		}
	}

	override function destroy()
	{
		instance = null;
		super.destroy();
	}
}
