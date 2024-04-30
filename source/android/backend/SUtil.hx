package android.backend;

#if android
import android.Tools;
import android.Permissions;
import android.PermissionsList;
import android.backend.AndroidDialogsExtend;
import flash.system.System;
#end
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import openfl.utils.Assets as OpenFlAssets;
import openfl.Lib;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author: Saw (M.A. Jigsaw)
 */

using StringTools;

class SUtil
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
			return aDir = Tools.getExternalStorageDirectory() + '/.SB Engine/';  // I think this thing makes your storage on your phone really big because it's using from Project.xml
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
			SUtil.applicationAlert('Permissions', "if you acceptd the permissions all good if not expect a crash\nPress Ok to see what happens");
		}

		if (Permissions.getGrantedPermissions().contains(PermissionsList.READ_EXTERNAL_STORAGE) || Permissions.getGrantedPermissions().contains(PermissionsList.WRITE_EXTERNAL_STORAGE))
		{
			if (!FileSystem.exists(Tools.getExternalStorageDirectory() + '/' + '.' + Application.current.meta.get('file'))) FileSystem.createDirectory(Tools.getExternalStorageDirectory() + '/' + '.' + Application.current.meta.get('file'));

		if (!FileSystem.exists(SUtil.getPath() + 'assets') && !FileSystem.exists(SUtil.getPath() + 'mods'))
		{
			SUtil.applicationAlert('Uncaught Error!', "Whoops, seems you didn't extract the files from the .APK!\nPlease watch the tutorial by pressing OK.");
			if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Missing the assets and mods folder in engine folder", 1);
			CoolUtil.browserLoad('https://www.youtube.com/watch?v=Cm1JE_uBbYk');
		} 
		else 
			{
				if (!FileSystem.exists(SUtil.getPath() + 'assets'))
				{
					SUtil.applicationAlert('Uncaught Error!', "Whoops, seems you are missing the assets folder from the .APK to the engine folder!\nPlease watch the tutorial by pressing OK.");
					if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Missing the assets folder in engine folder", 1);
					CoolUtil.browserLoad('https://www.youtube.com/watch?v=Cm1JE_uBbYk');
				}

				if (!FileSystem.exists(SUtil.getPath() + 'mods'))
				{
					SUtil.applicationAlert('Uncaught Error!', "Whoops, seems you are missing the mods folder from the .APK to the engine folder!\nPlease watch the tutorial by pressing OK.");
					if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Missing the mods folder in engine folder", 1);
					CoolUtil.browserLoad('https://www.youtube.com/watch?v=Cm1JE_uBbYk');
				}
			}
		}
	}

	public static function saveContent(fileName:String = 'file', fileExtension:String = '.json', fileData:String = 'You forgot something to add in your code')
	{
		if (!FileSystem.exists(SUtil.getPath() + 'saves')) FileSystem.createDirectory(SUtil.getPath() + 'saves');
		File.saveContent(SUtil.getPath() + 'saves/' + fileName + fileExtension, fileData);
		if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Done! File Saved Successfully!", 1);
	}

	public static function saveClipboard(fileData:String = 'You forgot something to add in your code')
	{
		openfl.system.System.setClipboard(fileData);
		if (ClientPrefs.data.toastText) AndroidDialogsExtend.openToastBox("Done! Data Saved to Clipboard Successfully!", 1);
	}

	public static function copyContent(copyPath:String, savePath:String)
	{
		if (!FileSystem.exists(savePath))
			File.saveBytes(savePath, OpenFlAssets.getBytes(copyPath));
	}
	#end
}