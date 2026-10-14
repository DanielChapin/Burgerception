class_name OrderEntry

var ingredient: Ingredient.Kind
var diner: Diner

func _init(_ingredient: Ingredient.Kind, _diner: Diner) -> void:
	ingredient = _ingredient
	diner = _diner
