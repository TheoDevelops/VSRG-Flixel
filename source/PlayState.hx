package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import vsrg.core.PlayField;
import vsrg.core.audio.Playback;

class PlayState extends FlxState
{
	var background:FlxSprite;
	var playField:PlayField;
	var musicPlayback:Playback;

	override public function create()
	{
		super.create();

		background = new FlxSprite();
		background.loadGraphic(AssetPaths.background__png);
		background.setGraphicSize(FlxG.width, FlxG.height);
		background.updateHitbox();
		background.screenCenter();
		add(background);

		musicPlayback = new Playback();
		musicPlayback.bpm = 174;
		musicPlayback.offset = -0.045 * 1000;
		add(musicPlayback);

		playField = new PlayField(musicPlayback);
		playField.load('');
		add(playField);

		musicPlayback.onBeat.add((b) ->
		{
			FlxG.sound.play(b % musicPlayback.beatsPerMeasure == 0 ? AssetPaths.tick1__ogg : AssetPaths.tick2__ogg);
		});

		FlxG.sound.playMusic(AssetPaths.Try_This__ogg);
		FlxG.sound.music.volume -= 0.2;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
