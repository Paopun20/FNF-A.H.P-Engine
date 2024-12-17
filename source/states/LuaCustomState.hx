package states;

// I dead for this code AAAAAAAAAAAAAAAAAAAAAAAAAAAAA

// [UNUES]

import psychlua.FunkinLua;
import psychlua.HScript;
import options.OptionsState;
import crowplexus.iris.Iris;
import backend.Mods;

class LuaCustomState extends MusicBeatState {
    public static var instance:LuaCustomState;

    #if LUA_ALLOWED
    public var luaArray:Array<FunkinLua> = [];
    #end

    #if HSCRIPT_ALLOWED
    public var hscriptArray:Array<HScript> = [];
    #end

    public function new(stateName:String) {
        super();
        instance = this;
        trace("LuaCustomState initialized.");

        if (!findLuaFolder(stateName)) {
            handleScriptsInStateFolder(stateName);
            return;
        }

        switch (stateName) {
            case 'story_mode': MusicBeatState.switchState(new StoryMenuState());
            case 'freeplay': MusicBeatState.switchState(new FreeplayState());
            #if MODS_ALLOWED case 'mods': MusicBeatState.switchState(new ModsMenuState()); #end
            #if ACHIEVEMENTS_ALLOWED case 'achievements': MusicBeatState.switchState(new AchievementsMenuState()); #end
            case 'credits': MusicBeatState.switchState(new CreditsState());
            case 'options': MusicBeatState.switchState(new OptionsState()); resetPlayState();
            default: throw "Unknown state: " + stateName;
        }
    }

    public static function findLuaFolder(stateName:String):Bool {
        trace("Checking for Lua folder for state: " + stateName);
        // Placeholder for Lua folder check logic
        return false;
    }

    private function handleScriptsInStateFolder(stateName:String):Void {
        try {
            // Iterate through all enabled mods
            for (mod in Mods.parseList().enabled) {
                var modPath = '$mod/state/' + stateName;
            }
        } catch (e:Dynamic) {
            trace('Error handling scripts in state folder for state: $stateName, Error: $e');
        }
    }    

    private static function resetPlayState():Void {
        if (PlayState.SONG != null) {
            PlayState.SONG.arrowSkin = null;
            PlayState.SONG.splashSkin = null;
            PlayState.stageUI = 'normal';
            trace("Reset PlayState properties.");
        }
    }

    public function initHScript(file:String):Void {
        try {
            var newScript = new HScript(null, file);
            newScript.executeFunction('onCreate');
            trace('Initialized HScript successfully: $file');
            hscriptArray.push(newScript);
        } catch (e:Dynamic) {
            var existingScript = cast (Iris.instances.get(file), HScript);
            existingScript?.destroy();
        }
    }

    private static function changeState(stateName:String):Void {
        trace("Changing state: " + stateName);
        MusicBeatState.switchState(new LuaCustomState(stateName));
    }

    private static function AddLuaRunTime(lua:Dynamic):Void {
        Lua_helper.add_callback(lua, "changeState", changeState);
    }
}
