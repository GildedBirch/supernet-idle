class_name DataDisplay
extends RichTextLabel



func _ready() -> void:
	SB.game.data_values_changed.connect(_on_data_values_changed)


func _on_data_values_changed(max: int, unparsed: int, valued: int, junk: int) -> void:
	clear()
	append_text("MAX: %s\nUNP: %s\nVAL: %s\nJNK: %s" % [max, unparsed, valued, junk])
