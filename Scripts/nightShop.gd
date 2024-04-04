extends Node


func _ready():
	var shopOfferings = PlayerData.save.currentLocation.get_shop_offerings(4)
	for i in shopOfferings:
		print(i)


