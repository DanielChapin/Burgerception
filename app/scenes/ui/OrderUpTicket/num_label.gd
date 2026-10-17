class_name OrderUpTicketNumLabel
extends Label

@export var num: int:
	set(val):
		text = str(val)
		num = val

func _ready() -> void:
	text = str(num)
