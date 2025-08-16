class_name OctetDisplay
extends RichTextLabel


func _ready() -> void:
	SB.game.octet_increased.connect(_on_octet_increased)


func _on_octet_increased(first: int, second: int, third: int, fourth: int) -> void:
	clear()
	append_text("%s.%s.%s.%s FW: %s" % [first, second, third, fourth, PM.firewall_strength])
