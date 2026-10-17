extends Control

@onready var twitch = $TwitchWrapper
@onready var twitch_chat = $TwitchWrapper/TwitchChat

var status: OrderStatus:
	set(val):
		$OrderUpTicket.status = val
		status = val

func _ready():
	await twitch.setup()
	var user: TwitchUser = await twitch.get_current_user()
	print("Signed in as ", user.display_name)
	twitch_chat.broadcaster_user = user
	twitch_chat.subscribe()
	print("Subscribed to twitch chat")
	
	status = OrderStatus.new(Order.new())

func _on_user_order_received(entry: OrderEntry) -> void:
	if status:
		status.order.push_entry(entry)
	
	print("[COMMAND] %s ordered %s" % [entry.diner.user_name, Ingredient.readable_name(entry.ingredient)])

func _on_twitch_chat_message_received(message: TwitchChatMessage) -> void:
	print(message.chatter_user_name, ": ", message.message.text)
