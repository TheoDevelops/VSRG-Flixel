package vsrg.core.arrows;

import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import vsrg.core.Constants;
import vsrg.core.format.ArrowData;

using StringTools;

class Receptor extends FlxSprite
{
	public var data:ArrowData;
	public var parent:PlayField;

	public function new(data:ArrowData, parent:PlayField)
	{
		super();

		this.data = data;
		this.parent = parent;

		load();
		scale.scale(0.4);
		updateHitbox();
	}

	public function load()
	{
		frames = FlxAtlasFrames.fromSparrow(AssetPaths.receptors__png, AssetPaths.receptors__xml);

		var dir = Constants.ANIMATION_PER_LANE[data.lane];
		animation.addByPrefix('static', dir, 24, false);
		animation.addByPrefix('hit', 'confirm_$dir', 24, false);
		animation.addByPrefix('ghost', 'pressed_$dir', 24, false);

		animation.play('static');
		animation.finish();

		parent.playback.onBeat.add((beat) ->
		{
			animation.play('static', true);
		});

		centerOffsets();
		centerOrigin();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
