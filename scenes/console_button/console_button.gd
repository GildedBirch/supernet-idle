class_name ConsoleButton
extends RichTextLabel


signal pressed
signal toggled_on
signal toggled_off

enum TYPE {NORMAL, TOGGLE, PAIRED}

@export var label_text: String = ""
@export var type: TYPE = TYPE.NORMAL
@export var disabled: bool = false
@export var toggled: bool = false
@export var pair: ConsoleButton


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use") and has_focus() and not disabled:
		match type:
			TYPE.TOGGLE:
				toggled = !toggled
				if toggled:
					toggled_on.emit()
					text = "[>%s<]" % label_text
				else:
					toggled_off.emit()
					text = "[ %s ]" % label_text
			TYPE.PAIRED:
				disable()
				pair.enable()
		pressed.emit()


func _ready() -> void:
	if type == TYPE.TOGGLE:
		text = "  %s  " % label_text
	else:
		text = " %s " % label_text
	if disabled:
		pass #add_theme_color_override("font_color", Colors.disabled)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	grab_focus()


func _on_focus_entered() -> void:
	print("aa")
	if type == TYPE.TOGGLE:
		if toggled:
			text = "[>%s<]" % label_text
		else:
			text = "[ %s ]" % label_text
	else:
		text = "[%s]" % label_text
	if disabled:
		pass #add_theme_color_override("font_color", Colors.disabled_highlight)
	else:
		pass #add_theme_color_override("font_color", Colors.highlight)


func _on_focus_exited() -> void:
	match type:
		TYPE.TOGGLE:
			if toggled:
				text = " >%s< " % label_text
			else:
				text = "  %s  " % label_text
		TYPE.NORMAL, TYPE.PAIRED:
			text = " %s " % label_text
	if disabled:
		pass #add_theme_color_override("font_color", Colors.disabled)
	else:
		pass #remove_theme_color_override("font_color")


func enable() -> void:
	disabled = false
	pass #remove_theme_color_override("font_color")


func disable() -> void:
	disabled = true
	pass #add_theme_color_override("font_color", Colors.disabled)
