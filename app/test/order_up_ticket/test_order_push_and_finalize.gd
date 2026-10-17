extends Control

func _ready() -> void:
	# The only real thing to notice with this test's implementation is that
	# all of the logic is hapenning in the models. There is no code here that
	# actually updates the UI manually - all of it is done through the models.
	# TODO: Strikethrough or other formatting when correct
	# TODO: Scrolling
	# TODO: Maximum sizing with elipses to cut off long names
	var order = Order.new()
	var status = OrderStatus.new(order)
	
	$OrderUpTicket.status = status
	
	var ingredients = Ingredient.Kind.values()
	ingredients.append_array(ingredients)
	for i in range(len(ingredients)):
		var entry = OrderEntry.new(ingredients[i], Diner.new("TEST", "Diner {0}".format([i + 1]), Color.FIREBRICK))
		print("Pushing {0} from {1}".format([Ingredient.readable_name(entry.ingredient), entry.diner.user_name]))
		order.push_entry(entry)
		await get_tree().create_timer(1.0).timeout
	
	print("DONE!")
	order.finalize()
	
	await get_tree().create_timer(1.0).timeout
	
	print("Satisfying order")
	for ingredient in ingredients:
		print("Pushing {0}".format([Ingredient.readable_name(ingredient)]))
		status.push_ingredient(ingredient)
		await get_tree().create_timer(1.0).timeout
	
	print("DONE!")
	print("Completeable: ", status.completeable())
	print("Correct: ", status.currently_correct())
