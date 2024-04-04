extends Node

var offeringScene = preload("res://Scenes/Screens/NightShop/NightShopIngredient.tscn")

func _ready():
	var shopOfferings = PlayerData.save.currentLocation.get_shop_offerings(4)
	var hbox = $"OfferingsHBox"
	for i in shopOfferings:
		var newOffering = offeringScene.instantiate()
		newOffering.call("setData", i)
		hbox.add_child(newOffering)


