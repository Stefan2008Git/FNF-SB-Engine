package states;

import objects.Bar;

class LoadingMenuState extends MusicBeatState
{
    var mainBackground:FlxSprite;
    var mainChecker:FlxBackdrop;
    var mainLogo:FlxSprite;
    var mainText:FlxText;
    var mainLoaderSpin:FlxSprite;
	var mainLoadingBar:Bar;
    var randomText:FlxText;
	var icons:FlxSprite;
	var creditTexts:FlxText;
    var tweening:Bool;
    var timer:Float = 0;
    var string:String = '';
	var loadingTime:Float = 0;
	public static var sillyIcons:Array<String> = ['stefan', 'hutaroz', 'mays', 'fearester'];
	public static var sillyTexts:Array<String> = ['Stefan2008', 'Hutaro', 'MaysLastPlays', 'Fearester2008'];

    override function create()
    {
        #if DISCORD_ALLOWED DiscordClient.changePresence("In the Loading Screen Menu", null); #end
        Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Loading...";
		FlxG.sound.playMusic(Paths.music('titleMenu/loadingMusic'), 1); // Credits: Roblox Corporation
		FlxG.mouse.visible = false;
        super.create();

        mainBackground = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		mainBackground.antialiasing = ClientPrefs.data.antialiasing;
        mainBackground.screenCenter();
        mainBackground.color = FlxColor.BROWN;
		add(mainBackground);

        mainChecker = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		mainChecker.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		mainChecker.visible = ClientPrefs.data.velocityBackground;
		mainChecker.screenCenter();
		add(mainChecker);

        mainLogo = new FlxSprite().loadGraphic(Paths.image("sbEngineLogo"));
		mainLogo.screenCenter();
		mainLogo.antialiasing = ClientPrefs.data.antialiasing;
		FlxTween.angle(mainLogo, mainLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
        new FlxTimer().start(2, function(tmr:FlxTimer) {
			if (mainLogo.angle == -10)
				FlxTween.angle(mainLogo, mainLogo.angle, 10, 2, {ease: FlxEase.sineInOut});
			else
				FlxTween.angle(mainLogo, mainLogo.angle, -10, 2, {ease: FlxEase.sineInOut});
		}, 0);
		add(mainLogo);

		mainLoadingBar = new Bar(0, FlxG.height * 0.94, 'loadingBar', function() return loadingTime, 0, 15);
		mainLoadingBar.screenCenter(X);
		mainLoadingBar.leftBar.color = FlxColor.BROWN;
		mainLoadingBar.rightBar.color = 0xFF1A1A1A;
		updateBarPercent();
		add(mainLoadingBar);

        mainText = new FlxText(1120, FlxG.height - 50, 0, "Loading...", 8);
		mainText.scrollFactor.set();
		mainText.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		mainText.borderSize = 1.25;
		add(mainText);

        mainLoaderSpin = new FlxSprite().loadGraphic(Paths.image("loadingSpeen"));
		mainLoaderSpin.screenCenter(X);
		mainLoaderSpin.setGraphicSize(Std.int(mainLoaderSpin.width * 0.89));
		mainLoaderSpin.x = FlxG.width - 130;
		mainLoaderSpin.y = FlxG.height - 130;
		mainLoaderSpin.angularVelocity = 180;
		mainLoaderSpin.antialiasing = ClientPrefs.data.antialiasing;
		add(mainLoaderSpin);

        randomText = new FlxText(20, FlxG.height - 80, 1000, "", 26);
		randomText.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(randomText);

		icons = new FlxSprite(40, FlxG.height * 0.78).loadGraphic(randomCreditIcons());
		icons.antialiasing = ClientPrefs.data.antialiasing;
		icons.setGraphicSize(Std.int(icons.width * 0.89));
		add(icons);

		creditTexts = new FlxText(30, FlxG.height * 0.95, "");
		creditTexts.scrollFactor.set();
		creditTexts.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		randomCreditText();
		add(creditTexts);

        super.create();
    }

    override function update(elapsed:Float) 
    {
        if (tweening) {
            randomText.screenCenter(X);
            timer = 0;
        } else {
            randomText.screenCenter(X);
            timer += elapsed;
            if (timer >= 3) {
                changeText();
            }
        }

		loadingTime += elapsed;
		if (loadingTime >= 15) {
			switchToTitleMenu();
		}
        super.update(elapsed);
    }

    function changeText() {
		var selectedText:String = '';
		var textArray:Array<String> = CoolUtil.coolTextFile(SUtil.getPath() + Paths.txt('loadingTips'));

		randomText.alpha = 1;
		tweening = true;
		selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))].replace('--', '\n');
		FlxTween.tween(randomText, {alpha: 0}, 1, {
			ease: FlxEase.linear,
			onComplete: function(freak:FlxTween) {
				if (selectedText != string) {
					randomText.text = selectedText;
					string = selectedText;
				} else {
					selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))].replace('--', '\n');
					randomText.text = selectedText;
				}

				randomText.alpha = 0;

				FlxTween.tween(randomText, {alpha: 1}, 1, {
					ease: FlxEase.linear,
					onComplete: function(freak:FlxTween) {
						tweening = false;
					}
				});
			}
		});
	}

	function switchToTitleMenu() {
		FlxTween.tween(FlxG.sound, {volume: 0}, 0.2);
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.sound.destroy();
			FlxG.switchState(() -> new TitleState());
		});
	}

	public var barTween:FlxTween = null;
	var val1:Float = 1;
	var val2:Float = 15;
	function updateBarPercent() {
		barTween = FlxTween.tween(mainLoadingBar, {percent: (val1 / val2) * 100}, 0.5, {ease: FlxEase.sineInOut,
			onComplete: function(twn:FlxTween) mainLoadingBar.updateBar(),
			onUpdate: function(twn:FlxTween) mainLoadingBar.updateBar()
		});
	}

	public function randomCreditIcons()
	{
		var iconChance:Int = FlxG.random.int(0, sillyIcons.length - 1);
		return Paths.image('credits/${sillyIcons[iconChance]}');
	}

	public function randomCreditText()
	{
		var textChance:Int = FlxG.random.int(0, sillyTexts.length - 1);
		return creditTexts.text = sillyTexts[textChance];
	}
}
