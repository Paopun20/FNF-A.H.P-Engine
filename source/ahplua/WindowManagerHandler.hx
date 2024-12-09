package ahplua;
import ahptool.WindowManager;

class WindowManagerHandler {
    #if LUA_ALLOWED
    private static var WindowManager = new WindowManager();

    // Register Lua callbacks for window management functions
    public static function addLuaCallbacks(lua:Dynamic):Void {
        Lua_helper.add_callback(lua, "createWindow", (title:String, width:Int = 800, height:Int = 600, resizable:Bool = true) -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    WindowManager.createWindow(title, width, height, resizable);
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                #end
            #else
                FunkinLua.luaTrace('WindowManager: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, "advanceCreateWindow", (data) -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    WindowManager.advanceCreateWindow(data);
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                #end
            #else
                FunkinLua.luaTrace('WindowManager: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, "closeWindow", (windowName:String) -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    WindowManager.closeWindow(windowName);
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                #end
            #else
                FunkinLua.luaTrace('WindowManager: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, "listWindows", () -> {
            #if WindowManager_LUA_EXTENSIONS
                return WindowManager.listWindows();  // Accessing static method directly from the class
            #else
                FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                return null;
            #end
        });

        Lua_helper.add_callback(lua, "getMainWindow", () -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    return WindowManager.getMainWindow();
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                    return null;
                #end
            #else
                FunkinLua.luaTrace('WindowManager [getMainWindow]: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, "getWindow", (windowName:String) -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    return WindowManager.getWindow(windowName);
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                    return null;
                #end
            #else
                FunkinLua.luaTrace('WindowManager: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, "closeAllWindows", () -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    WindowManager.closeAllWindows();
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                #end
            #else
                FunkinLua.luaTrace('WindowManager: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, "resizeWindow", (windowName:String, width:Int, height:Int) -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    WindowManager.resizeWindow(windowName, width, height);
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                #end
            #else
                FunkinLua.luaTrace('WindowManager: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, "minimizeWindow", (windowName:String) -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    WindowManager.minimizeWindow(windowName);
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                #end
            #else
                FunkinLua.luaTrace('WindowManager: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, "maximizeWindow", (windowName:String) -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    WindowManager.maximizeWindow(windowName);
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                #end
            #else
                FunkinLua.luaTrace('WindowManager: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, "restoreWindow", (windowName:String) -> {
            #if WindowManager_LUA_EXTENSIONS
                #if Window
                    WindowManager.restoreWindow(windowName);
                #else
                    FunkinLua.luaTrace('WindowManager: NOT SUPPORT', false, false, FlxColor.RED);
                #end
            #else
                FunkinLua.luaTrace('WindowManager: PPLUA EXTENSIONS HAS BE DISABLED', false, false, FlxColor.RED);
            #end
        });
    }
    #end
}
