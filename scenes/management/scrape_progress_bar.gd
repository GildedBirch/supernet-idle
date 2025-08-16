class_name ScrapeProgressBar
extends ProgressBar


func _ready() -> void:
	max_value = PM.scrape_time
	SB.game.scrape_timer_value_changed.connect(_on_scrape_timer_value_changed)


func _on_scrape_timer_value_changed(new_value: float) -> void:
	value = new_value
