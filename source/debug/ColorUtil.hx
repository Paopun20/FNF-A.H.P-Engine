package debug;

class ColorUtil {
    public static function findColor(fps:Int, targetFPS:Int):Int {
        if (fps >= targetFPS) return 0xFFFFFF; // Green
        if (fps >= targetFPS * 0.75) return 0xFFFF00; // Yellow
        return 0xFF0000; // Red
    }
}