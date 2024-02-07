package substates;

import objects.Bar;
import states.FreeplayState;
import states.StoryMenuState;

class CustomGameOverSubstate extends MusicBeatSubstate
{
    var background:FlxSprite;
    var songAndDiffTxt:FlxText;
    var bar:Bar;
    var deathCounterTxt:FlxText;
    var timeReamingsTxt:FlxText;
    var restartButton:FlxSprite;
    var exitToMenuButton:FlxSprite;

    public function new() {
        super();

        #if !android FlxG.mouse.visible = true; #end

        background = FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(400, 400, FlxColor.TRANSPARENT), 0, 0, 400, 400, 55, 55, FlxColor.BLACK);
        background.scrollFactor.set();
        background.screenCenter();
        add(background);

        restartButton = new FlxSprite(100, -50).loadGraphic(Paths.image('restart'));
        restartButton.scrollFactor.set(1, 1);
        restartButton.screenCenter(X);
        restartButton.color = FlxColor.GREEN;
        restartButton.scale.x = 0.4;
        restartButton.scale.y = 0.4;
        add(restartButton);
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(restartButton))
		{
            restartButton.scale.x = 0.7;
            restartButton.scale.y = 0.7;
            if (FlxG.mouse.justPressed)
                FlxG.sound.play(Paths.music('gameOverEnd'));
                new FlxTimer().start(1, function(tmr:FlxTimer) { 
                    FlxG.resetState();
                    FlxTween.tween(background, {y: 50}, 0.7, {ease: FlxEase.quadInOut});
            });
		} else {
            restartButton.scale.x = 0.4;
            restartButton.scale.y = 0.4;
        }
    }
}