extends Node


var game: GameSignals = GameSignals.new()


class GameSignals:
	## Called when octet values change.
	signal octet_increased(first: int, second: int, third: int, fourth: int)
	## Called when any of the data values change
	signal data_values_changed(max: int, unparsed: int, valued: int, junk: int)
	## Called when prestige increases
	signal prestige_increased(prestige: int)
	## Called when scrape timer runs
	signal scrape_timer_value_changed(value: float)
	signal scrape_time_changed(value: float)
	signal scrape_timer_stopped
