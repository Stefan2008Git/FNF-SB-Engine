package states.stages;

import flixel.math.FlxPoint;
import animateatlas.AtlasFrameMaker;

import states.stages.objects.*;
import cutscenes.CutsceneHandler;
import substates.GameOverSubstate;
import states.PlayState;
import objects.Character;

class Tank extends BaseStage
{
	var tankWatchtower:BGSprite;
	var tankGround:BackgroundTank;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var foregroundSprites:FlxTypedGroup<BGSprite>;

	override function create()
	{
        if (songName == 'stress'){
        var _song = PlayState.SONG;
				if(_song.gameOverChar == null || _song.gameOverChar.trim().length < 1) GameOverSubstate.characterName = 'bf-holding-gf-dead';
        }
		var sky:BGSprite = new BGSprite('tankSky', -400, -400, 0, 0);
		add(sky);

		if(!ClientPrefs.data.lowQuality)
		{
			var clouds:BGSprite = new BGSprite('tankClouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20), 0.1, 0.1);
			clouds.active = true;
			clouds.velocity.x = FlxG.random.float(5, 15);
			add(clouds);

			var mountains:BGSprite = new BGSprite('tankMountains', -300, -20, 0.2, 0.2);
			mountains.setGraphicSize(Std.int(1.2 * mountains.width));
			mountains.updateHitbox();
			add(mountains);

			var buildings:BGSprite = new BGSprite('tankBuildings', -200, 0, 0.3, 0.3);
			buildings.setGraphicSize(Std.int(1.1 * buildings.width));
			buildings.updateHitbox();
			add(buildings);
		}

		var ruins:BGSprite = new BGSprite('tankRuins',-200,0,.35,.35);
		ruins.setGraphicSize(Std.int(1.1 * ruins.width));
		ruins.updateHitbox();
		add(ruins);

		if(!ClientPrefs.data.lowQuality)
		{
			var smokeLeft:BGSprite = new BGSprite('smokeLeft', -200, -100, 0.4, 0.4, ['SmokeBlurLeft'], true);
			add(smokeLeft);
			var smokeRight:BGSprite = new BGSprite('smokeRight', 1100, -100, 0.4, 0.4, ['SmokeRight'], true);
			add(smokeRight);

			tankWatchtower = new BGSprite('tankWatchtower', 100, 50, 0.5, 0.5, ['watchtower gradient color']);
			add(tankWatchtower);
		}

		tankGround = new BackgroundTank();
		add(tankGround);

		tankmanRun = new FlxTypedGroup<TankmenBG>();
		add(tankmanRun);

		var ground:BGSprite = new BGSprite('tankGround', -420, -150);
		ground.setGraphicSize(Std.int(1.15 * ground.width));
		ground.updateHitbox();
		add(ground);

		foregroundSprites = new FlxTypedGroup<BGSprite>();
		foregroundSprites.add(new BGSprite('tank0', -500, 650, 1.7, 1.5, ['fg']));
		if(!ClientPrefs.data.lowQuality) foregroundSprites.add(new BGSprite('tank1', -300, 750, 2, 0.2, ['fg']));
		foregroundSprites.add(new BGSprite('tank2', 450, 940, 1.5, 1.5, ['foreground']));
		if(!ClientPrefs.data.lowQuality) foregroundSprites.add(new BGSprite('tank4', 1300, 900, 1.5, 1.5, ['fg']));
		foregroundSprites.add(new BGSprite('tank5', 1620, 700, 1.5, 1.5, ['fg']));
		if(!ClientPrefs.data.lowQuality) foregroundSprites.add(new BGSprite('tank3', 1300, 1200, 3.5, 2.5, ['fg']));

		// Default GFs
		if(songName == 'stress') setDefaultGF('pico-speaker');
		else setDefaultGF('gf-tankmen');
		
		if (isStoryMode && !seenCutscene)
		{
			switch (songName)
			{
				case 'ugh':
					setStartCallback(ughIntro);
				case 'guns':
					setStartCallback(gunsIntro);
				case 'stress':
					setStartCallback(stressIntro);
			}
		}
	}
	override function createPost()
	{
		add(foregroundSprites);

		if(!ClientPrefs.data.lowQuality)
		{
			for (daGf in gfGroup)
			{
				var gf:Character = cast daGf;
				if(gf.curCharacter == 'pico-speaker')
				{
					var firstTank:TankmenBG = new TankmenBG(20, 500, true);
					firstTank.resetShit(20, 600, true);
					firstTank.strumTime = 10;
					firstTank.visible = false;
					tankmanRun.add(firstTank);

					for (i in 0...TankmenBG.animationNotes.length)
					{
						if(FlxG.random.bool(16)) {
							var tankBih = tankmanRun.recycle(TankmenBG);
							tankBih.strumTime = TankmenBG.animationNotes[i][0];
							tankBih.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
							tankmanRun.add(tankBih);
						}
					}
					break;
				}
			}
		}
	}

	override function countdownTick(count:Countdown, num:Int) if(num % 2 == 0) everyoneDance();
	override function beatHit() everyoneDance();
	function everyoneDance()
	{
		if(!ClientPrefs.data.lowQuality) tankWatchtower.dance();
		foregroundSprites.forEach(function(spr:BGSprite)
		{
			spr.dance();
		});
	}

	// Cutscenes
	var cutsceneHandler:CutsceneHandler;
	var tankman:FlxSprite;
	var tankman2:FlxSprite;
	var gfDance:FlxSprite;
	var gfCutscene:FlxSprite;
	var picoCutscene:FlxSprite;
	var boyfriendCutscene:FlxSprite;
	function prepareCutscene()
	{
		cutsceneHandler = new CutsceneHandler();

		dadGroup.alpha = 0.00001;
		camHUD.visible = false;
		//inCutscene = true; //this would stop the camera movement, oops

		tankman = new FlxSprite(-20, 320);
		tankman.frames = Paths.getSparrowAtlas('cutscenes/' + songName);
		tankman.antialiasing = ClientPrefs.data.antialiasing;
		addBehindDad(tankman);

		tankman2 = new FlxSprite(16, 312);
		tankman2.antialiasing = ClientPrefs.data.antialiasing;
		tankman2.alpha = 0.000001;

		gfDance = new FlxSprite(gf.x - 107, gf.y + 140);
		gfDance.antialiasing = ClientPrefs.data.antialiasing;

		gfCutscene = new FlxSprite(gf.x - 104, gf.y + 122);
		gfCutscene.antialiasing = ClientPrefs.data.antialiasing;

		picoCutscene = new FlxSprite(gf.x - 849, gf.y - 264);
		picoCutscene.antialiasing = ClientPrefs.data.antialiasing;

		boyfriendCutscene = new FlxSprite(boyfriend.x + 5, boyfriend.y + 20);
		boyfriendCutscene.antialiasing = ClientPrefs.data.antialiasing;

		cutsceneHandler.push(tankman);
		cutsceneHandler.push(tankman2);
		cutsceneHandler.push(gfDance);
		cutsceneHandler.push(gfCutscene);
		cutsceneHandler.push(picoCutscene);
		cutsceneHandler.push(boyfriendCutscene);

		cutsceneHandler.finishCallback = function()
		{
			var timeForStuff:Float = Conductor.crochet / 1000 * 4.5;
			FlxG.sound.music.fadeOut(timeForStuff);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, timeForStuff, {ease: FlxEase.quadInOut});
			startCountdown();

			dadGroup.alpha = 1;
			camHUD.visible = true;
			boyfriend.animation.finishCallback = null;
			gf.animation.finishCallback = null;
			gf.dance();
		};
		camFollow.setPosition(dad.x + 280, dad.y + 170);
	}

