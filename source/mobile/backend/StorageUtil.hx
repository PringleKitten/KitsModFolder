 package mobile.backend;
 
 class StorageUtil
 {
	 #if sys
	 public static function getStorageDirectory():String
		 return #if android haxe.io.Path.addTrailingSlash(AndroidContext.getExternalFilesDir()) #elseif ios lime.system.System.documentsDirectory #else Sys.getCwd() #end;
 
	 public static function saveContent(fileName:String, fileData:String, ?alert:Bool = true):Void
	 {
		 try
		 {
			 if (!FileSystem.exists('saves'))
				 FileSystem.createDirectory('saves');
 
			 File.saveContent('saves/$fileName', fileData);
			 if (alert)
				 CoolUtil.showPopUp(Language.getPhrase('file_save_success', '{1} has been saved.', [fileName]), Language.getPhrase('mobile_success', "Success!"));
		 }
		 catch (e:Dynamic)
			 if (alert)
				 CoolUtil.showPopUp(Language.getPhrase('file_save_fail', '{1} couldn\'t be saved.\n({2})', [fileName, e.message]), Language.getPhrase('mobile_error', "Error!"));
			 else
				 trace('$fileName couldn\'t be saved. (${e.message})');
	 }
 
	 #if android
	 public static function requestPermissions():Void
	 {
		 if (AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU)
			 AndroidPermissions.requestPermissions(['READ_MEDIA_IMAGES', 'READ_MEDIA_VIDEO', 'READ_MEDIA_AUDIO', 'READ_MEDIA_VISUAL_USER_SELECTED']);
		 else
			 AndroidPermissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);
 
		 if (!AndroidEnvironment.isExternalStorageManager())
			 AndroidSettings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
 
		 if ((AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU
			 && !AndroidPermissions.getGrantedPermissions().contains('android.permission.READ_MEDIA_IMAGES'))
			 || (AndroidVersion.SDK_INT < AndroidVersionCode.TIRAMISU
				 && !AndroidPermissions.getGrantedPermissions().contains('android.permission.READ_EXTERNAL_STORAGE')))
			 CoolUtil.showPopUp(Language.getPhrase('permissions_message', 'If you accepted the permissions you are all good!\nIf you didn\'t then expect a crash\nPress OK to see what happens'),
				 Language.getPhrase('mobile_notice', "Notice!"));
 
		 try
		 {
			 if (!FileSystem.exists(StorageUtil.getStorageDirectory()))
				 FileSystem.createDirectory(StorageUtil.getStorageDirectory());
		 }
		 catch (e:Dynamic)
		 {
			 CoolUtil.showPopUp(Language.getPhrase('create_directory_error', 'Please create directory to\n{1}\nPress OK to close the game', [StorageUtil.getStorageDirectory()]), Language.getPhrase('mobile_error', "Error!"));
			 lime.system.System.exit(1);
		 }
	 }
	 #end
	 #end
 }