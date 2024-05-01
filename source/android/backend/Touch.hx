package android.backend;

class Touch
{
    **
     * Returns FlxTouch, shortcut to `FlxG.touches.getFirst()`.
     * @return FlxTouch
     */
    public static function touch():FlxTouch {
        return (FlxG.touches.getFirst());
    }

    /**
     * Touch checker for `spr`, then runs `onTouch` function
     * @param spr       Sprite that will be checked
     * @param onTouch   Function that will be runned if Touch = true
     */
    public static function touchJustPressed(spr:FlxSprite, onTouch:Void -> Void) {
        if (Touch.touch()!=null){
            var sprPos = spr.getScreenPosition(FlxG.camera);
            var touchX = Android.touch().screenX;
            var touchY = Android.touch().screenY;
            var overlap:Bool = (touchX >= sprPos.x && touchX <= sprPos.x + spr.frameWidth
            && touchY >= sprPos.y && touchY <= sprPos.y + spr.frameHeight);
            if (overlap && Android.touch().justPressed){
                onTouch();
            }
        }
    }
}
