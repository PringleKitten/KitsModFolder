package backend;

import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

#if cpp
import lime.system.System;
#end

typedef GithubRelease = {
	var tag_name:String;
	var assets:Array<{name:String, browser_download_url:String}>;
}

typedef VersionInfo = {
	var engine:String;
	var mod:String;
}

class UpdateManager
{
	public static final REPO:String = 'PringleKitten/KitsModFolder';
	public static final API_URL:String = 'https://api.github.com/repos/${REPO}/releases/latest';
	
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
	private static var _updateCheckInProgress:Bool = false;
	private static var _downloadInProgress:Bool = false;
	private static var _versionsInitialized:Bool = false;
	
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
			var release:GithubRelease = Json.parse(jsonString);
			
			// Parse version from tag_name (e.g., "v5.0r-2.8" or "5.0r-2.8")
			var rawTag:String = release.tag_name;
			if(rawTag.length > 0 && rawTag.charAt(0) == 'v') {
				rawTag = rawTag.substr(1);
			}
			var versionParts = rawTag.split('-');
			if(versionParts.length >= 2) {
				_latestEngineVersion = versionParts[0].replace('r', ''); // Remove 'r' suffix
				_latestModVersion = versionParts[1];
			} else {
				_latestEngineVersion = rawTag.replace('r', '');
				_latestModVersion = '';
			}
			
			engineUpdateAvailable = compareVersions(_latestEngineVersion, CURRENT_ENGINE_VERSION) > 0;
			
			modUpdateAvailable = false;
			if(hasInternetFavoritesMod) {
				modUpdateAvailable = compareVersions(_latestModVersion, CURRENT_MOD_VERSION) > 0;
			} else {
				trace('Internet Favorites mod not found - skipping mod update check');
			}
			
			updateAvailable = engineUpdateAvailable || modUpdateAvailable;
			
