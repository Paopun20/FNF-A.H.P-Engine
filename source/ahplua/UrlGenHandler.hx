package ahplua;

import ahptool.UrlGen;
import flixel.util.FlxColor;

class UrlGenHandler {
    static var tagUrlGen: Map<String, UrlGen> = new Map();

    /**
     * Adds Lua callbacks for URL generation functionality.
     * Registers Lua functions for creating, modifying, and accessing UrlGen objects.
     * @param lua The Lua object to register the callbacks with.
     */
    #if LUA_ALLOWED
    public static function addLuaCallbacks(lua: Dynamic): Void {
        if (lua == null) {
            throw "Lua object cannot be null.";
        }
        // Create a new UrlGen object
        Lua_helper.add_callback(lua, "makeUrlGen", (tag: String, url: String) -> {
            #if UrlGen_LUA_EXTENSIONS
            if (url == null || url == "") {
                FunkinLua.luaTrace('UrlGen: Invalid or empty URL provided', false, false, FlxColor.RED);
                return null;
            }

            try {
                var urlGen = new UrlGen(url);
                tagUrlGen.set(tag, urlGen);
                FunkinLua.luaTrace('UrlGen: Successfully created UrlGen object for tag: ' + tag, true, false, FlxColor.GREEN);
                return tag;
            } catch (e: Dynamic) {
                FunkinLua.luaTrace('UrlGen: Error creating UrlGen object: ' + e.toString(), false, false, FlxColor.RED);
                return null;
            }
            #else
            FunkinLua.luaTrace('UrlGen: LUA EXTENSIONS HAS BEEN DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });

        // Append a query parameter to the UrlGen object
        Lua_helper.add_callback(lua, "appendQueryUrlGen", (tag: String, key: String, value: String) -> {
            #if UrlGen_LUA_EXTENSIONS
            if (!tagUrlGen.exists(tag)) {
                FunkinLua.luaTrace('UrlGen: No UrlGen object found for tag: ' + tag, false, false, FlxColor.YELLOW);
                return false;
            }

            var urlGen = tagUrlGen.get(tag);
            urlGen.addQueryParam(key, value); // Update to match the UrlGen class's method
            FunkinLua.luaTrace('UrlGen: Appended query parameter to tag: ' + tag, true, false, FlxColor.GREEN);
            return true;
            #else
            FunkinLua.luaTrace('UrlGen: LUA EXTENSIONS HAS BEEN DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });

        // Append a path segment to the UrlGen object
        Lua_helper.add_callback(lua, "appendPathUrlGen", (tag: String, segment: String) -> {
            #if UrlGen_LUA_EXTENSIONS
            if (!tagUrlGen.exists(tag)) {
                FunkinLua.luaTrace('UrlGen: No UrlGen object found for tag: ' + tag, false, false, FlxColor.YELLOW);
                return false;
            }

            var urlGen = tagUrlGen.get(tag);
            urlGen.addPathSegment(segment); // Update to match the UrlGen class's method
            FunkinLua.luaTrace('UrlGen: Appended path segment to tag: ' + tag, true, false, FlxColor.GREEN);
            return true;
            #else
            FunkinLua.luaTrace('UrlGen: LUA EXTENSIONS HAS BEEN DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });

        // Retrieve the generated URL from the UrlGen object
        Lua_helper.add_callback(lua, "getUrlGen", (tag: String) -> {
            #if UrlGen_LUA_EXTENSIONS
            if (!tagUrlGen.exists(tag)) {
                FunkinLua.luaTrace('UrlGen: No UrlGen object found for tag: ' + tag, false, false, FlxColor.YELLOW);
                return null;
            }

            var urlGen = tagUrlGen.get(tag);
            return urlGen.generate();
            #else
            FunkinLua.luaTrace('UrlGen: LUA EXTENSIONS HAS BEEN DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });

        // Clear the UrlGen object for a given tag
        Lua_helper.add_callback(lua, "clearUrlGen", (tag: String) -> {
            #if UrlGen_LUA_EXTENSIONS
            if (!tagUrlGen.remove(tag)) {
                FunkinLua.luaTrace('UrlGen: No UrlGen object to clear for tag: ' + tag, false, false, FlxColor.YELLOW);
                return false;
            }

            FunkinLua.luaTrace('UrlGen: Successfully cleared UrlGen object for tag: ' + tag, true, false, FlxColor.GREEN);
            return true;
            #else
            FunkinLua.luaTrace('UrlGen: LUA EXTENSIONS HAS BEEN DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });
    }
    #end
}
