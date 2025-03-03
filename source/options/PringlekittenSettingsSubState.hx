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

		var option:Option = new Option('Dodging',
			'If checked, dodging is enabled.',
			'mechanics',
			BOOL);
		addOption(option);

		var option:Option = new Option('Extra Mechanics',
			'If checked, certain mechanics like HIT THAT KEY will be enabled.',
			'mechanicsAgain',
			BOOL);
		addOption(option);

		var option:Option = new Option('Health Drain',
			"If checked, your health will drain\nwhile opponent is playing.",
			'healthDrain',
			BOOL);
		addOption(option);

		var option:Option = new Option('Bad Rating Penalty',
			"If checked, your health will change based on\n how accurate you hit(Kade Engine).",
			'ratingPenalty',
			BOOL);
		addOption(option);

		var option:Option = new Option('Osu Sustain Input',
			"If checked, you will have to let go on time of when the sustain of the note ends.",
			'osuSustainInput',
			BOOL);
		addOption(option);
		
		var option:Option = new Option('Mobile Buttons',
			'0 = Off, 1 = On, 2 = Default by Installation',
			'mobileChoice',
			INT);
		option.displayFormat = '%v';
		option.minValue = 0;
		option.maxValue = 2;
		addOption(option);	

		super();
	}
}