package options;

class PringlekittenSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		rpcTitle = 'Pringlekitten\'s Settings Menu';

		var option:Option = new Option('Asset Movement',
			'If checked, allows scripts to move parts of the game.',
			'assetMovement',
			BOOL);
		addOption(option);

		var option:Option = new Option('Even Lower Quality',
			"If checked, the game will run with even less objects\n When combined with Low Quality",
			'ldm',
			BOOL);
		addOption(option);

		var option:Option = new Option('Camera Movement',
			"If unchecked, the camera wont move when hitting notes",
			'camMovement',
			BOOL);
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
			"If checked, your health will hurt more\n the worse rating you hit for a note(Kade Engine).\n (+50 Score Each Hit)",
			'ratingPenalty',
			BOOL);
		addOption(option);

		var option:Option = new Option('Low Accuracy Penalty',
			"If checked, your health will hurt more\n the lower your Accuracy is.\n (+30 Score Each Hit)",
			'lowPercentHurt',
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