package objects;

import flixel.addons.display.FlxPieDial;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

#if hxvlc
import hxvlc.flixel.FlxVideoSprite;
#end

class VideoSprite extends FlxSpriteGroup {
    #if VIDEOS_ALLOWED
    public var finishCallback:Void->Void = null;
    public var onSkip:Void->Void = null;

    private static inline final SKIP_TIME:Float = 1.0;

    public var holdingTime:Float = 0;
    public var videoSprite:FlxVideoSprite;
    public var skipSprite:FlxPieDial;
    public var cover:FlxSprite;
    public var canSkip(default, set):Bool = false;

    private var videoName:String;
    public var waiting:Bool = false;
    public var didPlay:Bool = false;

    private var alreadyDestroyed:Bool = false;

    public function new(videoName:String, isWaiting:Bool, canSkip:Bool = false, shouldLoop:Bool = false) {
        super();
        this.videoName = videoName;

        // Set camera and scroll
        scrollFactor.set();
        cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

        waiting = isWaiting;
        if (!waiting) {
            // Create a fullscreen cover
            cover = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
            cover.scale.set(FlxG.width + 100, FlxG.height + 100);
            cover.screenCenter();
            cover.scrollFactor.set();
            add(cover);
        }

        // Initialize the video sprite
        videoSprite = new FlxVideoSprite();
        videoSprite.antialiasing = ClientPrefs.data.antialiasing;
        add(videoSprite);

        if (canSkip) this.canSkip = true;

        if (!shouldLoop) {
            videoSprite.bitmap.onEndReached.add(onVideoEnd);
        }

        videoSprite.bitmap.onFormatSetup.add(adjustVideoSize);

        // Load video
        videoSprite.load(videoName, shouldLoop ? ['input-repeat=65545'] : null);
    }

    private function onVideoEnd() {
        if (alreadyDestroyed) return;

        trace('Video ended.');
        destroyCover();
        PlayState.instance.remove(this);
        destroy();
    }

    private function adjustVideoSize() {
        videoSprite.setGraphicSize(FlxG.width);
        videoSprite.updateHitbox();
        videoSprite.screenCenter();
    }

    override function destroy() {
        if (alreadyDestroyed) {
            super.destroy();
            return;
        }

        alreadyDestroyed = true;
        trace('Destroying VideoSprite.');

        destroyCover();
        destroySkipSprite();

        if (videoSprite != null) {
            videoSprite.bitmap.onEndReached.remove(onVideoEnd);
            remove(videoSprite);
            videoSprite.destroy();
        }

        if (finishCallback != null) finishCallback();
        finishCallback = null;
        onSkip = null;

        super.destroy();
    }

    private function destroyCover() {
        if (cover != null) {
            remove(cover);
            cover.destroy();
            cover = null;
        }
    }

    private function destroySkipSprite() {
        if (skipSprite != null) {
            remove(skipSprite);
            skipSprite.destroy();
            skipSprite = null;
        }
    }

    override function update(elapsed:Float) {
        if (canSkip) {
            if (Controls.instance.pressed('accept')) {
                holdingTime = Math.min(SKIP_TIME, holdingTime + elapsed);
            } else {
                holdingTime = Math.max(0, holdingTime - elapsed * 3);
            }

            updateSkipAlpha();

            if (holdingTime >= SKIP_TIME) {
                if (onSkip != null) onSkip();
                videoSprite.bitmap.onEndReached.dispatch();
                PlayState.instance.remove(this);
                trace('Video skipped.');
                return;
            }
        }

        super.update(elapsed);
    }

    function set_canSkip(newValue:Bool) {
        canSkip = newValue;
        if (canSkip && skipSprite == null) {
            // Create skip sprite
            skipSprite = new FlxPieDial(0, 0, 40, FlxColor.WHITE, 40, true, 24);
            skipSprite.replaceColor(FlxColor.BLACK, FlxColor.TRANSPARENT);
            skipSprite.x = FlxG.width - (skipSprite.width + 80);
            skipSprite.y = FlxG.height - (skipSprite.height + 72);
            skipSprite.amount = 0;
            add(skipSprite);
        } else if (!canSkip && skipSprite != null) {
            destroySkipSprite();
        }
        return canSkip;
    }

    private function updateSkipAlpha() {
        if (skipSprite == null) return;

        skipSprite.amount = Math.min(1, holdingTime / SKIP_TIME);
        skipSprite.alpha = FlxMath.remapToRange(skipSprite.amount, 0.025, 1, 0, 1);
    }

    public function resume() {
        videoSprite?.resume();
    }

    public function pause() {
        videoSprite?.pause();
    }
    #end
}
