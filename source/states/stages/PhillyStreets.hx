package states.stages;

import objects.BGSprite;

class PhillyStreets extends BaseStage
{
    var skyAdditive:FlxSprite;
    var phillyForegroundCity:FlxSprite;
    var phillyConstruction:FlxSprite;
    var phillyHighwayLights:FlxSprite;
    var phillyHighwayLightsLightmap:FlxSprite;
    var phillyHighway:FlxSprite;
    var phillySmog:FlxSprite;
    var phillyTrafficLightmap:FlxSprite;
    var phillyForeground:FlxSprite;
    var spraycanPile:FlxSprite;

    override function create() 
    {
        skyAdditive = new BGSprite('phillyStreets/phillySkyline', -545, -273);
        skyAdditive.scrollFactor.set(0.2, 0.2);
        skyAdditive.alpha = 1;
        skyAdditive.scale.x = 1;
        skyAdditive.scale.y = 1;
        add(skyAdditive);

        phillyForegroundCity = new BGSprite('phillyStreets/phillyForegroundCity', 625, 94);
        phillyForegroundCity.scrollFactor.set(0.3, 0.3);
        phillyForegroundCity.alpha = 1;
        phillyForegroundCity.scale.x = 1;
        phillyForegroundCity.scale.y = 1;
        add(phillyForegroundCity);

        phillyConstruction = new BGSprite('phillyStreets/phillyConstruction', 1800, 364);
        phillyConstruction.scrollFactor.set(0.7, 1);
        phillyConstruction.alpha = 1;
        phillyConstruction.scale.x = 1;
        phillyConstruction.scale.y = 1;
        add(phillyConstruction);

        phillyHighwayLights = new BGSprite('phillyStreets/phillyHighwayLights', 284, 305);
        phillyHighwayLights.scrollFactor.set(1, 1);
        phillyHighwayLights.alpha = 1;
        phillyHighwayLights.scale.x = 1;
        phillyHighwayLights.scale.y = 1;
        add(phillyHighwayLights);

        phillyHighwayLightsLightmap = new BGSprite('phillyStreets/phillyHighwayLights_lightmap', 284, 305);
        phillyHighwayLightsLightmap.scrollFactor.set(1, 1);
        phillyHighwayLightsLightmap.alpha = 1;
        phillyHighwayLightsLightmap.scale.x = 1;
        phillyHighwayLightsLightmap.scale.y = 1;
        add(phillyHighwayLightsLightmap);

        phillyHighway = new BGSprite('phillyStreets/phillyHighway', 139, 209);
        phillyHighway.scrollFactor.set(1, 1);
        phillyHighway.alpha = 1;
        phillyHighway.scale.x = 1;
        phillyHighway.scale.y = 1;
        add(phillyHighway);

        phillySmog = new BGSprite('phillyStreets/phillySmog', -6, 245);
        phillySmog.scrollFactor.set(1, 1);
        phillySmog.alpha = 1;
        phillySmog.scale.x = 1;
        phillySmog.scale.y = 1;
        add(phillySmog);

        phillyTrafficLightmap = new BGSprite('phillyStreets/phillyTraffic_lightmap', 1840, 608);
        phillyTrafficLightmap.scrollFactor.set(0.9, 1);
        phillyTrafficLightmap.alpha = 1;
        phillyTrafficLightmap.scale.x = 1;
        phillyTrafficLightmap.scale.y = 1;
        add(phillyTrafficLightmap);

        phillyForeground = new BGSprite('phillyStreets/phillyForeground', 88, 317);
        phillyForeground.scrollFactor.set(1, 1);
        phillyForeground.alpha = 1;
        phillyForeground.scale.x = 1;
        phillyForeground.scale.y = 1;
        add(phillyForeground);

        spraycanPile = new BGSprite('SpraycanPile', 92, 1045);
        spraycanPile.scrollFactor.set(1, 1);
        spraycanPile.alpha = 1;
        spraycanPile.scale.x = 1;
        spraycanPile.scale.y = 1;
        add(spraycanPile);

        if (isStoryMode && !seenCutscene)
		{
			switch (songName)
			{
				case 'darnell':
					setStartCallback(darnellIntro);
				/*case 'guns':
					setStartCallback(gunsIntro);
				case 'stress':
					setStartCallback(stressIntro);*/
			}
		}
    }

    function darnellIntro()
    {
        game.startVideo('darnellCutscene');
    }
}