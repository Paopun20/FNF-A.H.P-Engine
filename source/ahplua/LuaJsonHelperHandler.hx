package ahplua;
import ahptool.LuaJsonHelper;

class LuaJsonHelperHandler {
    #if LUA_ALLOWED
    public static function addLuaCallbacks(lua: Dynamic): Void {
        if (lua == null) {
            throw "Lua object cannot be null.";
        }
        Lua_helper.add_callback(lua, "JSONEncode", (input) -> {
            #if LuaJsonHelper_LUA_EXTENSIONS
                return LuaJsonHelper.JSONEncode(input);
            #else
                FunkinLua.luaTrace('LuaJsonHelper: LUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
                return null;
            #end
        });
        Lua_helper.add_callback(lua, "JSONDecode", (input) -> {
            #if LuaJsonHelper_LUA_EXTENSIONS
                return LuaJsonHelper.JSONDecode(input);
            #else
                FunkinLua.luaTrace('LuaJsonHelper: LUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
                return null;
            #end
        });
    }
    #end
}