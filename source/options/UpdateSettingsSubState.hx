package options;

import backend.UpdateManager;
import objects.Alphabet;
import objects.UpToDateNotification;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class UpdateSettingsSubState extends BaseOptionsMenu
{
	var statusText:FlxText;
	var checkButton:FlxButton;
	var isChecking:Bool = false;
	
	public function new()
	{
		title = 'Update Settings';
		rpcTitle = 'Update Settings Menu'; // For Discord Rich Presence
		
		var option:Option = new Option('Check for Updates on Startup',
			'Automatically check GitHub for new updates when you start the game.',
			'checkForUpdates',
			BOOL);
		addOption(option);
		
		super();
	}
	
	override function create()
	{
		super.create();
		
		// Initialize versions if not already done
		UpdateManager.initializeVersions();
		
		// Add manual update check button at top center
		checkButton = new FlxButton((FlxG.width - 200) / 2, 80, "Check Now", onCheckButtonPressed);
        checkButton.setGraphicSize(200, 50);
        checkButton.updateHitbox();
        checkButton.label.fieldWidth = checkButton.width;
        checkButton.label.alignment = CENTER;
        checkButton.label.setFormat(Paths.font('vcr.ttf'), 24, 0xFF000000, FlxTextAlign.CENTER);
        checkButton.label.offset.y = -10;
        add(checkButton);
		
		// Status display text
		statusText = new FlxText(100, 140, 600, 'Current Versions:\nEngine: ${UpdateManager.CURRENT_ENGINE_VERSION}\nMod: ${UpdateManager.CURRENT_MOD_VERSION}', 16);
		statusText.setFormat(Paths.font('vcr.ttf'), 20, 0xFFFFFFFF, LEFT);
		add(statusText);
	}
	
	private function onCheckButtonPressed():Void
	{
		if(isChecking) return;
		
		isChecking = true;
		checkButton.text = 'Checking...';
		statusText.text = 'Checking for updates...';
		
		UpdateManager.checkForUpdates(onUpdateCheckComplete);
	}
	
	private function onUpdateCheckComplete(updateAvailable:Bool, engineAvail:Bool, modAvail:Bool, error:String):Void
	{
		isChecking = false;
		checkButton.text = 'Check Now';
		
		if(error.length > 0) {
			statusText.text = 'Error: $error';
			return;
		}
		
		if(updateAvailable) {
			var message = 'Update Available!\n';
			if(engineAvail) message += 'Engine update available\n';
			if(modAvail) message += 'Mod update available\n';
			message += '\nCurrent Versions:\nEngine: ${UpdateManager.CURRENT_ENGINE_VERSION}\nMod: ${UpdateManager.CURRENT_MOD_VERSION}';
			statusText.text = message;
		} else {
			statusText.text = 'Update Check: Up-To-Date\n\nCurrent Versions:\nEngine: ${UpdateManager.CURRENT_ENGINE_VERSION}\nMod: ${UpdateManager.CURRENT_MOD_VERSION}';
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(controls.BACK) {
			close();
		}
	}
}
