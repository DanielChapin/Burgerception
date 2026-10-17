extends GutTest

func test_quantity():
	assert_eq(len(Ingredient.Kind.keys()), 10, "There should be 10 ingredients")

func test_readable_names():
	for kind in Ingredient.Kind.values():
		assert_not_null(Ingredient.readable_name(kind), "All ingredients should have a readable name")

func test_conversions():
	for kind in Ingredient.Kind.values():
		var readable = Ingredient.readable_name(kind)
		var from_readable = Ingredient.from_readable(readable)
		assert_eq(kind, from_readable, "Readable conversion should match")
	
	for kind in Ingredient.Kind.values():
		var readable_caps = ("    " + Ingredient.readable_name(kind)).to_upper()
		var from_readable = Ingredient.from_readable(readable_caps)
		assert_eq(kind, from_readable, "Readable conversion is case and whitespace insensitive")
