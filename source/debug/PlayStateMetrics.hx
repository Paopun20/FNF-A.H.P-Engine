package debug;

import flixel.FlxG;
import states.PlayState;
import backend.WeekData;
import backend.Song;
import backend.Paths;
import backend.Conductor;
import haxe.Exception;

class PlayStateMetrics {
    /**
     * Creates and starts a thread using the provided function.
     *
     * @param faa A function to run in a separate thread.
     * @return The created thread instance.
     * @throws haxe.Exception If thread creation fails.
     */

    /**
     * Retrieves debugging information about the current PlayState instance.
     *
     * @param state The state to fetch debugging information for.
     * @return A string containing the debugging data.
     */
    public static function getDebugInfo(state: Dynamic): String {
        if (Type.getClassName(Type.getClass(state)) != 'states.PlayState') return '';

        var game = PlayState.instance;
        var text = '';
        text += '\n---PlayState Data---';
        text += '\ncurBpm: ${Conductor.bpm}';
        text += '\nbpm: ${PlayState.SONG.bpm}';
        text += '\nscrollSpeed: ${PlayState.SONG.speed}';
        text += '\ncrochet: ${Conductor.crochet}';
        text += '\nstepCrochet: ${Conductor.stepCrochet}';
        text += '\nsongLength: ${FlxG.sound.music.length}';
        text += '\nsongName: ${PlayState.SONG.song}';
        text += '\nsongPath: ${Paths.formatToSongPath(PlayState.SONG.song)}';
        text += '\nloadedSongName: ${Song.loadedSongName}';
        text += '\nloadedSongPath: ${Paths.formatToSongPath(Song.loadedSongName)}';
        text += '\nchartPath: ${Song.chartPath}';
        text += '\ncurStage: ${PlayState.SONG.stage}';
        text += '\nisStoryMode: ${PlayState.isStoryMode}';
        text += '\nstoryDifficulty: ${PlayState.storyDifficulty}';
        text += '\nstoryWeek: ${PlayState.storyWeek}';
        text += '\nweeksList: ${WeekData.weeksList[PlayState.storyWeek]}';
        text += '\nseenCutscene: ${PlayState.seenCutscene}';
        text += '\nneedsVoices: ${PlayState.SONG.needsVoices}';
        text += '\n---FunkinLua Data File---';
        text += '\nLua Array Count: ${game.luaArray.length}';
        text += '\nHscript Array Count: ${game.hscriptArray.length}';

        // Lua Array Information
        //var luaInfo = getLuaArrayInfo(game);
        //var hInfo = getHArrayInfo(game);
        //text += '\n' + luaInfo;
        //text += hInfo;

        return text;
    }

    /**
     * Gathers Lua array information from the game instance.
     *
     * @param game The PlayState instance.
     * @return A string containing Lua array data.
     */
     private static function getLuaArrayInfo(game: PlayState): String {
        var output = 'Lua Array: [';
        for (lua in game.luaArray) {
            output += lua.getVar('scriptName') + ',';
        }
        if (output.length > 'Lua Array: ['.length) {
            output = output.substr(0, output.length - 1); // Remove trailing comma
        }
        output += ']\n';
        return output;
    }
    private static function getHArrayInfo(game: PlayState): String {
        var output = 'Hscript Array: [';
        for (hscript in game.hscriptArray) {
            output += hscript + ',';
        }
        if (output.length > 'Hscript Array: ['.length) {
            output = output.substr(0, output.length - 1); // Remove trailing comma
        }
        output += ']\n';
        return output;
    }
}