	function ughIntro()
	{
		prepareCutscene();
		cutsceneHandler.endTime = 12;
		cutsceneHandler.music = 'DISTORTO';
		precacheSound('wellWellWell');
		precacheSound('killYou');
		precacheSound('bfBeep');

		var wellWellWell:FlxSound = new FlxSound().loadEmbedded(Paths.sound('wellWellWell'));
		FlxG.sound.list.add(wellWellWell);

		tankman.animation.addByPrefix('wellWell', 'TANK TALK 1 P1', 24, false);
		tankman.animation.addByPrefix('killYou', 'TANK TALK 1 P2', 24, false);
		tankman.animation.play('wellWell', true);
		FlxG.camera.zoom *= 1.2;

		// Well well well, what do we got here?
		cutsceneHandler.timer(0.1, function()
		{
			wellWellWell.play(true);
		});

		// Move camera to BF
		cutsceneHandler.timer(3, function()
		{
			camFollow.x += 750;
			camFollow.y += 100;
		});

		// Beep!
		cutsceneHandler.timer(4.5, function()
		{
			boyfriend.playAnim('singUP', true);
			boyfriend.specialAnim = true;
			FlxG.sound.play(Paths.sound('bfBeep'));
		});

		// Move camera to Tankman
		cutsceneHandler.timer(6, function()
		{
			camFollow.x -= 750;
			camFollow.y -= 100;

			// We should just kill you but... what the hell, it's been a boring day... let's see what you've got!
			tankman.animation.play('killYou', true);
			FlxG.sound.play(Paths.sound('killYou'));
		});
	}
	function gunsIntro()
	{
		prepareCutscene();
		cutsceneHandler.endTime = 11.5;
		cutsceneHandler.music = 'DISTORTO';
		tankman.x += 40;
		tankman.y += 10;
		precacheSound('tankSong2');

		var tightBars:FlxSound = new FlxSound().loadEmbedded(Paths.sound('tankSong2'));
		FlxG.sound.list.add(tightBars);

		tankman.animation.addByPrefix('tightBars', 'TANK TALK 2', 24, false);
		tankman.animation.play('tightBars', true);
		boyfriend.animation.curAnim.finish();

		cutsceneHandler.onStart = function()
		{
			tightBars.play(true);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 4, {ease: FlxEase.quadInOut});
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2 * 1.2}, 0.5, {ease: FlxEase.quadInOut, startDelay: 4});
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 1, {ease: FlxEase.quadInOut, startDelay: 4.5});
		};

		cutsceneHandler.timer(4, function()
		{
			gf.playAnim('sad', true);
			gf.animation.finishCallback = function(name:String)
			{
				gf.playAnim('sad', true);
			};
		});
	}
	function stressIntro()
	{
  game.startVideo('stressCutscene');
	}

	function zoomBack()
	{
		var calledTimes:Int = 0;
		camFollow.setPosition(630, 425);
		FlxG.camera.snapToTarget();
		FlxG.camera.zoom = 0.8;
		game.cameraSpeed = 1;

		calledTimes++;
		if (calledTimes > 1)
		{
			foregroundSprites.forEach(function(spr:BGSprite)
			{
				spr.y -= 100;
			});
		}
	}
}