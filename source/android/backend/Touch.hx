package android.backend;

import flixel.input.touch.FlxTouch;

class Touch
{
    public static function touch():FlxTouch {
        return (FlxG.touches.getFirst());
    }

    public static function touchJustPressed(spr:FlxSprite, onTouch:Void -> Void) {
        if (Touch.touch()!=null){
            var sprPos = spr.getScreenPosition(FlxG.camera);
            var touchX = Touch.touch().screenX;
            var touchY = Touch.touch().screenY;
            var overlap:Bool = (touchX >= sprPos.x && touchX <= sprPos.x + spr.frameWidth
            && touchY >= sprPos.y && touchY <= sprPos.y + spr.frameHeight);
            if (overlap && Touch.touch().justPressed){
                onTouch();
            }
        }
    }
}
