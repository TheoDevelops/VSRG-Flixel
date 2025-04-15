package vsrg.core;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSignal.FlxTypedSignal;
import vsrg.core.arrows.*;
import vsrg.core.arrows.ArrowBuffer;
import vsrg.core.audio.Playback;
import vsrg.core.chart.ChartLoader;
import vsrg.core.format.Chart;

class PlayField extends FlxTypedContainer<FlxBasic>
{
	public var onArrowMiss:FlxTypedSignal<Arrow->Void>;
	public var onArrowHit:FlxTypedSignal<Arrow->Void>;
	public var onArrowDelete:FlxTypedSignal<Arrow->Void>;
	public var onArrowSpawn:FlxTypedSignal<Arrow->Void>;

	public var receptors:FlxTypedGroup<Receptor>;
	public var arrows:ArrowBuffer;

	public var playback:Playback;

	public var chart:Chart;
	public var scrollSpeed:Float = 1.2;

	public var cpu:Bool = true;

	public function new(playback:Playback)
	{
		super();

		this.playback = playback;

		receptors = new FlxTypedGroup<Receptor>();
		arrows = new ArrowBuffer(this);

		// setup receptors
		for (i in 0...4)
		{
			var receptor = new Receptor({
				lane: i,
				player: 0
			}, this);
			receptors.add(receptor);
		}

		add(receptors);
		add(arrows);
	}

	public function load(file:String)
	{
		chart = ChartLoader.loadChart(file);
		arrows.preallocate(chart.notes);

		onArrowHit = new FlxTypedSignal<Arrow->Void>();
		onArrowMiss = new FlxTypedSignal<Arrow->Void>();
		onArrowDelete = new FlxTypedSignal<Arrow->Void>();
		onArrowSpawn = new FlxTypedSignal<Arrow->Void>();
	}

	override function update(elapsed:Float)
	{
		final activeArrows = arrows._activeArrows;
		final validations = [false, false, false, false];
		// update arrow input
		var helds = [
			FlxG.keys.checkStatus(D, PRESSED),
			FlxG.keys.checkStatus(F, PRESSED),
			FlxG.keys.checkStatus(J, PRESSED),
			FlxG.keys.checkStatus(K, PRESSED)
		];
		var taps = [
			FlxG.keys.checkStatus(D, JUST_PRESSED),
			FlxG.keys.checkStatus(F, JUST_PRESSED),
			FlxG.keys.checkStatus(J, JUST_PRESSED),
			FlxG.keys.checkStatus(K, JUST_PRESSED)
		];

		if (cpu)
		{
			taps = [true, true, true, true];
			helds = [false, false, false, false];
		}

		final arrowsHeld = [false, false, false, false];

		if (helds.contains(true) || taps.contains(true))
		{
			for (i in 0...arrows._activeLength)
			{
				if (!validations.contains(false))
					break;
				final arrow = activeArrows[i];

				final lane = arrow.data.lane;

				// update hold logic
				if (arrow.holding)
				{
					final held = cpu || helds[lane];
					if (!held)
					{
						arrow.holding = false;
						onArrowMiss.dispatch(arrow);
					}
					else
					{
						arrow.tail.updateClipping();
						arrow.hit = true;
						arrowsHeld[lane] = true;

						if (cpu)
							helds[lane] = true;
					}
				}

				// prevent multiple hits at the same lane at the same frame
				if (validations[lane])
					continue;
				final distance = arrow.time - playback.time;
				final insideWindow = cpu ? distance <= 0 : (distance <= Constants.VALID_HIT_WINDOW * Constants.EARLY_WINDOW_MULT)
					|| (-distance >= Constants.VALID_HIT_WINDOW * -Constants.LATE_WINDOW_MULT);

				// arrow was hit
				if (insideWindow && taps[lane] && !arrow.hit)
				{
					onArrowHit.dispatch(arrow);

					arrow.hit = true;

					if (!arrow.hasHold)
						arrow.delete = true;
					else
						arrow.holding = true;

					if (cpu)
						helds[lane] = true;

					validations[lane] = true;
				}
			}
		}
		for (i in 0...validations.length)
			receptors.members[i]._scaleOff = helds[i] ? (arrowsHeld[i] ? 0.015 : -0.025) : 0;

		super.update(elapsed);

		// update arrow positioning
		receptors.forEach(receptor ->
		{
			var curX = FlxG.width / 2 + (-2 + receptor.data.lane) * receptor.width;
			var curY = FlxG.height * 0.1;

			receptor.setPosition(curX, curY);
		});

		arrows.forEach(arrow ->
		{
			var curX = FlxG.width / 2 + (-2 + arrow.data.lane) * arrow.width;
			var curY = FlxG.height * 0.1 + (arrow.time - playback.time) * 0.45 * scrollSpeed;

			arrow.setPosition(curX, curY);
		});
	};
}
