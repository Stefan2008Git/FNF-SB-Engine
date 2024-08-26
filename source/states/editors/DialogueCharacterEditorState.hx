package states.editors;

import flixel.ui.FlxButton;
import tjson.TJSON as Json;

class DialogueCharacterEditorState extends MusicBeatState
{
	var box:FlxSprite;
	var daText:TypedAlphabet = null;

	private static var TIP_TEXT_MAIN:String =
	'JKLI - Move camera (Hold Shift to move 4x faster)
	\nQ/E - Zoom out/in
	\nR - Reset Camera
	\nH - Toggle Speech Bubble
	\nSpace - Reset text';

	private static var TIP_TEXT_OFFSET:String =
	'JKLI - Move camera (Hold Shift to move 4x faster)
	\nQ/E - Zoom out/in
	\nR - Reset Camera
	\nH - Toggle Ghosts
	\nWASD - Move Looping animation offset (Red)
	\nArrow Keys - Move Idle/Finished animation offset (Blue)
	\nHold Shift to move offsets 10x faster';

	var tipText:FlxText;
	var offsetLoopText:FlxText;
	var offsetIdleText:FlxText;
	var animText:FlxText;

	var camGame:FlxCamera;
	var camHUD:FlxCamera;

	var mainGroup:FlxSpriteGroup;
	var hudGroup:FlxSpriteGroup;

	var character:DialogueCharacter;
	var ghostLoop:DialogueCharacter;
	var ghostIdle:DialogueCharacter;

	var curAnim:Int = 0;

	override function create() {
		persistentUpdate = persistentDraw = true;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camGame.bgColor = FlxColor.fromHSL(0, 0, 0.5);
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		
		#if android 
    	TIP_TEXT_MAIN = 
        'UP,Down,Left,Right(DOWN side) - Move camera (Hold B to move 4x faster)
    	\nX/C - Zoom out/in
    	\nZ - Reset Camera
    	\nY - Toggle Speech Bubble
    	\nA - Reset text';
    	
    	TIP_TEXT_OFFSET = 
    	'UP,Down,Left,Right(DOWN side)- Move camera (Hold B to move 4x faster)
    	\nX/C - Zoom out/in
    	\nZ - Reset Camera
       	\nY - Toggle Ghosts
    	\nUP,Down,Left,Right(UP side) - Move Looping animation offset (Red)
    	\nUP,Down,Left,Right(UP side) + press A once (twice to close)- Move Idle/Finished animation offset (Blue)
    	\nHold B to move offsets 10x faster';
    	#end

		FlxG.sound.playMusic(Paths.music('offsetSong'), 1, true);
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Mod Editors menu (Dialogue portrait)";
		
		mainGroup = new FlxSpriteGroup();
		mainGroup.cameras = [camGame];
		hudGroup = new FlxSpriteGroup();
		hudGroup.cameras = [camGame];
		add(mainGroup);
		add(hudGroup);

		character = new DialogueCharacter();
		character.scrollFactor.set();
		mainGroup.add(character);
		
		ghostLoop = new DialogueCharacter();
		ghostLoop.alpha = 0;
		ghostLoop.color = FlxColor.RED;
		ghostLoop.isGhost = true;
		ghostLoop.jsonFile = character.jsonFile;
		ghostLoop.cameras = [camGame];
		add(ghostLoop);
		
		ghostIdle = new DialogueCharacter();
		ghostIdle.alpha = 0;
		ghostIdle.color = FlxColor.BLUE;
		ghostIdle.isGhost = true;
		ghostIdle.jsonFile = character.jsonFile;
		ghostIdle.cameras = [camGame];
		add(ghostIdle);

		box = new FlxSprite(70, 370);
		box.antialiasing = ClientPrefs.data.antialiasing;
		box.frames = Paths.getSparrowAtlas('speech_bubble');
		box.scrollFactor.set();
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.animation.addByPrefix('center', 'speech bubble middle', 24);
		box.animation.play('normal', true);
		box.setGraphicSize(Std.int(box.width * 0.9));
		box.updateHitbox();
		hudGroup.add(box);

		tipText = new FlxText(10, 10, FlxG.width - 20, TIP_TEXT_MAIN, 8);
		tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipText.cameras = [camHUD];
		tipText.scrollFactor.set();
		add(tipText);

		offsetLoopText = new FlxText(10, 10, 0, '', 32);
		offsetLoopText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		offsetLoopText.cameras = [camHUD];
		offsetLoopText.scrollFactor.set();
		add(offsetLoopText);
		offsetLoopText.visible = false;

		offsetIdleText = new FlxText(10, 46, 0, '', 32);
		offsetIdleText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		offsetIdleText.cameras = [camHUD];
		offsetIdleText.scrollFactor.set();
		add(offsetIdleText);
		offsetIdleText.visible = false;

		animText = new FlxText(10, 22, FlxG.width - 20, '', 8);
		animText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		animText.scrollFactor.set();
		animText.cameras = [camHUD];
		add(animText);

		reloadCharacter();
		updateTextBox();

		daText = new TypedAlphabet(DialogueBoxPsych.DEFAULT_TEXT_X, DialogueBoxPsych.DEFAULT_TEXT_Y, '', 0.05, false);
		daText.setScale(0.7);
		daText.text = DEFAULT_TEXT;
		hudGroup.add(daText);

		addEditorBox();
		FlxG.mouse.visible = true;
		updateCharTypeBox();
		
		#if android
		addVirtualPad(DIALOGUECHARACTER, DIALOGUECHARACTER);
		addPadCamera();
		#end
		
		super.create();
	}

