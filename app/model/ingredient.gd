class_name Ingredient

enum Kind {
	PATTY,
	LETTUCE,
	ONION,
	TOMATO,
	PICKLE,
	MUSTARD,
	BACON,
	SECRET_SAUCE,
	CHEESE,
	KETCHUP,
}

static func readable_name(kind: Kind) -> StringName:
	match kind:
		Kind.PATTY:
			return &"Patty"
		Kind.LETTUCE:
			return &"Lettuce"
		Kind.ONION:
			return &"Onion"
		Kind.TOMATO:
			return &"Tomato"
		Kind.PICKLE:
			return &"Pickle"
		Kind.MUSTARD:
			return &"Mustard"
		Kind.BACON:
			return &"Bacon"
		Kind.SECRET_SAUCE:
			return &"Secret Sauce"
		Kind.CHEESE:
			return &"Cheese"
		Kind.KETCHUP:
			return &"Ketchup"
		_:
			printerr("UNKNOWN Ingredient.Kind:", kind)
			return &"???"
