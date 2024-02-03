package substates;

/*
    Working Kade Engine results screen made by NF|beihu (北狐丶逐梦)
    BilBil: https://b23.tv/SnqG443
    YouTube: https://youtube.com/@beihu235?si=NHnWxcUWPS46EqUt
    Discord: beihu235
    
    You can use it for your mods or modified PE forks, but you must need to give me a credit and plus icon (Don't forget!)
    Logically is very easy to use it, so I think everyone can understand it
    
    Who cares about Rudy's HScript? I can continue to choose it to use my Lua logic, but her HScript is not weren't worth, so I didn't stole it.
    
    By the way dont move this to the HScript, I dont allow it! --NF | Beihu
*/

import flixel.addons.transition.FlxTransitionableState;

import states.FreeplayState;

import backend.Conductor;

import flixel.util.FlxSpriteUtil;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

#if sys
import sys.io.File;
import sys.FileSystem;
#end
import tjson.TJSON as Json;

typedef NoteTypeColorData =
{
	sick:FlxColor,
	good:FlxColor,
    bad:FlxColor,
    shit:FlxColor,
    miss:FlxColor
}

class ResultsScreenSubstate extends MusicBeatSubstate
{
	public var background:FlxSprite;	
	public var bgGrid:FlxBackdrop;
    public var graphBG:FlxSprite;
    public var graphSizeUp:FlxSprite;
	public var graphSizeDown:FlxSprite;
	public var graphSizeLeft:FlxSprite;
	public var graphSizeRight:FlxSprite;
	
	public var graphJudgeCenter:FlxSprite;
	public var graphSickUp:FlxSprite;
	public var graphSickDown:FlxSprite;
	public var graphGoodUp:FlxSprite;
	public var graphGoodDown:FlxSprite;
	public var graphBadUp:FlxSprite;
	public var graphBadDown:FlxSprite;
	public var graphShitUp:FlxSprite;
	public var graphShitDown:FlxSprite;
    public var graphMiss:FlxSprite;
    
    public var clearText:FlxText;
	public var judgeText:FlxText;
	public var setGameText:FlxText;
	public var setMsText:FlxText;
	public var backText:FlxText;
    
    public var noteTypeColor:NoteTypeColorData;
    
