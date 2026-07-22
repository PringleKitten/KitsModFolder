package backend;

import haxe.Json;
import haxe.io.Bytes;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;
import sys.thread.Thread;
import sys.thread.Mutex;

#if cpp
import lime.system.System;
#end

typedef GithubRelease = {
	var tag_name:String;
	var name:String;
	var body:String;
	var html_url:String;
	var assets:Array<{name:String, browser_download_url:String}>;
}

typedef VersionInfo = {
	var engine:String;
	var mod:String;
}

class UpdateManager
{
	public static final REPO:String = 'PringleKitten/KitsModFolder';
	public static final API_URL:String = 'https://api.github.com/repos/${REPO}/tags?per_page=100';
	
	// Cached current versions - auto-loaded from system
	public static var CURRENT_ENGINE_VERSION:String = '';
	public static var CURRENT_MOD_VERSION:String = '0.0.0';
	public static var hasInternetFavoritesMod:Bool = false;
	
	public static var updateAvailable:Bool = false;
	public static var pendingUpdate:Bool = false;
	public static var engineUpdateAvailable:Bool = false;
	public static var modUpdateAvailable:Bool = false;
	
	private static var _latestEngineVersion:String = '';
	private static var _latestModVersion:String = '';
	private static var _latestEngineTagName:String = '';
	private static var _latestModTagName:String = '';
	private static var _latestReleaseTag:String = '';
	public static var latestEngineVersionDisplay:String = '';
	public static var latestModVersionDisplay:String = '';
	public static var latestReleaseTag:String = '';
	public static var latestReleaseName:String = '';
	public static var latestReleaseBody:String = '';
	public static var latestReleaseUrl:String = '';
	private static var _updateCheckInProgress:Bool = false;
	private static var _updateCheckFallbackAttempted:Bool = false;
	private static var _downloadInProgress:Bool = false;
	private static var _versionsInitialized:Bool = false;
	private static var _versionInitInProgress:Bool = false;
	private static var _versionInitFinished:Bool = false;
	private static var _versionInitError:String = '';
	private static var _versionInitMutex:Mutex = new Mutex();
	public static var postCloseInstallPending:Bool = false;
	public static var updateReadyToApply:Bool = false;
	public static var pendingModUpdatePrompt:Bool = false;
	public static var activeUpdateType:String = 'engine';
	private static var _includeModInUpdate:Bool = false;
	private static var _pendingInstallDir:String = '';
	private static var _engineInstallDir:String = '';
	private static var _modInstallDir:String = '';
	private static var _cachedInstallDirectory:String = '';
	private static var _cachedGameExecutablePath:String = '';
	public static var progressValue:Float = 0;
	public static var progressLabel:String = 'Preparing update...';
	public static var progressTotal:Int = 0;
	public static var progressCurrent:Int = 0;
	public static var updateThreadActive:Bool = false;
	public static var updateThreadFinished:Bool = false;
	public static var updateThreadSuccessful:Bool = false;
	public static var updateThreadMessage:String = '';
	
	/**
	 * Initialize version numbers from actual game sources
	 * Should be called once at startup
	 */
	public static function initializeVersions():Void
	{
		if(_versionsInitialized) return;
		initializeVersionsCore();
	}

	static function initializeVersionsCore():Void
	{
		if(_versionsInitialized) return;
		
		// Get engine version from MainMenuState
		#if sys
		try {
			CURRENT_ENGINE_VERSION = states.MainMenuState.internetFavsVersion;
		} catch(e:Dynamic) {
			CURRENT_ENGINE_VERSION = '5.0'; // Fallback
			trace('Warning: Could not read engine version from MainMenuState: $e');
		}
		#end
		
		// Get mod version from pack.json
		hasInternetFavoritesMod = false;
		CURRENT_MOD_VERSION = getModVersionFromPack();
		
		_versionsInitialized = true;
		trace('UpdateManager initialized - Engine: $CURRENT_ENGINE_VERSION, Mod: $CURRENT_MOD_VERSION, ModInstalled: $hasInternetFavoritesMod');
	}

	public static function initializeVersionsAsync():Void
	{
		if(_versionsInitialized) return;

		_versionInitMutex.acquire();
		if(_versionInitInProgress)
		{
			_versionInitMutex.release();
			return;
		}
		_versionInitInProgress = true;
		_versionInitFinished = false;
		_versionInitError = '';
		_versionInitMutex.release();

		Thread.create(function() {
			var errorText:String = '';
			try
			{
				initializeVersionsCore();
			}
			catch(e:Dynamic)
			{
				errorText = Std.string(e);
				CURRENT_ENGINE_VERSION = CURRENT_ENGINE_VERSION != null && CURRENT_ENGINE_VERSION.length > 0 ? CURRENT_ENGINE_VERSION : '5.0';
				CURRENT_MOD_VERSION = '0.0.0';
				hasInternetFavoritesMod = false;
				_versionsInitialized = true;
			}

			_versionInitMutex.acquire();
			_versionInitError = errorText;
			_versionInitInProgress = false;
			_versionInitFinished = true;
			_versionInitMutex.release();
		});
	}

	public static function isVersionInitializationReady():Bool
	{
		if(_versionsInitialized) return true;
		_versionInitMutex.acquire();
		var ready:Bool = _versionInitFinished && !_versionInitInProgress;
		_versionInitMutex.release();
		return ready;
	}

	public static function isVersionInitializationRunning():Bool
	{
		_versionInitMutex.acquire();
		var running:Bool = _versionInitInProgress;
		_versionInitMutex.release();
		return running;
	}

	public static function getVersionInitializationError():String
	{
		_versionInitMutex.acquire();
		var error:String = _versionInitError;
		_versionInitMutex.release();
		return error;
	}
	
	/**
	 * Check for updates asynchronously
	 * Callback receives: (updateAvailable:Bool, engineUpdateAvailable:Bool, modUpdateAvailable:Bool, errorMessage:String)
	 */
	public static function checkForUpdates(callback:Bool->Bool->Bool->String->Void):Void
	{
		// Initialize versions on first check
		if(!_versionsInitialized) {
			initializeVersions();
		}
		
		if(_updateCheckInProgress) return;
		
		_updateCheckInProgress = true;
		_updateCheckFallbackAttempted = false;
		
		// Use HTTP request to check GitHub API
		#if sys
		try {
			var http = new haxe.Http(API_URL);
			http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
			http.setHeader('Accept', 'application/vnd.github+json');
			
			http.onData = function(data:String) {
				parseReleaseInfo(data, callback);
			};
			
			http.onError = function(error:String) {
				handleUpdateCheckFailure(callback, error);
			};
			
			http.request(false);
		} catch(e:Dynamic) {
			handleUpdateCheckFailure(callback, Std.string(e));
		}
		#else
		callback(false, false, false, 'Update checking not supported on this platform');
		#end
	}
	
	private static function handleUpdateCheckFailure(callback:Bool->Bool->Bool->String->Void, ?error:String):Void
	{
		if(!_updateCheckFallbackAttempted) {
			_updateCheckFallbackAttempted = true;
			trace('Primary update check failed, trying GitHub tag-page fallback: ' + (error != null && error.length > 0 ? error : 'GitHub API request failed'));
			fetchTagFallback(callback);
			return;
		}
		
		_updateCheckInProgress = false;
		engineUpdateAvailable = false;
		modUpdateAvailable = false;
		updateAvailable = false;
		_latestEngineVersion = '';
		_latestModVersion = '';
		_latestEngineTagName = '';
		_latestModTagName = '';
		_latestReleaseTag = '';
		latestEngineVersionDisplay = CURRENT_ENGINE_VERSION;
		latestModVersionDisplay = CURRENT_MOD_VERSION;
		latestReleaseTag = '';
		latestReleaseName = '';
		latestReleaseBody = '';
		latestReleaseUrl = '';
		trace('Update check unavailable: ' + (error != null && error.length > 0 ? error : 'GitHub API request failed'));
		callback(false, false, false, '');
	}

	private static function parseReleaseInfo(jsonString:String, callback:Bool->Bool->Bool->String->Void):Void
	{
		try {
			var tags:Array<Dynamic> = Json.parse(jsonString);
			var engineInfo = findLatestTagInfoForPrefix(tags, 'engine');
			var modInfo = findLatestTagInfoForPrefix(tags, 'mod');
			_latestEngineVersion = engineInfo.version;
			_latestEngineTagName = engineInfo.tagName;
			_latestModVersion = modInfo.version;
			_latestModTagName = modInfo.tagName;
			if(_latestEngineVersion.length == 0 && _latestModVersion.length == 0) {
				fetchTagFallback(callback);
				return;
			}
			finishUpdateCheck(callback);
		} catch(e:Dynamic) {
			handleUpdateCheckFailure(callback, 'Failed to parse version info: $e');
		}
	}

	private static function fetchTagFallback(callback:Bool->Bool->Bool->String->Void):Void
	{
		#if sys
		try {
			var tagsUrl = 'https://github.com/${REPO}/tags';
			var http = new haxe.Http(tagsUrl);
			http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
			http.onData = function(data:String) {
				try {
					var tags:Array<String> = [];
					var regex = ~/href="\/PringleKitten\/KitsModFolder\/releases\/tag\/([^"#?]+)"/g;
					while(regex.match(data)) {
						var tagName = regex.matched(1);
						if(tagName.length > 0 && !containsString(tags, tagName)) {
							tags.push(tagName);
						}
						data = regex.matchedRight();
					}
					if(tags.length > 0) {
						var engineInfo = findLatestTagInfoForFallback(tags, 'engine');
						var modInfo = findLatestTagInfoForFallback(tags, 'mod');
						_latestEngineVersion = engineInfo.version;
						_latestEngineTagName = engineInfo.tagName;
						_latestModVersion = modInfo.version;
						_latestModTagName = modInfo.tagName;
					} else {
						_latestEngineVersion = '';
						_latestEngineTagName = '';
						_latestModVersion = '';
						_latestModTagName = '';
					}
					finishUpdateCheck(callback);
				} catch(e:Dynamic) {
					handleUpdateCheckFailure(callback, 'Failed to parse fallback tag info: $e');
				}
			};
			http.onError = function(error:String) {
				handleUpdateCheckFailure(callback, error);
			};
			http.request(false);
		} catch(e:Dynamic) {
			handleUpdateCheckFailure(callback, Std.string(e));
		}
		#end
	}

	private static function findLatestTagInfoForFallback(tags:Array<String>, prefix:String):{version:String, tagName:String}
	{
		var result:{version:String, tagName:String} = {version: '', tagName: ''};
		for(tagName in tags) {
			if(tagName == null || tagName.length == 0) continue;
			var normalized = StringTools.trim(tagName);
			if(normalized.startsWith('v')) normalized = normalized.substring(1);
			var version = extractVersionForPrefix(normalized, prefix);
			if(version.length == 0) continue;
			if(result.version.length == 0 || compareVersions(version, result.version) > 0) {
				result.version = version;
				result.tagName = tagName;
			}
		}
		return result;
	}

	private static function finishUpdateCheck(callback:Bool->Bool->Bool->String->Void):Void
	{
		_latestReleaseTag = _latestEngineTagName.length > 0 ? _latestEngineTagName : (_latestEngineVersion.length > 0 ? 'engine-' + _latestEngineVersion : '');
		latestEngineVersionDisplay = _latestEngineVersion;
		latestModVersionDisplay = _latestModVersion;
		latestReleaseTag = '';
		latestReleaseName = '';
		latestReleaseBody = '';
		latestReleaseUrl = '';

		engineUpdateAvailable = _latestEngineVersion.length > 0 && compareVersions(_latestEngineVersion, CURRENT_ENGINE_VERSION) > 0;

		modUpdateAvailable = false;
		if(hasInternetFavoritesMod) {
			modUpdateAvailable = _latestModVersion.length > 0 && compareVersions(_latestModVersion, CURRENT_MOD_VERSION) > 0;
			trace('Mod update check: installed=$hasInternetFavoritesMod currentMod=$CURRENT_MOD_VERSION latestMod=$_latestModVersion result=$modUpdateAvailable');
		} else {
			trace('Internet Favorites mod not found - skipping mod update check');
		}

		updateAvailable = engineUpdateAvailable || modUpdateAvailable;
		if(updateAvailable) {
			var releaseTag = getPreferredReleaseTag();
			latestReleaseTag = releaseTag;
			latestReleaseUrl = releaseTag.length > 0 ? 'https://github.com/${REPO}/releases/tag/${releaseTag}' : '';
			if(releaseTag.length > 0) {
				fetchReleaseDetails(releaseTag);
			}
		}

		_updateCheckInProgress = false;
		callback(updateAvailable, engineUpdateAvailable, modUpdateAvailable, '');
	}

	private static function getPreferredReleaseTag():String
	{
		if(modUpdateAvailable && _latestModTagName.length > 0) return _latestModTagName;
		if(engineUpdateAvailable && _latestEngineTagName.length > 0) return _latestEngineTagName;
		if(modUpdateAvailable && _latestModVersion.length > 0) return 'mod-' + _latestModVersion;
		if(engineUpdateAvailable && _latestEngineVersion.length > 0) return 'engine-' + _latestEngineVersion;
		return '';
	}

