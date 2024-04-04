extends Node

const NUMBER_OF_ITEMS = 4

var offeringScene = preload("res://Scenes/Screens/NightShop/NightShopIngredient.tscn")

func _ready():
	var shopOfferings = PlayerData.save.currentLocation.get_shop_offerings(NUMBER_OF_ITEMS)
	var hbox = $"OfferingsHBox"
	for i in shopOfferings:
		var newOffering = offeringScene.instantiate()
		newOffering.call("setData", i)
		hbox.add_child(newOffering)
	hbox.move_child(hbox.add_spacer(true), floor(NUMBER_OF_ITEMS/2))


