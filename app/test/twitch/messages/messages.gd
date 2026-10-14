extends Control

@onready var twitch = $TwitchWrapper
@onready var twitch_chat = $TwitchWrapper/TwitchChat
@onready var chat_grid = $ScrollContainer/GridContainer
@onready var auth = $TwitchWrapper/TwitchAuth

func _ready() -> void:
	await twitch.setup()
	var user: TwitchUser = await twitch.get_current_user()
	print("Signed in as ", user.display_name)
	twitch_chat.broadcaster_user = user
	twitch_chat.subscribe()
	print("Subscribed to twitch chat")

func _on_twitch_chat_message_received(message: TwitchChatMessage) -> void:
	print(message.chatter_user_name, ": ", message.message.text)
	
	var user_label = Label.new()
	user_label.text = message.chatter_user_name
	user_label.label_settings = LabelSettings.new()
	user_label.label_settings.font_color = message.get_color()
	chat_grid.add_child(user_label)
	
	var message_label = Label.new()
	message_label.text = message.message.text
	chat_grid.add_child(message_label)
