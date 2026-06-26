package backend;

import haxe.Http;
import haxe.Json;
import haxe.io.Bytes;
import haxe.io.Path;
import mobile.backend.StorageUtil;
import sys.FileSystem;
import sys.io.File;

class UpdateManager
{
	public static final REPO:String = 'PringleKitten/KitsModFolder';
	public static final API_URL:String = 'https://api.github.com/repos/${REPO}/tags?per_page=100';

	public static var CURRENT_ENGINE_VERSION:String = '';
	public static var CURRENT_MOD_VERSION:String = '0.0.0';
	public static var hasInternetFavoritesMod:Bool = false;

	public static var updateAvailable:Bool = false;
	public static var engineUpdateAvailable:Bool = false;
	public static var modUpdateAvailable:Bool = false;
	public static var latestEngineVersionDisplay:String = '';
	public static var latestModVersionDisplay:String = '';
	public static var latestReleaseUrl:String = '';
	public static var latestReleaseTag:String = '';
	public static var latestUpdateMessage:String = '';
	public static var isCheckingUpdates:Bool = false;
	public static var isDownloadingUpdate:Bool = false;
	public static var updateResultMessage:String = '';
	public static var updateResultSuccess:Bool = false;
	public static var updateReadyToApply:Bool = false;
	public static var pendingInstallPath:String = '';
	public static var pendingInstallType:String = 'engine';
	public static var latestEngineApkDownloadUrl:String = '';
	public static var latestEngineApkName:String = '';

	private static var _versionsInitialized:Bool = false;
	private static var _latestEngineVersion:String = '';
	private static var _latestModVersion:String = '';
	private static var _latestEngineTagName:String = '';
	private static var _latestModTagName:String = '';

	public static function initializeVersions():Void
	{
		if(_versionsInitialized) return;

		try {
			var engineVersion:String = states.MainMenuState.internetFavsVersion;
			CURRENT_ENGINE_VERSION = (engineVersion != null && engineVersion.length > 0) ? engineVersion : '5.0';
		} catch(e:Dynamic) {
			CURRENT_ENGINE_VERSION = '5.0';
		}

		CURRENT_MOD_VERSION = getCurrentModVersion();
		hasInternetFavoritesMod = CURRENT_MOD_VERSION != '0.0.0' && FileSystem.exists(Paths.mods(getActiveModFolder() + '/pack.json'));
		_versionsInitialized = true;
	}

	public static function checkForUpdates(callback:Bool->Bool->Bool->String->Void):Void
	{
		if(!_versionsInitialized) initializeVersions();
		if(isCheckingUpdates) return;

		isCheckingUpdates = true;
		updateResultMessage = '';
		updateResultSuccess = false;
		latestUpdateMessage = '';
		latestEngineApkDownloadUrl = '';
		latestEngineApkName = '';

		var http = new Http(API_URL);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.setHeader('Accept', 'application/vnd.github+json');
		http.onData = function(data:String) {
			parseTagInfo(data, callback);
		};
		http.onError = function(error:String) {
			isCheckingUpdates = false;
			engineUpdateAvailable = false;
			modUpdateAvailable = false;
			updateAvailable = false;
			latestEngineVersionDisplay = CURRENT_ENGINE_VERSION;
			latestModVersionDisplay = CURRENT_MOD_VERSION;
			latestReleaseTag = '';
			latestReleaseUrl = '';
			callback(false, false, false, error);
		};
		http.request(false);
	}

