package vsrg.internal.app;

import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * temporal memory counter
 * 
 * taken fron funkin loool
 */
class MemoryCounter extends TextField
{
	var memPeak:Float = 0;

	static final BYTES_PER_MEG:Float = 1024 * 1024;
	static final ROUND_TO:Float = 1 / 100;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;
		this.width = 500;
		this.selectable = false;
		this.mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "RAM: ";

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	public function getMemoryUsed():#if cpp Float #else Int #end
	{
		#if cpp
		// There is also Gc.MEM_INFO_RESERVED, MEM_INFO_CURRENT, and MEM_INFO_LARGE.
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
		#else
		return openfl.system.System.totalMemory;
		#end
	}

	// Event Handlers
	@:noCompletion
	#if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		var mem:Float = Math.fround(getMemoryUsed() / BYTES_PER_MEG / ROUND_TO) * ROUND_TO;

		if (mem > memPeak)
			memPeak = mem;

		text = 'RAM: ${mem}mb / ${memPeak}mb';
	}
}
