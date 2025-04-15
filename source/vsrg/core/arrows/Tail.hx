package vsrg.core.arrows;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteContainer;
import flixel.math.FlxRect;

class Tail extends FlxTypedSpriteContainer<HoldFragment>
{
	public var parent:Arrow;

	public var holdLength:Float;

	public var body:HoldFragment;
	public var end:HoldFragment;

	public function new()
	{
		super();

		body = new HoldFragment();
		body.loadGraphic(AssetPaths.hold_body__png);
		add(body);

		end = new HoldFragment();
		end.loadGraphic(AssetPaths.hold_end__png);
		add(end);
	}

	var clip:Float = 0.;
	
	public function load(parent:Arrow, holdLength:Float)
	{
		this.parent = parent;
		this.holdLength = holdLength;

		body.setGraphicSize(parent.width, (0.45 * holdLength * parent.parent.scrollSpeed));
		end.setGraphicSize(parent.width, parent.height * .5);

		body.updateHitbox();
		end.updateHitbox();

		update(0);
		updateClipping(true);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		body.x = parent.x + parent.width * .5 - body.width * .5;
		body.y = parent.y + parent.height * .5;

		end.x = body.x + body.width * .5 - end.width * .5;
		end.y = body.y + body.height;
	}
	public function updateClipping(reset:Bool = false)
	{
		if (reset)
		{
			if (body.clipRect != null)
			{
				final clipping = body.clipRect;
				clipping.y = 0;
				body.clipRect = clipping;
			}
			return;
		}
		var clipping = body.clipRect == null ? new FlxRect() : body.clipRect;
		var totalHeight = body.height;
		var scale:Float = -(parent.time - parent.parent.playback.time) / holdLength;

		clipping.y = body.frameHeight * scale;
		clipping.width = body.frameWidth;
		clipping.height = body.frameHeight;

		body.clipRect = clipping;
	}
}

class HoldFragment extends FlxSprite
{
	override function set_clipRect(rect:FlxRect)
	{
		clipRect = rect;

		if (frames != null)
			frame = frames.frames[animation.frameIndex];

		return rect;
	}
}