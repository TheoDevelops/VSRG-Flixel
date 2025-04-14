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

		final chart = new StepMania().fromFile(AssetPaths.Try_This__sm);

		for (note in chart.getNotes('Challenge'))
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