	var UI_typebox:FlxUITabMenu;
	var UI_mainbox:FlxUITabMenu;
	function addEditorBox() {
		var tabs = [
			{name: 'Character Type', label: 'Character Type'},
		];
		UI_typebox = new FlxUITabMenu(null, tabs, true);
		UI_typebox.resize(120, 180);
		UI_typebox.x = 900;
		UI_typebox.y = FlxG.height - UI_typebox.height - 50;
		UI_typebox.scrollFactor.set();
		UI_typebox.camera = camHUD;
		addTypeUI();
		add(UI_typebox);

		var tabs = [
			{name: 'Animations', label: 'Animations'},
			{name: 'Character', label: 'Character'},
		];
		UI_mainbox = new FlxUITabMenu(null, tabs, true);
		UI_mainbox.resize(200, 250);
		UI_mainbox.x = UI_typebox.x + UI_typebox.width;
		UI_mainbox.y = FlxG.height - UI_mainbox.height - 50;
		UI_mainbox.scrollFactor.set();
		UI_mainbox.camera = camHUD;
		addAnimationsUI();
		addCharacterUI();
		add(UI_mainbox);
		UI_mainbox.selected_tab_id = 'Character';
		lastTab = UI_mainbox.selected_tab_id;
	}

	var leftCheckbox:FlxUICheckBox;
	var centerCheckbox:FlxUICheckBox;
	var rightCheckbox:FlxUICheckBox;
	function addTypeUI() {
		var tab_group = new FlxUI(null, UI_typebox);
		tab_group.name = "Character Type";

		leftCheckbox = new FlxUICheckBox(10, 20, null, null, "Left", 100);
		leftCheckbox.callback = function()
		{
			character.jsonFile.dialogue_pos = 'left';
			updateCharTypeBox();
		};

		centerCheckbox = new FlxUICheckBox(leftCheckbox.x, leftCheckbox.y + 40, null, null, "Center", 100);
		centerCheckbox.callback = function()
		{
			character.jsonFile.dialogue_pos = 'center';
			updateCharTypeBox();
		};

		rightCheckbox = new FlxUICheckBox(centerCheckbox.x, centerCheckbox.y + 40, null, null, "Right", 100);
		rightCheckbox.callback = function()
		{
			character.jsonFile.dialogue_pos = 'right';
			updateCharTypeBox();
		};

		tab_group.add(leftCheckbox);
		tab_group.add(centerCheckbox);
		tab_group.add(rightCheckbox);
		UI_typebox.addGroup(tab_group);
	}

