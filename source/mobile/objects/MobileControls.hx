package mobile.objects;

import haxe.ds.Map;
import flixel.math.FlxPoint;
import mobile.input.MobileInputManager;
import haxe.extern.EitherType;
import mobile.objects.TouchButton;
import flixel.util.FlxSave;
import mobile.objects.Hitbox.HitboxButton;
import mobile.objects.TouchPad.TouchPadButton;
import flixel.util.typeLimit.OneOfTwo;

/**
 * ...
 * @author: Karim Akra
 */
class MobileControls extends FlxTypedSpriteGroup<MobileInputManager<Dynamic>>
{
	public var touchPad:TouchPad = new TouchPad('NONE', 'NONE', NONE);
	public var hitbox:Hitbox = new Hitbox(NONE);
	// YOU CAN'T CHANGE PROPERTIES USING THIS EXCEPT WHEN IN RUNTIME!!
	public var current:CurrentManager;

	public static var mode(get, set):Int;
	public static var forcedControl:Null<Int>;
	public static var save:FlxSave;

	public function new(?forceType:Int, ?extra:Bool = true)
	{
		super();
		forcedControl = mode;
		if (forceType != null)
			forcedControl = forceType;
		switch (forcedControl)
		{
			case 0: // RIGHT_FULL
				initControler(0, extra);
			case 1: // LEFT_FULL
				initControler(1, extra);
			case 2: // CUSTOM
				initControler(2, extra);
			case 3: // HITBOX
				initControler(3, extra);
		}
		current = new CurrentManager(this);
		// Options related stuff
		current.target.alpha = 1;
		alpha = ClientPrefs.data.controlsAlpha;
		updateButtonsColors();
	}

	private function initControler(touchPadMode:Int = 0, ?extra:Bool = true):Void
	{
		var extraAction = MobileData.extraActions.get(ClientPrefs.data.extraButtons);
		if (!extra)
			extraAction = NONE;
		switch (touchPadMode)
		{
			case 0:
				touchPad = new TouchPad('RIGHT_FULL', 'NONE', extraAction);
				add(touchPad);
			case 1:
				touchPad = new TouchPad('LEFT_FULL', 'NONE', extraAction);
				add(touchPad);
			case 2:
				touchPad = MobileControls.getCustomMode(new TouchPad('RIGHT_FULL', 'NONE', extraAction));
				add(touchPad);
			case 3:
				hitbox = new Hitbox(extraAction);
				add(hitbox);
		}
	}

	public static function setCustomMode(touchPad:TouchPad):Void
	{
		if (save.data.buttons == null)
		{
			save.data.buttons = new Array();
			for (buttons in touchPad)
				save.data.buttons.push(FlxPoint.get(buttons.x, buttons.y));
		}
		else
		{
			var tempCount:Int = 0;
			for (buttons in touchPad)
			{
				save.data.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				tempCount++;
			}
		}

		save.flush();
	}

	public static function getCustomMode(touchPad:TouchPad):TouchPad
	{
		var tempCount:Int = 0;

		if (save.data.buttons == null)
			return touchPad;

		for (buttons in touchPad)
		{
			if (save.data.buttons[tempCount] != null)
			{
				buttons.x = save.data.buttons[tempCount].x;
				buttons.y = save.data.buttons[tempCount].y;
			}
			tempCount++;
		}

		return touchPad;
	}

	override public function destroy():Void
	{
		super.destroy();

		if (touchPad != null)
		{
			touchPad = FlxDestroyUtil.destroy(touchPad);
			touchPad = null;
		}

		if (hitbox != null)
		{
			hitbox = FlxDestroyUtil.destroy(hitbox);
			hitbox = null;
		}
	}

	static function set_mode(mode:Int = 3)
	{
		save.data.mobileControlsMode = mode;
		save.flush();
		return mode;
	}

	static function get_mode():Int
	{
		if (forcedControl != null)
			return forcedControl;

		if (save.data.mobileControlsMode == null)
		{
			save.data.mobileControlsMode = 3;
			save.flush();
		}

		return save.data.mobileControlsMode;
	}

	public function updateButtonsColors()
	{
		// Dynamic Controls Color
		var buttonsColors:Array<FlxColor> = [];
		var data:Dynamic;
		if (ClientPrefs.data.dynamicColors)
			data = ClientPrefs.data;
		else
			data = ClientPrefs.defaultData;

		buttonsColors.push(data.arrowRGB[0][0]);
		buttonsColors.push(data.arrowRGB[1][0]);
		buttonsColors.push(data.arrowRGB[2][0]);
		buttonsColors.push(data.arrowRGB[3][0]);
		if (mode == 3)
		{
			touchPad.buttonLeft2.color = buttonsColors[0];
			touchPad.buttonDown2.color = buttonsColors[1];
			touchPad.buttonUp2.color = buttonsColors[2];
			touchPad.buttonRight2.color = buttonsColors[3];
		}
		current.buttonLeft.color = buttonsColors[0];
		current.buttonDown.color = buttonsColors[1];
		current.buttonUp.color = buttonsColors[2];
		current.buttonRight.color = buttonsColors[3];
	}

	public static function initSave() {
		save = new FlxSave();
		save.bind('MobileControls', CoolUtil.getSavePath());
	}
}

class CurrentManager
{
	public var buttonLeft:TouchButton;
	public var buttonDown:TouchButton;
	public var buttonUp:TouchButton;
	public var buttonRight:TouchButton;
	public var buttonExtra:TouchButton;
	public var buttonExtra2:TouchButton;
	public var target:MobileInputManager<Dynamic>;

	public function new(control:MobileControls)
	{
		if (MobileControls.mode == 3)
		{
			target = control.hitbox;
			buttonLeft = control.hitbox.buttonLeft;
			buttonDown = control.hitbox.buttonDown;
			buttonUp = control.hitbox.buttonUp;
			buttonRight = control.hitbox.buttonRight;
			buttonExtra = control.hitbox.buttonExtra;
			buttonExtra2 = control.hitbox.buttonExtra2;
		}
		else
		{
			target = control.touchPad;
			buttonLeft = control.touchPad.buttonLeft;
			buttonDown = control.touchPad.buttonDown;
			buttonUp = control.touchPad.buttonUp;
			buttonRight = control.touchPad.buttonRight;
			buttonExtra = control.touchPad.buttonExtra;
			buttonExtra2 = control.touchPad.buttonExtra2;
		}
	}
}
