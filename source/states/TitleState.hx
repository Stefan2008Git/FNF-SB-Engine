package states;

import backend.WeekData;
import backend.Highscore;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import tjson.TJSON as Json;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import shaders.ColorSwap;

import states.StoryMenuState;
import states.MainMenuState;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

typedef TitleData =
{

	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}

class TitleState extends MusicBeatState {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	
	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var titleJSON:TitleData;

	override public function create():Void
	{
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion +" - Title screen";
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		removeVirtualPad();
		noCheckPress();
        #end

		Paths.clearStoredMemory();

		#if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		curWacky = FlxG.random.getObject(getIntroTextShit());

		super.create();

		FlxG.save.bind('stefan2008', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();
		Highscore.load();

		// IGNORE THIS!!!
		titleJSON = Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		#end
	}

	var logoBl:FlxSprite;
	var beginTween:FlxTween;
	var logoBlTrail:FlxTrail;
	var gfDance:FlxSprite;
	var gfDanceTrail:FlxTrail;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var psychSpr:FlxSprite;
	var swagShader:ColorSwap = null;

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu-' + ClientPrefs.data.mainMenuMusic), 0);
			}
		}

		Conductor.bpm = titleJSON.bpm;
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;

		if (titleJSON.backgroundSprite != null && titleJSON.backgroundSprite.length > 0 && titleJSON.backgroundSprite != "none"){
			bg.loadGraphic(Paths.image(titleJSON.backgroundSprite));
		}else{
			bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		}

		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		if (ClientPrefs.data.objects) {
			logoBl = new FlxSprite(titleJSON.titlex, titleJSON.titley);
		} else {
			logoBl = new FlxSprite(-150, -100);
		}
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		if (ClientPrefs.data.objects) {
			logoBl.alpha = 0;
			logoBl.scale.x = 0;
			logoBl.scale.y = 0;
		} else {
			logoBl.alpha = 1;
			logoBl.scale.x = 1;
			logoBl.scale.y = 1;
		}

		if (ClientPrefs.data.objects) {
			logoBlTrail = new FlxTrail(logoBl, 4, 0, 0.4, 0.02);
		} else {
			logoBlTrail = new FlxTrail(logoBl, 0, 0, 0, 0);
		}
		
		if(ClientPrefs.data.shaders) swagShader = new ColorSwap();
		gfDance = new FlxSprite(titleJSON.gfx, titleJSON.gfy);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = ClientPrefs.data.antialiasing;
		if (ClientPrefs.data.objects) {
			gfDance.alpha = 0;
			gfDance.scale.x = 0;
			gfDance.scale.y = 0;
		} else {
			gfDance.alpha = 1;
			gfDance.scale.x = 1;
			gfDance.scale.y = 1;
		}

		if (ClientPrefs.data.objects) {
			gfDanceTrail = new FlxTrail(gfDance, 4, 0, 0.1, 0);
		} else {
			gfDanceTrail = new FlxTrail(gfDance, 0, 0, 0, 0);
		}
		add(logoBlTrail);
		add(gfDanceTrail);
		add(logoBl);
		add(gfDance);
		if(swagShader != null)
		{
			gfDance.shader = swagShader.shader;
			logoBl.shader = swagShader.shader;
		}

		titleText = new FlxSprite(titleJSON.startx, titleJSON.starty);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		var animFrames:Array<FlxFrame> = [];
		@:privateAccess {
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}
		
		if (animFrames.length > 0) {
			newTitle = true;
			
			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.data.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else {
			newTitle = false;
			
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		}
		
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		psychSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('peLogo'));
		add(psychSpr);
		psychSpr.visible = false;
		psychSpr.scale.x = 0.5;
		psychSpr.scale.y = 0.5;
		psychSpr.updateHitbox();
		psychSpr.screenCenter(X);
		psychSpr.antialiasing = ClientPrefs.data.antialiasing;

		Paths.clearUnusedMemory();

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		credTextShit.visible = false;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	function getIntroTextShit():Array<Array<String>>
	{
		#if MODS_ALLOWED
		var firstArray:Array<String> = Mods.mergeAllTextsNamed('data/introText.txt', Paths.getPreloadPath());
		#else
		var fullText:String = Assets.getText(Paths.txt('introText'));
		var firstArray:Array<String> = fullText.split('\n');
		#end
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		if (controls.FULL_SCREEN) FlxG.fullscreen = !FlxG.fullscreen;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		if (initialized && !transitioning && skippedIntro) {
			if (pressedEnter) {
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;

				timer = FlxEase.quadInOut(timer);

				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}

			if (pressedEnter) {
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;

				if (titleText != null)
					titleText.animation.play('press');

				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				if (ClientPrefs.data.objects) {
					FlxTween.tween(logoBl, {x: -700}, 2, {
						ease: FlxEase.backInOut,
						type: ONESHOT,
						onComplete: function(twn:FlxTween) logoBl.kill()
					});
					FlxTween.tween(logoBl, {alpha: 0}, 1.3, {
						ease: FlxEase.backInOut,
						type: ONESHOT,
						onComplete: function(twn:FlxTween) {
							logoBl.kill();
						}
					});
					FlxTween.tween(gfDance, {x: 1350}, 2, {
						ease: FlxEase.backInOut,
						type: ONESHOT,
						onComplete: function(twn:FlxTween) gfDance.kill()
					});
					FlxTween.tween(gfDance, {alpha: 0}, 1.3, {
						ease: FlxEase.backInOut,
						type: ONESHOT,
						onComplete: function(twn:FlxTween) {
							gfDance.kill();
						}
					});
					FlxTween.tween(titleText, {y: 700}, 2, {
						ease: FlxEase.backInOut,
						type: ONESHOT,
						onComplete: function(twn:FlxTween) titleText.kill()
					});
					FlxTween.tween(titleText, {alpha: 0}, 1.3, {
						ease: FlxEase.backInOut,
						type: ONESHOT,
						onComplete: function(twn:FlxTween) {
							titleText.kill();
						}
					});
				}
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;

				new FlxTimer().start(1, function(tmr:FlxTimer) {
					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0;

	public static var closedState:Bool = false;

	override function beatHit() {
		super.beatHit();
		if (logoBl != null)
			logoBl.animation.play('bump', true);

		if (gfDance != null) {
			danceLeft = !danceLeft;
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}

		if (!closedState) {
			sickBeats++;
			switch (sickBeats) {
				case 1:
					FlxG.sound.playMusic(Paths.music('freakyMenu-' + ClientPrefs.data.mainMenuMusic), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.7);
				case 2:
					createCoolText(['SB Engine by'], 15);
				case 4:
					addMoreText('Stefan2008', 15);
					addMoreText('Hutaro', 15);
					addMoreText('MaysLastPlay', 15);
					addMoreText('Fearester', 15);
				case 5:
					deleteCoolText();
				case 6:
					createCoolText(['Forked', 'From'], -40);
				case 8:
					addMoreText('Psych Engine v' + MainMenuState.psychEngineVersion, -40);
					psychSpr.visible = true;
				case 9:
					deleteCoolText();
					psychSpr.visible = false;
				case 10:
					#if !android
					createCoolText([curWacky[0]]);
					#else
					deleteCoolText();
					#end
				case 12:
					#if !android
					addMoreText(curWacky[1]);
					#else
					deleteCoolText();
					#end
				case 13:
					deleteCoolText();
				case 14:
					addMoreText('Friday');
				case 15:
					addMoreText('Night');
				case 16:
					addMoreText('Funkin');
				case 17:
					addMoreText('SB');
				case 18:
					addMoreText('Engine');

				case 19:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;

	function skipIntro():Void {
		if (!skippedIntro) {
			{
				remove(psychSpr);
				remove(credGroup);
				FlxG.camera.flash(FlxColor.WHITE, 4);
				if (ClientPrefs.data.objects) {
					FlxTween.tween(logoBl, {y: -100}, 1.4, {ease: FlxEase.expoInOut});
					FlxTween.tween(logoBl, {alpha: 1}, 0.75, {ease: FlxEase.quadInOut});
					beginTween = FlxTween.tween(logoBl.scale, {x: 1, y: 1}, 0.75, {ease: FlxEase.quadInOut});
					FlxTween.tween(gfDance, {alpha: 1}, 0.75, {ease: FlxEase.quadInOut});
					beginTween = FlxTween.tween(gfDance.scale, {x: 1, y: 1}, 0.75, {ease: FlxEase.quadInOut});

					logoBl.angle = -4;
					new FlxTimer().start(0.01, function(tmr:FlxTimer) {
					if (logoBl.angle == -4)
						FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
					if (logoBl.angle == 4)
						FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
					}, 0);
				}

				FlxG.camera.flash(FlxColor.WHITE, 3);
				{
					transitioning = false;
				};
			}
		} else {
			remove(credGroup);
			FlxG.camera.flash(FlxColor.WHITE, 4);
		}
		skippedIntro = true;
	}
}