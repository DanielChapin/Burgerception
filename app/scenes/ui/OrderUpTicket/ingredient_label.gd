extends Label

var ingredient: Ingredient.Kind:
	set(val):
		text = Ingredient.readable_name(val)
		ingredient = val
