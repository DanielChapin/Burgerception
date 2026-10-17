class_name IngredientLabel
extends Label

var ingredient: Ingredient.Kind:
	set(val):
		text = Ingredient.readable_name(val)
		ingredient = val

func make_bold(bold: bool = true):
	if bold:
		add_theme_constant_override("outline_size", 3)
		add_theme_font_size_override("font_size", int(get_theme_font_size("font_size") * 1.5))
	else:
		remove_theme_constant_override("outline_size")
		remove_theme_font_size_override("font_size")
