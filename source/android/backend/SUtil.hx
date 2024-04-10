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
			if (!Permissions.getGrantedPermissions().contains(PermissionsList.READ_EXTERNAL_STORAGE)) Permissions.requestPermission(PermissionsList.READ_EXTERNAL_STORAGE);
			if (!Permissions.getGrantedPermissions().contains(PermissionsList.WRITE_EXTERNAL_STORAGE)) Permissions.requestPermission(PermissionsList.WRITE_EXTERNAL_STORAGE);
			applicationAlert('Permissions', "if you acceptd the permissions all good if not expect a crash" + '\n' + 'Press Ok to see what happens');
		}
	}

	public static function mkDirs(directory:String):Void
	{
		var total:String = '';
		if (directory.substr(0, 1) == '/')
			total = '/';

		var parts:Array<String> = directory.split('/');
		if (parts.length > 0 && parts[0].indexOf(':') > -1)
			parts.shift();

		for (part in parts)
		{
			if (part != '.' && part != '')
			{
				if (total != '' && total != '/')
					total += '/';

				total += part;

				if (!FileSystem.exists(total))
					FileSystem.createDirectory(total);
			}
		}
	}

	public static function saveContent(fileName:String = 'file', fileExtension:String = '.json', fileData:String = 'You forgot something to add in your code')
	{
		if (!FileSystem.exists(SUtil.getPath() + 'saves'))
			FileSystem.createDirectory(SUtil.getPath() + 'saves');

		File.saveContent(SUtil.getPath() + 'saves/' + fileName + fileExtension, fileData);
		var toastFileSaveText:String = '';
		toastFileSaveText = 'Done! File Saved Successfully!';
		AndroidDialogsExtend.OpenToast(toastFileSaveText, 2);
	}

	public static function saveClipboard(fileData:String = 'You forgot something to add in your code')
	{
		openfl.system.System.setClipboard(fileData);
		var toastClipboardSaveText:String = '';
		toastClipboardSaveText = 'Done! Data Saved to Clipboard Successfully!';
		AndroidDialogsExtend.OpenToast(toastClipboardSaveText, 2);
	}

	public static function copyContent(copyPath:String, savePath:String)
	{
		if (!FileSystem.exists(savePath))
			File.saveBytes(savePath, OpenFlAssets.getBytes(copyPath));
	}
	#end
}
