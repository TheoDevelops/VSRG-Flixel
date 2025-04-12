package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import vsrg.internal.app.MemoryCounter;

class Main extends Sprite
{
	var game:FlxGame;

	public function new()
	{
		super();
		addChild(game = new FlxGame(0, 0, PlayState, 144, 144, true));

		game.addChild(new FPS(10, 10, 0xFFFFFFFF));
		game.addChild(new MemoryCounter(10, 25, 0xFFFFFFFF));
	}
}
