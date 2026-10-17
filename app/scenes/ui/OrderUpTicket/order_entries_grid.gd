class_name OrderEntriesGrid
extends GridContainer

var rows: Array[OrderEntryRow]

var status: OrderStatus:
	set(val):
		if status != null:
			status.num_correct_changed.disconnect(_status_num_correct_changed)
			status.pushed_ingredient.disconnect(_status_pushed_ingredient)
			status.popped_ingredient.disconnect(_status_popped_ingredient)
			status.order.pushed_entry.disconnect(_order_new_entry)
			status.order.finalized.disconnect(_order_finalized)
		if val != null:
			val.num_correct_changed.connect(_status_num_correct_changed)
			val.pushed_ingredient.connect(_status_pushed_ingredient)
			val.popped_ingredient.connect(_status_popped_ingredient)
			val.order.pushed_entry.connect(_order_new_entry)
			val.order.finalized.connect(_order_finalized)
			init_rows(val.order)
		status = val

# TODO: Animations

func init_rows(order: Order):
	free_rows()
	rows.clear()
	
	for i in range(order.length()):
		var row = OrderEntryRow.new(i + 1, order.entry(i))
		rows.push_back(row)
		for child in row.as_nodes():
			add_child(child)

func free_rows():
	for row in rows:
		for node in row.as_nodes():
			node.queue_free()

func add_row(row: OrderEntryRow):
	rows.append(row)
	for node in row.as_nodes():
		add_child(node)

func _status_num_correct_changed(count: int, previous: int):
	# When the number of correct ingredients changes, we need to update row
	# indicators
	for i in range(previous, count):
		rows[i].set_ingredient_status(OrderStatus.IngredientStatus.CORRECT)

func _status_pushed_ingredient(kind: Ingredient.Kind, correct: bool):
	pass

func _status_popped_ingredient(kind: Ingredient.Kind):
	pass

func _order_new_entry(entry: OrderEntry):
	# Push a new entry onto the order and scroll to it
	var row = OrderEntryRow.new(len(rows) + 1, entry)
	add_row(row)

func _order_finalized():
	# Update the colors or something IDK
	# Scroll to the current ingredient (the very first)
	pass
