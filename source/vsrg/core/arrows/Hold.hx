package vsrg.core.arrows;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteContainer;
import vsrg.core.ArrowData;
import vsrg.core.Constants;

class Hold extends FlxTypedGroup<FlxSprite>
{
	public var parent:Arrow;

	public var data:ArrowData;
	public var time:Float = 0;
	public var holdLength:Float;

	public var body:HoldFragment;
	public var tail:HoldFragment;

	private var __width:Float;

	public function new(length:Float = 0)
	{
		super();

		this.holdLength = length;

		body = new HoldFragment();
		body.frames = FlxAtlasFrames.fromSparrow(AssetPaths.arrows__png, AssetPaths.arrrows__xml);
		body.animation.addByPrefix('body', 'blue hold piece', 24, false);
		body.animation.addByPrefix('tail', 'pruple end hold', 24, false);
		body.animation.play('body');
		body.scale.scale(0.4);
		add(body);

		var fixedLength = holdLength * 0.45 * 0.1;
		body.scale.y = fixedLength / (body.frameHeight * body.scale.y);
		body.updateHitbox();

		__width = body.width;
	}

	override function update(elapsed)
	{
		super.update(elapsed);

		body.x = parent.x - body.width * .5;
		body.y = parent.y + parent.height * .5;
	}

	public function load(spr:FlxSprite, isEnd:Bool = false) {}
}

class HoldFragment extends FlxSprite
{
	override function isOnScreen(?camera:FlxCamera):Bool
	{
		return true;
	}
}
