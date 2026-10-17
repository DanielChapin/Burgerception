extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var order = Order.new()
	
	var ingredients = Ingredient.Kind.values()
	for i in range(len(ingredients)):
		order.push_entry(OrderEntry.new(ingredients[i], Diner.new(0, "Diner {0}".format([i]), Color.FIREBRICK)))
	order.finalize()
	
	$OrderUpTicket.order_status = OrderStatus.new(order)
