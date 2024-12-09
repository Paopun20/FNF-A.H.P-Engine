package backend;

import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepadManager;

class InputFormatter {
	// A helper method to format the key name in case it's not predefined.
	private static function formatKeyName(label:String):String {
		if (label.toLowerCase() == 'null') return '---';
		
		var arr:Array<String> = label.split('_');
		for (i in 0...arr.length) arr[i] = CoolUtil.capitalize(arr[i]);
		return arr.join(' ');
	}
	

    public static function getKeyName(key:FlxKey):String {
        switch (key) {
            case BACKSPACE: return "BckSpc";
            case CONTROL: return "Ctrl";
            case ALT: return "Alt";
            case CAPSLOCK: return "Caps";
            case PAGEUP: return "PgUp";
            case PAGEDOWN: return "PgDown";
            case ZERO: return "0";
            case ONE: return "1";
            case TWO: return "2";
            case THREE: return "3";
            case FOUR: return "4";
            case FIVE: return "5";
            case SIX: return "6";
            case SEVEN: return "7";
            case EIGHT: return "8";
            case NINE: return "9";
            case NUMPADZERO: return "#0";
            case NUMPADONE: return "#1";
            case NUMPADTWO: return "#2";
            case NUMPADTHREE: return "#3";
            case NUMPADFOUR: return "#4";
            case NUMPADFIVE: return "#5";
            case NUMPADSIX: return "#6";
            case NUMPADSEVEN: return "#7";
            case NUMPADEIGHT: return "#8";
            case NUMPADNINE: return "#9";
            case NUMPADMULTIPLY: return "#*";
            case NUMPADPLUS: return "#+";
            case NUMPADMINUS: return "#-";
            case NUMPADPERIOD: return "#.";
            case SEMICOLON: return ";";
            case COMMA: return ",";
            case PERIOD: return ".";
            case GRAVEACCENT: return "`";
            case LBRACKET: return "[";
            case RBRACKET: return "]";
            case QUOTE: return "'";
            case PRINTSCREEN: return "PrtScrn";
            case NONE: return '---';
			case F1: return "F1";
            case F2: return "F2";
            case F3: return "F3";
            case F4: return "F4";
            case F5: return "F5";
            case F6: return "F6";
            case F7: return "F7";
            case F8: return "F8";
            case F9: return "F9";
            case F10: return "F10";
            case F11: return "F11";
            case F12: return "F12";
            case TAB: return "Tab";
            default: return formatKeyName(Std.string(key));
        }
    }

    public static function getGamepadName(key:FlxGamepadInputID):String {
        var gamepad:FlxGamepad = FlxG.gamepads.firstActive;
        var model:FlxGamepadModel = gamepad != null ? gamepad.detectedModel : UNKNOWN;

        switch(key) {
            case LEFT_STICK_DIGITAL_LEFT: return "Left";
            case LEFT_STICK_DIGITAL_RIGHT: return "Right";
            case LEFT_STICK_DIGITAL_UP: return "Up";
            case LEFT_STICK_DIGITAL_DOWN: return "Down";
            case LEFT_STICK_CLICK: return getButtonLabel("L3", "LS", "Analog Click", model);
            case RIGHT_STICK_DIGITAL_LEFT: return "C. Left";
            case RIGHT_STICK_DIGITAL_RIGHT: return "C. Right";
            case RIGHT_STICK_DIGITAL_UP: return "C. Up";
            case RIGHT_STICK_DIGITAL_DOWN: return "C. Down";
            case RIGHT_STICK_CLICK: return getButtonLabel("R3", "RS", "C. Click", model);
            case DPAD_LEFT: return "D. Left";
            case DPAD_RIGHT: return "D. Right";
            case DPAD_UP: return "D. Up";
            case DPAD_DOWN: return "D. Down";
            case LEFT_SHOULDER: return getButtonLabel("L1", "LB", "L. Bumper", model);
            case RIGHT_SHOULDER: return getButtonLabel("R1", "RB", "R. Bumper", model);
            case LEFT_TRIGGER, LEFT_TRIGGER_BUTTON: return getButtonLabel("L2", "LT", "L. Trigger", model);
            case RIGHT_TRIGGER, RIGHT_TRIGGER_BUTTON: return getButtonLabel("R2", "RT", "R. Trigger", model);
            case A: return getButtonLabel("X", "A", "Action Down", model);
            case B: return getButtonLabel("O", "B", "Action Right", model);
            case X: return getButtonLabel("[", "X", "Action Left", model);
            case Y: return getButtonLabel("]", "Y", "Action Up", model);
            case BACK: return getButtonLabel("Share", "Back", "Select", model);
            case START: return model == PS4 ? "Options" : "Start";
            case NONE: return '---';
            default: return formatKeyName(Std.string(key));
        }
    }

    private static function getButtonLabel(ps4Label:String, xinputLabel:String, defaultLabel:String, model:FlxGamepadModel):String {
        switch (model) {
            case PS4: return ps4Label;
            case XINPUT: return xinputLabel;
            default: return defaultLabel;
        }
    }
}
