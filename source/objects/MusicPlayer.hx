package objects;

import flixel.group.FlxGroup;
import flixel.util.FlxStringUtil;

import objects.Bar;
import states.FreeplayState;

/**
 * Music player used for Freeplay
 */
@:access(states.FreeplayState)
class MusicPlayer extends FlxGroup 
{
	public var instance:FreeplayState;
	public var controls:Controls;

	public var playing(get, never):Bool;

	public var playingMusic:Bool = false;
	public var curTime:Float;

	var songBG:FlxSprite;
	var songTxt:FlxText;
	var timeTxt:FlxText;
	var progressOutline:FlxSprite;
	var progressBar:Bar;
	var playbackBG:FlxSprite;
	var playbackSymbols:Array<FlxText> = [];
	var playbackTxt:FlxText;
	var controlsTxt:FlxText;
	var rawSongLabel:String = '';
	var lastSongLayoutLabel:String = '';
	final progressBarYOffset:Float = 2;
	final progressBarInsetX:Float = 2;

	var wasPlaying:Bool;

	var holdPitchTime:Float = 0;
	public var playbackRate(default, set):Float = 1;

	public function new(instance:FreeplayState)
	{
		super();

		this.instance = instance;
		this.controls = instance.controls;

		var xPos:Float = FlxG.width * 0.7;

		songBG = new FlxSprite(xPos - 6, 0).makeGraphic(1, 110, 0xAA11192B);
		songBG.alpha = 0.95;
		add(songBG);

		playbackBG = new FlxSprite(xPos - 6, 0).makeGraphic(124, 70, 0xCC0A1020);
		playbackBG.alpha = 0.95;
		add(playbackBG);

		songTxt = new FlxText(FlxG.width * 0.7, 5, 0, "", 24);
		songTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT);
		songTxt.wordWrap = false;
		add(songTxt);

