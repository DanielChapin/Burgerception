class_name ChatterLabel
extends Label

@export var chatter_name: String:
	set(val):
		text = val
		chatter_name = val

@export var chatter_color: Color:
	set(val):
		label_settings.font_color = val
		chatter_color = val

func _ready() -> void:
	text = chatter_name
	label_settings.font_color = chatter_color
