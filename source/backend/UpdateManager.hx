package backend;

import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;
import sys.thread.Thread;

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
	private static var _latestReleaseTag:String = '';
	public static var latestEngineVersionDisplay:String = '';
	public static var latestModVersionDisplay:String = '';
	public static var latestReleaseTag:String = '';
	public static var latestReleaseName:String = '';
	public static var latestReleaseBody:String = '';
	public static var latestReleaseUrl:String = '';
	private static var _updateCheckInProgress:Bool = false;
	private static var _downloadInProgress:Bool = false;
	private static var _versionsInitialized:Bool = false;
	public static var postCloseInstallPending:Bool = false;
	public static var updateReadyToApply:Bool = false;
	private static var _includeModInUpdate:Bool = false;
	private static var _pendingInstallDir:String = '';
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
		
		// Use HTTP request to check GitHub API
		#if sys
		try {
			var http = new haxe.Http(API_URL);
			http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
			
			http.onData = function(data:String) {
				parseReleaseInfo(data, callback);
			};
			
			http.onError = function(error:String) {
				_updateCheckInProgress = false;
				callback(false, false, false, 'Failed to check for updates: $error');
			};
			
			http.request(false);
		} catch(e:Dynamic) {
			_updateCheckInProgress = false;
			callback(false, false, false, 'Error checking for updates: $e');
		}
		#else
		callback(false, false, false, 'Update checking not supported on this platform');
		#end
	}
	
	private static function parseReleaseInfo(jsonString:String, callback:Bool->Bool->Bool->String->Void):Void
	{
		try {
			var tags:Array<Dynamic> = Json.parse(jsonString);
			_latestEngineVersion = findLatestVersionForPrefix(tags, 'engine');
			_latestModVersion = findLatestVersionForPrefix(tags, 'mod');
			_latestReleaseTag = _latestEngineVersion.length > 0 ? 'engine-' + _latestEngineVersion : '';
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
		} catch(e:Dynamic) {
			_updateCheckInProgress = false;
			callback(false, false, false, 'Failed to parse version info: $e');
		}
	}

	private static function getPreferredReleaseTag():String
	{
		if(modUpdateAvailable && _latestModVersion.length > 0) return 'mod-' + _latestModVersion;
		if(engineUpdateAvailable && _latestEngineVersion.length > 0) return 'engine-' + _latestEngineVersion;
		return '';
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

	private static function findLatestVersionForPrefix(tags:Array<Dynamic>, prefix:String):String
	{
		var latest:String = '';
		for(entry in tags) {
			var tagName:String = entry != null ? Std.string(entry.name) : '';
			if(tagName.length == 0) continue;
			var normalized = StringTools.trim(tagName);
			if(normalized.startsWith('v')) normalized = normalized.substring(1);
			if(!normalized.startsWith(prefix + '-')) continue;
			var version = extractVersionFromTag(normalized);
			if(version.length == 0) continue;
			if(latest.length == 0 || compareVersions(version, latest) > 0) {
				latest = version;
			}
		}
		return latest;
	}

	private static function extractVersionFromTag(tag:String):String
	{
		if(tag == null) return '';
		var text = StringTools.trim(tag);
		if(text.length == 0) return '';
		if(text.startsWith('v')) text = text.substring(1);
		var regex = ~/([0-9]+(?:\.[0-9]+)*(?:[A-Za-z0-9._-]+)?)/;
		if(regex.match(text)) {
			return regex.matched(1);
		}
		return '';
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
		if(_downloadInProgress || updateThreadActive) return;
		
		_downloadInProgress = true;
		_includeModInUpdate = includeMod;
		postCloseInstallPending = false;
		resetProgressState();
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
	private static function resetProgressState():Void
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
		_pendingInstallDir = '';
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
		if(includeMod && modUpdateAvailable && _latestModVersion.length > 0) {
			return 'mod-' + _latestModVersion;
		}
		if(engineUpdateAvailable && _latestEngineVersion.length > 0) {
			return 'engine-' + _latestEngineVersion;
		}
		if(modUpdateAvailable && _latestModVersion.length > 0) {
			return 'mod-' + _latestModVersion;
		}
		return '';
	}

	private static function getCurrentTagName(includeMod:Bool):String
	{
		if(includeMod && modUpdateAvailable && CURRENT_MOD_VERSION != null && CURRENT_MOD_VERSION.length > 0 && CURRENT_MOD_VERSION != '0.0.0') {
			return 'mod-' + CURRENT_MOD_VERSION;
		}
		if(CURRENT_ENGINE_VERSION != null && CURRENT_ENGINE_VERSION.length > 0) {
			return 'engine-' + CURRENT_ENGINE_VERSION;
		}
		if(includeMod && CURRENT_MOD_VERSION != null && CURRENT_MOD_VERSION.length > 0 && CURRENT_MOD_VERSION != '0.0.0') {
			return 'mod-' + CURRENT_MOD_VERSION;
		}
		return _latestEngineVersion.length > 0 ? 'engine-' + _latestEngineVersion : '';
	}

	private static function fetchChangedFiles(baseTag:String, headTag:String, includeMod:Bool, callback:Bool->String->Void):Void
	{
		var baseCandidates:Array<String> = buildTagCandidates(baseTag);
		var headCandidates:Array<String> = buildTagCandidates(headTag);
		resolveBaseTagAndCompare(0, baseCandidates, headCandidates, includeMod, callback);
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
		return trimmed;
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
							inspectCommitFiles(commitShas, 0, includeMod, headTag, callback);
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

				for(path in headFiles) {
					if(path == null || path.length == 0 || isPathInList(baseFiles, path)) continue;
					if(!containsString(files, path)) {
						files.push(path);
					}
				}

				for(path in baseFiles) {
					if(path == null || path.length == 0 || isPathInList(headFiles, path)) continue;
					if(!containsString(deletions, path)) {
						deletions.push(path);
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
			callback(files);
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
					if(previousPath.length > 0 && !shouldIgnoreFile(previousPath)) {
						deletions.push(previousPath);
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

	private static function inspectCommitFiles(commitShas:Array<String>, index:Int, includeMod:Bool, headTag:String, callback:Bool->String->Void):Void
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
							if(previousPath.length > 0 && !shouldIgnoreFile(previousPath)) {
								compareOperations.deletions.push(previousPath);
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
					downloadFiles(compareOperations.files, compareOperations.deletions, headTag, callback);
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
		var modsRoot = Path.join([installDir, 'mods']);
		var downloadDir = Path.join([modsRoot, 'update_temp']);
		try {
			if(!FileSystem.exists(modsRoot)) {
				FileSystem.createDirectory(modsRoot);
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
			setProgress('Downloading files', 0, files.length);
			
			if(removedFiles != null && removedFiles.length > 0) {
				var manifestLines:Array<String> = [];
				for(removedPath in removedFiles) {
					var relativePath = getRelativePathForInstallTarget(removedPath);
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
				var relativePath = getRelativePathForInstallTarget(file);
				var destPath = getModStagedPath(downloadDir, relativePath);
				var dir = Path.directory(destPath);
				if(!FileSystem.exists(dir)) {
					FileSystem.createDirectory(dir);
				}
				if(downloadFileToPath(fileUrl, destPath)) {
					downloadedCount++;
					setProgress('Downloading files', downloadedCount, files.length);
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
		updateThreadFinished = false;
		updateThreadSuccessful = true;
		updateThreadMessage = shouldAutoApplyPendingUpdate() ? 'Update downloaded. Applying in place...' : 'Update downloaded. Click Restart to apply and relaunch.';
		pendingUpdate = true;
		updateReadyToApply = true;
		postCloseInstallPending = true;
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
		if(_pendingInstallDir == null || _pendingInstallDir.length == 0) return;
		setProgress('Applying update', 0, 1);
		try {
			if(shouldAutoApplyPendingUpdate()) {
				createPostCloseInstallScript(_pendingInstallDir);
				updateReadyToApply = false;
				postCloseInstallPending = true;
				exitForPostCloseInstall();
				return;
			}
			createPostCloseInstallScript(_pendingInstallDir);
			updateReadyToApply = false;
			postCloseInstallPending = true;
			exitForPostCloseInstall();
		} catch(e:Dynamic) {
			trace('Failed to start post-close installer: $e');
		}
		#end
	}
	
	private static function createPostCloseInstallScript(tempDir:String):Void
	{
		#if sys
		var installDir = getInstallDirectory();
		var installTargets = getPostCloseInstallPaths(tempDir, installDir);
		var scriptPath = Path.join([installDir, 'update_post_close.ps1']);
		var exePath = Sys.programPath();
		var normalizedTempDir = StringTools.replace(tempDir, '/', '\\');
		var normalizedSourceRoot = StringTools.replace(installTargets.sourceRoot, '/', '\\');
		var normalizedTargetRoot = StringTools.replace(installTargets.targetRoot, '/', '\\');
		var scriptContent = 'param([string]$$GameExe)\r\n' +
			'$$ErrorActionPreference = "Stop"\r\n' +
			'$$scriptDir = Split-Path -Parent $$MyInvocation.MyCommand.Path\r\n' +
			'$$updateDir = "' + normalizedTempDir + '"\r\n' +
			'$$manifestPath = Join-Path $$updateDir ".update_manifest.txt"\r\n' +
			'$$gameName = [System.IO.Path]::GetFileNameWithoutExtension($$GameExe)\r\n' +
			'while ($$true) {\r\n' +
			'  $$running = @(Get-Process -Name $$gameName -ErrorAction SilentlyContinue)\r\n' +
			'  if ($$running.Count -eq 0) { break }\r\n' +
			'  Stop-Process -Name $$gameName -Force -ErrorAction SilentlyContinue\r\n' +
			'  Start-Sleep -Seconds 2\r\n' +
			'}\r\n' +
			'if (Test-Path $$updateDir) {\r\n' +
			'  $$sourceRoot = [System.IO.Path]::GetFullPath("' + normalizedSourceRoot + '")\r\n' +
			'  $$targetRoot = [System.IO.Path]::GetFullPath("' + normalizedTargetRoot + '")\r\n' +
			'  $$deletePaths = @()\r\n' +
			'  if (Test-Path $$manifestPath) {\r\n' +
			'    $$deletePaths = Get-Content -LiteralPath $$manifestPath | Where-Object { $$_-and $$_.Trim().Length -gt 0 }\r\n' +
			'    Remove-Item -LiteralPath $$manifestPath -Force -ErrorAction SilentlyContinue\r\n' +
			'  }\r\n' +
			'  foreach ($$relPath in $$deletePaths) {\r\n' +
			'    $$targetPath = Join-Path $$targetRoot $$relPath\r\n' +
			'    if (Test-Path $$targetPath) {\r\n' +
			'      if (Test-Path $$targetPath -PathType Container) { Remove-Item -LiteralPath $$targetPath -Recurse -Force -ErrorAction SilentlyContinue } else { Remove-Item -LiteralPath $$targetPath -Force -ErrorAction SilentlyContinue }\r\n' +
			'    }\r\n' +
			'  }\r\n' +
			'  if (-not (Test-Path $$targetRoot)) { New-Item -ItemType Directory -Path $$targetRoot -Force | Out-Null }\r\n' +
			'  if (Test-Path (Join-Path $$targetRoot ".update_manifest.txt")) { Remove-Item -LiteralPath (Join-Path $$targetRoot ".update_manifest.txt") -Force -ErrorAction SilentlyContinue }\r\n' +
			'  Get-ChildItem -LiteralPath $$sourceRoot -Recurse -Force | ForEach-Object {\r\n' +
			'    $$relPath = $$_.FullName.Substring($$sourceRoot.Length).TrimStart([char[]]@("\\", "/"))\r\n' +
			'    if ($$relPath -eq "") { return }\r\n' +
			'    if ($$_.Name -eq ".update_manifest.txt") { return }\r\n' +
					'    $$targetPath = Join-Path $$targetRoot $$relPath\r\n' +
			'    $$targetParent = Split-Path -Parent $$targetPath\r\n' +
			'    if ($$targetParent -and -not (Test-Path $$targetParent)) { New-Item -ItemType Directory -Path $$targetParent -Force | Out-Null }\r\n' +
			'    $$targetFullPath = [System.IO.Path]::GetFullPath($$targetPath)\r\n' +
			'    $$sourceFullPath = [System.IO.Path]::GetFullPath($$_.FullName)\r\n' +
			'    if ($$targetFullPath -eq $$sourceFullPath) { return }\r\n' +
			'    if ($$_.PSIsContainer) { New-Item -ItemType Directory -Path $$targetPath -Force | Out-Null } else { Copy-Item -LiteralPath $$_.FullName -Destination $$targetPath -Force }\r\n' +
			'  }\r\n' +
			'  Get-ChildItem -LiteralPath $$targetRoot -Directory -Recurse -Force | Sort-Object FullName -Descending | ForEach-Object { if ((Get-ChildItem -LiteralPath $$_.FullName -Force | Measure-Object).Count -eq 0) { Remove-Item -LiteralPath $$_.FullName -Force -ErrorAction SilentlyContinue } }\r\n' +
			'  Remove-Item -Path $$updateDir -Recurse -Force -ErrorAction SilentlyContinue\r\n' +
			'}\r\n' +
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
			Sys.command('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', windowsScriptPath, windowsExePath]);
		}
		#end
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
		var exePath = Sys.programPath();
		if(exePath != null && exePath.length > 0) {
			var exeDir = Path.directory(exePath);
			if(exeDir != null && exeDir.length > 0) return exeDir;
		}
		return Sys.getCwd();
		#else
		return '.';
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

	private static function getRelativePathForInstallTarget(filePath:String):String
	{
		var normalized = normalizeInstallPath(filePath);
		if(normalized.length == 0) return '';
		var parts = normalized.split('/');

		if(parts.length >= 2 && parts[0] == 'mods') {
			if(parts.length > 2) {
				return parts.slice(2).join('/');
			}
			return parts.length > 1 ? parts[1] : '';
		}

		if(parts.length > 1 && isLikelyModRootFolderName(parts[0])) {
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

	private static function getModStagedPath(downloadDir:String, relativePath:String):String
	{
		#if sys
		var normalized = getRelativePathForInstallTarget(relativePath);
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
		if(_includeModInUpdate && sourceRoot.length > 0 && FileSystem.exists(sourceRoot)) {
			var existingModRoot = getExistingModInstallRoot(installDir, sourceRoot);
			if(existingModRoot.length > 0) {
				targetRoot = existingModRoot;
			} else {
				targetRoot = Path.join([installDir, 'mods']);
			}
		}
		#end
		return {sourceRoot: sourceRoot, targetRoot: targetRoot};
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
		return _includeModInUpdate && modUpdateAvailable && !engineUpdateAvailable;
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
