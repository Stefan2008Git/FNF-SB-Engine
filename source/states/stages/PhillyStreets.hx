package states.stages;

import objects.BGSprite;

class PhillyStreets extends BaseStage
{
    var phillySkyBox:FlxSprite;
    var skyAdditive:FlxSprite;
    var phillyForegroundCity:FlxSprite;
    var phillyConstruction:FlxSprite;
    var phillyHighwayLights:FlxSprite;
    var phillyHighwayLightsLightmap:FlxSprite;
    var phillyHighway:FlxSprite;
    var phillySmog:FlxSprite;
    var phillyTraffic:FlxSprite;
    var phillyTrafficLightmap:FlxSprite;
    var phillyForeground:FlxSprite;
    var spraycanPile:FlxSprite;

    override function create() 
    {
        phillySkyBox = new BGSprite('phillyStreets/phillySkybox', -700, -200);
        phillySkyBox.scrollFactor.set(0.3, 0.3);
        phillySkyBox.alpha = 1;
        phillySkyBox.scale.x = 1;
        phillySkyBox.scale.y = 5;
        add(phillySkyBox);

        skyAdditive = new BGSprite('phillyStreets/phillySkyline', -700, -300);
        skyAdditive.scrollFactor.set(0.2, 0.2);
        skyAdditive.alpha = 1;
        skyAdditive.scale.x = 1;
        skyAdditive.scale.y = 1;
        add(skyAdditive);

        phillyForegroundCity = new BGSprite('phillyStreets/phillyForegroundCity', 350, -20);
        phillyForegroundCity.scrollFactor.set(0.3, 0.3);
        phillyForegroundCity.alpha = 1;
        phillyForegroundCity.scale.x = 1;
        phillyForegroundCity.scale.y = 1;
        add(phillyForegroundCity);

        phillyConstruction = new BGSprite('phillyStreets/phillyConstruction', 1000, -150);
        phillyConstruction.scrollFactor.set(0.7, 1);
        phillyConstruction.alpha = 1;
        phillyConstruction.scale.x = 1;
        phillyConstruction.scale.y = 1;
        add(phillyConstruction);

        phillyHighwayLights = new BGSprite('phillyStreets/phillyHighwayLights', -1050, -205);
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

        phillyHighway = new BGSprite('phillyStreets/phillyHighway', -1130, -250);
        phillyHighway.scrollFactor.set(1, 1);
        phillyHighway.alpha = 1;
        phillyHighway.scale.x = 1;
        phillyHighway.scale.y = 1;
        add(phillyHighway);

        phillySmog = new BGSprite('phillyStreets/phillySmog', -1000, -200);
        phillySmog.scrollFactor.set(1, 1);
        phillySmog.alpha = 1;
        phillySmog.scale.x = 1;
        phillySmog.scale.y = 1;
        add(phillySmog);

        phillyTraffic = new BGSprite('phillyStreets/phillyTraffic', 1840, 608);
        phillyTraffic.scrollFactor.set(0.9, 1);
        phillyTraffic.alpha = 1;
        phillyTraffic.scale.x = 1;
        phillyTraffic.scale.y = 1;
        add(phillyTraffic);

        phillyTrafficLightmap = new BGSprite('phillyStreets/phillyTraffic_lightmap', -1100, -100);
        phillyTrafficLightmap.scrollFactor.set(0.9, 1);
        phillyTrafficLightmap.alpha = 1;
        phillyTrafficLightmap.scale.x = 1;
        phillyTrafficLightmap.scale.y = 1;
        add(phillyTrafficLightmap);

        phillyForeground = new BGSprite('phillyStreets/phillyForeground', -1430, -250);
        phillyForeground.scrollFactor.set(1, 1);
        phillyForeground.alpha = 1;
        phillyForeground.scale.x = 1;
        phillyForeground.scale.y = 1;
        add(phillyForeground);

        spraycanPile = new BGSprite('SpraycanPile', -320, 630);
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