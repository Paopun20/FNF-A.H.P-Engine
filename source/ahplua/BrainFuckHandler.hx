package ahplua;

import ahptool.BrainFuck;
import haxe.ds.IntMap;

class BrainFuckHandler {
    #if LUA_ALLOWED
    public static function addLuaCallbacks(lua: Dynamic): Void {
        if (lua == null) {
            throw "Lua object cannot be null.";
        }
        Lua_helper.add_callback(lua, "runBrainFuckCode", function(code: String, input = ""): String {
            #if BrainFuck_CYBER_LUA_EXTENSIONS
                var inputMap = new IntMap<Int>();
                try {
                    if (input != "") {
                        var inputValues = input.split(",").map(Std.parseInt);
                        for (i in 0...inputValues.length) {
                            inputMap.set(i, inputValues[i]);
                        }
                    }
                    return BrainFuck.runBrainfuck(code, inputMap);
                } catch (e: BrainFuck.BrainfuckError) {
                    return "Error: " + e.message;
                } catch (e: haxe.Exception) {
                    return "Error: " + e.message;
                }
            #else
                FunkinLua.luaTrace('BrainFuck: LUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
                return null;
            #end
        });
    }
    #end
}