	public static function getReleaseTagForUpdateKind(updateKind:String):String
	{
		if(updateKind == 'mod') {
			if(_latestModTagName.length > 0) return _latestModTagName;
			if(_latestModVersion.length > 0) return 'mod-' + _latestModVersion;
			return '';
		}
		if(_latestEngineTagName.length > 0) return _latestEngineTagName;
		if(_latestEngineVersion.length > 0) return 'engine-' + _latestEngineVersion;
		return '';
	}

	public static function getReleaseUrlForUpdateKind(updateKind:String):String
	{
		var releaseTag = getReleaseTagForUpdateKind(updateKind);
		return releaseTag.length > 0 ? 'https://github.com/${REPO}/releases/tag/${releaseTag}' : '';
	}

	private static function fetchReleaseDetails(tagName:String):Void
	{
		#if sys
		try {
			var releaseUrl = 'https://api.github.com/repos/${REPO}/releases/tags/${tagName}';
			var http = new haxe.Http(releaseUrl);
			http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
			http.onData = function(data:String) {
				try {
					var release:Dynamic = Json.parse(data);
					latestReleaseName = release != null && release.name != null ? Std.string(release.name) : '';
					latestReleaseBody = release != null && release.body != null ? Std.string(release.body) : '';
				} catch(e:Dynamic) {
					latestReleaseName = '';
					latestReleaseBody = '';
				}
			};
			http.onError = function(error:String) {
				latestReleaseName = '';
				latestReleaseBody = '';
				latestReleaseUrl = '';
			};
			http.request(false);
		} catch(e:Dynamic) {
			latestReleaseName = '';
			latestReleaseBody = '';
		}
		#end
	}

	private static function findLatestTagInfoForPrefix(tags:Array<Dynamic>, prefix:String):{version:String, tagName:String}
	{
		var result:{version:String, tagName:String} = {version: '', tagName: ''};
		for(entry in tags) {
			var tagName:String = entry != null ? Std.string(entry.name) : '';
			if(tagName.length == 0) continue;
			var normalized = StringTools.trim(tagName);
			if(normalized.startsWith('v')) normalized = normalized.substring(1);
			var version = extractVersionForPrefix(normalized, prefix);
			if(version.length == 0) continue;
			if(!isTagTypeCompatible(normalized, prefix)) continue;
			if(result.version.length == 0 || compareVersions(version, result.version) > 0) {
				result.version = version;
				result.tagName = tagName;
			}
		}
		return result;
	}

	private static function extractVersionForPrefix(tag:String, prefix:String):String
	{
		if(tag == null) return '';
		var text = StringTools.trim(tag);
		if(text.length == 0) return '';
		if(text.startsWith('v')) text = text.substring(1);

		if(!isTagTypeCompatible(text, prefix)) return '';

		var prefixLower = prefix != null ? prefix.toLowerCase() : '';
		var normalizedText = text.toLowerCase();
		if(prefixLower == 'mod') {
			var modPrefix = 'mod-';
			if(normalizedText.startsWith(modPrefix)) {
				return extractVersionFromTag(text.substring(modPrefix.length));
			}
			if(normalizedText.startsWith('mod ')) {
				return extractVersionFromTag(text.substring(4));
			}
		}
		if(prefixLower == 'engine') {
			var enginePrefix = 'engine-';
			if(normalizedText.startsWith(enginePrefix)) {
				return extractVersionFromTag(text.substring(enginePrefix.length));
			}
			if(normalizedText.startsWith('engine ')) {
				return extractVersionFromTag(text.substring(7));
			}
		}

		return '';
	}

	private static function isTagTypeCompatible(tag:String, prefix:String):Bool
	{
		if(tag == null || tag.length == 0) return false;
		var normalized = StringTools.trim(tag).toLowerCase();
		var prefixLower = prefix != null ? prefix.toLowerCase() : '';
		if(prefixLower == 'mod') {
			return normalized.startsWith('mod-') || normalized.startsWith('mod ') || normalized.startsWith('mod') && normalized.indexOf('engine') < 0;
		}
		if(prefixLower == 'engine') {
			return normalized.startsWith('engine-') || normalized.startsWith('engine ') || normalized.startsWith('engine') && normalized.indexOf('mod') < 0;
		}
		return false;
	}

