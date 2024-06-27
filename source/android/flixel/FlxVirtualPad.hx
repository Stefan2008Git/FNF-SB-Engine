package android.flixel;

import flixel.graphics.frames.FlxTileFrames;
import android.flixel.FlxButton as UIButton;

class FlxVirtualPad extends FlxSpriteGroup {
	//Actions
	public var buttonA:UIButton;
	public var buttonB:UIButton;
	public var buttonC:UIButton;
	public var buttonD:UIButton;
	public var buttonE:UIButton;
	public var buttonF:UIButton;
	public var buttonS:UIButton;
	public var buttonV:UIButton;
	public var buttonX:UIButton;
	public var buttonY:UIButton;
	public var buttonZ:UIButton;

	//DPad
	public var buttonLeft:UIButton;
	public var buttonUp:UIButton;
	public var buttonRight:UIButton;
	public var buttonDown:UIButton;

	//PAD DUO MODE
	public var buttonLeft2:UIButton;
	public var buttonUp2:UIButton;
	public var buttonRight2:UIButton;
	public var buttonDown2:UIButton;
    
    public var buttonCELeft:UIButton;
	public var buttonCEUp:UIButton;
	public var buttonCERight:UIButton;
	public var buttonCEDown:UIButton;
	public var buttonCEG:UIButton;
	
	public var buttonCEUp_M:UIButton;
	public var buttonCEDown_M:UIButton;
	
	public var dPad:FlxSpriteGroup;
	public var actions:FlxSpriteGroup;

	public var orgAlpha:Float = 0.75;
	public var orgAntialiasing:Bool = true;