	var currentlySelectedAnim:String;
	var animationArray:Array<String> = [];
	var animationDropDown:FlxUIDropDownMenu;
	var animationInputText:FlxUIInputText;
	var loopInputText:FlxUIInputText;
	var idleInputText:FlxUIInputText;
	function addAnimationsUI() {
		var tab_group = new FlxUI(null, UI_mainbox);
		tab_group.name = "Animations";

		animationDropDown = new FlxUIDropDownMenu(10, 30, FlxUIDropDownMenu.makeStrIdLabelArray([''], true), function(animation:String) {
			var anim:String = animationArray[Std.parseInt(animation)];
			if(character.dialogueAnimations.exists(anim)) {
				ghostLoop.playAnim(anim);
				ghostIdle.playAnim(anim, true);

				currentlySelectedAnim = anim;
				var animShit:DialogueAnimArray = character.dialogueAnimations.get(currentlySelectedAnim);
				offsetLoopText.text = 'Loop: ' + animShit.loop_offsets;
				offsetIdleText.text = 'Idle: ' + animShit.idle_offsets;

				animationInputText.text = animShit.anim;
				loopInputText.text = animShit.loop_name;
				idleInputText.text = animShit.idle_name;
			}
		});
		
		animationInputText = new FlxUIInputText(15, 85, 80, '', 8);
		animationInputText.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
		blockPressWhileTypingOn.push(animationInputText);
		loopInputText = new FlxUIInputText(animationInputText.x, animationInputText.y + 35, 150, '', 8);
		loopInputText.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
		blockPressWhileTypingOn.push(loopInputText);
		idleInputText = new FlxUIInputText(loopInputText.x, loopInputText.y + 40, 150, '', 8);
		idleInputText.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
		blockPressWhileTypingOn.push(idleInputText);
		
		var addUpdateButton:FlxButton = new FlxButton(10, idleInputText.y + 30, "Add/Update", function() {
			var theAnim:String = animationInputText.text.trim();
			if(character.dialogueAnimations.exists(theAnim)) //Update
			{
				for (i in 0...character.jsonFile.animations.length) {
					var animArray:DialogueAnimArray = character.jsonFile.animations[i];
					if(animArray.anim.trim() == theAnim) {
						animArray.loop_name = loopInputText.text;
						animArray.idle_name = idleInputText.text;
						break;
					}
				}

				character.reloadAnimations();
				ghostLoop.reloadAnimations();
				ghostIdle.reloadAnimations();
				if(currentlySelectedAnim == theAnim) {
					ghostLoop.playAnim(theAnim);
					ghostIdle.playAnim(theAnim, true);
				}
			}
			else //Add
			{
				var newAnim:DialogueAnimArray = {
					anim: theAnim,
					loop_name: loopInputText.text,
					loop_offsets: [0, 0],
					idle_name: idleInputText.text,
					idle_offsets: [0, 0]
				}
				character.jsonFile.animations.push(newAnim);

				var lastSelected:String = animationDropDown.selectedLabel;
				character.reloadAnimations();
				ghostLoop.reloadAnimations();
				ghostIdle.reloadAnimations();
				reloadAnimationsDropDown();
				animationDropDown.selectedLabel = lastSelected;
			}
		});
		
		var removeUpdateButton:FlxButton = new FlxButton(100, addUpdateButton.y, "Remove", function() {
			for (i in 0...character.jsonFile.animations.length) {
				var animArray:DialogueAnimArray = character.jsonFile.animations[i];
				if(animArray != null && animArray.anim.trim() == animationInputText.text.trim()) {
					var lastSelected:String = animationDropDown.selectedLabel;
					character.jsonFile.animations.remove(animArray);
					character.reloadAnimations();
					ghostLoop.reloadAnimations();
					ghostIdle.reloadAnimations();
					reloadAnimationsDropDown();
					if(character.jsonFile.animations.length > 0 && lastSelected == animArray.anim.trim()) {
						var animToPlay:String = character.jsonFile.animations[0].anim;
						ghostLoop.playAnim(animToPlay);
						ghostIdle.playAnim(animToPlay, true);
					}
					animationDropDown.selectedLabel = lastSelected;
					animationInputText.text = '';
					loopInputText.text = '';
					idleInputText.text = '';
					break;
				}
			}
		});
		
		tab_group.add(new FlxText(animationDropDown.x, animationDropDown.y - 18, 0, 'Animations:'));
		tab_group.add(new FlxText(animationInputText.x, animationInputText.y - 18, 0, 'Animation name:'));
		tab_group.add(new FlxText(loopInputText.x, loopInputText.y - 18, 0, 'Loop name on .XML file:'));
		tab_group.add(new FlxText(idleInputText.x, idleInputText.y - 18, 0, 'Idle/Finished name on .XML file:'));
		tab_group.add(animationInputText);
		tab_group.add(loopInputText);
		tab_group.add(idleInputText);
		tab_group.add(addUpdateButton);
		tab_group.add(removeUpdateButton);
		tab_group.add(animationDropDown);
		UI_mainbox.addGroup(tab_group);
		reloadAnimationsDropDown();
	}