	private static function extractVersionFromTag(tag:String):String
	{
		if(tag == null) return '';
		var text = StringTools.trim(tag);
		if(text.length == 0) return '';
		if(text.startsWith('v')) text = text.substring(1);

		var startIndex = -1;
		for(i in 0...text.length) {
			var ch = text.charAt(i);
			if(ch >= '0' && ch <= '9') {
				startIndex = i;
				break;
			}
		}
		if(startIndex < 0) return '';

		var endIndex = startIndex;
		while(endIndex < text.length) {
			var ch = text.charAt(endIndex);
			if(ch >= '0' && ch <= '9' || ch == '.' || ch == '_' || ch == '-' || (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')) {
				endIndex++;
			} else {
				break;
			}
		}
		return text.substring(startIndex, endIndex);
	}
	
	/**
	 * Compare two semantic versions
	 * Returns: -1 if v1 < v2, 0 if equal, 1 if v1 > v2
	 */
	private static function compareVersions(v1:String, v2:String):Int
	{
		var parsed1 = parseVersionTokens(v1);
		var parsed2 = parseVersionTokens(v2);
		
		for(i in 0...Std.int(Math.max(parsed1.parts.length, parsed2.parts.length))) {
			var p1 = i < parsed1.parts.length ? parsed1.parts[i] : 0;
			var p2 = i < parsed2.parts.length ? parsed2.parts[i] : 0;
			
			if(p1 > p2) return 1;
			if(p1 < p2) return -1;
		}

		if(parsed1.parts.length == 0 && parsed2.parts.length == 0) {
			return compareSuffix(parsed1.suffix, parsed2.suffix);
		}
		
		if(parsed1.suffix.length == 0 && parsed2.suffix.length > 0) return -1;
		if(parsed1.suffix.length > 0 && parsed2.suffix.length == 0) return 1;
		if(parsed1.suffix.length > 0 && parsed2.suffix.length > 0) {
			var suffixCompare = compareSuffix(parsed1.suffix, parsed2.suffix);
			if(suffixCompare != 0) return suffixCompare;
		}
		return 0;
	}

	private static function parseVersionTokens(value:String):{parts:Array<Int>, suffix:String}
	{
		var cleaned = value == null ? '' : StringTools.trim(value);
		if(cleaned.length > 0 && cleaned.charAt(0) == 'v') {
			cleaned = cleaned.substr(1);
		}
		
		var numericPart:String = '';
		var suffix:String = '';
		for(i in 0...cleaned.length) {
			var ch = cleaned.charAt(i);
			if(ch >= '0' && ch <= '9' || ch == '.') {
				numericPart += ch;
			} else {
				suffix += ch;
			}
		}
		
		var parts:Array<Int> = [];
		if(numericPart.length > 0) {
			for(segment in numericPart.split('.')) {
				var parsed = Std.parseInt(segment);
				if(parsed != null) parts.push(parsed);
			}
		}
		return {parts: parts, suffix: suffix};
	}

	private static function compareSuffix(left:String, right:String):Int
	{
		var leftLower = left.toLowerCase();
		var rightLower = right.toLowerCase();
		if(leftLower == rightLower) return 0;
		if(leftLower.length == 0) return -1;
		if(rightLower.length == 0) return 1;
		if(leftLower == 'r' || leftLower == 'rev' || leftLower == 'revision') return 1;
		if(rightLower == 'r' || rightLower == 'rev' || rightLower == 'revision') return -1;
		var maxLen = Std.int(Math.max(leftLower.length, rightLower.length));
		for(i in 0...maxLen) {
			var leftChar = i < leftLower.length ? leftLower.charCodeAt(i) : 0;
			var rightChar = i < rightLower.length ? rightLower.charCodeAt(i) : 0;
			if(leftChar > rightChar) return 1;
			if(leftChar < rightChar) return -1;
		}
		return 0;
	}
	
	/**
	 * Get mod version from pack.json in mods folder
	 * Only looks for Internet Favorites mod specifically
	 */
	public static function getModVersionFromPack():String
	{
		try {
			#if sys
			var modInfo = getInstalledModInfo();
			if(modInfo != null && modInfo.version != null && modInfo.version.length > 0 && modInfo.version != '0.0.0' && modInfo.name != null && modInfo.name.length > 0) {
				trace('Found installed mod version from metadata: ${modInfo.version} (${modInfo.name})');
				hasInternetFavoritesMod = true;
				return modInfo.version;
			}
			trace('No installed Internet Favorites mod metadata found');
			#end
		} catch(e:Dynamic) {
			trace('Error reading mod version from pack.json: $e');
		}
		
		hasInternetFavoritesMod = false;
		return '0.0.0';
	}

	private static function getInstalledModInfo():{name:String, version:String}
	{
		var result:{name:String, version:String} = {name: '', version: '0.0.0'};
		#if sys
		var baseDirs:Array<String> = getModBaseDirectories();
		for(baseDir in baseDirs) {
			if(baseDir == null || baseDir.length == 0) continue;
			if(!FileSystem.exists(baseDir) || !FileSystem.isDirectory(baseDir)) continue;
			try {
				for(folder in FileSystem.readDirectory(baseDir)) {
					var modDir = Path.join([baseDir, folder]);
					if(!FileSystem.isDirectory(modDir)) continue;
					var folderLower = folder.toLowerCase();
					var shouldInspect = folderLower.indexOf('ifemod') >= 0 || folderLower.indexOf('internet') >= 0 || folderLower.indexOf('favorites') >= 0;
					if(!shouldInspect) continue;
					var packPath = Path.join([modDir, 'pack.json']);
					if(!FileSystem.exists(packPath)) continue;
					try {
						var rawJson:String = File.getContent(packPath);
						var pack:Dynamic = Json.parse(rawJson);
						var packName:String = pack.name != null ? Std.string(pack.name) : '';
						var version:String = '';
						if(pack.version != null) version = Std.string(pack.version);
						if(version.length == 0) version = extractVersionFromPackName(packName);
						if(version.length == 0) version = extractVersionFromText(packName + ' ' + folder);
						if(version.length == 0) {
							var folderVersion = extractVersionFromText(folder);
							if(folderVersion.length > 0) version = folderVersion;
						}
						trace('Inspecting mod folder $folder at $packPath -> packName=$packName version=$version');
						if(hasExactInternetFavoritesIdentity(packName, folder) && version.length > 0 && version != '0.0.0') {
							result.name = packName.length > 0 ? packName : folder;
							result.version = version;
							return result;
						}
					} catch(e:Dynamic) {
						trace('Failed to read pack.json for mod $folder: $e');
					}
				}
			} catch(e:Dynamic) {
				trace('Failed to scan mod directory $baseDir: $e');
			}
		}
		#end
		return result;
	}

	private static function hasExactInternetFavoritesIdentity(packName:String, folder:String):Bool
	{
		var packText = packName != null ? packName : '';
		var folderText = folder != null ? folder : '';
		var packLower = packText.toLowerCase();
		var folderLower = folderText.toLowerCase();
		return (packLower.indexOf('internet favorites') >= 0 || packLower.indexOf('internet favorites rev') >= 0 || packLower.indexOf('internet favorites') >= 0) &&
			(folderLower.indexOf('ifemod') >= 0 || folderLower.indexOf('internet') >= 0 || folderLower.indexOf('favorites') >= 0);
	}

	private static function getModBaseDirectories():Array<String>
	{
		var dirs:Array<String> = [];
		#if sys
		var installDir = getInstallDirectory();
		if(installDir != null && installDir.length > 0) {
			var modsDir = Path.join([installDir, 'mods']);
			dirs.push(Path.normalize(modsDir));
		}
		var cwd = Sys.getCwd();
		if(cwd != null && cwd.length > 0) {
			var cwdModsDir = Path.join([cwd, 'mods']);
			dirs.push(Path.normalize(cwdModsDir));
		}
		dirs.push('mods');
		#end
		return dirs;
	}

	private static function extractVersionFromPackName(value:String):String
	{
		if(value == null) return '';
		var text = StringTools.trim(value);
		if(text.length == 0) return '';
		var regex = ~/rev([0-9]+(?:\.[0-9]+)*(?:[A-Za-z0-9._-]+)?)/i;
		if(regex.match(text)) {
			return regex.matched(1);
		}
		var versionRegex = ~/([0-9]+(?:\.[0-9]+)*(?:[A-Za-z0-9._-]+)?)/;
		if(versionRegex.match(text)) {
			return versionRegex.matched(1);
		}
		return '';
	}

	private static function extractVersionFromText(value:String):String
	{
		if(value == null) return '';
		var text = StringTools.trim(value);
		if(text.length == 0) return '';
		var regex = ~/([0-9]+(?:\.[0-9]+)*(?:[A-Za-z0-9._-]+)?)/;
		if(regex.match(text)) {
			return regex.matched(1);
		}
		return '';
	}
	
	/**
	 * Download and apply updates from the latest GitHub release tag.
	 * This avoids the broken compare-diff URL and uses the release tag contents directly.
	 */
	public static function downloadAndApplyUpdates(callback:Bool->String->Void, includeMod:Bool = false):Void
	{
		startUpdateDownload(callback, includeMod, false);
	}

	public static function downloadModUpdateAfterEngine(callback:Bool->String->Void):Void
	{
		startUpdateDownload(callback, true, true);
	}

	private static function startUpdateDownload(callback:Bool->String->Void, includeMod:Bool, preserveExistingInstallState:Bool):Void
	{
		if(_downloadInProgress || updateThreadActive) return;
		
		_downloadInProgress = true;
		_includeModInUpdate = includeMod;
		activeUpdateType = includeMod ? 'mod' : 'engine';
		postCloseInstallPending = false;
		resetProgressState(preserveExistingInstallState);
		updateThreadActive = true;
		
		#if sys
		try {
			Thread.create(function() {
				try {
					var targetTagName = getTargetTagName(includeMod);
					if(targetTagName == null || targetTagName.length == 0) {
						finishUpdate(false, 'No release tag available for update');
						return;
					}
					
					var currentTagName = getCurrentTagName(includeMod);
					trace('Comparing current tag $currentTagName against release tag: $targetTagName (include mod: $includeMod)');
					fetchChangedFiles(currentTagName, targetTagName, includeMod, function(success:Bool, message:String) {
						finishUpdate(success, message);
					});
				} catch(e:Dynamic) {
					finishUpdate(false, 'Error during update: $e');
				}
			});
		} catch(e:Dynamic) {
			finishUpdate(false, 'Error during update: $e');
		}
		#else
		finishUpdate(false, 'Updates not supported on this platform');
		#end
	}
	
	/**
	 * Fetch the file list for a release tag from the GitHub tree API.
	 */
	private static function resetProgressState(preserveExistingInstallState:Bool = false):Void
	{
		progressValue = 0;
		progressLabel = 'Preparing update...';
		progressTotal = 0;
		progressCurrent = 0;
		updateThreadActive = false;
		updateThreadFinished = false;
		updateThreadSuccessful = false;
		updateThreadMessage = '';
		updateReadyToApply = false;
		postCloseInstallPending = false;
		pendingModUpdatePrompt = false;
		if(!preserveExistingInstallState) {
			_pendingInstallDir = '';
			_engineInstallDir = '';
			_modInstallDir = '';
		}
		_cachedGameExecutablePath = '';
		_cachedInstallDirectory = '';
	}

	private static function setProgress(label:String, current:Int, total:Int):Void
	{
		progressLabel = label;
		progressCurrent = current;
		progressTotal = total;
		progressValue = total > 0 ? current / total : 0;
	}

	private static function finishUpdate(success:Bool, message:String):Void
	{
		_downloadInProgress = false;
		updateThreadActive = false;
		updateThreadFinished = true;
		updateThreadSuccessful = success;
		updateThreadMessage = message;
		if(success) {
			CURRENT_ENGINE_VERSION = _latestEngineVersion;
			CURRENT_MOD_VERSION = _latestModVersion;
			pendingUpdate = true;
			postCloseInstallPending = false;
			updateReadyToApply = false;
		} else {
			pendingUpdate = false;
			postCloseInstallPending = false;
			updateReadyToApply = false;
		}
	}

	private static function getTargetTagName(includeMod:Bool):String
	{
		if(includeMod && modUpdateAvailable && _latestModTagName.length > 0) {
			return _latestModTagName;
		}
		if(engineUpdateAvailable && _latestEngineTagName.length > 0) {
			return _latestEngineTagName;
		}
		if(includeMod && modUpdateAvailable && _latestModVersion.length > 0) {
			return 'mod-' + _latestModVersion;
		}
		if(engineUpdateAvailable && _latestEngineVersion.length > 0) {
			return 'engine-' + _latestEngineVersion;
		}
		return '';
	}

	private static function getCurrentTagName(includeMod:Bool):String
	{
		if(includeMod && modUpdateAvailable && CURRENT_MOD_VERSION != null && CURRENT_MOD_VERSION.length > 0 && CURRENT_MOD_VERSION != '0.0.0') {
			return 'mod-' + CURRENT_MOD_VERSION;
		}
		if(CURRENT_ENGINE_VERSION != null && CURRENT_ENGINE_VERSION.length > 0) {
			var currentEngineTag = getMatchingReleaseTag(CURRENT_ENGINE_VERSION);
			if(currentEngineTag.length > 0) return currentEngineTag;
			return 'engine-' + CURRENT_ENGINE_VERSION;
		}
		if(includeMod && CURRENT_MOD_VERSION != null && CURRENT_MOD_VERSION.length > 0 && CURRENT_MOD_VERSION.length != '0.0.0'.length) {
			return 'mod-' + CURRENT_MOD_VERSION;
		}
		return _latestEngineVersion.length > 0 ? getMatchingReleaseTag(_latestEngineVersion) : '';
	}

	private static function getMatchingReleaseTag(version:String):String
	{
		if(version == null || version.length == 0) return '';
		var normalized = StringTools.trim(version);
		if(normalized.startsWith('v')) normalized = normalized.substring(1);
		var candidates:Array<String> = [];
		addUniqueCandidate(candidates, 'Engine-' + normalized);
		addUniqueCandidate(candidates, 'engine-' + normalized);
		addUniqueCandidate(candidates, normalized);
		addUniqueCandidate(candidates, 'v' + normalized);
		for(candidate in candidates) {
			if(candidate.length > 0) return candidate;
		}
		return '';
	}

	private static function fetchChangedFiles(baseTag:String, headTag:String, includeMod:Bool, callback:Bool->String->Void):Void
	{
		resolveRemoteTagNameString(baseTag, function(resolvedBaseTag:String) {
			resolveRemoteTagNameString(headTag, function(resolvedHeadTag:String) {
				var compareBaseTag = resolvedBaseTag.length > 0 ? resolvedBaseTag : baseTag;
				var compareHeadTag = resolvedHeadTag.length > 0 ? resolvedHeadTag : headTag;
				resolveComparableBaseTag(compareBaseTag, compareHeadTag, function(resolvedCompareBaseTag:String) {
					var finalBaseTag = resolvedCompareBaseTag.length > 0 ? resolvedCompareBaseTag : compareBaseTag;
					trace('Using GitHub compare API for $finalBaseTag -> $compareHeadTag');
					fetchCompareChanges(finalBaseTag, compareHeadTag, includeMod, function(files:Array<String>, deletions:Array<String>) {
						if((files == null || files.length == 0) && (deletions == null || deletions.length == 0)) {
							finishUpdate(false, 'No changed files could be resolved between the current and target versions.');
						} else {
							downloadFiles(files, deletions, compareHeadTag, callback);
						}
					});
				});
			});
		});
	}

	private static function resolveComparableBaseTag(baseTag:String, headTag:String, callback:String->Void):Void
	{
		if(baseTag == null || baseTag.length == 0 || headTag == null || headTag.length == 0) {
			callback(baseTag);
			return;
		}
		var tagsUrl = 'https://api.github.com/repos/${REPO}/tags?per_page=100';
		var http = new haxe.Http(tagsUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			try {
				var tags:Array<Dynamic> = Json.parse(data);
				var bestTag = findBestComparableBaseTag(baseTag, headTag, tags);
				callback(bestTag.length > 0 ? bestTag : baseTag);
			} catch(e:Dynamic) {
				callback(baseTag);
			}
		};
		http.onError = function(error:String) {
			callback(baseTag);
		};
		http.request(false);
	}

	private static function findBestComparableBaseTag(baseTag:String, headTag:String, remoteTags:Array<Dynamic>):String
	{
		if(baseTag == null || baseTag.length == 0 || remoteTags == null) return '';
		var normalizedBase = normalizeTag(baseTag);
		var normalizedHead = normalizeTag(headTag);
		var baseVersion = extractVersionFromTag(baseTag);
		var baseKind = getTagKind(baseTag);
		var bestTag = '';
		var bestScore = -1;
		for(entry in remoteTags) {
			var remoteTag:String = entry != null ? Std.string(entry.name) : '';
			if(remoteTag.length == 0) continue;
			var normalizedRemote = normalizeTag(remoteTag);
			if(normalizedRemote.length == 0 || normalizedRemote == normalizedHead || normalizedRemote == normalizedBase) continue;
			var remoteKind = getTagKind(remoteTag);
			var remoteVersion = extractVersionFromTag(remoteTag);
			if(remoteVersion.length == 0) continue;
			var isVersionCompatible = isComparableReleaseVersion(baseVersion, remoteVersion);
			if(baseKind.length > 0) {
				if(remoteKind.length > 0 && remoteKind != baseKind && !isVersionCompatible) continue;
				if(remoteKind.length == 0 && !isVersionCompatible) continue;
			}
			if(!isVersionCompatible) continue;
			var remoteLower = remoteTag.toLowerCase();
			if(remoteLower.indexOf('alpha') >= 0 || remoteLower.indexOf('beta') >= 0 || remoteLower.indexOf('dev') >= 0 || remoteLower.indexOf('nightly') >= 0) continue;
			var score = 0;
			if(baseVersion.length > 0) {
				var baseCore = getComparableVersionCore(baseVersion);
				var remoteCore = getComparableVersionCore(remoteVersion);
				if(remoteCore == baseCore) {
					score += 100;
				} else {
					var basePrefix = getVersionPrefix(baseCore);
					if(basePrefix.length > 0 && remoteCore.indexOf(basePrefix) >= 0) {
						score += 40;
					}
				}
			}
			if(normalizedRemote.indexOf(normalizedBase) >= 0) score += 50;
			if(remoteLower.indexOf('engine') >= 0) score += 8;
			if(remoteLower.indexOf('release') >= 0) score += 4;
			if(score > bestScore) {
				bestTag = remoteTag;
				bestScore = score;
			}
		}
		return bestTag;
	}

	private static function getTagKind(tag:String):String
	{
		if(tag == null || tag.length == 0) return '';
		var normalized = normalizeTag(tag);
		if(normalized.startsWith('engine-')) return 'engine';
		if(normalized.startsWith('mod-')) return 'mod';
		if(normalized.indexOf('engine') >= 0) return 'engine';
		if(normalized.indexOf('mod') >= 0) return 'mod';
		return '';
	}

	private static function isComparableReleaseVersion(baseVersion:String, remoteVersion:String):Bool
	{
		if(baseVersion == null || baseVersion.length == 0 || remoteVersion == null || remoteVersion.length == 0) return false;
		var baseCore = getComparableVersionCore(baseVersion);
		var remoteCore = getComparableVersionCore(remoteVersion);
		if(baseCore.length == 0 || remoteCore.length == 0) return false;
		if(baseCore == remoteCore) return true;
		return remoteCore.indexOf(baseCore + '.') >= 0 || remoteCore.indexOf(baseCore + '-') >= 0 || remoteCore.indexOf(baseCore + '_') >= 0;
	}

	private static function getComparableVersionCore(version:String):String
	{
		if(version == null || version.length == 0) return '';
		var text = StringTools.trim(version);
		if(text.length == 0) return '';
		var lower = text.toLowerCase();
		for(suffix in ['revision', 'rev', 'release', 'r']) {
			if(lower.endsWith(suffix)) {
				return StringTools.trim(text.substring(0, text.length - suffix.length));
			}
		}
		return text;
	}

	private static function fetchCompareChanges(baseTag:String, headTag:String, includeMod:Bool, callback:Array<String>->Array<String>->Void):Void
	{
		if(baseTag == null || baseTag.length == 0 || headTag == null || headTag.length == 0) {
			callback([], []);
			return;
		}

		var compareUrl = 'https://api.github.com/repos/${REPO}/compare/${baseTag}...${headTag}';
		trace('Requesting compare URL: $compareUrl');
		var http = new haxe.Http(compareUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			try {
				var compareData:Dynamic = Json.parse(data);
				var compareOperations = collectCompareOperations(compareData, includeMod);
				var compareFiles:Array<String> = compareOperations.files != null ? compareOperations.files : [];
				var compareDeletions:Array<String> = compareOperations.deletions != null ? compareOperations.deletions : [];
				var compareCommits:Array<String> = collectCommitShas(compareData);
				if((compareFiles.length > 0) || (compareDeletions.length > 0)) {
					trace('Using compare API file list for $baseTag -> $headTag (${compareFiles.length} files, ${compareDeletions.length} deletions)');
					processCompareOperations(compareFiles, compareDeletions, headTag, callback);
				} else if(compareCommits.length > 0) {
					trace('Compare API returned commits but no file list; inspecting commits for $baseTag -> $headTag');
					inspectCommitFiles(compareCommits, 0, includeMod, headTag, callback);
				} else {
					trace('Compare API returned no file changes; falling back to tree comparison for $baseTag -> $headTag');
					fallbackToTreeComparison(baseTag, headTag, includeMod, callback);
				}
			} catch(e:Dynamic) {
				trace('Compare API parse failed: $e');
				fallbackToCompareDiff(baseTag, headTag, includeMod, callback);
			}
		};
		http.onError = function(error:String) {
			trace('Compare API request failed: $error');
			fallbackToCompareDiff(baseTag, headTag, includeMod, callback);
		};
		http.request(false);
	}

	private static function fallbackToCompareDiff(baseTag:String, headTag:String, includeMod:Bool, callback:Array<String>->Array<String>->Void):Void
	{
		if(baseTag == null || baseTag.length == 0 || headTag == null || headTag.length == 0) {
			fallbackToTreeComparison(baseTag, headTag, includeMod, callback);
			return;
		}

		var diffUrl = 'https://github.com/${REPO}/compare/${baseTag}...${headTag}.diff';
		var http = new haxe.Http(diffUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			var files:Array<String> = [];
			var deletions:Array<String> = [];
			try {
				var lines:Array<String> = data != null ? data.split('\n') : [];
				for(line in lines) {
					var trimmed:String = StringTools.trim(line);
					if(trimmed.startsWith('diff --git ')) {
						var dividerIndex = trimmed.indexOf(' b/');
						if(dividerIndex >= 0) {
							var oldPath = normalizeCompareDiffPath(trimmed.substring('diff --git a/'.length, dividerIndex));
							var newPath = normalizeCompareDiffPath(trimmed.substring(dividerIndex + 3));
							if(oldPath.length > 0 && isPathRelevantForUpdate(oldPath, includeMod)) {
								if(newPath.length == 0) {
									deletions.push(oldPath);
								} else if(oldPath != newPath) {
									deletions.push(oldPath);
									files.push(newPath);
								}
							}
							if(newPath.length > 0 && newPath != oldPath && isPathRelevantForUpdate(newPath, includeMod)) {
								if(oldPath.length == 0) {
									files.push(newPath);
								}
							}
						}
					}
				}
				if(files.length > 0 || deletions.length > 0) {
					trace('Using GitHub compare diff fallback for $baseTag -> $headTag (${files.length} files, ${deletions.length} deletions)');
					processCompareOperations(files, deletions, headTag, callback);
					return;
				}
			} catch(e:Dynamic) {
				trace('Compare diff fallback parse failed: $e');
			}
			fallbackToTreeComparison(baseTag, headTag, includeMod, callback);
		};
		http.onError = function(error:String) {
			trace('Compare diff fallback request failed: $error');
			fallbackToTreeComparison(baseTag, headTag, includeMod, callback);
		};
		http.request(false);
	}

	private static function normalizeCompareDiffPath(path:String):String
	{
		if(path == null) return '';
		var normalized = StringTools.trim(path);
		if(normalized.length == 0 || normalized == '/dev/null') return '';
		while(normalized.startsWith('/')) normalized = normalized.substring(1);
		if(normalized.startsWith('a/')) normalized = normalized.substring(2);
		if(normalized.startsWith('b/')) normalized = normalized.substring(2);
		return normalized;
	}

	private static function isPathRelevantForUpdate(path:String, includeMod:Bool):Bool
	{
		if(path == null || path.length == 0) return false;
		if(shouldIgnoreFile(path)) return false;
		if(includeMod) return true;
		return !path.startsWith('mods/');
	}

	private static function processCompareOperations(remoteFiles:Array<String>, remoteDeletions:Array<String>, headTag:String, callback:Array<String>->Array<String>->Void):Void
	{
		var files:Array<String> = [];
		var deletions:Array<String> = [];
		var installDir = getInstallDirectory();
		var fileIndex = 0;
		var processNext:Void->Void;
		processNext = function() {
			if(fileIndex >= remoteFiles.length) {
				for(deletionPath in remoteDeletions) {
					var targetKind = getActiveInstallTargetKind();
					var relativeDeletion = getRelativePathForInstallTarget(deletionPath, targetKind);
					if(relativeDeletion.length > 0) {
						deletions.push(deletionPath);
					}
				}
				callback(files, deletions);
				return;
			}
			var remotePath:String = remoteFiles[fileIndex++];
			var targetKind = getActiveInstallTargetKind();
			var relativePath = getRelativePathForInstallTarget(remotePath, targetKind);
			if(relativePath.length == 0) {
				processNext();
				return;
			}
			var localPath = getExpectedInstallTargetPath(relativePath, installDir, targetKind);
			if(!FileSystem.exists(localPath)) {
				files.push(remotePath);
				processNext();
				return;
			}
			if(FileSystem.isDirectory(localPath)) {
				processNext();
				return;
			}
			checkRemoteFileAgainstLocal(headTag, remotePath, relativePath, localPath, function(needsDownload:Bool) {
				if(needsDownload) {
					files.push(remotePath);
				}
				processNext();
			});
		};
		processNext();
	}

	private static function fallbackToTreeComparison(baseTag:String, headTag:String, includeMod:Bool, callback:Array<String>->Array<String>->Void):Void
	{
		fetchTagFileList(baseTag, includeMod, function(baseFiles:Array<String>) {
			fetchTagFileList(headTag, includeMod, function(headFiles:Array<String>) {
				var files:Array<String> = [];
				var deletions:Array<String> = [];
				var installDir = getInstallDirectory();
				var baseFileList:Array<String> = baseFiles != null ? baseFiles : [];
				var headFileList:Array<String> = headFiles != null ? headFiles : [];
				var fileIndex = 0;
				var processNext:Void->Void;
				processNext = function() {
					if(fileIndex >= headFileList.length) {
						callback(files, deletions);
						return;
					}
					var remotePath:String = headFileList[fileIndex++];
					var targetKind = getActiveInstallTargetKind();
					var relativePath = getRelativePathForInstallTarget(remotePath, targetKind);
					if(relativePath.length == 0) {
						processNext();
						return;
					}
					var localPath = getExpectedInstallTargetPath(relativePath, installDir, targetKind);
					if(!containsString(baseFileList, remotePath) || !FileSystem.exists(localPath) || FileSystem.isDirectory(localPath)) {
						files.push(remotePath);
						processNext();
						return;
					}
					checkRemoteFileAgainstLocal(headTag, remotePath, relativePath, localPath, function(needsDownload:Bool) {
						if(needsDownload) {
							files.push(remotePath);
						}
						processNext();
					});
				};
				processNext();
			});
		});
	}

	private static function resolveRemoteTagNameString(tagName:String, callback:String->Void):Void
	{
		if(tagName == null || tagName.length == 0) {
			callback('');
			return;
		}
		var normalizedTagName = normalizeTag(tagName);
		var tagsUrl = 'https://api.github.com/repos/${REPO}/tags?per_page=100';
		var http = new haxe.Http(tagsUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			try {
				var tags:Array<Dynamic> = Json.parse(data);
				for(entry in tags) {
					var remoteTag:String = entry != null ? Std.string(entry.name) : '';
					if(remoteTag.length > 0) {
						var normalizedRemoteTag = normalizeTag(remoteTag);
						if(normalizedRemoteTag == normalizedTagName || normalizedRemoteTag.indexOf(normalizedTagName) >= 0 || normalizedTagName.indexOf(normalizedRemoteTag) >= 0) {
							callback(remoteTag);
							return;
						}
					}
				}
			} catch(e:Dynamic) {
			}
			callback('');
		};
		http.onError = function(error:String) {
			callback('');
		};
		http.request(false);
	}

	private static function collectLocalInstallFiles(baseDir:String):Array<String>
	{
		var files:Array<String> = [];
		#if sys
		if(baseDir == null || baseDir.length == 0 || !FileSystem.exists(baseDir) || !FileSystem.isDirectory(baseDir)) return files;
		var normalizedBase = StringTools.replace(Path.normalize(baseDir), '\\', '/');
		collectLocalInstallFilesRecursive(normalizedBase, normalizedBase, files);
		#end
		return files;
	}

	private static function collectLocalInstallFilesRecursive(rootDir:String, currentDir:String, output:Array<String>):Void
	{
		#if sys
		for(entry in FileSystem.readDirectory(currentDir)) {
			var fullPath = Path.join([currentDir, entry]);
			var normalizedPath = StringTools.replace(Path.normalize(fullPath), '\\', '/');
			var normalizedCurrent = StringTools.replace(Path.normalize(currentDir), '\\', '/');
			if(FileSystem.isDirectory(fullPath)) {
				if(shouldSkipInstallDirectory(normalizedPath)) continue;
				collectLocalInstallFilesRecursive(rootDir, normalizedPath, output);
			} else {
				var relativePath = normalizedPath.substring(rootDir.length).trim();
				if(relativePath.startsWith('/')) relativePath = relativePath.substring(1);
				if(relativePath.length > 0 && isTrackedInstallPath(relativePath)) {
					output.push(relativePath);
				}
			}
		}
		#end
	}

	private static function shouldSkipInstallDirectory(path:String):Bool
	{
		if(path == null || path.length == 0) return false;
		var normalized = path.toLowerCase();
		return normalized.endsWith('/mods') || normalized.indexOf('/mods/') >= 0 || normalized.endsWith('/update_temp') || normalized.indexOf('/update_temp/') >= 0 || normalized.endsWith('/export') || normalized.indexOf('/export/') >= 0 || normalized.endsWith('/setup') || normalized.indexOf('/setup/') >= 0 || normalized.endsWith('/source') || normalized.indexOf('/source/') >= 0 || normalized.endsWith('/art') || normalized.indexOf('/art/') >= 0 || normalized.endsWith('/flashfiles') || normalized.indexOf('/flashfiles/') >= 0 || normalized.endsWith('/example_mods') || normalized.indexOf('/example_mods/') >= 0;
	}

	private static function isTrackedInstallPath(path:String):Bool
	{
		if(path == null || path.length == 0) return false;
		var normalized = normalizeInstallPath(path).toLowerCase();
		if(normalized.length == 0 || normalized == 'update_post_close.ps1' || normalized == '.update_manifest.txt' || normalized == 'modslist.txt') return false;
		return normalized.startsWith('assets/') || normalized.startsWith('data/') || normalized.startsWith('shared/') || normalized.startsWith('songs/') || normalized.startsWith('weeks/') || normalized.startsWith('images/') || normalized.startsWith('fonts/') || normalized.startsWith('music/') || normalized.startsWith('sounds/') || normalized.startsWith('stages/') || normalized.startsWith('characters/') || normalized.startsWith('videos/') || normalized.startsWith('scripts/') || normalized.startsWith('shaders/');
	}

	private static function shouldTreatAsTextFile(path:String):Bool
	{
		if(path == null || path.length == 0) return false;
		var normalized = path.toLowerCase();
		return normalized.endsWith('.json') || normalized.endsWith('.txt') || normalized.endsWith('.lua') || normalized.endsWith('.hx') || normalized.endsWith('.xml') || normalized.endsWith('.md') || normalized.endsWith('.ini') || normalized.endsWith('.cfg') || normalized.endsWith('.yaml') || normalized.endsWith('.yml') || normalized.endsWith('.toml') || normalized.endsWith('.ps1') || normalized.endsWith('.bat') || normalized.endsWith('.sh') || normalized.endsWith('.properties');
	}

	private static function checkRemoteFileAgainstLocal(tagName:String, remotePath:String, relativePath:String, localPath:String, callback:Bool->Void):Void
	{
		if(localPath == null || localPath.length == 0) {
			callback(true);
			return;
		}
		if(!FileSystem.exists(localPath)) {
			callback(true);
			return;
		}
		if(shouldTreatAsTextFile(relativePath)) {
			fetchRemoteTextContentForTag(tagName, remotePath, function(remoteContent:String) {
				try {
					if(remoteContent == null || remoteContent.length == 0) {
						callback(false);
					} else {
						var currentContent = File.getContent(localPath);
						callback(remoteContent != currentContent);
					}
				} catch(e:Dynamic) {
					callback(false);
				}
			});
			return;
		}
		fetchRemoteFileBytesForTag(tagName, remotePath, function(remoteBytes:Bytes) {
			try {
				if(remoteBytes == null) {
					callback(false);
					return;
				}
				var currentBytes = File.getBytes(localPath);
				callback(!bytesEqual(remoteBytes, currentBytes));
			} catch(e:Dynamic) {
				callback(false);
			}
		});
	}

	private static function fetchRemoteTextContentForTag(tagName:String, remotePath:String, callback:String->Void):Void
	{
		if(tagName == null || tagName.length == 0 || remotePath == null || remotePath.length == 0) {
			callback('');
			return;
		}
		var url = 'https://raw.githubusercontent.com/${REPO}/${tagName}/${remotePath}';
		fetchRemoteTextContent(url, callback);
	}

	private static function fetchRemoteFileBytesForTag(tagName:String, remotePath:String, callback:Bytes->Void):Void
	{
		if(tagName == null || tagName.length == 0 || remotePath == null || remotePath.length == 0) {
			callback(null);
			return;
		}
		var url = 'https://raw.githubusercontent.com/${REPO}/${tagName}/${remotePath}';
		var http = new haxe.Http(url);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onBytes = function(bytes:Bytes) {
			callback(bytes);
		};
		http.onError = function(error:String) {
			callback(null);
		};
		http.request(false);
	}

	private static function fetchRemoteTextContent(url:String, callback:String->Void):Void
	{
		var http = new haxe.Http(url);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			callback(data);
		};
		http.onError = function(error:String) {
			callback('');
		};
		http.request(false);
	}

