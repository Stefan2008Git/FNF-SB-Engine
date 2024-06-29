package states.stages;

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

    var lightsStop:Bool = false;
    var lastChange:Int = 0;
    var changeInterval:Int = 8;
    var carWaiting:Bool = false;
    var carInterruptable:Bool = true;
    var car2Interruptable:Bool = true;

    override function create() 
    {
        phillySkyBox = new BGSprite('phillyStreets/phillySkybox', -545, -123);
        phillySkyBox.scrollFactor.set(0, 0);
        phillySkyBox.alpha = 1;
        phillySkyBox.scale.x = 1;
        phillySkyBox.scale.y = 5;
        add(phillySkyBox);

        skyAdditive = new BGSprite('phillyStreets/phillySkyline', -545, -123);
        skyAdditive.scrollFactor.set(0.2, 0.2);
        skyAdditive.alpha = 1;
        add(skyAdditive);

        phillyForegroundCity = new BGSprite('phillyStreets/phillyForegroundCity', 625, -394);
        phillyForegroundCity.scrollFactor.set(0.3, 0.3);
        phillyForegroundCity.alpha = 1;
        add(phillyForegroundCity);

        phillyConstruction = new BGSprite('phillyStreets/phillyConstruction', 1800, -1064);
        phillyConstruction.scrollFactor.set(0.7, 1);
        phillyConstruction.alpha = 1;
        add(phillyConstruction);

        phillyHighwayLights = new BGSprite('phillyStreets/phillyHighwayLights', 284, 1005);
        phillyHighwayLights.scrollFactor.set(1, 1);
        phillyHighwayLights.alpha = 1;
        add(phillyHighwayLights);

        phillyHighway = new BGSprite('phillyStreets/phillyHighway', 139, 909);
        phillyHighway.scrollFactor.set(1, 1);
        phillyHighway.alpha = 1;
        add(phillyHighway);

        phillySmog = new BGSprite('phillyStreets/phillySmog', -6, 945);
        phillySmog.scrollFactor.set(1, 1);
        phillySmog.alpha = 1;
        add(phillySmog);

        phillyCars = new FlxSprite(1748, 818);
        phillyCars.frames = Paths.getSparrowAtlas('phillyStreets/phillyCars');
        phillyCars.animation.addByPrefix('phillyCars', 'car1', 24, false);
        phillyCars.animation.addByPrefix('phillyCars', 'car2', 24, false);
        phillyCars.animation.addByPrefix('phillyCars', 'car3', 24, false);
        phillyCars.animation.addByPrefix('phillyCars', 'car4', 24, false);
        phillyCars.flipX = false;
		phillyCars.scale.set(1, 1);
		phillyCars.alpha = 1;
		add(phillyCars);

		phillyCars2 = new FlxSprite(1748, 818);
        phillyCars2.frames = Paths.getSparrowAtlas('phillyStreets/phillyCars');
        phillyCars2.animation.addByPrefix('phillyCars2', 'car1', 24, false);
        phillyCars2.animation.addByPrefix('phillyCars2', 'car2', 24, false);
        phillyCars2.animation.addByPrefix('phillyCars2', 'car3', 24, false);
        phillyCars2.animation.addByPrefix('phillyCars2', 'car4', 24, false);
        phillyCars2.flipX = true;
		phillyCars2.scale.set(1, 1);
		phillyCars2.alpha = 1;
		add(phillyCars2);

        phillyTraffic = new FlxSprite(1840, 608);
        phillyTraffic.frames = Paths.getSparrowAtlas('phillyStreets/phillyTraffic');
        phillyTraffic.animation.addByPrefix('tored', 'redtogreen', 24, false);
        phillyTraffic.animation.addByPrefix('togreen', 'greentored', 24, false);
        phillyTraffic.scale.set(0.9, 1);
		phillyTraffic.alpha = 1;
		add(phillyTraffic);

        phillyTrafficLightmap = new BGSprite('phillyStreets/phillyTraffic_lightmap', -1840, -680);
        phillyTrafficLightmap.scrollFactor.set(0.9, 1);
        phillyTrafficLightmap.alpha = 1;
        add(phillyTrafficLightmap);

        phillyForeground = new BGSprite('phillyStreets/phillyForeground', 88, 1050);
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
                case 'blazin':
                    setEndCallback(blazinOutro);
			}
		}

        resetCar(true, true);
        resetStageValues();
    }

    override function createPost()
    {
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
                rainShaderStartIntensity = 0;
                rainShaderEndIntensity = 0;
        }

        rainShader.setFloat("uIntensity", 0.5);
        rainShaderFilter = new ShaderFilter(rainShader);

        if (ClientPrefs.data.shaders) game.camGame = [rainShaderFilter];
        addBehindDad(spraycanPile);
    }

    function darnellIntro()
    {
        game.startVideo('darnellCutscene');
    }

    function twoHotIntro()
    {
	    game.startVideo('2hotCutscene');
    }

    function blazinOutro()
    {
        game.startVideo('blazinCutscene');
    }

    function changeLights(beat:Int):Void{

        lastChange = beat;
        lightsStop = !lightsStop;
    
        if(lightsStop){
            phillyTraffic.animation.play('tored');
            changeInterval = 20;
        } else {
            phillyTraffic.animation.play('togreen');
            changeInterval = 30;
    
            if(carWaiting == true) finishCarLights(phillyCars);
        }
    }

    function resetCar(left:Bool, right:Bool){
        if (left){
            carWaiting = false;
            carInterruptable = true;
            var cars = phillyCars;
            if (cars != null) {
                FlxTween.cancelTweensOf(cars);
                cars.x = 1200;
                cars.y = 818;
                cars.angle = 0;
            }
        }
    
        if(right){
            car2Interruptable = true;
            var cars2 = phillyCars2;
            if (cars2 != null) {
                FlxTween.cancelTweensOf(cars2);
                phillyCars2.flipX = true;
                phillyCars2.x = 1200;
                phillyCars2.y = 818;
                phillyCars2.angle = 0;
            }
        }
    }

    function finishCarLights(sprite:FlxSprite):Void
    {
        carWaiting = false;
        var duration:Float = FlxG.random.float(1.8, 3);
        var rotations:Array<Int> = [-5, 18];
        var offset:Array<Float> = [306.6, 168.3];
        var startdelay:Float = FlxG.random.float(0.2, 1.2);
    
        var path:Array<FlxPoint> = [
            FlxPoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15),
            FlxPoint.get(2400 - offset[0], 980 - offset[1] - 50),
            FlxPoint.get(3102 - offset[0], 1127 - offset[1] + 40)
        ];
    
        FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.sineIn, startDelay: startdelay});
        FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: FlxEase.sineIn,
            startDelay: startdelay,
            onComplete: function(_) {
            carInterruptable = true;
            }
        });
    }

    function driveCarLights(sprite:FlxSprite):Void{
        carInterruptable = false;
        FlxTween.cancelTweensOf(sprite);
        var variant:Int = FlxG.random.int(1,4);
        sprite.animation.play('car' + variant);
        var extraOffset = [0, 0];
        var duration:Float = 2;
    
        switch(variant) {
            case 1:
                duration = FlxG.random.float(1, 1.7);
            case 2:
                extraOffset = [20, -15];
                duration = FlxG.random.float(0.9, 1.5);
            case 3:
                extraOffset = [30, 50];
                duration = FlxG.random.float(1.5, 2.5);
            case 4:
                extraOffset = [10, 60];
                duration = FlxG.random.float(1.5, 2.5);
        }
        var rotations:Array<Int> = [-7, -5];
        var offset:Array<Float> = [306.6, 168.3];
        sprite.offset.set(extraOffset[0], extraOffset[1]);
    
        var path:Array<FlxPoint> = [
            FlxPoint.get(1500 - offset[0] - 20, 1049 - offset[1] - 20),
            FlxPoint.get(1770 - offset[0] - 80, 994 - offset[1] + 10),
            FlxPoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15)
        ];
        
        FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.cubeOut} );
            FlxTween.quadPath(sprite, path, duration, true,
            {
                ease: FlxEase.cubeOut,
                onComplete: function(_) {
                carWaiting = true;
                if(lightsStop == false) finishCarLights(phillyCars);
            }
        });
    }

    function driveCar(sprite:FlxSprite):Void{
        carInterruptable = false;
        FlxTween.cancelTweensOf(sprite);
        var variant:Int = FlxG.random.int(1,4);
        sprite.animation.play('car' + variant);
        var extraOffset = [0, 0];
        var duration:Float = 2;
        switch(variant){
            case 1:
                duration = FlxG.random.float(1, 1.7);
            case 2:
                extraOffset = [20, -15];
                duration = FlxG.random.float(0.6, 1.2);
            case 3:
                extraOffset = [30, 50];
                duration = FlxG.random.float(1.5, 2.5);
            case 4:
                extraOffset = [10, 60];
                duration = FlxG.random.float(1.5, 2.5);
        }
        var offset:Array<Float> = [306.6, 168.3];
        sprite.offset.set(extraOffset[0], extraOffset[1]);
        var rotations:Array<Int> = [-8, 18];
        var path:Array<FlxPoint> = [
                FlxPoint.get(1570 - offset[0], 1049 - offset[1] - 30),
                FlxPoint.get(2400 - offset[0], 980 - offset[1] - 50),
                FlxPoint.get(3102 - offset[0], 1127 - offset[1] + 40)
        ];
    
        FlxTween.angle(sprite, rotations[0], rotations[1], duration, null );
        FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: null,
            onComplete: function(_) {
            carInterruptable = true;
            }
        });
    }

    function driveCarBack(sprite:FlxSprite):Void{
        car2Interruptable = false;
        FlxTween.cancelTweensOf(sprite);
        var variant:Int = FlxG.random.int(1,4);
        sprite.animation.play('car' + variant);


        var extraOffset = [0, 0];
        var duration:Float = 2;

        switch(variant){
            case 1:
                duration = FlxG.random.float(1, 1.7);
            case 2:
                extraOffset = [20, -15];
                duration = FlxG.random.float(0.6, 1.2);
            case 3:
                extraOffset = [30, 50];
                duration = FlxG.random.float(1.5, 2.5);
            case 4:
                extraOffset = [10, 60];
                duration = FlxG.random.float(1.5, 2.5);
        }
        

        var offset:Array<Float> = [306.6, 168.3];
        sprite.offset.set(extraOffset[0], extraOffset[1]);

        var rotations:Array<Int> = [18, -8];

        var path:Array<FlxPoint> = [
            FlxPoint.get(3102 - offset[0], 1127 - offset[1] + 60),
            FlxPoint.get(2400 - offset[0], 980 - offset[1] - 30),
            FlxPoint.get(1570 - offset[0], 1049 - offset[1] - 10)
        ];
    
        FlxTween.angle(sprite, rotations[0], rotations[1], duration, null );
        FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: null,
            onComplete: function(_) {
            car2Interruptable = true;
            }
        });
    }

    function resetStageValues():Void
    {
        lastChange = 0;
        changeInterval = 8;
        var traffic = phillyTraffic;
        if (traffic != null) {
            traffic.animation.play('togreen');
        }
        lightsStop = false;
    }

    override function update(elapsed:Float) {
        var remappedIntensityValue:Float = FlxMath.remapToRange(Conductor.songPosition, 0, FlxG.sound.music != null ? FlxG.sound.music.length : 0.0, rainShaderStartIntensity, rainShaderEndIntensity);
        rainShader.setFloat("uIntensity", remappedIntensityValue);
        rainShader.setFloat("uTime", rainShader.getFloat("uTime") +  elapsed);
        rainShader.setFloatArray("uCameraBounds", [FlxG.camera.scroll.x + FlxG.camera.viewMarginX, FlxG.camera.scroll.y + FlxG.camera.viewMarginY, FlxG.camera.scroll.x + FlxG.camera.width, FlxG.camera.scroll.y + FlxG.camera.height]);

        switch (songName)
        {
            case 'lit-up':
                rainShaderStartIntensity = 0.1;
                rainShaderEndIntensity = 0.2;
            
            case '2hot':
                rainShaderStartIntensity = 0.2;
                rainShaderEndIntensity = 0.4;
            
            default:
                rainShaderStartIntensity = 0;
                rainShaderEndIntensity = 0;
        }
    }

    var beat:Int;
    override function beatHit()
    {
        if (FlxG.random.bool(10) && beat != (lastChange + changeInterval) && carInterruptable == true)
        {
            if (lightsStop == false) {
                    driveCar(phillyCars);
            } else {
                driveCarLights(phillyCars);
            }
        }
        
        if(FlxG.random.bool(10) && beat != (lastChange + changeInterval) && car2Interruptable == true && lightsStop == false) driveCarBack(phillyCars2);
        if (beat == (lastChange + changeInterval)) changeLights(beat);
    }

    override function destroy()
    {
        var cars = phillyCars;
        if (cars != null) FlxTween.cancelTweensOf(cars);
        var cars2 = phillyCars2;
        if (cars2 != null) FlxTween.cancelTweensOf(cars2);
    }
}