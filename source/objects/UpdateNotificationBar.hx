package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.graphics.frames.FlxAtlasFrames;

class UpdateNotificationBar extends FlxGroup
{
	var bg:FlxSprite;
	var titleText:FlxText;
	var versionText:FlxText;
	var expandButton:FlxSprite;
	
	var engineUpdateAvailable:Bool = false;
	var modUpdateAvailable:Bool = false;
	var modInstalled:Bool = false;
	var onUpdatePressed:Void->Void;
	var onDismiss:Void->Void;
	
	public function new(engineAvailable:Bool, modAvailable:Bool, modInstalledState:Bool, currentEngineVer:String, currentModVer:String, latestEngineVer:String, latestModVer:String,
		onUpdate:Void->Void, onDismissFunc:Void->Void)
	{
		super();
		
		engineUpdateAvailable = engineAvailable;
		modInstalled = modInstalledState;
		modUpdateAvailable = modInstalled && modAvailable;
		onUpdatePressed = onUpdate;
		onDismiss = onDismissFunc;
		
		createBar(currentEngineVer, currentModVer, latestEngineVer, latestModVer);
	}
	
	private function createBar(currentEngineVer:String, currentModVer:String, latestEngineVer:String, latestModVer:String):Void
	{
		// Background bar at top right half
		var barX:Int = Std.int(FlxG.width / 2) + 10;
		var barWidth:Int = Std.int(FlxG.width / 2) - 20;
		var barHeight:Int = 70;
		var barY:Int = 10;
		bg = new FlxSprite(barX, barY);
		bg.makeGraphic(barWidth, barHeight, 0xFF1a1a2e);
		bg.scrollFactor.set(0, 0);
		bg.alpha = 0.95;
		add(bg);
		
		// Title text
		var titleTextValue = 'Update Available';
		if(engineUpdateAvailable && !modUpdateAvailable) {
			titleTextValue = 'Engine Update Available';
		} else if(modUpdateAvailable && !engineUpdateAvailable) {
			titleTextValue = 'Mod Update Available';
		} else if(engineUpdateAvailable && modUpdateAvailable) {
			titleTextValue = 'Engine & Mod Updates Available';
		}
		titleText = new FlxText(barX + 12, barY + 6, barWidth - 96, titleTextValue, 18);
		titleText.setFormat(Paths.font('vcr.ttf'), 18, 0xFFFFFF00, LEFT);
		titleText.scrollFactor.set(0, 0);
		add(titleText);
		
		// Version info text
		var updateText = '';
		var parts:Array<String> = [];
		if(engineUpdateAvailable) {
			var engineText = currentEngineVer + (latestEngineVer != null && latestEngineVer.length > 0 ? ' > $latestEngineVer' : '');
			parts.push('Engine $engineText');
		}
		if(modUpdateAvailable) {
			var modText = currentModVer + (latestModVer != null && latestModVer.length > 0 ? ' > $latestModVer' : '');
			parts.push('Mod $modText');
		}
		if(parts.length > 0) {
			updateText = parts.join(' | ');
		}
		
		versionText = new FlxText(barX + 12, barY + 34, barWidth - 96, updateText, 12);
		versionText.setFormat(Paths.font('vcr.ttf'), 12, 0xFFCCCCCC, LEFT);
		versionText.scrollFactor.set(0, 0);
		add(versionText);
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (bg != null && bg.visible && FlxG.mouse.overlaps(bg) && FlxG.mouse.justPressed && onUpdatePressed != null) {
			onUpdatePressed();
		}
	}

	public function shouldBlockMouse():Bool
	{
		if (bg != null && bg.visible && FlxG.mouse.overlaps(bg))
			return true;

		return false;
	}
}
