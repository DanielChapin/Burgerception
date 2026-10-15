class_name OrderStatus
extends RefCounted

var order: Order
var current_ingredients: Array[Ingredient.Kind]
# Note that the number of correct ingredients indicates the number
# of consecutive ingredients from the start of the current order that match
# the current ingredients.
# For example, if the very first ingredient is wrong, then all of the
# ingredients afterwards could be correct and num_correct would equal 0.
var num_correct: int:
	set(val):
		assert(val >= 0)
		var old = num_correct
		num_correct = val
		num_correct_changed.emit(val, old)

enum IngredientStatus {
	CORRECT,     # Ingredient is there and it matches
	INCORRECT,   # Ingredient is there but it doesn't match
	UNSATISFIED, # Nothing where the ingredient should be
}

# These signals are listed in order of decreasing precedence.
signal popped_ingredient(kind: Ingredient.Kind)
signal pushed_ingredient(kind: Ingredient.Kind, correct: bool)
signal num_correct_changed(updated: int, previous: int)

func _init(_order: Order) -> void:
	order = _order
	current_ingredients = []
	num_correct = 0

# O(1) operation as the count is updated as ingredients are pushed and popped.
func currently_correct() -> bool:
	return num_correct == len(current_ingredients)

func completeable() -> bool:
	return len(current_ingredients) == order.length() and currently_correct()

func ingredient_status(index: int) -> IngredientStatus:
	if index >= len(current_ingredients):
		return IngredientStatus.UNSATISFIED
	
	return IngredientStatus.CORRECT if current_ingredients.get(index) == expected_ingredient(index) else IngredientStatus.INCORRECT

func expected_ingredient(index: int = -1) -> Variant:
	if index == -1:
		index = num_correct
	
	if index >= order.length():
		return null
	
	return order.entry(index).ingredient

func push_ingredient(kind: Ingredient.Kind):
	# The newly added ingredient is correct only in one situation:
	# - All of the ingredients up to this point are correct
	# - and the new ingredient matches the expected one
	var expected = expected_ingredient()
	var correct = currently_correct() and kind == expected
	
	current_ingredients.push_back(kind)
	pushed_ingredient.emit(kind, correct)
	if correct:
		num_correct += 1

func pop_n(n: int):
	for _i in range(n):
		pop()

func pop():
	if current_ingredients.is_empty():
		return
	
	var ingredient = current_ingredients.pop_back()
	popped_ingredient.emit(ingredient)
	
	# Update num_correct
	# Popping the top ingredient can only make the number of correct ones go
	# down, but only in the case that the ingredient was within the range of
	# previously correct ingredients. If it was beyond that range then nothing
	# changes.
	var index = len(current_ingredients)
	if index < num_correct:
		num_correct -= 1
