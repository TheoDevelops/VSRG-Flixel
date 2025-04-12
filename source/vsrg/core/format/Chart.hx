package vsrg.core.format;

typedef Chart =
{
	song:ChartSong,
	notes:Array<ChartNote>
}

typedef ChartSong =
{
	// internal name
	id:String,
	// display name
	name:String
}

typedef ChartNote =
{
	time:Float,
	lane:Int,
	?player:Int,
	?holdTime:Float
}
