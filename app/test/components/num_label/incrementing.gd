extends Control

func _on_timer_timeout() -> void:
	$VBoxContainer/HBoxContainer/NumLabel.num += 1
