package vsrg.core.audio;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.util.FlxSignal.FlxTypedSignal;

class Playback extends FlxBasic
{
	public var offset:Float = 0;
	public var speed(default, set):Float = 0;

	function set_speed(val:Float)
	{
		return speed = Math.max(FlxMath.EPSILON, val);
	}

	public var onBeat:FlxTypedSignal<Float->Void> = new FlxTypedSignal();
	public var onStep:FlxTypedSignal<Float->Void> = new FlxTypedSignal();
	public var onMeasure:FlxTypedSignal<Float->Void> = new FlxTypedSignal();

	public var stepsPerBeat:Int = 4;
	public var beatsPerMeasure:Int = 4;
	public var bpm:Float = 120;

	public var time:Float = 0;

	public var crochet:Float = ((60 / 120) * 1000);

	public var step:Int;
	public var beat:Int;
	public var measure:Int;

	public var fStep:Float;
	public var fBeat:Float;
	public var fMeasure:Float;

	private var __lastStep:Int = -1;
	private var __lastBeat:Int = -1;
	private var __lastMeasure:Int = -1;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music == null)
			return;
		__computeTime(elapsed);

		crochet = 60 / bpm * 1000;

		fBeat = time / crochet;
		fStep = fBeat * stepsPerBeat;
		fMeasure = fBeat / beatsPerMeasure;

		step = Math.floor(fStep);
		beat = Math.floor(fBeat);
		measure = Math.floor(fMeasure);

		if (__lastStep != step)
			onStep.dispatch(step);

		if (__lastBeat != beat)
			onBeat.dispatch(beat);

		if (__lastMeasure != measure)
			onMeasure.dispatch(measure);

		__lastStep = step;
		__lastBeat = beat;
		__lastMeasure = measure;
	}

	public var rawTime(get, never):Float;

	public function get_rawTime()
		return FlxG.sound.music.time;

	private var __lastRawTime:Float = -1;
	private var __lastTime:Float = -1;

	private var __lastLatency:Float = -1;

	/**
	 * this took me forever to figure out
	 * 
	 * so basicly FlxSound.time updates every 20ms so is not smooth AT ALL and also innacurate AT ALL
	 */
	private function __computeTime(elapsed:Float)
	{
		// if the raw time was changed, fix the interpolated time
		if (__lastRawTime != rawTime)
		{
			__lastLatency = rawTime - __lastRawTime;

			time = rawTime + offset;
		}
		else
		{
			var latency = __lastRawTime - rawTime;
			time += elapsed * 1000 * (20 / __lastLatency);
		}

		__lastRawTime = rawTime;
		__lastTime = time;
	}
}
