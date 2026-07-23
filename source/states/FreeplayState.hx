package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;
import backend.Conductor;
import backend.ClientPrefs;

import objects.HealthIcon;
import objects.MusicPlayer;

import options.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSort;

import openfl.utils.Assets;
import openfl.filters.ShaderFilter;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import sys.thread.FixedThreadPool;
import sys.thread.Mutex;
import objects.Note.EventNote;
import shaders.ErrorHandledShader.ErrorHandledRuntimeShader;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];
	var lastBeatTriggered:Int = -1;

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var lerpSelected:Float = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = Difficulty.getDefault();

	var beatTimer:Float = 0;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Float = 0;
	var lerpRating:Float = 0;
	var intendedScore:Float = 0;
	var intendedRating:Float = 0;
	var recentScore:Float = 0;
	var recentRating:Float = 0;
	var cheatedSC:Int = -1;
	var rcheaT:Int = -1;
	var rate:Float = 1;
	var rrate:Float = 1;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;

	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	var bottomString:String;
	var bottomText:FlxText;
	var bottomBG:FlxSprite;

	var player:MusicPlayer;
	var leftPanel:FlxSprite;
	var rightPanel:FlxSprite;
	var topHeaderPanel:FlxSprite;
	var densityPanel:FlxSprite;
	var vsPanel:FlxSprite;
	var accentLine:FlxSprite;
	var songTickerText:FlxText;
	var songHeaderSubText:FlxText;
	var bpmText:FlxText;
	var bpmChangesText:FlxText;
	var densityText:FlxText;
	var detailHintText:FlxText;
	var densityP1Icon:HealthIcon;
	var densityP2Icon:HealthIcon;
	var densityVsText:FlxText;
	var densityPeakLine:FlxSprite;
	var densityLeftIconChar:String = '';
	var densityRightIconChar:String = '';
	final subtitleBaseBlueColor:Int = 0xFF9FE8FF;
	final subtitleValueRedColor:Int = 0xFFFF0000;
	var subtitleValueFormat:FlxTextFormat = null;
	var densityBars:Array<FlxSprite> = [];
	var densityBarCount:Int = 36;
	var densityCache:Map<String, SongDensityData> = [];
	var densityPendingJobs:Map<String, Bool> = [];
	var densityCompletedJobs:Map<String, SongDensityData> = [];
	var densityJobsMutex:Mutex = new Mutex();
	var densityThreadPool:FixedThreadPool = null;
	var headerCreditsCache:Map<String, String> = [];
	var previewPrewarmPending:Map<String, Bool> = [];
	var previewFileTextCache:Map<String, String> = [];
	var previewDirListCache:Map<String, Array<String>> = [];
	var previewFileCacheMutex:Mutex = new Mutex();
	var previewSoundPreloads:Map<String, flash.media.Sound> = [];
	var previewSoundMutex:Mutex = new Mutex();
	var currentDensityData:SongDensityData = null;
	var bpmChangesExpanded:Bool = false;
	var freeplayLoadOverlayBG:FlxSprite;
	var freeplayLoadOverlayPanel:FlxSprite;
	var freeplayLoadBarBack:FlxSprite;
	var freeplayLoadBarFill:FlxSprite;
	var freeplayLoadTitle:FlxText;
	var freeplayLoadStatus:FlxText;
	var freeplayLoadMode:String = '';
	var freeplayLoadProgress:Float = 0;
	var freeplayLoadPulse:Float = 0;
	var pendingPreviewSongIndex:Int = -1;
	var pendingPreviewDifficulty:Int = -1;
	var pendingPreviewStage:Int = 0;
	var pendingSongSongIndex:Int = -1;
	var pendingSongDifficulty:Int = -1;
	var pendingSongStage:Int = 0;

	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Freeplay Menu", null);
		#end

		final accept:String = (controls.mobileC) ? "A" : "ACCEPT";
		final reject:String = (controls.mobileC) ? "B" : "BACK";

		if(WeekData.weeksList.length < 1)
		{
			FlxTransitionableState.skipNextTransIn = true;
			persistentUpdate = false;
			MusicBeatState.switchState(new states.ErrorState("NO WEEKS ADDED FOR FREEPLAY\n\nPress " + accept + " to go to the Week Editor Menu.\nPress " + reject + " to return to Main Menu.",
				function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
				function() MusicBeatState.switchState(new states.MainMenuState())));
			return;
		}

		for (i in 0...WeekData.weeksList.length)
		{
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		Mods.loadTopMod();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();
		densityThreadPool = new FixedThreadPool(LoadingState.getUsableThreadCount(Std.int(Math.max(1, songs.length))));
		buildModernFreeplayLayout();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(rightPanel.x + 20, 180, songs[i].songName, true);
			songText.targetY = i;
			grpSongs.add(songText);

			songText.scaleX = Math.min(1.02, (rightPanel.width - 54) / songText.width);
			songText.scaleY = songText.scaleX;
			songText.snapToPosition();

			Mods.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(getHealthIconFromCharacter(songs[i].songCharacter));
			icon.sprTracker = songText;

			
			// too laggy with a lot of songs, so i had to recode the logic for it
			songText.visible = songText.active = songText.isMenuItem = false;
			icon.visible = icon.active = false;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(34, leftPanel.y + 64, leftPanel.width - 40, "", 18);
		scoreText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT);

		scoreBG = new FlxSprite(20, leftPanel.y + 48).makeGraphic(Std.int(leftPanel.width), 128, 0xAA05070C);
		scoreBG.alpha = 0.92;
		add(scoreBG);

		diffText = new FlxText(34, leftPanel.y + 176, leftPanel.width - 40, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);


		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		lerpSelected = curSelected;

		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

		bottomBG = new FlxSprite(20, FlxG.height - 48).makeGraphic(FlxG.width - 40, 30, 0xA0000000);
		bottomBG.alpha = 0.92;
		add(bottomBG);

		final space:String = (controls.mobileC) ? "X" : "SPACE";
		final control:String = (controls.mobileC) ? "C" : "CTRL";
		final reset:String = (controls.mobileC) ? "Y" : "RESET";
		
		var leText:String = Language.getPhrase("freeplay_tip", "Press {1} to listen to the Song / Press {2} to open the Gameplay Changers Menu / Press {3} to Reset your Score and Accuracy.", [space, control, reset]);
		bottomString = leText;
		var size:Int = 16;
		bottomText = new FlxText(bottomBG.x + 12, bottomBG.y + 6, bottomBG.width - 24, leText, size);
		bottomText.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, CENTER);
		bottomText.scrollFactor.set();
		add(bottomText);
		
		player = new MusicPlayer(this);
		add(player);
		createFreeplayLoadingOverlay();
		
		changeSelection();
		warmVisibleDensityCache();
		updateTexts();

		addTouchPad('LEFT_FULL', 'A_B_C_X_Y_Z');
		super.create();
	}

	override function closeSubState()
	{
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
		removeTouchPad();
		addTouchPad('LEFT_FULL', 'A_B_C_X_Y_Z');
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function createFreeplayLoadingOverlay():Void
	{
		freeplayLoadOverlayBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xB0000000);
		freeplayLoadOverlayBG.visible = false;
		add(freeplayLoadOverlayBG);

		var panelWidth:Int = Std.int(Math.min(920, FlxG.width - 120));
		freeplayLoadOverlayPanel = new FlxSprite(0, 0).makeGraphic(panelWidth, 170, 0xEE10192A);
		freeplayLoadOverlayPanel.screenCenter();
		freeplayLoadOverlayPanel.visible = false;
		add(freeplayLoadOverlayPanel);

		freeplayLoadTitle = new FlxText(freeplayLoadOverlayPanel.x + 28, freeplayLoadOverlayPanel.y + 22, freeplayLoadOverlayPanel.width - 56, '', 30);
		freeplayLoadTitle.setFormat(Paths.font('vcr.ttf'), 30, 0xFFF4FAFF, CENTER);
		freeplayLoadTitle.visible = false;
		add(freeplayLoadTitle);

		freeplayLoadStatus = new FlxText(freeplayLoadOverlayPanel.x + 28, freeplayLoadOverlayPanel.y + 68, freeplayLoadOverlayPanel.width - 56, '', 18);
		freeplayLoadStatus.setFormat(Paths.font('vcr.ttf'), 18, 0xFFB8D3F0, CENTER);
		freeplayLoadStatus.visible = false;
		add(freeplayLoadStatus);

		freeplayLoadBarBack = new FlxSprite(freeplayLoadOverlayPanel.x + 34, freeplayLoadOverlayPanel.y + 118).makeGraphic(panelWidth - 68, 22, 0xFF0C1320);
		freeplayLoadBarBack.visible = false;
		add(freeplayLoadBarBack);

		freeplayLoadBarFill = new FlxSprite(freeplayLoadBarBack.x + 3, freeplayLoadBarBack.y + 3).makeGraphic(1, 16, 0xFF7AD7FF);
		freeplayLoadBarFill.visible = false;
		add(freeplayLoadBarFill);
	}

	inline function isFreeplayLoadActive():Bool
	{
		return freeplayLoadMode != null && freeplayLoadMode.length > 0;
	}

	function setFreeplayLoadOverlayVisible(visible:Bool):Void
	{
		freeplayLoadOverlayBG.visible = visible;
		freeplayLoadOverlayPanel.visible = visible;
		freeplayLoadTitle.visible = visible;
		freeplayLoadStatus.visible = visible;
		freeplayLoadBarBack.visible = visible;
		freeplayLoadBarFill.visible = visible;
	}

	function redrawFreeplayLoadBar():Void
	{
		var usableWidth:Int = Std.int(Math.max(1, freeplayLoadBarBack.width - 6));
		var fillWidth:Int = Std.int(Math.max(1, Math.floor(usableWidth * FlxMath.bound(freeplayLoadProgress, 0, 1))));
		freeplayLoadBarFill.setGraphicSize(fillWidth, Std.int(freeplayLoadBarFill.height));
		freeplayLoadBarFill.updateHitbox();
		freeplayLoadBarFill.x = freeplayLoadBarBack.x + 3;
		freeplayLoadBarFill.y = freeplayLoadBarBack.y + 3;
	}

	function showFreeplayLoadOverlay(mode:String, title:String, status:String, progress:Float):Void
	{
		freeplayLoadMode = mode;
		freeplayLoadTitle.text = title;
		freeplayLoadStatus.text = status;
		freeplayLoadProgress = FlxMath.bound(progress, 0, 1);
		freeplayLoadPulse = 0;
		redrawFreeplayLoadBar();
		setFreeplayLoadOverlayVisible(true);
	}

	function updateFreeplayLoadOverlay(progress:Float, ?status:String):Void
	{
		freeplayLoadProgress = FlxMath.bound(progress, 0, 1);
		if(status != null)
			freeplayLoadStatus.text = status;
		redrawFreeplayLoadBar();
	}

	function hideFreeplayLoadOverlay():Void
	{
		freeplayLoadMode = '';
		pendingPreviewSongIndex = -1;
		pendingPreviewDifficulty = -1;
		pendingPreviewStage = 0;
		pendingSongSongIndex = -1;
		pendingSongDifficulty = -1;
		pendingSongStage = 0;
		freeplayLoadProgress = 0;
		setFreeplayLoadOverlayVisible(false);
	}

	function showFreeplayLoadError(errorText:String):Void
	{
		hideFreeplayLoadOverlay();
		missingText.text = errorText;
		missingText.screenCenter(Y);
		missingText.visible = true;
		missingTextBG.visible = true;
		FlxG.sound.play(Paths.sound('cancelMenu'));
	}

	function beginPreviewLoad():Void
	{
		pendingPreviewSongIndex = curSelected;
		pendingPreviewDifficulty = curDifficulty;
		pendingPreviewStage = 0;
		queuePreviewPrewarm(songs[curSelected].songName, curDifficulty);
		showFreeplayLoadOverlay('preview', 'PREPARING PREVIEW', 'Warming chart, events, and audio...', 0.08);
	}

	function beginSongLoad():Void
	{
		pendingSongSongIndex = curSelected;
		pendingSongDifficulty = curDifficulty;
		pendingSongStage = 0;
		showFreeplayLoadOverlay('song', 'LOADING SONG', 'Preparing chart and asset queue...', 0.04);
	}

	function tryStartPreviewPlayback(songIndex:Int, difficulty:Int):Bool
	{
		resetPreviewCamera();
		destroyFreeplayVocals();
		FlxG.sound.music.volume = 0;
		lastBeatTriggered = -1;

		Mods.currentModDirectory = songs[songIndex].folder;
		var songLower:String = songs[songIndex].songName.toLowerCase();
		var chartName:String = Highscore.formatSong(songLower, difficulty);

		try
		{
			Song.loadFromJson(chartName, songLower);
		}
		catch(e:haxe.Exception)
		{
			var errorStr:String = e.message;
			if(errorStr.contains('There is no TEXT asset with an ID of')) errorStr = 'Missing file: ' + errorStr.substring(errorStr.indexOf(songLower), errorStr.length-1);
			else errorStr += '\n\n' + e.stack;
			showFreeplayLoadError('ERROR WHILE LOADING PREVIEW:\n$errorStr');
			return false;
		}

		if (PlayState.SONG.needsVoices)
		{
			vocals = new FlxSound();
			try
			{
				var playerVocals:String = getVocalFromCharacter(PlayState.SONG.player1);
				var loadedVocals = Paths.voices(PlayState.SONG.song, (playerVocals != null && playerVocals.length > 0) ? playerVocals : 'Player');
				if(loadedVocals == null) loadedVocals = Paths.voices(PlayState.SONG.song);
				
				if(loadedVocals != null && loadedVocals.length > 0)
				{
					vocals.loadEmbedded(loadedVocals);
					FlxG.sound.list.add(vocals);
					vocals.persist = vocals.looped = true;
					vocals.volume = 0.8;
					vocals.play();
					vocals.pause();
				}
				else vocals = FlxDestroyUtil.destroy(vocals);
			}
			catch(e:Dynamic)
			{
				vocals = FlxDestroyUtil.destroy(vocals);
			}
			
			opponentVocals = new FlxSound();
			try
			{
				var oppVocals:String = getVocalFromCharacter(PlayState.SONG.player2);
				var loadedVocals = Paths.voices(PlayState.SONG.song, (oppVocals != null && oppVocals.length > 0) ? oppVocals : 'Opponent');
				
				if(loadedVocals != null && loadedVocals.length > 0)
				{
					opponentVocals.loadEmbedded(loadedVocals);
					FlxG.sound.list.add(opponentVocals);
					opponentVocals.persist = opponentVocals.looped = true;
					opponentVocals.volume = 0.8;
					opponentVocals.play();
					opponentVocals.pause();
				}
				else opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
			}
			catch(e:Dynamic)
			{
				opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
			}
		}

		Conductor.bpm = PlayState.SONG.bpm;
		Conductor.offset = Reflect.hasField(PlayState.SONG, 'offset') ? PlayState.SONG.offset : 0;
		Conductor.songPosition = 0;
		Conductor.mapBPMChanges(PlayState.SONG);
		buildPreviewSectionBPMData();
		loadPreviewEvents(Paths.formatToSongPath(songs[songIndex].songName));
		// Apply pre-loaded sounds into Paths cache so playMusic finds them without hitting disk
		flushPreviewSoundPreloads();
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.8);
		setupPreviewLoopRestart();
		FlxG.sound.music.pause();
		previewLastMusicTime = -1;

		instPlaying = songIndex;

		player.playingMusic = true;
		player.curTime = 0;
		player.switchPlayMusic();
		previewPendingSongStart = true;
		return true;
	}

	function tryPrepareSongGameplayLoad(songIndex:Int, difficulty:Int):Bool
	{
		var songLowercase:String = Paths.formatToSongPath(songs[songIndex].songName);
		var chartName:String = Highscore.formatSong(songLowercase, difficulty);

		try
		{
			Song.loadFromJson(chartName, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = difficulty;
			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
		}
		catch(e:haxe.Exception)
		{
			var errorStr:String = e.message;
			if(errorStr.contains('There is no TEXT asset with an ID of')) errorStr = 'Missing file: ' + errorStr.substring(errorStr.indexOf(songLowercase), errorStr.length-1);
			else errorStr += '\n\n' + e.stack;
			showFreeplayLoadError('ERROR WHILE LOADING CHART:\n$errorStr');
			return false;
		}

		@:privateAccess
		if(PlayState._lastLoadedModDirectory != Mods.currentModDirectory)
		{
			trace('CHANGED MOD DIRECTORY, RELOADING STUFF');
			Paths.freeGraphicsFromMemory();
		}

		LoadingState.loadNextDirectory();
		LoadingState.prepareToSong();
		return true;
	}

	function processPendingFreeplayLoad(elapsed:Float):Bool
	{
		if(!isFreeplayLoadActive())
			return false;

		freeplayLoadPulse += elapsed;
		switch(freeplayLoadMode)
		{
			case 'preview':
				var previewFloor:Float = 0.08 + (Math.sin(freeplayLoadPulse * 3.4) * 0.04);
				if(pendingPreviewSongIndex < 0 || pendingPreviewSongIndex >= songs.length)
				{
					hideFreeplayLoadOverlay();
					return false;
				}

				var prewarmKey:String = getPreviewPrewarmKey(songs[pendingPreviewSongIndex].songName, pendingPreviewDifficulty);
				if(pendingPreviewStage == 0)
				{
					updateFreeplayLoadOverlay(Math.max(0.1, previewFloor), 'Warming chart, events, and audio...');
					if(!isPreviewPrewarmPending(prewarmKey))
						pendingPreviewStage = 1;
				}
				else if(pendingPreviewStage == 1)
				{
					updateFreeplayLoadOverlay(0.62, 'Binding preview audio and event data...');
					if(tryStartPreviewPlayback(pendingPreviewSongIndex, pendingPreviewDifficulty))
					{
						updateFreeplayLoadOverlay(1, 'Preview ready');
						hideFreeplayLoadOverlay();
					}
					return true;
				}

			case 'song':
				if(pendingSongSongIndex < 0 || pendingSongSongIndex >= songs.length)
				{
					hideFreeplayLoadOverlay();
					return false;
				}

				if(pendingSongStage == 0)
				{
					updateFreeplayLoadOverlay(0.12, 'Preparing chart and asset queue...');
					if(tryPrepareSongGameplayLoad(pendingSongSongIndex, pendingSongDifficulty))
						pendingSongStage = 1;
					return true;
				}

				var songProgress:Float = 0.18 + (Math.sin(freeplayLoadPulse * 3.0) * 0.03);
				if(LoadingState.loadMax > 0)
					songProgress = 0.15 + (0.85 * (LoadingState.loaded / LoadingState.loadMax));
				updateFreeplayLoadOverlay(songProgress, LoadingState.loadMax > 0 ? 'Preloading ${LoadingState.loaded} / ${LoadingState.loadMax} assets...' : 'Scanning stage, character, and song assets...');

				if(LoadingState.checkLoaded())
				{
					updateFreeplayLoadOverlay(1, 'Launching song...');
					LoadingState.finishLoading();
					persistentUpdate = false;
					FlxG.sound.music.stop();
					stopMusicPlay = true;
					destroyFreeplayVocals();
					#if (MODS_ALLOWED && DISCORD_ALLOWED)
					DiscordClient.loadModRPC();
					#end
					hideFreeplayLoadOverlay();
					MusicBeatState.switchState(new PlayState());
					return true;
				}
				return true;
		}

		return true;
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	function buildModernFreeplayLayout():Void
	{
		topHeaderPanel = new FlxSprite(20, 20).makeGraphic(FlxG.width - 40, 58, 0xB8121B2E);
		topHeaderPanel.alpha = 0.95;
		add(topHeaderPanel);

		accentLine = new FlxSprite(20, topHeaderPanel.y + topHeaderPanel.height).makeGraphic(FlxG.width - 40, 2, 0xFFD5E4FF);
		accentLine.alpha = 0.22;
		add(accentLine);

		var contentY:Float = accentLine.y + accentLine.height + 8;
		var contentBottom:Float = FlxG.height - 66;
		var contentHeight:Int = Std.int(contentBottom - contentY);

		leftPanel = new FlxSprite(20, contentY).makeGraphic(560, contentHeight, 0xA80A101A);
		leftPanel.alpha = 0.95;
		add(leftPanel);

		var rightPanelWidth:Int = Std.int(leftPanel.width);
		rightPanel = new FlxSprite(FlxG.width - 20 - rightPanelWidth, contentY).makeGraphic(rightPanelWidth, contentHeight, 0xA80C1322);
		rightPanel.alpha = 0.96;
		add(rightPanel);

		densityPanel = new FlxSprite(20, leftPanel.y + 206).makeGraphic(560, 248, 0x98131E31);
		densityPanel.alpha = 0.96;
		add(densityPanel);

		var vsPanelY:Float = densityPanel.y + densityPanel.height + 10;
		var vsPanelHeight:Int = Std.int(Math.max(64.0, (leftPanel.y + leftPanel.height) - vsPanelY - 10));
		vsPanel = new FlxSprite(20, vsPanelY).makeGraphic(560, vsPanelHeight, 0x98111A2C);
		vsPanel.alpha = 0.94;
		add(vsPanel);

		songTickerText = new FlxText(topHeaderPanel.x + 24, topHeaderPanel.y + 3, topHeaderPanel.width - 48, '', 30);
		songTickerText.setFormat(Paths.font('vcr.ttf'), 30, 0xFFF4FAFF, CENTER);
		songTickerText.alpha = 0.86;
		add(songTickerText);

		songHeaderSubText = new FlxText(topHeaderPanel.x + 24, topHeaderPanel.y + 34, topHeaderPanel.width - 48, '', 17);
		songHeaderSubText.setFormat(Paths.font('vcr.ttf'), 17, subtitleBaseBlueColor, CENTER);
		songHeaderSubText.alpha = 0.86;
		add(songHeaderSubText);

		bpmText = new FlxText(34, leftPanel.y + 8, leftPanel.width - 40, '', 20);
		bpmText.setFormat(Paths.font('vcr.ttf'), 20, 0xFFCDE8FF, LEFT);
		add(bpmText);

		bpmChangesText = new FlxText(34, bpmText.y + 22, leftPanel.width - 40, '', 15);
		bpmChangesText.setFormat(Paths.font('vcr.ttf'), 15, 0xFFAED2F6, LEFT);
		bpmChangesText.visible = false;
		add(bpmChangesText);

		densityText = new FlxText(34, densityPanel.y + 8, leftPanel.width - 40, '', 20);
		densityText.setFormat(Paths.font('vcr.ttf'), 20, 0xFFB3F7D9, LEFT);
		add(densityText);

		detailHintText = new FlxText(34, densityPanel.y + densityPanel.height - 26, leftPanel.width - 40, 'Density Timeline: peaks represent harder sections', 14);
		detailHintText.setFormat(Paths.font('vcr.ttf'), 14, 0xFFB5C7E5, LEFT);
		add(detailHintText);

		var iconSize:Int = Std.int(Math.max(44.0, Math.min(74.0, vsPanel.height - 20)));
		var vsCenterX:Float = vsPanel.x + (vsPanel.width * 0.5);
		var vsTextWidth:Float = 64;

		densityP1Icon = new HealthIcon('bf', true);
		densityP1Icon.autoAdjustOffset = false;
		densityP1Icon.setGraphicSize(iconSize);
		densityP1Icon.updateHitbox();
		densityP1Icon.alpha = 0.96;
		add(densityP1Icon);

		densityP2Icon = new HealthIcon('dad', false);
		densityP2Icon.autoAdjustOffset = false;
		densityP2Icon.setGraphicSize(iconSize);
		densityP2Icon.updateHitbox();
		densityP2Icon.alpha = 0.96;
		add(densityP2Icon);

		densityVsText = new FlxText(vsCenterX - (vsTextWidth * 0.5), vsPanel.y + (vsPanel.height * 0.5) - 14, vsTextWidth, 'VS', 22);
		densityVsText.setFormat(Paths.font('vcr.ttf'), 22, 0xFFE8F2FF, CENTER);
		densityVsText.alpha = 0.85;
		add(densityVsText);

		densityBars = [];
		var graphX:Float = densityPanel.x + 16;
		var graphY:Float = densityPanel.y + 46;
		var graphW:Float = densityPanel.width - 32;
		var graphH:Float = densityPanel.height - 76;
		var spacing:Float = graphW / densityBarCount;
		for(i in 0...densityBarCount)
		{
			var barWidth:Int = Std.int(Math.max(2.0, Math.floor(spacing - 1)));
			var bar:FlxSprite = new FlxSprite(graphX + (i * spacing), graphY + graphH - 2).makeGraphic(barWidth, 2, 0xFF8DD0FF);
			bar.alpha = 0.8;
			densityBars.push(bar);
			add(bar);
		}

		densityPeakLine = new FlxSprite(graphX, graphY + graphH - 2).makeGraphic(Std.int(graphW), 2, 0xFFE8F2FF);
		densityPeakLine.alpha = 0.55;
		add(densityPeakLine);
	}

	function getDensityCacheKey(songName:String, difficulty:Int):String
	{
		return Paths.formatToSongPath(songName) + '::' + difficulty;
	}

	function createFallbackDensityData():SongDensityData
	{
		var fallbackBars:Array<Float> = [];
		for(i in 0...densityBarCount) fallbackBars.push(0);
		return new SongDensityData(0, 0, 0, 0, fallbackBars, '', '');
	}

	function getPreviewPrewarmKey(songName:String, difficulty:Int):String
	{
		return Paths.formatToSongPath(songName) + '::' + difficulty + '::preview';
	}

	function cachePreviewFileText(filePath:String):String
	{
		if(filePath == null || filePath.length < 1)
			return null;

		previewFileCacheMutex.acquire();
		var hasCached:Bool = previewFileTextCache.exists(filePath);
		var cached:String = hasCached ? previewFileTextCache.get(filePath) : null;
		previewFileCacheMutex.release();
		if(hasCached)
			return cached;

		var content:String = null;
		try
		{
			content = File.getContent(filePath);
		}
		catch(e:Dynamic) {}

		if(content != null)
		{
			previewFileCacheMutex.acquire();
			previewFileTextCache.set(filePath, content);
			previewFileCacheMutex.release();
		}
		return content;
	}

	function cachePreviewDirList(folder:String):Array<String>
	{
		if(folder == null || folder.length < 1)
			return [];

		previewFileCacheMutex.acquire();
		var hasCached:Bool = previewDirListCache.exists(folder);
		var cached:Array<String> = hasCached ? previewDirListCache.get(folder) : null;
		previewFileCacheMutex.release();
		if(hasCached)
			return cached != null ? cached : [];

		var entries:Array<String> = [];
		try
		{
			if(FileSystem.exists(folder) && FileSystem.isDirectory(folder))
				entries = Paths.readDirectory(folder);
		}
		catch(e:Dynamic) {}

		previewFileCacheMutex.acquire();
		previewDirListCache.set(folder, entries);
		previewFileCacheMutex.release();
		return entries;
	}

	function preloadPreviewSoundsInBackground(songPath:String, song:backend.Song.SwagSong):Void
	{
		inline function trySoundFile(key:String):Void
		{
			var file:String = Paths.getPath(
				Language.getFileTranslation(key) + '.${Paths.SOUND_EXT}', SOUND, 'songs', true);
			if(file == null || file.length < 1 || Paths.currentTrackedSounds.exists(file))
				return;
			try
			{
				if(FileSystem.exists(file))
				{
					var snd:flash.media.Sound = flash.media.Sound.fromFile(file);
					if(snd != null)
					{
						previewSoundMutex.acquire();
						previewSoundPreloads.set(file, snd);
						previewSoundMutex.release();
					}
				}
			}
			catch(e:Dynamic) {}
		}

		trySoundFile('$songPath/Inst');

		if(song == null || !song.needsVoices)
			return;

		var p1Vocal:String = null;
		var p2Vocal:String = null;
		try { p1Vocal = getVocalFromCharacter(song.player1 != null ? song.player1 : 'bf'); } catch(e:Dynamic) {}
		try { p2Vocal = getVocalFromCharacter(song.player2 != null ? song.player2 : 'dad'); } catch(e:Dynamic) {}
		var vBase:String = '$songPath/Voices';
		trySoundFile(vBase + (p1Vocal != null && p1Vocal.length > 0 ? '-' + p1Vocal : '-Player'));
		trySoundFile(vBase + (p2Vocal != null && p2Vocal.length > 0 ? '-' + p2Vocal : '-Opponent'));
		trySoundFile(vBase);
	}

	function flushPreviewSoundPreloads():Void
	{
		previewSoundMutex.acquire();
		for(file => snd in previewSoundPreloads)
		{
			if(!Paths.currentTrackedSounds.exists(file))
				Paths.currentTrackedSounds.set(file, snd);
			if(!Paths.localTrackedAssets.contains(file))
				Paths.localTrackedAssets.push(file);
		}
		previewSoundPreloads.clear();
		previewSoundMutex.release();
	}

	function prewarmPreviewLuaDirectory(folder:String, seenFiles:Map<String, Bool>):Void
	{
		if(folder == null || folder.length < 1 || !FileSystem.exists(folder) || !FileSystem.isDirectory(folder))
			return;

		try
		{
			for(entry in cachePreviewDirList(folder))
			{
				var entryPath:String = haxe.io.Path.join([folder, entry]);
				if(FileSystem.isDirectory(entryPath))
				{
					prewarmPreviewLuaDirectory(entryPath, seenFiles);
					continue;
				}

				if(!entry.toLowerCase().endsWith('.lua') || seenFiles.exists(entryPath))
					continue;

				seenFiles.set(entryPath, true);
				cachePreviewFileText(entryPath);
			}
		}
		catch(e:Dynamic) {}
	}

	function queuePreviewPrewarm(songName:String, difficulty:Int):Void
	{
		var prewarmKey:String = getPreviewPrewarmKey(songName, difficulty);
		densityJobsMutex.acquire();
		var alreadyQueued:Bool = previewPrewarmPending.exists(prewarmKey);
		if(!alreadyQueued)
			previewPrewarmPending.set(prewarmKey, true);
		densityJobsMutex.release();
		if(alreadyQueued)
			return;

		if(densityThreadPool == null)
			densityThreadPool = new FixedThreadPool(LoadingState.getUsableThreadCount(Std.int(Math.max(1, songs.length))));

		densityThreadPool.run(() -> {
			var songPath:String = Paths.formatToSongPath(songName);
			var previewChart:backend.Song.SwagSong = null;
			try
			{
				var raw:String = Song.preloadChartRaw(Highscore.formatSong(songPath, difficulty), songPath);
				if(raw != null) previewChart = Song.parseJSON(raw, songPath, null);
			}
			catch(e:Dynamic)
			{
				try
				{
					var raw:String = Song.preloadChartRaw(songPath, songPath);
					if(raw != null && previewChart == null) previewChart = Song.parseJSON(raw, songPath, null);
				}
				catch(e2:Dynamic) {}
			}

			try Song.preloadChartRaw('events', songPath) catch(e:Dynamic) {}

			// Pre-convert the chart to psych_v1 off-thread, the same way LoadingState precaches images/
			// sounds before PlayState starts. tryStartPreviewPlayback()/tryPrepareSongGameplayLoad() call
			// Song.loadFromJson()/Song.getChart() synchronously on the main thread right after this job
			// finishes, so warming the converted-chart cache here turns that into a cheap Json.parse
			// instead of a full raw-read + convert() stall.
			try Song.precacheConvertedChart(Highscore.formatSong(songPath, difficulty), songPath) catch(e:Dynamic) {}
			try Song.precacheConvertedChart('events', songPath) catch(e:Dynamic) {}

			// Pre-load audio off the main thread so Sound.fromFile doesn't stall on Space press
			preloadPreviewSoundsInBackground(songPath, previewChart);

			#if MODS_ALLOWED
			var seenFiles:Map<String, Bool> = [];
			for(folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'scripts/'))
			{
				cachePreviewDirList(folder);
				prewarmPreviewLuaDirectory(folder, seenFiles);
			}

			for(folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'data/$songPath/'))
			{
				cachePreviewDirList(folder);
				prewarmPreviewLuaDirectory(folder, seenFiles);
			}

			for(filePath in Mods.directoriesWithFile(Paths.getSharedPath(), 'data/' + songPath + '/credits.lua'))
				cachePreviewFileText(filePath);
			#end

			densityJobsMutex.acquire();
			previewPrewarmPending.remove(prewarmKey);
			densityJobsMutex.release();
		});
	}

	function isPreviewPrewarmPending(key:String):Bool
	{
		densityJobsMutex.acquire();
		var pending:Bool = previewPrewarmPending.exists(key);
		densityJobsMutex.release();
		return pending;
	}

	function queueDensityLoad(songName:String, difficulty:Int):Void
	{
		var key:String = getDensityCacheKey(songName, difficulty);
		if(densityCache.exists(key) && densityCache.get(key) != null && densityCache.get(key).analyzed)
			return;
		if(densityThreadPool == null)
			densityThreadPool = new FixedThreadPool(LoadingState.getUsableThreadCount(1));

		densityJobsMutex.acquire();
		var alreadyQueued:Bool = densityPendingJobs.exists(key);
		if(!alreadyQueued)
			densityPendingJobs.set(key, true);
		densityJobsMutex.release();
		if(alreadyQueued)
			return;

		densityThreadPool.run(() -> {
			var result:SongDensityData = null;
			try
			{
				result = buildSongDensityData(songName, difficulty, densityBarCount);
			}
			catch(e:Dynamic)
			{
				result = createFallbackDensityData();
			}

			densityJobsMutex.acquire();
			densityPendingJobs.remove(key);
			densityCompletedJobs.set(key, result != null ? result : createFallbackDensityData());
			densityJobsMutex.release();
		});
	}

	function isDensityLoadPending(key:String):Bool
	{
		densityJobsMutex.acquire();
		var pending:Bool = densityPendingJobs.exists(key);
		densityJobsMutex.release();
		return pending;
	}

	function flushDensityResults():Bool
	{
		var changed:Bool = false;
		var currentKey:String = songs != null && songs.length > 0 && curSelected >= 0 && curSelected < songs.length ? getDensityCacheKey(songs[curSelected].songName, curDifficulty) : null;
		var currentChanged:Bool = false;

		densityJobsMutex.acquire();
		for(key => data in densityCompletedJobs)
		{
			densityCache.set(key, data);
			changed = true;
			if(currentKey != null && key == currentKey)
				currentChanged = true;
		}
		densityCompletedJobs.clear();
		densityJobsMutex.release();

		return changed && currentChanged;
	}

	function warmVisibleDensityCache():Void
	{
		if(songs == null || songs.length < 1)
			return;

		for(song in songs)
			queueDensityLoad(song.songName, curDifficulty);
	}

	static function buildSongDensityData(songName:String, difficulty:Int, densityBarCount:Int):SongDensityData
	{
		var fallbackBars:Array<Float> = [];
		for(i in 0...densityBarCount) fallbackBars.push(0);
		var fallback:SongDensityData = new SongDensityData(0, 0, 0, 0, fallbackBars, '', '');

		var chart:SwagSong = null;
		var songPath:String = Paths.formatToSongPath(songName);
		try
		{
			var chartName:String = Highscore.formatSong(songPath, difficulty);
			chart = Song.getChart(chartName, songPath);
		}
		catch(e:Dynamic)
		{
			try
			{
				chart = Song.getChart(songPath, songPath);
			}
			catch(e2:Dynamic) {}
		}

		if(chart == null || chart.notes == null)
			return fallback;

		var noteTimes:Array<Float> = [];
		var estimatedSongLength:Float = 0;
		var sectionBpm:Float = chart.bpm > 0 ? chart.bpm : 100;
		for(section in chart.notes)
		{
			if(section != null && section.changeBPM && section.bpm > 0)
				sectionBpm = section.bpm;

			var sectionBeats:Float = 4;
			if(section != null && section.sectionBeats > 0)
				sectionBeats = section.sectionBeats;
			estimatedSongLength += (60000 / Math.max(1, sectionBpm)) * Math.max(0, sectionBeats);

			if(section == null || section.sectionNotes == null)
				continue;
			for(note in section.sectionNotes)
			{
				if(note == null || note.length < 2)
					continue;

				var noteLane:Null<Int> = Std.parseInt(Std.string(note[1]).trim());
				if(noteLane == null)
					continue;
				if(noteLane < 0)
					continue;

				var time:Float = Std.parseFloat(Std.string(note[0]).trim());
				if(!Math.isNaN(time))
					noteTimes.push(time);
			}
		}

		if(noteTimes.length < 1)
			return fallback;

		noteTimes.sort(function(a:Float, b:Float) return FlxSort.byValues(FlxSort.ASCENDING, a, b));
		var songLengthMs:Float = Math.max(1, Math.max(noteTimes[noteTimes.length - 1], estimatedSongLength));
		var windowMs:Float = Math.max(1, songLengthMs / densityBarCount);
		var bins:Array<Float> = [];
		for(i in 0...densityBarCount) bins.push(0);

		for(time in noteTimes)
		{
			var idx:Int = Math.floor((time / songLengthMs) * densityBarCount);
			idx = Std.int(FlxMath.bound(idx, 0, densityBarCount - 1));
			bins[idx] += 1;
		}

		var dens:Array<Float> = [];
		var sum:Float = 0;
		var peak:Float = 0;
		for(i in 0...bins.length)
		{
			var d:Float = bins[i] / (windowMs / 1000);
			dens.push(d);
		}

		var densSmooth:Array<Float> = [];
		for(i in 0...dens.length)
		{
			var prev:Float = i > 0 ? dens[i - 1] : dens[i];
			var curr:Float = dens[i];
			var next:Float = i + 1 < dens.length ? dens[i + 1] : dens[i];
			var smooth:Float = (prev * 0.25) + (curr * 0.5) + (next * 0.25);
			densSmooth.push(smooth);
			sum += smooth;
			if(smooth > peak) peak = smooth;
		}

		var avg:Float = densSmooth.length > 0 ? sum / densSmooth.length : 0;
		var varianceSum:Float = 0;
		for(v in densSmooth)
		{
			var delta:Float = v - avg;
			varianceSum += delta * delta;
		}
		var stdDev:Float = densSmooth.length > 0 ? Math.sqrt(varianceSum / densSmooth.length) : 0;

		var sortedDens:Array<Float> = densSmooth.copy();
		sortedDens.sort(function(a:Float, b:Float) return FlxSort.byValues(FlxSort.ASCENDING, a, b));
		var p90Index:Int = sortedDens.length > 0 ? Std.int(Math.floor((sortedDens.length - 1) * 0.90)) : 0;
		var p90:Float = sortedDens.length > 0 ? sortedDens[p90Index] : 0;
		var rawRating:Float = (avg * 0.45) + (p90 * 0.45) + (stdDev * 0.40);
		var rating:Float = Math.max(1, rawRating / 1.8);

		var bpm:Float = chart.bpm > 0 ? chart.bpm : 0;
		var sectionBPMs:Array<Float> = [];
		var bpmWeightedSum:Float = 0;
		var bpmWeightTotal:Float = 0;
		var baseBPM:Float = bpm > 0 ? bpm : 100;
		var curSectionBPM:Float = baseBPM;
		var ignoreIntroBpmSections:Int = 4;

		for(sectionIndex in 0...chart.notes.length)
		{
			var section = chart.notes[sectionIndex];
			if(sectionIndex == ignoreIntroBpmSections)
				curSectionBPM = baseBPM;
			var shouldCountSection:Bool = sectionIndex >= ignoreIntroBpmSections;

			if(section != null && section.changeBPM && section.bpm > 0)
				curSectionBPM = section.bpm;

			if(!shouldCountSection)
				continue;

			if(sectionBPMs.indexOf(curSectionBPM) == -1)
				sectionBPMs.push(curSectionBPM);

			var sectionBeats:Float = 4;
			if(section != null && section.sectionBeats > 0)
				sectionBeats = section.sectionBeats;

			bpmWeightedSum += curSectionBPM * sectionBeats;
			bpmWeightTotal += sectionBeats;
		}

		sectionBPMs.sort(function(a:Float, b:Float) return FlxSort.byValues(FlxSort.ASCENDING, a, b));
		var avgBpm:Float = bpmWeightTotal > 0 ? (bpmWeightedSum / bpmWeightTotal) : bpm;
		var maxBpm:Float = bpm;
		for(v in sectionBPMs)
			if(v > maxBpm) maxBpm = v;
		var hasBpmChanges:Bool = sectionBPMs.length > 1;
		var bpmChangesLabel:String = sectionBPMs.length > 0 ? sectionBPMs.map(function(v:Float) return Std.string(CoolUtil.floorDecimal(v, 2))).join(', ') : Std.string(CoolUtil.floorDecimal(bpm, 2));

		var p1:String = chart.player1 != null ? Std.string(chart.player1).trim() : '';
		var p2:String = chart.player2 != null ? Std.string(chart.player2).trim() : '';
		return new SongDensityData(bpm, CoolUtil.floorDecimal(rating, 2), avg, peak, densSmooth.copy(), p1, p2,
			CoolUtil.floorDecimal(bpm, 2), CoolUtil.floorDecimal(avgBpm, 2), CoolUtil.floorDecimal(maxBpm, 2), bpmChangesLabel, hasBpmChanges, true);
	}

	function loadSongDensityData(songName:String, difficulty:Int):SongDensityData
	{
		var key:String = getDensityCacheKey(songName, difficulty);
		if(densityCache.exists(key))
		{
			var cached:SongDensityData = densityCache.get(key);
			if(cached != null)
			{
				if(!cached.analyzed)
					queueDensityLoad(songName, difficulty);
				return cached;
			}
		}

		queueDensityLoad(songName, difficulty);
		var fallback:SongDensityData = createFallbackDensityData();
		densityCache.set(key, fallback);
		return fallback;
	}

	function updatePreviewBpmDisplay():Void
	{
		if(bpmText == null || currentDensityData == null)
			return;

		var baseBpm:Float = currentDensityData.mainBpm;
		if(baseBpm <= 0)
			baseBpm = currentDensityData.bpm;
		var currentBpm:Float = baseBpm;
		if(player != null && player.playingMusic && FlxG.sound.music != null)
			currentBpm = Conductor.bpm > 0 ? Conductor.bpm : baseBpm;

		if(currentDensityData.hasBpmChanges)
		{
			bpmText.text = 'BPM CURRENT  ' + Std.string(CoolUtil.floorDecimal(currentBpm, 2))
				+ '   AVG ' + Std.string(CoolUtil.floorDecimal(currentDensityData.avgBpm, 2))
				+ '   MAX ' + Std.string(CoolUtil.floorDecimal(currentDensityData.maxBpm, 2));
			bpmChangesText.text = 'Changes: ' + currentDensityData.bpmChangesLabel;
		}
		else
		{
			bpmText.text = 'BPM MAIN  ' + Std.string(CoolUtil.floorDecimal(baseBpm, 2));
			bpmChangesText.text = 'Changes: None';
		}
		bpmChangesText.visible = bpmChangesExpanded && currentDensityData.hasBpmChanges;
	}

	function refreshModernSongDetails():Void
	{
		if(songs == null || songs.length < 1 || curSelected < 0 || curSelected >= songs.length)
			return;

		var songPath:String = Paths.formatToSongPath(songs[curSelected].songName);
		flushDensityResults();
		currentDensityData = loadSongDensityData(songs[curSelected].songName, curDifficulty);
		var densityKey:String = getDensityCacheKey(songs[curSelected].songName, curDifficulty);
		var densityReady:Bool = !isDensityLoadPending(densityKey);
		var bpmValue:Float = currentDensityData != null ? currentDensityData.bpm : 0;
		var densityValue:Float = currentDensityData != null ? currentDensityData.rating : 0;
		if(densityReady)
		{
		updatePreviewBpmDisplay();
			densityText.text = 'DENSITY RATING  ' + Std.string(CoolUtil.floorDecimal(densityValue, 2));
			if(songs.length > 0)
				queuePreviewPrewarm(songs[curSelected].songName, curDifficulty);
		}
		else
		{
			bpmText.text = 'BPM  ANALYZING...';
			bpmChangesText.text = '';
			densityText.text = 'DENSITY RATING  ANALYZING...';
		}
		songTickerText.text = songs[curSelected].songName.toUpperCase();
		var tickerSize:Int = 30;
		if(songTickerText.textField != null)
		{
			var maxTickerWidth:Float = topHeaderPanel.width - 52;
			while(tickerSize > 16 && songTickerText.textField.textWidth > maxTickerWidth)
			{
				tickerSize--;
				songTickerText.setFormat(Paths.font('vcr.ttf'), tickerSize, 0xFFF4FAFF, CENTER);
			}
		}
		var creditsSubtitle:String = getCreditsHeaderSubtitle(songPath);
		if(creditsSubtitle != null && creditsSubtitle.length > 0)
			applySongHeaderSubtitleLayout(creditsSubtitle);
		else
			applySongHeaderSubtitleLayout(buildCenteredHeaderText('DIFF: ' + Difficulty.getString(curDifficulty).toUpperCase(), 'BPM: ' + Std.string(CoolUtil.floorDecimal(bpmValue, 2))));
		if(densityP1Icon != null && densityP2Icon != null)
		{
			var rawIconP1:String = currentDensityData != null ? currentDensityData.player1 : '';
			var rawIconP2:String = currentDensityData != null ? currentDensityData.player2 : '';
			var p1IsBar:Bool = isDensityPlaceholderIcon(rawIconP1);
			var p2IsBar:Bool = isDensityPlaceholderIcon(rawIconP2);
			var songIcon:String = songs[curSelected] != null ? songs[curSelected].songCharacter : '';
			var songIconValid:Bool = isDensityDisplayIcon(songIcon);
			var iconP1:String = isDensityDisplayIcon(rawIconP1) ? rawIconP1.trim() : '';
			var iconP2:String = isDensityDisplayIcon(rawIconP2) ? rawIconP2.trim() : '';
			var soloLabel:Bool = false;
			var singleIconOnly:Bool = false;
			var singleIconIsLeft:Bool = false;

			if(p1IsBar && p2IsBar)
			{
				if(songIconValid)
				{
					iconP2 = songIcon;
					iconP1 = 'bf';
				}
				else
					soloLabel = true;
			}
			else if(p1IsBar && !p2IsBar)
			{
				if(isDensityDisplayIcon(iconP2))
				{
					singleIconOnly = true;
					singleIconIsLeft = true;
				}
				else if(songIconValid)
				{
					iconP2 = songIcon;
					iconP1 = '';
					singleIconOnly = true;
					singleIconIsLeft = false;
				}
				else
					soloLabel = true;
			}
			else if(p2IsBar && !p1IsBar)
			{
				if(isDensityDisplayIcon(iconP1))
				{
					singleIconOnly = true;
					singleIconIsLeft = false;
				}
				else if(songIconValid)
				{
					iconP1 = songIcon;
					iconP2 = '';
					singleIconOnly = true;
					singleIconIsLeft = true;
				}
				else
					soloLabel = true;
			}
			else if(!isDensityDisplayIcon(iconP1) && !isDensityDisplayIcon(iconP2))
			{
				soloLabel = true;
			}

			// iconP1/iconP2 are character names at this point (e.g. from the chart's player1/player2
			// fields, or the freeplay song's character) -- resolve them to the actual healthicon
			// defined in that character's json, since the two don't always match.
			if(iconP1 != null && iconP1.length > 0)
				iconP1 = getHealthIconFromCharacter(iconP1);
			if(iconP2 != null && iconP2.length > 0)
				iconP2 = getHealthIconFromCharacter(iconP2);

			var iconSize:Int = Std.int(Math.max(44.0, Math.min(74.0, vsPanel.height - 20)));
			var vsCenterX:Float = vsPanel.x + (vsPanel.width * 0.5);
			var vsTextWidth:Float = soloLabel ? 120 : (singleIconOnly ? 92 : 64);
			if(soloLabel)
			{
				densityP1Icon.visible = false;
				densityP2Icon.visible = false;
				densityVsText.text = 'SOLO';
				densityVsText.size = 30;
				densityVsText.alpha = 0.95;
			}
			else if(singleIconOnly)
			{
				densityP1Icon.visible = !singleIconIsLeft;
				densityP2Icon.visible = singleIconIsLeft;
				densityVsText.text = '';
				densityVsText.size = 22;
				densityVsText.alpha = 0;

				if(singleIconIsLeft)
				{
					if(iconP2 != densityLeftIconChar)
					{
						densityP2Icon.changeIcon(iconP2);
						densityP2Icon.setGraphicSize(iconSize);
						densityP2Icon.updateHitbox();
						densityLeftIconChar = iconP2;
					}
					densityP2Icon.autoAdjustOffset = false;
					densityP2Icon.offset.set(0, 0);
					densityP2Icon.x = vsCenterX - (iconSize * 0.5);
					densityP2Icon.y = vsPanel.y - vsPanel.height / 3.9;
				}
				else
				{
					if(iconP1 != densityRightIconChar)
					{
						densityP1Icon.changeIcon(iconP1);
						densityP1Icon.setGraphicSize(iconSize);
						densityP1Icon.updateHitbox();
						densityRightIconChar = iconP1;
					}
					densityP1Icon.autoAdjustOffset = false;
					densityP1Icon.offset.set(0, 0);
					densityP1Icon.x = vsCenterX - (iconSize * 0.5);
					densityP1Icon.y = vsPanel.y - vsPanel.height / 3.9;
				}
			}
			else
			{
				densityP1Icon.visible = true;
				densityP2Icon.visible = true;
				densityVsText.alpha = 0.85;
				densityVsText.text = 'VS';
				densityVsText.size = 22;

			if(iconP2 != densityLeftIconChar)
			{
				densityP2Icon.changeIcon(iconP2);
				densityP2Icon.setGraphicSize(iconSize);
				densityP2Icon.updateHitbox();
				densityLeftIconChar = iconP2;
			}
			if(iconP1 != densityRightIconChar)
			{
				densityP1Icon.changeIcon(iconP1);
				densityP1Icon.setGraphicSize(iconSize);
				densityP1Icon.updateHitbox();
				densityRightIconChar = iconP1;
			}
			densityP1Icon.autoAdjustOffset = false;
			densityP2Icon.autoAdjustOffset = false;
			densityP1Icon.offset.set(0, 0);
			densityP2Icon.offset.set(0, 0);
			
			densityP2Icon.x = vsCenterX - 220;
			densityP1Icon.x = vsCenterX + 60;
			}

			// Lock both icons cleanly into the absolute vertical center of the vsPanel
			densityP1Icon.y = vsPanel.y - vsPanel.height / 3.9;
			densityP2Icon.y = vsPanel.y - vsPanel.height / 3.9;

			densityVsText.fieldWidth = vsTextWidth;
			densityVsText.x = vsCenterX - (vsTextWidth * 0.5);
			densityVsText.y = vsPanel.y + (vsPanel.height - densityVsText.height) * 0.5;
		}
		updateDensityBars();
	}

	function isDensityPlaceholderIcon(rawIcon:String):Bool
	{
		if(rawIcon == null)
			return false;

		var lowerIcon:String = rawIcon.toLowerCase().trim();
		return lowerIcon.length < 1 || lowerIcon.indexOf('bar') != -1 || lowerIcon == 'gf-invis';
	}

	function isDensityDisplayIcon(rawIcon:String):Bool
	{
		if(rawIcon == null)
			return false;

		var lowerIcon:String = rawIcon.toLowerCase().trim();
		return lowerIcon.length > 0 && lowerIcon != 'bf' && lowerIcon != 'gf-invis' && lowerIcon.indexOf('bar') == -1;
	}

	function getCurrentWeekIconCharacter():String
	{
		if(songs == null || curSelected < 0 || curSelected >= songs.length)
			return '';

		var weekIndex:Int = songs[curSelected].week;
		if(weekIndex < 0 || weekIndex >= WeekData.weeksList.length)
			return '';

		var weekKey:String = WeekData.weeksList[weekIndex];
		if(weekKey == null || !WeekData.weeksLoaded.exists(weekKey))
			return '';

		var weekData:WeekData = WeekData.weeksLoaded.get(weekKey);
		if(weekData == null || weekData.weekCharacters == null || weekData.weekCharacters.length < 1)
			return '';

		var weekIcon:String = weekData.weekCharacters[0];
		return weekIcon != null ? weekIcon.trim() : '';
	}

	function applySongHeaderSubtitleLayout(value:String):Void
	{
		if(songHeaderSubText == null)
			return;

		var rawText:String = value != null ? value : '';
		rawText = rawText.split('\n').join(' ').trim();
		while(rawText.indexOf('  ') != -1)
			rawText = rawText.split('  ').join(' ');

		var maxWidth:Float = topHeaderPanel != null ? (topHeaderPanel.width - 48) : songHeaderSubText.fieldWidth;
		if(maxWidth <= 0)
			maxWidth = songHeaderSubText.fieldWidth;
		songHeaderSubText.fieldWidth = maxWidth;

		var maxSingleLineSize:Int = 17;
		var minSingleLineSize:Int = 10;
		var fallbackTwoLineSize:Int = 12;
		var minTwoLineSize:Int = 8;

		for(sz in minSingleLineSize...maxSingleLineSize + 1)
		{
			// Loop is ascending; map to descending sizes.
			var size:Int = maxSingleLineSize - (sz - minSingleLineSize);
			songHeaderSubText.setFormat(Paths.font('vcr.ttf'), size, subtitleBaseBlueColor, CENTER);
			songHeaderSubText.text = rawText;
			if(songHeaderSubText.textField != null)
			{
				songHeaderSubText.textField.multiline = false;
				songHeaderSubText.textField.wordWrap = false;
				if(songHeaderSubText.textField.textWidth <= maxWidth - 2)
				{
					applySongHeaderSubtitleMarkup(rawText);
					return;
				}
			}
		}

		var wrappedText:String = rawText;
		for(sz in minTwoLineSize...fallbackTwoLineSize + 1)
		{
			var size:Int = fallbackTwoLineSize - (sz - minTwoLineSize);
			songHeaderSubText.setFormat(Paths.font('vcr.ttf'), size, subtitleBaseBlueColor, CENTER);
			songHeaderSubText.text = wrappedText;
			if(songHeaderSubText.textField != null)
			{
				songHeaderSubText.textField.multiline = true;
				songHeaderSubText.textField.wordWrap = true;
				if(songHeaderSubText.textField.numLines <= 2)
				{
					applySongHeaderSubtitleMarkup(wrappedText);
					return;
				}
			}
		}

		if(songHeaderSubText.textField != null && songHeaderSubText.textField.numLines > 2)
		{
			var tokens:Array<String> = rawText.split(' | ');
			while(tokens.length > 1 && songHeaderSubText.textField.numLines > 2)
			{
				tokens.pop();
				wrappedText = tokens.join(' | ');
				if(tokens.length > 0)
					wrappedText += ' | ...';
				songHeaderSubText.text = wrappedText;
				songHeaderSubText.textField.multiline = true;
				songHeaderSubText.textField.wordWrap = true;
			}
		}

		applySongHeaderSubtitleMarkup(songHeaderSubText.text);
	}

	function applySongHeaderSubtitleMarkup(rawText:String):Void
	{
		if(songHeaderSubText == null)
			return;

		if(rawText == null)
			rawText = '';

		if(subtitleValueFormat == null)
			subtitleValueFormat = new FlxTextFormat(subtitleValueRedColor);

		songHeaderSubText.text = rawText;
		songHeaderSubText.removeFormat(subtitleValueFormat);

		var scanIndex:Int = 0;
		while(scanIndex < rawText.length)
		{
			var segmentEnd:Int = rawText.indexOf('|', scanIndex);
			if(segmentEnd < 0)
				segmentEnd = rawText.length;

			var newLine:Int = rawText.indexOf('\n', scanIndex);
			if(newLine >= 0 && newLine < segmentEnd)
				segmentEnd = newLine;

			var colonIndex:Int = rawText.indexOf(':', scanIndex);
			if(colonIndex >= scanIndex && colonIndex < segmentEnd)
			{
				var valueStart:Int = colonIndex + 1;
				while(valueStart < segmentEnd && StringTools.isSpace(rawText, valueStart))
					valueStart++;

				if(valueStart < segmentEnd)
					songHeaderSubText.addFormat(subtitleValueFormat, valueStart, segmentEnd);
			}

			scanIndex = segmentEnd + 1;
		}
	}

	inline function trimLuaQuotedToken(value:String):String
	{
		if(value == null)
			return '';
		var t:String = value.trim();
		if(t.length >= 2)
		{
			var first:Int = t.charCodeAt(0);
			var last:Int = t.charCodeAt(t.length - 1);
			if((first == '"'.code && last == '"'.code) || (first == '\''.code && last == '\''.code))
				t = t.substr(1, t.length - 2);
		}
		return t.trim();
	}

	function extractLuaTableBody(content:String, tableName:String):String
	{
		if(content == null || tableName == null || tableName.length < 1)
			return null;

		var tableHead:EReg = new EReg('(?:local\\s+)?' + tableName + '\\s*=\\s*\\{', 'i');
		if(!tableHead.match(content))
			return null;

		var mpos = tableHead.matchedPos();
		var index:Int = mpos.pos + mpos.len;
		var depth:Int = 1;
		var quote:Null<Int> = null;
		var escaped:Bool = false;
		var bodyStart:Int = index;

		while(index < content.length)
		{
			var ch:Int = content.charCodeAt(index);
			if(quote != null)
			{
				if(ch == '\\'.code && !escaped)
					escaped = true;
				else
				{
					if(ch == quote && !escaped)
						quote = null;
					escaped = false;
				}
			}
			else
			{
				if(ch == '"'.code || ch == '\''.code)
					quote = ch;
				else if(ch == '{'.code)
					depth++;
				else if(ch == '}'.code)
				{
					depth--;
					if(depth == 0)
						return content.substr(bodyStart, index - bodyStart);
				}
			}
			index++;
		}

		return null;
	}

	function parseLuaStringTable(content:String, tableName:String):Array<String>
	{
		var output:Array<String> = [];
		var body:String = extractLuaTableBody(content, tableName);
		if(body == null || body.length < 1)
			return output;

		var matcher:EReg = ~/["']([^"']+)["']/;
		var startAt:Int = 0;
		while(matcher.matchSub(body, startAt))
		{
			var value:String = matcher.matched(1).trim();
			if(value.length > 0)
				output.push(value);
			var pos = matcher.matchedPos();
			startAt = pos.pos + pos.len;
		}
		return output;
	}

	inline function normalizeCreditsLabel(label:String):String
	{
		if(label == null)
			return '';
		return label.toLowerCase().trim();
	}

	inline function normalizeCreditsPairValue(value:String):String
	{
		if(value == null)
			return '';
		value = trimLuaQuotedToken(value);
		if(value.toLowerCase() == 'null' || value.toLowerCase() == 'nil')
			return '';
		return value;
	}

	inline function isCreditsTagSuffix(tag:String, suffix:String):Bool
	{
		if(tag == null || suffix == null)
			return false;
		return tag.toLowerCase().trim().endsWith(suffix);
	}

	inline function getCreditsTagPrefix(tag:String):String
	{
		if(tag == null)
			return '';
		var lowered:String = tag.toLowerCase().trim();
		if(lowered.endsWith('text'))
			return lowered.substr(0, lowered.length - 4);
		if(lowered.endsWith('person'))
			return lowered.substr(0, lowered.length - 6);
		return lowered;
	}

	function getCreditsLuaMetadataPairs(songPath:String):Array<{label:String, value:String}>
	{
		var pairs:Array<{label:String, value:String}> = [];
		if(songPath == null || songPath.length < 1)
			return pairs;

		var seenLabels:Map<String, Bool> = [];
		inline function pushPair(label:String, value:String):Void
		{
			var prettyLabel:String = normalizeCreditsPairValue(label);
			var prettyValue:String = normalizeCreditsPairValue(value);
			if(prettyLabel.length < 1 || prettyValue.length < 1)
				return;
			var key:String = normalizeCreditsLabel(prettyLabel);
			if(seenLabels.exists(key))
				return;
			seenLabels.set(key, true);
			pairs.push({label: prettyLabel, value: prettyValue});
		}

		for(filePath in Mods.directoriesWithFile(Paths.getSharedPath(), 'data/' + songPath + '/credits.lua'))
		{
			var content:String = cachePreviewFileText(filePath);
			if(content == null || content.length < 1)
				continue;

			var people:Array<String> = parseLuaStringTable(content, 'people');

			// Pattern 1: `people` table values annotated with role comments.
			var peopleBody:String = extractLuaTableBody(content, 'people');
			if(peopleBody != null)
			{
				for(rawLine in peopleBody.split('\n'))
				{
					var line:String = rawLine.trim();
					if(line.length < 1)
						continue;
					var commentPair:EReg = ~/["']([^"']+)["'][^\r\n]*--\s*([^\r\n]+)/;
					if(commentPair.match(line))
						pushPair(commentPair.matched(2), commentPair.matched(1));
				}
			}

			// Pattern 2: paired luaText tags like gameplaytext/gameplayperson.
			var labelByTagKey:Map<String, String> = [];
			var personByTagKey:Map<String, String> = [];
			for(rawLine in content.split('\n'))
			{
				var lineCommentIndex:Int = rawLine.indexOf('--');
				var line:String = (lineCommentIndex >= 0 ? rawLine.substr(0, lineCommentIndex) : rawLine).trim();
				if(line.length < 1)
					continue;

				var luaTextMatch:EReg = ~/luaText\s*\((.*)\)/i;
				if(!luaTextMatch.match(line))
					continue;

				var args:Array<String> = splitLuaArgs(luaTextMatch.matched(1));
				if(args.length < 2)
					continue;

				var tag:String = trimLuaQuotedToken(args[0]);
				if(tag.length < 1)
					continue;

				var tagKey:String = getCreditsTagPrefix(tag);
				var valueArg:String = args[args.length - 1];
				var valueLiteral:String = trimLuaQuotedToken(valueArg);
				var valueResolved:String = valueLiteral;

				var peopleRef:EReg = ~/^people\s*\[\s*(\d+)\s*\]$/i;
				if(peopleRef.match(valueArg.trim()))
				{
					var idx:Int = Std.parseInt(peopleRef.matched(1));
					if(idx > 0 && idx <= people.length)
						valueResolved = people[idx - 1];
				}

				if(isCreditsTagSuffix(tag, 'text'))
				{
					if(valueLiteral.length > 0)
						labelByTagKey.set(tagKey, valueLiteral);
				}
				else if(isCreditsTagSuffix(tag, 'person'))
				{
					if(valueResolved.length > 0)
						personByTagKey.set(tagKey, valueResolved);
				}
			}

			for(tagKey => roleLabel in labelByTagKey)
			{
				if(personByTagKey.exists(tagKey))
					pushPair(roleLabel, personByTagKey.get(tagKey));
			}
		}

		return pairs;
	}

	function getCreditsHeaderSubtitle(songPath:String):String
	{
		if(songPath == null || songPath.length < 1)
			return '';
		if(headerCreditsCache.exists(songPath))
			return headerCreditsCache.get(songPath);

		var pairs:Array<{label:String, value:String}> = getCreditsLuaMetadataPairs(songPath);
		if(pairs == null || pairs.length < 1)
		{
			headerCreditsCache.set(songPath, '');
			return '';
		}

		var tokens:Array<String> = [];
		for(pair in pairs)
			tokens.push(pair.label.toUpperCase() + ': ' + pair.value);

		var result:String = tokens.join(' | ');
		headerCreditsCache.set(songPath, result);
		return result;
	}

