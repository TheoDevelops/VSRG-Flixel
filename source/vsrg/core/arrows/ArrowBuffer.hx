package vsrg.core.arrows;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.util.FlxSort;
import haxe.ds.Vector;
import vsrg.core.audio.Playback;
import vsrg.core.format.Chart.ChartNote;

/**
 * arrow rendering component
 */
class ArrowBuffer extends FlxTypedContainer<Arrow>
{
	public var parent:PlayField;

	public var playback:Playback;
	public var generationWindow:Float = 1250;
	public var deletionWindowSize:Float = 250;

	private var _queuedArrows:Vector<ChartNote>;
	private var _queuePosition:Int = 0;

	/**
	 * yeah, pool and active arrow lists have fixed size
	 * 
	 * this prevents using push and splice, so we prevent
	 * allocations every frame
	 */
	private var _pool:Vector<Arrow>;

	private var _poolLength:Int = 0;

	private var _activeArrows:Vector<Arrow>;
	private var _activeLength:Int = 0;

	private inline static var DEFAULT_SIZE:Int = 48;
	private inline static var EXPAND_SIZE:Int = 32;

	public function new(parent:PlayField)
	{
		super();

		this.parent = parent;
		playback = parent.playback;

		_pool = new Vector<Arrow>(DEFAULT_SIZE);
		_activeArrows = new Vector<Arrow>(DEFAULT_SIZE);
	}

	public function preallocate(data:Array<ChartNote>)
	{
		_queuedArrows = new Vector<ChartNote>(data.length);

		for (i in 0...data.length)
			_queuedArrows[i] = data[i];

		_queuedArrows.sort((a, b) ->
		{
			return a.time < b.time ? -1 : 1;
		});

		#if cpp
		untyped data.length = 0;
		#else
		data.splice(0, data.length);
		#end

		data = null;

		_queuePosition = 0;
		_poolLength = 0;
		_activeLength = 0;
	}

	// lool
	private inline function ensurePoolCapacity()
	{
		if (_poolLength >= _pool.length)
		{
			var newVec = new Vector<Arrow>(_pool.length + EXPAND_SIZE);
			for (i in 0..._pool.length)
				newVec[i] = _pool[i];
			_pool = newVec;
		}
	}

	private inline function ensureActiveCapacity()
	{
		if (_activeLength >= _activeArrows.length)
		{
			var newVec = new Vector<Arrow>(_activeArrows.length + EXPAND_SIZE);
			for (i in 0..._activeArrows.length)
				newVec[i] = _activeArrows[i];
			_activeArrows = newVec;
		}
	}

	private function getArrow(data:ChartNote):Arrow
	{
		var arrow:Arrow;

		if (_poolLength > 0)
		{
			_poolLength--;
			arrow = _pool[_poolLength];
			_pool[_poolLength] = null;
		}
		else
		{
			arrow = new Arrow(parent);
		}

		arrow.exists = true;
		arrow.alive = true;
		arrow.visible = true;
		arrow.active = true;

		arrow.load(data);
		return arrow;
	}

	private function putArrow(arrow:Arrow)
	{
		arrow.exists = false;
		arrow.alive = false;
		arrow.visible = false;
		arrow.active = false;

		ensurePoolCapacity();
		_pool[_poolLength++] = arrow;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// arrow deletion
		if (_activeLength > 0)
		{
			var i = _activeLength - 1;
			while (i >= 0)
			{
				final arrow = _activeArrows[i];

				if (arrow == null)
				{
					i--;
					continue;
				}

				// endTime = time + holdLength
				if (arrow.endTime - playback.time < -deletionWindowSize)
				{
					putArrow(arrow);

					// swap delete ??
					_activeArrows[i] = _activeArrows[_activeLength - 1];
					_activeArrows[--_activeLength] = null;
				}
				else
				{
					i--;
				}
			}
		}

		// arrow generation
		if (_queuePosition < _queuedArrows.length)
		{
			while (_queuedArrows[_queuePosition].time - playback.time <= generationWindow)
			{
				var iArrowData = _queuedArrows[_queuePosition];
				var arrow = getArrow(iArrowData);

				ensureActiveCapacity();
				_activeArrows[_activeLength++] = arrow;

				_queuedArrows[_queuePosition++] = null;
				iArrowData = null;

				if (_queuePosition >= _queuedArrows.length)
					break;
			}
		}

		for (i in 0..._activeLength)
			_activeArrows[i].update(elapsed);

		// TODO: sort
	}

	override function draw()
	{
		for (i in 0..._activeLength)
			_activeArrows[i].draw();
	}

	override public inline function forEach(func:Arrow->Void, recursive:Bool = false)
	{
		for (i in 0..._activeLength)
		{
			final arrow = _activeArrows[i];
			if (arrow != null)
				func(arrow);
		}
	}
}
