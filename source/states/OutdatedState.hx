package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class OutdatedState extends MusicBeatState {
    private static var leftState:Bool = false;
    private var warnText:FlxText;

    override function create() {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
        
        super.create();
        createBackground();
        createWarningText();
    }

    private function createBackground() {
        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);
    }

    private function createWarningText() {
        warnText = new FlxText(0, 0, FlxG.width,
			"Hey there! It seems \n you're using an outdated version of Psych Engine (version " + MainMenuState.psychEngineVersion + ").\n" +
			"Please consider updating to version " + TitleState.updateVersion + "!\n" +
			"You can press ESCAPE to continue anyway.\n\n" +
			"Thanks for being a part of our community!",
            32
        );

        warnText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
        warnText.screenCenter(Y);
        add(warnText);
    }

    override function update(elapsed:Float) {
        if (!leftState) {
            handleInput();
        }
        super.update(elapsed);
    }

    private function handleInput() {
        if (controls.ACCEPT) {
            proceedToUpdate();
        } else if (controls.BACK) {
            cancelState();
        }
    }

    private function proceedToUpdate() {
        leftState = true;
        CoolUtil.browserLoad("https://github.com/ShadowMario/FNF-PsychEngine/releases");
        fadeOutWarningText();
    }

    private function cancelState() {
        leftState = true;
        fadeOutWarningText();
    }

    private function fadeOutWarningText() {
        FlxG.sound.play(Paths.sound('cancelMenu'));
        FlxTween.tween(warnText, { alpha: 0 }, 1, {
            onComplete: function(twn:FlxTween) {
                MusicBeatState.switchState(new MainMenuState());
            }
        });
    }
}
