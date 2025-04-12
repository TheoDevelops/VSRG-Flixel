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
			});
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
			var curY = FlxG.height * 0.1 + (arrow.time - playback.time) * 0.45;

			arrow.setPosition(curX, curY);
		});
	};
}
