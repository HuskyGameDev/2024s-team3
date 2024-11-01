extends Area2D

@export var station_id:String
@export var station_sprite : Texture2D :
	set(sprite):
		station_sprite = sprite
		if StationSprite: StationSprite.texture = station_sprite
@export var station_price : int : 
	set(price):
		station_price = price
		if StoreTag: StoreTag.price = price


@onready var StationSprite = $StationSprite
@onready var StoreTag = $StoreTag


func _on_mouse_entered_station():
	StoreTag.mouse_in_station = true


func _on_mouse_exited_station():
	StoreTag.mouse_in_station = false


func _on_buy_button_pressed():
	if PlayerData.money >= station_price:
		PlayerData.money -= station_price
		# make station show in player inventory
		PlayerData.unlocked_stations.append(station_id)
		PlayerData.save_game_files()
		#TODO make shopkeeper say something
		self.queue_free()
	else:
		#TODO make shopkeeper say this
		print("Not enough money")
	
