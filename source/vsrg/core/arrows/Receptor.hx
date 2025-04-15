package vsrg.core.arrows;

import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;
import vsrg.core.Constants;
import vsrg.core.format.ArrowData;
import vsrg.core.shaders.HueShifter;

class Receptor extends FlxSprite
{
	public var data:ArrowData;
	public var parent:PlayField;

	public var tick:Float = 0;
	public var glow:FlxSprite;
	public var glowProgress:Float = 0;

	public var hit(default, set):Bool = false;

	function set_hit(val)
	{
		if (val)
			glowProgress = 0.99999;
		return hit = val;
	}


	public function new(data:ArrowData, parent:PlayField)
	{
		super();

		this.data = data;
		this.parent = parent;

		// aux sprite
		glow = new FlxSprite();
		glow.loadRotatedGraphic(AssetPaths.receptor_glow__png, 4);
		glow.scale.scale(0.4);
		glow.updateHitbox();

		hueShifter = new HueShifter();
		glow.shader = hueShifter.shader;
				
		load();
		scale.scale(0.4);
		updateHitbox();
		_lastScale = scale.clone();
	}
	var hueShifter:HueShifter;

	var _lastScale:FlxPoint;
	@:allow(vsrg.core.PlayField)
	var _scaleOff(default, set):Float = 0;
	var _lerpScale:Float = 0;

	var _lastOff:Float = 0;
	var _scaleTimer:Float = 0;

	function set__scaleOff(val:Float)
	{
		if (_scaleOff != val)
		{
			_lastOff = _scaleOff;
			_scaleTimer = 1;
		}

		return _scaleOff = val;
	}

	public function load()
	{
		var dir = Constants.ANIMATION_PER_LANE[data.lane];
		loadRotatedGraphic(AssetPaths.receptor__png, 4);
		angle = Constants.ROTATION_PER_LANE[data.lane];
		glow.angle = Constants.ROTATION_PER_LANE[data.lane];
		hueShifter.hue = Constants.HUE_PER_LANE[data.lane];

		glow.alpha = 0.00001;

		parent.playback.onBeat.add((beat) ->
		{
			tick = 1;
		});

		centerOffsets();
		centerOrigin();
	}

	override function draw()
	{
		super.draw();

		glow.draw();
	}

	override function update(elapsed:Float)
	{
		if (tick > 0)
			tick -= elapsed * 2.5;
		else
			tick = 0;

		if (glowProgress > 0)
		{
			glowProgress -= elapsed * 2.5;
		}
		else
		{
			glowProgress = 0;
			hit = false;
		}

		final deltaTick = -0.1 + tick * .15;
		final mult = 1 + deltaTick;
		final off = Math.round(deltaTick * 255);
		setColorTransform(mult, mult, mult, 1, off, off, off, 0);

		// TODO: unhardcode the offset
		glow.x = this.x - this.width / 4 - 2;
		glow.y = this.y - this.height / 4 - 2;

		glow.alpha = 0.00001 + glowProgress;

		_lerpScale = FlxMath.lerp(_lastOff, _scaleOff, 1 - _scaleTimer);

		scale.set(_lastScale.x + _lerpScale, _lastScale.y + _lerpScale);
		if (glowProgress != 0)
			glow.scale.set(_lastScale.x + _lerpScale, _lastScale.y + _lerpScale);

		if (_scaleTimer > 0)
			_scaleTimer -= elapsed * 25;
		else
			_scaleTimer = 0;

		super.update(elapsed);
	}
}
