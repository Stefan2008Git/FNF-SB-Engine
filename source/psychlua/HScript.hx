package psychlua;

import flixel.FlxBasic;
import objects.Character;
import psychlua.FunkinLua;
import psychlua.CustomSubstate;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if (HSCRIPT_ALLOWED && SScript >= "3.0.0")
import tea.SScript;
class HScript extends SScript
{
	public var parentLua:FunkinLua;
	
	public static function initHaxeModule(parent:FunkinLua)
	{
		#if (SScript >= "3.0.0")
		if(parent.hscript == null)
		{
			trace('initializing haxe interp for: ${parent.scriptName}');
			parent.hscript = new HScript(parent);
		}
		#end
	}

	public static function initHaxeModuleCode(parent:FunkinLua, code:String)
	{
		#if (SScript >= "3.0.0")
		var hs:HScript = parent.hscript;
		if(hs == null)
		{
			trace('initializing haxe interp for: ${parent.scriptName}');
			parent.hscript = new HScript(parent, code);
		}
		else
		{
			hs.doString(code);
			@:privateAccess
			if(hs.parsingExceptions != null && hs.parsingExceptions.length > 0)
			{
				@:privateAccess
				for (e in hs.parsingExceptions)
					if(e != null)
						PlayState.instance.addTextToDebug('ERROR ON LOADING (${hs.origin}): ${e.message.substr(0, e.message.indexOf('\n'))}', FlxColor.RED);
			}
		}
		#end
	}

