class_name OrderEntryRow

var number_label: OrderUpTicketNumLabel
var status_indicator: IndicatorCheckbox
var ingredient_label: Node # TODO Type?
var diner_label: ChatterLabel

const NUM_LABEL := preload("res://scenes/ui/OrderUpTicket/NumLabel.tscn")
const INDICATOR_CHECKBOX := preload("res://scenes/ui/components/IndicatorCheckbox/IndicatorCheckbox.tscn")
const INGREDIENT_LABEL := preload("res://scenes/ui/OrderUpTicket/IngredientLabel.tscn")
const DINER_LABEL := preload("res://scenes/ui/components/ChatterLabel/ChatterLabel.tscn")

func set_ingredient_status(status: OrderStatus.IngredientStatus):
	match status:
		OrderStatus.IngredientStatus.CORRECT:
			status_indicator.state = IndicatorCheckbox.IndicatorState.POSITIVE
		OrderStatus.IngredientStatus.INCORRECT:
			status_indicator.state = IndicatorCheckbox.IndicatorState.NEGATIVE
		OrderStatus.IngredientStatus.UNSATISFIED:
			status_indicator.state = IndicatorCheckbox.IndicatorState.NEUTRAL

func set_ingredient(ingredient: Ingredient.Kind):
	ingredient_label.ingredient = ingredient

func _init(index: int, order_entry: OrderEntry):
	number_label = NUM_LABEL.instantiate()
	number_label.num = index
	
	status_indicator = INDICATOR_CHECKBOX.instantiate()
	set_ingredient_status(OrderStatus.IngredientStatus.UNSATISFIED)
	
	ingredient_label = INGREDIENT_LABEL.instantiate()
	set_ingredient(order_entry.ingredient)
	
	diner_label = DINER_LABEL.instantiate() as ChatterLabel
	diner_label.chatter_name = order_entry.diner.user_name
	diner_label.chatter_color = order_entry.diner.user_color

func as_nodes() -> Array[Node]:
	return [number_label, status_indicator, ingredient_label, diner_label]
