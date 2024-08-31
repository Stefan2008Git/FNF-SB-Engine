package debug;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class WatermarkCounter extends Bitmap
{
    public function new(x:Float = 10, y:Float = 10, alpha:Float = 0.5){

        super();
        
        var image:String = Paths.modFolders('images/engineStuff/main/sbinator.png');
        
        bitmapData = BitmapData.fromFile(image);

		this.x = x;
		this.y = y;
        this.alpha = alpha;        
    }
    
    private override function __enterFrame(deltaTime:Float):Void
	{	    	    	
	    this.x = 5;
	    this.y = Lib.current.stage.stageHeight - 5 - ClientPrefs.data.watermarkIconResize * bitmapData.height;
    }
} 