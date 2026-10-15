extends GutTest

func order_patty() -> Order:
	var order = Order.new()
	order.push_entry(OrderEntry.new(Ingredient.Kind.PATTY, null))
	order.finalize()
	return order

func order_all_ingredients() -> Order:
	var order = Order.new()
	for ingredient in Ingredient.Kind.values():
		order.push_entry(OrderEntry.new(ingredient, null))
	order.finalize()
	return order

func test_init():
	var order = Order.new()
	var order_status = OrderStatus.new(order)
	
	assert_eq(order_status.num_correct, 0, "0 ingredients are correct because there are 0 ingredients.")
	assert_true(order_status.currently_correct(), "Empty order with empty ingredients is correct.")

func test_push_correct():
	var order_status = OrderStatus.new(order_patty())
	watch_signals(order_status)
	
	var ingredient = order_status.order.entry(0).ingredient
	
	assert_true(order_status.currently_correct(), "No ingredients is vacuously correct.")
	assert_eq(order_status.expected_ingredient(), ingredient, "Expectation matches ingredient.")
	assert_false(order_status.completeable(), "Incomplete order not completeable.")
	
	order_status.push_ingredient(ingredient)
	
	assert_true(order_status.currently_correct(), "Order is correct up to index 0.")
	assert_true(order_status.completeable(), "Order is fullfilled.")
	assert_signal_emitted_with_parameters(order_status.num_correct_changed, [1, 0], -1, "Num correct should have incremeneted.")
	assert_signal_emitted_with_parameters(order_status.pushed_ingredient, [ingredient, true], -1, "Ingredient should have been pushed and been correct.")

func test_push_all_ingredients():
	var order_status = OrderStatus.new(order_all_ingredients())
	watch_signals(order_status)
	
	for i in range(order_status.order.length()):
		var ingredient = order_status.expected_ingredient()
		assert_not_null(ingredient, "Ingredient exists until done.")
		assert_false(order_status.completeable(), "Order not completeable until complete.")
		
		order_status.push_ingredient(ingredient)
		
		assert_true(order_status.currently_correct(), "Pushing correct ingredient is correct.")
		assert_eq(order_status.num_correct, i + 1, "Pushing correct ingredient makes num_correct increment.")
		assert_signal_emitted_with_parameters(order_status.num_correct_changed, [i + 1, i], -1, "num_correct increments.")
		assert_signal_emitted_with_parameters(order_status.pushed_ingredient, [ingredient, true], -1, "Pushed ingredient matches and was correct.")
	
	assert_true(order_status.completeable(), "Order completeable after all ingredients pushed.")
	assert_null(order_status.expected_ingredient(), "No more ingredients are expected.")

func test_push_empty_incorrect_then_pop():
	var order_status = OrderStatus.new(Order.new())
	watch_signals(order_status)
	
	order_status.push_ingredient(Ingredient.Kind.LETTUCE)
	
	assert_false(order_status.completeable(), "Incorrect order may not be completed.")
	assert_eq(order_status.num_correct, 0, "No ingredients are correct.")
	assert_signal_emitted_with_parameters(order_status.pushed_ingredient, [Ingredient.Kind.LETTUCE, false], -1, "Ingredient matches but is incorrect.")
	
	order_status.pop()
	
	assert_true(order_status.completeable(), "Fixed incorrect ingredient.")
	assert_eq(order_status.num_correct, 0, "No ingredients to be correct.")
	assert_signal_emitted_with_parameters(order_status.popped_ingredient, [Ingredient.Kind.LETTUCE], -1, "Popped off ingredient.")
	assert_signal_not_emitted(order_status.num_correct_changed, "", "Number of correct ingredients never changed.")
