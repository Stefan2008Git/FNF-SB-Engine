package android.backend;

#if android
import android.Tools;
import android.Permissions;
import android.PermissionsList;
import android.backend.AndroidDialogsExtend;
#end

import openfl.utils.Assets as OpenFlAssets;

/**
 * ...
 * @author: Saw (M.A. Jigsaw)
 */

using StringTools;

class StorageUtil
{
	#if android
	private static var aDir:String = null; // android dir
	#end

	public static function getPath():String
	{
		#if android
		if (aDir != null && aDir.length > 0)
			return aDir;
		else
			return aDir = Tools.getExternalStorageDirectory() + "/.SB Engine/";
		#else
		return '';
		#end
	}

	public static function applicationAlert(title:String, description:String)
	{
		Application.current.window.alert(description, title);
	}

	#if android
	public static function doTheCheck()
	{
		if (!Permissions.getGrantedPermissions().contains(PermissionsList.READ_EXTERNAL_STORAGE) || !Permissions.getGrantedPermissions().contains(PermissionsList.WRITE_EXTERNAL_STORAGE))
		{
			Permissions.requestPermissions([PermissionsList.READ_EXTERNAL_STORAGE, PermissionsList.WRITE_EXTERNAL_STORAGE]);
			applicationAlert('Permissions', "if you acceptd the permissions all good if not expect a crash\nPress Ok to see what happens");
		}

		if (Permissions.getGrantedPermissions().contains(PermissionsList.READ_EXTERNAL_STORAGE) || Permissions.getGrantedPermissions().contains(PermissionsList.WRITE_EXTERNAL_STORAGE))
		{
			if (!FileSystem.exists(Tools.getExternalStorageDirectory() + '/' + '.' + Application.current.meta.get('root'))) FileSystem.createDirectory(Tools.getExternalStorageDirectory() + '/' + '.' + Application.current.meta.get('root'));
			if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Creating the root directory...", 1);

		if (!FileSystem.exists(StorageUtil.getPath() + 'assets') && !FileSystem.exists(StorageUtil.getPath() + 'mods'))
		{
			applicationAlert('Uncaught Error!', "Whoops, seems you didn't extract the 2 folders from the .APK!\nPlease watch the tutorial by pressing OK.");
			if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Missing the assets and mods folder in root directory!", 1);
			CoolUtil.browserLoad('https://www.youtube.com/watch?v=Cm1JE_uBbYk');
			openfl.system.System.exit(1);
		} 
		else 
			{
				if (!FileSystem.exists(StorageUtil.getPath() + 'assets'))
				{
					applicationAlert('Uncaught Error!', "Whoops, seems you are missing the assets folder from the .APK to the root directory!\nPlease watch the tutorial by pressing OK.");
					if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Missing the assets folder in root directory!", 1);
					CoolUtil.browserLoad('https://www.youtube.com/watch?v=Cm1JE_uBbYk');
					openfl.system.System.exit(1);
				}

				if (!FileSystem.exists(StorageUtil.getPath() + 'mods'))
				{
					applicationAlert('Uncaught Error!', "Whoops, seems you are missing the mods folder from the .APK to the root directory!\nPlease watch the tutorial by pressing OK.");
					if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Missing the mods folder in root directory!", 1);
					CoolUtil.browserLoad('https://www.youtube.com/watch?v=Cm1JE_uBbYk');
					openfl.system.System.exit(1);
				}
			}
		}
	}

	public static function saveContent(fileName:String = 'file', fileExtension:String = '.json', fileData:String = 'You forgot something to add in your code')
	{
		if (!FileSystem.exists(StorageUtil.getPath() + 'saves')) FileSystem.createDirectory(StorageUtil.getPath() + 'saves');
		File.saveContent(StorageUtil.getPath() + 'saves/' + fileName + fileExtension, fileData);
		if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Done! File Saved Successfully!", 1);
	}

	public static function saveClipboard(fileData:String = 'You forgot something to add in your code')
	{
		openfl.system.System.setClipboard(fileData);
		if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Done! Data Saved to Clipboard Successfully!", 1);
	}

	public static function copyContent(copyPath:String, savePath:String)
	{
		if (!FileSystem.exists(savePath)) File.saveBytes(savePath, OpenFlAssets.getBytes(copyPath));
	}
	#end
}
