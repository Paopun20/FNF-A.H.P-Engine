#if !macro
// Discord API support
#if DISCORD_ALLOWED
import backend.Discord; // Import the Discord module for webhook functionality
#end

// Lua scripting support
#if LUA_ALLOWED
import llua.*;
import llua.Lua;
#end

// Achievements system support
#if ACHIEVEMENTS_ALLOWED
import backend.Achievements;
#end

// Platform-specific imports
#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

// Core backend modules
import backend.Paths;
import backend.Controls;
import backend.CoolUtil;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.CustomFadeTransition;
import backend.ClientPrefs;
import backend.Conductor;
import backend.BaseStage;
import backend.Difficulty;
import backend.Mods;
import backend.Language;
import ahptool.*;

// load all
import openfl.*;
import psychlua.*;
import ahplua.*;
import hxcodec.*;
import flixel.*;
import sys.*;
import away3d.*;
import lime.*;
import openfl.display3D.Context3D;
import openfl.display3D.utils.UInt8Buff;
import flx3D.Flx3DUtil;
import flx3D.FlxView3D;
import haxe.ds.Vector as HaxeVector; //apparently denpa uses vectors, which is required for amera panning i guess

// HTTP client support
import haxe.Http;

// UI module (Psych-UI)
import backend.ui.*;

// Core game objects
import objects.Alphabet;
import objects.BGSprite;

// Game states
import states.PlayState;
import states.LoadingState;
import states.*;

import hx.*;
import colyseus.*;
import tink.*;
import Reflect;

// FlxAnimate support for animations
#if flxanimate
import flxanimate.*;
import flxanimate.PsychFlxAnimate as FlxAnimate;
#end

// Flixel framework imports
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxRect;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;

// Using StringTools extension methods
using StringTools;
#end