	function reloadAnimationsDropDown() {
		animationArray = [];
		for (anim in character.jsonFile.animations) {
			animationArray.push(anim.anim);
		}

		if(animationArray.length < 1) animationArray = [''];
		animationDropDown.setData(FlxUIDropDownMenu.makeStrIdLabelArray(animationArray, true));
	}

	var imageInputText:FlxUIInputText;
	var scaleStepper:FlxUINumericStepper;
	var xStepper:FlxUINumericStepper;
	var yStepper:FlxUINumericStepper;
	var blockPressWhileTypingOn:Array<FlxUIInputText> = [];
	function addCharacterUI() {
		var tab_group = new FlxUI(null, UI_mainbox);
		tab_group.name = "Character";

		imageInputText = new FlxUIInputText(10, 30, 80, character.jsonFile.image, 8);
		imageInputText.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
		blockPressWhileTypingOn.push(imageInputText);
		xStepper = new FlxUINumericStepper(imageInputText.x, imageInputText.y + 50, 10, character.jsonFile.position[0], -2000, 2000, 0);
		yStepper = new FlxUINumericStepper(imageInputText.x + 80, xStepper.y, 10, character.jsonFile.position[1], -2000, 2000, 0);
		scaleStepper = new FlxUINumericStepper(imageInputText.x, xStepper.y + 50, 0.05, character.jsonFile.scale, 0.1, 10, 2);

		var noAntialiasingCheckbox:FlxUICheckBox = new FlxUICheckBox(scaleStepper.x + 80, scaleStepper.y, null, null, "No Antialiasing", 100);
		noAntialiasingCheckbox.checked = (character.jsonFile.no_antialiasing == true);
		noAntialiasingCheckbox.callback = function()
		{
			character.jsonFile.no_antialiasing = noAntialiasingCheckbox.checked;
			character.antialiasing = !character.jsonFile.no_antialiasing;
		};
		
		tab_group.add(new FlxText(10, imageInputText.y - 18, 0, 'Image file name:'));
		tab_group.add(new FlxText(10, xStepper.y - 18, 0, 'Position Offset:'));
		tab_group.add(new FlxText(10, scaleStepper.y - 18, 0, 'Scale:'));
		tab_group.add(imageInputText);
		tab_group.add(xStepper);
		tab_group.add(yStepper);
		tab_group.add(scaleStepper);
		tab_group.add(noAntialiasingCheckbox);

		var reloadImageButton:FlxButton = new FlxButton(10, scaleStepper.y + 60, "Reload Image", function() {
			reloadCharacter();
		});
		
		var loadButton:FlxButton = new FlxButton(reloadImageButton.x + 100, reloadImageButton.y, "Load Character", function() {
			loadCharacter();
		});
		var saveButton:FlxButton = new FlxButton(loadButton.x, reloadImageButton.y - 25, "Save Character", function() {
			saveCharacter();
		});
		tab_group.add(reloadImageButton);
		tab_group.add(loadButton);
		tab_group.add(saveButton);
		UI_mainbox.addGroup(tab_group);
	}
	
