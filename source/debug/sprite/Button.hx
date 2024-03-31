package debug.sprite;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;

class Button extends Bitmap
{
    public function new(width:Int = 140, height:Int = 50, alpha:Float = 0.3){

        super();             				
		
		var color:FlxColor = FlxColor.BROWN;
		
		var shape:Shape = new Shape();
        shape.graphics.beginFill(color);
        shape.graphics.drawRoundRect(0, 0, width, height, 10, 10);     
        shape.graphics.endFill();
        
        var BitmapData:BitmapData = new BitmapData(width, height, 0x00FFFFFF);
        BitmapData.draw(shape);   
                
        this.bitmapData = BitmapData;
        this.alpha = alpha;
    }  //说真的，haxe怎么写个贴图在flxgame层这么麻烦
}