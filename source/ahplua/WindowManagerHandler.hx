package ahplua;

import ahptool.WindowManager;
import lime.ui.WindowAttributes;
import Reflect;

class WindowManagerHandler {
    private static var windowManagerMap:Map<String, WindowManager> = new Map();

    #if LUA_ALLOWED
    public static function addLuaCallbacks(lua):Void {
        windowManagerMap = new Map();
        Lua_helper.add_callback(lua, 'makeWindow', (tag:String, attributes:WindowAttributes) -> {
            #if WindowManager_LUA_EXTENSIONS
            if (windowManagerMap.exists(tag)) {
                trace('Error: A WindowManager with the tag \'$tag\' already exists.');
                return;
            }
            if (!validateWindowAttributes(attributes)) {
                trace('Error: Invalid WindowAttributes provided.');
                return;
            }
            var window = new WindowManager(attributes);
            windowManagerMap.set(tag, window);
    
            trace('WindowManager with tag \'$tag\' created successfully.');
            #else
            FunkinLua.luaTrace('WindowManager: LUA EXTENSIONS HAS BEEN DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, 'destroyWindow', (tag:String) -> {
            #if WindowManager_LUA_EXTENSIONS
            if (!windowManagerMap.exists(tag)) {
                trace('Error: No WindowManager found with the tag \'$tag\' to destroy.');
                return;
            }
            var manager = windowManagerMap.get(tag);
            manager.getWindow().close(); // Close the window safely
            windowManagerMap.remove(tag); // Remove from the map
            trace('WindowManager with tag \'$tag\' destroyed successfully.');
            #else
            FunkinLua.luaTrace('WindowManager: LUA EXTENSIONS HAS BEEN DISABLED', false, false, FlxColor.RED);
            #end
        });

        Lua_helper.add_callback(lua, 'configWindow', (tag:String, variable:String, set:Dynamic) -> {
            #if WindowManager_LUA_EXTENSIONS
            if (!windowManagerMap.exists(tag)) {
                trace('Error: No WindowManager found with the tag \'$tag\'.');
                return;
            }

            var manager = windowManagerMap.get(tag);
            var window = manager.getWindow();

            try {
                Reflect.setProperty(window, variable, set);
                trace('WindowManager with tag \'$tag\' updated property \'$variable\' to \'${set}\'.');
            } catch (e:Dynamic) {
                trace('Error: Failed to update property \'$variable\' for tag \'$tag\'. Details: $e');
            }
            #else
            FunkinLua.luaTrace('WindowManager: LUA EXTENSIONS HAS BEEN DISABLED', false, false, FlxColor.RED);
            #end
        });
    }

    private static function onClosed(tag:String):Void {
        #if WindowManager_LUA_EXTENSIONS
        if (!windowManagerMap.exists(tag)) {
            trace('Error: No WindowManager found with the tag \'$tag\' to close.');
            return;
        }
        
        var manager = windowManagerMap.get(tag);
        manager.getWindow().close(); // Close the window safely
        windowManagerMap.remove(tag); // Remove it from the map
    
        trace('WindowManager with tag \'$tag\' closed and removed successfully.');
        #else
        FunkinLua.luaTrace('WindowManager: LUA EXTENSIONS HAS BEEN DISABLED', false, false, FlxColor.RED);
        #end
    }
    

    public static function getWindowManager(tag:String):WindowManager {
        if (!windowManagerMap.exists(tag)) {
            trace('Error: No WindowManager found with the tag \'$tag\'.');
            return null;
        }
        return windowManagerMap.get(tag);
    }

    private static function validateWindowAttributes(attributes:WindowAttributes):Bool {
        return attributes != null &&
               attributes.title != null && attributes.title != '' &&
               attributes.width > 0 &&
               attributes.height > 0;
    }
    #end
}
