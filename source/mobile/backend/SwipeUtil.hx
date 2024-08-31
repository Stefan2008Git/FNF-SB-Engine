package mobile.backend;

#if FLX_POINTER_INPUT
import flixel.FlxG;
#end

/**
 * ...
 * @author zacksgamerz
 */
class SwipeUtil
{
  public static var swipedDown(get, never):Bool;
  public static var swipedLeft(get, never):Bool;
  public static var swipedRight(get, never):Bool;
  public static var swipedUp(get, never):Bool;
  public static var swipedAny(get, never):Bool;

  @:noCompletion
  static function get_swipedDown():Bool
  {
    #if FLX_POINTER_INPUT
    for (swipe in FlxG.swipes)
    {
      if (swipe.degrees > -135 && swipe.degrees < -45 && swipe.distance > 20) return true;
    }
    #end

    return false;
  }

  @:noCompletion
  static function get_swipedLeft():Bool
  {
    #if FLX_POINTER_INPUT
    for (swipe in FlxG.swipes)
    {
      if ((swipe.degrees > 135 || swipe.degrees < -135) && swipe.distance > 20) return true;
    }
    #end

    return false;
  }

  @:noCompletion
  static function get_swipedRight():Bool
  {
    #if FLX_POINTER_INPUT
    for (swipe in FlxG.swipes)
    {
      if (swipe.degrees > -45 && swipe.degrees < 45 && swipe.distance > 20) return true;
    }
    #end

    return false;
  }

  @:noCompletion
  static function get_swipedUp():Bool
  {
    #if FLX_POINTER_INPUT
    for (swipe in FlxG.swipes)
    {
      if (swipe.degrees > 45 && swipe.degrees < 135 && swipe.distance > 20) return true;
    }
    #end

    return false;
  }

  @:noCompletion
  static function get_swipedAny():Bool
  {
    return swipedDown || swipedLeft || swipedRight || swipedUp;
  }
}