	private static function parseTagInfo(jsonString:String, callback:Bool->Bool->Bool->String->Void):Void
	{
		try {
			var tags:Array<Dynamic> = Json.parse(jsonString);
			var engineInfo = findLatestTagInfoForPrefix(tags, 'engine');
			var modInfo = findLatestTagInfoForPrefix(tags, 'mod');

			_latestEngineVersion = engineInfo.version;
			_latestEngineTagName = engineInfo.tagName;
			_latestModVersion = modInfo.version;
			_latestModTagName = modInfo.tagName;

			engineUpdateAvailable = _latestEngineVersion.length > 0 && compareVersions(_latestEngineVersion, CURRENT_ENGINE_VERSION) > 0;
			modUpdateAvailable = false;
			if(hasInternetFavoritesMod && _latestModVersion.length > 0) {
				modUpdateAvailable = compareVersions(_latestModVersion, CURRENT_MOD_VERSION) > 0;
			}
			updateAvailable = engineUpdateAvailable || modUpdateAvailable;

			latestEngineVersionDisplay = _latestEngineVersion;
			latestModVersionDisplay = _latestModVersion;
			latestReleaseTag = '';
			latestReleaseUrl = '';
			if(engineUpdateAvailable && _latestEngineTagName.length > 0) {
				latestReleaseTag = _latestEngineTagName;
				latestReleaseUrl = 'https://github.com/${REPO}/releases/tag/${latestReleaseTag}';
			} else if(modUpdateAvailable && _latestModTagName.length > 0) {
				latestReleaseTag = _latestModTagName;
				latestReleaseUrl = 'https://github.com/${REPO}/releases/tag/${latestReleaseTag}';
			}
			isCheckingUpdates = false;
			callback(updateAvailable, engineUpdateAvailable, modUpdateAvailable, '');
		} catch(e:Dynamic) {
			isCheckingUpdates = false;
			callback(false, false, false, Std.string(e));
		}
	}

