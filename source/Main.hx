package;

#if android
import android.content.Context;
#end

import debug.FPSCounter;
import debug.AdDebugtext;

import flixel.graphics.FlxGraphic;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.io.Path;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import states.TitleState;
import sys.io.Process;

import lime.graphics.Image;

import openfl.*;
import psychlua.*;
import ahplua.*;
import hxcodec.*;
import flixel.*;
import sys.*;
import away3d.*;
import lime.*;

// Crash handler imports
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import sys.FileSystem;
import sys.io.File;
import Date;
#end

import backend.Highscore;

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends Sprite {
    var game = {
        width: 1280,          // Window width
        height: 720,          // Window height
        initialState: CheckForUpdateState, // Initial game state
        zoom: -1.0,           // Game zoom
        framerate: 60,        // Default framerate
        skipSplash: true,     // Skip flixel splash screen
        startFullscreen: false // Start in fullscreen mode
    };

    public static var fpsVar: FPSCounter;
    public static var debugVar: AdDebugtext;

    public static function main(): Void {
        Lib.current.addChild(new Main());
    }

    public function new() {
        super();

        #if android
        Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
        #elseif ios
        Sys.setCwd(lime.system.System.applicationStorageDirectory);
        #end

        if (stage != null) {
            init();
        } else {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        #if VIDEOS_ALLOWED
        hxvlc.util.Handle.init(#if (hxvlc >= "1.8.0")  ['--no-lua'] #end);
        #end
    }

    private function init(?E: Event): Void {
        if (hasEventListener(Event.ADDED_TO_STAGE)) {
            removeEventListener(Event.ADDED_TO_STAGE, init);
        }
        setupGame();
    }

    #if CRASH_HANDLER
    function setupGlobalErrorHandling(): Void {
        // Ensure 'loaderInfo' is accessible, then add the listener
        this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
    }
    #end

    private function setupGame(): Void {
        var stageWidth: Int = Lib.current.stage.stageWidth;
        var stageHeight: Int = Lib.current.stage.stageHeight;

        if (game.zoom == -1.0) {
            var ratioX: Float = stageWidth / game.width;
            var ratioY: Float = stageHeight / game.height;
            game.zoom = Math.min(ratioX, ratioY);
            game.width = Math.ceil(stageWidth / game.zoom);
            game.height = Math.ceil(stageHeight / game.zoom);
        }

        #if LUA_ALLOWED
        Mods.pushGlobalMods();
        #end
        Mods.loadTopMod();

        FlxG.save.bind('funkin', CoolUtil.getSavePath());

        Highscore.load();

        #if LUA_ALLOWED
        Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call));
        #end

        Controls.instance = new Controls();
        ClientPrefs.loadDefaultKeys();

        #if ACHIEVEMENTS_ALLOWED
        Achievements.load();
        #end

        addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, game.skipSplash, game.startFullscreen));

        #if !mobile
        fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
        addChild(fpsVar);
        Lib.current.stage.align = "tl";
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        if (fpsVar != null) {
            fpsVar.visible = ClientPrefs.data.showFPS;
        }
        #end

        debugVar = new AdDebugtext(10, 18, 0xFFFFFF);
        addChild(debugVar);
        Lib.current.stage.align = "tl";
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

        var icon = Image.fromFile("icon.png");
        Lib.current.stage.window.setIcon(icon);

        #if html5
        FlxG.autoPause = false;
        FlxG.mouse.visible = false;
        #end

        FlxG.fixedTimestep = false;
        FlxG.game.focusLostFramerate = 60;
        FlxG.keys.preventDefaultKeys = [TAB];
        
        #if CRASH_HANDLER
        setupGlobalErrorHandling();
        #end

        #if DISCORD_ALLOWED
        DiscordClient.prepare();
        #end

        FlxG.signals.gameResized.add(function(w, h) {
            if (FlxG.cameras != null) {
                for (cam in FlxG.cameras.list) {
                    if (cam != null && cam.filters != null) {
                        resetSpriteCache(cam.flashSprite);
                    }
                }
            }

            if (FlxG.game != null) {
                resetSpriteCache(FlxG.game);
            }
        });
    }

    static function resetSpriteCache(sprite: Sprite): Void {
        @:privateAccess {
            sprite.__cacheBitmap = null;
            sprite.__cacheBitmapData = null;
        }
    }

    #if CRASH_HANDLER
    function onCrash(e: UncaughtErrorEvent): Void {
        var errMsg: String = "The application encountered an error and needs to close.";
        var callStack: Array<StackItem> = CallStack.exceptionStack(true);
        var timestamp: String = Date.now().toString().replace(":", "-").replace(" ", "_");
        var crashDir: String = "./crash/";
        var logFilePath: String = Path.normalize(crashDir + "PsychEngine_Crash_" + timestamp + ".txt");

        // Detailed error message with stack trace
        errMsg += "\nPlease restart the application and try again.\n\nError Details:\n";
        for (stackItem in callStack) {
            switch (stackItem) {
                case FilePos(_, file, line, _):
                    errMsg += "In file: " + file + ", line " + line + "\n";
                default:
                    errMsg += "Stack item: " + stackItem + "\n";
            }
        }

        errMsg += "\nError Message: " + e.error;

        #if MODS_ALLOWED
        errMsg += "\n\nNote: If this error was caused by a mod, please contact the mod author.";
        #end

        try {
            // Check or create the crash directory
            if (!FileSystem.exists(crashDir)) {
                FileSystem.createDirectory(crashDir);
            }

            // Save the error log to file
            File.saveContent(logFilePath, errMsg + "\n");

            // Print confirmation of log saved
            Sys.println("Crash log saved to: " + logFilePath);
        } catch (error: Dynamic) {
            Sys.println("Failed to save crash log: " + error);
        }

        // Display error alert to user
        Application.current.window.alert(errMsg, "Application Error");

        // Print error details to console
        Sys.println(errMsg);

        #if DISCORD_ALLOWED
        DiscordClient.shutdown();
        #end

        // Exit the application
        Sys.println("Exiting application due to error...");
        Sys.exit(0);
    }
    #end
}
