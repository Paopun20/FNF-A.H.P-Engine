package ahplua;
import ahptool.*;

class AHPLua {
  // PPTOOL Lua [Advanced Lua + Danger Lua]
  public static function addLuaCallbacks(lua) {
    HttpClientHandler.addLuaCallbacks(lua);
    ScreenInfoHandler.addLuaCallbacks(lua);
    WindowManagerHandler.addLuaCallbacks(lua);
    BrainFuckHandler.addLuaCallbacks(lua);
    LuaJsonHelperHandler.addLuaCallbacks(lua);
    UrlGenHandler.addLuaCallbacks(lua);
  }
}