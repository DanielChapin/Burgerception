extends GutTest

func test_quantity():
	assert_eq(len(Ingredient.Kind.keys()), 10, "There should be 10 ingredients")

func test_readable_names():
	for kind in Ingredient.Kind.values():
		assert_ne(Ingredient.readable_name(kind), "???", "All ingredients should have a readable name")