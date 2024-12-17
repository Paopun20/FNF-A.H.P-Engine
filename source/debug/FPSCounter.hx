package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import backend.CoolUtil;
import states.PlayState;
import backend.*;

/**
 * The FPSCounter class provides an easy-to-use monitor to display
 * the current frame rate and debug information of an OpenFL project.
 */
class FPSCounter extends TextField {
    /**
     * The current frame rate, expressed using frames-per-second.
     */
    public var currentFPS(default, null):Int;

    /**
     * The current memory usage (WARNING: this is NOT your total program memory usage,
     * rather it shows the garbage collector memory).
     */
    public var memoryMegas(get, never):Float;

    // Private array to store timestamp data for calculating FPS
    @:noCompletion private var times:Array<Float>;

    // Timeout for updating the display
    private var deltaTimeout:Float = 0.0;
    private var infoCpu:String = "";
    private var infoGpu:String = "";

    /**
     * Constructor for the FPSCounter.
     * 
     * @param x       X-coordinate for the counter.
     * @param y       Y-coordinate for the counter.
     * @param color   Text color for the counter display.
     */
    public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000) {
        super();

        this.x = x;
        this.y = y;

        currentFPS = 0;
        selectable = false;
        mouseEnabled = false;
        defaultTextFormat = new TextFormat('_sans', 14, color);
        autoSize = LEFT;
        multiline = true;
        text = 'FPS: ';

        infoCpu = DEBUG_SYSTEM_INFO.getCpuName();
        infoGpu = DEBUG_SYSTEM_INFO.getGpuName();

        times = [];
    }

    /**
     * Event handler to calculate and update the FPS counter each frame.
     * 
     * @param deltaTime The time elapsed since the last frame.
     */
     private override function __enterFrame(deltaTime:Float):Void {
        final now:Float = haxe.Timer.stamp() * 1000;
        times.push(now);
    
        // Remove timestamps older than 1 second
        while (times[0] < now - 1000) {
            times.shift();
        }
    
        // Update the display at a reduced frequency
        if (deltaTimeout < 50) {
            deltaTimeout += deltaTime;
            return;
        }
    
        // Fix: Cast Math.min result to Int
        //currentFPS = Std.int(Math.min(times.length, FlxG.updateFramerate));
        currentFPS = Std.int(times.length);
        updateText();
        deltaTimeout = 0.0;
    }    

    /**
     * Updates the displayed text with the latest FPS and debug data.
     */
    public dynamic function updateText():Void { 
        // Base performance metrics
        text = 'FPS: ${currentFPS} / ${ClientPrefs.data.framerate}'
            + '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}';
        
        // Add debug-specific metrics if enabled
        if (ClientPrefs.data.ahp_debug) {
            text += '\n';
            text += '\n---Game Data---';
            text += '\nState: ${Type.getClassName(Type.getClass(FlxG.state))}';
            text += '\nSubstate: ${FlxG.state.subState != null ? Type.getClassName(Type.getClass(FlxG.state.subState)) : "None (No Substate)"}';
            
            text += '\n---System Info---';
            text += '\nOS: ${Sys.systemName()}';
            text += '\nCPU: $infoCpu';
            text += '\nGPU: $infoGpu';

            // Additional PlayState data if applicable
            if (Type.getClassName(Type.getClass(FlxG.state)) == 'states.PlayState' && PlayState.instance != null) {
                var game = PlayState.instance;

                text += '\n---PlayState Data---';
                text += '\ncurBpm: ${Conductor.bpm}';
                text += '\nbpm: ${PlayState.SONG.bpm}';
                text += '\nscrollSpeed: ${PlayState.SONG.speed}';
                text += '\ncrochet: ${Conductor.crochet}';
                text += '\nstepCrochet: ${Conductor.stepCrochet}';
                text += '\nsongLength: ${FlxG.sound.music.length}';
                text += '\nsongName: ${PlayState.SONG.song}';
                text += '\nsongPath: ${Paths.formatToSongPath(PlayState.SONG.song)}';
                text += '\nloadedSongName: ${Song.loadedSongName}';
                text += '\nloadedSongPath: ${Paths.formatToSongPath(Song.loadedSongName)}';
                text += '\nchartPath: ${Song.chartPath}';
                text += '\ncurStage: ${PlayState.SONG.stage}';
                text += '\nisStoryMode: ${PlayState.isStoryMode}';
                text += '\nstoryDifficulty: ${PlayState.storyDifficulty}';
                text += '\nstoryWeek: ${PlayState.storyWeek}';
                text += '\nweeksList: ${WeekData.weeksList[PlayState.storyWeek]}';
                text += '\nseenCutscene: ${PlayState.seenCutscene}';
                text += '\nneedsVoices: ${PlayState.SONG.needsVoices}';
                text += '\n---FunkinLua Data File---';
                text += '\nLua Array Count: ${game.luaArray.length}';
                text += '\nHscript Array Count: ${game.hscriptArray.length}';
            }
        }
        
        // FPS color feedback
        textColor = 0xFFFFFFFF;
        if (currentFPS <= ClientPrefs.data.framerate / 2 && currentFPS >= ClientPrefs.data.framerate / 3) {
            textColor = 0xFFFFFF00; // Yellow
        }
        if (currentFPS <= ClientPrefs.data.framerate / 3 && currentFPS >= ClientPrefs.data.framerate / 4) {
            textColor = 0xFFFF8000; // Orange
        }
        if (currentFPS <= ClientPrefs.data.framerate / 4) {
            textColor = 0xFFFF0000; // Red
        }
    }        

    /**
     * Returns the current memory usage in megabytes.
     */
    inline function get_memoryMegas():Float {
        return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
    }
}
