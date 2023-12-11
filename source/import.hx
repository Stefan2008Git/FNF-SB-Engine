#if !macro
package;

// Basic Flixel stuff for HaxeFlixel engine.
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
#if (flixel < "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flash.text.TextField;
import lime.app.Application;
import lime.system.System;
import openfl.Lib;
import openfl.events.EventDispatcher;
import openfl.display.DisplayObject;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.filters.BitmapFilter;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

// Friday Night Funkin': SB Engine stuff (Im talking about states, substates, backend, etc.)
import psychlua.FunkinLua;
import SUtil;
import backend.BaseStage;
import backend.ClientPrefs;
import backend.Conductor;
import backend.Conductor.BPMChangeEvent;
import backend.Conductor;
import backend.Controls;
import backend.CoolUtil;
import backend.CustomFadeTransition;
#if desktop
import backend.Discord.DiscordClient;
#end
import backend.Difficulty;
import backend.Highscore;
import backend.InputFormatter;
import backend.Mods;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.Paths;
import backend.Section;
import backend.Section.SwagSection;
import backend.Song;
import backend.Song.SwagSong;
import backend.StageData;
import backend.WeekData;
import cutscenes.DialogueBox;
import cutscenes.DialogueBoxPsych;
import shaders.ColorSwap;
import shaders.Shaders;
import shaders.RGBPalette;
import shaders.RGBPalette.RGBShaderReference;
import objects.Alphabet;
import objects.AttachedText;
import objects.AttachedSprite;
import objects.BGSprite;
import objects.Character;
import objects.CheckboxThingie;
import objects.HealthIcon;
import objects.MenuCharacter;
import objects.MenuItem;
import objects.Note;
import objects.Note.EventNote;
import objects.NoteSplash;
import objects.StrumNote;
import objects.TypedAlphabet;
import states.LoadingState;
import states.PlayState;

// Lua stuff
#if LUA_ALLOWED
import llua.*;
import llua.Lua;
#end

using StringTools;
#end