inline function repeatSpaces(count:Int):String
{
	var result:String = '';
	for(i in 0...Std.int(Math.max(0, count)))
		result += ' ';
	return result;
}

inline function buildCenteredHeaderText(left:String, right:String):String
{
	if(left == null) left = '';
	if(right == null) right = '';

	var leftLen:Int = left.length;
	var rightLen:Int = right.length;
	var basePad:Int = 3;
	var maxExtraPad:Int = 8;
	var leftPad:Int = basePad;
	var rightPad:Int = basePad;

	if(rightLen > leftLen)
		leftPad += Std.int(Math.min(maxExtraPad, rightLen - leftLen));
	else if(leftLen > rightLen)
		rightPad += Std.int(Math.min(maxExtraPad, leftLen - rightLen));

	return left + repeatSpaces(leftPad) + '|' + repeatSpaces(rightPad) + right;
}

function updateDensityBars():Void
{
	if(densityBars == null || densityBars.length < 1)
		return;

	var graphY:Float = densityPanel.y + 66;
	var graphH:Float = densityPanel.height - 102;
	var graphX:Float = densityPanel.x + 16;
	var graphW:Float = densityPanel.width - 32;
	var bars:Array<Float> = currentDensityData != null ? currentDensityData.timeline : null;
	var avgNps:Float = currentDensityData != null ? currentDensityData.avgNps : 0;
	var peakNps:Float = currentDensityData != null ? currentDensityData.peakNps : 0;
	var spread:Float = Math.max(0, peakNps - avgNps);
	var mediumThreshold:Float = avgNps + (spread * 0.55);
	var hardThreshold:Float = avgNps + (spread * 0.82);
	if(spread < 0.75)
	{
		mediumThreshold = avgNps + 0.9;
		hardThreshold = avgNps + 1.8;
	}
	var visualMaxNps:Float = 10.0;
	if(currentDensityData != null)
	{
		visualMaxNps = Math.max(visualMaxNps, currentDensityData.avgNps + (currentDensityData.peakNps * 0.55));
	}
	var tallestBarTop:Float = graphY + graphH;

	for(i in 0...densityBars.length)
	{
		var bar:FlxSprite = densityBars[i];
		var nps:Float = (bars != null && i < bars.length) ? bars[i] : 0;
		var n:Float = visualMaxNps > 0 ? (nps / visualMaxNps) : 0;
		n = FlxMath.bound(n, 0, 1);
		n = Math.pow(n, 0.82);
		var targetH:Int = Std.int(Math.max(2.0, Math.floor((0.08 + (n * 0.92)) * graphH)));

		var barColor:Int = 0xFF8DD0FF;
		if(nps >= hardThreshold && hardThreshold > 0)
			barColor = 0xFFFF8A8A;
		else if(nps >= mediumThreshold && mediumThreshold > 0)
			barColor = 0xFFFFD27A;

		bar.makeGraphic(bar.frameWidth, targetH, barColor);
		bar.y = graphY + graphH - targetH;
		if(bar.y < tallestBarTop)
			tallestBarTop = bar.y;
	}

	if(densityPeakLine != null)
	{
		densityPeakLine.visible = true;
		densityPeakLine.x = graphX;
		densityPeakLine.y = tallestBarTop;
		densityPeakLine.makeGraphic(Std.int(graphW), 2, 0xFFE8F2FF);
		densityPeakLine.alpha = 0.55;
	}

	triggerPreviewHeaderBop();
}

	function triggerPreviewHeaderBop():Void
	{
		if(topHeaderPanel != null)
		{
			topHeaderPanel.alpha = 1;
			topHeaderPanel.scale.x = 1.01;
			topHeaderPanel.scale.y = 1.12;
			FlxTween.cancelTweensOf(topHeaderPanel.scale);
			FlxTween.cancelTweensOf(topHeaderPanel);
			FlxTween.tween(topHeaderPanel.scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.quadOut});
			FlxTween.tween(topHeaderPanel, {alpha: 0.94}, 0.3, {ease: FlxEase.quadOut});
		}

		if(accentLine != null)
		{
			accentLine.alpha = 1;
			accentLine.scale.y = 2.4;
			FlxTween.cancelTweensOf(accentLine);
			FlxTween.cancelTweensOf(accentLine.scale);
			FlxTween.tween(accentLine, {alpha: 0.16}, 0.34, {ease: FlxEase.sineOut});
			FlxTween.tween(accentLine.scale, {y: 1}, 0.18, {ease: FlxEase.quadOut});
		}

		if(songTickerText != null)
		{
			songTickerText.alpha = 1;
			songTickerText.scale.set(1.12, 1.12);
			FlxTween.cancelTweensOf(songTickerText);
			FlxTween.cancelTweensOf(songTickerText.scale);
			FlxTween.tween(songTickerText, {alpha: 0.86}, 0.3, {ease: FlxEase.quadOut});
			FlxTween.tween(songTickerText.scale, {x: 1, y: 1}, 0.24, {ease: FlxEase.quadOut});
		}

		if(songHeaderSubText != null)
		{
			songHeaderSubText.alpha = 1;
			songHeaderSubText.scale.set(1.14, 1.14);
			FlxTween.cancelTweensOf(songHeaderSubText);
			FlxTween.cancelTweensOf(songHeaderSubText.scale);
			FlxTween.tween(songHeaderSubText, {alpha: 0.74}, 0.32, {ease: FlxEase.quadOut});
			FlxTween.tween(songHeaderSubText.scale, {x: 1, y: 1}, 0.26, {ease: FlxEase.quadOut});
		}
	}

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	public static var opponentVocals:FlxSound = null;
	var holdTime:Float = 0;
	var previewSectionStartTimes:Array<Float> = [];
	var previewSectionStartBeats:Array<Float> = [];
	var previewSectionBPMs:Array<Float> = [];
	var previewSectionIndex:Int = -1;
	var previewSectionBeatIndex:Int = -1;
	var previewZoomTween:FlxTween = null;
	var previewCustomZoomTween:FlxTween = null;
	var previewCustomAngleTween:FlxTween = null;
	var previewSongSpeedTween:FlxTween = null;
	var previewSongSpeed:Float = 1;
	var previewCustomZoomLock:Float = 0;
	var previewEventNotes:Array<EventNote> = [];
	var previewBeatLoopEvents:Array<EventNote> = [];
	var previewHasSongCustomZoom:Bool = false;
	var previewHasBeatZoomEvent:Bool = false;
	var previewNZEventCount:Int = 0;
	var previewNZDisableCount:Int = 0;
	var previewNZEnableCount:Int = 0;
	var previewBeatZoomEnabled:Bool = true;
	var previewBeatZoomHud:Float = 0.03;
	var previewBeatZoomToggleMode:Bool = false;
	var previewBaseCamZoom:Float = 1;
	var previewSZ2Counter:Int = 0;
	var previewSawCustomZoom:Bool = false;
	var previewZoomsDisabled:Bool = false;
	var previewExternalZoomControl:Bool = false;
	var previewScriptCamZoomHud:Bool = true;
	var previewScriptCamZoomBg:Bool = true;
	var previewZoomToggleEventCount:Int = 0;
	var previewZoomToggleHasEnable:Bool = false;
	var previewCameraShaderName:String = '';
	var previewShaderFloatValues:Map<String, Float> = [];
	var previewShaderFloatTweens:Map<String, FlxTween> = [];
	var previewShaderFlip:Bool = false;
	var previewStartupGateActive:Bool = false;
	var previewStartupStableTime:Float = 0;
	var previewEventPushSerial:Int = 0;
	final previewStartupStableThreshold:Float = 0.18;
	#if (!flash && sys)
	var previewRuntimeShaders:Map<String, Array<String>> = [];
	var previewCameraShaders:Map<String, ErrorHandledRuntimeShader> = [];
	#end
	var previewLastMusicTime:Float = -1;
	var previewPendingSongStart:Bool = false;
	var previewLuaOnEventRules:Array<Dynamic> = [];

	inline function parsePreviewEventFloat(value:String):Null<Float>
	{
		if(value == null)
			return null;
		var parsed:Float = Std.parseFloat(value.trim());
		if(Math.isNaN(parsed))
			return null;
		return parsed;
	}

	function parsePreviewToggleValue(value:String):Null<Bool>
	{
		if(value == null)
			return null;

		switch(value.toLowerCase().trim())
		{
			case '1', '2', 'true', 'on', 'yes', 'enable', 'enabled':
				return true;
			case '0', 'false', 'off', 'no', 'disable', 'disabled':
				return false;
		}
		return null;
	}

	inline function sortPreviewEventsByTime(a:EventNote, b:EventNote):Int
		return FlxSort.byValues(FlxSort.ASCENDING, a.strumTime, b.strumTime);

	function clearPreviewEventData():Void
	{
		previewEventNotes = [];
		previewBeatLoopEvents = [];
		previewHasSongCustomZoom = false;
		previewHasBeatZoomEvent = false;
		previewNZEventCount = 0;
		previewNZDisableCount = 0;
		previewNZEnableCount = 0;
		previewBeatZoomEnabled = true;
		previewBeatZoomHud = 0.03;
		previewBeatZoomToggleMode = false;
		previewBaseCamZoom = 1;
		previewSZ2Counter = 0;
		previewSawCustomZoom = false;
		previewZoomsDisabled = false;
		previewExternalZoomControl = false;
		previewScriptCamZoomHud = true;
		previewScriptCamZoomBg = true;
		previewZoomToggleEventCount = 0;
		previewZoomToggleHasEnable = false;
		previewCameraShaderName = '';
		previewShaderFloatValues = [];
		previewShaderFloatTweens = [];
		previewShaderFlip = false;
		previewStartupGateActive = false;
		previewStartupStableTime = 0;
		previewEventPushSerial = 0;
		#if (!flash && sys)
		previewRuntimeShaders = [];
		previewCameraShaders = [];
		#end
		previewLastMusicTime = -1;
		previewPendingSongStart = false;
		previewLuaOnEventRules = [];
	}

	function resetPreviewLoopRuntimeState(songPath:String):Void
	{
		resetPreviewCamera();
		Conductor.bpm = PlayState.SONG != null ? PlayState.SONG.bpm : Conductor.bpm;
		Conductor.offset = PlayState.SONG != null && Reflect.hasField(PlayState.SONG, 'offset') ? PlayState.SONG.offset : 0;
		Conductor.songPosition = 0;
		lastBeatTriggered = -1;
		buildPreviewSectionBPMData();
		loadPreviewEvents(songPath);
	}

	inline function isBeatZoomEventName(eventName:String):Bool
	{
		if(eventName == null)
			return false;
		var normalized:String = eventName.toLowerCase().trim();
		normalized = StringTools.replace(normalized, ' ', '');
		normalized = StringTools.replace(normalized, '_', '');
		normalized = StringTools.replace(normalized, '-', '');
		if(normalized == 'beatzoom' || normalized == 'beatzoom2')
			return true;
		return normalized.indexOf('beatzoom') != -1;
	}

	inline function isBeatZoomToken(value:String):Bool
	{
		if(value == null)
			return false;

		var normalized:String = value.toLowerCase().trim();
		normalized = StringTools.replace(normalized, ' ', '');
		normalized = StringTools.replace(normalized, '_', '');
		normalized = StringTools.replace(normalized, '-', '');
		return normalized == 'beatzoom' || normalized == 'beatzoom2' || normalized.indexOf('beatzoom') != -1;
	}

	inline function isAddCameraZoomToken(value:String):Bool
	{
		if(value == null)
			return false;

		var normalized:String = value.toLowerCase().trim();
		normalized = StringTools.replace(normalized, ' ', '');
		normalized = StringTools.replace(normalized, '_', '');
		normalized = StringTools.replace(normalized, '-', '');
		return normalized.indexOf('addcamerazoom') != -1 || normalized.indexOf('camerazoomedit') != -1;
	}

	function isPreviewEmptyEventCommand(value:String):Bool
	{
		if(value == null)
			return false;

		var normalized:String = value.toLowerCase().trim();
		normalized = StringTools.replace(normalized, ' ', '');
		normalized = StringTools.replace(normalized, '_', '');
		normalized = StringTools.replace(normalized, '-', '');
		switch(normalized)
		{
			case 'zi', 'zo', 'zoomz', 'zoomh', 'sz2', 'sg':
				return true;
		}
		return false;
	}

	inline function hasPreviewCamHUDReference(raw:String):Bool
	{
		if(raw == null)
			return false;

		var normalized:String = raw.toLowerCase().trim();
		normalized = StringTools.replace(normalized, ' ', '');
		normalized = StringTools.replace(normalized, '_', '');
		normalized = StringTools.replace(normalized, '-', '');
		normalized = StringTools.replace(normalized, '"', '');
		normalized = StringTools.replace(normalized, '\'', '');

		return normalized.indexOf('camhud.zoom') != -1
			|| normalized.indexOf('hud.zoom') != -1
			|| normalized.indexOf('defaultcamuizoom') != -1;
	}

	inline function hasAnyPreviewCamHUDReference(eventName:String, value1:String, value2:String):Bool
	{
		return hasPreviewCamHUDReference(eventName)
			|| hasPreviewCamHUDReference(value1)
			|| hasPreviewCamHUDReference(value2);
	}

	function isPreviewUIProperty(path:String):Bool
	{
		if(path == null)
			return false;

		var lowerPath:String = normalizePreviewPropertyPath(path);
		return isPreviewCameraZoomProperty(lowerPath);
	}

	inline function normalizePreviewPropertyPath(path:String):String
	{
		if(path == null)
			return '';

		var normalized:String = path.toLowerCase().trim();
		normalized = StringTools.replace(normalized, '"', '');
		normalized = StringTools.replace(normalized, '\'', '');
		normalized = StringTools.replace(normalized, ' ', '');
		normalized = StringTools.replace(normalized, '..', '');
		return normalized;
	}

	inline function trimPreviewToken(value:String):String
	{
		if(value == null)
			return '';

		var out:String = value.trim();
		if(out.length >= 2)
		{
			var first:String = out.charAt(0);
			var last:String = out.charAt(out.length - 1);
			if((first == '"' && last == '"') || (first == '\'' && last == '\''))
				out = out.substr(1, out.length - 2).trim();
		}
		return out;
	}

	function isPreviewZoomToggleProperty(path:String):Bool
	{
		return false;
	}

	inline function shouldApplyPreviewZoomDisable():Bool
	{
		// Ignore disable calls when the song/scripts never re-enable zoom later.
		return previewZoomToggleHasEnable || previewNZEnableCount > 0;
	}

	function hasPreviewUpcomingZoomReenable():Bool
	{
		for(event in previewEventNotes)
		{
			if(event == null)
				continue;

			var eName:String = event.event != null ? trimPreviewToken(event.event).toLowerCase().trim() : '';
			var v1:String = event.value1 != null ? trimPreviewToken(event.value1) : '';
			var v2:String = event.value2 != null ? trimPreviewToken(event.value2) : '';

			if(eName == 'nz')
			{
				var hudCmd:Null<Float> = parsePreviewEventFloat(v1);
				if(hudCmd != null && hudCmd == 2)
					return true;
			}

			if(eName == 'set property' && isPreviewZoomToggleProperty(v1))
			{
				var toggle:Null<Bool> = parsePreviewToggleValue(v2);
				if(toggle == true)
					return true;
			}
		}

		return false;
	}

	inline function trackPreviewZoomToggleEvent(path:String, value:String):Void
	{
		if(!isPreviewZoomToggleProperty(path))
			return;

		var toggle:Null<Bool> = parsePreviewToggleValue(value);
		if(toggle == null)
			return;

		previewZoomToggleEventCount++;
		if(toggle)
			previewZoomToggleHasEnable = true;
	}

	function isPreviewUIEvent(eventName:String, value1:String, value2:String):Bool
	{
		if(eventName == null)
			return false;

		var lowerEvent:String = eventName.toLowerCase().trim();

		switch(lowerEvent)
		{
			case 'nz':
				return true;
			case 'add camera zoom', 'add camera zoom edit', 'beatzoom':
				return true;
			case '__tweenzoom':
				return isPreviewCameraTarget(value1) || hasPreviewCamHUDReference(value1) || isPreviewCameraZoomProperty(value1);
			case 'set property':
				return isPreviewUIProperty(value1);
		}

		return false;
	}

	function normalizePreviewTargetName(target:String):String
	{
		if(target == null)
			return '';
		var lowered:String = target.toLowerCase().trim();
		lowered = StringTools.replace(lowered, '"', '');
		lowered = StringTools.replace(lowered, '\'', '');
		lowered = StringTools.replace(lowered, ' ', '');
		return lowered;
	}

	inline function isPreviewCameraTarget(target:String):Bool
	{
		var lowerTarget:String = normalizePreviewTargetName(target);
		return lowerTarget == 'hud';
	}

	function applyPreviewCameraZoomTween(target:String, targetZoom:Float, duration:Float, ?easeName:String = 'linear'):Void
	{
		var effectiveTarget:String = normalizePreviewTargetName(target);
		if(effectiveTarget != 'hud')
			return;

		// Tween zoom targets should become the new resting base to avoid post-tween snap-back.
		previewBaseCamZoom = Math.max(0.2, targetZoom);

		if(previewCustomZoomTween != null)
		{
			previewCustomZoomTween.cancel();
			previewCustomZoomTween = null;
		}

		var tweenDur:Float = Math.max(0.01, duration);
		blockBeatZoomForCustom(tweenDur);
		previewCustomZoomTween = FlxTween.tween(FlxG.camera, {zoom: targetZoom}, tweenDur, {
			ease: getPreviewEaseFunc(easeName),
			onComplete: function(_) previewCustomZoomTween = null
		});
	}

	function applyPreviewCameraAngleTween(target:String, targetAngle:Float, duration:Float, ?easeName:String = 'linear'):Void
	{
		var effectiveTarget:String = normalizePreviewTargetName(target);
		if(effectiveTarget != 'hud')
			return;

		if(previewCustomAngleTween != null)
		{
			previewCustomAngleTween.cancel();
			previewCustomAngleTween = null;
		}

		var tweenDur:Float = Math.max(0.01, duration);
		previewCustomAngleTween = FlxTween.tween(FlxG.camera, {angle: targetAngle}, tweenDur, {
			ease: getPreviewEaseFunc(easeName),
			onComplete: function(_) previewCustomAngleTween = null
		});
	}

	function applyPreviewSongSpeedTween(targetSongSpeed:Float, duration:Float, ?easeName:String = 'linear'):Void
	{
		if(previewSongSpeedTween != null)
		{
			previewSongSpeedTween.cancel();
			previewSongSpeedTween = null;
		}

		var tweenDur:Float = Math.max(0.01, duration);
		var startSpeed:Float = previewSongSpeed;
		previewSongSpeedTween = FlxTween.num(startSpeed, targetSongSpeed, tweenDur, {
			ease: getPreviewEaseFunc(easeName),
			onComplete: function(_)
			{
				previewSongSpeedTween = null;
				previewSongSpeed = targetSongSpeed;
			}
		}, function(v:Float)
		{
			previewSongSpeed = v;
		});
	}

	inline function coercePreviewEventValue(value:Dynamic):String
	{
		if(value == null)
			return '';
		if(Std.isOfType(value, String))
			return cast value;
		if(Std.isOfType(value, Bool))
			return value ? 'true' : 'false';
		return Std.string(value);
	}

	function pushPreviewEvent(strumTime:Float, eventName:String, value1:String, value2:String):Void
	{
		var normalizedEvent:String = trimPreviewToken(coercePreviewEventValue(eventName));
		var normalizedValue1:String = trimPreviewToken(coercePreviewEventValue(value1));
		var normalizedValue2:String = trimPreviewToken(coercePreviewEventValue(value2));
		var loweredEvent:String = normalizedEvent.toLowerCase().trim();
		var loweredValue1:String = normalizePreviewPropertyPath(normalizedValue1);
		if(loweredEvent.indexOf('__tweenwindow') == 0 || loweredEvent.indexOf('__setwindow') == 0)
			return;
		if(loweredEvent == 'set property' && loweredValue1.indexOf('window') != -1)
			return;

		var isUIEvent:Bool = isPreviewUIEvent(normalizedEvent, normalizedValue1, normalizedValue2);
		if(normalizedEvent.length < 1 && !isUIEvent)
			return;

		if(isUIEvent)
		{
			if(loweredEvent == 'set property')
				trackPreviewZoomToggleEvent(normalizedValue1, normalizedValue2);
			else if(loweredEvent == 'nz')
			{
				var nzHudCmd:Null<Float> = parsePreviewEventFloat(normalizedValue1);
				var nzBgCmd:Null<Float> = parsePreviewEventFloat(normalizedValue2);
				if((nzHudCmd != null && nzHudCmd == 1) || (nzBgCmd != null && nzBgCmd == 1))
					previewNZDisableCount++;
				if((nzHudCmd != null && nzHudCmd == 2) || (nzBgCmd != null && nzBgCmd == 2))
					previewNZEnableCount++;
			}

			if(isBeatZoomEventName(normalizedEvent) || isBeatZoomToken(normalizedValue1) || isBeatZoomToken(normalizedValue2))
				previewHasBeatZoomEvent = true;
			if(isPreviewBeatZoomEvent(normalizedEvent, normalizedValue1, normalizedValue2))
				previewHasSongCustomZoom = true;
		}

		var orderedStrumTime:Float = strumTime + (previewEventPushSerial * 0.0001);
		previewEventPushSerial++;

		previewEventNotes.push({
			strumTime: orderedStrumTime,
			event: normalizedEvent,
			value1: normalizedValue1,
			value2: normalizedValue2
		});
	}

	function queuePreviewEventsFromSong(songData:SwagSong):Void
	{
		if(songData == null)
			return;
		var hasTopLevelEvents:Bool = songData.events != null && songData.events.length > 0;
		if(hasTopLevelEvents)
		{
			for(event in songData.events)
			{
				if(event == null || event[1] == null)
					continue;

				for(i in 0...event[1].length)
				{
					var eventTime:Null<Float> = parsePreviewEventFloat(Std.string(event[0]));
					if(eventTime == null)
						continue;

					var eventName:String = coercePreviewEventValue(event[1][i][0]);
					var value1:String = coercePreviewEventValue(event[1][i][1]);
					var value2:String = coercePreviewEventValue(event[1][i][2]);
					pushPreviewEvent(eventTime, eventName, value1, value2);
				}
			}
			return;
		}

		if(songData.notes == null)
			return;

		// Fallback for charts that store events directly inside sectionNotes rows.
		for(section in songData.notes)
		{
			if(section == null || section.sectionNotes == null)
				continue;

			for(note in section.sectionNotes)
			{
				if(note == null || note.length < 3)
					continue;

				var strumTime:Null<Float> = parsePreviewEventFloat(Std.string(note[0]));
				if(strumTime == null)
					continue;

				var noteDataStr:String = note.length > 1 ? Std.string(note[1]).trim() : '';
				var noteDataInt:Null<Int> = Std.parseInt(noteDataStr);
				var eventName:String = coercePreviewEventValue(note[2]);
				eventName = eventName.trim();
				if(eventName.length < 1)
					continue;

				// Embedded events usually use a negative note lane marker (commonly -1).
				if(noteDataInt == null || noteDataInt >= 0)
					continue;

				var value1:String = note.length > 3 && note[3] != null ? coercePreviewEventValue(note[3]) : '';
				var value2:String = note.length > 4 && note[4] != null ? coercePreviewEventValue(note[4]) : '';
				pushPreviewEvent(strumTime, eventName, value1, value2);
				continue;
			}
		}
	}

	function splitLuaArgs(text:String):Array<String>
	{
		var output:Array<String> = [];
		if(text == null)
			return output;

		var cur:String = '';
		var parenDepth:Int = 0;
		var braceDepth:Int = 0;
		var bracketDepth:Int = 0;
		var quote:Null<Int> = null;
		var escape:Bool = false;

		for(ch in text)
		{
			var c:String = String.fromCharCode(ch);

			if(escape)
			{
				cur += c;
				escape = false;
				continue;
			}

			if(c == '\\')
			{
				escape = true;
				cur += c;
				continue;
			}

			if(quote != null)
			{
				if(ch == quote)
					quote = null;
				cur += c;
				continue;
			}

			if(c == '"' || c == '\'')
			{
				quote = ch;
				cur += c;
				continue;
			}

			switch(ch)
			{
				case 40: // '('
					parenDepth++;
				case 41: // ')'
					if(parenDepth > 0)
						parenDepth--;
				case 123: // '{'
					braceDepth++;
				case 125: // '}'
					if(braceDepth > 0)
						braceDepth--;
				case 91: // '['
					bracketDepth++;
				case 93: // ']'
					if(bracketDepth > 0)
						bracketDepth--;
				default:
			}

			if(ch == 44 && parenDepth == 0 && braceDepth == 0 && bracketDepth == 0)
			{
				output.push(cur.trim());
				cur = '';
				continue;
			}

			cur += c;
		}

		if(cur.length > 0)
			output.push(cur.trim());
		return output;
	}

	function parseTweenEventValue(value:String):{a:Null<Float>, b:Null<Float>}
	{
		if(value == null)
			return {a: null, b: null};

		var split:Array<String> = value.split(',');
		var a:Null<Float> = split.length > 0 ? parsePreviewEventFloat(split[0]) : null;
		var b:Null<Float> = split.length > 1 ? parsePreviewEventFloat(split[1]) : null;
		return {a: a, b: b};
	}

	function parseTweenEventValueEx(value:String):{a:Null<Float>, b:Null<Float>, ease:String}
	{
		if(value == null)
			return {a: null, b: null, ease: 'linear'};

		var split:Array<String> = value.split(',');
		var a:Null<Float> = split.length > 0 ? parsePreviewEventFloat(split[0]) : null;
		var b:Null<Float> = split.length > 1 ? parsePreviewEventFloat(split[1]) : null;
		var ease:String = split.length > 2 ? split[2].trim() : 'linear';
		return {a: a, b: b, ease: ease};
	}

	function parseDurationEase(value:String):{duration:Null<Float>, ease:String}
	{
		if(value == null)
			return {duration: null, ease: 'linear'};

		if(value.indexOf('|') != -1)
		{
			var parts:Array<String> = value.split('|');
			return {
				duration: parts.length > 0 ? parsePreviewEventFloat(parts[0]) : null,
				ease: parts.length > 1 ? parts[1].trim() : 'linear'
			};
		}

		return {duration: parsePreviewEventFloat(value), ease: 'linear'};
	}

	function getPreviewEaseFunc(name:String):Float->Float
	{
		var n:String = (name != null ? name : 'linear').toLowerCase().trim();
		switch(n)
		{
			case 'linear': return FlxEase.linear;
			case 'sinein': return FlxEase.sineIn;
			case 'sineout': return FlxEase.sineOut;
			case 'sineinout': return FlxEase.sineInOut;
			case 'quadin': return FlxEase.quadIn;
			case 'quadout': return FlxEase.quadOut;
			case 'quadinout': return FlxEase.quadInOut;
			case 'cubein': return FlxEase.cubeIn;
			case 'cubeout': return FlxEase.cubeOut;
			case 'cubeinout': return FlxEase.cubeInOut;
			case 'quartin': return FlxEase.quartIn;
			case 'quartout': return FlxEase.quartOut;
			case 'quartinout': return FlxEase.quartInOut;
			case 'quintin': return FlxEase.quintIn;
			case 'quintout': return FlxEase.quintOut;
			case 'quintinout': return FlxEase.quintInOut;
			case 'expoin': return FlxEase.expoIn;
			case 'expoout': return FlxEase.expoOut;
			case 'expoinout': return FlxEase.expoInOut;
			case 'backin': return FlxEase.backIn;
			case 'backout': return FlxEase.backOut;
			case 'backinout': return FlxEase.backInOut;
			case 'circin': return FlxEase.circIn;
			case 'circout': return FlxEase.circOut;
			case 'circinout': return FlxEase.circInOut;
			case 'bouncein': return FlxEase.bounceIn;
			case 'bounceout': return FlxEase.bounceOut;
			case 'bounceinout': return FlxEase.bounceInOut;
			case 'elasticin': return FlxEase.elasticIn;
			case 'elasticout': return FlxEase.elasticOut;
			case 'elasticinout': return FlxEase.elasticInOut;
		}
		return FlxEase.linear;
	}

	function extractLuaTableNumber(table:String, key:String):Null<Float>
	{
		if(table == null || key == null)
			return null;

		var matcher:EReg = new EReg('(?:^|,|\\{)\\s*' + key + '\\s*=\\s*([-+]?[0-9]*\\.?[0-9]+)', 'i');
		if(!matcher.match(table))
			return null;

		return parsePreviewEventFloat(matcher.matched(1));
	}

	function extractLuaTableString(table:String, key:String):String
	{
		if(table == null || key == null)
			return 'linear';

		var matcher:EReg = new EReg('(?:^|,|\\{)\\s*' + key + '\\s*=\\s*[\"\']?([A-Za-z0-9_]+)[\"\']?', 'i');
		if(!matcher.match(table))
			return 'linear';
		return matcher.matched(1);
	}

	function extractLuaTableRaw(table:String, key:String):String
	{
		if(table == null || key == null)
			return null;

		var matcher:EReg = new EReg('(?:^|,|\\{)\\s*' + key + '\\s*=\\s*([^,\\}]+)', 'i');
		if(!matcher.match(table))
			return null;
		return matcher.matched(1).trim();
	}

	inline function encodeLuaOnEventTemplate(raw:String, nameParam:String, value1Param:String, value2Param:String):String
	{
		if(raw == null)
			return '';

		var t:String = raw.trim();
		var lower:String = t.toLowerCase();
		if(lower == nameParam)
			return '__LUA_EVT_NAME__';
		if(lower == value1Param)
			return '__LUA_EVT_VALUE1__';
		if(lower == value2Param)
			return '__LUA_EVT_VALUE2__';
		return t;
	}

	inline function resolveLuaOnEventTemplate(raw:String, eventName:String, value1:String, value2:String):String
	{
		if(raw == null)
			return '';

		var resolved:String = raw;
		resolved = StringTools.replace(resolved, '__LUA_EVT_NAME__', eventName != null ? eventName : '');
		resolved = StringTools.replace(resolved, '__LUA_EVT_VALUE1__', value1 != null ? value1 : '');
		resolved = StringTools.replace(resolved, '__LUA_EVT_VALUE2__', value2 != null ? value2 : '');
		return resolved;
	}

	inline function applyLuaOnEventAliasTemplates(raw:String, aliasTemplates:Map<String, String>):String
	{
		if(raw == null || aliasTemplates == null)
			return raw;

		var mapped:String = raw;
		for(alias => token in aliasTemplates)
		{
			if(alias == null || token == null)
				continue;
			var matcher:EReg = new EReg('\\b' + alias + '\\b', 'i');
			mapped = matcher.replace(mapped, token);
		}
		return mapped;
	}

	function applyLuaFunctionArgs(raw:String, paramNames:Array<String>, callArgs:Array<String>):String
	{
		if(raw == null)
			return '';
		if(paramNames == null || callArgs == null)
			return raw;

		var mapped:String = raw;
		for(i in 0...paramNames.length)
		{
			if(i >= callArgs.length)
				continue;

			var param:String = paramNames[i];
			if(param == null)
				continue;

			param = param.toLowerCase().trim();
			if(param.length < 1)
				continue;

			var arg:String = callArgs[i] != null ? callArgs[i] : '';
			var matcher:EReg = new EReg('\\b' + param + '\\b', 'i');
			mapped = matcher.replace(mapped, arg);
		}
		return mapped;
	}

	inline function normalizeLuaConditionKeys(keys:Array<String>):Array<String>
	{
		var output:Array<String> = [];
		if(keys == null)
			return output;

		for(raw in keys)
		{
			if(raw == null)
				continue;
			var key:String = raw.toLowerCase().trim();
			if(key.length < 1)
				continue;
			if(output.indexOf(key) == -1)
				output.push(key);
		}
		return output;
	}

	function pushLuaOnEventHandler(eventNames:Array<String>, value1Keys:Array<String>, value2Keys:Array<String>, eventNamesNot:Array<String>, value1KeysNot:Array<String>, value2KeysNot:Array<String>, actionEvent:String, actionValue1:String, actionValue2:String):Void
	{
		if(actionEvent == null)
			return;

		var nameKeys:Array<String> = normalizeLuaConditionKeys(eventNames);
		var v1Keys:Array<String> = normalizeLuaConditionKeys(value1Keys);
		var v2Keys:Array<String> = normalizeLuaConditionKeys(value2Keys);
		var nameNotKeys:Array<String> = normalizeLuaConditionKeys(eventNamesNot);
		var v1NotKeys:Array<String> = normalizeLuaConditionKeys(value1KeysNot);
		var v2NotKeys:Array<String> = normalizeLuaConditionKeys(value2KeysNot);
		if(nameKeys.length < 1 && v1Keys.length < 1 && v2Keys.length < 1 && nameNotKeys.length < 1 && v1NotKeys.length < 1 && v2NotKeys.length < 1)
			return;

		actionEvent = coercePreviewEventValue(actionEvent);
		actionValue1 = coercePreviewEventValue(actionValue1);
		actionValue2 = coercePreviewEventValue(actionValue2);

		previewLuaOnEventRules.push({
			eventNames: nameKeys,
			value1Keys: v1Keys,
			value2Keys: v2Keys,
			eventNamesNot: nameNotKeys,
			value1KeysNot: v1NotKeys,
			value2KeysNot: v2NotKeys,
			action: {
				strumTime: 0,
				event: actionEvent,
				value1: actionValue1 != null ? actionValue1 : '',
				value2: actionValue2 != null ? actionValue2 : ''
			}
		});
	}

	function extractLuaParamConditions(line:String, paramName:String, equalsCheck:Bool):Array<String>
	{
		var output:Array<String> = [];
		if(line == null || paramName == null)
			return output;

		var op:String = equalsCheck ? '==' : '~=';
		var matcher:EReg = new EReg(paramName + '\\s*' + op + '\\s*(?:[\"\']([^\"\']+)[\"\']|([A-Za-z0-9_\\.\\-]+))', 'i');
		var startAt:Int = 0;
		while(matcher.matchSub(line, startAt))
		{
			var cond:String = matcher.matched(1);
			if(cond == null || cond.length < 1)
				cond = matcher.matched(2);
			if(cond != null)
			{
				cond = cond.trim();
				if(cond.length > 0 && output.indexOf(cond) == -1)
					output.push(cond);
			}

			var pos = matcher.matchedPos();
			startAt = pos.pos + pos.len;
		}
		return output;
	}

	function queuePreviewLuaOnEventHandlers(content:String):Void
	{
		if(content == null || content.length < 1)
			return;

		var lines:Array<String> = content.split('\n');
		var zoomFunctionActions:Map<String, Dynamic> = inferLuaZoomActionFunctions(lines);
		var windowWrappers:Map<String, Dynamic> = inferLuaWindowTweenWrappers(lines);
		var windowFunctionActions:Map<String, Dynamic> = inferLuaWindowActionFunctions(lines);
		var inOnEvent:Bool = false;
		var onEventDepth:Int = 0;
		var onEventNameParam:String = 'name';
		var onEventValue1Param:String = 'value1';
		var onEventValue2Param:String = 'value2';
		var activeEventNames:Array<String> = [];
		var activeValue1Keys:Array<String> = [];
		var activeValue2Keys:Array<String> = [];
		var activeEventNamesNot:Array<String> = [];
		var activeValue1KeysNot:Array<String> = [];
		var activeValue2KeysNot:Array<String> = [];
		var onEventAliasTemplates:Map<String, String> = [];

		for(rawLine in lines)
		{
			var commentIndex:Int = rawLine.indexOf('--');
			var line:String = (commentIndex >= 0 ? rawLine.substr(0, commentIndex) : rawLine).trim();
			if(line.length < 1)
				continue;

			if(!inOnEvent)
			{
				var onEventMatch:EReg = ~/^function\s+onEvent\s*\((.*)\)/i;
				if(onEventMatch.match(line))
				{
					var params:Array<String> = splitLuaArgs(onEventMatch.matched(1));
					onEventNameParam = params.length > 0 ? params[0].toLowerCase().trim() : 'name';
					onEventValue1Param = params.length > 1 ? params[1].toLowerCase().trim() : 'value1';
					onEventValue2Param = params.length > 2 ? params[2].toLowerCase().trim() : 'value2';
					if(onEventNameParam.length < 1) onEventNameParam = 'name';
					if(onEventValue1Param.length < 1) onEventValue1Param = 'value1';
					if(onEventValue2Param.length < 1) onEventValue2Param = 'value2';
					inOnEvent = true;
					onEventDepth = 0;
					activeEventNames = [];
					activeValue1Keys = [];
					activeValue2Keys = [];
					activeEventNamesNot = [];
					activeValue1KeysNot = [];
					activeValue2KeysNot = [];
					onEventAliasTemplates = [];
				}
				continue;
			}

			var localTonumberAlias:EReg = ~/^(?:local\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*tonumber\s*\(\s*([A-Za-z_][A-Za-z0-9_]*)/i;
			if(localTonumberAlias.match(line))
			{
				var aliasName:String = localTonumberAlias.matched(1).toLowerCase().trim();
				var aliasSource:String = localTonumberAlias.matched(2).toLowerCase().trim();
				if(aliasSource == onEventNameParam)
					onEventAliasTemplates.set(aliasName, '__LUA_EVT_NAME__');
				else if(aliasSource == onEventValue1Param)
					onEventAliasTemplates.set(aliasName, '__LUA_EVT_VALUE1__');
				else if(aliasSource == onEventValue2Param)
					onEventAliasTemplates.set(aliasName, '__LUA_EVT_VALUE2__');
				else if(onEventAliasTemplates.exists(aliasSource))
					onEventAliasTemplates.set(aliasName, onEventAliasTemplates.get(aliasSource));
			}

			var eventIfMatch:EReg = ~/^(if|elseif)\s+.*\s+then$/i;
			if(eventIfMatch.match(line))
			{
				var names:Array<String> = extractLuaParamConditions(line, onEventNameParam, true);
				var keys1:Array<String> = extractLuaParamConditions(line, onEventValue1Param, true);
				var keys2:Array<String> = extractLuaParamConditions(line, onEventValue2Param, true);
				var namesNot:Array<String> = extractLuaParamConditions(line, onEventNameParam, false);
				var keys1Not:Array<String> = extractLuaParamConditions(line, onEventValue1Param, false);
				var keys2Not:Array<String> = extractLuaParamConditions(line, onEventValue2Param, false);
				var hasTrackedCond:Bool = names.length > 0 || keys1.length > 0 || keys2.length > 0 || namesNot.length > 0 || keys1Not.length > 0 || keys2Not.length > 0;

				if(!hasTrackedCond && onEventDepth <= 0)
				{
					activeEventNames = [];
					activeValue1Keys = [];
					activeValue2Keys = [];
					activeEventNamesNot = [];
					activeValue1KeysNot = [];
					activeValue2KeysNot = [];
				}

				if(names.length > 0)
					activeEventNames = names;

				if(keys1.length > 0)
					activeValue1Keys = keys1;

				if(keys2.length > 0)
					activeValue2Keys = keys2;

				if(namesNot.length > 0)
					activeEventNamesNot = namesNot;

				if(keys1Not.length > 0)
					activeValue1KeysNot = keys1Not;

				if(keys2Not.length > 0)
					activeValue2KeysNot = keys2Not;
			}

			if(activeEventNames.length > 0 || activeValue1Keys.length > 0 || activeValue2Keys.length > 0 || activeEventNamesNot.length > 0 || activeValue1KeysNot.length > 0 || activeValue2KeysNot.length > 0)
			{
				var triggerMatch:EReg = ~/triggerEvent\s*\((.*)\)/i;
				if(triggerMatch.match(line))
				{
					var args:Array<String> = splitLuaArgs(triggerMatch.matched(1));
					if(args.length > 0)
					{
						var mappedEvent:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[0], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
						var mappedV1:String = args.length > 1 ? applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[1], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates) : '';
						var mappedV2:String = args.length > 2 ? applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[2], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates) : '';
						pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, mappedEvent, mappedV1, mappedV2);
					}
				}

				var propMatch:EReg = ~/setProperty\s*\((.*)\)/i;
				if(propMatch.match(line))
				{
					var propArgs:Array<String> = splitLuaArgs(propMatch.matched(1));
					if(propArgs.length > 1 && isPreviewUIProperty(propArgs[0]))
					{
						var mappedPath:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(propArgs[0], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
						var mappedValue:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(propArgs[1], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
						pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, 'Set Property', mappedPath, mappedValue);
					}
				}

				var propClassMatch:EReg = ~/setPropertyFromClass\s*\((.*)\)/i;
				if(propClassMatch.match(line))
				{
					var classArgs:Array<String> = splitLuaArgs(propClassMatch.matched(1));
					if(classArgs.length > 2 && isPreviewUIProperty(classArgs[1]))
					{
						var mappedPath:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(classArgs[1], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
						var mappedValue:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(classArgs[2], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
						pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, 'Set Property', mappedPath, mappedValue);
					}
				}

				var tweenZoomMatch:EReg = ~/doTweenZoom\s*\((.*)\)/i;
				if(tweenZoomMatch.match(line))
				{
					var args:Array<String> = splitLuaArgs(tweenZoomMatch.matched(1));
					if(args.length > 3)
					{
						var target:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[1], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
						if(isPreviewCameraTarget(target))
						{
							var zoomValue:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[2], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							var zoomDuration:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[3], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							var zoomEase:String = args.length > 4 ? applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[4], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates) : 'linear';
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, '__TweenZoom', target, zoomValue + ',' + zoomDuration + ',' + zoomEase);
						}
					}
				}

				var tweenAngleMatch:EReg = ~/doTweenAngle\s*\((.*)\)/i;
				if(tweenAngleMatch.match(line))
				{
					var args:Array<String> = splitLuaArgs(tweenAngleMatch.matched(1));
					if(args.length > 3)
					{
						var target:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[1], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
						if(isPreviewCameraTarget(target))
						{
							var angleValue:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[2], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							var angleDuration:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[3], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							var angleEase:String = args.length > 4 ? applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[4], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates) : 'linear';
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, '__TweenAngle', target, angleValue + ',' + angleDuration + ',' + angleEase);
						}
					}
				}

				var tweenXMatch:EReg = ~/doTweenX\s*\((.*)\)/i;
				if(tweenXMatch.match(line))
				{
					var args:Array<String> = splitLuaArgs(tweenXMatch.matched(1));
					if(args.length > 3)
					{
						var targetVar:String = args[1] != null ? args[1].toLowerCase().trim() : '';
						if(targetVar == 'wnd' || targetVar.indexOf('window') != -1)
						{
							var xValue:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[2], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							var xDuration:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[3], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							var xEase:String = args.length > 4 ? applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[4], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates) : 'linear';
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, '__TweenWindowX', xValue, xDuration + '|' + xEase);
						}
					}
				}

				var tweenYMatch:EReg = ~/doTweenY\s*\((.*)\)/i;
				if(tweenYMatch.match(line))
				{
					var args:Array<String> = splitLuaArgs(tweenYMatch.matched(1));
					if(args.length > 3)
					{
						var targetVar:String = args[1] != null ? args[1].toLowerCase().trim() : '';
						if(targetVar == 'wnd' || targetVar.indexOf('window') != -1)
						{
							var yValue:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[2], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							var yDuration:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[3], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							var yEase:String = args.length > 4 ? applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[4], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates) : 'linear';
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, '__TweenWindowY', yValue, yDuration + '|' + yEase);
						}
					}
				}

				var startTweenMatch:EReg = ~/startTween\s*\((.*)\)/i;
				if(startTweenMatch.match(line))
				{
					var args:Array<String> = splitLuaArgs(startTweenMatch.matched(1));
					if(args.length > 3)
					{
						var target:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[1], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
						var tweenTable:String = args[2] != null ? args[2] : '';
						var duration:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(args[3], onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
						var easeRaw:String = args.length > 4 ? extractLuaTableRaw(args[4], 'ease') : null;
						var ease:String = easeRaw != null ? applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(easeRaw, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates) : 'linear';

						var zoomRaw:String = extractLuaTableRaw(tweenTable, 'zoom');
						if(zoomRaw != null && isPreviewCameraTarget(target))
						{
							var zoom:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(zoomRaw, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, '__TweenZoom', target, zoom + ',' + duration + ',' + ease);
						}

						var angleRaw:String = extractLuaTableRaw(tweenTable, 'angle');
						if(angleRaw != null && isPreviewCameraTarget(target))
						{
							var angle:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(angleRaw, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, '__TweenAngle', target, angle + ',' + duration + ',' + ease);
						}

						var speedRaw:String = extractLuaTableRaw(tweenTable, 'songSpeed');
						if(speedRaw != null)
						{
							var speed:String = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(speedRaw, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, '__TweenSongSpeed', speed, duration + '|' + ease);
						}
					}
				}

				var setWindowMatch:EReg = ~/setWindow\s*\((.*)\)/i;
				if(setWindowMatch.match(line))
				{
					var setWindowArgs:Array<String> = splitLuaArgs(setWindowMatch.matched(1));
					if(setWindowArgs.length >= 2)
					{
						var looksLikeTableCsv:Bool = false;
						if(setWindowArgs.length >= 4)
						{
							var tableRef:EReg = ~/^[A-Za-z_][A-Za-z0-9_]*\s*\[\s*[1-4]\s*\]$/;
							looksLikeTableCsv = tableRef.match(setWindowArgs[0].trim()) && tableRef.match(setWindowArgs[1].trim()) && tableRef.match(setWindowArgs[2].trim()) && tableRef.match(setWindowArgs[3].trim());
						}

						if(looksLikeTableCsv)
						{
							var csvTemplate:String = encodeLuaOnEventTemplate(onEventValue2Param, onEventNameParam, onEventValue1Param, onEventValue2Param);
							csvTemplate = applyLuaOnEventAliasTemplates(csvTemplate, onEventAliasTemplates);
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, '__SetWindowFromCsv', csvTemplate, '');
						}
						else
						{
							var packed:String = setWindowArgs[0] + '|' + setWindowArgs[1] + '|' + (setWindowArgs.length > 2 ? setWindowArgs[2] : '') + '|' + (setWindowArgs.length > 3 ? setWindowArgs[3] : '');
							packed = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(packed, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, '__SetWindow', packed, '');
						}
					}
				}

				var customCall:EReg = ~/^([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)\s*;?$/;
				if(customCall.match(line))
				{
					var callName:String = customCall.matched(1).toLowerCase();
					if(windowFunctionActions.exists(callName))
					{
						var callArgs:Array<String> = splitLuaArgs(customCall.matched(2));
						var wrapperW:Dynamic = windowFunctionActions.get(callName);
						var wrapperParamsW:Array<String> = wrapperW.paramNames;
						var wrapperActionsW:Array<Dynamic> = wrapperW.actions;
						for(a in wrapperActionsW)
						{
							var av1:String = applyLuaFunctionArgs(a.value1, wrapperParamsW, callArgs);
							var av2:String = applyLuaFunctionArgs(a.value2, wrapperParamsW, callArgs);
							av1 = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(av1, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							av2 = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(av2, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, a.event, av1, av2);
						}
					}

					if(windowWrappers.exists(callName))
					{
						var callArgs:Array<String> = splitLuaArgs(customCall.matched(2));
						var wrapper:Dynamic = windowWrappers.get(callName);
						if(wrapper.hasWindowTween)
						{
							var axisRaw:String = wrapper.axisParam < callArgs.length ? callArgs[wrapper.axisParam] : '';
							var amountRaw:String = wrapper.valueParam < callArgs.length ? callArgs[wrapper.valueParam] : '';
							var durationRaw:String = wrapper.durationParam < callArgs.length ? callArgs[wrapper.durationParam] : '0';
							var easeRaw:String = wrapper.easeParam < callArgs.length ? callArgs[wrapper.easeParam] : 'linear';
							axisRaw = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(axisRaw, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							amountRaw = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(amountRaw, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							durationRaw = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(durationRaw, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							easeRaw = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(easeRaw, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							var axisValue:Null<Float> = parsePreviewEventFloat(axisRaw);
							if(axisValue != null)
							{
								if(axisValue == 1)
								{
									var evX:String = wrapper.xRelative ? '__TweenWindowXRel' : '__TweenWindowX';
									pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, evX, amountRaw, durationRaw + '|' + easeRaw);
								}
								else if(axisValue == 2)
								{
									var evY:String = wrapper.yRelative ? '__TweenWindowYRel' : '__TweenWindowY';
									pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, evY, amountRaw, durationRaw + '|' + easeRaw);
								}
							}
						}
					}

					if(zoomFunctionActions.exists(callName))
					{
						var callArgs:Array<String> = splitLuaArgs(customCall.matched(2));
						var wrapper:Dynamic = zoomFunctionActions.get(callName);
						var wrapperParams:Array<String> = wrapper.paramNames;
						var wrapperActions:Array<Dynamic> = wrapper.actions;
						for(a in wrapperActions)
						{
							var av1:String = applyLuaFunctionArgs(a.value1, wrapperParams, callArgs);
							var av2:String = applyLuaFunctionArgs(a.value2, wrapperParams, callArgs);
							av1 = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(av1, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							av2 = applyLuaOnEventAliasTemplates(encodeLuaOnEventTemplate(av2, onEventNameParam, onEventValue1Param, onEventValue2Param), onEventAliasTemplates);
							pushLuaOnEventHandler(activeEventNames, activeValue1Keys, activeValue2Keys, activeEventNamesNot, activeValue1KeysNot, activeValue2KeysNot, a.event, av1, av2);
						}
					}
				}
			}

			if(line == 'end')
			{
				if(onEventDepth <= 0)
				{
					inOnEvent = false;
					activeEventNames = [];
					activeValue1Keys = [];
					activeValue2Keys = [];
					activeEventNamesNot = [];
					activeValue1KeysNot = [];
					activeValue2KeysNot = [];
					continue;
				}
				onEventDepth--;
				if(onEventDepth <= 0)
				{
					activeEventNames = [];
					activeValue1Keys = [];
					activeValue2Keys = [];
					activeEventNamesNot = [];
					activeValue1KeysNot = [];
					activeValue2KeysNot = [];
				}
			}

			if(line.endsWith(' then') || line.endsWith(' do') || line.startsWith('function '))
				onEventDepth++;
		}
	}

	inline function hasLuaBeatZoomTogglePattern(content:String):Bool
	{
		if(content == null || content.length < 1)
			return false;

		var lower:String = content.toLowerCase();
		return lower.indexOf("if n == 'beatzoom'") != -1
			&& lower.indexOf('doit') != -1
			&& lower.indexOf('onbeathit') != -1;
	}

	function triggerPreviewLuaOnEventHandlers(eventName:String, value1:String, value2:String):Bool
	{
		var didCustomZoom:Bool = false;
		var resolvedEventName:String = coercePreviewEventValue(eventName);
		var resolvedValue1:String = coercePreviewEventValue(value1);
		var resolvedValue2:String = coercePreviewEventValue(value2);
		var lowerName:String = resolvedEventName.toLowerCase().trim();
		var lowerV1:String = resolvedValue1.toLowerCase().trim();
		var lowerV2:String = resolvedValue2.toLowerCase().trim();

		for(rule in previewLuaOnEventRules)
		{
			var ruleNames:Array<String> = rule.eventNames;
			var ruleV1:Array<String> = rule.value1Keys;
			var ruleV2:Array<String> = rule.value2Keys;
			var ruleNamesNot:Array<String> = rule.eventNamesNot;
			var ruleV1Not:Array<String> = rule.value1KeysNot;
			var ruleV2Not:Array<String> = rule.value2KeysNot;
			var nameMatch:Bool = ruleNames.length < 1 || ruleNames.indexOf(lowerName) != -1;
			var v1Match:Bool = ruleV1.length < 1 || ruleV1.indexOf(lowerV1) != -1;
			var v2Match:Bool = ruleV2.length < 1 || ruleV2.indexOf(lowerV2) != -1;
			var nameNotMatch:Bool = ruleNamesNot.length < 1 || ruleNamesNot.indexOf(lowerName) == -1;
			var v1NotMatch:Bool = ruleV1Not.length < 1 || ruleV1Not.indexOf(lowerV1) == -1;
			var v2NotMatch:Bool = ruleV2Not.length < 1 || ruleV2Not.indexOf(lowerV2) == -1;
			if(!nameMatch || !v1Match || !v2Match || !nameNotMatch || !v1NotMatch || !v2NotMatch)
				continue;

			var action:EventNote = rule.action;
			var actionEvent:String = resolveLuaOnEventTemplate(action.event, resolvedEventName, resolvedValue1, resolvedValue2);
			var actionValue1:String = resolveLuaOnEventTemplate(action.value1, resolvedEventName, resolvedValue1, resolvedValue2);
			var actionValue2:String = resolveLuaOnEventTemplate(action.value2, resolvedEventName, resolvedValue1, resolvedValue2);
			if(triggerPreviewUIEvent(actionEvent, actionValue1, actionValue2, false))
				didCustomZoom = true;
		}
		return didCustomZoom;
	}

	function inferLuaWindowTweenWrappers(lines:Array<String>):Map<String, Dynamic>
	{
		var wrappers:Map<String, Dynamic> = [];
		var inFunc:Bool = false;
		var funcDepth:Int = 0;
		var funcName:String = '';
		var paramNames:Array<String> = [];
		var aliases:Map<String, String> = [];
		var info:Dynamic = null;

		for(raw in lines)
		{
			var cut:Int = raw.indexOf('--');
			var line:String = (cut >= 0 ? raw.substr(0, cut) : raw).trim();
			if(line.length < 1)
				continue;

			if(!inFunc)
			{
				var f:EReg = ~/^function\s+([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)/i;
				if(f.match(line))
				{
					funcName = f.matched(1);
					paramNames = [];
					for(p in splitLuaArgs(f.matched(2)))
						paramNames.push(p.toLowerCase().trim());

					var axisParam:Int = 0;
					var valueParam:Int = 1;
					var durationParam:Int = 2;
					var easeParam:Int = 3;
					for(i in 0...paramNames.length)
					{
						var pn:String = paramNames[i];
						if(pn == 'a' || pn.indexOf('axis') != -1)
							axisParam = i;
						if(pn == 'v' || pn == 'val' || pn.indexOf('value') != -1)
							valueParam = i;
						if(pn == 'd' || pn.indexOf('dur') != -1 || pn.indexOf('time') != -1)
							durationParam = i;
						if(pn == 'e' || pn.indexOf('ease') != -1)
							easeParam = i;
					}

					info = {
						axisParam: axisParam,
						valueParam: valueParam,
						durationParam: durationParam,
						easeParam: easeParam,
						hasWindowTween: false,
						xRelative: false,
						yRelative: false
					};
					aliases = [];
					inFunc = true;
					funcDepth = 0;
				}
				continue;
			}

			var localAlias:EReg = ~/^local\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*([A-Za-z_][A-Za-z0-9_]*)/i;
			if(localAlias.match(line))
			{
				var lhs:String = localAlias.matched(1).toLowerCase();
				var rhs:String = localAlias.matched(2).toLowerCase();
				if(paramNames.indexOf(rhs) != -1)
					aliases.set(lhs, rhs);
				else if(aliases.exists(rhs))
					aliases.set(lhs, aliases.get(rhs));
			}

			var tweenX:EReg = ~/doTweenX\s*\((.*)\)/i;
			if(tweenX.match(line))
			{
				var args:Array<String> = splitLuaArgs(tweenX.matched(1));
				if(args.length > 2)
				{
					var target:String = args[1].toLowerCase().trim();
					if(target == 'wnd' || target.indexOf('window') != -1)
					{
						info.hasWindowTween = true;
						var expr:String = args[2].toLowerCase();
						var vName:String = info.valueParam < paramNames.length ? paramNames[info.valueParam] : 'v';
						var hasValue:Bool = expr.indexOf(vName) != -1;
						if(!hasValue)
							for(k => original in aliases)
								if(original == vName && expr.indexOf(k) != -1)
									hasValue = true;

						if(hasValue && (expr.indexOf('+') != -1 || expr.indexOf('-') != -1 || expr.indexOf('origin') != -1 || expr.indexOf('current') != -1))
							info.xRelative = true;
					}
				}
			}

			var tweenY:EReg = ~/doTweenY\s*\((.*)\)/i;
			if(tweenY.match(line))
			{
				var args:Array<String> = splitLuaArgs(tweenY.matched(1));
				if(args.length > 2)
				{
					var target:String = args[1].toLowerCase().trim();
					if(target == 'wnd' || target.indexOf('window') != -1)
					{
						info.hasWindowTween = true;
						var expr:String = args[2].toLowerCase();
						var vName:String = info.valueParam < paramNames.length ? paramNames[info.valueParam] : 'v';
						var hasValue:Bool = expr.indexOf(vName) != -1;
						if(!hasValue)
							for(k => original in aliases)
								if(original == vName && expr.indexOf(k) != -1)
									hasValue = true;

						if(hasValue && (expr.indexOf('+') != -1 || expr.indexOf('-') != -1 || expr.indexOf('origin') != -1 || expr.indexOf('current') != -1))
							info.yRelative = true;
					}
				}
			}

			if(line == 'end')
			{
				if(funcDepth <= 0)
				{
					wrappers.set(funcName.toLowerCase(), info);
					inFunc = false;
					continue;
				}
				funcDepth--;
			}

			if(line.endsWith(' then') || line.endsWith(' do') || line.startsWith('function '))
				funcDepth++;
		}

		return wrappers;
	}

	function inferLuaZoomActionFunctions(lines:Array<String>):Map<String, Dynamic>
	{
		var wrappers:Map<String, Dynamic> = [];
		var inFunc:Bool = false;
		var funcDepth:Int = 0;
		var funcName:String = '';
		var paramNames:Array<String> = [];
		var actions:Array<Dynamic> = [];
		var functionCalls:Array<Dynamic> = [];

		for(raw in lines)
		{
			var cut:Int = raw.indexOf('--');
			var line:String = (cut >= 0 ? raw.substr(0, cut) : raw).trim();
			if(line.length < 1)
				continue;

			if(!inFunc)
			{
				var f:EReg = ~/^function\s+([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)/i;
				if(f.match(line))
				{
					funcName = f.matched(1);
					paramNames = [];
					for(p in splitLuaArgs(f.matched(2)))
						paramNames.push(p.toLowerCase().trim());
					actions = [];
					functionCalls = [];
					inFunc = true;
					funcDepth = 0;
				}
				continue;
			}

			var tweenZoomMatch:EReg = ~/doTweenZoom\s*\((.*)\)/i;
			if(tweenZoomMatch.match(line))
			{
				var args:Array<String> = splitLuaArgs(tweenZoomMatch.matched(1));
				if(args.length > 3)
				{
					var target:String = args[1] != null ? args[1] : 'camhud';
					if(!isPreviewCameraTarget(target))
						continue;
					var zoom:String = args[2] != null ? args[2] : '';
					var duration:String = args[3] != null ? args[3] : '0';
					var ease:String = args.length > 4 ? args[4] : 'linear';
					actions.push({
						event: '__TweenZoom',
						value1: target,
						value2: zoom + ',' + duration + ',' + ease
					});
				}
			}

			var tweenAngleMatch:EReg = ~/doTweenAngle\s*\((.*)\)/i;
			if(tweenAngleMatch.match(line))
			{
				var args:Array<String> = splitLuaArgs(tweenAngleMatch.matched(1));
				if(args.length > 3)
				{
					var target:String = args[1] != null ? args[1] : 'camhud';
					if(!isPreviewCameraTarget(target))
						continue;
					var angle:String = args[2] != null ? args[2] : '';
					var duration:String = args[3] != null ? args[3] : '0';
					var ease:String = args.length > 4 ? args[4] : 'linear';
					actions.push({
						event: '__TweenAngle',
						value1: target,
						value2: angle + ',' + duration + ',' + ease
					});
				}
			}

			var propMatch:EReg = ~/setProperty\s*\((.*)\)/i;
			if(propMatch.match(line))
			{
				var propArgs:Array<String> = splitLuaArgs(propMatch.matched(1));
				if(propArgs.length > 1 && isPreviewUIProperty(propArgs[0]))
				{
					actions.push({
						event: 'Set Property',
						value1: propArgs[0],
						value2: propArgs[1]
					});
				}
			}

			var propClassMatch:EReg = ~/setPropertyFromClass\s*\((.*)\)/i;
			if(propClassMatch.match(line))
			{
				var propClassArgs:Array<String> = splitLuaArgs(propClassMatch.matched(1));
				if(propClassArgs.length > 2 && isPreviewUIProperty(propClassArgs[1]))
				{
					actions.push({
						event: 'Set Property',
						value1: propClassArgs[1],
						value2: propClassArgs[2]
					});
				}
			}

			var triggerMatch:EReg = ~/triggerEvent\s*\((.*)\)/i;
			if(triggerMatch.match(line))
			{
				var triggerArgs:Array<String> = splitLuaArgs(triggerMatch.matched(1));
				if(triggerArgs.length > 0)
				{
					var eventName:String = triggerArgs[0];
					var value1:String = triggerArgs.length > 1 ? triggerArgs[1] : '';
					var value2:String = triggerArgs.length > 2 ? triggerArgs[2] : '';
					if(isPreviewUIEvent(eventName, value1, value2))
					{
						actions.push({
							event: eventName,
							value1: value1,
							value2: value2
						});
					}
				}
			}

			var customCall:EReg = ~/^([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)\s*;?$/;
			if(customCall.match(line))
			{
				var callName:String = customCall.matched(1).toLowerCase();
				if(callName != 'triggerevent' && callName != 'setproperty' && callName != 'setpropertyfromclass'
					&& callName != 'dotweenzoom' && callName != 'dotweenangle' && callName != 'dotweenx' && callName != 'dotweeny'
					&& callName != 'starttween' && callName != 'setwindow')
				{
					functionCalls.push({
						name: callName,
						args: splitLuaArgs(customCall.matched(2))
					});
				}
			}

			if(line == 'end')
			{
				if(funcDepth <= 0)
				{
					if(actions.length > 0 || functionCalls.length > 0)
					{
						wrappers.set(funcName.toLowerCase(), {
							paramNames: paramNames.copy(),
							actions: actions.copy(),
							calls: functionCalls.copy()
						});
					}
					inFunc = false;
					continue;
				}
				funcDepth--;
			}

			if(line.endsWith(' then') || line.endsWith(' do') || line.startsWith('function '))
				funcDepth++;
		}

		var resolvedActions:Map<String, Array<Dynamic>> = [];
		var resolving:Map<String, Bool> = [];

		function expandFunctionActions(name:String):Array<Dynamic>
		{
			if(name == null)
				return [];
			var key:String = name.toLowerCase().trim();
			if(key.length < 1)
				return [];
			if(resolvedActions.exists(key))
				return resolvedActions.get(key).copy();
			if(resolving.exists(key))
				return [];
			if(!wrappers.exists(key))
				return [];

			resolving.set(key, true);
			var wrapper:Dynamic = wrappers.get(key);
			var out:Array<Dynamic> = [];
			var ownActions:Array<Dynamic> = wrapper.actions;
			if(ownActions != null)
			{
				for(a in ownActions)
					out.push({event: a.event, value1: a.value1, value2: a.value2});
			}

			var calls:Array<Dynamic> = wrapper.calls;
			if(calls != null)
			{
				for(call in calls)
				{
					var callName:String = call.name;
					if(!wrappers.exists(callName))
						continue;

					var calleeWrapper:Dynamic = wrappers.get(callName);
					var calleeParams:Array<String> = calleeWrapper.paramNames;
					var callArgs:Array<String> = call.args;
					var calleeActions:Array<Dynamic> = expandFunctionActions(callName);
					for(calleeAction in calleeActions)
					{
						out.push({
							event: calleeAction.event,
							value1: applyLuaFunctionArgs(calleeAction.value1, calleeParams, callArgs),
							value2: applyLuaFunctionArgs(calleeAction.value2, calleeParams, callArgs)
						});
					}
				}
			}

			resolvedActions.set(key, out.copy());
			resolving.remove(key);
			return out;
		}

		for(name => wrapper in wrappers)
		{
			var expanded:Array<Dynamic> = expandFunctionActions(name);
			wrapper.actions = expanded;
			wrapper.calls = [];
			wrappers.set(name, wrapper);
		}

		return wrappers;
	}

	function inferLuaWindowActionFunctions(lines:Array<String>):Map<String, Dynamic>
	{
		var wrappers:Map<String, Dynamic> = [];
		var inFunc:Bool = false;
		var funcDepth:Int = 0;
		var funcName:String = '';
		var paramNames:Array<String> = [];
		var actions:Array<Dynamic> = [];

		for(raw in lines)
		{
			var cut:Int = raw.indexOf('--');
			var line:String = (cut >= 0 ? raw.substr(0, cut) : raw).trim();
			if(line.length < 1)
				continue;

			if(!inFunc)
			{
				var f:EReg = ~/^function\s+([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)/i;
				if(f.match(line))
				{
					funcName = f.matched(1);
					paramNames = [];
					for(p in splitLuaArgs(f.matched(2)))
						paramNames.push(p.toLowerCase().trim());
					actions = [];
					inFunc = true;
					funcDepth = 0;
				}
				continue;
			}

			var setWindowMatch:EReg = ~/setWindow\s*\((.*)\)/i;
			if(setWindowMatch.match(line))
			{
				var args:Array<String> = splitLuaArgs(setWindowMatch.matched(1));
				if(args.length >= 2)
				{
					actions.push({
						event: '__SetWindow',
						value1: (args.length > 0 ? args[0] : '') + '|' + (args.length > 1 ? args[1] : '') + '|' + (args.length > 2 ? args[2] : '') + '|' + (args.length > 3 ? args[3] : ''),
						value2: ''
					});
				}
			}

			var propMatch:EReg = ~/setProperty\s*\((.*)\)/i;
			if(propMatch.match(line))
			{
				// Window property actions intentionally unsupported in preview.
			}

			var propClassMatch:EReg = ~/setPropertyFromClass\s*\((.*)\)/i;
			if(propClassMatch.match(line))
			{
				// Window property actions intentionally unsupported in preview.
			}

			if(line == 'end')
			{
				if(funcDepth <= 0)
				{
					if(actions.length > 0)
					{
						wrappers.set(funcName.toLowerCase(), {
							paramNames: paramNames.copy(),
							actions: actions.copy()
						});
					}
					inFunc = false;
					continue;
				}
				funcDepth--;
			}

			if(line.endsWith(' then') || line.endsWith(' do') || line.startsWith('function '))
				funcDepth++;
		}

		return wrappers;
	}

	function extractLuaConditionNumbers(line:String, fieldName:String):Array<Int>
	{
		var output:Array<Int> = [];
		if(line == null || fieldName == null)
			return output;

		inline function pushUnique(value:Int):Void
		{
			if(output.indexOf(value) == -1)
				output.push(value);
		}

		inline function pushRange(startValue:Int, endValue:Int):Void
		{
			if(startValue > endValue)
			{
				var tmp:Int = startValue;
				startValue = endValue;
				endValue = tmp;
			}

			// Safety guard for malformed conditions.
			if(endValue - startValue > 1024)
				return;

			for(v in startValue...endValue + 1)
				pushUnique(v);
		}

		var matcher:EReg = new EReg(fieldName + '\\s*==\\s*(\\d+)', 'i');
		var startAt:Int = 0;
		while(matcher.matchSub(line, startAt))
		{
			var parsed:Int = Std.parseInt(matcher.matched(1));
			pushUnique(parsed);

			var pos = matcher.matchedPos();
			startAt = pos.pos + pos.len;
		}

		function collectRange(pattern:String, leftInclusive:Bool, rightInclusive:Bool):Void
		{
			var rangeMatcher:EReg = new EReg(pattern, 'i');
			var from:Int = 0;
			while(rangeMatcher.matchSub(line, from))
			{
				var a:Int = Std.parseInt(rangeMatcher.matched(1));
				var b:Int = Std.parseInt(rangeMatcher.matched(2));
				var startRange:Int = leftInclusive ? a : a + 1;
				var endRange:Int = rightInclusive ? b : b - 1;
				if(startRange <= endRange)
					pushRange(startRange, endRange);

				var matchedPos = rangeMatcher.matchedPos();
				from = matchedPos.pos + matchedPos.len;
			}
		}

		collectRange(fieldName + '\\s*>=\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*<=\\s*(\\d+)', true, true);
		collectRange(fieldName + '\\s*>=\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*<\\s*(\\d+)', true, false);
		collectRange(fieldName + '\\s*>\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*<=\\s*(\\d+)', false, true);
		collectRange(fieldName + '\\s*>\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*<\\s*(\\d+)', false, false);
		collectRange(fieldName + '\\s*<=\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*>=\\s*(\\d+)', true, true);
		collectRange(fieldName + '\\s*<\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*>=\\s*(\\d+)', false, true);
		collectRange(fieldName + '\\s*<=\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*>\\s*(\\d+)', true, false);
		collectRange(fieldName + '\\s*<\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*>\\s*(\\d+)', false, false);

		var maxBeat:Int = getPreviewSongMaxBeatEstimate();
		var moduloMatcher:EReg = new EReg(fieldName + '\\s*%\\s*(\\d+)\\s*==\\s*(\\d+)', 'i');
		var moduloStart:Int = 0;
		while(moduloMatcher.matchSub(line, moduloStart))
		{
			var modulo:Null<Int> = Std.parseInt(moduloMatcher.matched(1));
			var remainder:Null<Int> = Std.parseInt(moduloMatcher.matched(2));
			if(modulo != null && remainder != null && modulo > 0)
			{
				var normalizedRemainder:Int = remainder % modulo;
				if(normalizedRemainder < 0)
					normalizedRemainder += modulo;

				for(b in 0...maxBeat + 1)
				{
					if((b % modulo) == normalizedRemainder)
						pushUnique(b);
				}
			}

			var mPos = moduloMatcher.matchedPos();
			moduloStart = mPos.pos + mPos.len;
		}

		return output;
	}

	function inferLuaNumericArrayValues(lines:Array<String>):Map<String, Array<Int>>
	{
		var arrays:Map<String, Array<Int>> = [];
		if(lines == null)
			return arrays;

		for(rawLine in lines)
		{
			var cut:Int = rawLine.indexOf('--');
			var line:String = (cut >= 0 ? rawLine.substr(0, cut) : rawLine).trim();
			if(line.length < 1)
				continue;

			var assignMatcher:EReg = ~/^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*\{(.*)\}\s*$/i;
			if(!assignMatcher.match(line))
				continue;

			var name:String = assignMatcher.matched(1).toLowerCase().trim();
			var body:String = assignMatcher.matched(2);
			if(name.length < 1 || body == null)
				continue;

			var values:Array<Int> = [];
			for(rawToken in body.split(','))
			{
				if(rawToken == null)
					continue;
				var token:String = rawToken.trim();
				if(token.length < 1)
					continue;

				var numberMatcher:EReg = ~/^-?\d+/;
				if(!numberMatcher.match(token))
					continue;

				var parsed:Null<Int> = Std.parseInt(numberMatcher.matched(0));
				if(parsed != null)
					values.push(parsed);
			}

			if(values.length > 0)
				arrays.set(name, values);
		}

		return arrays;
	}

	function extractLuaIndexedConditionNumbers(line:String, fieldName:String, numericArrays:Map<String, Array<Int>>):Array<Int>
	{
		var output:Array<Int> = [];
		if(line == null || fieldName == null || numericArrays == null)
			return output;

		inline function pushUnique(value:Int):Void
		{
			if(output.indexOf(value) == -1)
				output.push(value);
		}

		var nameMatcher:EReg = new EReg(fieldName + '\\s*==\\s*([A-Za-z_][A-Za-z0-9_]*)\\s*\\[\\s*[A-Za-z_][A-Za-z0-9_]*\\s*\\]', 'i');
		var fromName:Int = 0;
		while(nameMatcher.matchSub(line, fromName))
		{
			var arrayName:String = nameMatcher.matched(1).toLowerCase().trim();
			if(numericArrays.exists(arrayName))
			{
				for(v in numericArrays.get(arrayName))
					pushUnique(v);
			}
			var matchedPos = nameMatcher.matchedPos();
			fromName = matchedPos.pos + matchedPos.len;
		}

		var indexMatcher:EReg = new EReg(fieldName + '\\s*==\\s*([A-Za-z_][A-Za-z0-9_]*)\\s*\\[\\s*(\\d+)\\s*\\]', 'i');
		var fromIndex:Int = 0;
		while(indexMatcher.matchSub(line, fromIndex))
		{
			var arrayKey:String = indexMatcher.matched(1).toLowerCase().trim();
			var oneBasedIndex:Null<Int> = Std.parseInt(indexMatcher.matched(2));
			if(oneBasedIndex != null && oneBasedIndex > 0 && numericArrays.exists(arrayKey))
			{
				var list:Array<Int> = numericArrays.get(arrayKey);
				var idx:Int = oneBasedIndex - 1;
				if(idx >= 0 && idx < list.length)
					pushUnique(list[idx]);
			}
			var idxPos = indexMatcher.matchedPos();
			fromIndex = idxPos.pos + idxPos.len;
		}

		return output;
	}

	function extractLuaDirectConditionNumbers(line:String, fieldName:String):Array<Int>
	{
		var output:Array<Int> = [];
		if(line == null || fieldName == null)
			return output;

		inline function pushUnique(value:Int):Void
		{
			if(output.indexOf(value) == -1)
				output.push(value);
		}

		inline function pushRange(startValue:Int, endValue:Int):Void
		{
			if(startValue > endValue)
			{
				var tmp:Int = startValue;
				startValue = endValue;
				endValue = tmp;
			}
			if(endValue - startValue > 1024)
				return;
			for(v in startValue...endValue + 1)
				pushUnique(v);
		}

		var matcher:EReg = new EReg(fieldName + '\\s*==\\s*(\\d+)', 'i');
		var startAt:Int = 0;
		while(matcher.matchSub(line, startAt))
		{
			var parsed:Int = Std.parseInt(matcher.matched(1));
			pushUnique(parsed);
			var pos = matcher.matchedPos();
			startAt = pos.pos + pos.len;
		}

		function collectRange(pattern:String, leftInclusive:Bool, rightInclusive:Bool):Void
		{
			var rangeMatcher:EReg = new EReg(pattern, 'i');
			var from:Int = 0;
			while(rangeMatcher.matchSub(line, from))
			{
				var a:Int = Std.parseInt(rangeMatcher.matched(1));
				var b:Int = Std.parseInt(rangeMatcher.matched(2));
				var startRange:Int = leftInclusive ? a : a + 1;
				var endRange:Int = rightInclusive ? b : b - 1;
				if(startRange <= endRange)
					pushRange(startRange, endRange);
				var matchedPos = rangeMatcher.matchedPos();
				from = matchedPos.pos + matchedPos.len;
			}
		}

		collectRange(fieldName + '\\s*>=\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*<=\\s*(\\d+)', true, true);
		collectRange(fieldName + '\\s*>=\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*<\\s*(\\d+)', true, false);
		collectRange(fieldName + '\\s*>\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*<=\\s*(\\d+)', false, true);
		collectRange(fieldName + '\\s*>\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*<\\s*(\\d+)', false, false);
		collectRange(fieldName + '\\s*<=\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*>=\\s*(\\d+)', true, true);
		collectRange(fieldName + '\\s*<\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*>=\\s*(\\d+)', false, true);
		collectRange(fieldName + '\\s*<=\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*>\\s*(\\d+)', true, false);
		collectRange(fieldName + '\\s*<\\s*(\\d+)\\s*and\\s*' + fieldName + '\\s*>\\s*(\\d+)', false, false);

		return output;
	}

	function getPreviewSongMaxBeatEstimate():Int
	{
		if(PlayState.SONG == null || PlayState.SONG.notes == null)
			return 1024;

		var beatSum:Float = 0;
		for(section in PlayState.SONG.notes)
		{
			var sectionBeats:Float = 4;
			if(section != null && section.sectionBeats > 0)
				sectionBeats = section.sectionBeats;
			beatSum += sectionBeats;
		}

		if(beatSum <= 0)
			beatSum = 1024;
		return Std.int(Math.ceil(beatSum + 8));
	}

	inline function normalizeLuaFlagName(value:String):String
	{
		if(value == null)
			return '';
		return value.toLowerCase().trim();
	}

	function extractLuaConditionFlags(line:String):{mustTrue:Array<String>, mustFalse:Array<String>}
	{
		var mustTrue:Array<String> = [];
		var mustFalse:Array<String> = [];
		if(line == null)
			return {mustTrue: mustTrue, mustFalse: mustFalse};

		var falseMatcher:EReg = ~/\bnot\s+([A-Za-z_][A-Za-z0-9_]*)/i;
		var startFalse:Int = 0;
		while(falseMatcher.matchSub(line, startFalse))
		{
			var keyFalse:String = normalizeLuaFlagName(falseMatcher.matched(1));
			if(keyFalse.length > 0 && mustFalse.indexOf(keyFalse) == -1)
				mustFalse.push(keyFalse);
			var falsePos = falseMatcher.matchedPos();
			startFalse = falsePos.pos + falsePos.len;
		}

		var trueMatcher:EReg = ~/\b([A-Za-z_][A-Za-z0-9_]*)\b\s+and/i;
		var startTrue:Int = 0;
		while(trueMatcher.matchSub(line, startTrue))
		{
			var keyTrue:String = normalizeLuaFlagName(trueMatcher.matched(1));
			if(keyTrue.length > 0
				&& keyTrue != 'if' && keyTrue != 'elseif' && keyTrue != 'and' && keyTrue != 'or' && keyTrue != 'not'
				&& keyTrue != 'curbeat' && keyTrue != 'curstep' && keyTrue != 'true' && keyTrue != 'false'
				&& mustTrue.indexOf(keyTrue) == -1)
				mustTrue.push(keyTrue);
			var truePos = trueMatcher.matchedPos();
			startTrue = truePos.pos + truePos.len;
		}

		return {mustTrue: mustTrue, mustFalse: mustFalse};
	}

	function inferLuaOnBeatFlagWindows(lines:Array<String>):Map<String, Array<{start:Int, end:Int}>>
	{
		var toggles:Map<String, Array<{beat:Int, state:Bool}>> = [];
		var windows:Map<String, Array<{start:Int, end:Int}>> = [];
		if(lines == null)
			return windows;

		var inOnBeatHit:Bool = false;
		var onBeatDepth:Int = 0;
		var currentGatedBeats:Array<Int> = [];

		for(rawLine in lines)
		{
			var cut:Int = rawLine.indexOf('--');
			var line:String = (cut >= 0 ? rawLine.substr(0, cut) : rawLine).trim();
			if(line.length < 1)
				continue;

			if(!inOnBeatHit)
			{
				var onBeatFuncMatch:EReg = ~/function\s+onBeatHit\s*\(/i;
				if(onBeatFuncMatch.match(line))
				{
					inOnBeatHit = true;
					onBeatDepth = 0;
					currentGatedBeats = [];
				}
				continue;
			}

			if(line == 'end')
			{
				if(onBeatDepth <= 0)
				{
					inOnBeatHit = false;
					continue;
				}
				onBeatDepth--;
				if(onBeatDepth <= 0)
					currentGatedBeats = [];
				continue;
			}

			var isConditionBranch:Bool = (line.startsWith('if ') || line.startsWith('elseif ')) && line.endsWith(' then');
			if(isConditionBranch)
				currentGatedBeats = extractLuaDirectConditionNumbers(line, 'curBeat');
			else if(line == 'else' || line.startsWith('else '))
				currentGatedBeats = [];

			var assignMatch:EReg = ~/^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(true|false)\b/i;
			if(assignMatch.match(line) && currentGatedBeats.length > 0)
			{
				var rawName:String = normalizeLuaFlagName(assignMatch.matched(1));
				var state:Bool = assignMatch.matched(2).toLowerCase() == 'true';
				if(rawName.length > 0)
				{
					if(!toggles.exists(rawName))
						toggles.set(rawName, []);
					var list:Array<{beat:Int, state:Bool}> = toggles.get(rawName);
					for(b in currentGatedBeats)
						list.push({beat: b, state: state});
				}
			}

			if(line.endsWith(' then') || line.endsWith(' do') || line.startsWith('function '))
				onBeatDepth++;
		}

		var maxBeat:Int = getPreviewSongMaxBeatEstimate();
		for(name => list in toggles)
		{
			list.sort(function(a:{beat:Int, state:Bool}, b:{beat:Int, state:Bool}) return FlxSort.byValues(FlxSort.ASCENDING, a.beat, b.beat));
			var out:Array<{start:Int, end:Int}> = [];
			var active:Bool = false;
			var startBeat:Int = 0;
			for(entry in list)
			{
				if(entry.state && !active)
				{
					active = true;
					startBeat = entry.beat;
				}
				else if(!entry.state && active)
				{
					out.push({start: startBeat, end: entry.beat - 1});
					active = false;
				}
			}
			if(active)
				out.push({start: startBeat, end: maxBeat});

			if(out.length > 0)
				windows.set(name, out);
		}

		return windows;
	}

	function inferLuaOnStepFlagBeatWindows(lines:Array<String>, numericArrays:Map<String, Array<Int>>):Map<String, Array<{start:Int, end:Int}>>
	{
		var toggles:Map<String, Array<{step:Int, state:Bool}>> = [];
		var windows:Map<String, Array<{start:Int, end:Int}>> = [];
		if(lines == null)
			return windows;

		var inOnStepHit:Bool = false;
		var onStepDepth:Int = 0;
		var currentGatedSteps:Array<Int> = [];

		for(rawLine in lines)
		{
			var cut:Int = rawLine.indexOf('--');
			var line:String = (cut >= 0 ? rawLine.substr(0, cut) : rawLine).trim();
			if(line.length < 1)
				continue;

			if(!inOnStepHit)
			{
				var onStepFuncMatch:EReg = ~/function\s+onStepHit\s*\(/i;
				if(onStepFuncMatch.match(line))
				{
					inOnStepHit = true;
					onStepDepth = 0;
					currentGatedSteps = [];
				}
				continue;
			}

			if(line == 'end')
			{
				if(onStepDepth <= 0)
				{
					inOnStepHit = false;
					continue;
				}
				onStepDepth--;
				if(onStepDepth <= 0)
					currentGatedSteps = [];
				continue;
			}

			var isConditionBranch:Bool = (line.startsWith('if ') || line.startsWith('elseif ')) && line.endsWith(' then');
			if(isConditionBranch)
			{
				currentGatedSteps = extractLuaConditionNumbers(line, 'curStep');
				var indexed:Array<Int> = extractLuaIndexedConditionNumbers(line, 'curStep', numericArrays);
				for(v in indexed)
					if(currentGatedSteps.indexOf(v) == -1)
						currentGatedSteps.push(v);
			}
			else if(line == 'else' || line.startsWith('else '))
				currentGatedSteps = [];

			var assignMatch:EReg = ~/^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(true|false)\b/i;
			if(assignMatch.match(line) && currentGatedSteps.length > 0)
			{
				var rawName:String = normalizeLuaFlagName(assignMatch.matched(1));
				var state:Bool = assignMatch.matched(2).toLowerCase() == 'true';
				if(rawName.length > 0)
				{
					if(!toggles.exists(rawName))
						toggles.set(rawName, []);
					var list:Array<{step:Int, state:Bool}> = toggles.get(rawName);
					for(s in currentGatedSteps)
						list.push({step: s, state: state});
				}
			}

			if(line.endsWith(' then') || line.endsWith(' do') || line.startsWith('function '))
				onStepDepth++;
		}

		var maxBeat:Int = getPreviewSongMaxBeatEstimate();
		for(name => list in toggles)
		{
			list.sort(function(a:{step:Int, state:Bool}, b:{step:Int, state:Bool}) return FlxSort.byValues(FlxSort.ASCENDING, a.step, b.step));
			var out:Array<{start:Int, end:Int}> = [];
			var active:Bool = false;
			var startBeat:Int = 0;
			for(entry in list)
			{
				var atBeat:Int = Std.int(Math.ceil(entry.step / 4));
				if(entry.state && !active)
				{
					active = true;
					startBeat = atBeat;
				}
				else if(!entry.state && active)
				{
					var endBeat:Int = atBeat - 1;
					if(endBeat >= startBeat)
						out.push({start: startBeat, end: endBeat});
					active = false;
				}
			}
			if(active)
				out.push({start: startBeat, end: maxBeat});

			if(out.length > 0)
				windows.set(name, out);
		}

		return windows;
	}

	function filterLuaBeatsByFlagWindows(beats:Array<Int>, flags:{mustTrue:Array<String>, mustFalse:Array<String>}, windows:Map<String, Array<{start:Int, end:Int}>>):Array<Int>
	{
		if(beats == null)
			return [];
		if(flags == null || windows == null)
			return beats.copy();

		function isInWindows(beat:Int, ranges:Array<{start:Int, end:Int}>):Bool
		{
			if(ranges == null)
				return false;
			for(range in ranges)
				if(range != null && beat >= range.start && beat <= range.end)
					return true;
			return false;
		}

		var output:Array<Int> = [];
		for(beat in beats)
		{
			var pass:Bool = true;
			for(flagName in flags.mustTrue)
			{
				if(!windows.exists(flagName) || !isInWindows(beat, windows.get(flagName)))
				{
					pass = false;
					break;
				}
			}
			if(!pass)
				continue;

			for(flagName in flags.mustFalse)
			{
				if(windows.exists(flagName) && isInWindows(beat, windows.get(flagName)))
				{
					pass = false;
					break;
				}
			}
			if(pass && output.indexOf(beat) == -1)
				output.push(beat);
		}
		return output;
	}

	function getPreviewGatedTimes(gatedSteps:Array<Int>, gatedBeats:Array<Int>):Array<Float>
	{
		var times:Array<Float> = [];
		if(gatedSteps != null && gatedSteps.length > 0)
		{
			for(step in gatedSteps)
			{
				var t:Float = previewTimeFromStep(step);
				if(times.indexOf(t) == -1)
					times.push(t);
			}
			return times;
		}

		if(gatedBeats != null)
		{
			for(beat in gatedBeats)
			{
				var t:Float = previewTimeFromBeat(beat);
				if(times.indexOf(t) == -1)
					times.push(t);
			}
		}
		return times;
	}

	function pushPreviewEventAtGates(eventName:String, value1:String, value2:String, gatedSteps:Array<Int>, gatedBeats:Array<Int>):Bool
	{
		var times:Array<Float> = getPreviewGatedTimes(gatedSteps, gatedBeats);
		if(times.length < 1)
			return false;

		for(t in times)
			pushPreviewEvent(t, eventName, value1, value2);
		return true;
	}

	function queuePreviewScriptDerivedEvent(eventName:String, value1:String, value2:String, inOnBeatHit:Bool, inStartupFunc:Bool, gatedSteps:Array<Int>, gatedBeats:Array<Int>):Void
	{
		if(inOnBeatHit && gatedSteps.length < 1 && gatedBeats.length < 1)
		{
			previewBeatLoopEvents.push({
				strumTime: 0,
				event: eventName,
				value1: value1,
				value2: value2
			});
			return;
		}

		if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
		{
			pushPreviewEvent(0, eventName, value1, value2);
			return;
		}

		if(!pushPreviewEventAtGates(eventName, value1, value2, gatedSteps, gatedBeats) && gatedSteps.length < 1 && gatedBeats.length < 1)
			pushPreviewEvent(0, eventName, value1, value2);
	}

	inline function previewTimeFromStep(step:Int):Float
		return Conductor.beatToSeconds(step / 4) - Conductor.offset;

	inline function previewTimeFromBeat(beat:Int):Float
		return Conductor.beatToSeconds(beat) - Conductor.offset;

	function isPreviewBeatZoomEvent(eventName:String, value1:String, ?value2:String = null):Bool
	{
		if(eventName == null)
			return false;

		var lowerEvent:String = eventName.toLowerCase().trim();

		if(lowerEvent == 'add camera zoom' || lowerEvent == 'add camera zoom edit' || lowerEvent == 'beatzoom')
			return true;

		if(lowerEvent == 'set property')
			return isPreviewCameraZoomProperty(value1);

		if(lowerEvent == '__tweenzoom')
			return isPreviewCameraTarget(value1) || isPreviewCameraZoomProperty(value1);

		return false;
	}

	function queuePreviewEventsFromLuaContent(content:String):Void
	{
		if(content == null || content.length < 1)
			return;

		if(hasLuaBeatZoomTogglePattern(content))
			previewBeatZoomToggleMode = true;

		queuePreviewLuaOnEventHandlers(content);

		var lines:Array<String> = content.split('\n');
		var numericArrays:Map<String, Array<Int>> = inferLuaNumericArrayValues(lines);
		var beatFlagWindows:Map<String, Array<{start:Int, end:Int}>> = inferLuaOnBeatFlagWindows(lines);
		var stepFlagBeatWindows:Map<String, Array<{start:Int, end:Int}>> = inferLuaOnStepFlagBeatWindows(lines, numericArrays);
		for(flagName => ranges in stepFlagBeatWindows)
		{
			if(!beatFlagWindows.exists(flagName))
				beatFlagWindows.set(flagName, ranges.copy());
			else
			{
				var merged:Array<{start:Int, end:Int}> = beatFlagWindows.get(flagName);
				for(range in ranges)
					merged.push(range);
			}
		}
		var windowWrappers:Map<String, Dynamic> = inferLuaWindowTweenWrappers(lines);
		var zoomFunctionActions:Map<String, Dynamic> = inferLuaZoomActionFunctions(lines);
		var windowFunctionActions:Map<String, Dynamic> = inferLuaWindowActionFunctions(lines);
		var gatedSteps:Array<Int> = [];
		var gatedBeats:Array<Int> = [];
		var onBeatHitDepth:Int = 0;
		var inOnBeatHit:Bool = false;
		var inOnSongStart:Bool = false;
		var onSongStartDepth:Int = 0;
		var inOnCreate:Bool = false;
		var onCreateDepth:Int = 0;
		var inOnCreatePost:Bool = false;
		var onCreatePostDepth:Int = 0;
		var inOnCountdownStarted:Bool = false;
		var onCountdownStartedDepth:Int = 0;

		for(rawLine in lines)
		{
			var commentIndex:Int = rawLine.indexOf('--');
			var line:String = (commentIndex >= 0 ? rawLine.substr(0, commentIndex) : rawLine).trim();
			if(line.length < 1)
				continue;

			var onBeatFuncMatch:EReg = ~/function\s+onBeatHit\s*\(/i;
			if(onBeatFuncMatch.match(line))
			{
				inOnBeatHit = true;
				onBeatHitDepth = 0;
				continue;
			}

			var onSongStartFuncMatch:EReg = ~/function\s+onSongStart\s*\(/i;
			if(onSongStartFuncMatch.match(line))
			{
				inOnSongStart = true;
				onSongStartDepth = 0;
				continue;
			}

			var onCreateFuncMatch:EReg = ~/function\s+onCreate\s*\(/i;
			if(onCreateFuncMatch.match(line))
			{
				inOnCreate = true;
				onCreateDepth = 0;
				continue;
			}

			var onCreatePostFuncMatch:EReg = ~/function\s+onCreatePost\s*\(/i;
			if(onCreatePostFuncMatch.match(line))
			{
				inOnCreatePost = true;
				onCreatePostDepth = 0;
				continue;
			}

			var onCountdownStartedFuncMatch:EReg = ~/function\s+onCountdownStarted\s*\(/i;
			if(onCountdownStartedFuncMatch.match(line))
			{
				inOnCountdownStarted = true;
				onCountdownStartedDepth = 0;
				continue;
			}

			var isConditionBranch:Bool = (line.startsWith('if ') || line.startsWith('elseif ')) && line.endsWith(' then');
			var isElseBranch:Bool = line == 'else' || line.startsWith('else ');
			if(isConditionBranch)
			{
				var stepMatches:Array<Int> = extractLuaConditionNumbers(line, 'curStep');
				var beatMatches:Array<Int> = extractLuaConditionNumbers(line, 'curBeat');
				var stepIndexedMatches:Array<Int> = extractLuaIndexedConditionNumbers(line, 'curStep', numericArrays);
				for(v in stepIndexedMatches)
					if(stepMatches.indexOf(v) == -1)
						stepMatches.push(v);
				var beatIndexedMatches:Array<Int> = extractLuaIndexedConditionNumbers(line, 'curBeat', numericArrays);
				for(v in beatIndexedMatches)
					if(beatMatches.indexOf(v) == -1)
						beatMatches.push(v);
				if(inOnBeatHit && beatMatches.length > 0)
				{
					var flagReq = extractLuaConditionFlags(line);
					if(flagReq.mustTrue.length > 0 || flagReq.mustFalse.length > 0)
						beatMatches = filterLuaBeatsByFlagWindows(beatMatches, flagReq, beatFlagWindows);
				}
				else if(inOnBeatHit && beatMatches.length < 1)
				{
					var flagOnlyReq = extractLuaConditionFlags(line);
					if(flagOnlyReq.mustTrue.length > 0 || flagOnlyReq.mustFalse.length > 0)
					{
						var allBeats:Array<Int> = [];
						var maxBeat:Int = getPreviewSongMaxBeatEstimate();
						for(b in 0...maxBeat + 1)
							allBeats.push(b);
						beatMatches = filterLuaBeatsByFlagWindows(allBeats, flagOnlyReq, beatFlagWindows);
					}
				}
				if(stepMatches.length > 0)
				{
					gatedSteps = stepMatches;
					gatedBeats = [];
				}
				else if(beatMatches.length > 0)
				{
					gatedBeats = beatMatches;
					gatedSteps = [];
				}
				else
				{
					gatedSteps = [];
					gatedBeats = [];
				}
			}
			else if(isElseBranch)
			{
				gatedSteps = [];
				gatedBeats = [];
			}

			if(line == 'end')
			{
				if(inOnBeatHit)
				{
					if(onBeatHitDepth <= 0)
					{
						inOnBeatHit = false;
						continue;
					}
					onBeatHitDepth--;
				}
				if(inOnSongStart)
				{
					if(onSongStartDepth <= 0)
					{
						inOnSongStart = false;
						continue;
					}
					onSongStartDepth--;
				}
				if(inOnCreate)
				{
					if(onCreateDepth <= 0)
					{
						inOnCreate = false;
						continue;
					}
					onCreateDepth--;
				}
				if(inOnCreatePost)
				{
					if(onCreatePostDepth <= 0)
					{
						inOnCreatePost = false;
						continue;
					}
					onCreatePostDepth--;
				}
				if(inOnCountdownStarted)
				{
					if(onCountdownStartedDepth <= 0)
					{
						inOnCountdownStarted = false;
						continue;
					}
					onCountdownStartedDepth--;
				}
				gatedSteps = [];
				gatedBeats = [];
			}

			if(inOnBeatHit && (line.startsWith('if ') || line.startsWith('elseif ')) && line.endsWith(' then'))
				onBeatHitDepth++;
			if(inOnSongStart && (line.startsWith('if ') || line.startsWith('elseif ')) && line.endsWith(' then'))
				onSongStartDepth++;
			if(inOnCreate && (line.startsWith('if ') || line.startsWith('elseif ')) && line.endsWith(' then'))
				onCreateDepth++;
			if(inOnCreatePost && (line.startsWith('if ') || line.startsWith('elseif ')) && line.endsWith(' then'))
				onCreatePostDepth++;
			if(inOnCountdownStarted && (line.startsWith('if ') || line.startsWith('elseif ')) && line.endsWith(' then'))
				onCountdownStartedDepth++;

			var inStartupFunc:Bool = inOnSongStart || inOnCreate || inOnCreatePost || inOnCountdownStarted;

			var eventMatch:EReg = ~/triggerEvent\s*\((.*)\)/i;
			if(eventMatch.match(line))
			{
				var args:Array<String> = splitLuaArgs(eventMatch.matched(1));
				if(args.length > 0)
				{
					var eventName:String = args[0];
					var value1:String = args.length > 1 ? args[1] : '';
					var value2:String = args.length > 2 ? args[2] : '';

					if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
					{
						if(isPreviewUIEvent(eventName, value1, value2))
						{
							previewBeatLoopEvents.push({
								strumTime: 0,
								event: eventName,
								value1: value1,
								value2: value2
							});
							if(isBeatZoomEventName(eventName) || isBeatZoomToken(value1) || isBeatZoomToken(value2))
								previewHasBeatZoomEvent = true;
							if(isPreviewBeatZoomEvent(eventName, value1, value2))
							{
								previewHasSongCustomZoom = true;
							}
						}
						continue;
					}

					if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
					{
						if(isPreviewUIEvent(eventName, value1, value2))
							pushPreviewEvent(0, eventName, value1, value2);
						continue;
					}

					if(!pushPreviewEventAtGates(eventName, value1, value2, gatedSteps, gatedBeats))
						continue;
				}
			}

			var propMatch:EReg = ~/setProperty\s*\((.*)\)/i;
			if(propMatch.match(line))
			{
				var propArgs:Array<String> = splitLuaArgs(propMatch.matched(1));
				if(propArgs.length > 1 && isPreviewUIProperty(propArgs[0]))
				{
					if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
					{
						previewBeatLoopEvents.push({
							strumTime: 0,
							event: 'Set Property',
							value1: propArgs[0],
							value2: propArgs[1]
						});
						if(isPreviewCameraZoomProperty(propArgs[0]))
						{
							previewHasSongCustomZoom = true;
						}
						continue;
					}

					if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
					{
						pushPreviewEvent(0, 'Set Property', propArgs[0], propArgs[1]);
						continue;
					}

					if(!pushPreviewEventAtGates('Set Property', propArgs[0], propArgs[1], gatedSteps, gatedBeats))
						continue;
				}
			}

			var propClassMatch:EReg = ~/setPropertyFromClass\s*\((.*)\)/i;
			if(propClassMatch.match(line))
			{
				var classArgs:Array<String> = splitLuaArgs(propClassMatch.matched(1));
				if(classArgs.length > 2)
				{
					var propPath:String = classArgs[1];
					var propValue:String = classArgs[2];
					if(isPreviewUIProperty(propPath))
					{
						if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							previewBeatLoopEvents.push({
								strumTime: 0,
								event: 'Set Property',
								value1: propPath,
								value2: propValue
							});
							if(isPreviewCameraZoomProperty(propPath))
								previewHasSongCustomZoom = true;
							continue;
						}

						if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							pushPreviewEvent(0, 'Set Property', propPath, propValue);
							continue;
						}

						if(!pushPreviewEventAtGates('Set Property', propPath, propValue, gatedSteps, gatedBeats))
							continue;
					}
				}
			}

			var tweenZoomMatch:EReg = ~/doTweenZoom\s*\((.*)\)/i;
			if(tweenZoomMatch.match(line))
			{
				var tweenArgs:Array<String> = splitLuaArgs(tweenZoomMatch.matched(1));
				if(tweenArgs.length > 3)
				{
					var tweenTarget:String = tweenArgs[1] != null ? tweenArgs[1] : 'camhud';
					if(!isPreviewCameraTarget(tweenTarget))
						continue;

					var targetZoom:Null<Float> = parsePreviewEventFloat(tweenArgs[2]);
					var tweenDuration:Null<Float> = parsePreviewEventFloat(tweenArgs[3]);
					var tweenEase:String = tweenArgs.length > 4 ? tweenArgs[4] : 'linear';
					if(targetZoom != null)
					{
						if(tweenDuration == null || tweenDuration < 0)
							tweenDuration = 0;

						if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							previewBeatLoopEvents.push({
								strumTime: 0,
								event: '__TweenZoom',
								value1: tweenTarget,
								value2: Std.string(targetZoom) + ',' + Std.string(tweenDuration) + ',' + tweenEase
							});
							previewHasSongCustomZoom = true;
							continue;
						}

						if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							pushPreviewEvent(0, '__TweenZoom', tweenTarget, Std.string(targetZoom) + ',' + Std.string(tweenDuration) + ',' + tweenEase);
							previewHasSongCustomZoom = true;
							continue;
						}

						if(!pushPreviewEventAtGates('__TweenZoom', tweenTarget, Std.string(targetZoom) + ',' + Std.string(tweenDuration) + ',' + tweenEase, gatedSteps, gatedBeats))
							continue;

						previewHasSongCustomZoom = true;
					}
				}
			}

			var tweenAngleMatch:EReg = ~/doTweenAngle\s*\((.*)\)/i;
			if(tweenAngleMatch.match(line))
			{
				var tweenAngleArgs:Array<String> = splitLuaArgs(tweenAngleMatch.matched(1));
				if(tweenAngleArgs.length > 3)
				{
					var angleTarget:String = tweenAngleArgs[1] != null ? tweenAngleArgs[1] : 'camhud';
					if(!isPreviewCameraTarget(angleTarget))
						continue;

					var targetAngle:Null<Float> = parsePreviewEventFloat(tweenAngleArgs[2]);
					var angleDuration:Null<Float> = parsePreviewEventFloat(tweenAngleArgs[3]);
					var angleEase:String = tweenAngleArgs.length > 4 ? tweenAngleArgs[4] : 'linear';
					if(targetAngle != null)
					{
						if(angleDuration == null || angleDuration < 0)
							angleDuration = 0;

						if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							previewBeatLoopEvents.push({
								strumTime: 0,
								event: '__TweenAngle',
								value1: angleTarget,
								value2: Std.string(targetAngle) + ',' + Std.string(angleDuration) + ',' + angleEase
							});
							continue;
						}

						if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							pushPreviewEvent(0, '__TweenAngle', angleTarget, Std.string(targetAngle) + ',' + Std.string(angleDuration) + ',' + angleEase);
							continue;
						}

						if(!pushPreviewEventAtGates('__TweenAngle', angleTarget, Std.string(targetAngle) + ',' + Std.string(angleDuration) + ',' + angleEase, gatedSteps, gatedBeats))
							continue;
					}
				}
			}

			var tweenXMatch:EReg = ~/doTweenX\s*\((.*)\)/i;
			if(tweenXMatch.match(line))
			{
				var tweenXArgs:Array<String> = splitLuaArgs(tweenXMatch.matched(1));
				if(tweenXArgs.length > 3)
				{
					var targetVar:String = tweenXArgs[1] != null ? tweenXArgs[1].toLowerCase().trim() : '';
					if(targetVar == 'wnd' || targetVar.indexOf('window') != -1)
					{
						var targetX:Null<Float> = parsePreviewEventFloat(tweenXArgs[2]);
						var xDuration:Null<Float> = parsePreviewEventFloat(tweenXArgs[3]);
						var xEase:String = tweenXArgs.length > 4 ? tweenXArgs[4] : 'linear';
						if(targetX != null)
						{
							if(xDuration == null || xDuration < 0)
								xDuration = 0;

							if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
							{
								previewBeatLoopEvents.push({
									strumTime: 0,
									event: '__TweenWindowX',
									value1: Std.string(targetX),
									value2: Std.string(xDuration) + '|' + xEase
								});
								continue;
							}

							if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
							{
								pushPreviewEvent(0, '__TweenWindowX', Std.string(targetX), Std.string(xDuration) + '|' + xEase);
								continue;
							}

							if(!pushPreviewEventAtGates('__TweenWindowX', Std.string(targetX), Std.string(xDuration) + '|' + xEase, gatedSteps, gatedBeats))
								continue;
						}
					}
				}
			}

			var tweenYMatch:EReg = ~/doTweenY\s*\((.*)\)/i;
			if(tweenYMatch.match(line))
			{
				var tweenYArgs:Array<String> = splitLuaArgs(tweenYMatch.matched(1));
				if(tweenYArgs.length > 3)
				{
					var targetVarY:String = tweenYArgs[1] != null ? tweenYArgs[1].toLowerCase().trim() : '';
					if(targetVarY == 'wnd' || targetVarY.indexOf('window') != -1)
					{
						var targetY:Null<Float> = parsePreviewEventFloat(tweenYArgs[2]);
						var yDuration:Null<Float> = parsePreviewEventFloat(tweenYArgs[3]);
						var yEase:String = tweenYArgs.length > 4 ? tweenYArgs[4] : 'linear';
						if(targetY != null)
						{
							if(yDuration == null || yDuration < 0)
								yDuration = 0;

							if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
							{
								previewBeatLoopEvents.push({
									strumTime: 0,
									event: '__TweenWindowY',
									value1: Std.string(targetY),
									value2: Std.string(yDuration) + '|' + yEase
								});
								continue;
							}

							if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
							{
								pushPreviewEvent(0, '__TweenWindowY', Std.string(targetY), Std.string(yDuration) + '|' + yEase);
								continue;
							}

							if(!pushPreviewEventAtGates('__TweenWindowY', Std.string(targetY), Std.string(yDuration) + '|' + yEase, gatedSteps, gatedBeats))
								continue;
						}
					}
				}
			}

			var startTweenMatch:EReg = ~/startTween\s*\((.*)\)/i;
			if(startTweenMatch.match(line))
			{
				var startTweenArgs:Array<String> = splitLuaArgs(startTweenMatch.matched(1));
				if(startTweenArgs.length > 3)
				{
					var startTarget:String = startTweenArgs[1] != null ? startTweenArgs[1] : '';
					var tweenTable:String = startTweenArgs[2] != null ? startTweenArgs[2] : '';
					var startDuration:Null<Float> = parsePreviewEventFloat(startTweenArgs[3]);
					var startEase:String = startTweenArgs.length > 4 ? extractLuaTableString(startTweenArgs[4], 'ease') : 'linear';
					if(startDuration == null || startDuration < 0)
						startDuration = 0;

					var tableZoom:Null<Float> = extractLuaTableNumber(tweenTable, 'zoom');
					if(tableZoom != null && isPreviewCameraTarget(startTarget))
					{
						previewHasSongCustomZoom = true;
						if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							previewBeatLoopEvents.push({
								strumTime: 0,
								event: '__TweenZoom',
								value1: startTarget,
								value2: Std.string(tableZoom) + ',' + Std.string(startDuration) + ',' + startEase
							});
						}
						else
						{
							pushPreviewEventAtGates('__TweenZoom', startTarget, Std.string(tableZoom) + ',' + Std.string(startDuration) + ',' + startEase, gatedSteps, gatedBeats);
						}
					}

					var tableAngle:Null<Float> = extractLuaTableNumber(tweenTable, 'angle');
					if(tableAngle != null && isPreviewCameraTarget(startTarget))
					{
						if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							previewBeatLoopEvents.push({
								strumTime: 0,
								event: '__TweenAngle',
								value1: startTarget,
								value2: Std.string(tableAngle) + ',' + Std.string(startDuration) + ',' + startEase
							});
						}
						else
						{
							pushPreviewEventAtGates('__TweenAngle', startTarget, Std.string(tableAngle) + ',' + Std.string(startDuration) + ',' + startEase, gatedSteps, gatedBeats);
						}
					}

					var tableSongSpeed:Null<Float> = extractLuaTableNumber(tweenTable, 'songSpeed');
					if(tableSongSpeed != null)
					{
						if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							previewBeatLoopEvents.push({
								strumTime: 0,
								event: '__TweenSongSpeed',
								value1: Std.string(tableSongSpeed),
								value2: Std.string(startDuration) + '|' + startEase
							});
						}
						else
						{
							pushPreviewEventAtGates('__TweenSongSpeed', Std.string(tableSongSpeed), Std.string(startDuration) + '|' + startEase, gatedSteps, gatedBeats);
						}
					}
				}
			}

			var setWindowMatch:EReg = ~/setWindow\s*\((.*)\)/i;
			if(setWindowMatch.match(line))
			{
				var setWindowArgs:Array<String> = splitLuaArgs(setWindowMatch.matched(1));
				if(setWindowArgs.length >= 2)
				{
					var packed:String = setWindowArgs[0] + '|' + setWindowArgs[1] + '|' + (setWindowArgs.length > 2 ? setWindowArgs[2] : '') + '|' + (setWindowArgs.length > 3 ? setWindowArgs[3] : '');
					if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
					{
						pushPreviewEvent(0, '__SetWindow', packed, '');
						continue;
					}
					pushPreviewEventAtGates('__SetWindow', packed, '', gatedSteps, gatedBeats);
				}
			}

			var customCall:EReg = ~/^([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)\s*;?$/;
			if(customCall.match(line))
			{
				var callName:String = customCall.matched(1).toLowerCase();
				var callArgs:Array<String> = splitLuaArgs(customCall.matched(2));
				if(windowFunctionActions.exists(callName))
				{
					var wrapperW:Dynamic = windowFunctionActions.get(callName);
					var wrapperParamsW:Array<String> = wrapperW.paramNames;
					var wrapperActionsW:Array<Dynamic> = wrapperW.actions;
					for(a in wrapperActionsW)
					{
						var actionValue1:String = applyLuaFunctionArgs(a.value1, wrapperParamsW, callArgs);
						var actionValue2:String = applyLuaFunctionArgs(a.value2, wrapperParamsW, callArgs);
						if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							previewBeatLoopEvents.push({
								strumTime: 0,
								event: a.event,
								value1: actionValue1,
								value2: actionValue2
							});
							continue;
						}
						if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							pushPreviewEvent(0, a.event, actionValue1, actionValue2);
							continue;
						}
						pushPreviewEventAtGates(a.event, actionValue1, actionValue2, gatedSteps, gatedBeats);
					}
				}

				if(zoomFunctionActions.exists(callName))
				{
					var wrapper:Dynamic = zoomFunctionActions.get(callName);
					var wrapperParams:Array<String> = wrapper.paramNames;
					var wrapperActions:Array<Dynamic> = wrapper.actions;
					for(a in wrapperActions)
					{
						var actionValue1:String = applyLuaFunctionArgs(a.value1, wrapperParams, callArgs);
						var actionValue2:String = applyLuaFunctionArgs(a.value2, wrapperParams, callArgs);

						if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							previewBeatLoopEvents.push({
								strumTime: 0,
								event: a.event,
								value1: actionValue1,
								value2: actionValue2
							});
							if(isPreviewBeatZoomEvent(a.event, actionValue1, actionValue2))
								previewHasSongCustomZoom = true;
							continue;
						}

						if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
						{
							pushPreviewEvent(0, a.event, actionValue1, actionValue2);
							if(isPreviewBeatZoomEvent(a.event, actionValue1, actionValue2))
								previewHasSongCustomZoom = true;
							continue;
						}

						if(pushPreviewEventAtGates(a.event, actionValue1, actionValue2, gatedSteps, gatedBeats))
						{
							if(isPreviewBeatZoomEvent(a.event, actionValue1, actionValue2))
								previewHasSongCustomZoom = true;
						}
					}
				}

				if(windowWrappers.exists(callName))
				{
					var wrapper:Dynamic = windowWrappers.get(callName);
					if(!wrapper.hasWindowTween)
						continue;
					var axis:Null<Float> = wrapper.axisParam < callArgs.length ? parsePreviewEventFloat(callArgs[wrapper.axisParam]) : null;
					var amount:Null<Float> = wrapper.valueParam < callArgs.length ? parsePreviewEventFloat(callArgs[wrapper.valueParam]) : null;
					var duration:Null<Float> = wrapper.durationParam < callArgs.length ? parsePreviewEventFloat(callArgs[wrapper.durationParam]) : null;
					var wrapperEase:String = wrapper.easeParam < callArgs.length ? callArgs[wrapper.easeParam] : 'linear';
					if(duration == null || duration < 0)
						duration = 0;

					if(axis != null && amount != null)
					{
						if(axis == 1)
						{
							var evX:String = wrapper.xRelative ? '__TweenWindowXRel' : '__TweenWindowX';
							if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
							{
								previewBeatLoopEvents.push({
									strumTime: 0,
									event: evX,
									value1: Std.string(amount),
									value2: Std.string(duration) + '|' + wrapperEase
								});
							}
							else if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
							{
								pushPreviewEvent(0, evX, Std.string(amount), Std.string(duration) + '|' + wrapperEase);
							}
							else
							{
								pushPreviewEventAtGates(evX, Std.string(amount), Std.string(duration) + '|' + wrapperEase, gatedSteps, gatedBeats);
							}
						}
						else if(axis == 2)
						{
							var evY:String = wrapper.yRelative ? '__TweenWindowYRel' : '__TweenWindowY';
							if(inOnBeatHit && onBeatHitDepth <= 0 && gatedSteps.length < 1 && gatedBeats.length < 1)
							{
								previewBeatLoopEvents.push({
									strumTime: 0,
									event: evY,
									value1: Std.string(amount),
									value2: Std.string(duration) + '|' + wrapperEase
								});
							}
							else if(inStartupFunc && gatedSteps.length < 1 && gatedBeats.length < 1)
							{
								pushPreviewEvent(0, evY, Std.string(amount), Std.string(duration) + '|' + wrapperEase);
							}
							else
							{
								pushPreviewEventAtGates(evY, Std.string(amount), Std.string(duration) + '|' + wrapperEase, gatedSteps, gatedBeats);
							}
						}
					}
				}
			}

			var initShaderMatch:EReg = ~/initLuaShader\s*\((.*)\)/i;
			if(initShaderMatch.match(line))
			{
				var initArgs:Array<String> = splitLuaArgs(initShaderMatch.matched(1));
				if(initArgs.length > 0)
					queuePreviewScriptDerivedEvent('__InitShader', initArgs[0], '', inOnBeatHit && onBeatHitDepth <= 0, inStartupFunc, gatedSteps, gatedBeats);
			}

			var setShaderMatch:EReg = ~/setSpriteShader\s*\((.*)\)/i;
			if(setShaderMatch.match(line))
			{
				var shaderArgs:Array<String> = splitLuaArgs(setShaderMatch.matched(1));
				if(shaderArgs.length > 1)
					queuePreviewScriptDerivedEvent('__SetSpriteShader', shaderArgs[0], shaderArgs[1], inOnBeatHit && onBeatHitDepth <= 0, inStartupFunc, gatedSteps, gatedBeats);
			}

			var removeShaderMatch:EReg = ~/removeSpriteShader\s*\((.*)\)/i;
			if(removeShaderMatch.match(line))
			{
				var removeArgs:Array<String> = splitLuaArgs(removeShaderMatch.matched(1));
				if(removeArgs.length > 0)
					queuePreviewScriptDerivedEvent('__RemoveSpriteShader', removeArgs[0], '', inOnBeatHit && onBeatHitDepth <= 0, inStartupFunc, gatedSteps, gatedBeats);
			}

			var shaderUniformMatch:EReg = ~/^(setShaderFloat|setShaderInt|setShaderBool|setShaderFloatArray|setShaderIntArray|setShaderBoolArray|setShaderSampler2D)\s*\((.*)\)/i;
			if(shaderUniformMatch.match(line))
			{
				var uniformFunc:String = shaderUniformMatch.matched(1);
				var uniformArgs:Array<String> = splitLuaArgs(shaderUniformMatch.matched(2));
				if(uniformArgs.length > 2)
				{
					var encodedPayload:String = uniformFunc + '|' + uniformArgs[0] + '|' + uniformArgs[1] + '|' + uniformArgs.slice(2).join(',');
					queuePreviewScriptDerivedEvent('__SetShaderUniform', encodedPayload, '', inOnBeatHit && onBeatHitDepth <= 0, inStartupFunc, gatedSteps, gatedBeats);
				}
			}
		}
	}

	function queuePreviewEventsFromLuaDirectory(folder:String, seenFiles:Map<String, Bool>):Void
	{
		if(folder == null || folder.length < 1 || !FileSystem.exists(folder) || !FileSystem.isDirectory(folder))
			return;

		try
		{
			for(entry in cachePreviewDirList(folder))
			{
				var entryPath:String = haxe.io.Path.join([folder, entry]);
				if(FileSystem.isDirectory(entryPath))
				{
					queuePreviewEventsFromLuaDirectory(entryPath, seenFiles);
					continue;
				}

				if(!entry.toLowerCase().endsWith('.lua'))
					continue;

				if(seenFiles.exists(entryPath))
					continue;

				seenFiles.set(entryPath, true);
				var content:String = cachePreviewFileText(entryPath);
				if(content != null)
					queuePreviewEventsFromLuaContent(content);
			}
		}
		catch(e:Dynamic) {}
	}

	function queuePreviewEventsFromCustomEventScripts(seenFiles:Map<String, Bool>):Void
	{
		#if MODS_ALLOWED
		var queuedNames:Map<String, Bool> = [];
		for(event in previewEventNotes)
		{
			if(event == null || event.event == null)
				continue;

			var rawEventName:String = trimPreviewToken(event.event);
			if(rawEventName.length < 1)
				continue;

			var candidates:Array<String> = [rawEventName, Paths.formatToSongPath(rawEventName)];
			for(candidate in candidates)
			{
				if(candidate == null)
					continue;

				candidate = candidate.trim();
				if(candidate.length < 1 || queuedNames.exists(candidate))
					continue;

				queuedNames.set(candidate, true);
				for(filePath in Mods.directoriesWithFile(Paths.getSharedPath(), 'custom_events/' + candidate + '.lua'))
				{
					if(seenFiles.exists(filePath))
						continue;

					seenFiles.set(filePath, true);
					var content:String = cachePreviewFileText(filePath);
					if(content != null)
						queuePreviewEventsFromLuaContent(content);
				}
			}
		}
		#end
	}

	function queuePreviewEventsFromLua(songPath:String):Void
	{
		#if MODS_ALLOWED
		var seenFiles:Map<String, Bool> = [];
		for(folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'scripts/'))
			queuePreviewEventsFromLuaDirectory(folder, seenFiles);

		for(folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'data/$songPath/'))
			queuePreviewEventsFromLuaDirectory(folder, seenFiles);

		queuePreviewEventsFromCustomEventScripts(seenFiles);
		#end
	}

	function loadPreviewEvents(songPath:String):Void
	{
		clearPreviewEventData();
		queuePreviewEventsFromSong(PlayState.SONG);

		try
		{
			var eventsChart:SwagSong = Song.getChart('events', songPath);
			queuePreviewEventsFromSong(eventsChart);
		}
		catch(e:Dynamic) {}

		queuePreviewEventsFromLua(songPath);

		previewEventNotes.sort(sortPreviewEventsByTime);
		previewNZEventCount = 0;
		for(event in previewEventNotes)
		{
			if(event != null && event.event != null && event.event.toLowerCase().trim() == 'nz')
				previewNZEventCount++;
		}

		if(previewBeatZoomToggleMode)
			previewBeatZoomEnabled = false;

	}

	inline function normalizePreviewShaderTarget(target:String):String
	{
		var lowered:String = normalizePreviewTargetName(trimPreviewToken(target));
		if(lowered == 'camhud' || lowered == 'hud' || lowered == 'camui' || lowered == 'ui')
			return 'menu-camera';
		return '';
	}

	function clearPreviewCameraShader():Void
	{
		for(_ => tween in previewShaderFloatTweens)
			if(tween != null)
				tween.cancel();
		previewShaderFloatTweens = [];
		previewShaderFloatValues = [];
		previewShaderFlip = false;
		FlxG.camera.setFilters([]);
		previewCameraShaderName = '';
	}

	function getPreviewShaderFloatDefault(prop:String):Float
	{
		if(prop == null)
			return 0;
		switch(prop.toLowerCase().trim())
		{
			case 'zoom': return 1;
			case 'x', 'y', 'angle': return 0;
		}
		return 0;
	}

	function ensurePreviewMirrorRepeatShader():Bool
	{
		if(previewCameraShaderName != 'MirrorRepeatEffect')
		{
			#if (!flash && sys)
			if(!initPreviewRuntimeShader('MirrorRepeatEffect'))
				return false;
			#end
			applyPreviewCameraShader('camHUD', 'MirrorRepeatEffect');
		}

		if(previewCameraShaderName != 'MirrorRepeatEffect')
			return false;

		if(!previewShaderFloatValues.exists('x')) previewShaderFloatValues.set('x', 0);
		if(!previewShaderFloatValues.exists('y')) previewShaderFloatValues.set('y', 0);
		if(!previewShaderFloatValues.exists('angle')) previewShaderFloatValues.set('angle', 0);
		if(!previewShaderFloatValues.exists('zoom')) previewShaderFloatValues.set('zoom', 1);
		return true;
	}

	function setPreviewShaderFloat(prop:String, value:Float):Void
	{
		if(prop == null || prop.length < 1)
			return;
		var normalizedProp:String = prop.toLowerCase().trim();
		previewShaderFloatValues.set(normalizedProp, value);
		applyPreviewShaderUniform('setShaderFloat|camHUD|' + normalizedProp + '|' + Std.string(value));
	}

	function setPreviewShaderBool(prop:String, value:Bool):Void
	{
		if(prop == null || prop.length < 1)
			return;
		applyPreviewShaderUniform('setShaderBool|camHUD|' + prop.toLowerCase().trim() + '|' + (value ? 'true' : 'false'));
	}

	function tweenPreviewShaderFloat(prop:String, targetValue:Float, duration:Float, easeName:String):Void
	{
		if(prop == null || prop.length < 1)
			return;
		var normalizedProp:String = prop.toLowerCase().trim();
		if(previewShaderFloatTweens.exists(normalizedProp))
		{
			var oldTween:FlxTween = previewShaderFloatTweens.get(normalizedProp);
			if(oldTween != null)
				oldTween.cancel();
			previewShaderFloatTweens.remove(normalizedProp);
		}

		var startValue:Float = previewShaderFloatValues.exists(normalizedProp) ? previewShaderFloatValues.get(normalizedProp) : getPreviewShaderFloatDefault(normalizedProp);
		if(duration <= 0)
		{
			setPreviewShaderFloat(normalizedProp, targetValue);
			return;
		}

		var shaderTween:FlxTween = FlxTween.num(startValue, targetValue, duration, {
			ease: getPreviewEaseFunc(easeName),
			onComplete: function(_)
			{
				previewShaderFloatTweens.remove(normalizedProp);
				setPreviewShaderFloat(normalizedProp, targetValue);
			}
		}, function(v:Float)
		{
			setPreviewShaderFloat(normalizedProp, v);
		});
		previewShaderFloatTweens.set(normalizedProp, shaderTween);
	}

	#if (!flash && sys)
	function initPreviewRuntimeShader(name:String):Bool
	{
		if(!ClientPrefs.data.shaders)
			return false;

		if(previewRuntimeShaders.exists(name))
			return true;

		for(folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'shaders/'))
		{
			var fragPath:String = folder + name + '.frag';
			var vertPath:String = folder + name + '.vert';
			var found:Bool = false;
			var frag:String = null;
			var vert:String = null;

			if(FileSystem.exists(fragPath))
			{
				frag = cachePreviewFileText(fragPath);
				found = true;
			}

			if(FileSystem.exists(vertPath))
			{
				vert = cachePreviewFileText(vertPath);
				found = true;
			}

			if(found)
			{
				previewRuntimeShaders.set(name, [frag, vert]);
				return true;
			}
		}

		return false;
	}

	function getPreviewRuntimeShader(name:String):Null<ErrorHandledRuntimeShader>
	{
		if(!ClientPrefs.data.shaders)
			return null;

		if(!previewCameraShaders.exists(name))
		{
			if(!initPreviewRuntimeShader(name))
				return null;

			var arr:Array<String> = previewRuntimeShaders.get(name);
			previewCameraShaders.set(name, new ErrorHandledRuntimeShader(name, arr[0], arr[1]));
		}

		return previewCameraShaders.get(name);
	}
	#end

	function applyPreviewCameraShader(target:String, shaderName:String):Void
	{
		var normalizedTarget:String = normalizePreviewShaderTarget(target);
		var normalizedShader:String = trimPreviewToken(shaderName);
		if(normalizedTarget != 'menu-camera' || normalizedShader.length < 1)
			return;

		if(previewCameraShaderName == normalizedShader)
			return;

		#if (!flash && sys)
		var shader:Null<ErrorHandledRuntimeShader> = getPreviewRuntimeShader(normalizedShader);
		if(shader == null)
			return;

		FlxG.camera.setFilters([new ShaderFilter(shader)]);
		previewCameraShaderName = normalizedShader;
		#end
	}

	function applyPreviewShaderUniform(encoded:String):Void
	{
		if(encoded == null || encoded.length < 1)
			return;

		var parts:Array<String> = encoded.split('|');
		if(parts.length < 4)
			return;

		var funcName:String = trimPreviewToken(parts[0]).toLowerCase();
		var target:String = trimPreviewToken(parts[1]);
		var prop:String = trimPreviewToken(parts[2]);
		var rawValue:String = trimPreviewToken(parts.slice(3).join('|'));

		if(normalizePreviewShaderTarget(target) != 'menu-camera' || previewCameraShaderName.length < 1)
			return;

		#if (!flash && sys)
		var shader:Null<ErrorHandledRuntimeShader> = previewCameraShaders.get(previewCameraShaderName);
		if(shader == null || prop.length < 1)
			return;

		switch(funcName)
		{
			case 'setshaderfloat':
				var f:Null<Float> = parsePreviewEventFloat(rawValue);
				if(f != null) shader.setFloat(prop, f);
			case 'setshaderint':
				var i:Null<Int> = Std.parseInt(rawValue);
				if(i != null) shader.setInt(prop, i);
			case 'setshaderbool':
				var b:Null<Bool> = parsePreviewToggleValue(rawValue);
				if(b != null) shader.setBool(prop, b);
			default:
		}
		#end
	}

	function applyPreviewProperty(path:String, value:String):Void
	{
		if(path == null)
			return;

		var trimmedPath:String = normalizePreviewPropertyPath(trimPreviewToken(path));
		var lowerPath:String = trimmedPath;
		if(!isPreviewCameraZoomProperty(lowerPath))
			return;
		var floatValue:Null<Float> = parsePreviewEventFloat(trimPreviewToken(value));
		if(floatValue != null)
		{
			previewExternalZoomControl = true;
			previewBaseCamZoom = Math.max(0.2, floatValue);
			FlxG.camera.zoom = floatValue;
		}
	}

	inline function isPreviewCameraZoomProperty(path:String):Bool
	{
		if(path == null)
			return false;
		var lowerPath:String = normalizePreviewPropertyPath(path);
		return lowerPath == 'camhud.zoom'
			|| lowerPath == 'hud.zoom'
			|| lowerPath == 'defaultcamuizoom';
	}

	inline function isPreviewCameraAngleProperty(path:String):Bool
	{
			return false;
	}

	function blockBeatZoomForCustom(?duration:Float = -1):Void
	{
		if(previewZoomTween != null)
		{
			previewZoomTween.cancel();
			previewZoomTween = null;
		}

		if(duration <= 0)
		{
			var playbackRate:Float = Math.max(0.05, player.playbackRate);
			var beatDuration:Float = ((Conductor.stepCrochet * 4) / playbackRate) / 1000;
			duration = Math.max(0.06, beatDuration * 0.9);
		}
		previewCustomZoomLock = Math.max(0, duration);
	}

	function triggerPreviewCustomZoomReturn(?duration:Float = -1):Void
	{
		blockBeatZoomForCustom(duration);
		if(previewCustomZoomTween != null)
		{
			previewCustomZoomTween.cancel();
			previewCustomZoomTween = null;
		}

		var returnDuration:Float = previewCustomZoomLock;
		if(returnDuration <= 0)
			returnDuration = 0.1;

		previewCustomZoomTween = FlxTween.tween(FlxG.camera, {zoom: previewBaseCamZoom}, returnDuration, {
			ease: FlxEase.sineOut,
			onComplete: function(_)
			{
				previewCustomZoomTween = null;
			}
		});
	}

	function triggerPreviewUIEvent(eventName:String, value1:String, value2:String, allowLuaOnEventHandlers:Bool = true):Bool
	{
		var didCustomZoom:Bool = false;
		eventName = trimPreviewToken(eventName);
		value1 = trimPreviewToken(value1);
		value2 = trimPreviewToken(value2);
		var lowerEvent:String = eventName.toLowerCase().trim();

		switch(lowerEvent)
		{
			case '__initshader':
				#if (!flash && sys)
				initPreviewRuntimeShader(value1);
				#end
				return didCustomZoom;
			case '__setspriteshader':
				applyPreviewCameraShader(value1, value2);
				return didCustomZoom;
			case '__removespriteshader':
				if(normalizePreviewShaderTarget(value1) == 'menu-camera')
					clearPreviewCameraShader();
				return didCustomZoom;
			case '__setshaderuniform':
				applyPreviewShaderUniform(value1);
				return didCustomZoom;
		}

		if(lowerEvent == '__tweenzoom')
		{
			if(isPreviewCameraTarget(value1))
			{
				var tweenZoomPayload = parseTweenEventValueEx(value2);
				if(tweenZoomPayload.a != null)
				{
					var tweenZoomDuration:Float = tweenZoomPayload.b != null && tweenZoomPayload.b >= 0 ? tweenZoomPayload.b : 0;
					applyPreviewCameraZoomTween(value1, tweenZoomPayload.a, tweenZoomDuration, tweenZoomPayload.ease);
					previewExternalZoomControl = true;
					didCustomZoom = true;
				}
			}
			return didCustomZoom;
		}

		if(lowerEvent == 'set property')
		{
			applyPreviewProperty(value1, value2);
			if(isPreviewCameraZoomProperty(value1))
			{
				triggerPreviewCustomZoomReturn(0.16);
				didCustomZoom = true;
			}
			return didCustomZoom;
		}

		if(lowerEvent == 'add camera zoom' || lowerEvent == 'add camera zoom edit')
		{
			if(!previewScriptCamZoomHud)
				return didCustomZoom;

			var addCamZoom:Null<Float> = parsePreviewEventFloat(value1);
			if(addCamZoom == null)
				addCamZoom = 0.03;
			FlxG.camera.zoom += addCamZoom;
			previewExternalZoomControl = true;

			if(previewCustomZoomTween == null)
				triggerPreviewCustomZoomReturn(0.16);
			else
				blockBeatZoomForCustom(0.08);
			didCustomZoom = true;
			return didCustomZoom;
		}

		if(lowerEvent == 'beatzoom')
		{
			var beatToggle:Null<Bool> = parsePreviewToggleValue(value1);
			previewBeatZoomToggleMode = true;
			previewHasBeatZoomEvent = true;
			if(beatToggle != null)
				previewBeatZoomEnabled = beatToggle;
			else
				previewBeatZoomEnabled = !previewBeatZoomEnabled;
				return didCustomZoom;
			}

		if(lowerEvent == 'nz')
		{
			var hudZoomToggle:Null<Bool> = parsePreviewToggleValue(value1);
			if(hudZoomToggle != null)
				previewScriptCamZoomHud = hudZoomToggle;

			if(hudZoomToggle != null)
				previewExternalZoomControl = true;
			return didCustomZoom;
		}

					return false;
					return false;

		switch(lowerEvent)
		{
			case '__tweenzoom':
				var tweenZoomTarget:String = value1;
				var tweenZoom:Null<Float> = parsePreviewEventFloat(value1);
				var tweenZoomTime:Null<Float> = null;
				var tweenZoomEase:String = 'linear';
				if(tweenZoom == null)
				{
					var tweenZoomPayload = parseTweenEventValueEx(value2);
					tweenZoom = tweenZoomPayload.a;
					tweenZoomTime = tweenZoomPayload.b;
					tweenZoomEase = tweenZoomPayload.ease;
				}
				else
				{
					tweenZoomTarget = 'camhud';
					var dz = parseDurationEase(value2);
					tweenZoomTime = dz.duration;
					tweenZoomEase = dz.ease;
				}

				if(tweenZoom != null)
				{
					if(tweenZoomTime == null || tweenZoomTime < 0)
						tweenZoomTime = 0;
				applyPreviewCameraZoomTween(tweenZoomTarget, tweenZoom, tweenZoomTime, tweenZoomEase);
					previewExternalZoomControl = true;
					didCustomZoom = true;
				}

			case '__tweenangle':
				var tweenAngleTarget:String = value1;
				var tweenAnglePayload = parseTweenEventValueEx(value2);
				if(tweenAnglePayload.a != null)
				{
					var tweenAngleDuration:Float = tweenAnglePayload.b != null && tweenAnglePayload.b >= 0 ? tweenAnglePayload.b : 0;
					applyPreviewCameraAngleTween(tweenAngleTarget, tweenAnglePayload.a, tweenAngleDuration, tweenAnglePayload.ease);
				}

			case '__tweensongspeed':
				var tweenSpeed:Null<Float> = parsePreviewEventFloat(value1);
				var tweenSpeedSpec = parseDurationEase(value2);
				var tweenSpeedTime:Null<Float> = tweenSpeedSpec.duration;
				if(tweenSpeed != null)
				{
					if(tweenSpeedTime == null || tweenSpeedTime < 0)
						tweenSpeedTime = 0;
					applyPreviewSongSpeedTween(tweenSpeed, tweenSpeedTime, tweenSpeedSpec.ease);
				}

			case 'screen shake':
				var split:Array<String> = value1.split(',');
				var duration:Float = 0;
				var intensity:Float = 0;
				if(split[0] != null)
					duration = Std.parseFloat(split[0].trim());
				if(split[1] != null)
					intensity = Std.parseFloat(split[1].trim());
				if(Math.isNaN(duration)) duration = 0;
				if(Math.isNaN(intensity)) intensity = 0;
				if(duration > 0 && intensity != 0)
					FlxG.camera.shake(intensity, duration);

			case 'set property':
				applyPreviewProperty(value1, value2);
				if(isPreviewCameraZoomProperty(value1))
				{
					previewExternalZoomControl = true;
					triggerPreviewCustomZoomReturn(0.16);
					didCustomZoom = true;
				}

			default:
				if(isPreviewCameraZoomProperty(value1) || isPreviewCameraAngleProperty(value1))
				{
					applyPreviewProperty(value1, value2);
					if(isPreviewCameraZoomProperty(value1))
					{
						previewExternalZoomControl = true;
						triggerPreviewCustomZoomReturn(0.16);
						didCustomZoom = true;
					}
				}
				else if(isPreviewBeatZoomEvent(eventName, value1, value2))
				{
					var fallbackCamZoom:Null<Float> = parsePreviewEventFloat(value1);
					if(fallbackCamZoom != null)
					{
						FlxG.camera.zoom += fallbackCamZoom;
						triggerPreviewCustomZoomReturn(0.16);
						didCustomZoom = true;
					}
				}
		}
		if(didCustomZoom)
			previewSawCustomZoom = true;
		return didCustomZoom;
	}

	function checkPreviewEventNote(songPosition:Float):Bool
	{
		var didCustomZoom:Bool = false;
		while(previewEventNotes.length > 0)
		{
			var leStrumTime:Float = previewEventNotes[0].strumTime;
			if(songPosition < leStrumTime)
				return didCustomZoom;

			var queuedEventName:String = previewEventNotes[0].event != null ? previewEventNotes[0].event.toLowerCase().trim() : '';
			if(queuedEventName == 'nz')
			{
				var startupWindowMs:Float = Math.max(350, ClientPrefs.data.noteOffset + 350);
				if(leStrumTime <= startupWindowMs)
				{
					previewEventNotes.shift();
					continue;
				}
			}

			var value1:String = '';
			if(previewEventNotes[0].value1 != null)
				value1 = previewEventNotes[0].value1;

			var value2:String = '';
			if(previewEventNotes[0].value2 != null)
				value2 = previewEventNotes[0].value2;

			if(triggerPreviewUIEvent(previewEventNotes[0].event, value1, value2))
				didCustomZoom = true;
			previewEventNotes.shift();
		}
		return didCustomZoom;
	}

	function triggerPreviewBeatLoopEvents():Bool
	{
		var didCustomZoom:Bool = false;
		for(event in previewBeatLoopEvents)
			if(triggerPreviewUIEvent(event.event, event.value1 != null ? event.value1 : '', event.value2 != null ? event.value2 : ''))
				didCustomZoom = true;
		return didCustomZoom;
	}

	function clearPreviewSectionBPMData():Void
	{
		previewSectionStartTimes = [];
		previewSectionStartBeats = [];
		previewSectionBPMs = [];
		previewSectionIndex = -1;
		previewSectionBeatIndex = -1;
	}

	function resetPreviewCamera():Void
	{
		if(previewZoomTween != null)
		{
			previewZoomTween.cancel();
			previewZoomTween = null;
		}
		if(previewCustomZoomTween != null)
		{
			previewCustomZoomTween.cancel();
			previewCustomZoomTween = null;
		}
		if(previewCustomAngleTween != null)
		{
			previewCustomAngleTween.cancel();
			previewCustomAngleTween = null;
		}
		if(previewSongSpeedTween != null)
		{
			previewSongSpeedTween.cancel();
			previewSongSpeedTween = null;
		}
		previewBeatZoomEnabled = true;
		previewScriptCamZoomHud = true;
		previewScriptCamZoomBg = true;
		previewSongSpeed = 1;
		previewCustomZoomLock = 0;
		previewBaseCamZoom = 1;
		previewSawCustomZoom = false;
		previewExternalZoomControl = false;
		FlxG.camera.visible = true;
		FlxG.camera.alpha = 1;
		FlxG.camera.zoom = previewBaseCamZoom;
		FlxG.camera.angle = 0;
		clearPreviewCameraShader();
	}

	function resetPreviewState():Void
	{
		resetPreviewCamera();
		clearPreviewEventData();
		clearPreviewSectionBPMData();
		previewLastMusicTime = -1;
		lastBeatTriggered = -1;
		Conductor.offset = 0;
		Conductor.songPosition = 0;
		previewPendingSongStart = false;
	}

	function beginPreviewStartupGate():Void
	{
		if(FlxG.sound.music != null)
			FlxG.sound.music.time = 0;
		if(vocals != null && vocals.length > 0)
			vocals.time = 0;
		if(opponentVocals != null && opponentVocals.length > 0)
			opponentVocals.time = 0;

		lastBeatTriggered = -1;
		previewLastMusicTime = -1;
		previewStartupGateActive = true;
		previewStartupStableTime = 0;
		player.pauseOrResume(false);
	}

	function restartPreviewLoopPlayback():Void
	{
		if(!player.playingMusic || FlxG.sound.music == null)
			return;

		var loopSongPath:String = Paths.formatToSongPath(songs[curSelected].songName);
		resetPreviewLoopRuntimeState(loopSongPath);
		FlxG.sound.music.play();
		FlxG.sound.music.pause();
		if(vocals != null && vocals.length > 0)
		{
			vocals.play();
			vocals.pause();
		}
		if(opponentVocals != null && opponentVocals.length > 0)
		{
			opponentVocals.play();
			opponentVocals.pause();
		}
		beginPreviewStartupGate();
	}

	function setupPreviewLoopRestart():Void
	{
		if(FlxG.sound.music == null)
			return;

		FlxG.sound.music.looped = false;
		FlxG.sound.music.onComplete = function()
		{
			restartPreviewLoopPlayback();
		};
	}

	function triggerPreviewZoom(beatCrochetMs:Float):Void
	{
		if(previewZoomsDisabled || !previewScriptCamZoomHud)
			return;

		if(previewZoomTween != null)
		{
			previewZoomTween.cancel();
			previewZoomTween = null;
		}

		var baseZoom:Float = Math.max(0.2, previewBaseCamZoom);
		var zoomOutAmount:Float = Math.max(0.06, baseZoom * 0.08);
		var zoomDuration:Float = Math.max(0.035, (beatCrochetMs / 1000) * 0.65);
		FlxG.camera.zoom = baseZoom + zoomOutAmount;
		previewZoomTween = FlxTween.tween(FlxG.camera, {zoom: baseZoom}, zoomDuration, {
			ease: FlxEase.sineIn,
			onComplete: function(_) previewZoomTween = null
		});
	}

	inline function isPreviewDownbeat(beat:Int):Bool
	{
		return beat >= 0;
	}

	function buildPreviewSectionBPMData():Void
	{
		clearPreviewSectionBPMData();
		if(PlayState.SONG == null || PlayState.SONG.notes == null)
			return;

		var curBPM:Float = PlayState.SONG.bpm;
		var curTime:Float = 0;
		var curBeatPos:Float = 0;
		for(i in 0...PlayState.SONG.notes.length)
		{
			var section = PlayState.SONG.notes[i];
			if(section != null && section.changeBPM && section.bpm > 0)
				curBPM = section.bpm;

			previewSectionStartTimes.push(curTime);
			previewSectionStartBeats.push(curBeatPos);
			previewSectionBPMs.push(curBPM);

			var sectionBeats:Float = 4;
			if(section != null)
			{
				sectionBeats = section.sectionBeats;
				if(sectionBeats <= 0)
					sectionBeats = 4;
			}
			if(sectionBeats <= 0)
				sectionBeats = 4;
			curTime += (60000 / curBPM) * sectionBeats;
			curBeatPos += sectionBeats;
		}
	}

	function updatePreviewSectionFromTime(songPosition:Float):Bool
	{
		if(previewSectionStartTimes.length < 1)
			return false;

		var oldIdx:Int = previewSectionBeatIndex;
		var idx:Int = oldIdx;
		if(idx < 0 || idx >= previewSectionStartTimes.length || songPosition < previewSectionStartTimes[idx])
			idx = 0;

		while(idx + 1 < previewSectionStartTimes.length && songPosition >= previewSectionStartTimes[idx + 1])
			idx++;

		previewSectionBeatIndex = idx;
		if(oldIdx < 0)
			return false;
		return idx != oldIdx;
	}

	function updatePreviewSectionBPM(songPosition:Float):Bool
	{
		if(previewSectionStartTimes.length < 1)
			return false;

		var idx:Int = previewSectionIndex;
		if(idx < 0 || idx >= previewSectionStartTimes.length || songPosition < previewSectionStartTimes[idx])
			idx = 0;

		while(idx + 1 < previewSectionStartTimes.length && songPosition >= previewSectionStartTimes[idx + 1])
			idx++;

		previewSectionIndex = idx;
		var sectionBPM:Float = previewSectionBPMs[idx];
		if(sectionBPM > 0 && Conductor.bpm != sectionBPM)
		{
			Conductor.bpm = sectionBPM;
			return true;
		}
		return false;
	}

	function getPreviewBeatFromTime(songPosition:Float):Int
	{
		if(previewSectionStartTimes.length < 1 || previewSectionStartBeats.length < 1 || previewSectionBPMs.length < 1)
			return Math.floor(Conductor.getStep(songPosition) / 4);

		var idx:Int = previewSectionBeatIndex;
		if(idx < 0 || idx >= previewSectionStartTimes.length || songPosition < previewSectionStartTimes[idx])
			idx = 0;

		while(idx + 1 < previewSectionStartTimes.length && songPosition >= previewSectionStartTimes[idx + 1])
			idx++;

		if(idx < 0 || idx >= previewSectionStartTimes.length)
			return Math.floor(Conductor.getStep(songPosition) / 4);

		var sectionStartTime:Float = previewSectionStartTimes[idx];
		var sectionStartBeat:Float = previewSectionStartBeats[idx];
		var sectionBPM:Float = previewSectionBPMs[idx];
		if(sectionBPM <= 0)
			return Math.floor(Conductor.getStep(songPosition) / 4);

		var beatLengthMs:Float = 60000 / sectionBPM;
		if(beatLengthMs <= 0)
			return Math.floor(Conductor.getStep(songPosition) / 4);

		var localBeatOffset:Float = (songPosition - sectionStartTime) / beatLengthMs;
		if(Math.isNaN(localBeatOffset))
			localBeatOffset = 0;
		if(localBeatOffset < 0)
			localBeatOffset = 0;

		return Math.floor(sectionStartBeat + localBeatOffset);
	}

	var stopMusicPlay:Bool = false;
	override function update(elapsed:Float)
	{
		if(WeekData.weeksList.length < 1)
			return;

		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * elapsed;

		if(previewCustomZoomLock > 0)
			previewCustomZoomLock = Math.max(0, previewCustomZoomLock - elapsed);

		lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
		lerpRating = FlxMath.lerp(intendedRating, lerpRating, Math.exp(-elapsed * 12));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		if(FlxG.mouse.justPressed && bpmText != null && FlxG.mouse.overlaps(bpmText))
		{
			bpmChangesExpanded = !bpmChangesExpanded;
			bpmChangesText.visible = bpmChangesExpanded && currentDensityData != null && currentDensityData.hasBpmChanges;
		}

		var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) //No decimals, add an empty space
			ratingSplit.push('');
		
		while(ratingSplit[1].length < 2) //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';

		var rratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(recentRating * 100, 2)).split('.');
		if(rratingSplit.length < 2) //No decimals, add an empty space
			rratingSplit.push('');
		
		while(rratingSplit[1].length < 2) //Less than 2 decimals in it, add decimals then
			rratingSplit[1] += '0';

		var shiftMult:Int = 1;
		if((FlxG.keys.pressed.SHIFT || touchPad.buttonZ.pressed) && !player.playingMusic) shiftMult = 3;

		if(processPendingFreeplayLoad(elapsed))
		{
			if(persistentUpdate)
			{
				updateTexts(elapsed);
				super.update(elapsed);
			}
			return;
		}

		if (!player.playingMusic)
		{
			if(flushDensityResults())
				refreshModernSongDetails();
			
			if(cheatedSC == -1 && rcheaT == -1) scoreText.text = Language.getPhrase('personal_best', 'PERSONAL BEST: {1} ({2}%) {5}x\nLast Play: {3} ({4}%) {6}x', [lerpScore, ratingSplit.join('.'), recentScore, rratingSplit.join('.'), rate, rrate]);
			
			if(cheatedSC > -1 && rcheaT == -1) scoreText.text = Language.getPhrase('personal_best', 'PERSONAL BEST: cheated* {1} ({2}%) {5}x\nLast Play: {3} ({4}%) {6}x', [lerpScore, ratingSplit.join('.'), recentScore, rratingSplit.join('.'), rate, rrate]);

			if(cheatedSC == -1 && rcheaT > -1) scoreText.text = Language.getPhrase('personal_best', 'PERSONAL BEST: {1} ({2}%) {5}x\nLast Play: cheated* {3} ({4}%) {6}x', [lerpScore, ratingSplit.join('.'), recentScore, rratingSplit.join('.'), rate, rrate]);

			if(cheatedSC > -1 && rcheaT > -1) scoreText.text = Language.getPhrase('cheated_save', 'PERSONAL BEST: cheated* {1} ({2}%) {5}x\nLast Play: cheated* {3} ({4}%) {6}x', [lerpScore, ratingSplit.join('.'), recentScore, rratingSplit.join('.'), rate, rrate]);

			if(songs.length > 1)
			{
				if(FlxG.keys.justPressed.HOME)
				{
					curSelected = 0;
					changeSelection();
					holdTime = 0;	
				}
				else if(FlxG.keys.justPressed.END)
				{
					curSelected = songs.length - 1;
					changeSelection();
					holdTime = 0;	
				}
				if (controls.UI_UP_P)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (controls.UI_DOWN_P)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
				}

				if(FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
					changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				}
			}

			if (controls.UI_LEFT_P)
			{
				changeDiff(-1);
				_updateSongLastDifficulty();
			}
			else if (controls.UI_RIGHT_P)
			{
				changeDiff(1);
				_updateSongLastDifficulty();
			}
		}

		if (controls.BACK)
		{
			if (player.playingMusic)
			{
				if(FlxG.sound.music != null)
					FlxG.sound.music.onComplete = null;
				FlxG.sound.music.stop();
				resetPreviewState();
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				instPlaying = -1;

				player.playingMusic = false;
				player.switchPlayMusic();

				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxTween.tween(FlxG.sound.music, {volume: 1}, 1);
			}
			else 
			{
				persistentUpdate = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		if((FlxG.keys.justPressed.CONTROL || touchPad.buttonC.justPressed) && !player.playingMusic)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
			removeTouchPad();
		}
		else if(FlxG.keys.justPressed.SPACE || touchPad.buttonX.justPressed)
		{
			if(instPlaying != curSelected && !player.playingMusic)
			{
				beginPreviewLoad();
			}
			else if (instPlaying == curSelected && player.playingMusic)
			{
				if(player.playing)
					resetPreviewCamera();
				player.pauseOrResume(!player.playing);
			}
		}
		else if (controls.ACCEPT && !player.playingMusic)
		{
			beginSongLoad();
			}
		else if(controls.RESET && !player.playingMusic)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			removeTouchPad();
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (player.playingMusic){
			if(previewPendingSongStart)
			{
				if(FlxG.sound.music != null && FlxG.sound.music.length > 0)
				{
					previewPendingSongStart = false;
					beginPreviewStartupGate();
				}
			}

			if(previewStartupGateActive)
			{
				if(FlxG.sound.music != null)
				{
					if(FlxG.sound.music.time != 0)
						FlxG.sound.music.time = 0;
					if(vocals != null && vocals.length > 0 && vocals.time != 0)
						vocals.time = 0;
					if(opponentVocals != null && opponentVocals.length > 0 && opponentVocals.time != 0)
						opponentVocals.time = 0;
				}

				var targetFPS:Float = Math.max(1, FlxG.drawFramerate * 0.5);
				var currentFPS:Float = elapsed > 0 ? (1 / elapsed) : targetFPS;
				if(currentFPS >= targetFPS)
					previewStartupStableTime += elapsed;
				else
					previewStartupStableTime = 0;

				if(previewStartupStableTime >= previewStartupStableThreshold)
				{
					previewStartupGateActive = false;
					previewLastMusicTime = -1;
					player.pauseOrResume(true);
				}
			}

			if (FlxG.sound.music != null && FlxG.sound.music.playing){
				previewExternalZoomControl = false;
				var currentMusicTime:Float = FlxG.sound.music.time;
				if(FlxG.sound.music.length > 0 && currentMusicTime >= FlxG.sound.music.length - 2)
				{
					restartPreviewLoopPlayback();
					updatePreviewBpmDisplay();
					updateTexts(elapsed);
					super.update(elapsed);
					return;
				}
				previewLastMusicTime = currentMusicTime;

					Conductor.songPosition = currentMusicTime + Conductor.offset;
					var previewSongPos:Float = Conductor.songPosition;
					var previewSyncPos:Float = previewSongPos - ClientPrefs.data.noteOffset;
					var didCustomZoomThisFrame:Bool = checkPreviewEventNote(previewSyncPos);
					var bpmChanged:Bool = updatePreviewSectionBPM(previewSyncPos);
					var playbackRate:Float = Math.max(0.05, player.playbackRate);
				var beatCrochetMs:Float = Conductor.crochet / playbackRate;
					var curBeat:Int = getPreviewBeatFromTime(previewSyncPos);
					var sectionChanged:Bool = updatePreviewSectionFromTime(previewSyncPos);
					var beatChanged:Bool = curBeat != lastBeatTriggered;
					if(beatChanged)
					{
						lastBeatTriggered = curBeat;
						if(previewBeatLoopEvents.length > 0)
							didCustomZoomThisFrame = triggerPreviewBeatLoopEvents() || didCustomZoomThisFrame;
						triggerPreviewHeaderBop();

						var hasAnySongCustomZoom:Bool = previewHasSongCustomZoom;
						var allowMenuBeatBop:Bool = !hasAnySongCustomZoom;
						var chartBeatZoomLoopActive:Bool = previewHasBeatZoomEvent && previewBeatZoomEnabled && previewScriptCamZoomHud && !previewZoomsDisabled;
						var directBeatZoomEveryBeat:Bool = chartBeatZoomLoopActive && previewBeatZoomHud != 0;
						var normalBeatBopEveryBeat:Bool = allowMenuBeatBop && !previewBeatZoomToggleMode && previewCustomZoomLock <= 0;

						if(chartBeatZoomLoopActive && previewBeatZoomHud != 0)
							FlxG.camera.zoom += previewBeatZoomHud;

						var allowNormalBop:Bool = allowMenuBeatBop && !previewZoomsDisabled && !didCustomZoomThisFrame && previewCustomZoomLock <= 0;
						if(previewBeatZoomToggleMode)
						{
							if(previewBeatZoomEnabled)
								allowNormalBop = false;
							else
								allowNormalBop = allowNormalBop && isPreviewDownbeat(curBeat);
						}

						if(allowNormalBop)
						{
							triggerPreviewZoom(beatCrochetMs);
							didCustomZoomThisFrame = true;
						}

						var shouldFallbackFirstBeatZoom:Bool = !didCustomZoomThisFrame
							&& !previewZoomsDisabled
							&& !previewHasBeatZoomEvent
							&& !directBeatZoomEveryBeat
							&& !normalBeatBopEveryBeat
							&& allowMenuBeatBop
							&& previewCustomZoomLock <= 0
							&& isPreviewDownbeat(curBeat);
						if(shouldFallbackFirstBeatZoom)
						{
							triggerPreviewZoom(beatCrochetMs);
							didCustomZoomThisFrame = true;
						}
					}

					if(sectionChanged && !previewHasSongCustomZoom && !previewBeatZoomToggleMode && !previewZoomsDisabled && !didCustomZoomThisFrame && previewCustomZoomLock <= 0)
					{
						triggerPreviewZoom(beatCrochetMs);
						didCustomZoomThisFrame = true;
					}

					// Safety: if additive/custom zoom tweens were interrupted, gently settle back to base.
					if(previewCustomZoomTween == null && previewCustomZoomLock <= 0)
					{
						var baseZoom:Float = Math.max(0.2, previewBaseCamZoom);
						var deltaZoom:Float = FlxG.camera.zoom - baseZoom;
						if(Math.abs(deltaZoom) > 0.001)
						{
							var settleLerp:Float = Math.min(1, elapsed * 8);
							FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, baseZoom, settleLerp);
							if(Math.abs(FlxG.camera.zoom - baseZoom) <= 0.002)
								FlxG.camera.zoom = baseZoom;
						}
					}
				}
				updatePreviewBpmDisplay();
			}
		updateTexts(elapsed);
		super.update(elapsed);
	}
	
	function getVocalFromCharacter(char:String)
	{
		try
		{
			var path:String = Paths.getPath('characters/$char.json', TEXT);
			#if MODS_ALLOWED
			var character:Dynamic = Json.parse(File.getContent(path));
			#else
			var character:Dynamic = Json.parse(Assets.getText(path));
			#end
			return character.vocals_file;
		}
		catch (e:Dynamic) {}
		return null;
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) vocals.stop();
		vocals = FlxDestroyUtil.destroy(vocals);

		if(opponentVocals != null) opponentVocals.stop();
		opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
	}

	function changeDiff(change:Int = 0)
	{
		if (player.playingMusic)
			return;

		curDifficulty = FlxMath.wrap(curDifficulty + change, 0, Difficulty.list.length-1);
		#if !switch
		cheatedSC = Highscore.getCheatedStatus(songs[curSelected].songName, curDifficulty);
		rcheaT = Highscore.getRCheatedStatus(songs[curSelected].songName, curDifficulty);
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		recentScore = Highscore.getRScore(songs[curSelected].songName, curDifficulty);
		recentRating = Highscore.getRRating(songs[curSelected].songName, curDifficulty);
		rate = Highscore.getRate(songs[curSelected].songName, curDifficulty);
		rrate = Highscore.getRRate(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		lastDifficultyName = Difficulty.getString(curDifficulty, false);
		var displayDiff:String = Difficulty.getString(curDifficulty);
		if (Difficulty.list.length > 1)
			diffText.text = '< ' + displayDiff.toUpperCase() + ' >';
		else
			diffText.text = displayDiff.toUpperCase();

		positionHighscore();
		missingText.visible = false;
		missingTextBG.visible = false;
		queueDensityLoad(songs[curSelected].songName, curDifficulty);
		queuePreviewPrewarm(songs[curSelected].songName, curDifficulty);
		refreshModernSongDetails();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (player.playingMusic)
			return;

		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length-1);
		_updateSongLastDifficulty();
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor)
		{
			intendedColor = newColor;
			FlxTween.cancelTweensOf(bg);
			FlxTween.color(bg, 1, bg.color, intendedColor);
			if(rightPanel != null)
				FlxTween.color(rightPanel, 0.35, rightPanel.color, FlxColor.interpolate(0xFF1A263B, intendedColor, 0.22));
			if(leftPanel != null)
				FlxTween.color(leftPanel, 0.35, leftPanel.color, FlxColor.interpolate(0xFF111A2A, intendedColor, 0.18));
			if(densityPanel != null)
				FlxTween.color(densityPanel, 0.35, densityPanel.color, FlxColor.interpolate(0xFF152238, intendedColor, 0.24));
		}

		for (num => item in grpSongs.members)
		{
			item.alpha = 0.6;
			if (item.targetY == curSelected)
			{
				item.alpha = 1;
			}
		}
		
		Mods.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
		Difficulty.loadFromWeek();
		
		var savedDiff:String = songs[curSelected].lastDifficulty;
		var lastDiff:Int = Difficulty.list.indexOf(lastDifficultyName);
		if(savedDiff != null && !Difficulty.list.contains(savedDiff) && Difficulty.list.contains(savedDiff))
			curDifficulty = Math.round(Math.max(0, Difficulty.list.indexOf(savedDiff)));
		else if(lastDiff > -1)
			curDifficulty = lastDiff;
		else if(Difficulty.list.contains(Difficulty.getDefault()))
			curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
		else
			curDifficulty = 0;

		changeDiff();
		_updateSongLastDifficulty();
	}

	inline private function _updateSongLastDifficulty()
		songs[curSelected].lastDifficulty = Difficulty.getString(curDifficulty, false);

	private function positionHighscore()
	{
		scoreText.x = 34;
		scoreText.y = leftPanel.y + 64;
		scoreText.fieldWidth = leftPanel.width - 40;
		scoreBG.x = 20;
		scoreBG.y = leftPanel.y + 48;
		if(Math.abs(scoreBG.width - leftPanel.width) > 0.5)
		{
			scoreBG.setGraphicSize(Std.int(leftPanel.width), Std.int(scoreBG.height));
			scoreBG.updateHitbox();
		}
		diffText.x = 34;
		diffText.y = leftPanel.y + 176;
	}

	var _drawDistance:Int = 6;
	var _lastVisibles:Array<Int> = [];
	public function updateTexts(elapsed:Float = 0.0)
	{
		lerpSelected = FlxMath.lerp(curSelected, lerpSelected, Math.exp(-elapsed * 9.6));
		for (i in _lastVisibles)
		{
			grpSongs.members[i].visible = grpSongs.members[i].active = false;
		}
		_lastVisibles = [];

		var min:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected - _drawDistance)));
		var max:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected + _drawDistance)));
		for (i in min...max)
		{
			var item:Alphabet = grpSongs.members[i];
			var isSelected:Bool = (i == curSelected);
			item.visible = item.active = true;
			var centerY:Float = rightPanel.y + (rightPanel.height * 0.5) - 18;
			var laneY:Float = centerY + ((i - lerpSelected) * 68);
			item.y = laneY;
			var distance:Float = Math.abs(i - lerpSelected);
			var miniScale:Float = FlxMath.bound(0.9 - (distance * 0.14), 0.52, 1.02);
			if(isSelected)
				miniScale = Math.max(miniScale, 1.12);
			item.scaleX = miniScale;
			item.scaleY = miniScale;

			var maxSongWidth:Float = rightPanel.width - 56;
			if(item.width > maxSongWidth && item.width > 0)
			{
				var widthRatio:Float = maxSongWidth / item.width;
				item.scaleX *= widthRatio;
				item.scaleY *= widthRatio;
			}

			var slideFromRight:Float = 18 + (distance * 26);
			var targetX:Float = rightPanel.x + 16 + slideFromRight;
			if(i == curSelected)
				targetX -= 32;

			var minX:Float = rightPanel.x + 10;
			var maxX:Float = rightPanel.x + rightPanel.width - item.width - 10;
			item.x = FlxMath.bound(targetX, minX, maxX);

			var withinPanel:Bool = item.y >= (rightPanel.y + 8) && (item.y + item.height) <= (rightPanel.y + rightPanel.height - 8);
			item.visible = item.active = withinPanel;

			if(isSelected)
			{
				item.alpha = 1;
				item.color = 0xFFFFF2A8;
			}
			else
			{
				item.alpha = FlxMath.bound(0.55 - (distance * 0.16), 0.12, 0.48);
				item.color = 0xFFA9B6C9;
			}

			var icon:HealthIcon = iconArray[i];
			icon.visible = icon.active = false;
			icon.scale.set(miniScale, miniScale);
			icon.alpha = isSelected ? 1 : FlxMath.bound(item.alpha * 0.85, 0.1, 0.45);
			_lastVisibles.push(i);
		}
	}

	private function getHealthIconFromCharacter(char:String):String {
		try
		{
			var path:String = Paths.getPath('characters/$char.json', TEXT);
			#if MODS_ALLOWED
			if (sys.FileSystem.exists(path))
			{
				var rawJson:String = sys.io.File.getContent(path);
				if (rawJson != null && rawJson.length > 0)
				{
					var json:Dynamic = haxe.Json.parse(rawJson);
					if (json.healthicon != null && json.healthicon.length > 0)
						return json.healthicon;
				}
			}
			#else
			if (OpenFlAssets.exists(path))
			{
				var rawJson:String = Assets.getText(path);
				if (rawJson != null && rawJson.length > 0)
				{
					var json:Dynamic = haxe.Json.parse(rawJson);
					if (json.healthicon != null && json.healthicon.length > 0)
						return json.healthicon;
				}
			}
			#end
		}
		catch (e:Dynamic) {}
		return char; // Default back to character name if json isn't found
	}

	override function destroy():Void
	{
		if(densityThreadPool != null)
		{
			densityThreadPool.shutdown();
			densityThreadPool = null;
		}
		previewSoundMutex.acquire();
		previewSoundPreloads.clear();
		previewSoundMutex.release();
		super.destroy();

		FlxG.autoPause = ClientPrefs.data.autoPause;
		if (!FlxG.sound.music.playing && !stopMusicPlay)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}	
}

