package android;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
//import flixel.ui.FlxButton;
import android.flixel.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import android.FlxHitbox;
import android.FlxNewHitbox;
import android.AndroidControls.Config;
import android.FlxVirtualPad;

using StringTools;

class AndroidControlsMenu extends MusicBeatState
{
	var virtualPads:FlxVirtualPad;
	//var hbox:FlxHitbox;
	var newhbox:FlxNewHitbox;
	var upPozition:FlxText;
	var downPozition:FlxText;
	var leftPozition:FlxText;
	var rightPozition:FlxText;
	var inputvari:PsychAlphabet;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var controlitems:Array<String> = ['Pad-Right','Pad-Left','Pad-Custom','Duo','Hitbox','Keyboard'];
	var currentlySelected:Int = 4;
	var buttonistouched:Bool = false;
	var bindbutton:FlxButton;
	var config:Config;

	override public function create():Void
	{
		super.create();
		
		config = new Config();
		currentlySelected = config.getcontrolmode();

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		var titleText:Alphabet = new Alphabet(75, 60, "Android Controls", true);
		titleText.scaleX = 0.6;
		titleText.scaleY = 0.6;
		titleText.alpha = 0.4;
		add(titleText);

		virtualPads = new FlxVirtualPad(RIGHT_FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
		virtualPads.alpha = 0;
		add(virtualPads);
        /*
		hbox = new FlxHitbox(0.75, ClientPrefs.data.antialiasing);
		hbox.visible = false;
		add(hbox);
		*/
		newhbox = new FlxNewHitbox();
		newhbox.visible = false;
		add(newhbox);

		inputvari = new PsychAlphabet(0, 50, controlitems[currentlySelected], false, false, 0.05, 0.8);
		inputvari.screenCenter(X);
		add(inputvari);

		var ui_tex = Paths.getSparrowAtlas('androidcontrols/menu/arrows');

		leftArrow = new FlxSprite(inputvari.x - 60, inputvari.y + 50);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(inputvari.x + inputvari.width + 10, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		add(rightArrow);

		upPozition = new FlxText(10, FlxG.height - 104, 0,"Button Up X:" + virtualPads.buttonUp.x +" Y:" + virtualPads.buttonUp.y, 16);
		upPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		upPozition.borderSize = 2.4;
		add(upPozition);

		downPozition = new FlxText(10, FlxG.height - 84, 0,"Button Down X:" + virtualPads.buttonDown.x +" Y:" + virtualPads.buttonDown.y, 16);
		downPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		downPozition.borderSize = 2.4;
		add(downPozition);

		leftPozition = new FlxText(10, FlxG.height - 64, 0,"Button Left X:" + virtualPads.buttonLeft.x +" Y:" + virtualPads.buttonLeft.y, 16);
		leftPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		leftPozition.borderSize = 2.4;
		add(leftPozition);

		rightPozition = new FlxText(10, FlxG.height - 44, 0,"Button RIght x:" + virtualPads.buttonRight.x +" Y:" + virtualPads.buttonRight.y, 16);
		rightPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		rightPozition.borderSize = 2.4;
		add(rightPozition);

		var tipText:FlxText = new FlxText(10, FlxG.height - 24, 0, 'Press BACK to Go Back to Options Menu', 16);
		tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipText.borderSize = 2;
		tipText.scrollFactor.set();
		add(tipText);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		leftArrow.x = inputvari.x - 60;
		rightArrow.x = inputvari.x + inputvari.width + 10;
		inputvari.screenCenter(X);
		
		for (touch in FlxG.touches.list){		
			if(touch.overlaps(leftArrow) && touch.justPressed)
			{
				changeSelection(-1);
			}
			else if (touch.overlaps(rightArrow) && touch.justPressed)
			{
				changeSelection(1);
			}
			trackbutton(touch);
		}
		
		#if android
		if (FlxG.android.justReleased.BACK)
		{
			save();
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new options.OptionsState());
		}
		#end
	}

	function changeSelection(change:Int = 0)
	{
		currentlySelected += change;
	
		if (currentlySelected < 0)
			currentlySelected = controlitems.length - 1;
		if (currentlySelected >= controlitems.length)
			currentlySelected = 0;
	
		inputvari.changeText(controlitems[currentlySelected]);

		var daChoice:String = controlitems[Math.floor(currentlySelected)];

		switch (daChoice)
		{
				case 'Pad-Right':
					remove(virtualPads);
					virtualPads = new FlxVirtualPad(RIGHT_FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
					add(virtualPads);
				case 'Pad-Left':
					remove(virtualPads);
					virtualPads = new FlxVirtualPad(FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
					add(virtualPads);
				case 'Pad-Custom':
					remove(virtualPads);
					virtualPads = new FlxVirtualPad(RIGHT_FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
					add(virtualPads);
					loadcustom();
				case 'Duo':
					remove(virtualPads);
					virtualPads = new FlxVirtualPad(DUO, NONE, 0.75, ClientPrefs.data.antialiasing);
					add(virtualPads);
				case 'Hitbox':
					virtualPads.alpha = 0;
				case 'Keyboard':
					remove(virtualPads);
					virtualPads.alpha = 0;
		}

		if (daChoice != "Hitbox")
		{
			//hbox.visible = false;
			newhbox.visible = false;
		}
		else
		{
		    //hbox.visible = true;
		    newhbox.visible = true;
		     
		}

		if (daChoice != "Pad-Custom")
		{
			upPozition.visible = false;
			downPozition.visible = false;
			leftPozition.visible = false;
			rightPozition.visible = false;
		}
		else
		{
			upPozition.visible = true;
			downPozition.visible = true;
			leftPozition.visible = true;
			rightPozition.visible = true;
		}
	}

	function trackbutton(touch:flixel.input.touch.FlxTouch){
		var daChoice:String = controlitems[Math.floor(currentlySelected)];

		if (daChoice == 'Pad-Custom'){
			if (buttonistouched){
				if (bindbutton.justReleased && touch.justReleased)
				{
					bindbutton = null;
					buttonistouched = false;
				}else 
				{
					movebutton(touch, bindbutton);
					setbuttontexts();
				}
			}
			else 
			{
				if (virtualPads.buttonUp.justPressed) {
					movebutton(touch, virtualPads.buttonUp);
				}
				
				if (virtualPads.buttonDown.justPressed) {
					movebutton(touch, virtualPads.buttonDown);
				}

				if (virtualPads.buttonRight.justPressed) {
					movebutton(touch, virtualPads.buttonRight);
				}

				if (virtualPads.buttonLeft.justPressed) {
					movebutton(touch, virtualPads.buttonLeft);
				}
			}
		}
	}

	function movebutton(touch:flixel.input.touch.FlxTouch, button:android.flixel.FlxButton) {
		button.x = touch.x - virtualPads.buttonUp.width / 2;
		button.y = touch.y - virtualPads.buttonUp.height / 2;
		bindbutton = button;
		buttonistouched = true;
	}

	function setbuttontexts() {
		upPozition.text = "Button Up X:" + virtualPads.buttonUp.x +" Y:" + virtualPads.buttonUp.y;
		downPozition.text = "Button Down X:" + virtualPads.buttonDown.x +" Y:" + virtualPads.buttonDown.y;
		leftPozition.text = "Button Left X:" + virtualPads.buttonLeft.x +" Y:" + virtualPads.buttonLeft.y;
		rightPozition.text = "Button RIght x:" + virtualPads.buttonRight.x +" Y:" + virtualPads.buttonRight.y;
	}

	function save() {
		config.setcontrolmode(currentlySelected);
		var daChoice:String = controlitems[Math.floor(currentlySelected)];

		if (daChoice == 'Pad-Custom'){
			config.savecustom(virtualPads);
		}
	}

	function loadcustom():Void{
		virtualPads = config.loadcustom(virtualPads);	
	}
}
