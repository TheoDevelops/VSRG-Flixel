package vsrg.core.arrows;

import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import vsrg.core.Constants;
import vsrg.core.format.ArrowData;
import vsrg.core.format.Chart;

class Arrow extends FlxSprite
{
	public var parent:PlayField;
	public var data:ArrowData;
	public var time:Float = 0;

	public var receptor:Receptor;

	public function new(parent:PlayField)
	{
		super();

		this.parent = parent;

		__loadTexture();
		scale.scale(0.4);
		updateHitbox();
	}

	public function load(chartData:ChartNote)
	{
		time = chartData?.time ?? 0;

		this.data = {
			lane: chartData?.lane ?? 0,
			player: chartData?.player ?? 0
		};

		receptor = parent.receptors.members[data.lane];
		animation.play(Constants.ANIMATION_PER_LANE[data.lane]);

		alpha = 1;
	}

	public function __loadTexture()
	{
		frames = FlxAtlasFrames.fromSparrow(AssetPaths.arrows__png, AssetPaths.arrows__xml);
		animation.addByPrefix('left', 'left', 24, true);
		animation.addByPrefix('right', 'right', 24, true);
		animation.addByPrefix('up', 'up', 24, true);
		animation.addByPrefix('down', 'down', 24, true);
	}
}