	private static function bytesEqual(left:Bytes, right:Bytes):Bool
	{
		if(left == null || right == null) return left == right;
		if(left.length != right.length) return false;
		for(i in 0...left.length) {
			if(left.get(i) != right.get(i)) return false;
		}
		return true;
	}

	private static function resolveBaseTagAndCompare(index:Int, baseCandidates:Array<String>, headCandidates:Array<String>, includeMod:Bool, callback:Bool->String->Void):Void
	{
		if(index >= baseCandidates.length) {
			tryCompareTags(0, baseCandidates, headCandidates, includeMod, callback);
			return;
		}

		var baseTag:String = baseCandidates[index++];
		var tagsUrl = 'https://api.github.com/repos/${REPO}/tags?per_page=100';
		var http = new haxe.Http(tagsUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			try {
				var tags:Array<Dynamic> = Json.parse(data);
				var resolvedBaseTag:String = resolveBaseTagFromRemote(baseTag, tags, headCandidates);
				if(resolvedBaseTag != null && resolvedBaseTag.length > 0) {
					trace('Resolved compare base tag "$baseTag" -> "$resolvedBaseTag" for head "${headCandidates[0]}"');
					tryCompareTags(0, [resolvedBaseTag], headCandidates, includeMod, callback);
				} else {
					resolveBaseTagAndCompare(index, baseCandidates, headCandidates, includeMod, callback);
				}
			} catch(e:Dynamic) {
				resolveBaseTagAndCompare(index, baseCandidates, headCandidates, includeMod, callback);
			}
		};
		http.onError = function(error:String) {
			resolveBaseTagAndCompare(index, baseCandidates, headCandidates, includeMod, callback);
		};
		http.request(false);
	}

