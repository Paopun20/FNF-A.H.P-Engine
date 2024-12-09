package ahplua;
import ahptool.HttpClient;

class HttpClientHandler {
    #if LUA_ALLOWED
    /**
     * Adds Lua callbacks to interface with Haxe HTTP methods.
     */
    public static function addLuaCallbacks(lua: Dynamic): Void {
        // Add callback for checking internet connectivity
        Lua_helper.add_callback(lua, "httpHasInternet", function(): Bool {
            #if HttpClient_LUA_EXTENSIONS
            return runSync(function(callback) {
                HttpClient.hasInternet(callback);
            });
            #else
            FunkinLua.luaTrace('HttpClient: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });

        // Add callback for sending GET requests
        Lua_helper.add_callback(lua, "httpGet", function(url: String, headers: Dynamic = null, queryParams: Dynamic = null): Dynamic {
            #if HttpClient_LUA_EXTENSIONS
            return runSync(function(callback) {
                HttpClient.getRequest(url, function(success, response) {
                    callback({ success: success, response: response });
                }, headers, queryParams);
            });
            #else
            FunkinLua.luaTrace('HttpClient : PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });

        // Add callback for sending POST requests
        Lua_helper.add_callback(lua, "httpPost", function(url: String, data: Dynamic, headers: Dynamic = null, queryParams: Dynamic = null): Dynamic {
            var luaData = LuaJsonHelper.JSONDecode(data);
            #if HttpClient_LUA_EXTENSIONS
            return runSync(function(callback) {
                HttpClient.postRequest(url, luaData, function(success, response) {
                    callback({ success: success, response: response });
                }, headers, queryParams);
            });
            #else
            FunkinLua.luaTrace('HttpClient : PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });

        // Add callback for sending PUT requests
        Lua_helper.add_callback(lua, "httpPut", function(url: String, data: Dynamic, headers: Dynamic = null, queryParams: Dynamic = null): Dynamic {
            var luaData = LuaJsonHelper.JSONDecode(data);
            #if HttpClient_LUA_EXTENSIONS
            return runSync(function(callback) {
                HttpClient.putRequest(url, luaData, function(success, response) {
                    callback({ success: success, response: response });
                }, headers, queryParams);
            });
            #else
            FunkinLua.luaTrace('HttpClient : PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });

        // Add callback for sending DELETE requests
        Lua_helper.add_callback(lua, "httpDelete", function(url: String, headers: Dynamic = null, queryParams: Dynamic = null): Dynamic {
            #if HttpClient_LUA_EXTENSIONS
            return runSync(function(callback) {
                HttpClient.deleteRequest(url, function(success, response) {
                    callback({ success: success, response: response });
                }, headers, queryParams);
            });
            #else
            FunkinLua.luaTrace('HttpClient : PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            return null;
            #end
        });
    }
    #end // This is the closing #end for LUA_ALLOWED block

    /**
     * Run asynchronous code synchronously using a coroutine-like mechanism.
     */
    #if HttpClient_LUA_EXTENSIONS
    private static function runSync(asyncFunc: (Dynamic -> Void) -> Void): Dynamic {
        var result: Dynamic = null;
        var completed = false;

        // Execute the asynchronous function
        asyncFunc(function(res: Dynamic) {
            result = res;
            completed = true;
        });

        // Wait for the asynchronous operation to complete
        while (!completed) {
            Sys.sleep(0);  // Slight delay to prevent busy-waiting
        }

        return result;
    }
    #end
}