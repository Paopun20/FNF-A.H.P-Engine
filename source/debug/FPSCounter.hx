package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import backend.CoolUtil;
import states.PlayState;
import backend.*;

/**
 * The FPSCounter class provides an easy-to-use monitor to display
 * the current frame rate and debug information of an OpenFL project.
 */
class FPSCounter extends TextField {
    public var currentFPS(default, null):Int;
    public var memoryMegas(get, never):Float;

    private var times:Array<Float>;
    private var deltaTimeout:Float = 0.0;

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
        times = [];
    }

    private override function __enterFrame(deltaTime:Float):Void {
        final now:Float = haxe.Timer.stamp() * 1000;
        times.push(now);

        while (times[0] < now - 1000) {
            times.shift();
        }

        if (deltaTimeout < 50) {
            deltaTimeout += deltaTime;
            return;
        }

        currentFPS = Std.int(Math.min(times.length, FlxG.updateFramerate));
        updateText();
        deltaTimeout = 0.0;
    }

    public dynamic function updateText():Void {
        text = 'FPS: ${currentFPS} / ${ClientPrefs.data.framerate}'
            + '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}';

        textColor = ColorUtil.findColor(currentFPS, ClientPrefs.data.framerate);
    }

    inline function get_memoryMegas():Float {
        return MemoryUtils.getMemoryUsage();
    }
}