	private static function resolveBaseTagFromRemote(baseTag:String, remoteTags:Array<Dynamic>, headCandidates:Array<String>):String
	{
		if(baseTag == null || baseTag.length == 0) return '';
		var normalizedBase = normalizeTag(baseTag);
		var headTagNames:Array<String> = [];
		for(headCandidate in headCandidates) {
			var headName = normalizeTag(headCandidate);
			if(headName.length > 0 && !containsString(headTagNames, headName)) {
				headTagNames.push(headName);
			}
		}

		var candidates:Array<String> = buildTagCandidates(baseTag);
		for(candidate in candidates) {
			var normalizedCandidate = normalizeTag(candidate);
			if(normalizedCandidate.length == 0) continue;
			for(entry in remoteTags) {
				var remoteTag:String = Std.string(entry.name);
				var normalizedRemote = normalizeTag(remoteTag);
				if(normalizedRemote.length == 0) continue;
				if(containsString(headTagNames, normalizedRemote)) continue;
				if(normalizedRemote == normalizedCandidate) {
					return remoteTag;
				}
			}
		}

		for(entry in remoteTags) {
			var remoteTag:String = Std.string(entry.name);
			var normalizedRemote = normalizeTag(remoteTag);
			if(normalizedRemote.length == 0) continue;
			if(containsString(headTagNames, normalizedRemote)) continue;
			if(normalizedRemote == normalizedBase || normalizedRemote.startsWith(normalizedBase) || doesTagMatchBase(remoteTag, normalizedBase)) {
				return remoteTag;
			}
		}
		return '';
	}

	private static function normalizeTag(tag:String):String
	{
		if(tag == null) return '';
		var trimmed:String = StringTools.trim(tag);
		if(trimmed.startsWith('v')) {
			trimmed = trimmed.substring(1);
		}
		return trimmed.toLowerCase();
	}

	private static function doesTagMatchBase(remoteTag:String, baseTag:String):Bool
	{
		var normalizedRemote = normalizeTag(remoteTag);
		var normalizedBase = normalizeTag(baseTag);
		if(normalizedRemote == normalizedBase) return true;
		if(normalizedRemote.startsWith(normalizedBase)) return true;
		var basePrefix = getVersionPrefix(normalizedBase);
		if(basePrefix.length > 0 && normalizedRemote.startsWith(basePrefix)) return true;
		return false;
	}

	private static function getVersionPrefix(value:String):String
	{
		if(value == null || value.length == 0) return '';
		var normalized = normalizeTag(value);
		var prefix = '';
		for(i in 0...normalized.length) {
			var ch = normalized.charAt(i);
			if(ch >= '0' && ch <= '9' || ch == '.') {
				prefix += ch;
			} else if(prefix.length > 0) {
				break;
			}
		}
		return prefix;
	}

	private static function buildTagCandidates(tag:String):Array<String>
	{
		var candidates:Array<String> = [];
		if(tag == null || tag.length == 0) return candidates;
		var trimmed:String = StringTools.trim(tag);
		var withoutV:String = trimmed.startsWith('v') ? trimmed.substring(1) : trimmed;
		var withV:String = withoutV.startsWith('v') ? withoutV : 'v' + withoutV;
		addUniqueCandidate(candidates, trimmed);
		addUniqueCandidate(candidates, withoutV);
		addUniqueCandidate(candidates, withV);
		if(trimmed.startsWith('engine-') || trimmed.startsWith('mod-')) {
			var baseName = trimmed.substring(trimmed.indexOf('-') + 1);
			addUniqueCandidate(candidates, baseName);
			addUniqueCandidate(candidates, 'v' + baseName);
		}
		return candidates;
	}

	private static function addUniqueCandidate(candidates:Array<String>, value:String):Void
	{
		if(value == null || value.length == 0) return;
		for(candidate in candidates) {
			if(candidate == value) return;
		}
		candidates.push(value);
	}

	private static function tryCompareTags(index:Int, baseCandidates:Array<String>, headCandidates:Array<String>, includeMod:Bool, callback:Bool->String->Void):Void
	{
		var total = baseCandidates.length * headCandidates.length;
		if(index >= total) {
			finishUpdate(false, 'No changed files could be resolved between the current and target versions.');
			return;
		}

		var baseTag = baseCandidates[Std.int(index / headCandidates.length)];
		var headTag = headCandidates[index % headCandidates.length];
		var compareUrl = 'https://api.github.com/repos/${REPO}/compare/${baseTag}...${headTag}';
		trace('Requesting compare URL: $compareUrl');
		var http = new haxe.Http(compareUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			try {
				var compareData:Dynamic = Json.parse(data);
				var fileEntries:Array<Dynamic> = compareData.files != null ? cast compareData.files : [];
				var compareOperations = collectCompareOperations(compareData, includeMod);
				var shouldUseTreeComparison = compareOperations.files.length > 0 || compareOperations.deletions.length > 0 || fileEntries.length == 0;
				if(shouldUseTreeComparison) {
					compareTagTrees(baseTag, headTag, includeMod, compareOperations.files, compareOperations.deletions, function(files:Array<String>, deletions:Array<String>) {
						if(files.length > 0 || deletions.length > 0) {
							downloadFiles(files, deletions, headTag, callback);
							return;
						}

						var commitShas:Array<String> = collectCommitShas(compareData);
						if(commitShas.length > 0) {
							inspectCommitFiles(commitShas, 0, includeMod, headTag, function(files:Array<String>, deletions:Array<String>) {
								downloadFiles(files, deletions, headTag, callback);
							});
							return;
						}

						tryCompareTags(index + 1, baseCandidates, headCandidates, includeMod, callback);
					});
					return;
				}
			} catch(e:Dynamic) {
			}
			tryCompareTags(index + 1, baseCandidates, headCandidates, includeMod, callback);
		};
		http.onError = function(error:String) {
			tryCompareTags(index + 1, baseCandidates, headCandidates, includeMod, callback);
		};
		http.request(false);
	}

	private static function compareTagTrees(baseTag:String, headTag:String, includeMod:Bool, initialFiles:Array<String>, initialDeletions:Array<String>, onComplete:Array<String>->Array<String>->Void):Void
	{
		fetchTagFileList(baseTag, includeMod, function(baseFiles:Array<String>) {
			fetchTagFileList(headTag, includeMod, function(headFiles:Array<String>) {
				var files:Array<String> = [];
				var deletions:Array<String> = [];
				var normalizedBaseTag = normalizeTag(baseTag);
				var normalizedHeadTag = normalizeTag(headTag);
				if(normalizedBaseTag.length > 0 && normalizedHeadTag.length > 0 && normalizedBaseTag == normalizedHeadTag) {
					trace('Skipping update download: base and head tags are identical ($baseTag -> $headTag).');
					onComplete([], []);
					return;
				}
				var baseFileList:Array<String> = baseFiles != null ? baseFiles : [];
				var headFileList:Array<String> = headFiles != null ? headFiles : [];
				if(fileListsMatch(baseFileList, headFileList)) {
					trace('Skipping update download: file lists are identical for $baseTag -> $headTag.');
					onComplete([], []);
					return;
				}

				for(path in initialFiles) {
					if(path != null && path.length > 0 && !containsString(files, path)) {
						files.push(path);
					}
				}
				for(path in initialDeletions) {
					if(path != null && path.length > 0 && !containsString(deletions, path)) {
						deletions.push(path);
					}
				}

				for(path in headFileList) {
					if(path == null || path.length == 0 || isPathInList(baseFileList, path)) continue;
					if(!containsString(files, path)) {
						files.push(path);
					}
				}

				if(initialDeletions != null) {
					for(path in initialDeletions) {
						if(path != null && path.length > 0 && !containsString(deletions, path)) {
							deletions.push(path);
						}
					}
				}

				onComplete(files, deletions);
			});
		});
	}

	private static function fetchTagFileList(tagName:String, includeMod:Bool, callback:Array<String>->Void):Void
	{
		if(tagName == null || tagName.length == 0) {
			callback([]);
			return;
		}

		var treeUrl = 'https://api.github.com/repos/${REPO}/git/trees/${tagName}?recursive=1';
		var http = new haxe.Http(treeUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			var files:Array<String> = [];
			try {
				var treeData:Dynamic = Json.parse(data);
				if(treeData.tree != null) {
					for(entry in (treeData.tree:Array<Dynamic>)) {
						var entryPath:String = entry != null && entry.path != null ? Std.string(entry.path) : '';
						var entryType:String = entry != null && entry.type != null ? Std.string(entry.type) : '';
						if(entryPath.length == 0 || entryType != 'blob') continue;
						if(shouldIncludePathForUpdate(entryPath, includeMod) && !shouldIgnoreFile(entryPath)) {
							files.push(entryPath);
						}
					}
				}
			} catch(e:Dynamic) {
			}
			if(files.length == 0) {
				resolveRemoteTagName(tagName, callback, includeMod);
			} else {
				callback(files);
			}
		};
		http.onError = function(error:String) {
			resolveRemoteTagName(tagName, callback, includeMod);
		};
		http.request(false);
	}

	private static function resolveRemoteTagName(tagName:String, callback:Array<String>->Void, includeMod:Bool):Void
	{
		if(tagName == null || tagName.length == 0) {
			callback([]);
			return;
		}

		var tagsUrl = 'https://api.github.com/repos/${REPO}/tags?per_page=100';
		var http = new haxe.Http(tagsUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			try {
				var tags:Array<Dynamic> = Json.parse(data);
				for(entry in tags) {
					var remoteTag:String = entry != null ? Std.string(entry.name) : '';
					if(remoteTag.length > 0 && remoteTag.toLowerCase() == tagName.toLowerCase() && remoteTag != tagName) {
						fetchTagFileList(remoteTag, includeMod, callback);
						return;
					}
				}
			} catch(e:Dynamic) {
			}
			callback([]);
		};
		http.onError = function(error:String) {
			callback([]);
		};
		http.request(false);
	}

	private static function shouldIncludePathForUpdate(filePath:String, includeMod:Bool):Bool
	{
		if(filePath == null || filePath.length == 0) return false;
		if(shouldIgnoreFile(filePath)) return false;
		if(includeMod) return true;
		return !filePath.startsWith('mods/');
	}

	private static function isPathInList(paths:Array<String>, target:String):Bool
	{
		if(target == null || target.length == 0) return false;
		for(path in paths) {
			if(path == target) return true;
		}
		return false;
	}

