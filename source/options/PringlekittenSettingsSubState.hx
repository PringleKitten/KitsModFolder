package options;

class PringlekittenSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		rpcTitle = 'Pringlekitten\'s Settings Menu';

		var option:Option = new Option('Asset Movement',
			'Allows scripts to move parts of the game.',
			'assetMovement',
			BOOL);
		addOption(option);

		var option:Option = new Option('Even Lower Quality',
			"Game will run with even less objects\n Even when combined with Low Quality",
			'ldm',
			BOOL);
		addOption(option);

		var option:Option = new Option('Camera Movement',
			"The camera moves when hitting notes",
			'camMovement',
			BOOL);
		addOption(option);

		var option:Option = new Option('Dodging',
			'Dodging is enabled. (Special Songs that use it)',
			'mechanics',
			BOOL);
		addOption(option);

		var option:Option = new Option('Extra Mechanics',
			'Certain mechanics like HIT THAT KEY will be enabled.',
			'mechanicsAgain',
			BOOL);
		addOption(option);

		var option:Option = new Option('Health Drain',
			"Your health will drain when opponent plays.",
			'healthDrain',
			BOOL);
		addOption(option);

		var option:Option = new Option('Bad Rating Penalty',
			"Your health will hurt more\n the worse rating you hit for a note(Kade Engine).\n (+50 Score Each Hit)",
			'ratingPenalty',
			BOOL);
		addOption(option);

		var option:Option = new Option('Low Accuracy Penalty',
			"Your health will hurt more\n the lower your Accuracy is.\n (+30 Score Each Hit)",
			'lowPercentHurt',
			BOOL);
		addOption(option);

		var option:Option = new Option('Osu Sustain Input',
			"Let go at the end of a hold note. (In the works)",
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