package states;

import flixel.ui.FlxButton;
import tjson.TJSON as Json;

import states.editors.MasterEditorMenu;

class ModsMenuState extends MusicBeatState
{
	var mods:Array<ModMetadata> = [];
	static var changedAThing = false;
	var background:FlxSprite;
	var checkerboard:FlxBackdrop;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var noModsTxt:FlxText;
	var modEditorTxt:FlxText;
	var selector:AttachedSprite;
	var descriptionTxt:FlxText;
	var needaReset = false;
	private static var currentlySelected:Int = 0;
	public static var defaultColor:FlxColor = FlxColor.BROWN;

	var buttonDown:FlxButton;
	var buttonTop:FlxButton;
	var buttonDisableAll:FlxButton;
	var buttonEnableAll:FlxButton;
	var buttonUp:FlxButton;
	var buttonToggle:FlxButton;
	var buttonsArray:Array<FlxButton> = [];

	var installButton:FlxButton;
	var removeButton:FlxButton;

	var modsList:Array<Dynamic> = [];

	var visibleWhenNoMods:Array<FlxBasic> = [];
	var visibleWhenHasMods:Array<FlxBasic> = [];

	var control:Bool = true;

	override function create()
	{
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Mods Menu";
		Paths.clearStoredMemory();
		WeekData.setDirectoryFromWeek();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Mods Menus", null);
		#end

		background = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		background.antialiasing = ClientPrefs.data.antialiasing;
		add(background);
		background.screenCenter();

		checkerboard = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		checkerboard.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		checkerboard.visible = ClientPrefs.data.checkerboard;
		add(checkerboard);

		noModsTxt = new FlxText(0, 0, FlxG.width, "NO MODS INSTALLED\nPRESS BACK TO EXIT AND INSTALL A MOD", 48);
		if(FlxG.random.bool(0.1)) noModsTxt.text += '\nBITCH.'; //meanie
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine': noModsTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'TGT Engine': noModsTxt.setFormat(Paths.font("calibri.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			case 'Dave and Bambi': noModsTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			default: noModsTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		noModsTxt.scrollFactor.set();
		noModsTxt.borderSize = 2;
		noModsTxt.alpha = 1;
		noModsTxt.screenCenter();
		visibleWhenNoMods.push(noModsTxt);
		add(noModsTxt);

		modEditorTxt = new FlxText(400, 665, FlxG.width - 800, #if android "Tap on E button to enter on master editor menu." #else "Press 7 to enter on master editor menu." #end, 25);
		modEditorTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		modEditorTxt.scrollFactor.set();
		modEditorTxt.borderSize = 2;
		modEditorTxt.screenCenter(Y);
		add(modEditorTxt);

		var list:ModsList = Mods.parseList();
		for (mod in list.all) modsList.push([mod, list.enabled.contains(mod)]);

		selector = new AttachedSprite();
		selector.xAdd = -205;
		selector.yAdd = -68;
		selector.alphaMult = 0.5;
		makeSelectorGraphic();
		add(selector);
		visibleWhenHasMods.push(selector);

		//attached buttons
		var startX:Int = 1120;

		buttonToggle = new FlxButton(startX, 0, "ON", function()
		{
			if(mods[currentlySelected].restart)
			{
				needaReset = true;
			}
			modsList[currentlySelected][1] = !modsList[currentlySelected][1];
			updateButtonToggle();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
		});
		buttonToggle.setGraphicSize(50, 50);
		buttonToggle.updateHitbox();
		add(buttonToggle);
		buttonsArray.push(buttonToggle);
		visibleWhenHasMods.push(buttonToggle);

		buttonToggle.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER);
		setAllLabelsOffset(buttonToggle, -15, 10);
		startX -= 70;

		buttonUp = new FlxButton(startX, 0, "/\\", function()
		{
			moveMod(-1);
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
		});
		buttonUp.setGraphicSize(50, 50);
		buttonUp.updateHitbox();
		add(buttonUp);
		buttonsArray.push(buttonUp);
		visibleWhenHasMods.push(buttonUp);
		buttonUp.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
		setAllLabelsOffset(buttonUp, -15, 10);
		startX -= 70;

		buttonDown = new FlxButton(startX, 0, "\\/", function() {
			moveMod(1);
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
		});
		buttonDown.setGraphicSize(50, 50);
		buttonDown.updateHitbox();
		add(buttonDown);
		buttonsArray.push(buttonDown);
		visibleWhenHasMods.push(buttonDown);
		buttonDown.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
		setAllLabelsOffset(buttonDown, -15, 10);

		startX -= 100;
		buttonTop = new FlxButton(startX, 0, "TOP", function() {
			var doRestart:Bool = (mods[0].restart || mods[currentlySelected].restart);
			for (i in 0...currentlySelected) //so it shifts to the top instead of replacing the top one
			{
				moveMod(-1, true);
			}

			if(doRestart)
			{
				needaReset = true;
			}
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
		});
		buttonTop.setGraphicSize(80, 50);
		buttonTop.updateHitbox();
		buttonTop.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
		setAllLabelsOffset(buttonTop, 0, 10);
		add(buttonTop);
		buttonsArray.push(buttonTop);
		visibleWhenHasMods.push(buttonTop);


		startX -= 190;
		buttonDisableAll = new FlxButton(startX, 0, "DISABLE ALL", function() {
			for (i in modsList)
			{
				i[1] = false;
			}
			for (mod in mods)
			{
				if (mod.restart)
				{
					needaReset = true;
					break;
				}
			}
			updateButtonToggle();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
		});
		buttonDisableAll.setGraphicSize(170, 50);
		buttonDisableAll.updateHitbox();
		buttonDisableAll.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
		buttonDisableAll.label.fieldWidth = 170;
		setAllLabelsOffset(buttonDisableAll, 0, 10);
		add(buttonDisableAll);
		buttonsArray.push(buttonDisableAll);
		visibleWhenHasMods.push(buttonDisableAll);

		startX -= 190;
		buttonEnableAll = new FlxButton(startX, 0, "ENABLE ALL", function() {
			for (i in modsList)
			{
				i[1] = true;
			}
			for (mod in mods)
			{
				if (mod.restart)
				{
					needaReset = true;
					break;
				}
			}
			updateButtonToggle();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
		});
		buttonEnableAll.setGraphicSize(170, 50);
		buttonEnableAll.updateHitbox();
		buttonEnableAll.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
		buttonEnableAll.label.fieldWidth = 170;
		setAllLabelsOffset(buttonEnableAll, 0, 10);
		add(buttonEnableAll);
		buttonsArray.push(buttonEnableAll);
		visibleWhenHasMods.push(buttonEnableAll);

		// more buttons
		var startX:Int = 1100;
		descriptionTxt = new FlxText(148, 0, FlxG.width - 216, "", 32);
		descriptionTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
		descriptionTxt.scrollFactor.set();
		add(descriptionTxt);
		visibleWhenHasMods.push(descriptionTxt);

		var i:Int = 0;
		var len:Int = modsList.length;
		while (i < modsList.length)
		{
			var values:Array<Dynamic> = modsList[i];
			if(!FileSystem.exists(Paths.mods(values[0])))
			{
				modsList.remove(modsList[i]);
				continue;
			}

			var newMod:ModMetadata = new ModMetadata(values[0]);
			mods.push(newMod);

			newMod.alphabet = new Alphabet(0, 0, mods[i].name, true);
			var scale:Float = Math.min(840 / newMod.alphabet.width, 1);
			newMod.alphabet.setScale(scale);
			newMod.alphabet.y = i * 150;
			newMod.alphabet.x = 310;
			add(newMod.alphabet);
			//Don't ever cache the icons, it's a waste of loaded memory
			var loadedIcon:BitmapData = null;
			var iconToUse:String = Paths.mods(values[0] + '/pack.png');
			if(FileSystem.exists(iconToUse))
			{
				loadedIcon = BitmapData.fromFile(iconToUse);
			}

			newMod.icon = new AttachedSprite();
			if(loadedIcon != null)
			{
				newMod.icon.loadGraphic(loadedIcon, true, 150, 150);//animated icon support
				var totalFrames = Math.floor(loadedIcon.width / 150) * Math.floor(loadedIcon.height / 150);
				newMod.icon.animation.add("icon", [for (i in 0...totalFrames) i],10);
				newMod.icon.animation.play("icon");
			}
			else
			{
				newMod.icon.loadGraphic(Paths.image('unknownMod'));
			}
			newMod.icon.sprTracker = newMod.alphabet;
			newMod.icon.xAdd = -newMod.icon.width - 30;
			newMod.icon.yAdd = -45;
			add(newMod.icon);
			i++;
		}

		if(currentlySelected >= mods.length) currentlySelected = 0;

		if(mods.length < 1)
			background.color = defaultColor;
		else
			background.color = mods[currentlySelected].color;

		intendedColor = background.color;
		changeSelection();
		updatePosition();
		FlxG.sound.play(Paths.sound('scrollMenu'));

		Paths.clearUnusedMemory();

		FlxG.mouse.visible = true;

   		#if mobile addVirtualPad(UP_DOWN, B_E); #end

		super.create();
	}

