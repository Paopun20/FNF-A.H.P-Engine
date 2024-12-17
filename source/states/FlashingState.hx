package states;

import flixel.FlxSubState;
import flixel.effects.FlxFlicker;
import lime.app.Application;

class FlashingState extends MusicBeatState {
    public static var leftState:Bool = false;

    var warnText:FlxText;

    override function create() {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();
        super.create();

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        warnText = new FlxText(0, 0, FlxG.width,
            "Warning: This mod contains flashing lights!\n" +
            "Press ENTER to disable them now, or go to the Options Menu for further adjustments.\n" +
            "Press ESCAPE to dismiss this message.\n" +
            "You’ve been warned!"
        );
        warnText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
        warnText.screenCenter(Y);
        add(warnText);
    }

    override function update(elapsed:Float) {
        if (!leftState) {
            var back:Bool = controls.BACK;
            
            // Check if the user pressed ACCEPT or BACK
            if (controls.ACCEPT || back) {
                leftState = true;
                FlxTransitionableState.skipNextTransIn = true;
                FlxTransitionableState.skipNextTransOut = true;
                
                // Handle Enter (Accept)
                if (!back) {
                    ClientPrefs.data.flashing = false;
                    ClientPrefs.saveSettings();
                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    
                    // Flicker text and transition
                    FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
                        new FlxTimer().start(0.5, function (tmr:FlxTimer) {
                            MusicBeatState.switchState(new TitleState());
                        });
                    });
                } else {
                    // Handle Escape (Back)
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    FlxTween.tween(warnText, {alpha: 0}, 1, {
                        onComplete: function (twn:FlxTween) {
                            MusicBeatState.switchState(new TitleState());
                        }
                    });
                }
            }
        }

        super.update(elapsed);
    }
}
