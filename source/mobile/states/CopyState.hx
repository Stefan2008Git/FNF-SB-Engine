package mobile.states;

#if mobile
import main.Init;
import states.TitleState;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFLAssets;
import flixel.addons.util.FlxAsyncLoop;
import openfl.utils.ByteArray;
import haxe.io.Path;

/**
 * ...
 * @author: Karim Akra
 */
class CopyState extends MusicBeatState
{
	public static var locatedFiles:Array<String> = [];
	public static var maxLoopTimes:Int = 0;
	public static final IGNORE_FOLDER_FILE_NAME:String = "ignore.txt";

	public var loadingImage:FlxSprite;
	public var bottomBG:FlxSprite;
	public var loadedText:FlxText;
	public var loadingText:FlxText;
	var bar:FlxSprite;
	var barWidth:Int = 0;
	public var copyLoop:FlxAsyncLoop;

	var loopTimes:Int = 0;
	var failedFiles:Array<String> = [];
	var failedFilesStack:Array<String> = [];
	var canUpdate:Bool = true;
	var shouldCopy:Bool = false;

	private static final textFilesExtensions:Array<String> = ['ini', 'txt', 'xml', 'hxs', 'hx', 'lua', 'json', 'frag', 'vert'];

	override function create()
	{
		locatedFiles = [];
		maxLoopTimes = 0;
		checkExistingFiles();
		if (maxLoopTimes <= 0)
		{
			FlxG.switchState(() -> new Init());
			return;
		}

		#if !ios
		CoolUtil.showPopUp("Seems like you have some missing files that are necessary to run the game\nPress OK to begin the copy process", "Notice!");
		#end
		
		shouldCopy = true;

		add(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xffcaff4d));

		loadingImage = new FlxSprite(0, 0, Paths.image('menuDesat'));
		loadingImage.updateHitbox();
		loadingImage.screenCenter();
		loadingImage.color = FlxColor.GREEN;
		add(loadingImage);

		bottomBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, FlxColor.BLACK);
		bottomBG.alpha = 0.6;
		add(bottomBG);

		loadingText = new FlxText(520, 600, 400, Language.getPhrase('now_loading', 'Now Loading', ['...']), 32);
		loadingText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		loadingText.borderSize = 2;
		add(loadingText);

		var bg:FlxSprite = new FlxSprite(0, 660).makeGraphic(1, 1, FlxColor.BLACK);
		bg.scale.set(FlxG.width - 300, 25);
		bg.updateHitbox();
		bg.screenCenter(X);
		add(bg);

		bar = new FlxSprite(bg.x + 5, bg.y + 5).makeGraphic(1, 1, FlxColor.GREEN);
		bar.scale.set(0, 15);
		bar.updateHitbox();
		add(bar);
		barWidth = Std.int(bg.width - 10);

		loadedText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width, '', 16);
		loadedText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER);
		add(loadedText);

		var ticks:Int = 15;
		if (maxLoopTimes <= 15)
			ticks = 1;

		copyLoop = new FlxAsyncLoop(maxLoopTimes, copyAsset, ticks);
		add(copyLoop);
		copyLoop.start();

		super.create();
	}

	var timePassed:Float;
	override function update(elapsed:Float)
	{
		timePassed += elapsed;
		var dots:String = '';
		switch(Math.floor(timePassed % 1 * 3))
		{
			case 0:
				dots = '.';
			case 1:
				dots = '..';
			case 2:
				dots = '...';
		}
		loadingText.text = Language.getPhrase('now_loading', 'Now Loading{1}', [dots]);

		if (shouldCopy && copyLoop != null)
		{
			if (copyLoop.finished && canUpdate)
			{
				if (failedFiles.length > 0)
				{
					#if !ios
					CoolUtil.showPopUp(failedFiles.join('\n'), 'Failed To Copy ${failedFiles.length} File.');
					#end
					if (!FileSystem.exists('logs'))
						FileSystem.createDirectory('logs');
					File.saveContent('logs/' + Date.now().toString().replace(' ', '-').replace(':', "'") + '-CopyState' + '.logs', failedFilesStack.join('\n'));
				}
				canUpdate = false;
				FlxG.sound.play(Paths.sound('confirmMenu')).onComplete = () -> {
					FlxG.switchState(() -> new Init());
				};
			}

			if (loopTimes == maxLoopTimes)
				loadedText.text = "Completed!";
			else
				loadedText.text = 'Assets needed: $loopTimes/$maxLoopTimes';
				bar.scale.x = barWidth * loopTimes / maxLoopTimes * 100;
				bar.updateHitbox();
		}
		super.update(elapsed);
	}

	public function copyAsset()
	{
		var file = locatedFiles[loopTimes];
		loopTimes++;
		if (!FileSystem.exists(file))
		{
			var directory = Path.directory(file);
			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);
			try
			{
				if (OpenFLAssets.exists(getFile(file)))
				{
					if (textFilesExtensions.contains(Path.extension(file)))
						createContentFromInternal(file);
					else
						File.saveBytes(file, getFileBytes(getFile(file)));
				}
				else
				{
					failedFiles.push(getFile(file) + " (File Dosen't Exist)");
					failedFilesStack.push('Asset ${getFile(file)} does not exist.');
				}
			}
			catch (e:haxe.Exception)
			{
				failedFiles.push('${getFile(file)} (${e.message})');
				failedFilesStack.push('${getFile(file)} (${e.stack})');
			}
		}
	}

	public function createContentFromInternal(file:String)
	{
		var fileName = Path.withoutDirectory(file);
		var directory = Path.directory(file);
		try
		{
			var fileData:String = OpenFLAssets.getText(getFile(file));
			if (fileData == null)
				fileData = '';
			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);
			File.saveContent(Path.join([directory, fileName]), fileData);
		}
		catch (e:haxe.Exception)
		{
			failedFiles.push('${getFile(file)} (${e.message})');
			failedFilesStack.push('${getFile(file)} (${e.stack})');
		}
	}

	public function getFileBytes(file:String):ByteArray
	{
		switch (Path.extension(file))
		{
			case 'otf' | 'ttf':
				return ByteArray.fromFile(file);
			default:
				return OpenFLAssets.getBytes(file);
		}
	}

	public static function getFile(file:String):String
	{
		if(OpenFLAssets.exists(file)) return file;

		@:privateAccess
		for(library in LimeAssets.libraries.keys()){
			if(OpenFLAssets.exists('$library:$file') && library != 'default')
				return '$library:$file';
		}

		return file;
	}

	public static function checkExistingFiles():Bool
	{
		locatedFiles = OpenFLAssets.list();
		
		// removes unwanted assets
		var assets = locatedFiles.filter(folder -> folder.startsWith('assets/'));
		var mods = locatedFiles.filter(folder -> folder.startsWith('mods/'));
		locatedFiles = assets.concat(mods);

		var filesToRemove:Array<String> = [];

		for (file in locatedFiles)
		{
			if (FileSystem.exists(file) || OpenFLAssets.exists(getFile(Path.join([Path.directory(getFile(file)), IGNORE_FOLDER_FILE_NAME]))))
			{
				filesToRemove.push(file);
			}
		}

		for (file in filesToRemove)
			locatedFiles.remove(file);

		maxLoopTimes = locatedFiles.length;

		return (maxLoopTimes <= 0);
	}
}
#end
