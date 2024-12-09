package ahptool;

import lime.app.Application;
import lime.ui.Window;
import haxe.ds.StringMap;

class WindowManager {
    private var windows:StringMap<Window>;
    private static var _instance:WindowManager;

    public function new() {
        if (_instance != null) throw "WindowManager already initialized.";
        _instance = this;
        windows = new StringMap();
    }    

    private static function get_instance():WindowManager {
        return _instance ??= new WindowManager();
    }

    public function getMainWindow():Null<Window> {
        return Application.current.windows.length > 0 ? Application.current.windows[0] : null;
    }

    public function createWindow(title:String, width:Int = 800, height:Int = 600, resizable:Bool = true):Void {
        if (windows.exists(title)) {
            log('warn', 'Window \'$title\' already exists.');
            return;
        }
        var window = Application.current.createWindow({title: title, width: width, height: height, resizable: resizable});
        addEventListeners(window, title);
        windows.set(title, window);
    }

    public function advanceCreateWindow(data:Dynamic):Void {
        if (!data?.title || !data?.width || !data?.height) {
            log("error", "Missing fields (title, width, height).");
            return;
        }
        createWindow(data.title, data.width, data.height, data.resizable ?? true);
    }

    private function addEventListeners(window:Window, title:String):Void {
        window.onClose.add(() -> onWindowEvent(title, "closed"));
        window.onFocusIn.add(() -> onWindowEvent(title, "focusIn"));
        window.onFocusOut.add(() -> onWindowEvent(title, "focusOut"));
    }

    public function getWindow(windowName:String):Null<Window> {
        return windows.get(windowName);
    }

    public function closeWindow(windowName:String):Void {
        operateOnWindow(windowName, "close");
    }

    public function closeAllWindows():Void {
        for (title in windows.keys()) closeWindow(title);
    }

    public function listWindows():Array<String> {
        var result:Array<String> = [];
        for (key in windows.keys()) {
            result.push(key);
        }
        return result;
    }    

    public function resizeWindow(windowName:String, width:Int, height:Int):Void {
        operateOnWindow(windowName, "resize", width, height);
    }

    public function minimizeWindow(windowName:String):Void {
        operateOnWindow(windowName, "minimize");
    }

    public function maximizeWindow(windowName:String):Void {
        operateOnWindow(windowName, "maximize");
    }

    public function restoreWindow(windowName:String):Void {
        operateOnWindow(windowName, "restore");
    }

    private function operateOnWindow(windowName:String, action:String, width:Int = 0, height:Int = 0):Void {
        var window = getWindow(windowName);
        if (window == null) {
            log('error', 'No window found with title \'$windowName\'.');
            return;
        }
        switch(action) {
            case "close": 
                window.close(); 
                windows.remove(windowName);
            case "resize": 
                window.resize(width, height);
            case "minimize": 
                window.minimized = true;
            case "maximize": 
                window.maximized = true;
            case "restore": 
                window.minimized = false; 
                window.maximized = false;
        }
    }

    #if LUA_ALLOWED
    private function dispatchWindowEventToLua(name:String, event:String):Void {
        try {
            for (script in PlayState.instance.luaArray) {
                script.call("onWindowEvent", [name, event]);
            }
            log('info', 'Dispatched Lua method onWindowEvent for window $name with event $event.');
        } catch (e:Dynamic) {
            log('error', 'Failed to dispatch Lua method for $name on event $event: $e');
        }
    }
    #end
    #if HSCRIPT_ALLOWED
    private function dispatchWindowEventToHScript(name:String, event:String):Void {
        try {
            for (script in PlayState.instance.hscriptArray) {
                script.call("onWindowEvent", [name, event]);
            }
            log('info', 'Dispatched HScrip method onWindowEvent for window $name with event $event.');
        } catch (e:Dynamic) {
            log('error', 'Failed to dispatch HScrip method for $name on event $event: $e');
        }
    }
    #end
    
    private function onWindowEvent(windowName:String, event:String):Void {
        log('info', '$windowName $event.');
        switch (event) {
            case "closed": windows.remove(windowName);
            default:
                #if LUA_ALLOWED
                dispatchWindowEventToLua(windowName, event);
                #end
                #if HSCRIPT_ALLOWED
                dispatchWindowEventToHScript(windowName, event);
                #end
        }
    }    

    private function log(level:String, message:String):Void {
        trace('[${level.toUpperCase()}]: $message');
    }
}
