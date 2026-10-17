extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var order = Order.new()
	
	$OrderUpTicket.order_status = OrderStatus.new(order)
	
	var ingredients = Ingredient.Kind.values()
	for i in range(len(ingredients)):
		var entry = OrderEntry.new(ingredients[i], Diner.new(0, "Diner {0}".format([i]), Color.FIREBRICK))
		print("Pushing {0} from {1}".format([Ingredient.readable_name(entry.ingredient), entry.diner.user_name]))
		order.push_entry(entry)
		await get_tree().create_timer(1.0).timeout
	
	print("DONE!")
	order.finalize()