		timeTxt = new FlxText(xPos, songTxt.y + 34, 0, "", 20);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT);
		add(timeTxt);

		for (i in 0...2)
		{
			var text:FlxText = new FlxText();
			text.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, CENTER);
			text.text = '^';
			if (i == 1)
				text.flipY = true;
			text.visible = false;
			playbackSymbols.push(text);
			add(text);
		}

		progressOutline = new FlxSprite(timeTxt.x - progressBarInsetX, timeTxt.y + timeTxt.height + 1).makeGraphic(Std.int(timeTxt.width) + Std.int(progressBarInsetX * 2), 12, 0xFF000000);
		add(progressOutline);

		progressBar = new Bar(timeTxt.x, timeTxt.y + timeTxt.height + 3, 'healthBar', null, 0, 1);
		progressBar.barWidth = Std.int(timeTxt.width);
		progressBar.barHeight = 8;
		progressBar.barOffset.set(0, 0);
		progressBar.leftBar.makeGraphic(progressBar.barWidth, progressBar.barHeight, FlxColor.WHITE);
		progressBar.rightBar.makeGraphic(progressBar.barWidth, progressBar.barHeight, FlxColor.BLACK);
		progressBar.regenerateClips();
		progressBar.setColors(0xFF00AAFF, 0xFF000000);
		progressBar.leftBar.setGraphicSize(progressBar.barWidth, progressBar.barHeight);
		progressBar.leftBar.updateHitbox();
		progressBar.rightBar.setGraphicSize(progressBar.barWidth, progressBar.barHeight);
		progressBar.rightBar.updateHitbox();
		progressBar.bg.visible = false;
		progressBar.bg.alpha = 0;
		progressBar.rightBar.visible = true;
		progressBar.rightBar.alpha = 1;
		add(progressBar);

		playbackTxt = new FlxText(FlxG.width * 0.6, 20, 0, "", 26);
		playbackTxt.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, CENTER);
		add(playbackTxt);

		controlsTxt = new FlxText(xPos, songTxt.y + 72, 0, "", 14);
		controlsTxt.setFormat(Paths.font('vcr.ttf'), 14, 0xFFBED0EA, LEFT);
		controlsTxt.text = 'LEFT/RIGHT SEEK  UP/DOWN RATE';
		add(controlsTxt);

		switchPlayMusic();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!playingMusic)
		{
			return;
		}

		var songName:String = instance.songs[FreeplayState.curSelected].songName;
		if (playing && !wasPlaying)
			rawSongLabel = Language.getPhrase('musicplayer_playing', 'PLAYING: {1}', [songName]);
		else
			rawSongLabel = Language.getPhrase('musicplayer_paused', 'PAUSED: {1}', [songName]);
		rawSongLabel = StringTools.replace(rawSongLabel, '\n', ' ');

		//if(FlxG.keys.justPressed.K) trace('Time: ${FreeplayState.vocals.time}, Playing: ${FreeplayState.vocals.playing}');

		if (controls.UI_LEFT_P)
		{
			if (playing)
				wasPlaying = true;

			pauseOrResume();

			curTime = FlxG.sound.music.time - 1000;
			instance.holdTime = 0;

			if (curTime < 0)
				curTime = 0;

			FlxG.sound.music.time = curTime;
			setVocalsTime(curTime);
		}
		if (controls.UI_RIGHT_P)
		{
			if (playing)
				wasPlaying = true;

			pauseOrResume();

			curTime = FlxG.sound.music.time + 1000;
			instance.holdTime = 0;

			if (curTime > FlxG.sound.music.length)
				curTime = FlxG.sound.music.length;

			FlxG.sound.music.time = curTime;
			setVocalsTime(curTime);
		}

		if(controls.UI_LEFT || controls.UI_RIGHT)
		{
			instance.holdTime += elapsed;
			if(instance.holdTime > 0.5)
			{
				curTime += 40000 * elapsed * (controls.UI_LEFT ? -1 : 1);
			}

			var difference:Float = Math.abs(curTime - FlxG.sound.music.time);
			if(curTime + difference > FlxG.sound.music.length) curTime = FlxG.sound.music.length;
			else if(curTime - difference < 0) curTime = 0;

			FlxG.sound.music.time = curTime;
			setVocalsTime(curTime);
		}

		if(controls.UI_LEFT_R || controls.UI_RIGHT_R)
		{
			FlxG.sound.music.time = curTime;
			setVocalsTime(curTime);

			if (wasPlaying)
			{
				pauseOrResume(true);
				wasPlaying = false;
			}
		}
		if (controls.UI_UP_P)
		{
			holdPitchTime = 0;
			playbackRate += 0.05;
			setPlaybackRate();
		}
		else if (controls.UI_DOWN_P)
		{
			holdPitchTime = 0;
			playbackRate -= 0.05;
			setPlaybackRate();
		}
		if (controls.UI_DOWN || controls.UI_UP)
		{
			holdPitchTime += elapsed;
			if (holdPitchTime > 0.6)
			{
				playbackRate += 0.05 * (controls.UI_UP ? 1 : -1);
				setPlaybackRate();
			}
		}
	
		if (instance.touchPad.buttonC.justPressed || controls.RESET)
		{
			playbackRate = 1;
			setPlaybackRate();

			FlxG.sound.music.time = 0;
			setVocalsTime(0);
		}

		if (playing)
		{
			if(FreeplayState.vocals != null)
				FreeplayState.vocals.volume = (FreeplayState.vocals.length > FlxG.sound.music.time) ? 0.8 : 0;
			if(FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.volume = (FreeplayState.opponentVocals.length > FlxG.sound.music.time) ? 0.8 : 0;

			if((FreeplayState.vocals != null && FreeplayState.vocals.length > FlxG.sound.music.time && Math.abs(FlxG.sound.music.time - FreeplayState.vocals.time) >= 25) ||
			(FreeplayState.opponentVocals != null && FreeplayState.opponentVocals.length > FlxG.sound.music.time && Math.abs(FlxG.sound.music.time - FreeplayState.opponentVocals.time) >= 25))
			{
				pauseOrResume();
				setVocalsTime(FlxG.sound.music.time);
				pauseOrResume(true);
			}
		}

		updateTimeTxt();
		positionSong();
		progressBar.updateBar();
		updatePlaybackTxt();
	}

	function setVocalsTime(time:Float)
	{
		if (FreeplayState.vocals != null && FreeplayState.vocals.length > time)
			FreeplayState.vocals.time = time;
		if (FreeplayState.opponentVocals != null && FreeplayState.opponentVocals.length > time)
			FreeplayState.opponentVocals.time = time;
	}

	public function pauseOrResume(resume:Bool = false) 
	{
		if (resume)
		{
			if(!FlxG.sound.music.playing)
				FlxG.sound.music.resume();

			if (FreeplayState.vocals != null && FreeplayState.vocals.length > FlxG.sound.music.time && !FreeplayState.vocals.playing)
				FreeplayState.vocals.resume();
			if (FreeplayState.opponentVocals != null && FreeplayState.opponentVocals.length > FlxG.sound.music.time && !FreeplayState.opponentVocals.playing)
				FreeplayState.opponentVocals.resume();
		}
		else 
		{
			FlxG.sound.music.pause();

			if (FreeplayState.vocals != null)
				FreeplayState.vocals.pause();
			if (FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.pause();
		}
	}

	public function switchPlayMusic()
	{
		FlxG.autoPause = (!playingMusic && ClientPrefs.data.autoPause);
		active = visible = playingMusic;

		// Keep Freeplay personal best and difficulty panel visible while previewing.
		instance.scoreBG.visible = instance.diffText.visible = instance.scoreText.visible = true;
		songTxt.visible = timeTxt.visible = songBG.visible = playbackTxt.visible = playbackBG.visible = progressOutline.visible = progressBar.visible = controlsTxt.visible = playingMusic; //Show Music Player HUD only when previewing

		for (i in playbackSymbols)
			i.visible = playingMusic;
		
		holdPitchTime = 0;
		instance.holdTime = 0;
		playbackRate = 1;
		updatePlaybackTxt();

		if (playingMusic)
		{
			final space:String = (instance.controls.mobileC) ? "X" : "SPACE";
			final escape:String = (instance.controls.mobileC) ? "B" : "ESCAPE";
			final reset:String = (instance.controls.mobileC) ? "C" : "R";

			instance.bottomText.text = Language.getPhrase('musicplayer_tip', 'Press {1} to Pause / Press {2} to Exit / Press {3} to Reset the Song', [space, escape, reset]);
			positionSong();
			progressBar.bg.visible = false;
			progressBar.bg.alpha = 0;
			progressBar.rightBar.visible = true;
			progressBar.rightBar.alpha = 1;
			
			progressBar.setRange(0, 100);
			progressBar.setParent(null, "");
			progressBar.numDivisions = 0; // smooth continuous progress
			progressBar.valueFunction = function()
			{
				if (FlxG.sound.music == null || FlxG.sound.music.length <= 0)
					return 0;
				return (FlxG.sound.music.time / FlxG.sound.music.length) * 100;
			};

			updateTimeTxt();
		}
		else
		{
			progressBar.setRange(0, Math.POSITIVE_INFINITY);
			progressBar.setParent(null, "");
			progressBar.numDivisions = 0;

			instance.bottomText.text = instance.bottomString;
			instance.positionHighscore();
		}
		progressBar.updateBar();
	}

	function updatePlaybackTxt()
	{
		var text = "";
		if (playbackRate is Int)
			text = playbackRate + '.00';
		else
		{
			var playbackRate = Std.string(playbackRate);
			if (playbackRate.split('.')[1].length < 2) // Playback rates for like 1.1, 1.2 etc
				playbackRate += '0';

			text = playbackRate;
		}
		playbackTxt.text = text + 'x';
	}

	function positionSong() 
	{
		var pad:Float = 14;
		var baseX:Float = instance.rightPanel.x;
		var baseY:Float = instance.rightPanel.y;
		var panelW:Float = instance.rightPanel.width;

		songBG.x = baseX;
		songBG.y = baseY;
		songBG.setGraphicSize(Std.int(panelW), 110);
		songBG.updateHitbox();

		playbackBG.x = songBG.x + songBG.width - playbackBG.width - pad;
		playbackBG.y = songBG.y + 10;

		songTxt.x = songBG.x + pad;
		songTxt.y = songBG.y + 8;
		songTxt.wordWrap = false;
		songTxt.size = 24;
		songTxt.fieldWidth = songBG.width - playbackBG.width - (pad * 3);
		updateSongTitleLabel(rawSongLabel);

		timeTxt.x = songBG.x + pad;
		timeTxt.y = songBG.y + 42;
		timeTxt.fieldWidth = songBG.width - playbackBG.width - (pad * 3);

		var panelRight:Float = songBG.x + songBG.width - 8;
		var beforePlaybackRight:Float = playbackBG.x - 8;
		var maxRight:Float = Math.min(panelRight, beforePlaybackRight);
		var measuredTimeWidth:Float = Math.max(64, maxRight - timeTxt.x);

		progressOutline.makeGraphic(Std.int(measuredTimeWidth + (progressBarInsetX * 2)), 12, 0xFF000000);
		progressOutline.x = timeTxt.x - progressBarInsetX;
		progressOutline.y = timeTxt.y + timeTxt.height;

		progressBar.barWidth = Std.int(measuredTimeWidth);
		progressBar.barHeight = 8;
		progressBar.barOffset.set(0, 0);
		progressBar.leftBar.makeGraphic(progressBar.barWidth, progressBar.barHeight, FlxColor.WHITE);
		progressBar.rightBar.makeGraphic(progressBar.barWidth, progressBar.barHeight, FlxColor.BLACK);
		progressBar.regenerateClips();
		progressBar.setColors(0xFF00AAFF, 0xFF000000);
		progressBar.leftBar.setGraphicSize(progressBar.barWidth, progressBar.barHeight);
		progressBar.leftBar.updateHitbox();
		progressBar.rightBar.setGraphicSize(progressBar.barWidth, progressBar.barHeight);
		progressBar.rightBar.updateHitbox();
		progressBar.bg.visible = false;
		progressBar.bg.alpha = 0;
		progressBar.rightBar.visible = true;
		progressBar.rightBar.alpha = 1;
		progressBar.x = timeTxt.x;
		progressBar.y = timeTxt.y + timeTxt.height + progressBarYOffset;

		controlsTxt.x = songBG.x + pad;
		controlsTxt.y = progressBar.y + 13;
		controlsTxt.fieldWidth = songBG.width - playbackBG.width - (pad * 3);

		playbackTxt.x = playbackBG.x + (playbackBG.width - playbackTxt.width) * 0.5;
		playbackTxt.y = playbackBG.y + 22;

		for (i in 0...2)
		{
			var text = playbackSymbols[i];
			text.x = playbackBG.x + (playbackBG.width - text.width) * 0.5;
			text.y = playbackTxt.y;

			if (i == 0)
				text.y -= playbackTxt.height - 2;
			else
				text.y += playbackTxt.height;
		}
	}

	function updateSongTitleLabel(label:String):Void
	{
		if(label == null)
			label = '';
		label = StringTools.replace(label, '\n', ' ');
		label = StringTools.replace(label, '\r', ' ');
		while(label.indexOf('  ') != -1)
			label = StringTools.replace(label, '  ', ' ');
		label = label.trim();

		// Skip expensive fitting work unless text source changed.
		if(lastSongLayoutLabel == label && songTxt.text != null && songTxt.text.length > 0)
			return;

		songTxt.wordWrap = false;
		var maxSize:Int = 30;
		var minSize:Int = 16;
		songTxt.size = maxSize;
		songTxt.text = label;
		if(songTxt.textField != null)
		{
			songTxt.textField.wordWrap = false;
			songTxt.textField.multiline = false;

			while(songTxt.size > minSize && songTxt.textField.textWidth > songTxt.fieldWidth)
			{
				songTxt.size--;
				songTxt.text = label;
			}

			while(songTxt.size < maxSize && songTxt.textField.textWidth < songTxt.fieldWidth - 24)
			{
				songTxt.size++;
				songTxt.text = label;
				if(songTxt.textField.textWidth > songTxt.fieldWidth)
				{
					songTxt.size--;
					songTxt.text = label;
					break;
				}
			}
		}
	}

	function updateTimeTxt()
	{
		var text = FlxStringUtil.formatTime(FlxG.sound.music.time / 1000, false) + ' / ' + FlxStringUtil.formatTime(FlxG.sound.music.length / 1000, false);
		timeTxt.text = text;
	}

	function setPlaybackRate() 
	{
		FlxG.sound.music.pitch = playbackRate;
		if (FreeplayState.vocals != null)
			FreeplayState.vocals.pitch = playbackRate;
		if (FreeplayState.opponentVocals != null)
			FreeplayState.opponentVocals.pitch = playbackRate;
	}

	function get_playing():Bool 
	{
		return FlxG.sound.music.playing;
	}

	function set_playbackRate(value:Float):Float 
	{
		var value = FlxMath.roundDecimal(value, 2);
		if (value > 1000) value = 1000;
		else if (value <= 0.05) value = 0.05;
		return playbackRate = value;
	}
}