	public var origin:String;
	override public function new(?parent:FunkinLua, ?file:String)
	{
		var usesClasses = false;
		if (file == null)
			file = '';
	
		#if sys
		else if (FileSystem.exists(file)) {
			var fileWithoutComments = ~/(\/[*](?:[^*]|[\r\n]|([*]+([^*\/]|[\r\n])))*[*]+\/|\/\/.*)/gm.replace(File.getContent(file), '');
			usesClasses = ~/class\s.*\s*{/.match(fileWithoutComments);
		}
		#end

		super(null, false, false);
		classSupport = usesClasses;
		doFile(file);
		parentLua = parent;
		if (parent != null)
			origin = parent.scriptName;
		if (scriptFile != null && scriptFile.length > 0)
			origin = scriptFile;
		preset();
		execute();
	}

	override function preset()
	{
		#if (SScript >= "3.0.0")
		super.preset();

		// Some very commonly used classes
		set('FlxG', flixel.FlxG);
		set('FlxSprite', flixel.FlxSprite);
		set('FlxCamera', flixel.FlxCamera);
		set('FlxTimer', flixel.util.FlxTimer);
		set('FlxTween', flixel.tweens.FlxTween);
		set('FlxEase', flixel.tweens.FlxEase);
		set('FlxColor', CustomFlxColor.instance);
		set('PlayState', PlayState);
		set('Paths', Paths);
		set('Conductor', Conductor);
		set('ClientPrefs', ClientPrefs);
		set('Character', Character);
		set('Alphabet', Alphabet);
		set('Note', objects.Note);
		set('CustomSubstate', CustomSubstate);
		set('Countdown', backend.BaseStage.Countdown);
		#if (!flash && sys)
		set('FlxRuntimeShader', flixel.addons.display.FlxRuntimeShader);
		#end
		set('ShaderFilter', openfl.filters.ShaderFilter);
		set('StringTools', StringTools);

		// Functions & Variables
		set('setVar', function(name:String, value:Dynamic)
		{
			PlayState.instance.variables.set(name, value);
		});
		set('getVar', function(name:String)
		{
			var result:Dynamic = null;
			if(PlayState.instance.variables.exists(name)) result = PlayState.instance.variables.get(name);
			return result;
		});
		set('removeVar', function(name:String)
		{
			if(PlayState.instance.variables.exists(name))
			{
				PlayState.instance.variables.remove(name);
				return true;
			}
			return false;
		});
		set('debugPrint', function(text:String, ?color:FlxColor = null) {
			if(color == null) color = FlxColor.WHITE;
			PlayState.instance.addTextToDebug(text, color);
		});

		// For adding your own callbacks

		// not very tested but should work
		set('createGlobalCallback', function(name:String, func:Dynamic)
		{
			#if LUA_ALLOWED
			for (script in PlayState.instance.luaArray)
				if(script != null && script.lua != null && !script.closed)
					Lua_helper.add_callback(script.lua, name, func);
			#end
			FunkinLua.customFunctions.set(name, func);
		});

		// tested
		set('createCallback', function(name:String, func:Dynamic, ?funk:FunkinLua = null)
		{
			if(funk == null) funk = parentLua;
			
			if(parentLua != null) funk.addLocalCallback(name, func);
			else FunkinLua.luaTrace('createCallback ($name): 3rd argument is null', false, false, FlxColor.RED);
		});

		set('addHaxeLibrary', function(libName:String, ?libPackage:String = '') {
			try {
				var str:String = '';
				if(libPackage.length > 0)
					str = libPackage + '.';

				var c:Dynamic = Type.resolveClass(str + libName);
				if (c == null)
					c = Type.resolveEnum(str + libName);
				set(libName, c);
			}
			catch (e:Dynamic) {
				var msg:String = e.message.substr(0, e.message.indexOf('\n'));
				if(parentLua != null)
				{
					FunkinLua.lastCalledScript = parentLua;
					msg = origin + ":" + parentLua.lastCalledFunction + " - " + msg;
				}
				else msg = '$origin - $msg';
				FunkinLua.luaTrace(msg, parentLua == null, false, FlxColor.RED);
			}
		});
		set('parentLua', parentLua);
		set('this', this);
		set('game', PlayState.instance);
		set('buildTarget', FunkinLua.getBuildTarget());
		set('customSubstate', CustomSubstate.instance);
		set('customSubstateName', CustomSubstate.name);

		set('Function_Stop', FunkinLua.Function_Stop);
		set('Function_Continue', FunkinLua.Function_Continue);
		set('Function_StopLua', FunkinLua.Function_StopLua); //doesnt do much cuz HScript has a lower priority than Lua
		set('Function_StopHScript', FunkinLua.Function_StopHScript);
		set('Function_StopAll', FunkinLua.Function_StopAll);
		
		set('add', function(obj:FlxBasic) PlayState.instance.add(obj));
		set('addBehindGF', function(obj:FlxBasic) PlayState.instance.addBehindGF(obj));
		set('addBehindDad', function(obj:FlxBasic) PlayState.instance.addBehindDad(obj));
		set('addBehindBF', function(obj:FlxBasic) PlayState.instance.addBehindBF(obj));
		set('insert', function(pos:Int, obj:FlxBasic) PlayState.instance.insert(pos, obj));
		set('remove', function(obj:FlxBasic, splice:Bool = false) PlayState.instance.remove(obj, splice));
		
		set('Math', Math);
		#end
	}

	public function executeCode(?funcToRun:String = null, ?funcArgs:Array<Dynamic> = null):SCall
	{
		if (funcToRun == null) return null;

		if(!exists(funcToRun))
		{
			FunkinLua.luaTrace(origin + ' - No HScript function named: $funcToRun', false, false, FlxColor.RED);
			return null;
		}

		var callValue = call(funcToRun, funcArgs);
		if (!callValue.succeeded)
		{
			var e = callValue.exceptions[0];
			if (e != null)
			{
				var msg:String = e.toString();
				if(parentLua != null) msg = origin + ":" + parentLua.lastCalledFunction + " - " + msg;
				else msg = '$origin - $msg';
				FunkinLua.luaTrace(msg, parentLua == null, false, FlxColor.RED);
			}
			return null;
		}
		return callValue;
	}

	public function executeFunction(funcToRun:String = null, funcArgs:Array<Dynamic>):SCall
	{
		if (funcToRun == null)
			return null;

		return call(funcToRun, funcArgs);
	}

	public static function implement(funk:FunkinLua)
	{
		#if LUA_ALLOWED
		funk.addLocalCallback("runHaxeCode", function(codeToRun:String, ?varsToBring:Any = null, ?funcToRun:String = null, ?funcArgs:Array<Dynamic> = null):Dynamic {
			var retVal:SCall = null;
			#if (SScript >= "3.0.0")
			initHaxeModule(funk);
			funk.hscript.doString(codeToRun);
			if(varsToBring != null)
			{
				for (key in Reflect.fields(varsToBring))
				{
					//trace('Key $key: ' + Reflect.field(varsToBring, key));
					funk.hscript.set(key, Reflect.field(varsToBring, key));
				}
			}
			retVal = funk.hscript.executeCode(funcToRun, funcArgs);
			if (retVal != null)
			{
				if(retVal.succeeded)
					return (retVal.returnValue == null || LuaUtils.isOfTypes(retVal.returnValue, [Bool, Int, Float, String, Array])) ? retVal.returnValue : null;

				var e = retVal.exceptions[0];
				if (e != null)
					FunkinLua.luaTrace(funk.hscript.origin + ":" + funk.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
				return null;
			}
			#else
			FunkinLua.luaTrace("runHaxeCode: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end
			return null;
		});
		
		funk.addLocalCallback("runHaxeFunction", function(funcToRun:String, ?funcArgs:Array<Dynamic> = null) {
			#if (SScript >= "3.0.0")
			var callValue = funk.hscript.executeFunction(funcToRun, funcArgs);
			if (!callValue.succeeded)
			{
				var e = callValue.exceptions[0];
				if (e != null)
					FunkinLua.luaTrace('ERROR (${funk.hscript.origin}: ${callValue.calledFunction}) - ' + e.message.substr(0, e.message.indexOf('\n')), false, false, FlxColor.RED);
				return null;
			}
			else
				return callValue.returnValue;
			#else
			FunkinLua.luaTrace("runHaxeFunction: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end
		});
		// This function is unnecessary because import already exists in SScript as a native feature
		funk.addLocalCallback("addHaxeLibrary", function(libName:String, ?libPackage:String = '') {
			var str:String = '';
			if(libPackage.length > 0)
				str = libPackage + '.';
			else if(libName == null)
				libName = '';

			var c:Dynamic = Type.resolveClass(str + libName);
			if (c == null)
				c = Type.resolveEnum(str + libName);

			#if (SScript >= "3.0.3")
			if (c != null)
				SScript.globalVariables[libName] = c;
			#end

			#if (SScript >= "3.0.0")
			if (funk.hscript != null)
			{
				try {
					if (c != null)
						funk.hscript.set(libName, c);
				}
				catch (e:Dynamic) {
					FunkinLua.luaTrace(funk.hscript.origin + ":" + funk.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
				}
			}
			#else
			FunkinLua.luaTrace("addHaxeLibrary: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end
		});
		#end
	}

	#if (SScript >= "3.0.3")
	override public function destroy()
	{
		origin = null;
		parentLua = null;

		super.destroy();
	}
	#else
	public function destroy()
	{
		active = false;
	}
	#end
}
#end

@:publicFields
class CustomFlxColor
{
	static var instance:CustomFlxColor = new CustomFlxColor();
	function new() {}

	var TRANSPARENT(default, null):Int = FlxColor.TRANSPARENT;
	var WHITE(default, null):Int = FlxColor.WHITE;
	var GRAY(default, null):Int = FlxColor.GRAY;
	var BLACK(default, null):Int = FlxColor.BLACK;

	var GREEN(default, null):Int = FlxColor.GREEN;
	var LIME(default, null):Int = FlxColor.LIME;
	var YELLOW(default, null):Int = FlxColor.YELLOW;
	var ORANGE(default, null):Int = FlxColor.ORANGE;
	var RED(default, null):Int = FlxColor.RED;
	var PURPLE(default, null):Int = FlxColor.PURPLE;
	var BLUE(default, null):Int = FlxColor.BLUE;
	var BROWN(default, null):Int = FlxColor.BROWN;
	var PINK(default, null):Int = FlxColor.PINK;
	var MAGENTA(default, null):Int = FlxColor.MAGENTA;
	var CYAN(default, null):Int = FlxColor.CYAN;

	function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Int
	{
		return cast FlxColor.fromRGB(Red, Green, Blue, Alpha);
	}
	function getRGB(color:Int):Array<Int>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.red, flxcolor.green, flxcolor.blue, flxcolor.alpha];
	}
	function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromRGBFloat(Red, Green, Blue, Alpha);
	}
	function getRGBFloat(color:Int):Array<Float>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.redFloat, flxcolor.greenFloat, flxcolor.blueFloat, flxcolor.alphaFloat];
	}
	function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):Int
	{
		return cast FlxColor.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha);
	}
	function getCMYK(color:Int):Array<Float>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.cyan, flxcolor.magenta, flxcolor.yellow, flxcolor.black, flxcolor.alphaFloat];
	}
	function fromHSB(Hue:Float, Sat:Float, Brt:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSB(Hue, Sat, Brt, Alpha);
	}
	function getHSB(color:Int):Array<Float>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.hue, flxcolor.saturation, flxcolor.brightness, flxcolor.alphaFloat];
	}
	function fromHSL(Hue:Float, Sat:Float, Light:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSL(Hue, Sat, Light, Alpha);
	}
	function getHSL(color:Int):Array<Float>
	{
		var flxcolor:FlxColor = FlxColor.fromInt(color);
		return [flxcolor.hue, flxcolor.saturation, flxcolor.lightness, flxcolor.alphaFloat];
	}
	function fromString(str:String):Int
	{
		return cast FlxColor.fromString(str);
	}
	function getHSBColorWheel(Alpha:Int = 255):Array<Int>
	{
		return cast FlxColor.getHSBColorWheel(Alpha);
	}
	function interpolate(Color1:Int, Color2:Int, Factor:Float = 0.5):Int
	{
		return cast FlxColor.interpolate(Color1, Color2, Factor);
	}
	function gradient(Color1:Int, Color2:Int, Steps:Int, ?Ease:Float->Float):Array<Int>
	{
		return cast FlxColor.gradient(Color1, Color2, Steps, Ease);
	}
	function multiply(lhs:Int, rhs:Int):Int
	{
		return cast FlxColor.multiply(lhs, rhs);
	}
	function add(lhs:Int, rhs:Int):Int
	{
		return cast FlxColor.add(lhs, rhs);
	}
	function subtract(lhs:Int, rhs:Int):Int
	{
		return cast FlxColor.subtract(lhs, rhs);
	}
	function getComplementHarmony(color:Int):Int
	{
		return cast FlxColor.fromInt(color).getComplementHarmony();
	}
	function getAnalogousHarmony(color:Int, Threshold:Int = 30):CustomHarmony
	{
		return cast FlxColor.fromInt(color).getAnalogousHarmony(Threshold);
	}
	function getSplitComplementHarmony(color:Int, Threshold:Int = 30):CustomHarmony
	{
		return cast FlxColor.fromInt(color).getSplitComplementHarmony(Threshold);
	}
	function getTriadicHarmony(color:Int):CustomTriadicHarmony
	{
		return cast FlxColor.fromInt(color).getTriadicHarmony();
	}
	function to24Bit(color:Int):Int
	{
		return color & 0xffffff;
	}
	function toHexString(color:Int, Alpha:Bool = true, Prefix:Bool = true):String
	{
		return cast FlxColor.fromInt(color).toHexString(Alpha, Prefix);
	}
	function toWebString(color:Int):String
	{
		return cast FlxColor.fromInt(color).toWebString();
	}
	function getColorInfo(color:Int):String
	{
		return cast FlxColor.fromInt(color).getColorInfo();
	}
	function getDarkened(color:Int, Factor:Float = 0.2):Int
	{
		return cast FlxColor.fromInt(color).getDarkened(Factor);
	}
	function getLightened(color:Int, Factor:Float = 0.2):Int
	{
		return cast FlxColor.fromInt(color).getLightened(Factor);
	}
	function getInverted(color:Int):Int
	{
		return cast FlxColor.fromInt(color).getInverted();
	}
}
typedef CustomHarmony = {
	original:Int,
	warmer:Int,
	colder:Int
}
typedef CustomTriadicHarmony = {
	color1:Int,
	color2:Int,
	color3:Int
}
