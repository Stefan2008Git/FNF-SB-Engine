package options.android;

import android.flixel.FlxButton;
import android.flixel.FlxHitbox;
import android.flixel.FlxNewHitbox;
import android.AndroidControls.Config;
import android.flixel.FlxVirtualPad;
import android.flixel.FlxButton as UIButton;
import android.objects.PsychAlphabet;


class AndroidControlsMenuState extends MusicBeatState
{
	var uiCamera:FlxCamera;
	var background:FlxSprite;
	var checkerboard:FlxBackdrop;
	var virtualPadHandler:FlxVirtualPad;
	var hitbox:FlxNewHitbox;
	var upPosition:FlxText;
	var downPosition:FlxText;
	var leftPosition:FlxText;
	var rightPosition:FlxText;
	var controlVarName:PsychAlphabet;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var exit:UIButton;
	var reset:UIButton;
	var tweenieShit:Float = 0;
	var keyboardText:FlxText;
	var controlItemName:Array<String> = ['Pad-Right', 'Pad-Left', 'Pad-Custom', 'Duo', 'Hitbox', 'Keyboard'];
	var currentlySelected:Int = 4;
	var buttonIsTouched:Bool = false;
	var bindTheButton:FlxButton;
	var config:Config;

	override public function create():Void
	{
		super.create();
		
		config = new Config();
		currentlySelected = config.getControlMode();

		uiCamera = new FlxCamera();
		uiCamera.bgColor.alpha = 0;
		// uiCamera.alpha = 0;
		FlxG.cameras.add(uiCamera, false);

		background = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
		switch (ClientPrefs.data.themes) {
			case 'SB Engine':
				background.color = FlxColor.BROWN;
			
			case 'Psych Engine':
				background.color = 0xFFea71fd;
		}
		background.screenCenter();
		background.antialiasing = ClientPrefs.data.antialiasing;
		background.cameras = [uiCamera];
		add(background);

		checkerboard = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		checkerboard.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		checkerboard.visible = ClientPrefs.data.checkerboard;
		checkerboard.cameras = [uiCamera];
		add(checkerboard);

		virtualPadHandler = new FlxVirtualPad(RIGHT_FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
		virtualPadHandler.cameras = [uiCamera];
		add(virtualPadHandler);
        
		hitbox = new FlxNewHitbox();
		hitbox.visible = false;
		hitbox.cameras = [uiCamera];
		add(hitbox);

		var titleText:Alphabet = new Alphabet(25, 25, "Android Controls", true);
		titleText.scaleX = 0.6;
		titleText.scaleY = 0.6;
		titleText.alpha = 0.4;
		titleText.cameras = [uiCamera];
		add(titleText);

		controlVarName = new PsychAlphabet(0, 50, controlItemName[currentlySelected], false, false, 0.05, 0.8);
		controlVarName.screenCenter(X);
		controlVarName.cameras = [uiCamera];
		add(controlVarName);

		var ui_tex = Paths.getSparrowAtlas('android/menu/arrows');

		leftArrow = new FlxSprite(controlVarName.x - 60, controlVarName.y + 50);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.cameras = [uiCamera];
		add(leftArrow);

		rightArrow = new FlxSprite(controlVarName.x + controlVarName.width + 10, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.cameras = [uiCamera];
		add(rightArrow);

		upPosition = new FlxText(10, FlxG.height - 104, 0,"Button Up X:" + virtualPadHandler.buttonUp.x +" Y:" + virtualPadHandler.buttonUp.y, 16);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': upPosition.setFormat(Paths.font("bahnschrift.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': upPosition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'TGT Engine': upPosition.setFormat(Paths.font("calibri.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Dave and Bambi': upPosition.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		upPosition.borderSize = 2.4;
		upPosition.cameras = [uiCamera];
		add(upPosition);

		downPosition = new FlxText(10, FlxG.height - 84, 0,"Button Down X:" + virtualPadHandler.buttonDown.x +" Y:" + virtualPadHandler.buttonDown.y, 16);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': downPosition.setFormat(Paths.font("bahnschrift.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': downPosition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'TGT Engine': downPosition.setFormat(Paths.font("calibri.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Dave and Bambi': downPosition.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		downPosition.borderSize = 2.4;
		downPosition.cameras = [uiCamera];
		add(downPosition);

		leftPosition = new FlxText(10, FlxG.height - 64, 0,"Button Left X:" + virtualPadHandler.buttonLeft.x +" Y:" + virtualPadHandler.buttonLeft.y, 16);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': leftPosition.setFormat(Paths.font("bahnschrift.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': leftPosition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'TGT Engine': leftPosition.setFormat(Paths.font("calibri.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Dave and Bambi': leftPosition.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		leftPosition.borderSize = 2.4;
		leftPosition.cameras = [uiCamera];
		add(leftPosition);

		rightPosition = new FlxText(10, FlxG.height - 44, 0,"Button Right x:" + virtualPadHandler.buttonRight.x +" Y:" + virtualPadHandler.buttonRight.y, 16);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': rightPosition.setFormat(Paths.font("bahnschrift.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': rightPosition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'TGT Engine': rightPosition.setFormat(Paths.font("calibri.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Dave and Bambi': rightPosition.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		rightPosition.borderSize = 2.4;
		rightPosition.cameras = [uiCamera];
		add(rightPosition);

		var tipText:FlxText = new FlxText(10, FlxG.height - 24, 0, 'Press on lime button to save data and go back to options menu!', 16);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': tipText.setFormat(Paths.font("bahnschrift.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'TGT Engine': tipText.setFormat(Paths.font("calibri.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Dave and Bambi': tipText.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		tipText.borderSize = 2;
		tipText.scrollFactor.set();
		tipText.cameras = [uiCamera];
		add(tipText);

		keyboardText = new FlxText(0, 0, FlxG.width, "-- There is no avaiable any Android controls on keyboard options for Android build.\nOnly the PC support can access to keyboard! --", 14);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': keyboardText.setFormat(Paths.font("bahnschrift.ttf"), 36, FlxColor.WHITE, FlxTextAlign.CENTER);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': keyboardText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, FlxTextAlign.CENTER);
			case 'TGT Engine': keyboardText.setFormat(Paths.font("calibri.ttf"), 36, FlxColor.WHITE, FlxTextAlign.CENTER);
			case 'Dave and Bambi': keyboardText.setFormat(Paths.font("comic.ttf"), 36, FlxColor.WHITE, FlxTextAlign.CENTER);
		}
		keyboardText.screenCenter();
		keyboardText.visible = false;
		keyboardText.cameras = [uiCamera];
		add(keyboardText);

		exit = new UIButton(0, controlVarName.y - 25, "Exit & Save", () ->
		{
			saveTheData();
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(() -> new options.OptionsState());
		});
		exit.color = FlxColor.LIME;
		exit.setGraphicSize(Std.int(exit.width) * 3);
		exit.updateHitbox();
		exit.x = FlxG.width - exit.width - 70;
		exit.label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': exit.label.setFormat(Paths.font('bahnschrift.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': exit.label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			case 'TGT Engine': exit.label.setFormat(Paths.font('calibri.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			case 'Dave and Bambi': exit.label.setFormat(Paths.font('comic.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		}
		exit.label.fieldWidth = exit.width;
		exit.label.x = ((exit.width - exit.label.width) / 2) + exit.x;
		exit.label.offset.y = -10; // WHY THE FUCK I CAN'T CHANGE THE LABEL Y
		exit.cameras = [uiCamera];
		add(exit);

		reset = new UIButton(exit.x, exit.height + exit.y + 20, "Reset", () ->
		{
			changeSelection(0); // realods the current control mode ig?
		});
		reset.color = FlxColor.RED;
		reset.setGraphicSize(Std.int(reset.width) * 3);
		reset.updateHitbox();
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': reset.label.setFormat(Paths.font('bahnschrift.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			case 'Psych Engine' | 'Kade Engine' | 'Cheeky': reset.label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			case 'TGT Engine': reset.label.setFormat(Paths.font('calibri.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			case 'Dave and Bambi': reset.label.setFormat(Paths.font('comic.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		}
		reset.label.fieldWidth = reset.width;
		reset.label.x = ((reset.width - reset.label.width) / 2) + reset.x;
		reset.label.offset.y = -10;
		reset.cameras = [uiCamera];
		add(reset);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		leftArrow.x = controlVarName.x - 60;
		rightArrow.x = controlVarName.x + controlVarName.width + 10;
		controlVarName.screenCenter(X);
		
		for (touch in FlxG.touches.list) {		
			if (touch.overlaps(leftArrow) && touch.justPressed)
			{
				changeSelection(-1);
			}
			else if (touch.overlaps(rightArrow) && touch.justPressed)
			{
				changeSelection(1);
			}
			trackTheButton(touch);
		}

		tweenieShit += 180 * elapsed;
		keyboardText.alpha = 1 - Math.sin((Math.PI * tweenieShit) / 180);
	}

	function changeSelection(change:Int = 0)
	{
		currentlySelected += change;
	
		if (currentlySelected < 0)
			currentlySelected = controlItemName.length - 1;
		if (currentlySelected >= controlItemName.length)
			currentlySelected = 0;
	
		controlVarName.changeText(controlItemName[currentlySelected]);

		var daChoice:String = controlItemName[Math.floor(currentlySelected)];

		switch (daChoice)
		{
				case 'Pad-Right':
					remove(virtualPadHandler);
					virtualPadHandler = new FlxVirtualPad(RIGHT_FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
					keyboardText.visible = false;
					reset.visible = false;
					add(virtualPadHandler);
				case 'Pad-Left':
					remove(virtualPadHandler);
					virtualPadHandler = new FlxVirtualPad(FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
					keyboardText.visible = false;
					reset.visible = false;
					add(virtualPadHandler);
				case 'Pad-Custom':
					remove(virtualPadHandler);
					virtualPadHandler = new FlxVirtualPad(RIGHT_FULL, NONE, 0.75, ClientPrefs.data.antialiasing);
					keyboardText.visible = false;
					reset.visible = true;
					add(virtualPadHandler);
					loadcustom();
				case 'Duo':
					remove(virtualPadHandler);
					virtualPadHandler = new FlxVirtualPad(DUO, NONE, 0.75, ClientPrefs.data.antialiasing);
					keyboardText.visible = false;
					reset.visible = false;
					add(virtualPadHandler);
				case 'Hitbox':
					virtualPadHandler.alpha = 0;
					keyboardText.visible = false;
					reset.visible = false;
				case 'Keyboard':
					remove(virtualPadHandler);
					keyboardText.visible = true;
					reset.visible = false;
					virtualPadHandler.alpha = 0;
		}

		if (daChoice != "Hitbox")
		{
			hitbox.visible = false;
		}
		else
		{
		    hitbox.visible = true;
		}

		if (daChoice != "Pad-Custom")
		{
			upPosition.visible = false;
			downPosition.visible = false;
			leftPosition.visible = false;
			rightPosition.visible = false;
			reset.visible = false;
		}
		else
		{
			upPosition.visible = true;
			downPosition.visible = true;
			leftPosition.visible = true;
			rightPosition.visible = true;
			reset.visible = true;
		}
	}

	function trackTheButton(touch:flixel.input.touch.FlxTouch){
		var daChoice:String = controlItemName[Math.floor(currentlySelected)];

		if (daChoice == 'Pad-Custom'){
			if (buttonIsTouched){
				if (bindTheButton.justReleased && touch.justReleased)
				{
					bindTheButton = null;
					buttonIsTouched = false;
				}else 
				{
					moveTheButton(touch, bindTheButton);
					updateTheButtonPositionText();
				}
			}
			else 
			{
				if (virtualPadHandler.buttonUp.justPressed) {
					moveTheButton(touch, virtualPadHandler.buttonUp);
				}
				
				if (virtualPadHandler.buttonDown.justPressed) {
					moveTheButton(touch, virtualPadHandler.buttonDown);
				}

				if (virtualPadHandler.buttonRight.justPressed) {
					moveTheButton(touch, virtualPadHandler.buttonRight);
				}

				if (virtualPadHandler.buttonLeft.justPressed) {
					moveTheButton(touch, virtualPadHandler.buttonLeft);
				}
			}
		}
	}

	function moveTheButton(touch:flixel.input.touch.FlxTouch, button:android.flixel.FlxButton) {
		button.x = touch.x - virtualPadHandler.buttonUp.width / 2;
		button.y = touch.y - virtualPadHandler.buttonUp.height / 2;
		bindTheButton = button;
		buttonIsTouched = true;
	}

	function updateTheButtonPositionText() {
		upPosition.text = "Button Up X:" + virtualPadHandler.buttonUp.x +" Y:" + virtualPadHandler.buttonUp.y;
		downPosition.text = "Button Down X:" + virtualPadHandler.buttonDown.x +" Y:" + virtualPadHandler.buttonDown.y;
		leftPosition.text = "Button Left X:" + virtualPadHandler.buttonLeft.x +" Y:" + virtualPadHandler.buttonLeft.y;
		rightPosition.text = "Button RIght x:" + virtualPadHandler.buttonRight.x +" Y:" + virtualPadHandler.buttonRight.y;
	}

	function saveTheData() {
		config.setcontrolmode(currentlySelected);
		var daChoice:String = controlItemName[Math.floor(currentlySelected)];

		if (daChoice == 'Pad-Custom'){
			config.savecustom(virtualPadHandler);
		}
	}

	function loadcustom():Void{
		virtualPadHandler = config.loadcustom(virtualPadHandler);	
	}
}
