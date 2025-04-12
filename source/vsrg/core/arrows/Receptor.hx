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

	public function new(data:ArrowData)
	{
		super();

		this.data = data;

		load();
		scale.scale(0.4);
		updateHitbox();
	}

	public function load()
	{
		frames = FlxAtlasFrames.fromSparrow(AssetPaths.receptors__png, AssetPaths.receptors__xml);

		var dir = Constants.ANIMATION_PER_LANE[data.lane];
		animation.addByPrefix('static', dir, 24, true);
		animation.addByPrefix('hit', 'confirm_$dir', 24, false);
		animation.addByPrefix('ghost', 'pressed_$dir', 24, false);

		animation.play('static');

		centerOffsets();
		centerOrigin();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
