// WHY CAN'T I USE SHADERFILTER.SHADER FOR A FLXSHADER ARGUMENT GUH --mcgabe19

package shaders.openfl.filters;

import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObjectRenderer;
import shaders.flixel.system.FlxShader;
import openfl.filters.BitmapFilter;

class ShaderFilter extends BitmapFilter
{
	@:dox(hide) @:noCompletion @:beta @SuppressWarnings("checkstyle:FieldDocComment")
	public var blendMode:BlendMode = NORMAL;
	public var bottomExtension(get, set):Int;
	public var leftExtension(get, set):Int;
	public var rightExtension(get, set):Int;
	public var shader:FlxShader;
	public var topExtension(get, set):Int;

	public function new(shader:FlxShader)
	{
		super();

		this.shader = shader;

		__numShaderPasses = 1;
	}

	public override function clone():BitmapFilter
	{
		var filter = new ShaderFilter(shader);
		filter.bottomExtension = bottomExtension;
		filter.leftExtension = leftExtension;
		filter.rightExtension = rightExtension;
		filter.topExtension = topExtension;
		filter.blendMode = blendMode;
		return filter;
	}

	public function invalidate():Void
	{
		__renderDirty = true;
	}

	private function get_topExtension():Int
	{
		return __topExtension;
	}

	private function set_topExtension(value:Int):Int
	{
		__topExtension = value;
		return __topExtension;
	}

	private function get_bottomExtension():Int
	{
		return __bottomExtension;
	}

	private function set_bottomExtension(value:Int):Int
	{
		__bottomExtension = value;
		return __bottomExtension;
	}

	private function get_leftExtension():Int
	{
		return __leftExtension;
	}

	private function set_leftExtension(value:Int):Int
	{
		__leftExtension = value;
		return __leftExtension;
	}

	private function get_rightExtension():Int
	{
		return __rightExtension;
	}

	private function set_rightExtension(value:Int):Int
	{
		__rightExtension = value;
		return __rightExtension;
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):FlxShader
	{
		__shaderBlendMode = blendMode;
		return shader;
	}
}
