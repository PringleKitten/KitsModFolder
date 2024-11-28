package options;

class PringlekittenSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		rpcTitle = 'Pringlekitten\'s Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Asset Movement', //Name
			'If checked, allows scripts to move parts of the game.', //Description
			'assetMovement', //Save data variable name
			BOOL); //Variable type
		addOption(option);

		var option:Option = new Option('Mechanics',
			'If checked, certain mechanics like dodging will be enabled.',
			'mechanics',
			BOOL);
		addOption(option);

		var option:Option = new Option('Health Drain',
			"If checked, your health will drain while\nopponent is playing.",
			'healthDrain',
			BOOL);
		addOption(option);

		var option:Option = new Option('Bad Rating Penalty',
			"If checked, If you have a bad rating, misses\nwill hurt more.",
			'ratingPenalty',
			BOOL);
		addOption(option);

		super();
	}
}