class SongDensityData
{
	public var bpm:Float;
	public var rating:Float;
	public var avgNps:Float;
	public var peakNps:Float;
	public var timeline:Array<Float>;
	public var player1:String;
	public var player2:String;
	public var mainBpm:Float;
	public var avgBpm:Float;
	public var maxBpm:Float;
	public var bpmChangesLabel:String;
	public var hasBpmChanges:Bool;
	public var analyzed:Bool;

	public function new(bpm:Float, rating:Float, avgNps:Float, peakNps:Float, timeline:Array<Float>, ?player1:String = '', ?player2:String = '',
		?mainBpm:Float = 0, ?avgBpm:Float = 0, ?maxBpm:Float = 0, ?bpmChangesLabel:String = '', ?hasBpmChanges:Bool = false, ?analyzed:Bool = false)
	{
		this.bpm = bpm;
		this.rating = rating;
		this.avgNps = avgNps;
		this.peakNps = peakNps;
		this.timeline = timeline;
		this.player1 = player1;
		this.player2 = player2;
		this.mainBpm = mainBpm > 0 ? mainBpm : bpm;
		this.avgBpm = avgBpm > 0 ? avgBpm : bpm;
		this.maxBpm = maxBpm > 0 ? maxBpm : bpm;
		this.bpmChangesLabel = (bpmChangesLabel != null && bpmChangesLabel.length > 0) ? bpmChangesLabel : Std.string(CoolUtil.floorDecimal(this.mainBpm, 2));
		this.hasBpmChanges = hasBpmChanges;
		this.analyzed = analyzed;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var lastDifficulty:String = null;

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}