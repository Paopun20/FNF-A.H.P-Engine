package options;

import objects.Character;

class DebugSettingsSubState extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;
	public function new()
	{
		title = Language.getPhrase('gebug_menu', 'Debug Settings');
		rpcTitle = 'Debug Settings Menu'; //for Discord Rich Presence
		
		// Option for Shader settings
		var option: Option = new Option(
		    'Advance Debug', // Option name
		    'For Creator only', // Description
		    'ahp_debug', 
		    BOOL
		);
		addOption(option);

		super();
	}
}