	function updateCharTypeBox() {
		leftCheckbox.checked = false;
		centerCheckbox.checked = false;
		rightCheckbox.checked = false;

		switch(character.jsonFile.dialogue_pos) {
			case 'left':
				leftCheckbox.checked = true;
			case 'center':
				centerCheckbox.checked = true;
			case 'right':
				rightCheckbox.checked = true;
		}
		reloadCharacter();
		updateTextBox();
	}

	private static var DEFAULT_TEXT:String = 'Ovo je decko sa igre...';

	function reloadCharacter() {
		var charsArray:Array<DialogueCharacter> = [character, ghostLoop, ghostIdle];
		for (char in charsArray) {
			char.frames = Paths.getSparrowAtlas('dialogue/' + character.jsonFile.image);
			char.jsonFile = character.jsonFile;
			char.reloadAnimations();
			char.setGraphicSize(Std.int(char.width * DialogueCharacter.DEFAULT_SCALE * character.jsonFile.scale));
			char.updateHitbox();
		}
		character.x = DialogueBoxPsych.LEFT_CHAR_X;
		character.y = DialogueBoxPsych.DEFAULT_CHAR_Y;

		switch(character.jsonFile.dialogue_pos) {
			case 'right':
				character.x = FlxG.width - character.width + DialogueBoxPsych.RIGHT_CHAR_X;
			
			case 'center':
				character.x = FlxG.width / 2;
				character.x -= character.width / 2;
		}
		character.x += character.jsonFile.position[0] + mainGroup.x;
		character.y += character.jsonFile.position[1] + mainGroup.y;
		character.playAnim(character.jsonFile.animations[0].anim);
		if(character.jsonFile.animations.length > 0) {
			currentlySelectedAnim = character.jsonFile.animations[0].anim;
			var animShit:DialogueAnimArray = character.dialogueAnimations.get(currentlySelectedAnim);
			ghostLoop.playAnim(animShit.anim);
			ghostIdle.playAnim(animShit.anim, true);
			offsetLoopText.text = 'Loop: ' + animShit.loop_offsets;
			offsetIdleText.text = 'Idle: ' + animShit.idle_offsets;
		}

		curAnim = 0;
		animText.text = 'Animation: ' + character.jsonFile.animations[curAnim].anim + ' (' + (curAnim + 1) +' / ' + character.jsonFile.animations.length + ') - Press W or S to scroll';

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Dialogue Character Editor", "Editting: " + character.jsonFile.image);
		#end
	}

