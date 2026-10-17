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

const READABLE_NAME: Dictionary[Kind, String] = {
	Kind.PATTY: &"Patty",
	Kind.LETTUCE: &"Lettuce",
	Kind.ONION: &"Onion",
	Kind.TOMATO: &"Tomato",
	Kind.PICKLE: &"Pickle",
	Kind.MUSTARD: &"Mustard",
	Kind.BACON: &"Bacon",
	Kind.SECRET_SAUCE: &"Secret Sauce",
	Kind.CHEESE: &"Cheese",
	Kind.KETCHUP: &"Ketchup",
}

static func make_readable_key(val: String) -> String:
	return val.remove_chars(" \t").to_lower()

static var FROM_READABLE_NAME: Dictionary = (func():
	var inv = {}
	for kind in READABLE_NAME.keys():
		var name = READABLE_NAME[kind]
		var name_simpl = make_readable_key(name)
		inv[name_simpl] = kind
	return inv
	).call()

static func readable_name(kind: Kind) -> StringName:
	return READABLE_NAME.get(kind)

static func from_readable(val: String) -> Variant:
	return FROM_READABLE_NAME.get(make_readable_key(val))
