extends Area2D

@export var location_id:String
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
		#TODO make shopkeeper say something
		self.queue_free()
	else:
		#TODO make shopkeeper say this
		print("Not enough money")
	