	function updateButtonToggle()
	{
		if (modsList[currentlySelected][1])
		{
			buttonToggle.label.text = 'ON';
			buttonToggle.color = FlxColor.GREEN;
		}
		else
		{
			buttonToggle.label.text = 'OFF';
			buttonToggle.color = FlxColor.RED;
		}
	}

	function moveMod(change:Int, skipResetCheck:Bool = false)
	{
		if(mods.length > 1)
		{
			var doRestart:Bool = (mods[0].restart);

			var newPos:Int = currentlySelected + change;
			if(newPos < 0)
			{
				modsList.push(modsList.shift());
				mods.push(mods.shift());
			}
			else if(newPos >= mods.length)
			{
				modsList.insert(0, modsList.pop());
				mods.insert(0, mods.pop());
			}
			else
			{
				var lastArray:Array<Dynamic> = modsList[currentlySelected];
				modsList[currentlySelected] = modsList[newPos];
				modsList[newPos] = lastArray;

				var lastMod:ModMetadata = mods[currentlySelected];
				mods[currentlySelected] = mods[newPos];
				mods[newPos] = lastMod;
			}
			changeSelection(change);

			if(!doRestart) doRestart = mods[currentlySelected].restart;
			if(!skipResetCheck && doRestart) needaReset = true;
		}
	}

