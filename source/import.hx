#if !macro
package;

// Baic Haxe stuff for Haxe
import haxe.CallStack;
import haxe.CallStack.StackItem;
import haxe.Constraints;
import haxe.Constraints.Function;
import haxe.Json;
import haxe.Log;
import haxe.PosInfos;
import haxe.format.JsonParser;
import haxe.iterators.ArrayIterator;
import haxe.io.Bytes;
import haxe.io.Path;
import haxe.macro.Compiler;
import Type.ValueType;

// Basic Flixel stuff for HaxeFlixel engine.
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
#if !flash
import flixel.addons.display.FlxRuntimeShader;
#end
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.addons.effects.FlxTrail;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIAssets;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIGroup;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIPopup;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.interfaces.IFlxUIClickable;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.addons.ui.interfaces.IHasParams;
import flixel.addons.text.FlxTypeText;
import flixel.addons.transition.FlxTransitionableState;
import flixel.animation.FlxAnimationController;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepadManager;
import flixel.input.gamepad.mappings.FlxGamepadMapping;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets;
import flixel.system.FlxAssets.FlxShader;
import flixel.system.frontEnds.LogFrontEnd;
import flixel.system.ui.FlxSoundTray;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

#if flash
import flash.geom.Rectangle;
import flash.media.Sound;
import flash.net.FileFilter;
import flash.text.TextField;
#end

#if lime
import lime.app.Application;
import lime.media.AudioBuffer;
import flash.net.FileFilter;
import lime.system.Clipboard;
#end

#if openfl
import openfl.Assets;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.KeyboardEvent;
import openfl.events.IOErrorEvent;
import openfl.events.MouseEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.geom.Rectangle;
import openfl.display.DisplayObject;
import openfl.display.PNGEncoderOptions;
import openfl.display.ShaderParameter;
import openfl.display.ShaderParameterType;
import openfl.display.StageScaleMode;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.filters.BlurFilter;
import openfl.filters.BitmapFilter;
import openfl.display.Sprite;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.utils.AssetType;
import openfl.utils.ByteArray;
#end

#if !flash 
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import openfl.display.Shader;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

// Friday Night Funkin': SB Engine stuff (Im talking about states, substates, backend, etc.)
import android.backend.StorageUtil;
import backend.animation.PsychAnimationController;
import backend.BaseStage;
import backend.ClientPrefs;
import backend.Conductor;
import backend.Conductor.BPMChangeEvent;
import backend.Conductor;
import backend.Controls;
import backend.CoolUtil;
import backend.CustomFadeTransition;
#if DISCORD_ALLOWED
import backend.Discord.DiscordClient;
#end
import backend.Difficulty;
import backend.Highscore;
import backend.InputFormatter;
import backend.Mods;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.NoteTypesConfig;
import backend.Paths;
import backend.Rating;
import backend.Section;
import backend.Section.SwagSection;
import backend.Song;
import backend.Song.SwagSong;
import backend.StageData;
import backend.WeekData;
import cutscenes.DialogueBox;
import cutscenes.DialogueBoxPsych;
import cutscenes.DialogueCharacter;
import cutscenes.CutsceneHandler;
import debug.FPS;
import debug.TraceText;
import psychlua.FunkinLua;
import objects.Alphabet;
import objects.AttachedText;
import objects.AttachedSprite;
import objects.Bar;
import objects.BGSprite;
import objects.Character;
import objects.CheckboxThingie;
import objects.GameplayOption;
import objects.HealthIcon;
import objects.MenuCharacter;
import objects.MusicPlayer;
import objects.MenuItem;
import objects.Note;
import objects.Note.EventNote;
import objects.NoteSplash;
import objects.StrumNote;
import objects.TypedAlphabet;
import shaders.ColorSwap;
import shaders.RGBPalette;
import shaders.RGBPalette.RGBShaderReference;
import states.MainMenuState;
import states.LoadingState;
import states.PlayState;
import states.stages.objects.*;
import substates.*;

#if flxanimate
import flxanimate.*;
import flxanimate.PsychFlxAnimate as FlxAnimate;
#end

// Lua stuff
#if LUA_ALLOWED
import llua.*;
import llua.Lua;
#end

#if VIDEOS_ALLOWED 
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

using StringTools;
#end