	public function new(?DPad:FlxDPadMode, ?Action:FlxActionMode, ?alphaAlt:Float = 0.75, ?antialiasingAlt:Bool = true) {
		super();

		orgAntialiasing = antialiasingAlt;
		orgAlpha = ClientPrefs.data.virtualPadAlpha;

		dPad = new FlxSpriteGroup();
		dPad.scrollFactor.set();

		actions = new FlxSpriteGroup();
		actions.scrollFactor.set();

		buttonA = new UIButton(0, 0);
		buttonB = new UIButton(0, 0);
		buttonC = new UIButton(0, 0);
		buttonD = new UIButton(0, 0);
		buttonE = new UIButton(0, 0);
		buttonF = new UIButton(0, 0);
		buttonS = new UIButton(0, 0);
		buttonV = new UIButton(0, 0);
		buttonX = new UIButton(0, 0);
		buttonY = new UIButton(0, 0);
		buttonZ = new UIButton(0, 0);

		buttonLeft = new UIButton(0, 0);
		buttonUp = new UIButton(0, 0);
		buttonRight = new UIButton(0, 0);
		buttonDown = new UIButton(0, 0);

		buttonLeft2 = new UIButton(0, 0);
		buttonUp2 = new UIButton(0, 0);
		buttonRight2 = new UIButton(0, 0);
		buttonDown2 = new UIButton(0, 0);
        
        buttonCELeft = new UIButton(0, 0);
		buttonCEUp = new UIButton(0, 0);
		buttonCERight = new UIButton(0, 0);
		buttonCEDown = new UIButton(0, 0);
		buttonCEG = new UIButton(0, 0);
		
		buttonCEUp_M = new UIButton(0, 0);
		buttonCEDown_M = new UIButton(0, 0);
		
		if (ClientPrefs.data.gameStyle == 'SB Engine') {
			switch (DPad) {
				case UP_DOWN:
					dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
				case LEFT_RIGHT:
					dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));
				case UP_LEFT_RIGHT:
					dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 81 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));
				case FULL:
					dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonLeft = createButton(0, FlxG.height - 81 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));
					dPad.add(add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
				case RIGHT_FULL:
					dPad.add(add(buttonUp = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonLeft = createButton(FlxG.width - 128 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));
					dPad.add(add(buttonDown = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
				case DUO:
					dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonLeft = createButton(0, FlxG.height - 81 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));
					dPad.add(add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
					dPad.add(add(buttonUp2 = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonLeft2 = createButton(FlxG.width - 128 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight2 = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));
					dPad.add(add(buttonDown2 = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
				case CHART_EDITOR:
					//orgAlpha = 0.75;
					dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
					dPad.add(add(buttonLeft = createButton(42 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));		
				case MENUCHARACTEREDITOR:
					//orgAlpha = 0.75;
					dPad.add(add(buttonUp = createButton(220, FlxG.height - 85 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonDown = createButton(220, FlxG.height - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
					dPad.add(add(buttonLeft = createButton(220 + 42 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight = createButton(220 + 42 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));	
				case DIALOGUECHARACTER:
					//orgAlpha = 0.75;
					dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
					dPad.add(add(buttonLeft = createButton(42 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));					
					dPad.add(add(buttonUp2 = createButton(0 * 3, FlxG.height - 165 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonDown2 = createButton(0 * 3, FlxG.height - 125 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
					dPad.add(add(buttonLeft2 = createButton(42 * 3, FlxG.height - 165 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight2 = createButton(42 * 3, FlxG.height - 125 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));					
				case NOTESLPLASHDEBUG:
					//orgAlpha = 0.75;
					dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "down", FlxColor.BROWN)));
					dPad.add(add(buttonLeft = createButton(42 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "right", FlxColor.BROWN)));					
					dPad.add(add(buttonUp2 = createButton(84 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonDown2 = createButton(84 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "down", FlxColor.BROWN)));
					dPad.add(add(buttonLeft2 = createButton(126 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight2 = createButton(126 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "right", FlxColor.BROWN)));					
				case NONE:
			}
	
			switch (Action) {
				case A:
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));
				case B:
					actions.add(add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));
				case D:
					actions.add(add(buttonD = createButton(FlxG.width - 44 * 3, FlxG.height - 125 * 3, 44 * 3, 127, "d", FlxColor.BROWN)));	
				case E:
					actions.add(add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "e", FlxColor.BROWN)));					
				case A_B:
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));
				case B_E:
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));
					actions.add(add(buttonE = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "e", FlxColor.BROWN)));
				case A_B_C:
					actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));								
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));				
				case A_B_E:
					actions.add(add(buttonE = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "e", FlxColor.BROWN)));   
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));								
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));
				 case A_B_X_Y:
					actions.add(add(buttonY = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "y", FlxColor.BROWN)));
					actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "x", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));								
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));	 			               
				case A_B_C_X_Y:		
					actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", FlxColor.BROWN)));
					actions.add(add(buttonX = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", FlxColor.BROWN)));
					actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));				
				case A_B_C_X_Y_Z:
					actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", FlxColor.BROWN)));
					actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", FlxColor.BROWN)));
					actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "z", FlxColor.BROWN)));
					actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));								
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));	
				case FULL:
					actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "v", FlxColor.BROWN)));            
					actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", FlxColor.BROWN)));
					actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", FlxColor.BROWN)));
					actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "z", FlxColor.BROWN)));
					actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "d", FlxColor.BROWN)));
					actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));								
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));
	
				case CHARACTER_EDITOR:
					actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "v", FlxColor.BROWN)));            
					actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", FlxColor.BROWN)));
					actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", FlxColor.BROWN)));
					actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "z", FlxColor.BROWN)));
					actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "d", FlxColor.BROWN)));
					actions.add(add(buttonF = createButton(FlxG.width - 170 * 3, FlxG.height - 240 * 3, 44 * 3, 127, "f", FlxColor.BROWN)));
					actions.add(add(buttonS = createButton(FlxG.width - 128 * 3, FlxG.height - 190 * 3, 44 * 3, 127, "s", FlxColor.BROWN)));
					actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));								
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));
					dPad.add(add(buttonUp2 = createButton(180 * 3, FlxG.height - 116 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonLeft2 = createButton(133, FlxG.height - 81 * 3, 44 * 3, 127, "left", FlxColor.BROWN)));
					dPad.add(add(buttonRight2 = createButton(190 * 3, FlxG.height - 81 * 3, 44 * 3, 127, "right", FlxColor.BROWN)));
					dPad.add(add(buttonDown2 = createButton(180 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));
	
				case CHART_EDITOR:			    
					actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "v", FlxColor.BROWN)));            
					actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", FlxColor.BROWN)));
					actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", FlxColor.BROWN)));
					actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "z", FlxColor.BROWN)));
					actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "d", FlxColor.BROWN)));
					actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));								
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));				
					dPad.add(add(buttonCEUp = createButton(FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 85 * 3, 44 * 3, 127, "up", FlxColor.BROWN)));
					dPad.add(add(buttonCEDown = createButton(FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 45 * 3, 44 * 3, 127, "down", FlxColor.BROWN)));		
				case MENUCHARACTEREDITOR:
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3 - 350, FlxG.height - 45 * 3, 44 * 3, 127, "a", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 44 * 3 - 350, FlxG.height - 85 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));	
				case DIALOGUECHARACTER:
					actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "x", FlxColor.BROWN)));
					actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "y", FlxColor.BROWN)));
					actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "z", FlxColor.BROWN)));
					actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "c", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "b", FlxColor.BROWN)));								
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "a", FlxColor.BROWN)));	
				case NOTESLPLASHDEBUG:
					actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "v", FlxColor.BROWN)));            
					actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "x", FlxColor.BROWN)));
					actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "z", FlxColor.BROWN)));
					actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "d", FlxColor.BROWN)));
					actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "c", FlxColor.BROWN)));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "b", FlxColor.BROWN)));								
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "a", FlxColor.BROWN)));	
				case NOTESCOLORMENU:
					actions.add(add(buttonE = createButton(42 * 3, FlxG.height - 165 * 3, 44 * 3, 127, "e", FlxColor.BROWN)));
					actions.add(add(buttonC = createButton(0, FlxG.height - 165 * 3, 44 * 3, 127, "c", FlxColor.BROWN)));  
					actions.add(add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", FlxColor.BROWN)));					
				case NONE:
			}
		} else {
			switch (DPad){
				case UP_DOWN:
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));
			case LEFT_RIGHT:
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", 0xFF0000)));
			case UP_LEFT_RIGHT:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 81 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", 0xFF0000)));
			case FULL:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 81 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, 44 * 3, 127, "right", 0xFF0000)));
				dPad.add(add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));
			case RIGHT_FULL:
				dPad.add(add(buttonUp = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, 44 * 3, 155127, "up", 0x00FF00)));
				dPad.add(add(buttonLeft = createButton(FlxG.width - 128 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 127, "right", 0xFF0000)));
				dPad.add(add(buttonDown = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));
			case DUO:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 81 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, 44 * 3, 127, "right", 0xFF0000)));
				dPad.add(add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));
				dPad.add(add(buttonUp2 = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonLeft2 = createButton(FlxG.width - 128 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight2 = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 127, "right", 0xFF0000)));
				dPad.add(add(buttonDown2 = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));
			case CHART_EDITOR:
			    //orgAlpha = 0.75;
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));
				dPad.add(add(buttonLeft = createButton(42 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", 0xFF0000)));		
			case MENUCHARACTEREDITOR:
			    //orgAlpha = 0.75;
				dPad.add(add(buttonUp = createButton(220, FlxG.height - 85 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonDown = createButton(220, FlxG.height - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));
				dPad.add(add(buttonLeft = createButton(220 + 42 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(220 + 42 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", 0xFF0000)));	
			case DIALOGUECHARACTER:
			    //orgAlpha = 0.75;
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));
				dPad.add(add(buttonLeft = createButton(42 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "right", 0xFF0000)));					
				dPad.add(add(buttonUp2 = createButton(0 * 3, FlxG.height - 165 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonDown2 = createButton(0 * 3, FlxG.height - 125 * 3, 44 * 3, 127, "down", 0x00FFFF)));
				dPad.add(add(buttonLeft2 = createButton(42 * 3, FlxG.height - 165 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight2 = createButton(42 * 3, FlxG.height - 125 * 3, 44 * 3, 127, "right", 0xFF0000)));					
            case NOTESLPLASHDEBUG:
			    //orgAlpha = 0.75;
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "down", 0x00FFFF)));
				dPad.add(add(buttonLeft = createButton(42 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "right", 0xFF0000)));					
				dPad.add(add(buttonUp2 = createButton(84 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonDown2 = createButton(84 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "down", 0x00FFFF)));
				dPad.add(add(buttonLeft2 = createButton(126 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight2 = createButton(126 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "right", 0xFF0000)));					
			case NONE:
		}

		switch (Action){
			case A:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));
			case B:
				actions.add(add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));
			case D:
				actions.add(add(buttonD = createButton(FlxG.width - 44 * 3, FlxG.height - 125 * 3, 44 * 3, 127, "d", 0x0078FF)));	
			case E:
				actions.add(add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "e", 0x3131310)));					
			case A_B:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));
			case B_E:
				actions.add(add(buttonE = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "e", 0xFF7D00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));
			case A_B_C:
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));				
			case A_B_E:
				actions.add(add(buttonE = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "e", 0xFF7D00)));   
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));
 			case A_B_X_Y:
				actions.add(add(buttonY = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "y", 0x4A35B9)));
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "x", 0x99062D)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));	 			               
			case A_B_C_X_Y:		
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", 0x4A35B9)));
				actions.add(add(buttonX = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", 0x99062D)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));				
			case A_B_C_X_Y_Z:
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", 0x99062D)));
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", 0x4A35B9)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "z", 0xCCB98E)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));	
			case FULL:
				actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "v", 0x49A9B2)));            
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", 0x99062D)));
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", 0x4A35B9)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "z", 0xCCB98E)));
				actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "d", 0x0078FF)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));

			case CHARACTER_EDITOR:
				actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "v", 0x49A9B2)));            
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", 0x99062D)));
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", 0x4A35B9)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "z", 0xCCB98E)));
				actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "d", 0x0078FF)));
				actions.add(add(buttonF = createButton(FlxG.width - 170 * 3, FlxG.height - 250 * 3, 44 * 3, 127, "f", 0xFF00FFFB)));
				actions.add(add(buttonS = createButton(FlxG.width - 128 * 3, FlxG.height - 190 * 3, 44 * 3, 127, "s", 0xAB03FF)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));
				dPad.add(add(buttonUp2 = createButton(180 * 3, FlxG.height - 116 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonLeft2 = createButton(133, FlxG.height - 81 * 3, 44 * 3, 127, "left", 0xFF00FF)));
				dPad.add(add(buttonRight2 = createButton(190 * 3, FlxG.height - 81 * 3, 44 * 3, 127, "right", 0xFF0000)));
				dPad.add(add(buttonDown2 = createButton(180 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));
				
			case CHART_EDITOR:			    
				actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "v", 0x49A9B2)));            
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "x", 0x99062D)));
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "y", 0x4A35B9)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 127, "z", 0xCCB98E)));
				actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "d", 0x0078FF)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));				
				dPad.add(add(buttonCEUp = createButton(FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 85 * 3, 44 * 3, 127, "up", 0x00FF00)));
				dPad.add(add(buttonCEDown = createButton(FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 45 * 3, 44 * 3, 127, "down", 0x00FFFF)));		
			case MENUCHARACTEREDITOR:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3 - 350, FlxG.height - 45 * 3, 44 * 3, 127, "a", 0xFF0000)));
				actions.add(add(buttonB = createButton(FlxG.width - 44 * 3 - 350, FlxG.height - 85 * 3, 44 * 3, 127, "b", 0xFFCB00)));	
			case DIALOGUECHARACTER:
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "x", 0x99062D)));
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "y", 0x4A35B9)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "z", 0xCCB98E)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "a", 0xFF0000)));	
			case NOTESLPLASHDEBUG:
				actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "v", 0x49A9B2)));            
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "x", 0x99062D)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3 - 460, 44 * 3, 127, "z", 0xCCB98E)));
				actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "d", 0x0078FF)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3 - 460, 44 * 3, 127, "a", 0xFF0000)));	
			case NOTESCOLORMENU:
			    actions.add(add(buttonE = createButton(42 * 3, FlxG.height - 165 * 3, 44 * 3, 127, "e", 0xFF7D00)));
				actions.add(add(buttonC = createButton(0, FlxG.height - 165 * 3, 44 * 3, 127, "c", 0x44FF00)));  
				actions.add(add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 127, "b", 0xFFCB00)));					
			case NONE:
			}
		}
	}	

	public function createButton(x:Float, y:Float, width:Int, height:Int, frames:String, colors:Int):UIButton {
		var button = new UIButton(x, y);
		button.frames = FlxTileFrames.fromFrame(getFrames().getByName(frames), FlxPoint.get(width, height));
		button.resetSizeFromFrame();
		button.solid = false;
		button.immovable = true;
		button.scrollFactor.set();
		button.alpha = orgAlpha;
		button.color = colors;
		button.antialiasing = orgAntialiasing;
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
	}

	public static function getFrames():FlxAtlasFrames {
		return Paths.getPackerAtlas('android/androidControls/controls/virtualpad');																											
	}

	override public function destroy():Void {
		super.destroy();

		dPad = FlxDestroyUtil.destroy(dPad);
		actions = FlxDestroyUtil.destroy(actions);

		dPad = null;
		actions = null;

		buttonA = null;
		buttonB = null;
		buttonC = null;
		buttonD = null;
		buttonE = null;
		buttonF = null;
		buttonS = null;
		buttonV = null;	
		buttonX = null;	
		buttonY = null;
		buttonZ	= null;	

		buttonLeft = null;
		buttonUp = null;
		buttonDown = null;
		buttonRight = null;

		buttonLeft2 = null;
		buttonUp2 = null;
		buttonDown2 = null;
		buttonRight2 = null;
		
		buttonCELeft = null;
		buttonCEUp = null;
		buttonCEDown = null;
		buttonCERight = null;
		buttonCEG = null;
		
		buttonCEUp_M = null;
		buttonCEDown_M = null;
	}
}

enum FlxDPadMode {
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	FULL;
	RIGHT_FULL;
	DUO;
	CHART_EDITOR;
	MENUCHARACTEREDITOR;
	DIALOGUECHARACTER;
	NOTESLPLASHDEBUG;
	NONE;
}

enum FlxActionMode {
	A;
	B;
	D;
	E;
	A_B;
	B_E;
	A_B_C;
	A_B_E;
	A_B_X_Y;	
	A_B_C_X_Y;
	A_B_C_X_Y_Z;
	FULL;
	CHART_EDITOR;
	CHARACTER_EDITOR;
	MENUCHARACTEREDITOR;
	DIALOGUECHARACTER;
	NOTESLPLASHDEBUG;
	NOTESCOLORMENU;
	NONE;
}
