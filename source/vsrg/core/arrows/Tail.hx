package vsrg.core.arrows;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteContainer;
import haxe.io.Path;

class Tail extends FlxTypedSpriteContainer<FlxSprite>
{
	public var parent:Arrow;

	public var holdLength:Float;

	public var body:FlxSprite;
	public var end:FlxSprite;

	public function new()
	{
		super();

		body = new FlxSprite();
		body.loadGraphic(AssetPaths.hold_body__png);
		add(body);

		end = new FlxSprite();
		end.loadGraphic(AssetPaths.hold_end__png);
		add(end);
	}

	public function load(parent:Arrow, holdLength:Float)
	{
		this.parent = parent;
		this.holdLength = holdLength;

		body.setGraphicSize(parent.width, (0.45 * holdLength));
		end.setGraphicSize(parent.width, parent.height * .5);

		body.updateHitbox();
		end.updateHitbox();

		update(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		body.x = parent.x + parent.width * .5 - body.width * .5;
		body.y = parent.y + parent.height * .5;

		end.x = body.x + body.width * .5 - end.width * .5;
		end.y = body.y + body.height;
	}
}