    public var color:FlxColor;
	public function new(x:Float, y:Float)
	{
		super();
		
		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.scrollFactor.set();
		background.alpha = 0;
		add(background);

		bgGrid = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x11FFFFFF, 0x0));
		bgGrid.alpha = 0;
		bgGrid.velocity.set(175, 175);
		add(bgGrid);
		
		var graphWidth = 550;
		var graphHeight = 300;
		graphBG = new FlxSprite(FlxG.width - 550 - 50, 50).makeGraphic(550, 300, FlxColor.BLACK);
		graphBG.scrollFactor.set();
		graphBG.alpha = 0;		
		add(graphBG);
		
		var noteSpr = FlxSpriteUtil.flashGfx;		
		var _rect = new Rectangle(0, 0, graphWidth, graphHeight);
		graphBG.pixels.fillRect(_rect, 0xFF000000);
		FlxSpriteUtil.beginDraw(0xFFFFFFFF);
	    
	    var noteSize = 2.3;
	    var moveSize = 0.6;
		for (i in 0...PlayState.rsNoteTime.length){
		    if (Math.abs(PlayState.rsNoteMs[i]) <= 200) color = FlxColor.CYAN;
		    if (Math.abs(PlayState.rsNoteMs[i]) <= Conductor.safeZoneOffset) color = FlxColor.LIME;
		    if (Math.abs(PlayState.rsNoteMs[i]) <= ClientPrefs.data.badWindow) color = FlxColor.YELLOW;
		    if (Math.abs(PlayState.rsNoteMs[i]) <= ClientPrefs.data.goodWindow) color = FlxColor.ORANGE;
		    if (Math.abs(PlayState.rsNoteMs[i]) <= ClientPrefs.data.sickWindow) color = FlxColor.RED;
		    FlxSpriteUtil.beginDraw(color);
		    if (Math.abs(PlayState.rsNoteMs[i]) <= 166) {
    			noteSpr.drawCircle(graphWidth * (PlayState.rsNoteTime[i] / PlayState.rsSongLength) - noteSize / 2 , graphHeight * 0.5 + graphHeight * 0.5 * moveSize * (PlayState.rsNoteMs[i] / Conductor.safeZoneOffset), noteSize);
    		} else {
    			noteSpr.drawCircle(graphWidth * (PlayState.rsNoteTime[i] / PlayState.rsSongLength) - noteSize / 2 , graphHeight * 0.5 + graphHeight * 0.5 * 0.8, noteSize);		
    		}
    		
		    graphBG.pixels.draw(FlxSpriteUtil.flashGfxSprite);
		}
		
		var judgeHeight = 3;
		graphJudgeCenter = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.WHITE);
		graphJudgeCenter.scrollFactor.set();
		graphJudgeCenter.alpha = 0;		
		add(graphJudgeCenter);
		
		graphSickUp = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - graphHeight * 0.5 * moveSize * (ClientPrefs.data.sickWindow / Conductor.safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.GREEN);
		graphSickUp.scrollFactor.set();
		graphSickUp.alpha = 0;		
		add(graphSickUp);
		
		graphSickDown = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * moveSize * (ClientPrefs.data.sickWindow / Conductor.safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.GREEN);
		graphSickDown.scrollFactor.set();
		graphSickDown.alpha = 0;		
		add(graphSickDown);
		
		graphGoodUp = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - graphHeight * 0.5 * moveSize * (ClientPrefs.data.goodWindow / Conductor.safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.YELLOW);
		graphGoodUp.scrollFactor.set();
		graphGoodUp.alpha = 0;		
		add(graphGoodUp);
		
		graphGoodDown = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * moveSize * (ClientPrefs.data.goodWindow / Conductor.safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.YELLOW);
		graphGoodDown.scrollFactor.set();
		graphGoodDown.alpha = 0;		
		add(graphGoodDown);
		
		graphBadUp = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - graphHeight * 0.5 * moveSize * (ClientPrefs.data.badWindow / Conductor.safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.ORANGE);
		graphBadUp.scrollFactor.set();
		graphBadUp.alpha = 0;		
		add(graphBadUp);
		
		graphBadDown = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * moveSize * (ClientPrefs.data.badWindow / Conductor.safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.ORANGE);
		graphBadDown.scrollFactor.set();
		graphBadDown.alpha = 0;		
		add(graphBadDown);
		
		graphShitUp = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - graphHeight * 0.5 * moveSize * (Conductor.safeZoneOffset / Conductor.safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.RED);
		graphShitUp.scrollFactor.set();
		graphShitUp.alpha = 0;		
		add(graphShitUp);
		
		graphShitDown = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * moveSize * (Conductor.safeZoneOffset / Conductor.safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.RED);
		graphShitDown.scrollFactor.set();
		graphShitDown.alpha = 0;		
		add(graphShitDown);
		
		graphMiss = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * 0.8 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.GRAY);
		graphMiss.scrollFactor.set();
		graphMiss.alpha = 0;		
		add(graphMiss);
		
		graphJudgeCenter = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.WHITE);
		graphJudgeCenter.scrollFactor.set();
		graphJudgeCenter.alpha = 0;		
		add(graphJudgeCenter);
		
		graphJudgeCenter = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.WHITE);
		graphJudgeCenter.scrollFactor.set();
		graphJudgeCenter.alpha = 0;		
		add(graphJudgeCenter);
		
		graphJudgeCenter = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.WHITE);
		graphJudgeCenter.scrollFactor.set();
		graphJudgeCenter.alpha = 0;		
		add(graphJudgeCenter);
		
		graphSizeUp = new FlxSprite(graphBG.x, graphBG.y - 2).makeGraphic(graphWidth + 2, 2, FlxColor.WHITE);
		graphSizeUp.scrollFactor.set();
		graphSizeUp.alpha = 0;		
		add(graphSizeUp);
		
		graphSizeDown = new FlxSprite(graphBG.x - 2, graphBG.y + graphHeight).makeGraphic(graphWidth + 2, 2, FlxColor.WHITE);
		graphSizeDown.scrollFactor.set();
		graphSizeDown.alpha = 0;		
		add(graphSizeDown);
		
		graphSizeLeft = new FlxSprite(graphBG.x - 2, graphBG.y - 2).makeGraphic(2, graphHeight + 2, FlxColor.WHITE);
		graphSizeLeft.scrollFactor.set();
		graphSizeLeft.alpha = 0;		
		add(graphSizeLeft);
		
		graphSizeRight = new FlxSprite(graphBG.x + graphWidth, graphBG.y).makeGraphic(2, graphHeight + 2, FlxColor.WHITE);
		graphSizeRight.scrollFactor.set();
		graphSizeRight.alpha = 0;		
		add(graphSizeRight);		
		
		//-----------------------BG
		clearText = new FlxText(20, -155, 0, 'Song Cleared!\n' + PlayState.SONG.song + ' - ' + '(' + Difficulty.getString() + ')' + '\n');
		clearText.size = 34;
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				clearText.font = Paths.font('bahnschrift.ttf');
			
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky':
				clearText.font = Paths.font('vcr.ttf');
			
			case 'Dave and Bambi':
				clearText.font = Paths.font('comic.ttf');
			
			case 'TGT Engine':
				clearText.font = Paths.font('calibri.ttf');
		}
		clearText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		clearText.scrollFactor.set();
		clearText.antialiasing = ClientPrefs.data.antialiasing;
		add(clearText);		
	    
	    var accurarcyCeil = Math.ceil(PlayState.resultsScreenAcurracy * 10000) / 100;
		judgeText = new FlxText(-400, 200, 0);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				judgeText.text = 'Judgements:
				\nSicks: ' + PlayState.resultsScreenSicks 
				+ '\nGoods: ' + PlayState.resultsScreenGoods 
				+ '\nBads: ' + PlayState.resultsScreenBads 
				+ '\nShits: ' + PlayState.resultsScreenShits 
				+ '\n\nNote missed: ' + PlayState.resultsScreenMisses 
				+ '\nCombo: ' + PlayState.resultsScreenCombo + ' (Max Combo: ' + PlayState.resultsScreenMaxCombo + ')'
				+ '\nCPS: ' + PlayState.resultsScreenNPS + ' (Max CPS: ' + PlayState.resultsScreenMaxNPS + ')'
				+ '\nScore: ' + PlayState.resultsScreenScore 
				+ '\nPercent: ' + accurarcyCeil + '%'
				+ '\nRank: ' + PlayState.resultsScreenRatingName + '{' + PlayState.resultsScreenFullCombo + '}';
			
			case 'Psych Engine' | 'TGT Engine':
				judgeText.text = 'Judgements:
				\nSicks: ' + PlayState.resultsScreenSicks 
				+ '\nGoods: ' + PlayState.resultsScreenGoods 
				+ '\nBads: ' + PlayState.resultsScreenBads 
				+ '\nShits: ' + PlayState.resultsScreenShits 
				+ '\n\nMisses: ' + PlayState.resultsScreenMisses 
				+ '\nCombo: ' + PlayState.resultsScreenCombo + ' (Max Combo: ' + PlayState.resultsScreenMaxCombo + ')'
				+ '\nNPS: ' + PlayState.resultsScreenNPS + ' (Max NPS: ' + PlayState.resultsScreenMaxNPS + ')'
				+ '\nScore: ' + PlayState.resultsScreenScore 
				+ '\nRating: ' + PlayState.resultsScreenRatingName + '(' + PlayState.resultsScreenFullCombo + accurarcyCeil + '%)';
			
			case 'Kade Engine' | 'Dave and Bambi' | 'Cheeky':
				judgeText.text = 'Judgements:
				\nSicks: ' + PlayState.resultsScreenSicks 
				+ '\nGoods: ' + PlayState.resultsScreenGoods 
				+ '\nBads: ' + PlayState.resultsScreenBads 
				+ '\nShits: ' + PlayState.resultsScreenShits 
				+ '\n\nCombo Breaks: ' + PlayState.resultsScreenMisses 
				+ '\nCombo: ' + PlayState.resultsScreenCombo + ' (Max Combo: ' + PlayState.resultsScreenMaxCombo + ')'
				+ '\nNPS: ' + PlayState.resultsScreenNPS + ' (Max NPS: ' + PlayState.resultsScreenMaxNPS + ')'
				+ '\nScore: ' + PlayState.resultsScreenScore 
				+ '\nAccuracy: ' + accurarcyCeil + '%'
				+ '\nRating: ' + PlayState.resultsScreenRatingName + '[' + PlayState.resultsScreenFullCombo + ']';
		}
		judgeText.size = 25;
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				judgeText.font = Paths.font('bahnschrift.ttf');
			
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky':
				judgeText.font = Paths.font('vcr.ttf');
			
			case 'Dave and Bambi':
				judgeText.font = Paths.font('comic.ttf');
			
			case 'TGT Engine':
				judgeText.font = Paths.font('calibri.ttf');
		}
		judgeText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		judgeText.scrollFactor.set();
		judgeText.antialiasing = ClientPrefs.data.antialiasing;
		add(judgeText);
		
		var botplay:String = 'False';
		if (ClientPrefs.getGameplaySetting('botplay')) botplay = 'True';
		var practice:String = 'False';
		if (ClientPrefs.getGameplaySetting('practice')) practice = 'True';

		setGameText = new FlxText(FlxG.width + 400, 420, 0, 
		'Gained health multiplier: X' + ClientPrefs.getGameplaySetting('healthgain')
		+ ' / Losed health multiplier: X' + ClientPrefs.getGameplaySetting('healthloss')
		+ '\n'
		+ 'Used the song speed: X' + ClientPrefs.getGameplaySetting('scrollspeed')
		+ ' / Playback used: X' + ClientPrefs.getGameplaySetting('songspeed')
		+ '\n'
		+ 'Used the botplay: ' + botplay
		+ ' / Used the practice mode: ' + practice
		+ '\n'
		+ 'Your current time: ' + Date.now().toString()
		+ '\n'
		);
		setGameText.size = 25;
		setGameText.alignment = RIGHT;
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				setGameText.font = Paths.font('bahnschrift.ttf');
			
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky':
				setGameText.font = Paths.font('vcr.ttf');
			
			case 'Dave and Bambi':
				setGameText.font = Paths.font('comic.ttf');
			
			case 'TGT Engine':
				setGameText.font = Paths.font('calibri.ttf');
		}
		setGameText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		setGameText.scrollFactor.set();
		setGameText.antialiasing = ClientPrefs.data.antialiasing;
		add(setGameText);
		
		var main:Float = 0;
		for (i in 0...PlayState.rsNoteTime.length){
		main = main + Math.abs(PlayState.rsNoteMs[i]);
		}
		main = Math.ceil(main / PlayState.rsNoteTime.length * 100) / 100;
        var safeZoneOffset:Float = Math.ceil(Conductor.safeZoneOffset * 10) / 10;
		setMsText = new FlxText(20, FlxG.height + 150, 0, 'Main: ' + main + 'ms' + '\n' + '(' + 'SICK:' + ClientPrefs.data.sickWindow + 'ms,' + 'GOOD:' + ClientPrefs.data.goodWindow + 'ms,' + 'BAD:' + ClientPrefs.data.badWindow + 'ms,' + 'SHIT:' + safeZoneOffset + 'ms' + ')'	+ '\n');
		setMsText.size = 16;
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				setMsText.font = Paths.font('bahnschrift.ttf');
			
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky':
				setMsText.font = Paths.font('vcr.ttf');
			
			case 'Dave and Bambi':
				setMsText.font = Paths.font('comic.ttf');
			
			case 'TGT Engine':
				setMsText.font = Paths.font('calibri.ttf');
		}
		setMsText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		setMsText.scrollFactor.set();
		setMsText.antialiasing = ClientPrefs.data.antialiasing;
		add(setMsText);		
		
		var backTextShow:String = 'Press ENTER to continue';
		#if android backTextShow = 'Touch the screen to continue'; #end
		backText = new FlxText(0, FlxG.height - 45, 0, backTextShow);
		backText.size = 28;
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				backText.font = Paths.font('bahnschrift.ttf');
			
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky':
				backText.font = Paths.font('vcr.ttf');
			
			case 'Dave and Bambi':
				backText.font = Paths.font('comic.ttf');
			
			case 'TGT Engine':
				backText.font = Paths.font('calibri.ttf');
		}
		backText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		backText.scrollFactor.set();
		backText.antialiasing = ClientPrefs.data.antialiasing;
	    backText.alignment = RIGHT;
		add(backText);		
		backText.alpha = 0;
		backText.x = FlxG.width - backText.width - 20;

		//--------------text
		
		//time = 0
		FlxTween.tween(background, {alpha: 0.5}, 0.5, {ease: FlxEase.sineInOut});
		FlxTween.tween(bgGrid, {alpha: 0.5}, 0.5, {ease: FlxEase.sineInOut});		
		new FlxTimer().start(0.5, function(tmr:FlxTimer) { 
			FlxTween.tween(clearText, {y: ClientPrefs.data.showFPS ? 60 : 5}, 0.5, {ease: FlxEase.sineInOut}); 
		});
		
		
		new FlxTimer().start(1, function(tmr:FlxTimer) { 
			FlxTween.tween(setMsText, {y: FlxG.height - 25 * 2}, 0.5, {ease: FlxEase.sineInOut});			
		});
		
		new FlxTimer().start(1.5, function(tmr:FlxTimer){
		    FlxTween.tween(judgeText, {x: 20}, 0.5, {ease: FlxEase.sineInOut});		
		    FlxTween.tween(setGameText, {x: FlxG.width - setGameText.width - 20}, 0.5, {ease: FlxEase.sineInOut});		
		});
		
		new FlxTimer().start(2, function(tmr:FlxTimer){
			FlxTween.tween(graphBG, {alpha: 0.75}, 0.5, {ease: FlxEase.sineInOut});
			FlxTween.tween(graphJudgeCenter, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});	
			FlxTween.tween(graphSickUp, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});	
			FlxTween.tween(graphSickDown, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});	
			FlxTween.tween(graphGoodUp, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});	
			FlxTween.tween(graphGoodDown, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});	
			FlxTween.tween(graphBadUp, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});	
			FlxTween.tween(graphBadDown, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});	
			FlxTween.tween(graphShitUp, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});
			FlxTween.tween(graphShitDown, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});	
			FlxTween.tween(graphMiss, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});	
		    FlxTween.tween(graphSizeUp, {alpha: 0.75}, 0.5, {ease: FlxEase.sineInOut});
		    FlxTween.tween(graphSizeDown, {alpha: 0.75}, 0.5, {ease: FlxEase.sineInOut});
		    FlxTween.tween(graphSizeLeft, {alpha: 0.75}, 0.5, {ease: FlxEase.sineInOut});
		    FlxTween.tween(graphSizeRight, {alpha: 0.75}, 0.5, {ease: FlxEase.sineInOut});	
		});
		
		new FlxTimer().start(2.5, function(tmr:FlxTimer){
			FlxTween.tween(backText, {alpha: 1}, 1, {ease: FlxEase.sineInOut});	
		});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];	
	}
	
    
	override function update(elapsed:Float)
	{   
        #if android
		var pressedTheTouchScreen:Bool = false;

		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				pressedTheTouchScreen = true;
			}
		}
		#end

	    var botplay:String = 'False';
		if (ClientPrefs.getGameplaySetting('botplay')) botplay = 'True';
		var practice:String = 'False';
		if (ClientPrefs.getGameplaySetting('practice')) practice = 'True';

		setGameText.text = 'Gained health multiplier: X' + ClientPrefs.getGameplaySetting('healthgain')
		+ ' / Losed health multiplier: X' + ClientPrefs.getGameplaySetting('healthloss')
		+ '\n'
		+ 'Used the song speed: X' + ClientPrefs.getGameplaySetting('scrollspeed')
		+ ' / Playback used: X' + ClientPrefs.getGameplaySetting('songspeed')
		+ '\n'
		+ 'Used the botplay: ' + botplay
		+ ' / Used the practice mode: ' + practice
		+ '\n'
		+ 'Your current time: ' + Date.now().toString()
		+ '\n';

		if(FlxG.keys.justPressed.ENTER #if android || pressedTheTouchScreen #end)
		{
            Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Freeplay Menu (Closing the state)";
		    MusicBeatState.switchState(new FreeplayState());
            FlxG.sound.playMusic(Paths.music('freakyMenu-' + ClientPrefs.data.mainMenuMusic));
		}
		PlayState.cancelMusicFadeTween();
	}

	override function destroy()
	{
		super.destroy();
	}
}