	private static function collectCompareOperations(compareData:Dynamic, includeMod:Bool):{files:Array<String>, deletions:Array<String>}
	{
		var files:Array<String> = [];
		var deletions:Array<String> = [];
		if(compareData.files != null) {
			for(entry in (compareData.files:Array<Dynamic>)) {
				var filePath:String = Std.string(entry.filename);
				var previousPath:String = entry.previous_filename != null ? Std.string(entry.previous_filename) : '';
				var isRemoval = entry.status == 'removed' || entry.status == 'renamed' || entry.status == 'deleted';
				if(isRemoval) {
					var deletionTarget = previousPath.length > 0 ? previousPath : filePath;
					if(deletionTarget.length > 0 && !shouldIgnoreFile(deletionTarget) && (includeMod || !deletionTarget.startsWith('mods/'))) {
						deletions.push(deletionTarget);
					}
					if(filePath.length > 0 && !shouldIgnoreFile(filePath) && entry.status != 'removed' && entry.status != 'deleted') {
						files.push(filePath);
					}
				} else if((includeMod || !filePath.startsWith('mods/')) && !shouldIgnoreFile(filePath)) {
					files.push(filePath);
				}
			}
		}
		return {files: files, deletions: deletions};
	}

	private static function collectCommitShas(compareData:Dynamic):Array<String>
	{
		var shas:Array<String> = [];
		if(compareData.commits != null) {
			for(entry in (compareData.commits:Array<Dynamic>)) {
				var sha:String = Std.string(entry.sha);
				if(sha.length > 0 && !containsString(shas, sha)) {
					shas.push(sha);
				}
			}
		}
		return shas;
	}

	private static function inspectCommitFiles(commitShas:Array<String>, index:Int, includeMod:Bool, headTag:String, callback:Array<String>->Array<String>->Void):Void
	{
		if(index >= commitShas.length) {
			finishUpdate(false, 'No changed files could be resolved from the commit history.');
			return;
		}

		var sha:String = commitShas[index++];
		var commitUrl = 'https://api.github.com/repos/${REPO}/commits/${sha}';
		var http = new haxe.Http(commitUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			try {
				var commitData:Dynamic = Json.parse(data);
				var compareOperations = {files: [], deletions: []};
				if(commitData.files != null) {
					for(entry in (commitData.files:Array<Dynamic>)) {
						var filePath:String = Std.string(entry.filename);
						var previousPath:String = entry.previous_filename != null ? Std.string(entry.previous_filename) : '';
						var isRemoval = entry.status == 'removed' || entry.status == 'renamed' || entry.status == 'deleted';
						if(isRemoval) {
							var deletionTarget = previousPath.length > 0 ? previousPath : filePath;
							if(deletionTarget.length > 0 && !shouldIgnoreFile(deletionTarget) && (includeMod || !deletionTarget.startsWith('mods/'))) {
								compareOperations.deletions.push(deletionTarget);
							}
							if(filePath.length > 0 && !shouldIgnoreFile(filePath) && entry.status != 'removed' && entry.status != 'deleted') {
								compareOperations.files.push(filePath);
							}
						} else if((includeMod || !filePath.startsWith('mods/')) && !shouldIgnoreFile(filePath)) {
							compareOperations.files.push(filePath);
						}
					}
				}
				if(compareOperations.files.length > 0 || compareOperations.deletions.length > 0) {
					processCompareOperations(compareOperations.files, compareOperations.deletions, headTag, callback);
				} else {
					inspectCommitFiles(commitShas, index, includeMod, headTag, callback);
				}
			} catch(e:Dynamic) {
				inspectCommitFiles(commitShas, index, includeMod, headTag, callback);
			}
		};
		http.onError = function(error:String) {
			inspectCommitFiles(commitShas, index, includeMod, headTag, callback);
		};
		http.request(false);
	}

	private static function containsString(values:Array<String>, value:String):Bool
	{
		for(item in values) {
			if(item == value) return true;
		}
		return false;
	}

	private static function fileListsMatch(left:Array<String>, right:Array<String>):Bool
	{
		if(left == null || right == null) return left == right;
		if(left.length != right.length) return false;
		for(path in left) {
			if(!containsString(right, path)) return false;
		}
		return true;
	}
	
	/**
	 * Check if a file should be ignored during updates
	 */
	private static function shouldIgnoreFile(filePath:String):Bool
	{
		var ignoredPatterns = [
			'example_mods/',
			'export/',
			'art/',
			'buildScripts/',
			'setup/',
			'source/',
			'flashFiles/',
			'.git/',
			'.gitattributes',
			'.gitignore',
			'README.md',
			'LICENSE',
			'Project.xml',
			'hxformat.json',
			'list.txt',
			'alsoft.txt',
			'gitVersion.txt',
			'PringleKitten NOTE FOR COMPILING ERRORS!!!.txt'
		];
		
		for(pattern in ignoredPatterns) {
			if(filePath.startsWith(pattern)) {
				return true;
			}
		}
		
		return false;
	}
	
