package backend;

import backend.ClientPrefs;

class Rating
{
	public var name:String = '';
	public var image:String = '';
	public var hitWindow:Null<Int> = 0; //ms
	public var ratingMod:Float = 1;
	public var score:Int = 350;
	public var noteSplash:Bool = true;
	public var hits:Int = 0;

	public function new(name:String):Void
	{
		this.name = name = this.image = name;
		this.hitWindow = 0;

		try {
			this.hitWindow = Reflect.field(ClientPrefs.data, '${name}Window');
		} catch (e:Dynamic) {
			FlxG.log.error(e);
		}
	}

	public static function loadDefault():Array<Rating>
	{
		final ratingsData:Array<Rating> = [new Rating('sick')];
		final otherRatings:Array<String> = ['good', 'bad', 'shit'];
		for (i in 0...otherRatings.length) {
			final rating:Rating = new Rating(otherRatings[i]);
			rating.ratingMod = .68 - .68 * i * .5;
			rating.score = cast 200 * Math.pow(.5, i);
			rating.noteSplash = false;
			ratingsData.push(rating);
		}
		return ratingsData;
	}
}
