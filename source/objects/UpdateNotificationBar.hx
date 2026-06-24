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
	
	var expanded:Bool = false;
	var expandedPanel:FlxSprite;
	var expandedText:FlxText;
	var closeButton:FlxSprite;
	var updateButton:FlxButton;
	var dismissButton:FlxButton;
	
	var engineUpdateAvailable:Bool = false;
	var modUpdateAvailable:Bool = false;
	var onUpdatePressed:Void->Void;
	var onDismiss:Void->Void;
	
	public function new(engineAvailable:Bool, modAvailable:Bool, engineVer:String, modVer:String, 
		onUpdate:Void->Void, onDismissFunc:Void->Void)
	{
		super();
		
		engineUpdateAvailable = engineAvailable;
		modUpdateAvailable = modAvailable;
		onUpdatePressed = onUpdate;
		onDismiss = onDismissFunc;
		
		createBar(engineVer, modVer);
	}
	
	private function createBar(engineVer:String, modVer:String):Void
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
		titleText = new FlxText(barX + 12, barY + 6, barWidth - 96, 'Update Available', 18);
		titleText.setFormat(Paths.font('vcr.ttf'), 18, 0xFFFFFF00, LEFT);
		titleText.scrollFactor.set(0, 0);
		add(titleText);
		
		// Version info text
		var updateText = '';
		if(engineUpdateAvailable && modUpdateAvailable) {
			updateText = 'Engine $engineVer | Mod $modVer';
		} else if(engineUpdateAvailable) {
			updateText = 'Engine $engineVer';
		} else if(modUpdateAvailable) {
			updateText = 'Mod $modVer';
		}
		
		versionText = new FlxText(barX + 12, barY + 34, barWidth - 96, updateText, 12);
		versionText.setFormat(Paths.font('vcr.ttf'), 12, 0xFFCCCCCC, LEFT);
		versionText.scrollFactor.set(0, 0);
		add(versionText);
		
		// Expand button
		expandButton = new FlxSprite(barX + barWidth - 60, barY + 20);
		expandButton.makeGraphic(50, 30, 0xFF16213e);
		expandButton.alpha = 0.8;
		expandButton.scrollFactor.set(0, 0);
		add(expandButton);
		
		var expandText = new FlxText(barX + barWidth - 60, barY + 20, 50, 'More', 12);
		expandText.setFormat(Paths.font('vcr.ttf'), 12, 0xFFFFFFFF, CENTER);
		expandText.y = expandButton.y + (expandButton.height - expandText.height) / 2;
		expandText.scrollFactor.set(0, 0);
		add(expandText);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if(!expanded && FlxG.mouse.overlaps(bg) && FlxG.mouse.justPressed) {
			expandPanel();
		}
	}
	
	private function expandPanel():Void
	{
		expanded = true;
		
		// Create expanded panel
		expandedPanel = new FlxSprite(50, 150);
		expandedPanel.makeGraphic(FlxG.width - 100, 200, 0xFF0f3460);
		expandedPanel.scrollFactor.set(0, 0);
		expandedPanel.alpha = 0;
		add(expandedPanel);
		
		// Panel text
		expandedText = new FlxText(70, 170, FlxG.width - 140, 
			'A new update is available!\n\nYour current versions will be replaced with the latest release from GitHub. Only changed files will be downloaded to save bandwidth and storage space.\n\nThe game will automatically restart after the update is applied.',
			14);
		expandedText.setFormat(Paths.font('vcr.ttf'), 14, 0xFFFFFFFF, LEFT);
		expandedText.scrollFactor.set(0, 0);
		expandedText.wordWrap = true;
		expandedText.alpha = 0;
		add(expandedText);
		
		// Update button
		updateButton = new FlxButton(70, expandedPanel.y + expandedPanel.height - 50, 'Update', onUpdateButtonPressed);
		updateButton.scrollFactor.set(0, 0);
		updateButton.alpha = 0;
		add(updateButton);
		
		// Dismiss button
		dismissButton = new FlxButton(FlxG.width - 180, expandedPanel.y + expandedPanel.height - 50, 'Later', onDismissButtonPressed);
		dismissButton.scrollFactor.set(0, 0);
		dismissButton.alpha = 0;
		add(dismissButton);
		
		// Fade in
		FlxTween.tween(expandedPanel, {alpha: 0.95}, 0.3, {ease: FlxEase.quadOut});
		FlxTween.tween(expandedText, {alpha: 1}, 0.3, {ease: FlxEase.quadOut});
		FlxTween.tween(updateButton, {alpha: 1}, 0.3, {ease: FlxEase.quadOut});
		FlxTween.tween(dismissButton, {alpha: 1}, 0.3, {ease: FlxEase.quadOut});
	}
	
	private function onUpdateButtonPressed():Void
	{
		if(onUpdatePressed != null) {
			onUpdatePressed();
		}
	}
	
	private function onDismissButtonPressed():Void
	{
		collapse();
		if(onDismiss != null) {
			onDismiss();
		}
	}
	
	private function collapse():Void
	{
		expanded = false;
		if(expandedPanel != null) {
			FlxTween.tween(expandedPanel, {alpha: 0}, 0.2, {
				ease: FlxEase.quadOut,
				onComplete: function(t) {
					remove(expandedPanel);
					expandedPanel = null;
				}
			});
		}
		if(expandedText != null) {
			FlxTween.tween(expandedText, {alpha: 0}, 0.2, {ease: FlxEase.quadOut});
		}
		if(updateButton != null) {
			FlxTween.tween(updateButton, {alpha: 0}, 0.2, {ease: FlxEase.quadOut});
		}
		if(dismissButton != null) {
			FlxTween.tween(dismissButton, {alpha: 0}, 0.2, {ease: FlxEase.quadOut});
		}
	}
}
