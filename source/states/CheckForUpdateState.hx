package states;

import flixel.*;
import ahptool.HttpClient;
import ahptool.*;
import flixel.*;
import flixel.effects.*;
import lime.*;

class CheckForUpdateState extends MusicBeatState {
    private var statusText:FlxText;
    private var isUpdateAvailable:Bool = false;

    override function create() {
        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;
        ClientPrefs.loadPrefs();
        super.create();
        
        createBackground();
        createWarningText("Looking for the latest version...");
        // Check for updates if enabled in preferences
        if (ClientPrefs.data.checkForUpdates) {
            new FlxTimer().start(1, function (tmr:FlxTimer) {
                checkForUpdate();
            });
        } else {
            statusText.text = "Skipping update check as per your settings...";
            fadeOutAndSwitchState(new TitleState());
        }
    }

    // Compares online version with the local version
    private function isNewVersionAvailable(localVersion:String, onlineVersion:String):Bool {
        return onlineVersion != localVersion;
    }

    // Performs the update check by fetching the version file
    private function checkForUpdate():Void {
        HttpClient.getRequest("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt", onUpdateCheckResponse);
    }

    // Handles the update check response and updates the status text
    private function onUpdateCheckResponse(succeed:Bool, data:String):Void {
        if (succeed) {
            var onlineVersion = data.split('\n')[0].trim();
            var localVersion = MainMenuState.psychEngineVersion.trim();

            if (isNewVersionAvailable(localVersion, onlineVersion)) {
                isUpdateAvailable = true;
                statusText.text = "Your version: ${localVersion}\nNew version [${onlineVersion}] available!";
            } else {
                statusText.text = "You’re up-to-date!";
                fadeOutAndSwitchState(new TitleState());
            }
        } else {
            showError();
        }
    }

    // Displays an error message when the update check fails
    private function showError():Void {
        statusText.text = "Update check failed. Please try again later.";
        fadeOutAndSwitchState(new TitleState());
    }

    // Creates a black background for the update state screen
    private function createBackground():Void {
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);
    }

    // Creates and sets up the warning text on the screen
    private function createWarningText(initialText:String):Void {
        statusText = new FlxText(0, 0, FlxG.width, initialText, 32);
        statusText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
        statusText.screenCenter(Y);
        add(statusText);
    }

    // Handles user input for ACCEPT and BACK actions
    override function update(elapsed:Float):Void {
        if (isUpdateAvailable && controls.ACCEPT) {
            CoolUtil.browserLoad("https://github.com/ShadowMario/FNF-PsychEngine/releases");
            fadeOutAndSwitchState(new TitleState());
        } else if (controls.BACK) {
            fadeOutAndSwitchState(new TitleState());
        }
        super.update(elapsed);
    }

    // Fades out the current text and switches to a new state
    private function fadeOutAndSwitchState(state:MusicBeatState):Void {
        FlxTween.tween(statusText, { alpha: 0 }, 2, {
            onComplete: function(_) {
                FlxTransitionableState.skipNextTransIn = false;
                FlxTransitionableState.skipNextTransOut = false;
                MusicBeatState.switchState(state);
            }
        });
    }
}
