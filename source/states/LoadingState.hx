package states;

import lime.app.Future;
import sys.thread.FixedThreadPool;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import flixel.FlxState;

import flash.media.Sound;

import backend.Song;
import backend.StageData;
import objects.Character;

import sys.thread.Thread;
import sys.thread.Mutex;

import objects.Note;
import objects.NoteSplash;

#if HSCRIPT_ALLOWED
import psychlua.HScript;
import crowplexus.iris.Iris;
import crowplexus.hscript.Expr.Error as IrisError;
import crowplexus.hscript.Printer;
#end

#if cpp
@:headerCode('
#include <iostream>
#include <thread>
')
#end
class LoadingState extends MusicBeatState
{
	public static var loaded:Int = 0;
	public static var loadMax:Int = 0;

	static var originalBitmapKeys:Map<String, String> = [];
	static var requestedBitmaps:Map<String, BitmapData> = [];
	static var mutex:Mutex;
	static var threadPool:FixedThreadPool = null;
	static var threadPoolWorkers:Int = 0;

	function new(target:FlxState, stopMusic:Bool)
	{
		this.target = target;
		this.stopMusic = stopMusic;
		
		super();
	}

	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false, intrusive:Bool = true)
		MusicBeatState.switchState(getNextState(target, stopMusic, intrusive));
	
	var target:FlxState = null;
	var stopMusic:Bool = false;
	var dontUpdate:Bool = false;

	var barGroup:FlxSpriteGroup;
	var bar:FlxSprite;
	var barWidth:Int = 0;
	var intendedPercent:Float = 0;
	var curPercent:Float = 0;
	var stateChangeDelay:Float = 0;

	var funkay:FlxSprite;

	#if HSCRIPT_ALLOWED
	var hscript:HScript;
	#end
	override function create()
	{
		persistentUpdate = true;
		super.create();
	}

	var transitioning:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (dontUpdate) return;

		if (!transitioning)
		{
			if (!finishedLoading && checkLoaded())
			{
				if(stateChangeDelay <= 0)
				{
					transitioning = true;
					onLoad();
					return;
				}
				else stateChangeDelay = Math.max(0, stateChangeDelay - elapsed);
			}
			intendedPercent = loaded / loadMax;
		}
	}
	
	var finishedLoading:Bool = false;
	function onLoad()
	{
		_loaded();

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.camera.visible = false;
		MusicBeatState.switchState(target);
		transitioning = true;
		finishedLoading = true;
	}

	static function _loaded()
	{
		loaded = 0;
		loadMax = 0;
		initialThreadCompleted = true;
		isIntrusive = false;

		FlxTransitionableState.skipNextTransIn = true;
		if (threadPool != null) threadPool.shutdown(); // kill all workers safely
		threadPool = null;
		threadPoolWorkers = 0;
		mutex = null;
	}

	public static function checkLoaded():Bool
	{
		var pendingBitmaps:Array<{file:String, requestKey:String, bitmap:BitmapData}> = [];
		if(mutex != null)
		{
			mutex.acquire();
			for (key => bitmap in requestedBitmaps)
				pendingBitmaps.push({file: key, requestKey: originalBitmapKeys.get(key), bitmap: bitmap});
			requestedBitmaps.clear();
			originalBitmapKeys.clear();
			mutex.release();
		}

		for (entry in pendingBitmaps)
		{
			if (entry.bitmap != null && Paths.cacheBitmap(entry.requestKey, entry.bitmap) != null) {} //trace('finished preloading image $key');
			else trace('failed to cache image ${entry.file}');
		}
		// trace('we checked if loaded');
		return (loaded >= loadMax && initialThreadCompleted);
	}

	public static function loadNextDirectory()
	{
		var directory:String = 'shared';
		var weekDir:String = StageData.forceNextDirectory;
		StageData.forceNextDirectory = null;

		if (weekDir != null && weekDir.length > 0 && weekDir != '') directory = weekDir;

		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to ' + directory);
	}

	static var isIntrusive:Bool = false;
	static function getNextState(target:FlxState, stopMusic = false, intrusive:Bool = true):FlxState
	{
		LoadingState.isIntrusive = intrusive;
		_startPool();
		loadNextDirectory();

		if(intrusive)
			return new LoadingState(target, stopMusic);
		
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		while(true)
		{
			if(checkLoaded())
			{
				_loaded();
				break;
			}
			else Sys.sleep(0.001);
		}
		return target;
	}

	public static function finishLoading():Void
	{
		_loaded();
	}

	static var imagesToPrepare:Array<String> = [];
	static var soundsToPrepare:Array<String> = [];
	static var musicToPrepare:Array<String> = [];
	static var songsToPrepare:Array<String> = [];

	static function appendPreparedAsset(target:Array<String>, asset:String):Void
	{
		if(target == null || asset == null)
			return;

		var normalized:String = asset.trim();
		if(normalized.length < 1)
			return;

		if(mutex != null)
			mutex.acquire();
		if(!target.contains(normalized))
			target.push(normalized);
		if(mutex != null)
			mutex.release();
	}

	static function appendPreparedAssets(target:Array<String>, assets:Array<String>):Void
	{
		if(assets == null)
			return;

		for(asset in assets)
			appendPreparedAsset(target, asset);
	}

	static function dedupePreparedAssets(target:Array<String>):Void
	{
		if(target == null || target.length < 2)
			return;

		var seen:Map<String, Bool> = [];
		var deduped:Array<String> = [];
		for(asset in target)
		{
			if(asset == null)
				continue;
			var normalized:String = asset.trim();
			if(normalized.length < 1 || seen.exists(normalized))
				continue;
			seen.set(normalized, true);
			deduped.push(normalized);
		}
		target.resize(0);
		for(asset in deduped)
			target.push(asset);
	}

	public static function prepare(images:Array<String> = null, sounds:Array<String> = null, music:Array<String> = null)
	{
		appendPreparedAssets(imagesToPrepare, images);
		appendPreparedAssets(soundsToPrepare, sounds);
		appendPreparedAssets(musicToPrepare, music);
	}

	static var initialThreadCompleted:Bool = true;
	static var dontPreloadDefaultVoices:Bool = false;
	public static function getUsableThreadCount(?taskCount:Int = 0):Int
	{
		var cpuCount:Int = 1;
		#if cpp
		cpuCount = getCPUThreadsCount();
		#end
		if(cpuCount <= 0)
			cpuCount = 1;
		
		trace(cpuCount + ' CPU threads detected');

		var workerCount:Int = Std.int(Math.max(1, cpuCount - 1));
		if(taskCount > 0)
			workerCount = Std.int(Math.min(workerCount, taskCount));
		return Std.int(Math.max(1, workerCount));
	}

	static function _startPool(?taskCount:Int = 0, ?forceRecreate:Bool = false)
	{
		var threadCount:Int = getUsableThreadCount(taskCount);
		if(threadPool != null)
		{
			if(!forceRecreate && threadPoolWorkers == threadCount)
				return;
			threadPool.shutdown();
		}

		threadPool = new FixedThreadPool(threadCount);
		threadPoolWorkers = threadCount;
	}

	public static function prepareToSong()
	{
		if(PlayState.SONG == null)
		{
			imagesToPrepare = [];
			soundsToPrepare = [];
			musicToPrepare = [];
			songsToPrepare = [];
			loaded = 0;
			loadMax = 0;
			initialThreadCompleted = true;
			isIntrusive = false;
			return;
		}

		mutex = new Mutex();
		_startPool(2, true);
		imagesToPrepare = [];
		soundsToPrepare = [];
		musicToPrepare = [];
		songsToPrepare = [];

		initialThreadCompleted = false;
		var threadsCompleted:Int = 0;
		var threadsMax:Int = 0;
		function completedThread()
		{
			threadsCompleted++;
			if(threadsCompleted == threadsMax)
			{
				dedupePreparedAssets(imagesToPrepare);
				dedupePreparedAssets(soundsToPrepare);
				dedupePreparedAssets(musicToPrepare);
				dedupePreparedAssets(songsToPrepare);
				clearInvalids();
				startThreads();
				initialThreadCompleted = true;
			}
		}

		var song:SwagSong = PlayState.SONG;
		var folder:String = Paths.formatToSongPath(Song.loadedSongName);
		new Future<Bool>(() -> {
			// LOAD NOTE IMAGE
			var noteSkin:String = Note.defaultNoteSkin;
			if(PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin.length > 1) noteSkin = PlayState.SONG.arrowSkin;
	
			var customSkin:String = noteSkin + Note.getNoteSkinPostfix();
			if(Paths.fileExists('images/$customSkin.png', IMAGE)) noteSkin = customSkin;
			appendPreparedAsset(imagesToPrepare, noteSkin);
			// LOAD NOTE SPLASH IMAGE
			var noteSplash:String = NoteSplash.defaultNoteSplash;
			if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) noteSplash = PlayState.SONG.splashSkin;
			else noteSplash += NoteSplash.getSplashSkinPostfix();
			appendPreparedAsset(imagesToPrepare, noteSplash);

			try
			{
				var path:String = Paths.json('$folder/preload');
				var json:Dynamic = null;

				#if MODS_ALLOWED
				var moddyFile:String = Paths.modsJson('$folder/preload');
				if (FileSystem.exists(moddyFile)) json = Json.parse(File.getContent(moddyFile));
				else json = Json.parse(File.getContent(path));
				#else
				json = Json.parse(Assets.getText(path));
				#end

				if(json != null)
				{
					var imgs:Array<String> = [];
					var snds:Array<String> = [];
					var mscs:Array<String> = [];
					for (asset in Reflect.fields(json))
					{
						var filters:Int = Reflect.field(json, asset);
						var asset:String = asset.trim();

						if(filters < 0 || StageData.validateVisibility(filters))
						{
							if(asset.startsWith('images/'))
								imgs.push(asset.substr('images/'.length));
							else if(asset.startsWith('sounds/'))
								snds.push(asset.substr('sounds/'.length));
							else if(asset.startsWith('music/'))
								mscs.push(asset.substr('music/'.length));
						}
					}
					prepare(imgs, snds, mscs);
				}
			}
			catch(e:Dynamic) {}
			return true;
		}, isIntrusive)
		.then((_) -> new Future<Bool>(() -> {
			if (song.stage == null || song.stage.length < 1)
				song.stage = StageData.vanillaSongStage(folder);

			var stageData:StageFile = StageData.getStageFile(song.stage);
			if (stageData != null)
			{
				var imgs:Array<String> = [];
				var snds:Array<String> = [];
				var mscs:Array<String> = [];
				if(stageData.preload != null)
				{
					for (asset in Reflect.fields(stageData.preload))
					{
						var filters:Int = Reflect.field(stageData.preload, asset);
						var asset:String = asset.trim();

						if(filters < 0 || StageData.validateVisibility(filters))
						{
							if(asset.startsWith('images/'))
								imgs.push(asset.substr('images/'.length));
							else if(asset.startsWith('sounds/'))
								snds.push(asset.substr('sounds/'.length));
							else if(asset.startsWith('music/'))
								mscs.push(asset.substr('music/'.length));
						}
					}
				}
				
				if (stageData.objects != null)
				{
					for (sprite in stageData.objects)
					{
						if(sprite.type == 'sprite' || sprite.type == 'animatedSprite')
							if((sprite.filters < 0 || StageData.validateVisibility(sprite.filters)) && !imgs.contains(sprite.image))
								imgs.push(sprite.image);
					}
				}
				prepare(imgs, snds, mscs);
			}

			appendPreparedAsset(songsToPrepare, '$folder/Inst');

			var player1:String = song.player1;
			var player2:String = song.player2;
			var gfVersion:String = song.gfVersion;
			var prefixVocals:String = song.needsVoices ? '$folder/Voices' : null;
			if (gfVersion == null) gfVersion = 'gf';

			dontPreloadDefaultVoices = false;
			preloadCharacter(player1, prefixVocals);
			if (!dontPreloadDefaultVoices && prefixVocals != null)
			{
				if(Paths.fileExists('$prefixVocals-Player.${Paths.SOUND_EXT}', SOUND, false, 'songs') && Paths.fileExists('$prefixVocals-Opponent.${Paths.SOUND_EXT}', SOUND, false, 'songs'))
				{
					appendPreparedAsset(songsToPrepare, '$prefixVocals-Player');
					appendPreparedAsset(songsToPrepare, '$prefixVocals-Opponent');
				}
				else if(Paths.fileExists('$prefixVocals.${Paths.SOUND_EXT}', SOUND, false, 'songs'))
					appendPreparedAsset(songsToPrepare, prefixVocals);
			}

			if (player2 != player1)
			{
				threadsMax++;
				threadPool.run(() -> {
					try { preloadCharacter(player2, prefixVocals); } catch (e:Dynamic) {}
					completedThread();
				});
			}
			if (!stageData.hide_girlfriend && gfVersion != player2 && gfVersion != player1)
			{
				threadsMax++;
				threadPool.run(() -> {
					try { preloadCharacter(gfVersion); } catch (e:Dynamic) {}
					completedThread();
				});
			}

			if(threadsCompleted == threadsMax)
			{
				dedupePreparedAssets(imagesToPrepare);
				dedupePreparedAssets(soundsToPrepare);
				dedupePreparedAssets(musicToPrepare);
				dedupePreparedAssets(songsToPrepare);
				clearInvalids();
				startThreads();
				initialThreadCompleted = true;
			}
			return true;
		}, isIntrusive))
		.onError((err:Dynamic) -> {
			trace('ERROR! while preparing song: $err');
		});
	}

	public static function clearInvalids()
	{
		clearInvalidFrom(imagesToPrepare, 'images', '.png', IMAGE);
		clearInvalidFrom(soundsToPrepare, 'sounds', '.${Paths.SOUND_EXT}', SOUND);
		clearInvalidFrom(musicToPrepare, 'music', '.${Paths.SOUND_EXT}', SOUND);
		clearInvalidFrom(songsToPrepare, 'songs', '.${Paths.SOUND_EXT}', SOUND, 'songs');

		for (arr in [imagesToPrepare, soundsToPrepare, musicToPrepare, songsToPrepare])
			while (arr.contains(null))
				arr.remove(null);
	}

	static function clearInvalidFrom(arr:Array<String>, prefix:String, ext:String, type:AssetType, ?parentFolder:String = null)
	{
		for (folder in arr.copy())
		{
			var nam:String = folder.trim();
			if(nam.endsWith('/'))
			{
				for (subfolder in Mods.directoriesWithFile(Paths.getSharedPath(), '$prefix/$nam'))
				{
					for (file in FileSystem.readDirectory(subfolder))
					{
						if(file.endsWith(ext))
						{
							var toAdd:String = nam + haxe.io.Path.withoutExtension(file);
							if(!arr.contains(toAdd)) arr.push(toAdd);
						}
					}
				}

				//trace('Folder detected! ' + folder);
			}
		}

		var i:Int = 0;
		while(i < arr.length)
		{

			var member:String = arr[i];
			var myKey = '$prefix/$member$ext';
			if(parentFolder == 'songs') myKey = '$member$ext';

			//trace('attempting on $prefix: $myKey');
			var doTrace:Bool = false;
			if(!member.endsWith('/') && !Paths.fileExists(myKey, type, false, parentFolder))
			{
				// If the asset wasn't found and it's an icon path, try with "icon-" prefix as fallback
				if(member.indexOf('icons/') == 0)
				{
					var iconName:String = member.substr('icons/'.length);
					var fallbackKey = '$prefix/icons/icon-$iconName$ext';
					if(parentFolder == 'songs') fallbackKey = 'icons/icon-$iconName$ext';
					
					if(Paths.fileExists(fallbackKey, type, false, parentFolder))
					{
						i++;
						continue;
					}
				}
				doTrace = true;
			}
			
			if(member.endsWith('/') || doTrace)
			{
				arr.remove(member);
				if(doTrace) trace('Removed invalid $prefix: $member');
			}
			else i++;
		}
	}

	public static function startThreads()
	{
		loadMax = imagesToPrepare.length + soundsToPrepare.length + musicToPrepare.length + songsToPrepare.length;
		loaded = 0;
		if(loadMax < 1)
			return;

		//then start threads
		_threadFunc();
	}

	static function _threadFunc()
	{
		_startPool(loadMax, true);
		for (sound in soundsToPrepare) initThread(() -> preloadSound('sounds/$sound'), 'sound $sound');
		for (music in musicToPrepare) initThread(() -> preloadSound('music/$music'), 'music $music');
		for (song in songsToPrepare) initThread(() -> preloadSound(song, 'songs', true, false), 'song $song');

		// for images, they get to have their own thread
		for (image in imagesToPrepare) initThread(() -> preloadGraphic(image), 'image $image');
	}

	static function initThread(func:Void->Dynamic, traceData:String)
	{
		// trace('scheduled $func in threadPool');
		#if debug
		var threadSchedule = Sys.time();
		#end
		threadPool.run(() -> {
			#if debug
			var threadStart = Sys.time();
			trace('$traceData took ${threadStart - threadSchedule}s to start preloading');
			#end

			try {
				if (func() != null) {
					#if debug
					var diff = Sys.time() - threadStart;
					trace('finished preloading $traceData in ${diff}s');
					#end
				} else trace('ERROR! fail on preloading $traceData ');
			}
			catch(e:Dynamic) {
				trace('ERROR! fail on preloading $traceData: $e');
			}
			mutex.acquire();
			loaded++;
			mutex.release();
		});
	}

	inline private static function preloadCharacter(char:String, ?prefixVocals:String)
	{
		try
		{
			var path:String = Paths.getPath('characters/$char.json', TEXT);
			#if MODS_ALLOWED
			var character:Dynamic = Json.parse(File.getContent(path));
			#else
			var character:Dynamic = Json.parse(Assets.getText(path));
			#end

			var isAnimateAtlas:Bool = false;
			var img:String = character.image;
			img = img.trim();
			#if flxanimate
			var animToFind:String = Paths.getPath('images/$img/Animation.json', TEXT);
			if (#if MODS_ALLOWED FileSystem.exists(animToFind) || #end Assets.exists(animToFind))
				isAnimateAtlas = true;
			#end

			if(!isAnimateAtlas)
			{
				var split:Array<String> = img.split(',');
				for (file in split)
				{
					appendPreparedAsset(imagesToPrepare, file);
				}
			}
			#if flxanimate
			else
			{
				for (i in 0...10)
				{
					var st:String = '$i';
					if(i == 0) st = '';
	
					if(Paths.fileExists('images/$img/spritemap$st.png', IMAGE))
					{
						//trace('found Sprite PNG');
						appendPreparedAsset(imagesToPrepare, '$img/spritemap$st');
						break;
					}
				}
			}
			#end
	
			if (prefixVocals != null && character.vocals_file != null && character.vocals_file.length > 0)
			{
				appendPreparedAsset(songsToPrepare, prefixVocals + "-" + character.vocals_file);
				if(char == PlayState.SONG.player1) dontPreloadDefaultVoices = true;
			}
		}
		catch(e:haxe.Exception)
		{
			trace(e.details());
		}
	}

	// thread safe sound loader
	static function preloadSound(key:String, ?path:String, ?modsAllowed:Bool = true, ?beepOnNull:Bool = true):Null<Sound>
	{
		var file:String = Paths.getPath(Language.getFileTranslation(key) + '.${Paths.SOUND_EXT}', SOUND, path, modsAllowed);

		//trace('precaching sound: $file');
		if(!Paths.currentTrackedSounds.exists(file))
		{
			if (#if sys FileSystem.exists(file) || #end OpenFlAssets.exists(file, SOUND))
			{
				var sound:Sound = #if sys Sound.fromFile(file) #else OpenFlAssets.getSound(file, false) #end;
				mutex.acquire();
				Paths.currentTrackedSounds.set(file, sound);
				mutex.release();
			}
			else if (beepOnNull)
			{
				trace('SOUND NOT FOUND: $key, PATH: $path');
				FlxG.log.error('SOUND NOT FOUND: $key, PATH: $path');
				return FlxAssets.getSound('flixel/sounds/beep');
			}
		}
		mutex.acquire();
		Paths.localTrackedAssets.push(file);
		mutex.release();

		return Paths.currentTrackedSounds.get(file);
	}

	// thread safe sound loader
	static function preloadGraphic(key:String):Null<BitmapData>
	{
		try {
			var requestKey:String = 'images/$key';
			#if TRANSLATIONS_ALLOWED requestKey = Language.getFileTranslation(requestKey); #end
			if(requestKey.lastIndexOf('.') < 0) requestKey += '.png';

			if (!Paths.currentTrackedAssets.exists(requestKey))
			{
				var file:String = Paths.getPath(requestKey, IMAGE);
				if (#if sys FileSystem.exists(file) || #end OpenFlAssets.exists(file, IMAGE))
				{
					#if sys
					var bitmap:BitmapData = BitmapData.fromFile(file);
					#else
					var bitmap:BitmapData = OpenFlAssets.getBitmapData(file, false);
					#end

					mutex.acquire();
					requestedBitmaps.set(file, bitmap);
					originalBitmapKeys.set(file, requestKey);
					mutex.release();
					return bitmap;
				}
				// If the image wasn't found and it's an icon path, try with "icon-" prefix as fallback
				else if(key.indexOf('icons/') == 0)
				{
					var iconName:String = key.substr('icons/'.length);
					var fallbackKey:String = 'images/icons/icon-$iconName.png';
					#if TRANSLATIONS_ALLOWED fallbackKey = Language.getFileTranslation(fallbackKey); #end

					var fallbackFile:String = Paths.getPath(fallbackKey, IMAGE);
					if (#if sys FileSystem.exists(fallbackFile) || #end OpenFlAssets.exists(fallbackFile, IMAGE))
					{
						#if sys
						var fallbackBitmap:BitmapData = BitmapData.fromFile(fallbackFile);
						#else
						var fallbackBitmap:BitmapData = OpenFlAssets.getBitmapData(fallbackFile, false);
						#end

						mutex.acquire();
						requestedBitmaps.set(fallbackFile, fallbackBitmap);
						originalBitmapKeys.set(fallbackFile, requestKey);
						mutex.release();
						return fallbackBitmap;
					}
					else trace('no such image $key or icons/icon-$iconName exists');
				}
				else trace('no such image $key exists');
			}

			return Paths.currentTrackedAssets.get(requestKey).bitmap;
		}
		catch(e:haxe.Exception)
		{
			trace('ERROR! fail on preloading image $key');
		}

		return null;
	}
	
	#if cpp
	@:functionCode('
		return std::thread::hardware_concurrency();
    	')
	@:noCompletion
    	public static function getCPUThreadsCount():Int
    	{
        	return -1;
    	}
    	#end
}
