package ahptool;

import openfl.display.Screen;
import lime.system.System;
import Reflect;

class ScreenInfo {
    /**
     * Retrieves the resolution of all connected screens.
     * @return An array of objects containing `width` and `height` for each screen.
     */
    public static function getScreenResolutions(): Array<Dynamic> {
        var screenList: Array<Dynamic> = [];

        #if desktop
        // Attempt to handle multi-screen setups
        try {
            var screens = Reflect.field(Screen, "get_screens");
            if (screens != null) {
                var screenArray: Array<Screen> = cast screens();
                for (screen in screenArray) {
                    screenList.push({
                        "width": screen.bounds.width,
                        "height": screen.bounds.height
                    });
                }
                return screenList;
            }
        } catch (e: Dynamic) {
            // Handle platforms without multi-screen support
            trace("Multi-screen support is not available. Falling back to primary screen.");
        }
        #end

        // Fallback to primary screen resolution
        var primaryScreen = Screen.mainScreen;
        screenList.push({
            "width": primaryScreen.bounds.width,
            "height": primaryScreen.bounds.height
        });

        return screenList;
    }

    public static function getScreenInfo() {
        // Retrieve screen info from the display mode
        final displayMode = FlxG.stage.application.window.displayMode;
        
        return {
            width: displayMode.width,
            height: displayMode.height,
            refreshRate: displayMode.refreshRate
        };
    }
}
