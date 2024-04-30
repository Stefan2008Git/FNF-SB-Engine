package substates.system;

class CrashHandlerSubstate extends MusicBeatSubstate
{
    var background:FlxSprite;
    var crashText:FlxText;
    var restartButton:FlxSprite;
    var restartText:FlxText;
    var exitButton:FlxSprite;
    var exitText:FlxText;

    public function new() {
        super();

        background = FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(1175, 685, FlxColor.TRANSPARENT), 0, 0, 1175, 685, 65, 65, FlxColor.BLACK);
	    background.updateHitbox();
	    background.alpha = 0.6;
	    background.screenCenter();
	    add(background);

        crashText = new FlxText(0, 0, 600, "Engine unexpectedly crashed and here's why:\n", Main.errorMessage);
        crashText.screenCenter();
        switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				crashText.setFormat("Bahnschrift", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			case 'Dave and Bambi':
				crashText.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			case 'TGT Engine':
				crashText.setFormat("Calibri", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

            default:
				crashText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
        crashText.borderSize = 1;
        crashText.scrollFactor.x = 0;
		crashText.scrollFactor.y = 0;
        add(crashText);
    }
}