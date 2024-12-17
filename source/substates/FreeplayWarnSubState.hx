package substates;
// GIVE UP :(

import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

class FreeplayWarnSubState extends MusicBeatSubstate {
    private var bg:FlxSprite;
    private var alphabetArray:Array<Alphabet> = [];
    private var onYes:Bool = false;
    private var yesText:Alphabet;
    private var noText:Alphabet;

    private var song:String;
    private var functionOnAccept:Dynamic;

    public var isAccept:Bool = false;

    public function new(song:String, ?warntxt:String = "Are you sure you want to play this song?", ?functionOnAccept:Dynamic = null) {
        this.song = song;
        this.functionOnAccept = functionOnAccept;

        super();

        // Initialize background
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
        bg.scrollFactor.set();
        add(bg);

        // Initialize song name text
        var songNameText:Alphabet = new Alphabet(0, 180, '$song:$warntxt', true);
        add(songNameText);

        // Initialize Yes/No buttons
        yesText = createOptionButton("Yes", songNameText.y + 150, -200);
        noText = createOptionButton("No", songNameText.y + 150, 200);

        // Highlight initial selection
        updateOptions();
    }

    override function update(elapsed:Float):Void {
        // Fade in background and UI elements
        fadeInElements(elapsed);

        // Handle input for toggling and confirming
        handleInput();
        super.update(elapsed);
    }

    //override function destroy(values) {
    //    
    //}

    private function fadeInElements(elapsed:Float):Void {
        bg.alpha = Math.min(bg.alpha + elapsed * 1.5, 0.6);
        for (spr in alphabetArray) {
            spr.alpha = Math.min(spr.alpha + elapsed * 2.5, 1);
        }
    }

    private function handleInput():Void {
        if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
            FlxG.sound.play(Paths.sound("scrollMenu"), 1);
            onYes = !onYes;
            updateOptions();
        }

        if (controls.BACK) {
            FlxG.sound.play(Paths.sound("cancelMenu"), 1);
            invokeCallback(false);
            close();
        } else if (controls.ACCEPT) {
            FlxG.sound.play(Paths.sound("confirmMenu"), 1);
            invokeCallback(onYes);
            close();
        }
    }

    private function updateOptions():Void {
        var selectedIndex:Int = if (onYes) 1 else 0;
        updateButtonAppearance(yesText, selectedIndex == 1);
        updateButtonAppearance(noText, selectedIndex == 0);
    }

    private function invokeCallback(choice:Bool):Void {
        if (functionOnAccept != null) {
            functionOnAccept(choice);
        }
    }

    private function wrapText(content:String, maxLineLength:Int = 40):Array<String> {
        var words:Array<String> = content.split(" ");
        var lines:Array<String> = [];
        var currentLine:String = "";

        for (word in words) {
            if ((currentLine.length + word.length + 1) <= maxLineLength) {
                currentLine += (currentLine.length > 0 ? " " : "") + word;
            } else {
                lines.push(currentLine);
                currentLine = word;
            }
        }

        if (currentLine.length > 0) {
            lines.push(currentLine);
        }

        return lines;
    }

    private function createOptionButton(label:String, y:Float, offsetX:Float):Alphabet {
        var button:Alphabet = new Alphabet(0, y, Language.getPhrase(label), true);
        button.screenCenter(X);
        button.x += offsetX;
        button.alpha = 0.6;
        button.scale.set(0.75, 0.75);
        add(button);
        return button;
    }

    private function updateButtonAppearance(button:Alphabet, isSelected:Bool):Void {
        var scale:Float = isSelected ? 1 : 0.75;
        var alpha:Float = isSelected ? 1.25 : 0.6;
        button.scale.set(scale, scale);
        button.alpha = alpha;
    }
}
