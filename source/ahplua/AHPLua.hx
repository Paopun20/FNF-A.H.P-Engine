package ahplua;
import ahptool.*;

class AHPLua {
  // PPTOOL Lua [Advanced Lua + Danger Lua]
  public static function addLuaCallbacks(lua) {
    if (lua == null) {
      throw "Lua object cannot be null.";
    }
    
    HttpClientHandler.addLuaCallbacks(lua);
    ScreenInfoHandler.addLuaCallbacks(lua);
    WindowManagerHandler.addLuaCallbacks(lua);
    BrainFuckHandler.addLuaCallbacks(lua);
    LuaJsonHelperHandler.addLuaCallbacks(lua);
    UrlGenHandler.addLuaCallbacks(lua);
  }
}