	function updateTextBox() {
		box.flipX = false;
		var anim:String = 'normal';
		switch(character.jsonFile.dialogue_pos) {
			case 'left':
				box.flipX = true;
			case 'center':
				anim = 'center';
		}
		box.animation.play(anim, true);
		DialogueBoxPsych.updateBoxOffsets(box);
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if(id == FlxUIInputText.CHANGE_EVENT && sender == imageInputText) {
			character.jsonFile.image = imageInputText.text;
		} else if(id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)) {
			if(sender == scaleStepper) {
				character.jsonFile.scale = scaleStepper.value;
				reloadCharacter();
			} else if(sender == xStepper) {
				character.jsonFile.position[0] = xStepper.value;
				reloadCharacter();
			} else if(sender == yStepper) {
				character.jsonFile.position[1] = yStepper.value;
				reloadCharacter();
			}
		}
	}

	var currentGhosts:Int = 0;
	var lastTab:String = 'Character';
	var transitioning:Bool = false;
	var CheckPress:Bool = false;
	override function update(elapsed:Float) {
		MusicBeatState.camBeat = FlxG.camera;
		if(transitioning) {
			super.update(elapsed);
			return;
		}

		if(character.animation.curAnim != null) {
			if(daText.finishedText) {
				if(character.animationIsLoop()) {
					character.playAnim(character.animation.curAnim.name, true);
				}
			} else if(character.animation.curAnim.finished) {
				character.animation.curAnim.restart();
			}
		}

		var blockInput:Bool = false;
		for (inputText in blockPressWhileTypingOn) {
			if(inputText.hasFocus) {
				ClientPrefs.toggleVolumeKeys(false);
				blockInput = true;

				if(FlxG.keys.justPressed.ENTER) inputText.hasFocus = false;
				break;
			}
		}
		#if android
		if(UI_mainbox.selected_tab_id == 'Animations' && MusicBeatState.virtualPad.buttonA.justPressed)
		if (!CheckPress)CheckPress = true;
		else CheckPress = false;
        #end
        
		if(!blockInput && !animationDropDown.dropPanel.visible) {
			ClientPrefs.toggleVolumeKeys(true);
			if(FlxG.keys.justPressed.SPACE #if android || MusicBeatState.virtualPad.buttonA.justPressed #end && UI_mainbox.selected_tab_id == 'Character') {
				character.playAnim(character.jsonFile.animations[curAnim].anim);
				daText.resetDialogue();
				updateTextBox();
			}

			//lots of Ifs lol get trolled
			var offsetAdd:Int = 1;
			var speed:Float = 300;
			if(FlxG.keys.pressed.SHIFT #if android || MusicBeatState.virtualPad.buttonB.pressed #end) {
				speed = 1200;
				offsetAdd = 10;
			}

			var negaMult:Array<Int> = [1, 1, -1, -1];
			var controlArray:Array<Bool> = [FlxG.keys.pressed.J  #if android || MusicBeatState.virtualPad.buttonLeft2.pressed #end, FlxG.keys.pressed.I #if android || MusicBeatState.virtualPad.buttonUp2.pressed #end, FlxG.keys.pressed.L #if android || MusicBeatState.virtualPad.buttonRight2.pressed #end, FlxG.keys.pressed.K #if android || MusicBeatState.virtualPad.buttonDown2.pressed #end];
			for (i in 0...controlArray.length) {
				if(controlArray[i]) {
					if(i % 2 == 1) {
						mainGroup.y += speed * elapsed * negaMult[i];
					} else {
						mainGroup.x += speed * elapsed * negaMult[i];
					}
				}
			}

			if(UI_mainbox.selected_tab_id == 'Animations' && currentlySelectedAnim != null && character.dialogueAnimations.exists(currentlySelectedAnim)) {
				var moved:Bool = false;
				var animShit:DialogueAnimArray = character.dialogueAnimations.get(currentlySelectedAnim);
				var controlArrayLoop:Array<Bool> = [FlxG.keys.justPressed.A #if android || MusicBeatState.virtualPad.buttonLeft.justPressed && !CheckPress #end, FlxG.keys.justPressed.W #if android || MusicBeatState.virtualPad.buttonUp.justPressed && !CheckPress #end, FlxG.keys.justPressed.D #if android || MusicBeatState.virtualPad.buttonRight.justPressed && !CheckPress #end, FlxG.keys.justPressed.S #if android || MusicBeatState.virtualPad.buttonDown.justPressed && !CheckPress #end];
				var controlArrayIdle:Array<Bool> = [FlxG.keys.justPressed.LEFT #if android || MusicBeatState.virtualPad.buttonLeft.justPressed && CheckPress #end, FlxG.keys.justPressed.UP #if android || MusicBeatState.virtualPad.buttonUp.justPressed && CheckPress #end, FlxG.keys.justPressed.RIGHT #if android || MusicBeatState.virtualPad.buttonRight.justPressed && CheckPress #end, FlxG.keys.justPressed.DOWN #if android || MusicBeatState.virtualPad.buttonDown.justPressed && CheckPress #end];
				for (i in 0...controlArrayLoop.length) {
					if(controlArrayLoop[i]) {
						if(i % 2 == 1) {
							animShit.loop_offsets[1] += offsetAdd * negaMult[i];
						} else {
							animShit.loop_offsets[0] += offsetAdd * negaMult[i];
						}
						moved = true;
					}
				}
				for (i in 0...controlArrayIdle.length) {
					if(controlArrayIdle[i]) {
						if(i % 2 == 1) {
							animShit.idle_offsets[1] += offsetAdd * negaMult[i];
						} else {
							animShit.idle_offsets[0] += offsetAdd * negaMult[i];
						}
						moved = true;
					}
				}

				if(moved) {
					offsetLoopText.text = 'Loop: ' + animShit.loop_offsets;
					offsetIdleText.text = 'Idle: ' + animShit.idle_offsets;
					ghostLoop.offset.set(animShit.loop_offsets[0], animShit.loop_offsets[1]);
					ghostIdle.offset.set(animShit.idle_offsets[0], animShit.idle_offsets[1]);
				}
			}

			if (FlxG.keys.pressed.Q  #if android || MusicBeatState.virtualPad.buttonX.pressed #end && camGame.zoom > 0.1) {
				camGame.zoom -= elapsed * camGame.zoom;
				if(camGame.zoom < 0.1) camGame.zoom = 0.1;
			}
			if (FlxG.keys.pressed.E #if android || MusicBeatState.virtualPad.buttonC.pressed #end && camGame.zoom < 1) {
				camGame.zoom += elapsed * camGame.zoom;
				if(camGame.zoom > 1) camGame.zoom = 1;
			}
			if(FlxG.keys.justPressed.H #if android || MusicBeatState.virtualPad.buttonY.justPressed #end) {
				if(UI_mainbox.selected_tab_id == 'Animations') {
					currentGhosts++;
					if(currentGhosts > 2) currentGhosts = 0;

					ghostLoop.visible = (currentGhosts != 1);
					ghostIdle.visible = (currentGhosts != 2);
					ghostLoop.alpha = (currentGhosts == 2 ? 1 : 0.6);
					ghostIdle.alpha = (currentGhosts == 1 ? 1 : 0.6);
				} else {
					hudGroup.visible = !hudGroup.visible;
				}
			}
			if(FlxG.keys.justPressed.R #if android || MusicBeatState.virtualPad.buttonZ.justPressed #end) {
				camGame.zoom = 1;
				mainGroup.setPosition(0, 0);
				hudGroup.visible = true;
			}

			if(UI_mainbox.selected_tab_id != lastTab) {
				if(UI_mainbox.selected_tab_id == 'Animations') {
					hudGroup.alpha = 0;
					mainGroup.alpha = 0;
					ghostLoop.alpha = 0.6;
					ghostIdle.alpha = 0.6;
					tipText.text = TIP_TEXT_OFFSET;
					offsetLoopText.visible = true;
					offsetIdleText.visible = true;
					animText.visible = false;
					currentGhosts = 0;
				} else {
					hudGroup.alpha = 1;
					mainGroup.alpha = 1;
					ghostLoop.alpha = 0;
					ghostIdle.alpha = 0;
					tipText.text = TIP_TEXT_MAIN;
					offsetLoopText.visible = false;
					offsetIdleText.visible = false;
					animText.visible = true;
					updateTextBox();
					daText.resetDialogue();
					
					if(curAnim < 0) curAnim = character.jsonFile.animations.length - 1;
					else if(curAnim >= character.jsonFile.animations.length) curAnim = 0;
					
					character.playAnim(character.jsonFile.animations[curAnim].anim);
					animText.text = 'Animation: ' + character.jsonFile.animations[curAnim].anim + ' (' + (curAnim + 1) +' / ' + character.jsonFile.animations.length + ') - Press W or S to scroll';
				}
				lastTab = UI_mainbox.selected_tab_id;
				currentGhosts = 0;
			}
			
			if(UI_mainbox.selected_tab_id == 'Character')
			{
				var negaMult:Array<Int> = [1, -1];
				var controlAnim:Array<Bool> = [FlxG.keys.justPressed.W #if android || MusicBeatState.virtualPad.buttonUp.justPressed #end, FlxG.keys.justPressed.S #if android || MusicBeatState.virtualPad.buttonDown.justPressed #end];

				if(controlAnim.contains(true))
				{
					for (i in 0...controlAnim.length) {
						if(controlAnim[i] && character.jsonFile.animations.length > 0) {
							curAnim -= negaMult[i];
							if(curAnim < 0) curAnim = character.jsonFile.animations.length - 1;
							else if(curAnim >= character.jsonFile.animations.length) curAnim = 0;

							var animToPlay:String = character.jsonFile.animations[curAnim].anim;
							if(character.dialogueAnimations.exists(animToPlay)) {
								character.playAnim(animToPlay, daText.finishedText);
							}
						}
					}
					animText.text = 'Animation: ' + character.jsonFile.animations[curAnim].anim + ' (' + (curAnim + 1) +' / ' + character.jsonFile.animations.length + ') - Press W or S to scroll';
				}
			}

			if(FlxG.keys.justPressed.ESCAPE #if android || FlxG.android.justReleased.BACK #end) {
				FlxG.switchState(() -> new states.editors.MasterEditorMenu());
				FlxG.sound.playMusic(Paths.music('freakyMenu-' + ClientPrefs.data.mainMenuMusic), 1);
				transitioning = true;
			}

			ghostLoop.setPosition(character.x, character.y);
			ghostIdle.setPosition(character.x, character.y);
			hudGroup.x = mainGroup.x;
			hudGroup.y = mainGroup.y;
		}
		super.update(elapsed);
	}
	
	var _file:FileReference = null;
	function loadCharacter() {
		var jsonFilter:FileFilter = new FileFilter('JSON', 'json');
		_file = new FileReference();
		_file.addEventListener(Event.SELECT, onLoadComplete);
		_file.addEventListener(Event.CANCEL, onLoadCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file.browse([jsonFilter]);
	}

	function onLoadComplete(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);

		#if sys
		var fullPath:String = null;
		@:privateAccess
		if(_file.__path != null) fullPath = _file.__path;

		if(fullPath != null) {
			var rawJson:String = File.getContent(fullPath);
			if(rawJson != null) {
				var loadedChar:DialogueCharacterFile = cast Json.parse(rawJson);
				if(loadedChar.dialogue_pos != null) //Make sure it's really a dialogue character
				{
					var cutName:String = _file.name.substr(0, _file.name.length - 5);
					TraceText.makeTheTraceText("Successfully loaded file: " + cutName);
					character.jsonFile = loadedChar;
					reloadCharacter();
					reloadAnimationsDropDown();
					updateCharTypeBox();
					updateTextBox();
					daText.resetDialogue();
					imageInputText.text = character.jsonFile.image;
					scaleStepper.value = character.jsonFile.scale;
					xStepper.value = character.jsonFile.position[0];
					yStepper.value = character.jsonFile.position[1];
					_file = null;
					return;
				}
			}
		}
		_file = null;
		#else
		TraceText.makeTheTraceText("File couldn't be loaded! You aren't on Desktop, are you?");
		#end
	}

	/**
		* Called when the save file dialog is cancelled.
		*/
	function onLoadCancel(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		TraceText.makeTheTraceText("Cancelled file loading.");
	}

	/**
		* Called if there is an error while saving the gameplay recording.
		*/
	function onLoadError(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		TraceText.makeTheTraceText("Problem loading file");
	}

	function saveCharacter() {
		var data:String = haxe.Json.stringify(character.jsonFile, "\t");
		if (data.length > 0)
		{
			var splittedImage:Array<String> = imageInputText.text.trim().split('_');
			var characterName:String = splittedImage[0].toLowerCase().replace(' ', '');

			#if android
			StorageUtil.saveContent(characterName, ".json", data);
			#else
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data, characterName + ".json");
			#end
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved file.");
	}

	/**
		* Called when the save file dialog is cancelled.
		*/
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
		* Called if there is an error while saving the gameplay recording.
		*/
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving file");
	}

	function ClipboardAdd(prefix:String = ''):String {
		if(prefix.toLowerCase().endsWith('v')) //probably copy paste attempt
		{
			prefix = prefix.substring(0, prefix.length-1);
		}

		var text:String = prefix + Clipboard.text.replace('\n', '');
		return text;
	}
}