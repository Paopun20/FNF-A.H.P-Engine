package ahplua;

import ahptool.ScreenInfo;
import flixel.util.FlxColor;

class ScreenInfoHandler {
    #if LUA_ALLOWED
    /**
     * Adds a Lua callback for retrieving screen information.
     * Registers `getScreenInfo` function to Lua as "getScreenInfo".
     * @param lua The Lua object to register the callback with.
     */
    public static function addLuaCallbacks(lua: Dynamic): Void {
        Lua_helper.add_callback(lua, "getScreenResolutions", () -> {
            #if ScreenInfo_LUA_EXTENSIONS
                return ScreenInfo.getScreenResolutions();
            #else
                FunkinLua.luaTrace('getScreenInfo: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
                return null;
            #end
        });

        Lua_helper.add_callback(lua, "getScreenInfo", () -> { // for what
            #if ScreenInfo_LUA_EXTENSIONS
                return ScreenInfo.getScreenInfo();
            #else
                FunkinLua.luaTrace('getScreenInfo: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
                return null;
            #end
        });
    }
    #end
}