package vsrg.core.chart;

import moonchart.formats.BasicFormat.FormatDifficulty;
import moonchart.formats.BasicFormat;
import moonchart.formats.StepMania;
import moonchart.formats.fnf.FNFCodename;
import openfl.Assets;
import vsrg.core.format.Chart;

class ChartLoader
{
	// dont hate me this is temporal lol
	public static function loadChart(file:String):Chart
	{
		final parsedChart:Chart = {
			song: {
				id: "try_this",
				name: "Try This - Pegboard Nerds"
			},
			notes: []
		};
		// arrow performance test
		/*
			for (i in 0...Std.int(20000 / 5))
			{
				for (j in 0...4)
				{
					parsedChart.notes.push({
						lane: j,
						time: i * 5
					});
				}
			}
			return parsedChart; */

		final chart = new StepMania().fromFile(AssetPaths.KICK_BACK__sm);

		for (note in chart.getNotes('Hard'))
		{
			parsedChart.notes.push({
				lane: note.lane,
				time: note.time,
				holdTime: note.length
			});
		}
		return parsedChart;
	}
}
