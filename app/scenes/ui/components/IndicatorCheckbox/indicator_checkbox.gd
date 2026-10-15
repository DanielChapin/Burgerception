class_name IndicatorCheckbox
extends TextureRect

enum IndicatorState {
	NEUTRAL,
	POSITIVE,
	NEGATIVE,
}

@export var state: IndicatorState = IndicatorState.NEUTRAL:
	set(val):
		state = val
		_update_texture()

@export_category("Textures")
@export var neutral_texture: Texture2D = preload("res://scenes/ui/components/IndicatorCheckbox/indicator_neutral_default.tres")
@export var positive_texture: Texture2D = preload("res://scenes/ui/components/IndicatorCheckbox/indicator_positive_default.tres")
@export var negative_texture: Texture2D = preload("res://scenes/ui/components/IndicatorCheckbox/indicator_negative_default.tres")

func _ready():
	_update_texture()

func get_state_texture(_state: IndicatorState = state) -> Texture2D:
	match _state:
		IndicatorState.NEGATIVE:
			return negative_texture
		IndicatorState.POSITIVE:
			return positive_texture
		_:
			return neutral_texture

func _update_texture():
	texture = get_state_texture()
