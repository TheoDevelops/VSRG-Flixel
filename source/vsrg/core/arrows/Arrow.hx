package vsrg.core.arrows;

import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxShader;
import vsrg.core.Constants;
import vsrg.core.format.ArrowData;
import vsrg.core.format.Chart;
import vsrg.core.shaders.HueShifter;

class Arrow extends FlxSprite
{
	public var parent:PlayField;
	public var receptor:Receptor;

	public var data:ArrowData;
	public var time:Float = 0;
	public var holdTime:Float = 0;
	public var hasHold:Bool = false;
	public var endTime(get, never):Float;

	inline function get_endTime()
		return time + holdTime;

	public var hit(default, set):Bool = false;
	public var miss:Bool = false;
	public var delete:Bool = false;
	public var holding:Bool = false;

	public function set_hit(val)
	{
		if (val)
			receptor.hit = true;
		return hit = val;
	}

	public var tail:Tail;

	public function new(parent:PlayField)
	{
		super();

		this.parent = parent;

		__loadTexture();
		scale.scale(0.4);
		updateHitbox();
	}

	public function release()
	{
		receptor.hit = false;

		hit = false;
		miss = false;
		delete = false;
		hasHold = false;
		holding = false;
	}

	public function load(chartData:ChartNote)
	{
		time = chartData?.time ?? 0;
		holdTime = chartData?.holdTime ?? 0;
		hasHold = holdTime > 0;

		this.data = {
			lane: chartData?.lane ?? 0,
			player: chartData?.player ?? 0
		};

		receptor = parent.receptors.members[data.lane];
		angle = Constants.ROTATION_PER_LANE[data.lane];
		hueShifter.hue = Constants.HUE_PER_LANE[data.lane];

		if (hasHold)
		{
			if (tail == null)
				tail = new Tail();
			tail.load(this, chartData.holdTime);
			tail.visible = false;
		}

		alpha = 1;
	}

	override function draw()
	{
		if (hasHold && tail != null)
		{
			tail.draw();

			// prevent popping LOL
			tail.visible = true;
		}
		if (!holding)
			super.draw();
	}

	override function update(elapsed:Float)
	{
		if (hasHold && tail != null)
		{
			tail.update(elapsed);
		}
		super.update(elapsed);
	}

	public function __loadTexture()
	{
		frames = FlxAtlasFrames.fromSparrow(AssetPaths.arrow_texture__png, AssetPaths.arrow_texture__xml);
		animation.addByPrefix('idle', 'idle', 24, true);
		animation.play('idle');

		hueShifter = new HueShifter();
		shader = hueShifter.shader;
	}
	var hueShifter:HueShifter;
}
