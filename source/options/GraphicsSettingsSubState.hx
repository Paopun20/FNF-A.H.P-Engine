package options;

import objects.Character;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;
	public function new()
	{
		title = Language.getPhrase('graphics_menu', 'Graphics Settings');
		rpcTitle = 'Graphics Settings Menu'; //for Discord Rich Presence

		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		boyfriend.animation.finishCallback = function (name:String) boyfriend.dance();
		boyfriend.visible = false;

		// Example Option for "Low Quality" setting, which is the simplest case
		var option: Option = new Option(
		    'Low Quality',  // Option name
		    'When enabled, reduces some background details to improve performance and decrease loading times.', // Description
		    'lowQuality',  // Save data variable name
		    BOOL  // Variable type
		);
		addOption(option);
		
		// Option for Anti-Aliasing setting
		var option: Option = new Option(
		    'Anti-Aliasing', 
		    'When disabled, anti-aliasing is turned off, which improves performance at the cost of slightly sharper visuals.', 
		    'antialiasing', 
		    BOOL
		);
		option.onChange = onChangeAntiAliasing; // Optional callback for special interactions when the option changes
		addOption(option);
		antialiasingOption = optionsArray.length - 1;
		
		// Option for Shader settings
		var option: Option = new Option(
		    'Shaders', // Option name
		    'Disables shaders when unchecked. Shaders are used for visual effects, but can be CPU-intensive on weaker PCs.', // Description
		    'shaders', 
		    BOOL
		);
		addOption(option);
		
		// Option for GPU Caching
		var option: Option = new Option(
		    'GPU Caching', // Option name
		    'When enabled, the GPU will cache textures, reducing RAM usage. However, avoid using this on systems with low-end graphics cards.', // Description
		    'cacheOnGPU', 
		    BOOL
		);
		addOption(option);
		
		#if !html5 // Disabling framerate adjustments due to potential issues on browsers
		var option: Option = new Option(
		    'Framerate', 
		    'Adjusts the game’s frame rate. This setting may not work properly in browsers due to V-Sync settings or other restrictions.', 
		    'framerate', 
		    INT
		);
		addOption(option);

		final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
		option.minValue = 1;
		option.maxValue = 1000;
		option.defaultValue = Std.int(FlxMath.bound(refreshRate, option.minValue, option.maxValue));
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		super();
		insert(1, boyfriend);
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:FlxSprite = cast sprite;
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		boyfriend.visible = (antialiasingOption == curSelected);
	}
}