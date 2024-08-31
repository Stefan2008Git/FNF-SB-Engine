package mobile.objects;

import mobile.input.MobileInputManager;
import openfl.display.BitmapData;
import mobile.objects.TouchButton;
import openfl.display.Shape;
import mobile.objects.TouchButton;
import flixel.graphics.FlxGraphic;

/**
 * A zone with 4 hint's (A hitbox).
 * It's really easy to customize the layout.
 *
 * @author: Mihai Alexandru and Karim Akra
 */
class Hitbox extends MobileInputManager<HitboxButton>
{
	final offsetFir:Int = (ClientPrefs.data.hitbox2 ? Std.int(FlxG.height / 4) * 3 : 0);
	final offsetSec:Int = (ClientPrefs.data.hitbox2 ? 0 : Std.int(FlxG.height / 4));

	public var buttonLeft:HitboxButton = new HitboxButton(0, 0, [MobileInputID.hitboxLEFT, MobileInputID.noteLEFT]);
	public var buttonDown:HitboxButton = new HitboxButton(0, 0, [MobileInputID.hitboxDOWN, MobileInputID.noteDOWN]);
	public var buttonUp:HitboxButton = new HitboxButton(0, 0, [MobileInputID.hitboxUP, MobileInputID.noteUP]);
	public var buttonRight:HitboxButton = new HitboxButton(0, 0, [MobileInputID.hitboxRIGHT, MobileInputID.noteRIGHT]);
	public var buttonExtra:HitboxButton = new HitboxButton(0, 0);
	public var buttonExtra2:HitboxButton = new HitboxButton(0, 0);

	var storedButtonsIDs:Map<String, Array<MobileInputID>> = new Map<String, Array<MobileInputID>>();

	/**
	 * Create the zone.
	 */
	public function new(extraMode:ExtraActions)
	{
		super();

		for (button in Reflect.fields(this))
		{
			if (Std.isOfType(Reflect.field(this, button), HitboxButton))
				storedButtonsIDs.set(button, Reflect.getProperty(Reflect.field(this, button), 'IDs'));
		}

		switch (extraMode)
		{
			case NONE:
				add(buttonLeft = createHint(0, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFFC24B99));
				add(buttonDown = createHint(FlxG.width / 4, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF00FFFF));
				add(buttonUp = createHint(FlxG.width / 2, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF12FA05));
				add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), 0, Std.int(FlxG.width / 4), FlxG.height, 0xFFF9393F));
			case SINGLE:
				add(buttonLeft = createHint(0, offsetSec, Std.int(FlxG.width / 4), Std.int(FlxG.height / 4) * 3, 0xFFC24B99));
				add(buttonDown = createHint(FlxG.width / 4, offsetSec, Std.int(FlxG.width / 4), Std.int(FlxG.height / 4) * 3, 0xFF00FFFF));
				add(buttonUp = createHint(FlxG.width / 2, offsetSec, Std.int(FlxG.width / 4), Std.int(FlxG.height / 4) * 3, 0xFF12FA05));
				add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), offsetSec, Std.int(FlxG.width / 4), Std.int(FlxG.height / 4) * 3,
					0xFFF9393F));
				add(buttonExtra = createHint(0, offsetFir, FlxG.width, Std.int(FlxG.height / 4), 0xFF0066FF));
			case DOUBLE:
				add(buttonLeft = createHint(0, offsetSec, Std.int(FlxG.width / 4), Std.int(FlxG.height / 4) * 3, 0xFFC24B99));
				add(buttonDown = createHint(FlxG.width / 4, offsetSec, Std.int(FlxG.width / 4), Std.int(FlxG.height / 4) * 3, 0xFF00FFFF));
				add(buttonUp = createHint(FlxG.width / 2, offsetSec, Std.int(FlxG.width / 4), Std.int(FlxG.height / 4) * 3, 0xFF12FA05));
				add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), offsetSec, Std.int(FlxG.width / 4), Std.int(FlxG.height / 4) * 3,
					0xFFF9393F));
				add(buttonExtra2 = createHint(Std.int(FlxG.width / 2), offsetFir, Std.int(FlxG.width / 2), Std.int(FlxG.height / 4), 0xA6FF00));
				add(buttonExtra = createHint(0, offsetFir, Std.int(FlxG.width / 2), Std.int(FlxG.height / 4), 0xFF0066FF));
		}

		for (button in Reflect.fields(this))
		{
			if (Std.isOfType(Reflect.field(this, button), HitboxButton))
				Reflect.setProperty(Reflect.getProperty(this, button), 'IDs', storedButtonsIDs.get(button));
		}
		scrollFactor.set();
		updateTrackedButtons();
	}

	/**
	 * Clean up memory.
	 */
	override function destroy()
	{
		super.destroy();

		for (field in Reflect.fields(this))
			if (Std.isOfType(Reflect.field(this, field), HitboxButton))
				Reflect.setField(this, field, FlxDestroyUtil.destroy(Reflect.field(this, field)));
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF):HitboxButton
	{
		var hint = new HitboxButton(X, Y, null, Width, Height);
		hint.color = Color;
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}
}

