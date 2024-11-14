extends Area2D

signal shopkeeper_speak(text:String)

@export var location_id : String :
	set(id):
		location_id = id
		if StoreTag: StoreTag.label = "Map to %s" % location_id.capitalize()
@export var map_price : int : 
	set(price):
		map_price = price
		if StoreTag: StoreTag.price = price
@export var map_color : Color :
	set(color):
		map_color = color
		if MapSprite: MapSprite.material.set_shader_parameter("to", map_color)


@onready var StoreTag = $StoreTag
@onready var MapSprite = $MapSprite


func _on_mouse_entered_map():
	StoreTag.mouse_in_station = true


func _on_mouse_exited_map():
	StoreTag.mouse_in_station = false


func _on_buy_button_pressed():
	if PlayerData.money >= map_price:
		PlayerData.money -= map_price
		# make location available
		PlayerData.unlocked_locations.append(location_id)
		PlayerData.save_game_files()
		shopkeeper_speak.emit("Thanks for your purchase!")
		self.queue_free()
	else:
		shopkeeper_speak.emit("You can't afford that")
	
