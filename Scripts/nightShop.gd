extends Node

const NUMBER_OF_ITEMS = 4

var offeringScene = preload("res://Scenes/Screens/NightShop/NightShopIngredient.tscn")
var totalCostLabel:Label

var totalCost = 0;

func _ready():
	var shopOfferings = PlayerData.save.currentLocation.get_shop_offerings(NUMBER_OF_ITEMS)
	totalCostLabel = $"TotalInfoVBox/TotalCostLabel"
	var hbox = $"OfferingsHBox"
	for i in shopOfferings:
		var newOffering = offeringScene.instantiate()
		newOffering.call("setData", i)
		hbox.add_child(newOffering)
		newOffering.add_to_group("ingredientsForSale")
		newOffering.totalChanged.connect(_updateTotal)
	hbox.move_child(hbox.add_spacer(true), floor(NUMBER_OF_ITEMS/2))


func _updateTotal(changeAmount:int):
	totalCost += changeAmount
	totalCostLabel.text = "Total $" + str(totalCost)
	

func _on_buy_button_pressed():
	if PlayerData.save.money >= totalCost:
		get_tree().call_group("ingredientsForSale", "handlePurchase")
		PlayerData.save.money -= totalCost
		get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")
	else:
		print("Not enough money")