class HitboxButton extends TouchButton
{
	public static var hitboxesGraphics:Int = -1;

	public function new(x:Float, y:Float, ?IDs:Array<MobileInputID>, ?width:Int, ?height:Int){
		super(x, y, IDs);
		statusAlphas = [];
		statusIndicatorType = NONE;
		var fullLoad:Bool = true;
		if(width == null || height == null)
			fullLoad = false;
		if(fullLoad){
			loadGraphic(createHintGraphic(width, height));
			solid = false;
			immovable = true;
			multiTouch = true;
			moves = false;
			alpha = 0.00001;
			antialiasing = ClientPrefs.data.antialiasing;
			var hintTween:FlxTween = null;
			if (ClientPrefs.data.hitboxType != "Hidden")
			{
				onDown.callback = function()
				{
					if (hintTween != null)
						hintTween.cancel();

					hintTween = FlxTween.tween(this, {alpha: ClientPrefs.data.controlsAlpha}, ClientPrefs.data.controlsAlpha / 100, {
						ease: FlxEase.circInOut,
						onComplete: function(twn:FlxTween)
						{
							hintTween = null;
						}
					});
				}
				onUp.callback = function()
				{
					if (hintTween != null)
						hintTween.cancel();

					hintTween = FlxTween.tween(this, {alpha: 0.00001}, ClientPrefs.data.controlsAlpha / 10, {
						ease: FlxEase.circInOut,
						onComplete: function(twn:FlxTween)
						{
							hintTween = null;
						}
					});
				}
				onOut.callback = function()
				{
					if (hintTween != null)
						hintTween.cancel();

					hintTween = FlxTween.tween(this, {alpha: 0.00001}, ClientPrefs.data.controlsAlpha / 10, {
						ease: FlxEase.circInOut,
						onComplete: function(twn:FlxTween)
						{
							hintTween = null;
						}
					});
				}
			}
		}
	}

	function createHintGraphic(Width:Int, Height:Int):FlxGraphic
	{
		for(index in 0...hitboxesGraphics){
			if(FlxG.bitmap.get('hitbox$index') != null){
				var graphic = FlxG.bitmap.get('hitbox$index');
				if(graphic.width == Width && graphic.height == Height){
					return graphic;
				}
			}
		}
		hitboxesGraphics++;
		var guh = ClientPrefs.data.controlsAlpha;
		if (guh >= 0.9)
			guh = ClientPrefs.data.controlsAlpha - 0.07;
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFFFFFF);
		if (ClientPrefs.data.hitboxType == 'Gradient') {
			shape.graphics.lineStyle(3, 0xFFFFFF, 1);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.lineStyle(0, 0, 0);
			shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
			shape.graphics.endFill();
			shape.graphics.beginGradientFill(RADIAL, [0xFFFFFF, FlxColor.TRANSPARENT], [guh, 0], [0, 255], null, null, null, 0.5);
			shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
			shape.graphics.endFill();
		} else {
			shape.graphics.lineStyle(10, 0xFFFFFF, 1);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.endFill();
		}
		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return FlxG.bitmap.add(bitmap, false, 'hitbox$hitboxesGraphics');
	}
}
