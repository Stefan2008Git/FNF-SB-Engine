package mobile.objects;

import mobile.objects.TouchButton;
import haxe.io.Path;
import flixel.graphics.frames.FlxTileFrames;
import mobile.input.MobileInputManager;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import openfl.display.BitmapData;

/**
 * ...
 * @author: Karim Akra and Lily Ross (mcagabe19)
 */
class TouchPad extends MobileInputManager<TouchPadButton> {
	public var buttonLeft:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.LEFT, MobileInputID.noteLEFT]);
	public var buttonUp:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.UP, MobileInputID.noteUP]);
	public var buttonRight:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.RIGHT, MobileInputID.noteRIGHT]);
	public var buttonDown:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.DOWN, MobileInputID.noteDOWN]);
	public var buttonLeft2:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.LEFT2, MobileInputID.noteLEFT]);
	public var buttonUp2:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.UP2, MobileInputID.noteUP]);
	public var buttonRight2:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.RIGHT2, MobileInputID.noteRIGHT]);
	public var buttonDown2:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.DOWN2, MobileInputID.noteDOWN]);
	public var buttonA:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.A]);
	public var buttonB:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.B]);
	public var buttonC:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.C]);
	public var buttonD:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.D]);
	public var buttonE:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.E]);
	public var buttonF:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.F]);
	public var buttonG:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.G]);
	public var buttonH:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.H]);
	public var buttonI:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.I]);
	public var buttonJ:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.J]);
	public var buttonK:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.K]);
	public var buttonL:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.L]);
	public var buttonM:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.M]);
	public var buttonN:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.N]);
	public var buttonO:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.O]);
	public var buttonP:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.P]);
	public var buttonQ:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.Q]);
	public var buttonR:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.R]);
	public var buttonS:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.S]);
	public var buttonT:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.T]);
	public var buttonU:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.U]);
	public var buttonV:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.V]);
	public var buttonW:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.W]);
	public var buttonX:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.X]);
	public var buttonY:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.Y]);
	public var buttonZ:TouchPadButton = new TouchPadButton(0, 0, [MobileInputID.Z]);
	public var buttonExtra:TouchPadButton = new TouchPadButton(0, 0);
	public var buttonExtra2:TouchPadButton = new TouchPadButton(0, 0);

	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */
	public function new(DPad:String, Action:String, ?Extra:ExtraActions = NONE) {
		super();

		if (DPad != "NONE") {
			if (!MobileData.dpadModes.exists(DPad))
				throw 'The touchPad dpadMode "$DPad" doesn\'t exists.';
			for (buttonData in MobileData.dpadModes.get(DPad).buttons) {
				Reflect.setField(this, buttonData.button,
					createButton(buttonData.x, buttonData.y, buttonData.graphic, CoolUtil.colorFromString(buttonData.color),
					Reflect.getProperty(this, buttonData.button).IDs));
				add(Reflect.field(this, buttonData.button));
			}
		}

		if (Action != "NONE") {
			if (!MobileData.actionModes.exists(Action))
				throw 'The touchPad actionMode "$Action" doesn\'t exists.';
			for (buttonData in MobileData.actionModes.get(Action).buttons) {
				Reflect.setField(this, buttonData.button,
					createButton(buttonData.x, buttonData.y, buttonData.graphic, CoolUtil.colorFromString(buttonData.color),
					Reflect.getProperty(this, buttonData.button).IDs));
				add(Reflect.field(this, buttonData.button));
			}
		}

		switch (Extra) {
			case SINGLE:
				add(buttonExtra = createButton(0, FlxG.height - 137, 's', 0xFF0066FF));
				setExtrasPos();
			case DOUBLE:
				add(buttonExtra = createButton(0, FlxG.height - 137, 's', 0xFF0066FF));
				add(buttonExtra2 = createButton(FlxG.width - 132, FlxG.height - 137, 'g', 0xA6FF00));
				setExtrasPos();
			case NONE: // nothing
		}

		alpha = ClientPrefs.data.controlsAlpha;
		scrollFactor.set();
		updateTrackedButtons();
	}

	override function update(elapsed:Float)
	{
		/*
		forEachAlive((button:TouchPadButton) -> {
			if(!button.isOnScreen(button.camera))
			{
				if(button.x < 0)
					button.x = 0;
				if(button.y < 0)
					button.y = 0;
				if(button.x > FlxG.width - button.frameWidth)
					button.x = FlxG.width - button.frameWidth;
				if(button.y > FlxG.height - button.frameHeight)
					button.y = FlxG.height - button.frameHeight;
			}
		});
		*/
		super.update(elapsed);
	}

	override public function destroy() {
		super.destroy();

		for (field in Reflect.fields(this))
			if (Std.isOfType(Reflect.field(this, field), TouchPadButton))
				Reflect.setField(this, field, FlxDestroyUtil.destroy(Reflect.field(this, field)));
	}

	public function setExtrasDefaultPos() {
		var int:Int = 0;

		if (MobileControls.save.data.extraData == null)
			MobileControls.save.data.extraData = new Array();

		for (button in Reflect.fields(this)) {
			if (button.toLowerCase().contains('extra') && Std.isOfType(Reflect.field(this, button), TouchPadButton)) {
				var daButton = Reflect.field(this, button);
				if (MobileControls.save.data.extraData[int] == null)
					MobileControls.save.data.extraData.push(FlxPoint.get(daButton.x, daButton.y));
				else
					MobileControls.save.data.extraData[int] = FlxPoint.get(daButton.x, daButton.y);
				++int;
			}
		}
		MobileControls.save.flush();
	}

	public function setExtrasPos() {
		var int:Int = 0;
		if (MobileControls.save.data.extraData == null)
			setExtrasDefaultPos();

		for (button in Reflect.fields(this)) {
			if (button.toLowerCase().contains('extra') && Std.isOfType(Reflect.field(this, button), TouchPadButton)) {
				if(MobileControls.save.data.extraData.length > int)
					setExtrasDefaultPos();
				var daButton = Reflect.field(this, button);
				daButton.x = MobileControls.save.data.extraData[int].x;
				daButton.y = MobileControls.save.data.extraData[int].y;
				int++;
			}
		}
	}

	private function createButton(X:Float, Y:Float, Graphic:String, ?Color:FlxColor = 0xFFFFFF, ?IDs:Array<MobileInputID>):TouchPadButton {
		var button = new TouchPadButton(X, Y, IDs, Graphic.toUpperCase());
		button.bounds.makeGraphic(Std.int(button.width - 50), Std.int(button.height - 50), FlxColor.TRANSPARENT);
		button.centerBounds();
		button.color = Color;
		button.parentAlpha = this.alpha;
		return button;
	}

	override function set_alpha(Value):Float {
		forEachAlive((button:TouchPadButton) -> {
			button.parentAlpha = Value;
		});
		super.set_alpha(Value);
		return Value;
	}
}

