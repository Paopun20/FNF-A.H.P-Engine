package debug;
import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import backend.CoolUtil;
import states.PlayState;
import backend.*;

class AdDebugtext extends TextField {
    private var infoCpu:String = "";
    private var infoGpu:String = "";

    public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000) {
        super();

        this.x = x;
        this.y = y;
        selectable = false;
        defaultTextFormat = new TextFormat('_sans', 14, color);
        autoSize = LEFT;
        multiline = true;
        text = '';

        infoCpu = DEBUG_SYSTEM_INFO.getCpuName();
        infoGpu = DEBUG_SYSTEM_INFO.getGpuName();
    }

    private override function __enterFrame(deltaTime:Float):Void {
        updateText();
    }

    public dynamic function updateText():Void {
        text = '';
        if (ClientPrefs.data.ahp_debug) {
            text += '\n---System Info---';
            text += '\nOS: ${Sys.systemName()}';
            text += '\nCPU: $infoCpu';
            text += '\nGPU: $infoGpu';
            text += PlayStateMetrics.getDebugInfo(FlxG.state);
        }

        textColor = 0xFFFFFF;
    }
}