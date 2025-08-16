class_name DataProgressBar
extends ProgressBar


func _ready() -> void:
	max_value = PM.process_time
	SB.game.data_process_timer_value_changed.connect(_on_data_process_timer_value_changed)
	value = 0


func _on_data_process_timer_value_changed(new_value: float) -> void:
	value = max_value - new_value
