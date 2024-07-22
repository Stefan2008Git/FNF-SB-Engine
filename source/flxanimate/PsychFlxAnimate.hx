package flxanimate;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flxanimate.frames.FlxAnimateFrames;
import flxanimate.data.AnimationData;
import flxanimate.FlxAnimate as OriginalFlxAnimate;

class PsychFlxAnimate extends OriginalFlxAnimate
{
	override public function loadAtlasEx(img:FlxGraphicAsset, pathOrStr:String = null, myJson:Dynamic = null)
	{
		super.loadAtlasEx(img, pathOrStr, myJson);
		var animJson:AnimAtlas = null;
		if(myJson is String)
		{
			var trimmed:String = pathOrStr.trim();
			trimmed = trimmed.substr(trimmed.length - 5).toLowerCase();

			if(trimmed == '.json') myJson = File.getContent(myJson); //is a path
			animJson = cast haxe.Json.parse(_removeBOM(myJson));
		}
		else animJson = cast myJson;

		var isXml:Null<Bool> = null;
		var myData:Dynamic = pathOrStr;

		var trimmed:String = pathOrStr.trim();
		trimmed = trimmed.substr(trimmed.length - 5).toLowerCase();

		if(trimmed == '.json') //Path is json
		{
			myData = File.getContent(pathOrStr);
			isXml = false;
		}
		else if (trimmed.substr(1) == '.xml') //Path is xml
		{
			myData = File.getContent(pathOrStr);
			isXml = true;
		}
		myData = _removeBOM(myData);

		// Automatic if everything else fails
		switch(isXml)
		{
			case true:
				myData = Xml.parse(myData);
			case false:
				myData = haxe.Json.parse(myData);
			case null:
				try
				{
					myData = haxe.Json.parse(myData);
					isXml = false;
					//trace('JSON parsed successfully!');
				}
				catch(e)
				{
					myData = Xml.parse(myData);
					isXml = true;
					//trace('XML parsed successfully!');
				}
		}

		anim._loadAtlas(animJson);
		if(!isXml) frames = FlxAnimateFrames.fromJson(cast myData, img);
		else frames = FlxAnimateFrames.fromSparrow(cast myData, img);
		origin = anim.curInstance.symbol.transformationPoint;
	}

	override function draw()
	{
		if(anim.curInstance == null || anim.curSymbol == null) return;
		super.draw();
	}

	override function destroy()
	{
		try
		{
			super.destroy();
		}
		catch(e:haxe.Exception)
		{
			anim.curInstance = null;
			anim.stageInstance = null;
			anim.metadata = null;
			anim.symbolDictionary = null;
		}
	}

	override function _removeBOM(str:String) //Removes BOM byte order indicator
	{
		super._removeBOM(str);
		if (str.charCodeAt(0) == 0xFEFF) str = str.substr(1); //myData = myData.substr(2);
		return str;
	}

	public function pauseAnimation()
	{
		if(anim.curInstance == null || anim.curSymbol == null) return;
		anim.pause();
	}
	public function resumeAnimation()
	{
		if(anim.curInstance == null || anim.curSymbol == null) return;
		anim.play();
	}
}