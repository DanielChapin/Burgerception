class_name OrderUpTicket
extends Node

var rows: Array[OrderEntryRow]

@onready var order_entries_grid = %OrderEntriesGrid
@onready var scroll_container = %ScrollContainer
@onready var correct_label = %CorrectLabel
@onready var count_label = %CountLabel

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
		add_row(row)

func _set_num_correct(num: int = status.num_correct):
	correct_label.text = "Correct: %d/%d" % [num, status.ingredient_count()]

func _set_count(num: int = -1):
	if num == -1:
		num = status.ingredient_count()
	count_label.text = "Ingredient Count: %d/%d" % [num, status.order.length()]

func free_rows():
	for row in rows:
		for node in row.as_nodes():
			node.queue_free()

func add_row(row: OrderEntryRow):
	rows.append(row)
	for node in row.as_nodes():
		order_entries_grid.add_child(node)

func focus_row(index: int):
	if index >= len(rows):
		return
	
	var row = rows[index]
	var scroll_position_target = row.status_indicator.position.y
	var height = scroll_container.size.y
	var scroll = max(0, scroll_position_target - height / 2)
	scroll_container.set_deferred("scroll_vertical", scroll)

func _status_num_correct_changed(count: int, previous: int):
	# When the number of correct ingredients changes, we need to update row
	# indicators
	if count > previous:
		for i in range(previous, count):
			rows[i].set_ingredient_status(OrderStatus.IngredientStatus.CORRECT)
	elif previous > count:
		for i in range(count, previous):
			rows[i].set_ingredient_status(OrderStatus.IngredientStatus.UNSATISFIED)
	_set_num_correct()
	_set_count()

func _status_pushed_ingredient(_kind: Ingredient.Kind, correct: bool):
	# When an ingredient gets pushed, we must check if there is an existing
	# row for it and update it if it exists.
	var index = status.ingredient_count() - 1
	if index < len(rows):
		var row = rows[index]
		row.set_ingredient_status(OrderStatus.IngredientStatus.CORRECT if correct else OrderStatus.IngredientStatus.INCORRECT)
	
	if correct:
		focus_row(index + 1)

	_set_num_correct()
	_set_count()

func _status_popped_ingredient(_kind: Ingredient.Kind):
	var index = status.ingredient_count()
	if index < len(rows):
		var row = rows[index]
		row.set_ingredient_status(OrderStatus.IngredientStatus.UNSATISFIED)
	
	focus_row(index - 1)
	
	_set_num_correct()
	_set_count()

func _order_new_entry(entry: OrderEntry):
	# Push a new entry onto the order and scroll to it
	var row = OrderEntryRow.new(len(rows) + 1, entry)
	add_row(row)
	# Have to call this deferred because the row must be fully initialized
	# before it can be scrolled to. We don't need to do this anywhere else
	# because the rows are already created. This function creates the rows.
	call_deferred("focus_row", len(rows) - 1)
	
	_set_num_correct()
	_set_count()

func _order_finalized():
	# Update the colors or something IDK
	# Scroll to the current ingredient (the very first)
	focus_row(0)
