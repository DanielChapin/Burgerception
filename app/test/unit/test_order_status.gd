extends GutTest

func order_patty() -> Order:
	var order = Order.new()
	order.push_entry(OrderEntry.new(Ingredient.Kind.PATTY, null))
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
