extends GutTest

func test_init():
	var order = Order.new()
	assert_eq(len(order._entries), 0, "A new order should have no entries")
	assert_false(order.final, "New order should not be final.")

func test_push_get_one():
	var order = Order.new()
	watch_signals(order)

	var entry = OrderEntry.new()
	order.push_entry(entry)

	assert_signal_emitted_with_parameters(order.pushed_entry, [entry])

	assert_eq(order.length(), 1, "There should only be one entry")
	assert_eq(order.entry(0), entry, "Same entry in the order")

	assert_false(order.final, "Never finalized order")

func test_finalize_one():
	var order = Order.new()
	watch_signals(order)

	var entry = OrderEntry.new()
	order.push_entry(entry)

	order.finalize()
	order.push_entry(OrderEntry.new())

	assert_signal_emit_count(order.pushed_entry, 1)
	assert_signal_emit_count(order.finalized, 1)
	assert_eq(order.length(), 1, "Second push should not have gone through")
	assert_true(order.final, "Order should be finalized")
	assert_eq(order.entry(0), entry, "Entry should not have changed")