			_updateCheckInProgress = false;
			callback(updateAvailable, engineUpdateAvailable, modUpdateAvailable, '');
		} catch(e:Dynamic) {
			_updateCheckInProgress = false;
			callback(false, false, false, 'Failed to parse version info: $e');
		}
	}
	
	/**
	 * Compare two semantic versions
	 * Returns: -1 if v1 < v2, 0 if equal, 1 if v1 > v2
	 */
	private static function compareVersions(v1:String, v2:String):Int
	{
		var parts1 = if(v1 == null || v1.length == 0) [] else v1.split('.').map(parseVersionPart);
		var parts2 = if(v2 == null || v2.length == 0) [] else v2.split('.').map(parseVersionPart);
		
		for(i in 0...Std.int(Math.max(parts1.length, parts2.length))) {
			var p1 = i < parts1.length ? parts1[i] : 0;
			var p2 = i < parts2.length ? parts2[i] : 0;
			
			if(p1 > p2) return 1;
			if(p1 < p2) return -1;
		}
		return 0;
	}

	private static function parseVersionPart(part:String):Int
	{
		var parsed = Std.parseInt(part);
		return parsed == null ? 0 : parsed;
	}
	
	/**
	 * Get mod version from pack.json in mods folder
	 * Only looks for Internet Favorites mod specifically
	 */
	public static function getModVersionFromPack():String
	{
		try {
			#if sys
			var modsFolders = Mods.getModDirectories();
			for(folder in modsFolders) {
				var packPath = Paths.mods(folder + '/pack.json');
				if(FileSystem.exists(packPath)) {
					var rawJson:String = File.getContent(packPath);
					var pack:Dynamic = Json.parse(rawJson);
					
					// Only check for Internet Favorites mod specifically
					if(pack.name != null && pack.name.contains('Internet Favorites')) {
						hasInternetFavoritesMod = true;
						var version:String = '0.0.0';
						if(pack.version != null) {
							version = Std.string(pack.version);
							trace('Found Internet Favorites mod version from pack.version: $version in folder: $folder');
						} else {
							var regex = ~/Internet Favorites\s+(?:Rev)?(\d+\.\d+)/;
							if(regex.match(pack.name)) {
								version = regex.matched(1);
								trace('Found Internet Favorites mod version: $version in folder: $folder');
							}
						}
						return version;
					}
				}
			}
			#end
		} catch(e:Dynamic) {
			trace('Error reading mod version from pack.json: $e');
		}
		
		// Fallback: return 0.0.0 to indicate mod not found, forcing update check
		return '0.0.0';
	}
	
	/**
	 * Download and apply updates
	 * This uses git diff to get changed files and downloads only those
	 */
	public static function downloadAndApplyUpdates(callback:Bool->String->Void):Void
	{
		if(_downloadInProgress) return;
		
		_downloadInProgress = true;
		
		#if sys
		try {
			var diffUrl = if(hasInternetFavoritesMod) 'https://github.com/${REPO}/compare/v${CURRENT_ENGINE_VERSION}-${CURRENT_MOD_VERSION}...v${_latestEngineVersion}-${_latestModVersion}.diff' else 'https://github.com/${REPO}/compare/v${CURRENT_ENGINE_VERSION}...v${_latestEngineVersion}.diff';
			var http = new haxe.Http(diffUrl);
			http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
			http.onData = function(data:String) {
				var changedFiles = parseGitDiff(data);
				if(changedFiles.length > 0) {
					downloadFiles(changedFiles, callback);
				} else {
					_downloadInProgress = false;
					callback(false, 'No changes found');
				}
			};
			http.onError = function(error:String) {
				_downloadInProgress = false;
				callback(false, 'Failed to download diff: $error');
			};
			http.request(false);
		} catch(e:Dynamic) {
			_downloadInProgress = false;
			callback(false, 'Error during update: $e');
		}
		#else
		callback(false, 'Updates not supported on this platform');
		#end
	}
	
	/**
	 * Parse git diff output to extract changed files
	 */
	private static function parseGitDiff(diffContent:String):Array<String>
	{
		var files:Array<String> = [];
		var lines = diffContent.split('\n');
		
		for(line in lines) {
			if(line.startsWith('diff --git')) {
				// Extract filename from: diff --git a/path/to/file b/path/to/file
				var parts = line.split(' ');
				if(parts.length >= 4) {
					var filePath = parts[3]; // b/path/to/file
					if(filePath.startsWith('b/')) {
						filePath = filePath.substring(2);
						// Only include files that should be updated (exclude certain directories)
						if(!shouldIgnoreFile(filePath)) {
							files.push(filePath);
						}
					}
				}
			}
		}
		
		return files;
	}
	
	/**
	 * Check if a file should be ignored during updates
	 */
	private static function shouldIgnoreFile(filePath:String):Bool
	{
		var ignoredPatterns = [
			'example_mods/',
			'export/',
			'.git/',
			'.gitattributes',
			'.gitignore',
			'README.md',
			'LICENSE'
		];
		
		for(pattern in ignoredPatterns) {
			if(filePath.startsWith(pattern)) {
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 * Download changed files from GitHub raw content
	 */
	private static function downloadFiles(files:Array<String>, callback:Bool->String->Void):Void
	{
		if(files.length == 0) {
			_downloadInProgress = false;
			callback(false, 'No files to update');
			return;
		}
		
		#if sys
		var downloadDir = Paths.getPath('', 'update_temp');
		try {
			if(!FileSystem.exists(downloadDir)) {
				FileSystem.createDirectory(downloadDir);
			}
			
			var failedFiles:Array<String> = [];
			var downloadedCount = 0;
			var tagPath = _latestEngineVersion + (hasInternetFavoritesMod ? '-' + _latestModVersion : '');
			var index:Int = 0;
			
			var downloadNext:Void->Void;
			downloadNext = function() {
				if(index >= files.length) {
					if(failedFiles.length > 0) {
						_downloadInProgress = false;
						callback(false, 'Failed to download: ${failedFiles.join(", ")}');
					} else {
						applyUpdates(downloadDir, callback);
					}
					return;
				}
				var file = files[index++];
				var fileUrl = 'https://raw.githubusercontent.com/${REPO}/refs/tags/${tagPath}/$file';
				var http = new haxe.Http(fileUrl);
				var content = '';
				http.setHeader('User-Agent', 'FNF-IFE-UpdateChecker');
				http.onData = function(data:String) {
					content = data;
					if(content.length > 0) {
						var destPath = haxe.io.Path.join([downloadDir, file]);
						var dir = Path.directory(destPath);
						if(!FileSystem.exists(dir)) {
							FileSystem.createDirectory(dir);
						}
						File.saveContent(destPath, content);
						downloadedCount++;
					} else {
						failedFiles.push('$file (empty file)');
					}
					downloadNext();
				};
				http.onError = function(error:String) {
					failedFiles.push('$file ($error)');
					downloadNext();
				};
				http.request(false);
			};
			downloadNext();
		} catch(e:Dynamic) {
			_downloadInProgress = false;
			callback(false, 'Error preparing update: $e');
		}
		#end
	}

	/**
	 * Apply downloaded updates to the game directory
	 */
	private static function applyUpdates(tempDir:String, callback:Bool->String->Void):Void
	{
		#if sys
		try {
			// Copy files from temp directory to game directory
			copyDirectory(tempDir, '.');
			
			// Clean up temp directory
			deleteDirectory(tempDir);
			
			// Update version numbers in memory
			CURRENT_ENGINE_VERSION = _latestEngineVersion;
			CURRENT_MOD_VERSION = _latestModVersion;
			
			_downloadInProgress = false;
			pendingUpdate = true;
			
			callback(true, 'Update downloaded successfully. Game will restart to apply changes.');
		} catch(e:Dynamic) {
			_downloadInProgress = false;
			callback(false, 'Error applying update: $e');
		}
		#end
	}
	
	/**
	 * Recursively copy directory contents
	 */
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
				var content = File.getContent(srcPath);
				File.saveContent(dstPath, content);
			}
		}
		#end
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
