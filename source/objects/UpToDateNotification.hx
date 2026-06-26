package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class UpToDateNotification extends FlxGroup
{
	var bg:FlxSprite;
	var titleText:FlxText;
	var versionText:FlxText;
	var displayTime:Float = 3.0;
	var elapsedTime:Float = 0;
	var isAnimatingOut:Bool = false;

	public function new(engineVer:String, modVer:String = '')
	{
		super();
		createNotification(engineVer, modVer);
	}

	private function createNotification(engineVer:String, modVer:String):Void
	{
		bg = new FlxSprite(0, 0);
		bg.makeGraphic(FlxG.width, 80, 0xFF1a4d2e);
		bg.scrollFactor.set(0, 0);
		bg.alpha = 0;
		add(bg);

		titleText = new FlxText(20, 12, 0, 'Update Check: Up-To-Date', 20);
		titleText.setFormat(Paths.font('vcr.ttf'), 20, 0xFF00FF00, LEFT);
		titleText.scrollFactor.set(0, 0);
		titleText.alpha = 0;
		add(titleText);

		var versionDisplay = 'Engine: $engineVer';
		if(modVer.length > 0 && modVer != '0.0.0') {
			versionDisplay += ' | Mod: $modVer';
		}

		versionText = new FlxText(20, 40, 0, versionDisplay, 14);
		versionText.setFormat(Paths.font('vcr.ttf'), 14, 0xFFCCFFCC, LEFT);
		versionText.scrollFactor.set(0, 0);
		versionText.alpha = 0;
		add(versionText);

		FlxTween.tween(bg, {alpha: 0.95}, 0.3, {ease: FlxEase.quadOut});
		FlxTween.tween(titleText, {alpha: 1}, 0.3, {ease: FlxEase.quadOut});
		FlxTween.tween(versionText, {alpha: 1}, 0.3, {ease: FlxEase.quadOut});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(!isAnimatingOut) {
			elapsedTime += elapsed;
			if(elapsedTime >= displayTime) {
				animateOut();
			}
		}
	}

	private function animateOut():Void
	{
		isAnimatingOut = true;
		FlxTween.tween(bg, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
		FlxTween.tween(titleText, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
		FlxTween.tween(versionText, {alpha: 0}, 0.4, {
			ease: FlxEase.quadOut,
			onComplete: function(t) {
				kill();
			}
		});
	}
}