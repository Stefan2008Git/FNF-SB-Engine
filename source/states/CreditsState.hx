package states;

import objects.AttachedSprite;

class CreditsState extends MusicBeatState
{
	var currentlySelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	public static var creditsStuff:Array<Array<String>> = [];

	var background:FlxSprite;
	var checkerboard:FlxBackdrop;
	var descText:FlxText;
	var intendedColor:FlxColor;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + MainMenuState.sbEngineVersion + " - Credits Menu";
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Credits Menus", null);
		#end

		persistentUpdate = true;
		Paths.clearStoredMemory();

		background = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		background.scrollFactor.set();
		background.setGraphicSize(Std.int(background.width * 1.175));
		background.updateHitbox();
		background.screenCenter();
		background.antialiasing = ClientPrefs.data.antialiasing;
		add(background);

		checkerboard = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		checkerboard.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		checkerboard.visible = ClientPrefs.data.checkerboard;
		add(checkerboard);
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled) pushModCreditsToList(mod);
		#end

		var defaultList:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['SB Engine Team'],
			['Stefan2008', 			'stefan', 			'Main Programmer of SB Engine', 								'https://www.youtube.com/@stefan2008official', 				'8B4513'],
			['Hutaro', 				'hutaroz', 			'Main Artist for SB Engine', 									'https://www.youtube.com/@hutaroz', 						'F8F58F'],
			['IsThePlusOpd', 		'plus', 			'Second Artist for SB Engine', 									'http://www.youtube.com/@Istheplusopd', 					'4c5695'],
			['MaysLastPlay', 		'mays', 			'Second Programmer of SB Engine', 								'https://www.youtube.com/@MaysLastPlay', 					'5E99DF'],
			['Fearester2008', 		'fearester', 		'Third Programmer of SB Engine', 								'https://www.youtube.com/@fearester1282', 					'04435a'],
			['SunBurntTails', 		'sun', 				'First Beta test player for SB Engine', 						'https://www.youtube.com/channel/UCooFjEgVBZyTSx_hbcnqclw', 'fc0000'],
			['Ali Alafandy', 		'ali', 				'Second Beta test player for SB Engine', 						'https://youtube.com/channel/UClK5uzYLZDUZmbI6O56J-QA', 	'00008b'],
			['Luiz Felipe Play', 	'luiz', 			'Third Beta test player for SB Engine', 						'https://www.youtube.com/channel/UCb0odiyqDCKje8rlBZGvKBg', '59d927'],
			[null],
			['Special credits'],
			['Sussy Sam', 			'sam', 				'Maked new icons and new music for SB Engine', 					'https://www.youtube.com/@sussysam6789',					'964B00'],
			['JustXale', 			'xale', 			'Main Programmer of Grafex Engine', 							'https://github.com/JustXale', 								'f7a300'],
			['Sayofthelor', 		'bean', 			'Main Programmer of Lore Engine', 								'https://twitter.com/sayofthelor', 							'663399'],
			['CoreCat', 			'core', 			'Used a lot of stuff from CDEV Engine. Thank you CoreCat.', 	'https://twitter.com/core5570r', 							'005FAD'],
			['GatoMago',			'mago',				'Gem note asset creator',										'https://www.youtube.com/@GatoMago_XD',						'04435a'],
			#if android
			['MarioMaster', 		'mario', 			'Created hitbox selector and virtual pad opacity', 				'https://www.youtube.com/channel/UC65m-_5tbYFJ7oRqZzpFBJw', 'fc0000'],
			['NF | Beihu', 			'beihu', 			'Created the working Kade Engine for PE on NF Engine.', 		'https://www.youtube.com/@beihu235', 						'964B00'],
			['M.A. Jigsaw77', 		'jigsaw', 			'Main Programmer of Psych Engine\nWith Android Support', 		'https://www.youtube.com/channel/UC2Sk7vtPzOvbVzdVTWrribQ', '444444'],
			['Goldie', 				'goldie', 			'Old Hitbox and Virtual Pad Artist', 							'https://www.youtube.com/channel/UCjTi9Hfl1Eb5Bgk5gksmsbA', '444444'],
			['mcagabe19', 			'lily', 			'Old Head Porter of Psych Engine Mobile',						'https://www.youtube.com/@mcagabe19', 						'FFE7C0'],
			['Karim Akra', 			'karim',            'New Head Porter of Psych Engine Mobile', 						'https://youtube.com/@Karim0690',      						'FFB4F0'],
			#end
			[null],
			['Psych Engine Team'],
			['Shadow Mario', 		'shadowmario',		'Main Programmer of Psych Engine', 								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Riveren',				'riveren', 			'Main Artist/Animator of Psych Engine', 						'https://twitter.com/riverennn', 		'14967B'],
			[null],
			['Former Engine Members'],
			['bb-panzu',			'bb',				'Ex-Programmer of Psych Engine',								'https://twitter.com/bbsub3',			'3E813A'],
			[null],
			['Engine Contributors'],
			['iFlicky',				'flicky',			'Composer of Psync and Tea Time\nMade the Dialogue Sounds',		'https://twitter.com/flicky_i',			'9E29CF'],
			['SqirraRNG',			'sqirra',			'Crash Handler and Base code for\nChart Editor\'s Waveform',	'https://twitter.com/gedehari',			'E1843A'],
			['EliteMasterEric',		'mastereric',		'Runtime Shaders support',										'https://twitter.com/EliteMasterEric',	'FFBD40'],
			['PolybiusProxy',		'proxy',			'.MP4 Video Loader Library (hxCodec)',							'https://twitter.com/polybiusproxy',	'DCD294'],
			['KadeDev',				'kade',				'Fixed some cool stuff on Chart Editor\nand other PRs',			'https://twitter.com/kade0912',			'64A250'],
			['Keoiki',				'keoiki',			'Note Splash Animations and Latin Alphabet',					'https://twitter.com/Keoiki_',			'D2D2D2'],
			['superpowers04',		'superpowers04',	'LUA JIT Fork',													'https://twitter.com/superpowers04',	'B957ED'],
			[null],
			["Funkin' Crew"],
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'", 							'https://twitter.com/ninja_muffin99',   'CF2D2D'],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",								'https://twitter.com/PhantomArcade3K',  'FADC45'],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'", 								'https://twitter.com/evilsk8r', 		'5ABD4B'],
			['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",								'https://twitter.com/kawaisprite', 		'378FC7']
		];
		
		for(i in defaultList) {
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, creditsStuff[i][0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Mods.currentModDirectory = creditsStuff[i][5];
				}

				var str:String = 'credits/missing_icon';
				if (Paths.image('credits/' + creditsStuff[i][1]) != null) str = 'credits/' + creditsStuff[i][1];
				var icon:AttachedSprite = new AttachedSprite(str);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Mods.currentModDirectory = '';

				if(currentlySelected == -1) currentlySelected = i;
			}
			else optionText.alignment = CENTERED;
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(descBox, 0, 0, 1, 1, 65, 65, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				descText.setFormat(Paths.font("bahnschrift.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
			
			case 'Dave and Bambi':
				descText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
			
			case 'TGT Engine':
				descText.setFormat(Paths.font("calibri.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
			
			default:
				descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		}
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		Paths.clearUnusedMemory();

		background.color = CoolUtil.colorFromString(creditsStuff[currentlySelected][4]);
		intendedColor = background.color;
		changeSelection();

    	#if mobile
   		addVirtualPad(UP_DOWN, A_B);
    	#end

		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[currentlySelected][3] == null || creditsStuff[currentlySelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[currentlySelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(() -> new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.bold)
			{
				var lerpVal:Float = FlxMath.bound(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			currentlySelected += change;
			if (currentlySelected < 0)
				currentlySelected = creditsStuff.length - 1;
			if (currentlySelected >= creditsStuff.length)
				currentlySelected = 0;
		} while(unselectableCheck(currentlySelected));

		var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[currentlySelected][4]);
		TraceText.makeTheTraceText('The BG color is: $newColor');
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(background, 1, background.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - currentlySelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[currentlySelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
