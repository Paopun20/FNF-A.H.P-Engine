package ahplua;
import ahptool.GetArgs;

class GetArgsHandler {
    #if LUA_ALLOWED
    public static function addLuaCallbacks(lua:Dynamic):Void {
    if (lua == null) {
        throw "Lua object cannot be null.";
    }
        Lua_helper.add_callback(lua, "appGetArgs", function() {
            #if GetArgs_LUA_EXTENSIONS
                return GetArgs.getArgs();
            #else
                FunkinLua.luaTrace('GetArgs: LUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
                return null;
            #end
        });
    }
    #end
}