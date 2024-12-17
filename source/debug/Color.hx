package debug;

class Color {
    /**
     * Determines the color based on the current FPS and maximum framerate.
     * @param currentFPS The current frames per second.
     * @param maxFramerate The maximum allowed framerate.
     * @return The corresponding color in HEX format.
     */
    public static function findColor(currentFPS:Float, maxFramerate:Float):Int {
        if (currentFPS <= maxFramerate / 4) {
            return 0xFFFF0000; // Red
        }
        else if (currentFPS <= maxFramerate / 3) {
            return 0xFFFF8000; // Orange
        }
        else if (currentFPS <= maxFramerate / 2) {
            return 0xFFFFFF00; // Yellow
        }

        return 0xFFFFFFFF; // Default color: White
    }
}