	private static function findLatestTagInfoForPrefix(tags:Array<Dynamic>, prefix:String):{version:String, tagName:String}
	{
		var result:{version:String, tagName:String} = {version: '', tagName: ''};
		for(entry in tags) {
			if(entry == null) continue;
			var tagName:String = entry.name != null ? Std.string(entry.name) : '';
			if(tagName.length == 0) continue;
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

	private static function extractVersionForPrefix(tag:String, prefix:String):String
	{
		if(tag == null || tag.length == 0) return '';
		var normalized = StringTools.trim(tag);
		if(normalized.startsWith('v')) normalized = normalized.substring(1);
		var lower = normalized.toLowerCase();
		if(prefix == 'mod') {
			if(lower.startsWith('mod-') || lower.startsWith('mod ') || lower.indexOf('mod') == 0) {
				var versionText = normalized;
				if(lower.startsWith('mod-')) versionText = normalized.substring(4);
				else if(lower.startsWith('mod ')) versionText = normalized.substring(4);
				else if(lower.indexOf('mod') == 0) versionText = normalized.substring(3);
				return extractVersionFromTag(versionText);
			}
			if(lower.indexOf('mods') >= 0 || lower.indexOf('modfolder') >= 0) {
				return extractVersionFromTag(normalized);
			}
		}
		if(prefix == 'engine') {
			if(lower.indexOf('mod') >= 0) return '';
			if(lower.indexOf('engine') >= 0 || lower.indexOf('rev') >= 0 || lower.indexOf('unfinished') >= 0 || (lower.charAt(0) >= '0' && lower.charAt(0) <= '9')) {
				return extractVersionFromTag(normalized);
			}
		}
		return '';
	}

	private static function extractVersionFromTag(tag:String):String
	{
		if(tag == null || tag.length == 0) return '';
		var normalized = StringTools.trim(tag);
		if(normalized.startsWith('v')) normalized = normalized.substring(1);
		var versionParts:Array<String> = [];
		var currentPart:String = '';
		for(i in 0...normalized.length) {
			var ch = normalized.charAt(i);
			if(ch >= '0' && ch <= '9') {
				currentPart += ch;
			} else {
				if(currentPart.length > 0) {
					versionParts.push(currentPart);
					currentPart = '';
				}
			}
		}
		if(currentPart.length > 0) versionParts.push(currentPart);
		return versionParts.join('.');
	}

	private static function compareVersions(left:String, right:String):Int
	{
		var leftBase:String = normalizeBaseVersion(left);
		var rightBase:String = normalizeBaseVersion(right);
		if(leftBase != rightBase) {
			var leftParts:Array<Int> = normalizeVersionParts(leftBase);
			var rightParts:Array<Int> = normalizeVersionParts(rightBase);
			var size = Std.int(Math.max(leftParts.length, rightParts.length));
			for(i in 0...size) {
				var leftValue:Int = i < leftParts.length ? leftParts[i] : 0;
				var rightValue:Int = i < rightParts.length ? rightParts[i] : 0;
				if(leftValue > rightValue) return 1;
				if(leftValue < rightValue) return -1;
			}
		}
		return 0;
	}

	private static function normalizeBaseVersion(version:String):String
	{
		var cleaned = StringTools.trim(version != null ? version : '');
		if(cleaned.length == 0) return '0';
		if(cleaned.startsWith('v')) cleaned = cleaned.substring(1);
		var parts:Array<String> = cleaned.split('.');
		var result:Array<String> = [];
		for(part in parts) {
			var numeric = '';
			for(i in 0...part.length) {
				var ch = part.charAt(i);
				if(ch >= '0' && ch <= '9') numeric += ch;
			}
			if(numeric.length > 0) {
				result.push(numeric);
				if(result.length >= 2) break;
			}
		}
		return result.length > 0 ? result.join('.') : '0';
	}

	private static function normalizeVersionParts(version:String):Array<Int>
	{
		var cleaned = StringTools.trim(version != null ? version : '');
		if(cleaned.length == 0) return [0];
		if(cleaned.startsWith('v')) cleaned = cleaned.substring(1);
		var parts:Array<String> = cleaned.split('.');
		var result:Array<Int> = [];
		for(part in parts) {
			var numeric = '';
			for(i in 0...part.length) {
				var ch = part.charAt(i);
				if(ch >= '0' && ch <= '9') numeric += ch;
			}
			result.push(numeric.length > 0 ? Std.parseInt(numeric) : 0);
		}
		return result;
	}

	public static function downloadAndApplyUpdates(callback:Bool->String->Void, includeMod:Bool = false):Void
	{
		if(isDownloadingUpdate) return;
		isDownloadingUpdate = true;
		updateResultSuccess = false;
		updateResultMessage = '';
		updateReadyToApply = false;
		pendingInstallPath = '';
		pendingInstallType = includeMod ? 'mod' : 'engine';

		if(!engineUpdateAvailable && !modUpdateAvailable) {
			isDownloadingUpdate = false;
			callback(false, 'No update is currently available.');
			return;
		}

		resolveLatestApkAsset(callback);
	}

	private static function resolveLatestApkAsset(callback:Bool->String->Void):Void
	{
		var preferredTagName = '';
		if(engineUpdateAvailable) {
			preferredTagName = _latestEngineTagName.length > 0 ? _latestEngineTagName : ('engine-' + _latestEngineVersion);
		} else if(modUpdateAvailable) {
			preferredTagName = _latestModTagName.length > 0 ? _latestModTagName : ('mod-' + _latestModVersion);
		}

		var releaseUrl = 'https://api.github.com/repos/${REPO}/releases';
		var http = new Http(releaseUrl);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onData = function(data:String) {
			try {
				var releases:Array<Dynamic> = Json.parse(data);
				var selectedAsset:Dynamic = null;
				var selectedReleaseTag:String = '';
				for(release in releases) {
					if(release == null) continue;
					var releaseTag:String = release.tag_name != null ? Std.string(release.tag_name) : '';
					var assets:Array<Dynamic> = release.assets != null ? cast release.assets : [];
					var apkAsset:Dynamic = findApkAssetInAssets(assets);
					if(apkAsset == null) continue;
					if(preferredTagName.length > 0 && releaseTag == preferredTagName) {
						selectedAsset = apkAsset;
						selectedReleaseTag = releaseTag;
						break;
					}
					if(selectedAsset == null) {
						selectedAsset = apkAsset;
						selectedReleaseTag = releaseTag;
					}
				}

				if(selectedAsset == null) {
					isDownloadingUpdate = false;
					callback(false, 'No APK asset was found in the GitHub releases.');
					return;
				}

				latestEngineApkDownloadUrl = selectedAsset.browser_download_url != null ? Std.string(selectedAsset.browser_download_url) : '';
				latestEngineApkName = selectedAsset.name != null ? Std.string(selectedAsset.name) : 'update.apk';
				if(latestEngineApkDownloadUrl.length == 0) {
					isDownloadingUpdate = false;
					callback(false, 'The APK asset URL could not be resolved.');
					return;
				}

				pendingInstallPath = latestEngineApkDownloadUrl;
				pendingInstallType = 'engine';
				updateReadyToApply = true;
				isDownloadingUpdate = false;
				callback(true, 'The APK download link was opened in your browser.');
				CoolUtil.browserLoad(latestEngineApkDownloadUrl);
			} catch(e:Dynamic) {
				isDownloadingUpdate = false;
				callback(false, 'Failed to read the GitHub release assets: $e');
			}
		};
		http.onError = function(error:String) {
			isDownloadingUpdate = false;
			callback(false, 'Failed to fetch the GitHub release assets: $error');
		};
		http.request(false);
	}

	private static function findApkAssetInAssets(assets:Array<Dynamic>):Dynamic
	{
		for(asset in assets) {
			if(asset == null) continue;
			var assetName:String = asset.name != null ? Std.string(asset.name) : '';
			var lowerName = assetName.toLowerCase();
			if(lowerName.endsWith('.apk') || lowerName.indexOf('apk') >= 0) return asset;
		}
		return null;
	}

	private static function downloadFileToPath(url:String, destPath:String, callback:Bool->Void):Void
	{
		if(url == null || url.length == 0 || destPath == null || destPath.length == 0) {
			callback(false);
			return;
		}

		var http = new Http(url);
		http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
		http.onBytes = function(bytes:Bytes) {
			try {
				File.saveBytes(destPath, bytes);
				callback(true);
			} catch(e:Dynamic) {
				callback(false);
			}
		};
		http.onError = function(error:String) {
			callback(false);
		};
		http.request(false);
	}

	private static function getUpdateStorageRoot():String
	{
		var baseDir = StorageUtil.getStorageDirectory();
		if(baseDir != null && baseDir.length > 0) {
			var root = Path.join([baseDir, 'downloads', 'updates']);
			if(!FileSystem.exists(root)) FileSystem.createDirectory(root);
			return root;
		}
		return Path.join([Sys.getCwd(), 'updates']);
	}

	private static function getActiveModFolder():String
	{
		if(Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0) return Mods.currentModDirectory;
		var enabledMods:Array<String> = Mods.parseList().enabled;
		if(enabledMods != null && enabledMods.length > 0) return enabledMods[0];
		return '';
	}

	private static function getCurrentModVersion():String
	{
		var modFolder = getActiveModFolder();
		if(modFolder.length == 0) return '0.0.0';
		var packPath = Paths.mods(modFolder + '/pack.json');
		if(!FileSystem.exists(packPath)) return '0.0.0';
		try {
			var raw:String = File.getContent(packPath);
			var parsed:Dynamic = Json.parse(raw);
			if(parsed != null && parsed.version != null) {
				var versionText:String = Std.string(parsed.version);
				return versionText.length > 0 ? versionText : '0.0.0';
			}
			if(parsed != null && parsed.modVersion != null) {
				var versionText:String = Std.string(parsed.modVersion);
				return versionText.length > 0 ? versionText : '0.0.0';
			}
			if(parsed != null && parsed.name != null) {
				var inferred = extractVersionFromTag(Std.string(parsed.name));
				if(inferred.length > 0) return inferred;
			}
			var inferredFromFolder = extractVersionFromTag(modFolder);
			if(inferredFromFolder.length > 0) return inferredFromFolder;
			return '0.0.0';
		} catch(e:Dynamic) {
			return '0.0.0';
		}
	}
}
