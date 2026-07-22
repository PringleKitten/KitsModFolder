package backend;

import haxe.Json;
import lime.utils.Assets;
import sys.thread.Mutex;

import objects.Note;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var events:Array<Dynamic>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;
	var offset:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var stage:String;
	var format:String;

	@:optional var gameOverChar:String;
	@:optional var gameOverSound:String;
	@:optional var gameOverLoop:String;
	@:optional var gameOverEnd:String;
	
	@:optional var disableNoteRGB:Bool;

	@:optional var arrowSkin:String;
	@:optional var splashSkin:String;
}

typedef SwagSection =
{
	var sectionNotes:Array<Dynamic>;
	var sectionBeats:Float;
	var mustHitSection:Bool;
	@:optional var altAnim:Bool;
	@:optional var gfSection:Bool;
	@:optional var bpm:Float;
	@:optional var changeBPM:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var events:Array<Dynamic>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var arrowSkin:String;
	public var splashSkin:String;
	public var gameOverChar:String;
	public var gameOverSound:String;
	public var gameOverLoop:String;
	public var gameOverEnd:String;
	public var disableNoteRGB:Bool = false;
	public var speed:Float = 1;
	public var stage:String;
	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gfVersion:String = 'gf';
	public var format:String = 'psych_v1';

	public static function convert(songJson:Dynamic) // Convert old charts to psych_v1 format
	{
		if(songJson.gfVersion == null)
		{
			songJson.gfVersion = songJson.player3;
			if(Reflect.hasField(songJson, 'player3')) Reflect.deleteField(songJson, 'player3');
		}

		if(songJson.events == null)
		{
			songJson.events = [];
			for (secNum in 0...songJson.notes.length)
			{
				var sec:SwagSection = songJson.notes[secNum];

				var i:Int = 0;
				var notes:Array<Dynamic> = sec.sectionNotes;
				var len:Int = notes.length;
				while(i < len)
				{
					var note:Array<Dynamic> = notes[i];
					if(note[1] < 0)
					{
						songJson.events.push([note[0], [[note[2], note[3], note[4]]]]);
						notes.remove(note);
						len = notes.length;
					}
					else i++;
				}
			}
		}

		var sectionsData:Array<SwagSection> = songJson.notes;
		if(sectionsData == null) return;

		for (section in sectionsData)
		{
			var beats:Null<Float> = cast section.sectionBeats;
			if (beats == null || Math.isNaN(beats))
			{
				section.sectionBeats = 4;
				if(Reflect.hasField(section, 'lengthInSteps')) Reflect.deleteField(section, 'lengthInSteps');
			}

			for (note in section.sectionNotes)
			{
				var gottaHitNote:Bool = (note[1] < 4) ? section.mustHitSection : !section.mustHitSection;
				note[1] = (note[1] % 4) + (gottaHitNote ? 0 : 4);

				if(!Std.isOfType(note[3], String))
					note[3] = Note.defaultNoteTypes[note[3]]; //compatibility with Week 7 and 0.1-0.3 psych charts
			}
		}
	}

	public static var chartPath:String;
	public static var loadedSongName:String;
	static var rawChartCache:Map<String, String> = [];
	static var rawChartCacheMutex:Mutex = new Mutex();

	public static function getChartPath(jsonInput:String, ?folder:String):String
	{
		if(folder == null) folder = jsonInput;

		var formattedFolder:String = Paths.formatToSongPath(folder);
		var formattedSong:String = Paths.formatToSongPath(jsonInput);
		return Paths.json('$formattedFolder/$formattedSong');
	}

	static function getCachedRawChart(path:String):String
	{
		rawChartCacheMutex.acquire();
		var cached:String = rawChartCache.get(path);
		rawChartCacheMutex.release();
		return cached;
	}

	static function setCachedRawChart(path:String, rawData:String):Void
	{
		if(path == null || rawData == null)
			return;

		rawChartCacheMutex.acquire();
		rawChartCache.set(path, rawData);
		rawChartCacheMutex.release();
	}

	public static function clearChartCache():Void
	{
		rawChartCacheMutex.acquire();
		rawChartCache.clear();
		rawChartCacheMutex.release();

		clearConvertedChartCache();
	}

	// Caches the *converted* (psych_v1, etc) chart as JSON text, keyed by resolved path + target format.
	// This lets a background thread do the expensive raw-read + convert() work once, then the main
	// thread (or any other thread) can turn that cached text back into a fresh SwagSong with just a
	// cheap Json.parse, instead of re-reading the file and re-running convert() synchronously.
	static var convertedChartCache:Map<String, String> = [];
	static var convertedChartCacheMutex:Mutex = new Mutex();

	static function convertedChartCacheKey(path:String, convertTo:String):String
		return path + '::' + (convertTo != null ? convertTo : 'raw');

	static function getCachedConvertedChart(key:String):String
	{
		convertedChartCacheMutex.acquire();
		var cached:String = convertedChartCache.get(key);
		convertedChartCacheMutex.release();
		return cached;
	}

	static function setCachedConvertedChart(key:String, json:String):Void
	{
		if(key == null || json == null)
			return;

		convertedChartCacheMutex.acquire();
		convertedChartCache.set(key, json);
		convertedChartCacheMutex.release();
	}

	public static function clearConvertedChartCache():Void
	{
		convertedChartCacheMutex.acquire();
		convertedChartCache.clear();
		convertedChartCacheMutex.release();
	}

	// Meant to be called from a background thread (e.g. FreeplayState's density/preview thread pool),
	// the same way LoadingState precaches images/sounds off the main thread. Does the full read + JSON
	// parse + psych_v1 convert() up front and stashes the result, so a later synchronous getChart()/
	// loadFromJson() call on the main thread is just a cache hit.
	public static function precacheConvertedChart(jsonInput:String, ?folder:String, ?convertTo:String = 'psych_v1'):Void
	{
		if(folder == null) folder = jsonInput;
		var path:String = getChartPath(jsonInput, folder);
		var key:String = convertedChartCacheKey(path, convertTo);

		if(getCachedConvertedChart(key) != null)
			return; // already warmed by another job

		try
		{
			var rawData:String = preloadChartRaw(jsonInput, folder);
			if(rawData == null)
				return;

			var parsed:SwagSong = parseJSON(rawData, jsonInput, convertTo);
			if(parsed != null)
				setCachedConvertedChart(key, Json.stringify(parsed));
		}
		catch(e:Dynamic) {} // if precaching fails, the main thread will just fall back to parsing normally
	}

	public static function preloadChartRaw(jsonInput:String, ?folder:String):String
	{
		var path:String = getChartPath(jsonInput, folder);
		var rawData:String = getCachedRawChart(path);

		if(rawData == null)
		{
			#if MODS_ALLOWED
			if(FileSystem.exists(path))
				rawData = File.getContent(path);
			else
			#end
				rawData = Assets.getText(path);

			if(rawData != null)
				setCachedRawChart(path, rawData);
		}

		return rawData;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		if(folder == null) folder = jsonInput;
		PlayState.SONG = getChart(jsonInput, folder);
		loadedSongName = folder;
		chartPath = _lastPath;
		#if windows
		// prevent any saving errors by fixing the path on Windows (being the only OS to ever use backslashes instead of forward slashes for paths)
		chartPath = chartPath.replace('/', '\\');
		#end
		StageData.loadDirectory(PlayState.SONG);
		return PlayState.SONG;
	}

	static var _lastPath:String;
	public static function getChart(jsonInput:String, ?folder:String, ?convertTo:String = 'psych_v1'):SwagSong
	{
		if(folder == null) folder = jsonInput;
		_lastPath = getChartPath(jsonInput, folder);

		var cacheKey:String = convertedChartCacheKey(_lastPath, convertTo);
		var cachedJson:String = getCachedConvertedChart(cacheKey);
		if(cachedJson != null)
		{
			try
			{
				return cast Json.parse(cachedJson);
			}
			catch(e:Dynamic) {} // cache got corrupted somehow, fall through to a normal load
		}

		var rawData:String = preloadChartRaw(jsonInput, folder);
		if(rawData == null)
			return null;

		var parsed:SwagSong = parseJSON(rawData, jsonInput, convertTo);
		if(parsed != null)
			setCachedConvertedChart(cacheKey, Json.stringify(parsed));
		return parsed;
	}

	public static function parseJSON(rawData:String, ?nameForError:String = null, ?convertTo:String = 'psych_v1'):SwagSong
	{
		var songJson:SwagSong = cast Json.parse(rawData);
		if(Reflect.hasField(songJson, 'song'))
		{
			var subSong:SwagSong = Reflect.field(songJson, 'song');
			if(subSong != null && Type.typeof(subSong) == TObject)
				songJson = subSong;
		}

		if(convertTo != null && convertTo.length > 0)
		{
			var fmt:String = songJson.format;
			if(fmt == null) fmt = songJson.format = 'unknown';

			switch(convertTo)
			{
				case 'psych_v1':
					if(!fmt.startsWith('psych_v1')) //Convert to Psych 1.0 format
					{
						trace('converting chart $nameForError with format $fmt to psych_v1 format...');
						songJson.format = 'psych_v1_convert';
						convert(songJson);
					}
			}
		}
		return songJson;
	}
}