class TouchPadButton extends TouchButton
{
	public function new(X:Float = 0, Y:Float = 0, ?IDs:Array<MobileInputID>, ?labelGraphic:String){
		super(X, Y, IDs);
		if(labelGraphic != null){
			label = new FlxSprite();
			loadGraphic(Paths.image('touchpad/bg', "mobile"));
			label.loadGraphic(Paths.image('touchpad/$labelGraphic', "mobile"));
			scale.set(0.243, 0.243);
			updateHitbox();
			updateLabelPosition();
			// statusAlphas = [ClientPrefs.data.controlsAlpha, ClientPrefs.data.controlsAlpha - 0.05, ClientPrefs.data.controlsAlpha-0.12];
			statusAlphas = [parentAlpha, parentAlpha - 0.05, (parentAlpha - 0.45 == 0 && parentAlpha > 0) ? 0.25 : parentAlpha - 0.45];
			statusBrightness = [1, 0.9, 0.75];
			statusIndicatorType = BRIGHTNESS;
			labelStatusDiff = 0.08;
			indicateStatus();
			solid = false;
			immovable = true;
			moves = false;
			antialiasing = ClientPrefs.data.antialiasing;
			label.antialiasing = ClientPrefs.data.antialiasing;
			tag = labelGraphic.toUpperCase();
		}
	}
}
