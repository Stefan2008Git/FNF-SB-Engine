package backend;

import lime.ui.Haptic;
import openfl.events.UncaughtErrorEvent;
import openfl.events.ErrorEvent;
import openfl.errors.Error;
#if sys
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
#end

using StringTools;
using flixel.util.FlxArrayUtil;

/**
 * Crash Handler.
 * @author YoshiCrafter29, Ne_Eo, MAJigsaw77 and Lily Ross (mcagabe19)
 */
class CrashHandler
{
	public static function init():Void
	{
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onError);
		#elseif hl
		hl.Api.setErrorHandler(onError);
		#end
	}

	private static function onUncaughtError(e:UncaughtErrorEvent):Void
	{
		e.preventDefault();
		e.stopPropagation();
		e.stopImmediatePropagation();

		var m:String = e.error;
		if (Std.isOfType(e.error, Error)) {
			var err = cast(e.error, Error);
			m = '${err.message}';
		} else if (Std.isOfType(e.error, ErrorEvent)) {
			var err = cast(e.error, ErrorEvent);
			m = '${err.text}';
		}
		var stack = haxe.CallStack.exceptionStack();
		var stackLabelArr:Array<String> = [];
		var stackLabel:String = "";
		for(e in stack) {
			switch(e) {
				case CFunction: stackLabelArr.push("Non-Haxe (C) Function");
				case Module(c): stackLabelArr.push('Module ${c}');
				case FilePos(parent, file, line, col):
					switch(parent) {
						case Method(cla, func):
							stackLabelArr.push('${file.replace('.hx', '')}.$func() [Line $line]');
						case _:
							stackLabelArr.push('${file.replace('.hx', '')} [Line $line]');
					}
				case LocalFunction(v):
					stackLabelArr.push('Local Function ${v}');
				case Method(cl, m):
					stackLabelArr.push('${cl} - ${m}');
			}
		}
		stackLabel = stackLabelArr.join('\r\n');
		#if sys
		try
		{
			if (!FileSystem.exists('crash'))
				FileSystem.createDirectory('crash');

			File.saveContent('crash/' + 'SB Engine - ' + Date.now().toString().replace(' ', '-').replace(':', "'") + '.logs', '$m\n$stackLabel');
		}
		catch (e:haxe.Exception)
			trace('Couldn\'t save error message. (${e.message})');
		#end

		#if android
		if (ClientPrefs.data.vibration) Haptic.vibrate(0, 500);
		AndroidToast.makeText("Fatal Uncaugth Expection happened!", 1, -1, 0, 0);
		#end

		Sys.println("Crash dump saved in /crash/ root folder\n" + Path.normalize(stackLabel));

		FlxG.sound.play(Paths.sound('engineStuff/error'));
		flixel.FlxG.sound.music.stop();

		CoolUtil.showPopUp('$m\n$stackLabel\n\nPlease report this error to the GitHub page: https://github.com/Stefan2008Git/FNF-SB-Engine\n> Crash Handler written by: sqirra-rng', "Fatal Uncaugth Expection! SB Engine v" + MainMenuState.sbEngineVersion);

		#if html5
		if (flixel.FlxG.sound.music != null)
			flixel.FlxG.sound.music.stop();

		js.Browser.window.location.reload(true);
		#else
		#if DISCORD_ALLOWED DiscordClient.shutdown(); #end
		lime.system.System.exit(1);
		#end
	}

	#if (cpp || hl)
	private static function onError(message:Dynamic):Void
	{
		throw Std.string(message);
	}
	#end
}
