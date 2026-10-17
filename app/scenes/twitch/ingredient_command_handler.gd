@tool
class_name IngredientCommandHandler
extends TwitchCommandRegex

signal _on_user_order_received(entry: OrderEntry)

func _ready():
	print(eventsub)

# TODO: This needs to use the game settings for prefixing when implemented.

func _on_command_received(_from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	var user_input := args.get(1)
	var ingredient = Ingredient.from_readable(user_input)
	
	if ingredient != null and info.original_message is TwitchChatMessage:
		var message: TwitchChatMessage = info.original_message
		var diner := Diner.new(info.user_id, message.chatter_user_name, message.color)
		var entry := OrderEntry.new(ingredient, diner)
		
		_on_user_order_received.emit(entry)
