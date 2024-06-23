package states.stages;

import flixel.addons.display.FlxRuntimeShader;
import objects.BGSprite;
import openfl.filters.BlurFilter;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets;

class PhillyStreets extends BaseStage
{
    var phillySkyBox:FlxSprite;
    var skyAdditive:FlxSprite;
    var phillyForegroundCity:FlxSprite;
    var phillyConstruction:FlxSprite;
    var phillyHighwayLights:FlxSprite;
    var phillyHighway:FlxSprite;
    var phillySmog:FlxSprite;
    var phillyCars:FlxSprite;
    var phillyCars2:FlxSprite;
    var phillyTraffic:FlxSprite;
    var phillyTrafficLightmap:FlxSprite;
    var phillyForeground:FlxSprite;
    var spraycanPile:FlxSprite;

    // Rain shader stuff
    var rainShader:FlxRuntimeShader = new FlxRuntimeShader(Assets.getText(Paths.shaderFragment("rain")));
    var rainShaderFilter:ShaderFilter;
    var rainShaderBlurFilter:BlurFilter = new BlurFilter(6, 6);
    var rainShaderStartIntensity:Float;
    var rainShaderEndIntensity:Float;

    override function create() 
    {
        phillySkyBox = new BGSprite('phillyStreets/phillySkybox', -545, -123, 0, 0);
        phillySkyBox.scrollFactor.set(0.3, 0.3);
        phillySkyBox.alpha = 1;
        phillySkyBox.scale.x = 1;
        phillySkyBox.scale.y = 5;
        add(phillySkyBox);

        skyAdditive = new BGSprite('phillyStreets/phillySkyline', -545, -123, 0.2, 0.2);
        skyAdditive.scrollFactor.set(0.2, 0.2);
        skyAdditive.alpha = 1;
        add(skyAdditive);

        phillyForegroundCity = new BGSprite('phillyStreets/phillyForegroundCity', 625, -394, 0.3, 0.3);
        phillyForegroundCity.scrollFactor.set(0.3, 0.3);
        phillyForegroundCity.alpha = 1;
        add(phillyForegroundCity);

        phillyConstruction = new BGSprite('phillyStreets/phillyConstruction', 1800, -1064, 0.7, 1);
        phillyConstruction.scrollFactor.set(0.7, 1);
        phillyConstruction.alpha = 1;
        add(phillyConstruction);

        phillyHighwayLights = new BGSprite('phillyStreets/phillyHighwayLights', 284, 1005, 1, 1);
        phillyHighwayLights.scrollFactor.set(1, 1);
        phillyHighwayLights.alpha = 1;
        add(phillyHighwayLights);

        phillyHighway = new BGSprite('phillyStreets/phillyHighway', 139, 909, 1, 1);
        phillyHighway.scrollFactor.set(1, 1);
        phillyHighway.alpha = 1;
        add(phillyHighway);

        phillySmog = new BGSprite('phillyStreets/phillySmog', -6, 945, 1, 1);
        phillySmog.scrollFactor.set(1, 1);
        phillySmog.alpha = 1;
        add(phillySmog);

       /* phillyCars = new BGSprite('phillyStreets/phillyCars', 1748, 818, 1, 1);
		phillyCars.animation.addByPrefix('car1', "car1", 24);
		phillyCars.animation.addByPrefix('car2', "car2", 24);
		phillyCars.animation.addByPrefix('car3', "car3", 24);
		phillyCars.animation.addByPrefix('car4', "car4", 24);
		phillyCars.scale.set(1, 1);
		phillyCars.alpha = 1;
		add(phillyCars);

		phillyCars2 = new BGSprite('phillyStreets/phillyCars', 1748, 818, 1, 1);
		phillyCars2.animation.addByPrefix('car1', "car1", 24);
		phillyCars2.animation.addByPrefix('car2', "car2", 24);
		phillyCars2.animation.addByPrefix('car3', "car3", 24);
		phillyCars2.animation.addByPrefix('car4', "car4", 24);
		phillyCars2.scale.set(1, 1);
		phillyCars2.alpha = 1;
		add(phillyCars2);

		phillyTraffic = new BGSprite('phillyStreets/phillyTraffic', 1840, 608, 0.9, 1);
		phillyTraffic.animation.addByPrefix('greentored', "greentored", 24);
		phillyTraffic.animation.addByPrefix('redtogreen', "redtogreen", 24);
		phillyTraffic.scale.set(1, 1);
		phillyTraffic.alpha = 1;
		add(phillyTraffic);*/

        phillyTrafficLightmap = new BGSprite('phillyStreets/phillyTraffic_lightmap', -1840, -680, 0.9, 1);
        phillyTrafficLightmap.scrollFactor.set(0.9, 1);
        phillyTrafficLightmap.alpha = 1;
        add(phillyTrafficLightmap);

        phillyForeground = new BGSprite('phillyStreets/phillyForeground', 88, 1050, 1, 1);
        phillyForeground.scrollFactor.set(1, 1);
        phillyForeground.alpha = 1;
        add(phillyForeground);

        spraycanPile = new BGSprite('SpraycanPile', 980, 1765, 1, 1);
        spraycanPile.scrollFactor.set(1, 1);
        spraycanPile.alpha = 1;
        add(spraycanPile);

        if (isStoryMode && !seenCutscene)
		{
			switch (songName)
			{
				case 'darnell':
					setStartCallback(darnellIntro);
				case '2hot':
					setStartCallback(twoHotIntro);
			}
		}

        rainShader.setFloat('uTime', 0);
        rainShader.setFloatArray('uScreenResolution', [FlxG.width, FlxG.height]);

        switch (songName)
        {
            case 'lit-up':
                rainShaderStartIntensity = 0.1;
                rainShaderEndIntensity = 0.2;
            
            case '2hot':
                rainShaderStartIntensity = 0.2;
                rainShaderEndIntensity = 0.4;
            
            default:
                rainShaderStartIntensity = 0.0;
                rainShaderEndIntensity = 0.1;
        }

        rainShader.setFloat("uIntensity", 0.5);
        rainShaderFilter = new ShaderFilter(rainShader);

        if (ClientPrefs.data.shaders) FlxG.camera.filters = [rainShaderFilter];
    }

    function darnellIntro()
    {
        game.startVideo('darnellCutscene');
    }

    function twoHotIntro()
    {
	    game.startVideo('2hotCutscene');
    }
}
