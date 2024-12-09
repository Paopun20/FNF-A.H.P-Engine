package backend;

#if DISCORD_ALLOWED
import Sys.sleep;
import sys.thread.Thread;
import lime.app.Application;
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import flixel.util.FlxStringUtil;

class DiscordClient {
    public static var isInitialized:Bool = false;
    private inline static final _defaultID:String = "1208439718233243719";
    public static var clientID(default, set):String = _defaultID;
    private static var presence:DiscordPresence = new DiscordPresence();
    @:unreflective private static var __thread:Thread;

    public static function check() {
        ClientPrefs.data.discordRPC ? initialize() : shutdownIfInitialized();
    }

    public static function prepare() {
        if (!isInitialized && ClientPrefs.data.discordRPC) initialize();
        Application.current.window.onClose.add(() -> shutdownIfInitialized());
    }

    public dynamic static function shutdown() {
        isInitialized = false;
        Discord.Shutdown();
    }

    private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void {
        var user = cast(request[0].username, String);
        var discriminator = cast(request[0].discriminator, String);
        trace('(Discord) Connected to User ' + (discriminator != '0' ? '($user#$discriminator)' : '($user)'));
        changePresence();
    }

    private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void {
        trace('Discord: Error ($errorCode: ${cast(message, String)})');
    }

    private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void {
        trace('Discord: Disconnected ($errorCode: ${cast(message, String)})');
    }

    public static function initialize() {
        if (!isInitialized) {
            trace("Discord Client initialized");
            setupDiscordHandlers();
            startUpdateThread();
            isInitialized = true;
        }
    }

    public static function changePresence(details:String = 'In the Menus', ?state:String, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float, largeImageKey:String = 'icon') {
        var startTimestamp = hasStartTimestamp ? Date.now().getTime() / 1000 : 0;
        presence.configurePresence(state, details, smallImageKey, largeImageKey, startTimestamp, endTimestamp);
        updatePresence();
    }

    public static function updatePresence() {
        Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence.__presence));
    }

    inline public static function resetClientID() {
        clientID = _defaultID;
    }

    private static function set_clientID(newID:String) {
        if (clientID != newID) {
            clientID = newID;
            if (isInitialized) restartClient();
        }
        return newID;
    }

    private static function restartClient() {
        shutdown();
        initialize();
        updatePresence();
    }

    private static function setupDiscordHandlers() {
        var discordHandlers = DiscordEventHandlers.create();
        discordHandlers.ready = cpp.Function.fromStaticFunction(onReady);
        discordHandlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
        discordHandlers.errored = cpp.Function.fromStaticFunction(onError);
        Discord.Initialize(clientID, cpp.RawPointer.addressOf(discordHandlers), 1, null);
    }

    private static function startUpdateThread() {
        if (__thread == null) {
            __thread = Thread.create(() -> {
                while (true) {
                    if (isInitialized) {
                        #if DISCORD_DISABLE_IO_THREAD
                        Discord.UpdateConnection();
                        #end
                        Discord.RunCallbacks();
                    }
                    Sys.sleep(1.0);
                }
            });
        }
    }

    private static function shutdownIfInitialized() {
        if (isInitialized) shutdown();
    }

    #if MODS_ALLOWED
    public static function loadModRPC() {
        var pack = Mods.getPack();
        if (pack != null && pack.discordRPC != clientID) clientID = pack.discordRPC;
    }
    #end

    #if LUA_ALLOWED
    public static function addLuaCallbacks(lua:State) {
        Lua_helper.add_callback(lua, "changeDiscordPresence", changePresence);
        Lua_helper.add_callback(lua, "changeDiscordClientID", function(?newID:String) {
            clientID = newID != null ? newID : _defaultID;
        });
    }
    #end
}

@:allow(backend.DiscordClient)
private final class DiscordPresence {
    public var state(get, set):String;
    public var details(get, set):String;
    public var smallImageKey(get, set):String;
    public var largeImageKey(get, set):String;
    public var largeImageText(get, set):String;
    public var startTimestamp(get, set):Int;
    public var endTimestamp(get, set):Int;

    @:noCompletion private var __presence:DiscordRichPresence = DiscordRichPresence.create();

    function new() {}

    public function configurePresence(state:String, details:String, smallImageKey:String, largeImageKey:String, startTimestamp:Float, endTimestamp:Float) {
        this.state = state;
        this.details = details;
        this.smallImageKey = smallImageKey;
        this.largeImageKey = largeImageKey;
        this.largeImageText = "Engine Version: " + states.MainMenuState.psychEngineVersion;
        this.startTimestamp = Std.int(startTimestamp);
        this.endTimestamp = Std.int(endTimestamp / 1000);
    }

    public function toString():String {
        return FlxStringUtil.getDebugString([
            LabelValuePair.weak("state", state),
            LabelValuePair.weak("details", details),
            LabelValuePair.weak("smallImageKey", smallImageKey),
            LabelValuePair.weak("largeImageKey", largeImageKey),
            LabelValuePair.weak("largeImageText", largeImageText),
            LabelValuePair.weak("startTimestamp", startTimestamp),
            LabelValuePair.weak("endTimestamp", endTimestamp)
        ]);
    }

	@:noCompletion inline function get_state():String
		{
			return __presence.state;
		}
	
		@:noCompletion inline function set_state(value:String):String
		{
			return __presence.state = value;
		}
	
		@:noCompletion inline function get_details():String
		{
			return __presence.details;
		}
	
		@:noCompletion inline function set_details(value:String):String
		{
			return __presence.details = value;
		}
	
		@:noCompletion inline function get_smallImageKey():String
		{
			return __presence.smallImageKey;
		}
	
		@:noCompletion inline function set_smallImageKey(value:String):String
		{
			return __presence.smallImageKey = value;
		}
	
		@:noCompletion inline function get_largeImageKey():String
		{
			return __presence.largeImageKey;
		}
		
		@:noCompletion inline function set_largeImageKey(value:String):String
		{
			return __presence.largeImageKey = value;
		}
	
		@:noCompletion inline function get_largeImageText():String
		{
			return __presence.largeImageText;
		}
	
		@:noCompletion inline function set_largeImageText(value:String):String
		{
			return __presence.largeImageText = value;
		}
	
		@:noCompletion inline function get_startTimestamp():Int
		{
			return __presence.startTimestamp;
		}
	
		@:noCompletion inline function set_startTimestamp(value:Int):Int
		{
			return __presence.startTimestamp = value;
		}
	
		@:noCompletion inline function get_endTimestamp():Int
		{
			return __presence.endTimestamp;
		}
	
		@:noCompletion inline function set_endTimestamp(value:Int):Int
		{
			return __presence.endTimestamp = value;
		}
}
#end