	private static function downloadFileToPath(url:String, destPath:String):Bool
	{
		#if sys
		try {
			var escapedUrl = escapePowerShellString(url);
			var escapedDest = escapePowerShellString(destPath);
			var command = '$$wc = New-Object System.Net.WebClient; $$wc.Headers.Add("User-Agent", "FNF-IFE-UpdateChecker"); $$wc.DownloadFile(' + escapedUrl + ', ' + escapedDest + ');';
			var process = new sys.io.Process('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', command]);
			var exitCode = process.exitCode();
			var stdout = process.stdout.readAll().toString();
			var stderr = process.stderr.readAll().toString();
			process.close();
			if(exitCode != 0) {
				trace('PowerShell download failed for $url: $stderr');
			}
			return exitCode == 0;
		} catch(e:Dynamic) {
			trace('Error downloading $url: $e');
			return false;
		}
		#else
		return false;
		#end
	}

	private static function escapePowerShellString(value:String):String
	{
		if(value == null) return "''";
		var escaped = StringTools.replace(value, "'", "''");
		return "'" + escaped + "'";
	}

	/**
	 * Download changed files from GitHub raw content
	 */
	private static function downloadFiles(files:Array<String>, removedFiles:Array<String>, tagName:String, callback:Bool->String->Void):Void
	{
		if(files.length == 0 && (removedFiles == null || removedFiles.length == 0)) {
			finishUpdate(false, 'No files to update');
			return;
		}
		
		#if sys
		var installDir = getInstallDirectory();
		var targetKind = getActiveInstallTargetKind();
		var downloadDir = targetKind == 'mod'
			? Path.join([installDir, 'mods', 'update_temp'])
			: Path.join([installDir, 'assets', 'update_temp']);
		try {
			var targetRootDir = targetKind == 'mod' ? Path.join([installDir, 'mods']) : Path.join([installDir, 'assets']);
			if(!FileSystem.exists(targetRootDir)) {
				FileSystem.createDirectory(targetRootDir);
			}
			if(FileSystem.exists(downloadDir)) {
				deleteDirectory(downloadDir);
			}
			if(!FileSystem.exists(downloadDir)) {
				FileSystem.createDirectory(downloadDir);
			}
			
			var failedFiles:Array<String> = [];
			var downloadedCount = 0;
			var index:Int = 0;
			setProgress('Downloading ${getActiveUpdateKindLabel()} files', 0, files.length);
			
			if(removedFiles != null && removedFiles.length > 0) {
				var manifestLines:Array<String> = [];
				for(removedPath in removedFiles) {
					var relativePath = getRelativePathForInstallTarget(removedPath, getActiveInstallTargetKind());
					if(relativePath.length > 0 && !containsString(manifestLines, relativePath)) {
						manifestLines.push(relativePath);
					}
				}
				if(manifestLines.length > 0) {
					var manifestPath = Path.join([downloadDir, '.update_manifest.txt']);
					File.saveContent(manifestPath, manifestLines.join('\n'));
				}
			}
			
			var downloadNext:Void->Void;
			downloadNext = function() {
				if(index >= files.length) {
					if(failedFiles.length > 0) {
						finishUpdate(false, 'Failed to download: ${failedFiles.join(", ")}');
					} else {
						preparePendingInstall(downloadDir, callback);
					}
					return;
				}
				if(index >= files.length) {
					preparePendingInstall(downloadDir, callback);
					return;
				}
				var file = files[index++];
				var fileUrl = 'https://raw.githubusercontent.com/${REPO}/${tagName}/$file';
				var relativePath = getRelativePathForInstallTarget(file, getActiveInstallTargetKind());
				var destPath = getModStagedPath(downloadDir, relativePath);
				var dir = Path.directory(destPath);
				if(!FileSystem.exists(dir)) {
					FileSystem.createDirectory(dir);
				}
				if(downloadFileToPath(fileUrl, destPath)) {
					downloadedCount++;
					setProgress('Downloading ${getActiveUpdateKindLabel()} files', downloadedCount, files.length);
				} else {
					failedFiles.push('$file (download failed)');
				}
				downloadNext();
			};
			downloadNext();
		} catch(e:Dynamic) {
			finishUpdate(false, 'Error preparing update: $e');
		}
		#end
	}

	private static function preparePendingInstall(tempDir:String, callback:Bool->String->Void):Void
	{
		#if sys
		_pendingInstallDir = tempDir;
		if(_includeModInUpdate) {
			_modInstallDir = tempDir;
			_engineInstallDir = _engineInstallDir.length > 0 ? _engineInstallDir : '';
			pendingModUpdatePrompt = false;
		} else {
			_engineInstallDir = tempDir;
			_modInstallDir = _modInstallDir.length > 0 ? _modInstallDir : '';
			pendingModUpdatePrompt = engineUpdateAvailable && modUpdateAvailable;
		}
		activeUpdateType = _includeModInUpdate ? 'mod' : 'engine';
		updateThreadFinished = false;
		updateThreadSuccessful = true;
		updateThreadMessage = shouldAutoApplyPendingUpdate() ? 'Update downloaded. Applying in place...' : 'Update downloaded. Click Restart to apply and relaunch.';
		pendingUpdate = true;
		updateReadyToApply = true;
		postCloseInstallPending = false;
		_downloadInProgress = false;
		updateThreadActive = false;
		progressLabel = 'Update ready to apply';
		progressCurrent = 1;
		progressTotal = 1;
		progressValue = 1;
		#end
	}

	public static function applyPendingUpdate():Void
	{
		#if sys
		if((_engineInstallDir == null || _engineInstallDir.length == 0) && (_modInstallDir == null || _modInstallDir.length == 0) && (_pendingInstallDir == null || _pendingInstallDir.length == 0)) return;
		setProgress('Applying ${getActiveUpdateKindLabel()} update', 0, 1);
		try {
			createPostCloseInstallScript();
			updateReadyToApply = false;
			postCloseInstallPending = true;
			exitForPostCloseInstall();
		} catch(e:Dynamic) {
			trace('Failed to start post-close installer: $e');
		}
		#end
	}
	
	private static function createPostCloseInstallScript():Void
	{
		#if sys
		var installDir = getInstallDirectory();
		var scriptPath = Path.join([installDir, 'update_post_close.ps1']);
		var exePath = getExpectedGameExecutablePath();
		var stages:Array<{sourceRoot:String, targetRoot:String, includeMod:Bool}> = [];
		if(_engineInstallDir != null && _engineInstallDir.length > 0) {
			stages.push({sourceRoot: _engineInstallDir, targetRoot: installDir, includeMod: false});
		}
		if(_modInstallDir != null && _modInstallDir.length > 0) {
			var modTargetRoot = getExistingModInstallRoot(installDir, _modInstallDir);
			if(modTargetRoot == null || modTargetRoot.length == 0) {
				modTargetRoot = Path.join([installDir, 'mods']);
			}
			stages.push({sourceRoot: _modInstallDir, targetRoot: modTargetRoot, includeMod: true});
		}
		if(stages.length == 0 && _pendingInstallDir != null && _pendingInstallDir.length > 0) {
			stages.push({sourceRoot: _pendingInstallDir, targetRoot: installDir, includeMod: false});
		}
		if(stages.length == 0) return;
		for(stage in stages) {
			applyManifestDeletions(stage.sourceRoot, stage.targetRoot, stage.includeMod);
		}
		var scriptContent = 'param([string]$$GameExe)\r\n' +
			'$$ErrorActionPreference = "Stop"\r\n' +
			'$$scriptDir = Split-Path -Parent $$MyInvocation.MyCommand.Path\r\n' +
			'$$gameName = [System.IO.Path]::GetFileNameWithoutExtension($$GameExe)\r\n' +
			'while ($$true) {\r\n' +
			'  $$running = @(Get-Process -Name $$gameName -ErrorAction SilentlyContinue)\r\n' +
			'  if ($$running.Count -eq 0) { break }\r\n' +
			'  Stop-Process -Name $$gameName -Force -ErrorAction SilentlyContinue\r\n' +
			'  Start-Sleep -Seconds 2\r\n' +
			'}\r\n';
		for(stage in stages) {
			scriptContent += buildInstallStageScript(stage.sourceRoot, stage.targetRoot, stage.includeMod);
		}
		scriptContent +=
			'if (Test-Path $$GameExe) {\r\n' +
			'  Push-Location $$scriptDir\r\n' +
			'  & $$GameExe\r\n' +
			'  Pop-Location\r\n' +
			'}\r\n' +
			'Remove-Item -Path $$MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue\r\n';
		File.saveContent(scriptPath, scriptContent);
		if(exePath != null && exePath.length > 0) {
			var windowsScriptPath = StringTools.replace(scriptPath, '/', '\\');
			var windowsExePath = StringTools.replace(exePath, '/', '\\');
			trace('Launching detached post-close installer: $windowsScriptPath');
			Sys.command('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-WindowStyle', 'Hidden', '-NonInteractive', '-File', windowsScriptPath, windowsExePath]);
		}
		#end
	}
	
	private static function applyManifestDeletions(sourceRoot:String, targetRoot:String, includeMod:Bool):Void
	{
		#if sys
		if(sourceRoot == null || sourceRoot.length == 0 || targetRoot == null || targetRoot.length == 0) return;
		var manifestPath = Path.join([sourceRoot, '.update_manifest.txt']);
		if(!FileSystem.exists(manifestPath)) return;
		try {
			var manifestContent = File.getContent(manifestPath);
			var lines:Array<String> = manifestContent != null ? manifestContent.split('\n') : [];
			for(line in lines) {
				var trimmed = StringTools.trim(line);
				if(trimmed.length == 0) continue;
				var relativePath = normalizeInstallPath(trimmed);
				if(relativePath.length == 0) continue;
				var targetPath = Path.join([targetRoot, relativePath]);
				trace('Applying staged deletion: $targetPath');
				if(FileSystem.exists(targetPath)) {
					if(FileSystem.isDirectory(targetPath)) {
						deleteDirectory(targetPath);
					} else {
						FileSystem.deleteFile(targetPath);
					}
				}
			}
		} catch(e:Dynamic) {
			trace('Failed to apply manifest deletions from $sourceRoot: $e');
		}
		#end
	}

	private static function buildInstallStageScript(sourceRoot:String, targetRoot:String, includeMod:Bool):String
	{
		var normalizedSourceRoot = StringTools.replace(sourceRoot, '/', '\\');
		var normalizedTargetRoot = StringTools.replace(targetRoot, '/', '\\');
		var shouldStripAssetsPrefix = !includeMod;
		var modsPrefixAdjustment = '    $$relPath = $$relPath -replace "^(?:mods[\\/])?(?:IFEModR2\\.0[\\/])?", ""\r\n';
		var assetPathAdjustment = shouldStripAssetsPrefix ?
			'    if ($$relPath -like "assets/*") { $$relPath = $$relPath.Substring(7) }\r\n' +
			'    if ($$relPath -eq "assets") { $$relPath = "" }\r\n' :
			'';
		return 'if (Test-Path "' + normalizedSourceRoot + '") {\r\n' +
			'  $$sourceRoot = [System.IO.Path]::GetFullPath("' + normalizedSourceRoot + '")\r\n' +
			'  $$targetRoot = [System.IO.Path]::GetFullPath("' + normalizedTargetRoot + '")\r\n' +
			'  $$manifestPath = Join-Path $$sourceRoot ".update_manifest.txt"\r\n' +
			'  $$deletePaths = @()\r\n' +
			'  if (Test-Path $$manifestPath) {\r\n' +
			'    $$deletePaths = Get-Content -LiteralPath $$manifestPath | Where-Object { $$_-and $$_.Trim().Length -gt 0 }\r\n' +
			'    Remove-Item -LiteralPath $$manifestPath -Force -ErrorAction SilentlyContinue\r\n' +
			'  }\r\n' +
			'  foreach ($$relPath in $$deletePaths) {\r\n' +
			'    $$relPath = $$relPath.TrimStart([char[]]@("\\", "/"))\r\n' +
			modsPrefixAdjustment +
			assetPathAdjustment +
			'    if ($$relPath -eq "") { continue }\r\n' +
			'    $$targetPath = Join-Path $$targetRoot $$relPath\r\n' +
			'    Write-Host "[UpdateManager] delete: $$targetPath"\r\n' +
			'    if (Test-Path $$targetPath) {\r\n' +
			'      if (Test-Path $$targetPath -PathType Container) { Remove-Item -LiteralPath $$targetPath -Recurse -Force -ErrorAction SilentlyContinue } else { Remove-Item -LiteralPath $$targetPath -Force -ErrorAction SilentlyContinue }\r\n' +
			'    }\r\n' +
			'  }\r\n' +
			'  if (-not (Test-Path $$targetRoot)) { New-Item -ItemType Directory -Path $$targetRoot -Force | Out-Null }\r\n' +
			'  Get-ChildItem -LiteralPath $$sourceRoot -Recurse -Force | ForEach-Object {\r\n' +
			'    $$relPath = $$_.FullName.Substring($$sourceRoot.Length).TrimStart([char[]]@("\\", "/"))\r\n' +
			'    if ($$relPath -eq "") { return }\r\n' +
			'    if ($$_.Name -eq ".update_manifest.txt") { return }\r\n' +
			assetPathAdjustment +
			modsPrefixAdjustment +
			'    $$relPath = $$relPath.TrimStart([char[]]@("\\", "/"))\r\n' +
			'    $$targetPath = if ($$relPath) { Join-Path $$targetRoot $$relPath } else { $$targetRoot }\r\n' +
			'    $$targetParent = Split-Path -Parent $$targetPath\r\n' +
			'    if ($$targetParent -and -not (Test-Path $$targetParent)) { New-Item -ItemType Directory -Path $$targetParent -Force | Out-Null }\r\n' +
			'    $$targetFullPath = [System.IO.Path]::GetFullPath($$targetPath)\r\n' +
			'    $$sourceFullPath = [System.IO.Path]::GetFullPath($$_.FullName)\r\n' +
			'    if ($$targetFullPath -eq $$sourceFullPath) { return }\r\n' +
			'    Write-Host "[UpdateManager] copy: $$targetPath"\r\n' +
			'    if ($$_.PSIsContainer) {\r\n' +
			'      if (Test-Path $$targetPath -PathType Leaf) { Remove-Item -LiteralPath $$targetPath -Force -ErrorAction SilentlyContinue }\r\n' +
			'      if (-not (Test-Path $$targetPath)) { New-Item -ItemType Directory -Path $$targetPath -Force | Out-Null }\r\n' +
			'    } else {\r\n' +
			'      if (Test-Path $$targetPath -PathType Container) { Remove-Item -LiteralPath $$targetPath -Recurse -Force -ErrorAction SilentlyContinue }\r\n' +
			'      Copy-Item -LiteralPath $$_.FullName -Destination $$targetPath -Force\r\n' +
			'    }\r\n' +
			'  }\r\n' +
			'  Get-ChildItem -LiteralPath $$targetRoot -Directory -Recurse -Force | Sort-Object FullName -Descending | ForEach-Object { if ((Get-ChildItem -LiteralPath $$_.FullName -Force | Measure-Object).Count -eq 0) { Remove-Item -LiteralPath $$_.FullName -Force -ErrorAction SilentlyContinue } }\r\n' +
			'  Remove-Item -Path "' + normalizedSourceRoot + '" -Recurse -Force -ErrorAction SilentlyContinue\r\n' +
			'}\r\n';
	}
	
	public static function exitForPostCloseInstall():Void
	{
		#if cpp
		Sys.exit(0);
		#end
	}
	
	/**
	 * Recursively copy directory contents
	 */
	private static function getInstallDirectory():String
	{
		#if sys
		if(_cachedInstallDirectory != null && _cachedInstallDirectory.length > 0) return _cachedInstallDirectory;
		var exePath = Sys.programPath();
		if(exePath != null && exePath.length > 0) {
			var exeDir = Path.directory(exePath);
			if(exeDir != null && exeDir.length > 0) {
				var normalizedDir = StringTools.replace(Path.normalize(exeDir), '\\', '/');
				var dirName = normalizedDir.lastIndexOf('/') >= 0 ? normalizedDir.substring(normalizedDir.lastIndexOf('/') + 1) : normalizedDir;
				if(dirName.toLowerCase() == 'mods') {
					var parentDir = Path.directory(exeDir);
					if(parentDir != null && parentDir.length > 0) {
						_cachedInstallDirectory = parentDir;
						return _cachedInstallDirectory;
					}
				}
				_cachedInstallDirectory = exeDir;
				return _cachedInstallDirectory;
			}
		}
		_cachedInstallDirectory = Sys.getCwd();
		return _cachedInstallDirectory;
		#else
		return '.';
		#end
	}

	private static function getExpectedGameExecutablePath():String
	{
		#if sys
		if(_cachedGameExecutablePath != null && _cachedGameExecutablePath.length > 0) return _cachedGameExecutablePath;
		var exePath = Sys.programPath();
		if(exePath != null && exePath.length > 0) {
			var installDir = getInstallDirectory();
			if(installDir != null && installDir.length > 0) {
				var exeName = exePath.indexOf('/') >= 0 ? exePath.substring(exePath.lastIndexOf('/') + 1) : exePath;
				var candidatePath = Path.join([installDir, exeName]);
				if(FileSystem.exists(candidatePath) && !FileSystem.isDirectory(candidatePath)) {
					_cachedGameExecutablePath = candidatePath;
					return _cachedGameExecutablePath;
				}
			}
		}
		_cachedGameExecutablePath = exePath;
		return _cachedGameExecutablePath;
		#else
		return '';
		#end
	}

	private static function copyDirectory(src:String, dst:String):Void
	{
		#if sys
		for(file in FileSystem.readDirectory(src)) {
			var srcPath = haxe.io.Path.join([src, file]);
			var dstPath = haxe.io.Path.join([dst, file]);
			
			if(FileSystem.isDirectory(srcPath)) {
				if(!FileSystem.exists(dstPath)) {
					FileSystem.createDirectory(dstPath);
				}
				copyDirectory(srcPath, dstPath);
			} else {
				try {
					File.copy(srcPath, dstPath);
				} catch(e:Dynamic) {
					throw 'Unable to apply file $srcPath to $dstPath: $e';
				}
			}
		}
		#end
	}

	private static function getActiveInstallTargetKind():String
	{
		return _includeModInUpdate ? 'mod' : 'engine';
	}

	private static function getRelativePathForInstallTarget(filePath:String, targetKind:String = null):String
	{
		var normalized = normalizeInstallPath(filePath);
		if(normalized.length == 0) return '';
		var effectiveTargetKind = targetKind != null && targetKind.length > 0 ? targetKind : getActiveInstallTargetKind();
		var parts = normalized.split('/');

		if(effectiveTargetKind == 'engine') {
			if(parts.length >= 2 && parts[0] == 'mods') {
				return '';
			}
			if(parts.length > 1 && parts[0] == 'assets') {
				return parts.slice(1).join('/');
			}
			return normalized;
		}

		if(parts.length >= 3 && parts[0] == 'mods' && isLikelyModRootFolderName(parts[1])) {
			return parts.slice(2).join('/');
		}

		if(parts.length >= 2 && parts[0] == 'mods') {
			return parts.length > 1 ? parts[1] : '';
		}

		if(parts.length >= 2 && isLikelyModRootFolderName(parts[0])) {
			return parts.slice(1).join('/');
		}

		return normalized;
	}

	private static function getFirstPathSegment(path:String):String
	{
		if(path == null || path.length == 0) return '';
		var normalized = normalizeInstallPath(path);
		var parts = normalized.split('/');
		if(parts.length == 0) return '';
		return parts[0];
	}

	private static function isLikelyModRootFolderName(segment:String):Bool
	{
		if(segment == null || segment.length == 0) return false;
		var lower = segment.toLowerCase();
		return lower.indexOf('mod') >= 0 || lower.indexOf('favorite') >= 0 || lower.indexOf('internet') >= 0 || lower.indexOf('ife') >= 0;
	}

	private static function getActiveUpdateKindLabel():String
	{
		return activeUpdateType == 'mod' ? 'mod' : 'engine';
	}

	public static function getUpdateTitleText():String
	{
		return activeUpdateType == 'mod' ? 'Updating mod...' : 'Updating engine...';
	}

	private static function getModStagedPath(downloadDir:String, relativePath:String):String
	{
		#if sys
		var normalized = getRelativePathForInstallTarget(relativePath, getActiveInstallTargetKind());
		if(normalized.length > 0) {
			return Path.join([downloadDir, normalized]);
		}
		return Path.join([downloadDir, 'root']);
		#else
		return Path.join([downloadDir, normalized]);
		#end
	}

	private static function getPostCloseInstallPaths(tempDir:String, installDir:String):{sourceRoot:String, targetRoot:String}
	{
		var sourceRoot = tempDir != null ? tempDir : '';
		var targetRoot = installDir != null ? installDir : '';
		#if sys
		if(sourceRoot.length > 0 && installDir != null && installDir.length > 0) {
			if(_includeModInUpdate) {
				targetRoot = Path.join([installDir, 'mods']);
			} else {
				// Engine updates install into the game directory that contains the executable.
				targetRoot = installDir;
			}
		}
		#end
		return {sourceRoot: sourceRoot, targetRoot: targetRoot};
	}

	private static function getExpectedInstallTargetPath(relativePath:String, installDir:String, targetKind:String = null):String
	{
		if(relativePath == null || relativePath.length == 0 || installDir == null || installDir.length == 0) return '';
		var effectiveTargetKind = targetKind != null && targetKind.length > 0 ? targetKind : getActiveInstallTargetKind();
		if(effectiveTargetKind == 'mod') {
			var existingModRoot = getExistingModInstallRoot(installDir);
			if(existingModRoot != null && existingModRoot.length > 0) {
				return Path.join([existingModRoot, relativePath]);
			}
		}
		var targetRoot = effectiveTargetKind == 'mod' ? Path.join([installDir, 'mods']) : installDir;
		return Path.join([targetRoot, relativePath]);
	}

	private static function getExistingModInstallRoot(installDir:String, ?excludeDir:String):String
	{
		#if sys
		if(installDir == null || installDir.length == 0) return '';
		var modsRoot = Path.join([installDir, 'mods']);
		if(FileSystem.exists(modsRoot) && FileSystem.isDirectory(modsRoot)) {
			var candidate = getModInstallCandidateRoot(modsRoot, excludeDir);
			if(candidate.length > 0) return candidate;
		}
		#end
		return '';
	}

	private static function getStagedModRoot(baseDir:String):String
	{
		#if sys
		if(baseDir == null || baseDir.length == 0 || !FileSystem.exists(baseDir) || !FileSystem.isDirectory(baseDir)) return '';
		if(isLikelyModDirectory(baseDir)) return baseDir;
		var directModFolder = getTargetModFolderName(baseDir);
		if(directModFolder.length > 0) {
			var candidate = Path.join([baseDir, directModFolder]);
			if(FileSystem.exists(candidate) && FileSystem.isDirectory(candidate)) {
				return candidate;
			}
		}
		var nestedModsRoot = Path.join([baseDir, 'mods']);
		if(FileSystem.exists(nestedModsRoot) && FileSystem.isDirectory(nestedModsRoot)) {
			var nestedModFolder = getTargetModFolderName(nestedModsRoot);
			if(nestedModFolder.length > 0) {
				var nestedCandidate = Path.join([nestedModsRoot, nestedModFolder]);
				if(FileSystem.exists(nestedCandidate) && FileSystem.isDirectory(nestedCandidate)) {
					return nestedCandidate;
				}
			}
		}
		#end
		return '';
	}

	private static function getModInstallCandidateRoot(baseDir:String, ?excludeDir:String):String
	{
		#if sys
		if(baseDir == null || baseDir.length == 0) return '';
		if(isLikelyModDirectory(baseDir)) {
			return baseDir;
		}
		if(FileSystem.exists(baseDir) && FileSystem.isDirectory(baseDir)) {
			var bestCandidate = '';
			var bestScore = -1;
			for(entry in FileSystem.readDirectory(baseDir)) {
				var candidate = Path.join([baseDir, entry]);
				if(FileSystem.isDirectory(candidate)) {
					if(shouldIgnoreModCandidate(candidate, excludeDir)) continue;
					var score = getModCandidateScore(candidate);
					if(score > bestScore) {
						bestCandidate = candidate;
						bestScore = score;
					}
				}
			}
			if(bestCandidate.length > 0) return bestCandidate;
		}
		var nestedModsRoot = Path.join([baseDir, 'mods']);
		if(FileSystem.exists(nestedModsRoot) && FileSystem.isDirectory(nestedModsRoot)) {
			for(entry in FileSystem.readDirectory(nestedModsRoot)) {
				var candidate = Path.join([nestedModsRoot, entry]);
				if(FileSystem.isDirectory(candidate)) {
					if(shouldIgnoreModCandidate(candidate, excludeDir)) continue;
					if(isLikelyModDirectory(candidate)) {
						return candidate;
					}
				}
			}
		}
		#end
		return '';
	}

	private static function shouldIgnoreModCandidate(candidate:String, excludeDir:String):Bool
	{
		#if sys
		if(candidate == null || candidate.length == 0) return false;
		var normalizedCandidate = StringTools.replace(Path.normalize(candidate), '\\', '/');
		var normalizedExclude = excludeDir != null ? StringTools.replace(Path.normalize(excludeDir), '\\', '/') : '';
		if(normalizedExclude.length > 0) {
			if(normalizedCandidate == normalizedExclude || normalizedCandidate == normalizedExclude + '/' || normalizedCandidate.startsWith(normalizedExclude + '/')) {
				return true;
			}
		}
		var lowerCandidate = normalizedCandidate.toLowerCase();
		return lowerCandidate.endsWith('/update_temp') || lowerCandidate.indexOf('/update_temp/') >= 0 || lowerCandidate.indexOf('/update_temp') >= 0;
		#else
		return false;
		#end
	}

	private static function getModCandidateScore(dir:String):Int
	{
		#if sys
		if(dir == null || dir.length == 0 || !FileSystem.exists(dir) || !FileSystem.isDirectory(dir)) return 0;
		var score = 0;
		if(FileSystem.exists(Path.join([dir, 'pack.json']))) score += 100;
		for(entry in FileSystem.readDirectory(dir)) {
			var lower = entry.toLowerCase();
			if(lower == 'characters' || lower == 'data' || lower == 'images' || lower == 'scripts' || lower == 'shaders' || lower == 'weeks') {
				score += 20;
			}
		}
		return score;
		#else
		return 0;
		#end
	}

	private static function isLikelyModDirectory(dir:String):Bool
	{
		#if sys
		if(dir == null || dir.length == 0 || !FileSystem.exists(dir) || !FileSystem.isDirectory(dir)) return false;
		if(FileSystem.exists(Path.join([dir, 'pack.json']))) return true;
		var knownEntries = ['characters', 'data', 'images', 'scripts', 'shaders', 'weeks'];
		for(entry in FileSystem.readDirectory(dir)) {
			var lower = entry.toLowerCase();
			for(known in knownEntries) {
				if(lower == known) return true;
			}
		}
		#end
		return false;
	}

	private static function getTargetModFolderName(tempDir:String):String
	{
		#if sys
		if(tempDir == null || tempDir.length == 0) return '';
		if(isLikelyModDirectory(tempDir)) {
			return Path.withoutDirectory(Path.normalize(tempDir));
		}
		if(FileSystem.exists(tempDir) && FileSystem.isDirectory(tempDir)) {
			for(entry in FileSystem.readDirectory(tempDir)) {
				var candidate = Path.join([tempDir, entry]);
				if(FileSystem.isDirectory(candidate)) {
					if(isLikelyModDirectory(candidate)) {
						return entry;
					}
				}
			}
		}
		var modsRoot = Path.join([tempDir, 'mods']);
		if(FileSystem.exists(modsRoot) && FileSystem.isDirectory(modsRoot)) {
			for(entry in FileSystem.readDirectory(modsRoot)) {
				var candidate = Path.join([modsRoot, entry]);
				if(FileSystem.isDirectory(candidate)) {
					if(isLikelyModDirectory(candidate)) {
						return entry;
					}
				}
			}
		}
		#end
		return '';
	}

	private static function forceDisableModInList(modFolder:String):Void
	{
		#if sys
		if(modFolder == null || modFolder.length == 0) return;
		var modsListPath = Path.join([getInstallDirectory(), 'modsList.txt']);
		if(!FileSystem.exists(modsListPath)) return;
		try {
			var content = File.getContent(modsListPath);
			var lines:Array<String> = [];
			var changed = false;
			for(line in content.split('\n')) {
				var trimmed = StringTools.trim(line);
				if(trimmed.length == 0) {
					lines.push(line);
					continue;
				}
				var parts = trimmed.split('|');
				if(parts.length > 0 && parts[0] == modFolder) {
					lines.push(parts[0] + '|0');
					changed = true;
				} else {
					lines.push(line);
				}
			}
			if(!changed) {
				lines.push(modFolder + '|0');
			}
			File.saveContent(modsListPath, lines.join('\n'));
			Mods.updatedOnState = false;
			Mods.loadTopMod();
		} catch(e:Dynamic) {
			trace('Failed to disable mod $modFolder before update: $e');
		}
		#end
	}

	private static function forceEnableModInList(modFolder:String):Void
	{
		#if sys
		if(modFolder == null || modFolder.length == 0) return;
		var modsListPath = Path.join([getInstallDirectory(), 'modsList.txt']);
		if(!FileSystem.exists(modsListPath)) return;
		try {
			var content = File.getContent(modsListPath);
			var lines:Array<String> = [];
			var changed = false;
			for(line in content.split('\n')) {
				var trimmed = StringTools.trim(line);
				if(trimmed.length == 0) {
					lines.push(line);
					continue;
				}
				var parts = trimmed.split('|');
				if(parts.length > 0 && parts[0] == modFolder) {
					lines.push(parts[0] + '|1');
					changed = true;
				} else {
					lines.push(line);
				}
			}
			if(changed) {
				File.saveContent(modsListPath, lines.join('\n'));
			}
			Mods.updatedOnState = false;
			Mods.loadTopMod();
		} catch(e:Dynamic) {
			trace('Failed to re-enable mod $modFolder after update: $e');
		}
		#end
	}

	public static function shouldAutoApplyPendingUpdate():Bool
	{
		// Keep mod updates on the same restart-and-apply path as engine updates.
		return false;
	}

	private static function applyPendingInstallInPlace(tempDir:String):Void
	{
		#if sys
		var installDir = getInstallDirectory();
		var installTargets = getPostCloseInstallPaths(tempDir, installDir);
		if(installTargets.sourceRoot == null || installTargets.sourceRoot.length == 0 || installTargets.targetRoot == null || installTargets.targetRoot.length == 0) return;
		if(!FileSystem.exists(installTargets.sourceRoot) || !FileSystem.isDirectory(installTargets.sourceRoot)) return;
		var targetModFolder = getTargetModFolderName(tempDir);
		if(targetModFolder.length > 0) {
			forceDisableModInList(targetModFolder);
		}
		setProgress('Deleting old files', 0, 1);
		if(!FileSystem.exists(installTargets.targetRoot)) {
			FileSystem.createDirectory(installTargets.targetRoot);
		}
		if(FileSystem.exists(installTargets.targetRoot) && FileSystem.isDirectory(installTargets.targetRoot)) {
			deleteDirectoryContents(installTargets.targetRoot);
		}
		setProgress('Replacing files', 0, 1);
		copyDirectoryContents(installTargets.sourceRoot, installTargets.targetRoot);
		setProgress('Adding new files', 0, 1);
		if(FileSystem.exists(tempDir) && FileSystem.isDirectory(tempDir)) {
			deleteDirectory(tempDir);
		}
		if(targetModFolder.length > 0) {
			forceEnableModInList(targetModFolder);
		}
		setProgress('Update complete', 1, 1);
		#end
	}

	private static function copyDirectoryContents(src:String, dst:String):Void
	{
		#if sys
		for(entry in FileSystem.readDirectory(src)) {
			var srcPath = Path.join([src, entry]);
			var dstPath = Path.join([dst, entry]);
			if(FileSystem.isDirectory(srcPath)) {
				if(!FileSystem.exists(dstPath)) {
					FileSystem.createDirectory(dstPath);
				}
				copyDirectoryContents(srcPath, dstPath);
			} else {
				if(FileSystem.exists(dstPath)) {
					FileSystem.deleteFile(dstPath);
				}
				File.copy(srcPath, dstPath);
			}
		}
		#end
	}

	private static function deleteDirectoryContents(path:String):Void
	{
		#if sys
		if(!FileSystem.exists(path) || !FileSystem.isDirectory(path)) return;
		for(entry in FileSystem.readDirectory(path)) {
			var entryPath = Path.join([path, entry]);
			if(FileSystem.isDirectory(entryPath)) {
				deleteDirectory(entryPath);
			} else {
				FileSystem.deleteFile(entryPath);
			}
		}
		#end
	}

	private static function normalizeInstallPath(filePath:String):String
	{
		if(filePath == null) return '';
		var normalized = StringTools.trim(filePath);
		while(normalized.startsWith('/')) {
			normalized = normalized.substring(1);
		}
		if(normalized.startsWith('game/')) {
			normalized = normalized.substring('game/'.length);
		}
		return normalized;
	}
	
	/**
	 * Recursively delete directory
	 */
	private static function deleteDirectory(path:String):Void
	{
		#if sys
		for(file in FileSystem.readDirectory(path)) {
			var filePath = haxe.io.Path.join([path, file]);
			if(FileSystem.isDirectory(filePath)) {
				deleteDirectory(filePath);
			} else {
				FileSystem.deleteFile(filePath);
			}
		}
		FileSystem.deleteDirectory(path);
		#end
	}
	
	/**
	 * Restart the game
	 */
	public static function restartGame():Void
	{
		#if cpp
		var args = Sys.args();
		Sys.command(Sys.programPath(), args);
		Sys.exit(0);
		#end
	}
}