	function saveTxt()
	{
		var fileStr:String = '';
		for (values in modsList)
		{
			if(fileStr.length > 0) fileStr += '\n';
			fileStr += values[0] + '|' + (values[1] ? '1' : '0');
		}

		var path:String = StorageUtil.getPath() + 'modsList.txt';
		File.saveContent(path, fileStr);
		Mods.pushGlobalMods();
	}

	var noModsSine:Float = 0;
	var canExit:Bool = true;
	override function update(elapsed:Float)
	{
		if(noModsTxt.visible)
		{
			noModsSine += 180 * elapsed;
			noModsTxt.alpha = 1 - Math.sin((Math.PI * noModsSine) / 180);
		}

		if(canExit && controls.BACK && control)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.mouse.visible = false;
			saveTxt();
			if(needaReset)
			{
				TitleState.initialized = false;
				TitleState.closedState = false;
				FlxG.sound.music.fadeOut(0.3);
				if(FreeplayState.vocals != null)
				{
					FreeplayState.vocals.fadeOut(0.3);
					FreeplayState.vocals = null;
				}
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
			}
			else
			{
				FlxG.switchState(() -> new MainMenuState());
			}
		}

		if(controls.UI_UP_P && control)
		{
			changeSelection(-1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		if(controls.UI_DOWN_P && control)
		{
			changeSelection(1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		#if (desktop || android)
		else if (controls.justPressed('debug_1') #if android || MusicBeatState.virtualPad.buttonE.justPressed #end && control)
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(() -> new MasterEditorMenu());
		}
		#end

		updatePosition(elapsed);
		super.update(elapsed);
	}

	function setAllLabelsOffset(button:FlxButton, x:Float, y:Float)
	{
		for (point in button.labelOffsets)
		{
			point.set(x, y);
		}
	}

	function changeSelection(change:Int = 0)
	{
		var noMods:Bool = (mods.length < 1);
		for (obj in visibleWhenHasMods)
		{
			obj.visible = !noMods;
		}
		for (obj in visibleWhenNoMods)
		{
			obj.visible = noMods;
		}
		if(noMods) return;

		currentlySelected += change;
		if(currentlySelected < 0)
			currentlySelected = mods.length - 1;
		else if(currentlySelected >= mods.length)
			currentlySelected = 0;

		var newColor:Int = mods[currentlySelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(background, 1, background.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var i:Int = 0;
		for (mod in mods)
		{
			mod.alphabet.alpha = 0.6;
			if(i == currentlySelected)
			{
				mod.alphabet.alpha = 1;
				selector.sprTracker = mod.alphabet;
				descriptionTxt.text = mod.description;
				if (mod.restart){//finna make it to where if nothing changed then it won't reset
					descriptionTxt.text += " (This Mod will restart the game!)";
				}

				// correct layering
				var stuffArray:Array<FlxSprite> = [/*removeButton, installButton,*/ selector, descriptionTxt, mod.alphabet, mod.icon];
				for (obj in stuffArray)
				{
					remove(obj);
					insert(members.length, obj);
				}
				for (obj in buttonsArray)
				{
					remove(obj);
					insert(members.length, obj);
				}
			}
			i++;
		}
		updateButtonToggle();
	}

	function updatePosition(elapsed:Float = -1)
	{
		var i:Int = 0;
		for (mod in mods)
		{
			var intendedPos:Float = (i - currentlySelected) * 225 + 200;
			if(i > currentlySelected) intendedPos += 225;
			if(elapsed == -1)
			{
				mod.alphabet.y = intendedPos;
			}
			else
			{
				mod.alphabet.y = FlxMath.lerp(mod.alphabet.y, intendedPos, FlxMath.bound(elapsed * 12, 0, 1));
			}

			if(i == currentlySelected)
			{
				descriptionTxt.y = mod.alphabet.y + 160;
				for (button in buttonsArray)
				{
					button.y = mod.alphabet.y + 320;
				}
			}
			i++;
		}
	}

	var cornerSize:Int = 11;
	function makeSelectorGraphic()
	{
		selector.makeGraphic(1100, 450, FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle(0, 190, selector.width, 5), 0x0);

		// Why did i do this? Because i'm a lmao stupid, of course
		// also i wanted to understand better how fillRect works so i did this shit lol???
		selector.pixels.fillRect(new Rectangle(0, 0, cornerSize, cornerSize), 0x0);														 //top left
		drawCircleCornerOnSelector(false, false);
		selector.pixels.fillRect(new Rectangle(selector.width - cornerSize, 0, cornerSize, cornerSize), 0x0);							 //top right
		drawCircleCornerOnSelector(true, false);
		selector.pixels.fillRect(new Rectangle(0, selector.height - cornerSize, cornerSize, cornerSize), 0x0);							 //bottom left
		drawCircleCornerOnSelector(false, true);
		selector.pixels.fillRect(new Rectangle(selector.width - cornerSize, selector.height - cornerSize, cornerSize, cornerSize), 0x0); //bottom right
		drawCircleCornerOnSelector(true, true);
	}

	function drawCircleCornerOnSelector(flipX:Bool, flipY:Bool)
	{
		var antiX:Float = (selector.width - cornerSize);
		var antiY:Float = flipY ? (selector.height - 1) : 0;
		if(flipY) antiY -= 2;
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 1), Std.int(Math.abs(antiY - 8)), 10, 3), FlxColor.BLACK);
		if(flipY) antiY += 1;
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 2), Std.int(Math.abs(antiY - 6)),  9, 2), FlxColor.BLACK);
		if(flipY) antiY += 1;
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 3), Std.int(Math.abs(antiY - 5)),  8, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 4), Std.int(Math.abs(antiY - 4)),  7, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 5), Std.int(Math.abs(antiY - 3)),  6, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 6), Std.int(Math.abs(antiY - 2)),  5, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 8), Std.int(Math.abs(antiY - 1)),  3, 1), FlxColor.BLACK);
	}
}

class ModMetadata
{
	public var folder:String;
	public var name:String;
	public var description:String;
	public var color:FlxColor;
	public var restart:Bool;//trust me. this is very important
	public var alphabet:Alphabet;
	public var icon:AttachedSprite;

	public function new(folder:String)
	{
		this.folder = folder;
		this.name = folder;
		this.description = "No description provided.";
		this.color = ModsMenuState.defaultColor;
		this.restart = false;

		//Try loading json
		var pack:Dynamic = Mods.getPack(folder);
		if(pack != null) {
			if(pack.name != null && pack.name.length > 0)
			{
				if(pack.name != 'Name')
					this.name = pack.name;
				else
					this.name = pack.folder;
			}

			if(pack.description != null && pack.description.length > 0)
			{
				if(pack.description != 'Description')
					this.description = pack.description;
				else
					this.description = "No description provided.";
			}

			if(pack.color != null)
				this.color = FlxColor.fromRGB(pack.color[0] != null ? pack.color[0] : 170,
											pack.color[1] != null ? pack.color[1] : 0,
											pack.color[2] != null ? pack.color[2] : 255);
			this.restart = pack.restart;
		}
	}
}
